-----------------------------------------------------------------------
-- MODULE        : x_chopper
-- 
-- DESCRIPTION   : 
--              
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Crop (xstart + xsize)
-- sub  (div2. )
-- reverse
-- rgba

entity x_chopper is
  generic (
    NUMB_LINE_BUFFER : integer range 2 to 4 := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    aclk_x_size    : in std_logic_vector(15 downto 0);
    aclk_x_start   : in std_logic_vector(15 downto 0);
    aclk_x_stop    : in std_logic_vector(15 downto 0);
    aclk_x_scale   : in std_logic_vector(3 downto 0);
    aclk_x_reverse : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    aclk         : in std_logic;
    aclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI slave stream input interface
    ---------------------------------------------------------------------------
    aclk_tready : out std_logic;
    aclk_tvalid : in  std_logic;
    aclk_tuser  : in  std_logic_vector(3 downto 0);
    aclk_tlast  : in  std_logic;
    aclk_tdata  : in  std_logic_vector(63 downto 0);

    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    bclk         : in std_logic;
    bclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- AXI master stream output interface
    ---------------------------------------------------------------------------
    bclk_tready : in  std_logic;
    bclk_tvalid : out std_logic;
    bclk_tuser  : out std_logic_vector(3 downto 0);
    bclk_tlast  : out std_logic;
    bclk_tdata  : out std_logic_vector(63 downto 0)
    );
end x_chopper;


architecture rtl of x_chopper is


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

  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_WRITE, S_EOL, S_EOF, S_DONE);
  type OUTPUT_FSM_TYPE is (S_IDLE, S_INIT, S_READ_CMD, S_READ_DATA, S_SOF, S_SOL, S_READ, S_EOL, S_EOF, S_DONE);

  constant WORD_PTR_WIDTH      : integer := 9;
  constant BUFF_PTR_WIDTH      : integer := 1;
  constant BUFFER_ADDR_WIDTH   : integer := BUFF_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH   : integer := 64;
  constant CMD_FIFO_ADDR_WIDTH : integer := 1;
  constant CMD_FIFO_DATA_WIDTH : integer := 2 + WORD_PTR_WIDTH + BUFF_PTR_WIDTH;

  -----------------------------------------------------------------------------
  -- ACLK clock domain
  -----------------------------------------------------------------------------
  signal aclk_reset           : std_logic;
  signal aclk_state           : FSM_TYPE := S_IDLE;
  signal aclk_full            : std_logic;
  signal aclk_tready_int      : std_logic;
  signal aclk_init_word_ptr   : std_logic;
  signal aclk_word_ptr        : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal aclk_buffer_ptr      : unsigned(BUFF_PTR_WIDTH-1 downto 0);
  signal aclk_init_buffer_ptr : std_logic;
  signal aclk_nxt_buffer      : std_logic;
  signal aclk_write_en        : std_logic;
  signal aclk_write_address   : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal aclk_write_data      : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal aclk_cmd_wen         : std_logic;
  signal aclk_cmd_full        : std_logic;
  signal aclk_cmd_data        : std_logic_vector(CMD_FIFO_DATA_WIDTH-1 downto 0);
  signal aclk_cmd_sync        : std_logic_vector(1 downto 0);
  signal aclk_cmd_size        : std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
  signal aclk_cmd_buff_ptr    : std_logic_vector(BUFF_PTR_WIDTH-1 downto 0);
  --signal aclk_crop_cntr       : natural 0 to 4096;

  signal aclk_pixel_width   : natural range 1 to 4;
  signal aclk_ack           : std_logic;
  signal aclk_pix_cntr      : unsigned(12 downto 0);
  signal aclk_pix_incr      : unsigned(aclk_pix_cntr'range);
  signal aclk_pix_cntr_mask : unsigned(aclk_pix_cntr'range);

  signal aclk_crop_start      : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_stop       : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_size       : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_start_mask : std_logic_vector(7 downto 0);
  signal aclk_crop_stop_mask  : std_logic_vector(7 downto 0);

  signal aclk_crop_en         : std_logic;
  signal aclk_crop_packer     : std_logic_vector(127 downto 0);
  signal aclk_crop_packer_ben : std_logic_vector(15 downto 0);
  signal aclk_crop_data_mux   : std_logic_vector(63 downto 0);
  signal aclk_crop_ben_mux    : std_logic_vector(7 downto 0);
  signal aclk_crop_mux_sel    : std_logic_vector(2 downto 0);

  -----------------------------------------------------------------------------
  -- BCLK clock domain
  -----------------------------------------------------------------------------
  signal bclk_reset : std_logic;
  signal bclk_state : OUTPUT_FSM_TYPE;
  signal bclk_full  : std_logic;
  signal bclk_empty : std_logic;

  signal bclk_row_cntr      : integer;
  signal bclk_read_address  : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal bclk_read_en       : std_logic;
  signal bclk_read_data     : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal bclk_used_buffer   : unsigned(BUFF_PTR_WIDTH downto 0);
  signal bclk_transfer_done : std_logic;
  signal bclk_init          : std_logic;
  signal bclk_buffer_rdy    : std_logic;
  signal bclk_cmd_ren       : std_logic;
  signal bclk_cmd_empty     : std_logic;
  signal bclk_cmd_data      : std_logic_vector(CMD_FIFO_DATA_WIDTH-1 downto 0);
  signal bclk_cmd_sync      : std_logic_vector(1 downto 0);
  signal bclk_cmd_size      : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cmd_buff_ptr  : unsigned(BUFF_PTR_WIDTH-1 downto 0);

  signal bclk_cntr      : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal bclk_cntr_init : std_logic;
  signal bclk_cntr_en   : std_logic;

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin


  aclk_reset <= not aclk_reset_n;
  aclk_tready <= aclk_tready_int;


  aclk_tready_int <= '1' when (aclk_state = S_IDLE and aclk_full = '0') else
                     '1' when (aclk_state = S_WRITE) else
                     '0';




  aclk_ack <= '1' when (aclk_tready_int = '1'and aclk_tvalid = '1') else
              '0';


  -- TEMP parameters. should come from register fields
  aclk_crop_start <= "0000000001010";
  aclk_crop_size  <= "0100000000000";
  aclk_crop_stop  <= aclk_crop_start + aclk_crop_size -1;

  -- TEMP assign accordingly (aclk_crop_start/stop)
  aclk_crop_start_mask <= "11111111";
  aclk_crop_stop_mask  <= "11111111";

  aclk_pix_incr <= "0000000001000" when (aclk_pixel_width = 1) else  -- 8 pix/slice
                   "0000000000100" when (aclk_pixel_width = 2) else  -- 4 pix/slice
                   "0000000000100" when (aclk_pixel_width = 2) else  -- 2 pix/slice
                   "0000000000000";

  aclk_pix_cntr_mask <= "0000000000111" when (aclk_pixel_width = 1) else  -- 8 pix/slice
                        "0000000000011" when (aclk_pixel_width = 2) else  -- 4 pix/slice
                        "0000000000001" when (aclk_pixel_width = 4) else  -- 2 pix/slice
                        "0000000000000";


  aclk_crop_en <= '1' when (aclk_pix_cntr >= (aclk_crop_start and not(aclk_pix_cntr_mask))) else
                  '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_pix_cntr : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_pix_cntr <= (others => '0');
      else
        if (aclk_state = S_DONE) then
          aclk_pix_cntr <= (others => '0');
        elsif (aclk_ack = '1') then
          aclk_pix_cntr <= aclk_pix_cntr + aclk_pix_incr;
        end if;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_crop_packer_ben : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_crop_packer_ben <= (others => '0');
      else
        if (aclk_state = S_DONE) then
          aclk_crop_packer_ben <= (others => '0');

        -----------------------------------------------------------------------
        -- Shift right process
        -----------------------------------------------------------------------
        elsif (aclk_ack = '1' and aclk_crop_en = '1') then
          aclk_crop_packer_ben(7 downto 0) <= aclk_crop_packer_ben(15 downto 8);
          ---------------------------------------------------------------------
          -- Start border of the valid window
          ---------------------------------------------------------------------
          if (aclk_pix_cntr = (aclk_crop_start and not(aclk_pix_cntr_mask))) then
            aclk_crop_packer_ben(15 downto 8) <= aclk_crop_start_mask;
          ---------------------------------------------------------------------
          -- Stop border of the valid window
          ---------------------------------------------------------------------
          elsif (aclk_pix_cntr = (aclk_crop_stop and not(aclk_pix_cntr_mask))) then
            aclk_crop_packer_ben(15 downto 8) <= aclk_crop_stop_mask;
          ---------------------------------------------------------------------
          -- Valid window
          ---------------------------------------------------------------------
          elsif (aclk_pix_cntr > aclk_crop_start and aclk_pix_cntr < aclk_crop_stop) then
            aclk_crop_packer_ben(15 downto 8) <= (others => '1');
          ---------------------------------------------------------------------
          -- Invalid region
          ---------------------------------------------------------------------
          else
            aclk_crop_packer_ben(15 downto 8) <= (others => '0');
          end if;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_crop_packer : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_crop_packer <= (others => '0');
      else
        if (aclk_state = S_DONE) then
          aclk_crop_packer <= (others => '0');
        elsif (aclk_ack = '1' and aclk_crop_en = '1') then
          aclk_crop_packer(127 downto 64) <= aclk_tdata;
          aclk_crop_packer(63 downto 0)   <= aclk_crop_packer(127 downto 64);
        end if;
      end if;
    end if;
  end process;

  
  -----------------------------------------------------------------------------
  -- Modulo 8 equivalent equation
  -----------------------------------------------------------------------------
  aclk_crop_mux_sel <= std_logic_vector(to_unsigned(to_integer(aclk_crop_start) * aclk_pixel_width, 3));

  
  P_aclk_crop_mux: process (aclk_crop_mux_sel,aclk_crop_packer_ben,aclk_crop_packer) is
  begin
    case aclk_crop_mux_sel is
      when "000" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(7 downto 0);
        aclk_crop_data_mux <= aclk_crop_packer(63 downto 0);
      when "001" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(8 downto 1);
        aclk_crop_data_mux <= aclk_crop_packer(71 downto 8);
      when "010" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(9 downto 2);
        aclk_crop_data_mux <= aclk_crop_packer(79 downto 16);
      when "011" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(10 downto 3);
        aclk_crop_data_mux <= aclk_crop_packer(87 downto 24);
      when "100" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(11 downto 4);
        aclk_crop_data_mux <= aclk_crop_packer(95 downto 32);
      when "101" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(12 downto 5);
        aclk_crop_data_mux <= aclk_crop_packer(103 downto 40);
      when "110" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(13 downto 6);
        aclk_crop_data_mux <= aclk_crop_packer(111 downto 48);
      when "111" =>
        aclk_crop_ben_mux <= aclk_crop_packer_ben(14 downto 7);
        aclk_crop_data_mux <= aclk_crop_packer(119 downto 56);
      when others =>
        null;
    end case;
  end process;

  
  -----------------------------------------------------------------------------
  -- Process     : P_aclk_state
  -- Description : Line buffer write side state machine
  -----------------------------------------------------------------------------
  P_aclk_state : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_state <= S_IDLE;
      else

        case aclk_state is
          -------------------------------------------------------------------
          -- S_IDLE : Parking state
          -------------------------------------------------------------------
          when S_IDLE =>
            if (aclk_tvalid = '1' and aclk_full = '0') then
              if (aclk_tuser(0) = '1') then
                aclk_state <= S_SOF;
              elsif (aclk_tuser(2) = '1') then
                aclk_state <= S_SOL;
              end if;
            else
              aclk_state <= S_IDLE;
            end if;


          -------------------------------------------------------------------
          -- S_SOF : Start of frame detected on the AXIS I/F
          -------------------------------------------------------------------
          when S_SOF =>
            aclk_state <= S_WRITE;


          -------------------------------------------------------------------
          -- S_SOL : Start of line; initialize the current buffer for a new
          --         line storage
          -------------------------------------------------------------------
          when S_SOL =>
            aclk_state <= S_WRITE;


          -------------------------------------------------------------------
          --  S_WRITE : 
          -------------------------------------------------------------------
          when S_WRITE =>
            -- If a end of line is detected
            if (aclk_tvalid = '1' and aclk_tlast = '1') then
              -- If a End of frame is detected
              if (aclk_tuser(1) = '1') then
                aclk_state <= S_EOF;
              -- If a End of line is detected
              elsif (aclk_tuser(3) = '1') then
                aclk_state <= S_EOL;
              end if;
            else
              aclk_state <= S_WRITE;
            end if;

          -------------------------------------------------------------------
          -- S_EOF : End of frame encounter
          -------------------------------------------------------------------
          when S_EOF =>
            aclk_state <= S_DONE;

          -------------------------------------------------------------------
          -- S_EOL : End of line encounter
          -------------------------------------------------------------------
          when S_EOL =>
            aclk_state <= S_IDLE;


          -------------------------------------------------------------------
          -- S_DONE : Switch line buffer
          -------------------------------------------------------------------
          when S_DONE =>
            aclk_state <= S_IDLE;

          -------------------------------------------------------------------
          -- 
          -------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_aclk_state;


  aclk_init_buffer_ptr <= '1' when (aclk_state = S_SOF) else
                          '0';

  aclk_nxt_buffer <= '1' when (aclk_state = S_EOL) else
                     '0';

  -----------------------------------------------------------------------------
  -- Process     : P_aclk_buffer_ptr
  -- Description : Buffer pointer. 
  -----------------------------------------------------------------------------
  P_aclk_buffer_ptr : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1') then
        aclk_buffer_ptr <= (others => '0');
      else
        if (aclk_init_buffer_ptr = '1') then
          aclk_buffer_ptr <= (others => '0');
        elsif (aclk_nxt_buffer = '1') then
          aclk_buffer_ptr <= aclk_buffer_ptr + 1;
        end if;
      end if;
    end if;
  end process;



  aclk_init_word_ptr <= '1' when (aclk_state = S_SOF or aclk_state = S_EOL) else
                        '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_word_ptr : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_word_ptr <= (others => '0');
      else
        if (aclk_init_word_ptr = '1') then
          aclk_word_ptr <= (others => '0');
        elsif (aclk_write_en = '1') then
          aclk_word_ptr <= aclk_word_ptr + 1;
        end if;
      end if;
    end if;
  end process;


  M_aclk_full : mtx_resync
    port map (
      aClk  => bclk,
      aClr  => bclk_reset,
      aDin  => bclk_full,
      bclk  => aclk,
      bclr  => aclk_reset,
      bDout => aclk_full,
      bRise => open,
      bFall => open
      );

  aclk_write_en <= '1' when (aclk_state = S_WRITE and aclk_tvalid = '1') else
                   '0';

  aclk_write_address <= std_logic_vector(aclk_buffer_ptr & aclk_word_ptr);
  aclk_write_data    <= aclk_tdata;


  aclk_cmd_wen <= '1' when (aclk_state = S_EOL or aclk_state = S_EOF) else
                  '0';



  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_cmd_sync : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_cmd_sync <= (others => '0');
      else
        if (aclk_state = S_SOF) then
          aclk_cmd_sync <= "01";
        elsif (aclk_state = S_WRITE and aclk_tvalid = '1' and aclk_tlast = '1' and aclk_tuser(1) = '1') then
          aclk_cmd_sync <= "10";
        elsif (aclk_state = S_SOL) then
          aclk_cmd_sync <= "00";
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  aclk_cmd_size <= std_logic_vector(aclk_word_ptr);

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  aclk_cmd_buff_ptr <= std_logic_vector(aclk_buffer_ptr);




  aclk_cmd_data <= aclk_cmd_sync & aclk_cmd_buff_ptr & aclk_cmd_size;

  xcommand_buffer : mtxDCFIFO
    generic map(
      DATAWIDTH => CMD_FIFO_DATA_WIDTH,
      ADDRWIDTH => CMD_FIFO_ADDR_WIDTH
      )
    port map(
      aClr   => aclk_reset,
      wClk   => aclk,
      wEn    => aclk_cmd_wen,
      wData  => aclk_cmd_data,
      wFull  => aclk_cmd_full,
      rClk   => bclk,
      rEn    => bclk_cmd_ren,
      rData  => bclk_cmd_data,
      rEmpty => bclk_cmd_empty
      );


  -----------------------------------------------------------------------------
  -- Line buffer (2xline buffer size to support double buffering)
  -----------------------------------------------------------------------------
  xdual_port_ram : dualPortRamVar
    generic map(
      DATAWIDTH => BUFFER_DATA_WIDTH,
      ADDRWIDTH => BUFFER_ADDR_WIDTH
      )
    port map(
      data      => aclk_write_data,
      rdaddress => bclk_read_address,
      rdclock   => bclk,
      rden      => bclk_read_en,
      wraddress => aclk_write_address,
      wrclock   => aclk,
      wren      => aclk_write_en,
      q         => bclk_read_data
      );

  bclk_reset <= not bclk_reset_n;

  M_bclk_buffer_rdy : mtx_resync
    port map (
      aClk  => aclk,
      aClr  => aclk_reset,
      aDin  => aclk_nxt_buffer,
      bclk  => bclk,
      bclr  => bclk_reset,
      bDout => open,
      bRise => bclk_buffer_rdy,
      bFall => open
      );


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


  bclk_empty <= '1' when (bclk_used_buffer = (bclk_used_buffer'range => '0')) else
                '0';


  bclk_read_en <= '1' when (bclk_state = S_READ_DATA) else
                  '0';

  bclk_transfer_done <= '1' when (bclk_state = S_EOL) else
                        '1' when (bclk_state = S_EOF) else
                        '0';

  bclk_cmd_ren <= '1' when (bclk_state = S_READ_CMD) else
                  '0';

  -----------------------------------------------------------------------------
  -- Remapping of the command on bclk
  -----------------------------------------------------------------------------
  bclk_cmd_sync     <= bclk_cmd_data(11 downto 10);
  bclk_cmd_buff_ptr <= unsigned(bclk_cmd_data(9 downto 9));
  bclk_cmd_size     <= unsigned(bclk_cmd_data(8 downto 0));



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
        if (bclk_cntr_init = '1') then
          bclk_cntr <= (others => '0');
        elsif (bclk_cntr_en = '1') then
          bclk_cntr <= bclk_cntr + 1;
        end if;
      end if;
    end if;
  end process;


  bclk_read_address <= std_logic_vector(bclk_cmd_buff_ptr & bclk_cntr);

  bclk_cntr_init <= '1' when (bclk_state = S_INIT) else
                    '0';

  bclk_cntr_en <= '1' when (bclk_read_en = '1') else
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
            if (bclk_cntr = bclk_cmd_size) then
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



end architecture rtl;
