-----------------------------------------------------------------------
-- MODULE        : x_trim_streamout
-- 
-- DESCRIPTION   : 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity x_trim_streamout is
  generic (
    NUMB_LINE_BUFFER    : integer range 2 to 4 := 2;
    CMD_FIFO_DATA_WIDTH : integer;
    BUFFER_ADDR_WIDTH   : integer
    );
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    bclk       : in std_logic;
    bclk_reset : in std_logic;

    ---------------------------------------------------------------------------
    -- Registerfile field
    ---------------------------------------------------------------------------
    bclk_pixel_width : in  std_logic_vector(2 downto 0);
    bclk_x_reverse   : in  std_logic;
    bclk_buffer_rdy  : in  std_logic;
    bclk_full        : out std_logic;

    ---------------------------------------------------------------------------
    -- Command FiFo
    ---------------------------------------------------------------------------
    bclk_cmd_empty : in  std_logic;
    bclk_cmd_ren   : out std_logic;
    bclk_cmd_data  : in  std_logic_vector(CMD_FIFO_DATA_WIDTH-1 downto 0);

    ---------------------------------------------------------------------------
    -- Line buffer
    ---------------------------------------------------------------------------
    bclk_read_en      : out std_logic;
    bclk_read_address : out std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
    bclk_read_data    : in  std_logic_vector(63 downto 0);

    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    bclk_tready : in  std_logic;
    bclk_tvalid : out std_logic;
    bclk_tuser  : out std_logic_vector(3 downto 0);
    bclk_tlast  : out std_logic;
    bclk_tdata  : out std_logic_vector(63 downto 0)
    );
end;


architecture rtl of x_trim_streamout is


  attribute mark_debug : string;
  attribute keep       : string;

  component mtx_resync is
    port
      (
        aClk  : in  std_logic;
        aClr  : in  std_logic;
        aDin  : in  std_logic;
        bclk  : in  std_logic;
        bclr  : in  std_logic;
        bDout : out std_logic;
        bRise : out std_logic;
        bFall : out std_logic
        );
  end component;


  component dualPortRamVar is
    generic
      (
        DATAWIDTH : integer := 32;
        ADDRWIDTH : integer := 12
        );
    port
      (
        data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        rdclock   : in  std_logic;
        rden      : in  std_logic := '1';
        wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        wrclock   : in  std_logic := '1';
        wren      : in  std_logic := '0';
        q         : out std_logic_vector (DATAWIDTH-1 downto 0)
        );
  end component;

  component mtxDCFIFO is
    generic
      (
        DATAWIDTH : natural := 32;
        ADDRWIDTH : natural := 12
        );
    port
      (
        -- Asynchronous reset
        aClr   : in  std_logic;
        -- Write port I/F (wClk)
        wClk   : in  std_logic;
        wEn    : in  std_logic;
        wData  : in  std_logic_vector (DATAWIDTH-1 downto 0);
        wFull  : out std_logic;
        -- Read port I/F (rClk)
        rClk   : in  std_logic;
        rEn    : in  std_logic;
        rData  : out std_logic_vector (DATAWIDTH-1 downto 0);
        rEmpty : out std_logic
        );
  end component;

  type OUTPUT_FSM_TYPE is (S_IDLE, S_INIT, S_READ_CMD, S_READ_DATA, S_SOF, S_SOL, S_READ, S_EOL, S_EOF, S_DONE);

  constant WORD_PTR_WIDTH      : integer := 2+9;
  constant BUFF_PTR_WIDTH      : integer := 1;
  constant BUFFER_DATA_WIDTH   : integer := 64;
  constant CMD_FIFO_ADDR_WIDTH : integer := 1;

  -----------------------------------------------------------------------------
  -- BCLK clock domain
  -----------------------------------------------------------------------------
  signal bclk_state          : OUTPUT_FSM_TYPE;
  signal bclk_row_cntr       : integer;
  signal bclk_used_buffer    : unsigned(BUFF_PTR_WIDTH downto 0);
  signal bclk_transfer_done  : std_logic;
  signal bclk_last_read_data : std_logic;
  signal bclk_cmd_sync       : std_logic_vector(1 downto 0);
  signal bclk_cmd_size       : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cmd_buff_ptr   : unsigned(BUFF_PTR_WIDTH-1 downto 0);
  signal bclk_cmd_last_ben   : std_logic_vector(7 downto 0);
  signal bclk_read_en_int    : std_logic;

  signal bclk_word_cntr          : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_word_cntr_treshold : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_ack                : std_logic;
  signal bclk_tvalid_int         : std_logic;

  signal bclk_read_data_valid         : std_logic;
  signal bclk_align_packer            : std_logic_vector(127 downto 0);
  signal bclk_align_packer_valid_vect : std_logic_vector(1 downto 0);
  signal bclk_align_mux_sel           : std_logic_vector(2 downto 0);
  signal bclk_align_mux               : std_logic_vector(63 downto 0);
  signal bclk_align_data              : std_logic_vector(63 downto 0);
  signal bclk_align_packer_valid      : std_logic;

  signal bclk_align_packer_user : std_logic_vector(3 downto 0);
  signal bclk_align_user        : std_logic_vector(3 downto 0);


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin


  bclk_read_en <= bclk_read_en_int;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_used_buffer
  -- Description : Count the number of buffer used in the line buffer. We rely
  --               on this counter to determine if the line buffer is full or
  --               not.
  -----------------------------------------------------------------------------
  P_bclk_used_buffer : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_used_buffer <= (others => '0');
      else
        -- Initialize the buffer after the EOF transmitted
        if (bclk_state = S_DONE) then
          bclk_used_buffer <= (others => '0');
        -- A new line buffer is ready and no simultaneous transfer completed
        -- so we increment the count  
        elsif (bclk_buffer_rdy = '1' and bclk_transfer_done = '0') then
          bclk_used_buffer <= bclk_used_buffer+1;
        -- Transfer of a row completed.  
        elsif (bclk_buffer_rdy = '0' and bclk_transfer_done = '1') then
          bclk_used_buffer <= bclk_used_buffer-1;
        -- A new row filled the buffer simultaneously as a transfer
        -- completed (+1 -1) so no increment.  
        else
          bclk_used_buffer <= bclk_used_buffer;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Flag used to indicate the line buffer is full. It also propagates back
  -- pressure in the aclk domain.
  -----------------------------------------------------------------------------
  bclk_full <= '1' when (bclk_used_buffer = to_unsigned(NUMB_LINE_BUFFER, bclk_used_buffer'length)) else
               '0';


  -----------------------------------------------------------------------------
  -- Line buffer read enable. This flag is used to request the databeat located
  -- @bclk_read_address from the line buffer.
  -----------------------------------------------------------------------------
  bclk_read_en_int <= '1' when (bclk_state = S_READ_DATA and bclk_ack = '1') else
                      '0';


  -----------------------------------------------------------------------------
  -- Flag used to indicate the current row transfer is completed. When asserted
  -- this flag decrements bclk_used_buffer counter.
  -----------------------------------------------------------------------------
  bclk_transfer_done <= '1' when (bclk_state = S_EOL) else
                        '1' when (bclk_state = S_EOF) else
                        '0';


  -----------------------------------------------------------------------------
  -- Flag used to retrieve the next transfer command from the command buffer. 
  -----------------------------------------------------------------------------
  bclk_cmd_ren <= '1' when (bclk_state = S_READ_CMD) else
                  '0';


  -----------------------------------------------------------------------------
  -- Remapping the current command fields
  -----------------------------------------------------------------------------
  bclk_cmd_last_ben <= bclk_cmd_data(21 downto 14);
  bclk_cmd_sync     <= bclk_cmd_data(13 downto 12);
  bclk_cmd_buff_ptr <= unsigned(bclk_cmd_data(11 downto 11));
  bclk_cmd_size     <= unsigned(bclk_cmd_data(10 downto 0));


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_last_read_data
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_last_read_data : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_last_read_data <= '0';
      else
        bclk_last_read_data <= bclk_transfer_done;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_word_cntr_treshold
  -- Description : Treshold value used to switch bclk_state from S_READ_DATA to
  --               S_EOF/EOF (transfer almost completed).
  -----------------------------------------------------------------------------
  P_bclk_word_cntr_treshold : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_word_cntr_treshold <= (others => '0');
      else
        -- Initialize the counter treshold value right after a new command was
        -- retrieved.
        if (bclk_state = S_INIT) then
          if (bclk_x_reverse = '1') then
            -- In reverse we count down to 0
            bclk_word_cntr_treshold <= to_unsigned(0, bclk_word_cntr_treshold'length);
          else
            -- In forward addressing we count upto bclk_cmd_size-1
            bclk_word_cntr_treshold <= bclk_cmd_size-1;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_word_cntr
  -- Description : Count the data beat (word) transfered. Hence it serves as 
  -- the word pointer in the line buffer. That is why this counter can 
  -- increment or decrement. In forward mode the counter increment and in 
  -- reverse mode, it decrements. 
  -----------------------------------------------------------------------------
  P_bclk_word_cntr : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_word_cntr <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Initialize the counter
        -----------------------------------------------------------------------
        if (bclk_state = S_INIT) then
          -- In reverse mode we initialize at the maximum value
          if (bclk_x_reverse = '1') then
            bclk_word_cntr <= bclk_cmd_size-1;
          -- In forward mode we initialize at 0
          else
            bclk_word_cntr <= (others => '0');
          end if;

        -----------------------------------------------------------------------
        -- Each time we read a databeat from the line buffer we increment the
        -- counter
        -----------------------------------------------------------------------
        elsif (bclk_read_en_int = '1') then
          -- Reverse mode: decrement address
          if (bclk_x_reverse = '1') then
            bclk_word_cntr <= bclk_word_cntr - 1;
          -- Forward mode: increment address
          else
            bclk_word_cntr <= bclk_word_cntr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- The line buffer data read address is the concatenation of the current
  -- line buffer pointer and the word pointer counter.
  -----------------------------------------------------------------------------
  bclk_read_address <= std_logic_vector(bclk_cmd_buff_ptr & bclk_word_cntr);


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_state
  -- Description : Line buffer read side finite state machine (FSM)
  -----------------------------------------------------------------------------
  P_bclk_state : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_state <= S_IDLE;
      else
        case bclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            -- When a new transfer command is available
            if (bclk_cmd_empty = '0') then
              bclk_state <= S_READ_CMD;
            else
              bclk_state <= S_IDLE;
            end if;

          -------------------------------------------------------------------
          -- S_READ_CMD : Read a transfer command from the command FiFo
          -------------------------------------------------------------------
          when S_READ_CMD =>
            bclk_state <= S_INIT;

          -------------------------------------------------------------------
          -- S_INIT : initialize misc logic before a new row transfer
          -------------------------------------------------------------------
          when S_INIT =>
            bclk_state <= S_READ_DATA;
            -- Corner case only one data beat in th edata fifo
            -- if (bclk_cmd_size = "000000001") then
            --   if (bclk_cmd_sync(1) = '1') then
            --     bclk_state <= S_EOF;
            --   else
            --     bclk_state <= S_EOL;
            --   end if;
            -- else
            --   bclk_state <= S_READ_DATA;
            -- end if;

          -------------------------------------------------------------------
          --  S_READ_DATA : While in this state, we read the line buffer data
          --  of the current row until we reach bclk_word_cntr_treshold.
          --  Depending if we are on the last row of the frame, we jump to
          --  S_EOF in all other cases we jump to S_EOL.
          -------------------------------------------------------------------
          when S_READ_DATA =>
            if (bclk_ack = '1') then
              if (bclk_word_cntr = bclk_word_cntr_treshold) then
                if (bclk_cmd_sync(1) = '1') then
                  bclk_state <= S_EOF;
                else
                  bclk_state <= S_EOL;
                end if;
              end if;
            else
              bclk_state <= S_READ_DATA;
            end if;


          -------------------------------------------------------------------
          -- S_EOF : Indicates the transfer of the last data of the last row of
          -- the current frame transfered.
          -------------------------------------------------------------------
          when S_EOF =>
            if (bclk_ack = '1') then
              bclk_state <= S_DONE;
            else
              bclk_state <= S_EOF;
            end if;

          -------------------------------------------------------------------
          -- S_EOL : Indicates the transfer of the last data of any row of the
          -- current frame that is not the last row.
          -------------------------------------------------------------------
          when S_EOL =>
            if (bclk_ack = '1') then
              bclk_state <= S_IDLE;
            else
              bclk_state <= S_EOL;
            end if;

          -------------------------------------------------------------------
          -- S_DONE : Indicates the current frame is transfer, we can switch
          -- line buffer.
          -------------------------------------------------------------------
          when S_DONE =>
            bclk_state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_bclk_state;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_read_data_valid
  -- Description : Flag used to indicate that a data valid is available on the
  --               pipeline bclk_read_data (Output of the line buffer ram
  --               block).
  ---------------------------------------------------------------------------
  P_bclk_read_data_valid : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_read_data_valid <= '0';
      else
        if (bclk_ack = '1') then
          if (bclk_read_en_int = '1') then
            bclk_read_data_valid <= '1';
          else
            bclk_read_data_valid <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer
  -- Description : Data align packer. This is a 2 word wide shift left
  --               pipeline.This is required when the first valid byte of a row
  --               is not align on byte 0 of the row (stream). This is can be
  --               the case in line reversal if the lenght of a row in byte is
  --               not a multiple of 8 bytes (i.e. a Word).
  ---------------------------------------------------------------------------
  P_bclk_align_packer : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer <= (others => '0');
      else
        if (bclk_ack = '1') then
          -- If data valid in the previous pipeline we load it in the low word
          -- of the packer
          if (bclk_read_data_valid = '1') then
            bclk_align_packer(63 downto 0) <= bclk_read_data;

          -- If no data valid in the previous pipeline but the pipeline move
          -- forward we store all_0. We could simply keep the current value but
          -- easier to debug. If we lack ressources, we could optimize the
          -- following elsif statement.
          elsif (bclk_align_packer_valid_vect /= "00") then
            bclk_align_packer(63 downto 0) <= (others => '0');
          end if;

          -- The high word of the packer is always assigned by the shift left
          -- of the low word.
          bclk_align_packer(127 downto 64) <= bclk_align_packer(63 downto 0);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer_valid_vect
  -- Description : Flag used to indicate that a data valid is available on the
  --               pipeline bclk_align_packer
  -----------------------------------------------------------------------------
  P_bclk_align_packer_valid_vect : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer_valid_vect <= (others => '0');
      else
        if (bclk_ack = '1') then
          bclk_align_packer_valid_vect(0) <= bclk_read_data_valid;
          bclk_align_packer_valid_vect(1) <= bclk_align_packer_valid_vect(0);
        end if;
      end if;
    end if;
  end process;

  -- Remapping of bclk_align_packer_valid (makes code simpler)
  bclk_align_packer_valid <= bclk_align_packer_valid_vect(1);

  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer_user
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_packer_user : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer_user <= (others => '0');
      else
        if (bclk_ack = '1') then
          -----------------------------------------------------------------------
          -- User sync in reverse packing
          -----------------------------------------------------------------------
          -- Start of line
          if (bclk_align_packer_valid_vect = "01") then
            bclk_align_packer_user(2) <= '1';
            -- Start of frame
            if (bclk_cmd_sync = "01") then
              bclk_align_packer_user(0) <= '1';
            end if;

            -- Corner case (SOL and EOL in same databeat i.e. line only 1 databeat)
            if (bclk_last_read_data = '1') then
              bclk_align_packer_user(3) <= '1';
              -- End of Frame
              if (bclk_cmd_sync = "10") then
                bclk_align_packer_user(1) <= '1';
              end if;
            end if;

          -- End of line
          elsif (bclk_last_read_data = '1') then
            bclk_align_packer_user(3) <= '1';
            -- End of Frame
            if (bclk_cmd_sync = "10") then
              bclk_align_packer_user(1) <= '1';
            end if;
          else
            bclk_align_packer_user <= "0000";
          end if;
        end if;
      end if;
    end if;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_align_mux_sel
  -- Description : Mux alignment selector. This process calculates the 
  --               alignment of the first valid byte of the current row.
  ---------------------------------------------------------------------------
  P_bclk_align_mux_sel : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_mux_sel <= (others => '0');
      else
        if (bclk_state = S_INIT) then
          ---------------------------------------------------------------------
          -- In reverse mode the alignment is determine using the byte enable
          -- of the last word of the row stored in the line buffer (not reversed).
          ---------------------------------------------------------------------
          if (bclk_x_reverse = '1') then
            case bclk_cmd_last_ben is
              when "11111111" =>
                bclk_align_mux_sel <= "000";
              when "00000001" =>
                bclk_align_mux_sel <= "001";
              when "00000011" =>
                bclk_align_mux_sel <= "010";
              when "00000111" =>
                bclk_align_mux_sel <= "011";
              when "00001111" =>
                bclk_align_mux_sel <= "100";
              when "00011111" =>
                bclk_align_mux_sel <= "101";
              when "00111111" =>
                bclk_align_mux_sel <= "110";
              when "01111111" =>
                bclk_align_mux_sel <= "111";
              when others =>
                null;
            end case;

          ---------------------------------------------------------------------
          -- In forward mode the first valid byte of a row is always aligned on
          -- byte 0 so no need to calculate a mux alignment.
          ---------------------------------------------------------------------
          else
            bclk_align_mux_sel <= "000";
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- In case the line lenght is not a multiple of 8 bytes we need to shift data
  -- so the output stream is always aligned on the byte 0
  -----------------------------------------------------------------------------
  P_bclk_align_mux : process (bclk_align_mux_sel, bclk_align_packer) is
  begin
    case bclk_align_mux_sel is
      when "000" =>
        bclk_align_mux <= bclk_align_packer(127 downto 64);
      when "001" =>
        bclk_align_mux <= bclk_align_packer(71 downto 8);
      when "010" =>
        bclk_align_mux <= bclk_align_packer(79 downto 16);
      when "011" =>
        bclk_align_mux <= bclk_align_packer(87 downto 24);
      when "100" =>
        bclk_align_mux <= bclk_align_packer(95 downto 32);
      when "101" =>
        bclk_align_mux <= bclk_align_packer(103 downto 40);
      when "110" =>
        bclk_align_mux <= bclk_align_packer(111 downto 48);
      when "111" =>
        bclk_align_mux <= bclk_align_packer(119 downto 56);
      when others =>
        null;
    end case;
  end process;


  ---------------------------------------------------------------------------
  -- Process     : P_bclk_align_data
  -- Description : This pipeline store the output of alignemnt packer. This is
  --               also the last pipeline stage of the axi streamout module.
  ---------------------------------------------------------------------------
  P_bclk_align_data : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_data <= (others => '0');
      else
        if (bclk_ack = '1') then
          if (bclk_align_packer_valid = '1') then
            -----------------------------------------------------------------------
            -- Reverse mode; we reverse pixel position order
            -----------------------------------------------------------------------
            if (bclk_x_reverse = '1') then
              case bclk_pixel_width is
                when "001" =>
                  bclk_align_data(7 downto 0)   <= bclk_align_mux(63 downto 56);
                  bclk_align_data(15 downto 8)  <= bclk_align_mux(55 downto 48);
                  bclk_align_data(23 downto 16) <= bclk_align_mux(47 downto 40);
                  bclk_align_data(31 downto 24) <= bclk_align_mux(39 downto 32);
                  bclk_align_data(39 downto 32) <= bclk_align_mux(31 downto 24);
                  bclk_align_data(47 downto 40) <= bclk_align_mux(23 downto 16);
                  bclk_align_data(55 downto 48) <= bclk_align_mux(15 downto 8);
                  bclk_align_data(63 downto 56) <= bclk_align_mux(7 downto 0);
                when "010" =>
                  bclk_align_data(15 downto 0)  <= bclk_align_mux(63 downto 48);
                  bclk_align_data(31 downto 16) <= bclk_align_mux(47 downto 32);
                  bclk_align_data(47 downto 32) <= bclk_align_mux(31 downto 16);
                  bclk_align_data(63 downto 48) <= bclk_align_mux(15 downto 0);
                when "100" =>
                  bclk_align_data(31 downto 0)  <= bclk_align_mux(63 downto 32);
                  bclk_align_data(63 downto 32) <= bclk_align_mux(31 downto 0);
                when others =>
                  bclk_align_data <= bclk_align_mux;
              end case;
            -----------------------------------------------------------------------
            -- Forward packing no pixel position swap
            -----------------------------------------------------------------------
            else
              bclk_align_data <= bclk_align_mux;
            end if;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_user
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_user : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_user <= (others => '0');
      else
        if (bclk_ack = '1') then
          if (bclk_align_packer_valid = '1') then
            bclk_align_user <= bclk_align_packer_user;

          else
            bclk_align_user <= "0000";
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_tvalid_int
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_tvalid_int : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_tvalid_int <= '0';
      else
        if (bclk_ack = '1') then
          if (bclk_align_packer_valid = '1') then
            bclk_tvalid_int <= '1';
          else
            bclk_tvalid_int <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;


  bclk_tlast <= '1' when ((bclk_align_user(1) = '1' or bclk_align_user(3) = '1') and bclk_tvalid_int = '1') else
                '0';


  -----------------------------------------------------------------------------
  -- Acknowledge forward pipeline
  -----------------------------------------------------------------------------
  bclk_ack <= '1' when (bclk_tready = '1' and bclk_tvalid_int = '1') else
              '1' when (bclk_tvalid_int = '0') else
              '0';


  -----------------------------------------------------------------------------
  -- Port remapping
  -----------------------------------------------------------------------------
  bclk_tvalid <= bclk_tvalid_int;
  bclk_tuser  <= bclk_align_user;
  bclk_tdata  <= bclk_align_data;


end architecture rtl;
