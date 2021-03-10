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

  constant WORD_PTR_WIDTH      : integer := 9;
  constant BUFF_PTR_WIDTH      : integer := 1;
  constant BUFFER_DATA_WIDTH   : integer := 64;
  constant CMD_FIFO_ADDR_WIDTH : integer := 1;

  -----------------------------------------------------------------------------
  -- BCLK clock domain
  -----------------------------------------------------------------------------
  signal bclk_state         : OUTPUT_FSM_TYPE;
  signal bclk_row_cntr      : integer;
  signal bclk_used_buffer   : unsigned(BUFF_PTR_WIDTH downto 0);
  signal bclk_transfer_done : std_logic;
  signal bclk_init          : std_logic;
  signal bclk_cmd_sync      : std_logic_vector(1 downto 0);
  signal bclk_cmd_size      : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cmd_buff_ptr  : unsigned(BUFF_PTR_WIDTH-1 downto 0);
  signal bclk_cmd_last_ben  : std_logic_vector(7 downto 0);
  signal bclk_read_en_int   : std_logic;

  signal bclk_cntr          : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cntr_treshold : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cntr_init     : std_logic;
  signal bclk_cntr_en       : std_logic;
  signal bclk_ack           : std_logic;
  signal bclk_tvalid_int    : std_logic;

  signal bclk_align_packer_en    : std_logic;
  signal bclk_align_packer       : std_logic_vector(127 downto 0);
  signal bclk_align_packer_ben   : std_logic_vector(15 downto 0);
  signal bclk_align_packer_valid : std_logic_vector(1 downto 0);
  signal bclk_align_mux_sel      : std_logic_vector(2 downto 0);
  signal bclk_align_mux          : std_logic_vector(63 downto 0);
  signal bclk_align_data         : std_logic_vector(63 downto 0);
  signal bclk_align_data_valid   : std_logic;

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
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_used_buffer : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_used_buffer <= (others => '0');
      else
        if (bclk_init = '1') then
          bclk_used_buffer <= (others => '0');
        elsif (bclk_buffer_rdy = '1' and bclk_transfer_done = '0') then
          bclk_used_buffer <= bclk_used_buffer+1;
        elsif (bclk_buffer_rdy = '0' and bclk_transfer_done = '1') then
          bclk_used_buffer <= bclk_used_buffer-1;
        else
          bclk_used_buffer <= bclk_used_buffer;
        end if;
      end if;
    end if;
  end process;


  bclk_full <= '1' when (bclk_used_buffer = to_unsigned(NUMB_LINE_BUFFER, bclk_used_buffer'length)) else
               '0';



  bclk_read_en_int <= '1' when (bclk_state = S_READ_DATA and bclk_ack = '1') else
                      '1' when (bclk_state = S_EOL and bclk_ack = '1') else
                      '1' when (bclk_state = S_EOF and bclk_ack = '1') else
                      '0';


  bclk_transfer_done <= '1' when (bclk_state = S_EOL) else
                        '1' when (bclk_state = S_EOF) else
                        '0';


  bclk_cmd_ren <= '1' when (bclk_state = S_READ_CMD) else
                  '0';


  -----------------------------------------------------------------------------
  -- Remapping of the command on bclk
  -----------------------------------------------------------------------------
  bclk_cmd_last_ben <= bclk_cmd_data(19 downto 12);
  bclk_cmd_sync     <= bclk_cmd_data(11 downto 10);
  bclk_cmd_buff_ptr <= unsigned(bclk_cmd_data(9 downto 9));
  bclk_cmd_size     <= unsigned(bclk_cmd_data(8 downto 0));


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_mux_sel
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_mux_sel : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_mux_sel <= (others => '0');
      else
        if (bclk_state = S_INIT) then
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
          else
            bclk_align_mux_sel <= "000";
          end if;
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Process     : P_bclk_cntr_treshold
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_cntr_treshold : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_cntr_treshold <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Initialize the counter treshold value (almost done flag for the FSM)
        -----------------------------------------------------------------------
        if (bclk_state = S_INIT) then
          if (bclk_x_reverse = '1') then
            bclk_cntr_treshold <= to_unsigned(1, bclk_cntr_treshold'length);
          else
            bclk_cntr_treshold <= bclk_cmd_size-2;
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_cntr
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_cntr : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_cntr <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Initialize the counter
        -----------------------------------------------------------------------
        if (bclk_cntr_init = '1') then
          if (bclk_x_reverse = '1') then
            bclk_cntr <= bclk_cmd_size-1;
          else
            bclk_cntr <= (others => '0');
          end if;

        -----------------------------------------------------------------------
        -- Count
        -----------------------------------------------------------------------
        elsif (bclk_cntr_en = '1') then
          -- Reverse : decrement address
          if (bclk_x_reverse = '1') then
            bclk_cntr <= bclk_cntr - 1;
          -- Forward : increment address
          else
            bclk_cntr <= bclk_cntr + 1;
          end if;
        end if;
      end if;
    end if;
  end process;


  bclk_read_address <= std_logic_vector(bclk_cmd_buff_ptr & bclk_cntr);

  bclk_cntr_init <= '1' when (bclk_state = S_INIT) else
                    '0';

  bclk_cntr_en <= '1' when (bclk_read_en_int = '1') else
                  '0';

  bclk_init <= '1' when (bclk_state = S_DONE) else
               '0';


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_state
  -- Description : Line buffer write side state machine
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
            if (bclk_cmd_empty = '0') then
              bclk_state <= S_READ_CMD;
            else
              bclk_state <= S_IDLE;
            end if;

          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_READ_CMD =>
            bclk_state <= S_INIT;

          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_INIT =>
            bclk_state <= S_READ_DATA;

          -------------------------------------------------------------------
          --  S_WRITE : 
          -------------------------------------------------------------------
          when S_READ_DATA =>
            if (bclk_cntr = bclk_cntr_treshold) then
              if (bclk_cmd_sync(1) = '1') then
                bclk_state <= S_EOF;
              else
                bclk_state <= S_EOL;
              end if;
            end if;

          -------------------------------------------------------------------
          -- S_EOF : End of frame encounter
          -------------------------------------------------------------------
          when S_EOF =>
            bclk_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_EOL : End of line encounter
          -------------------------------------------------------------------
          when S_EOL =>
            bclk_state <= S_IDLE;


          -------------------------------------------------------------------
          -- S_DONE : Switch line buffer
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


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer_en
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_packer_en : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer_en <= '0';
      else
        if (bclk_read_en_int = '1') then
          bclk_align_packer_en <= '1';
        else
          bclk_align_packer_en <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer_valid
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_packer_valid : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer_valid <= (others => '0');
      else
        bclk_align_packer_valid(0) <= bclk_align_packer_en;
        bclk_align_packer_valid(1) <= bclk_align_packer_valid(0);
      end if;
    end if;
  end process;


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
        -----------------------------------------------------------------------
        -- User sync in reverse packing
        -----------------------------------------------------------------------
        -- SOF or SOL
        if (bclk_align_packer_valid = "01") then
          if (bclk_cmd_sync = "01") then
            -- SOF
            bclk_align_packer_user(0) <= '1';
          else
            -- SOL
            bclk_align_packer_user(2) <= '1';
          end if;
        elsif (bclk_align_packer_valid = "11" and bclk_align_packer_en = '0') then
          -- EOF
          if (bclk_cmd_sync = "10") then
            bclk_align_packer_user(1) <= '1';
          -- EOL
          else
            bclk_align_packer_user(3) <= '1';
          end if;
        else
          bclk_align_packer_user <= "0000";
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_align_packer
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_align_packer : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_packer <= (others => '0');
      else
        if (bclk_align_packer_en = '1') then
          bclk_align_packer(63 downto 0) <= bclk_read_data;
        elsif (bclk_align_packer_valid = "11") then
          bclk_align_packer(63 downto 0) <= (others => '0');
        end if;

        bclk_align_packer(127 downto 64) <= bclk_align_packer(63 downto 0);
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


  bclk_align_data_valid <= bclk_align_packer_valid(1);


-----------------------------------------------------------------------------
-- Process     : P_bclk_align_data
-- Description : 
-----------------------------------------------------------------------------
  P_bclk_align_data : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_align_data <= (others => '0');
      else
        if (bclk_align_data_valid = '1') then
          -----------------------------------------------------------------------
          -- Reverse packing we reverse pixel position order
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
        if (bclk_align_data_valid = '1') then
          bclk_align_user <= bclk_align_packer_user;
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
        if (bclk_align_data_valid = '1') then
          bclk_tvalid_int <= '1';
        elsif (bclk_tready = '1') then
          bclk_tvalid_int <= '0';
        end if;
      end if;
    end if;
  end process;


  bclk_tlast <= '1' when ((bclk_align_user(1) = '1' or bclk_align_user(3) = '1') and bclk_tvalid_int = '1') else
                '0';



  bclk_ack <= '1' when (bclk_tready = '1') else
              '0';


  bclk_tvalid <= bclk_tvalid_int;
  bclk_tuser  <= bclk_align_user;
  bclk_tdata  <= bclk_align_data;


end architecture rtl;
