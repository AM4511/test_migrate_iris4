-----------------------------------------------------------------------
-- MODULE        : x_trim
-- 
-- DESCRIPTION   : 
--              
--
-- ToDO: Implement sub-sampling
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Crop (xstart + xsize)
-- sub  (div2. )
-- reverse
-- rgba

-- #  
-- # ---------------------------------
-- #  Results of testlist simulation  
-- # ---------------------------------
-- # test0001_result : PASS
-- # test0002_result : PASS
-- # test0003_result : PASS
-- # test0004_result : PASS
-- # test0005_result : FAIL
-- # test0006_result : PASS
-- # test0007_result : FAIL
-- # test0008_result : FAIL ->Revx
-- # test0009_result : PASS
-- # test0010_result : FAIL -> cropping x

entity x_trim is
  generic (
    NUMB_LINE_BUFFER : integer range 2 to 4 := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    aclk_pixel_width : in std_logic_vector(2 downto 0);
    aclk_x_crop_en   : in std_logic;
    aclk_x_start     : in std_logic_vector(12 downto 0);
    aclk_x_size      : in std_logic_vector(12 downto 0);
    aclk_x_scale     : in std_logic_vector(3 downto 0);
    aclk_x_reverse   : in std_logic;

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
end x_trim;


architecture rtl of x_trim is


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


  component x_trim_subsampling is
    port (
      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      aclk       : in std_logic;
      aclk_reset : in std_logic;

      ---------------------------------------------------------------------------
      -- 
      ---------------------------------------------------------------------------
      aclk_pixel_width   : in std_logic_vector(2 downto 0);
      aclk_x_subsampling : in std_logic_vector(3 downto 0);

      ---------------------------------------------------------------------------
      -- Input stream
      ---------------------------------------------------------------------------
      aclk_en      : in std_logic;
      aclk_init    : in std_logic;
      aclk_data_in : in std_logic_vector(63 downto 0);
      aclk_ben_in  : in std_logic_vector(7 downto 0);

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      aclk_data_out : out std_logic_vector(63 downto 0);
      aclk_ben_out  : out std_logic_vector(7 downto 0)
      );
  end component;


  component x_trim_streamout is
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
  end component;


  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_WRITE, S_EOL, S_EOF, S_FLUSH, S_DONE);

  constant WORD_PTR_WIDTH      : integer := 9;
  constant BUFF_PTR_WIDTH      : integer := 1;
  constant BUFFER_ADDR_WIDTH   : integer := BUFF_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH   : integer := 64;
  constant CMD_FIFO_ADDR_WIDTH : integer := 1;
  constant CMD_FIFO_DATA_WIDTH : integer := 8 + 2 + WORD_PTR_WIDTH + BUFF_PTR_WIDTH;


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
  signal aclk_cmd_last_ben    : std_logic_vector(7 downto 0);

  signal aclk_ack         : std_logic;
  signal aclk_pix_cntr    : unsigned(12 downto 0);
  signal aclk_pix_incr    : integer range 0 to 8;
  signal aclk_valid_start : unsigned(aclk_pix_cntr'range);
  signal aclk_valid_stop  : unsigned(aclk_pix_cntr'range);
  signal aclk_eof_pndg    : std_logic;

  signal aclk_crop_start         : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_stop          : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_size          : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_stop_mask_sel : std_logic_vector(2 downto 0);
  signal aclk_crop_data_rdy      : std_logic;

  signal aclk_crop_window_valid : std_logic;
  signal aclk_crop_packer       : std_logic_vector(127 downto 0);
  signal aclk_crop_packer_ben   : std_logic_vector(15 downto 0);
  signal aclk_crop_data_mux     : std_logic_vector(63 downto 0);
  signal aclk_crop_ben_mux      : std_logic_vector(7 downto 0);
  signal aclk_crop_mux_sel      : std_logic_vector(2 downto 0);
  signal aclk_crop_packer_valid : std_logic_vector(1 downto 0);


  -----------------------------------------------------------------------------
  -- BCLK clock domain
  -----------------------------------------------------------------------------
  signal bclk_x_reverse_Meta : std_logic;
  signal bclk_x_reverse      : std_logic;
  signal bclk_pixel_width    : std_logic_vector(2 downto 0);

  signal bclk_reset : std_logic;
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
  signal bclk_cmd_last_ben  : std_logic_vector(7 downto 0);

  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin

  aclk_reset  <= not aclk_reset_n;
  aclk_tready <= aclk_tready_int;


  aclk_tready_int <= '1' when (aclk_state = S_IDLE and aclk_full = '0') else
                     '1' when (aclk_state = S_WRITE) else
                     '0';




  aclk_ack <= '1' when (aclk_tready_int = '1'and aclk_tvalid = '1') else
              '0';


  -- TEMP parameters. should come from register fields
  aclk_crop_start <= unsigned(aclk_x_start(aclk_pix_cntr'range)) when (aclk_x_crop_en = '1') else
                     (aclk_pix_cntr'range => '0');
  aclk_crop_size <= unsigned(aclk_x_size(aclk_pix_cntr'range));
  aclk_crop_stop <= aclk_crop_start + aclk_crop_size -1 when (aclk_x_crop_en = '1') else
                    (aclk_pix_cntr'range => '1');

  --aclk_pixel_width <= 1;
  bclk_pixel_width <= aclk_pixel_width;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_pixel_width : process (aclk_pixel_width, aclk_crop_start, aclk_crop_stop) is
  begin
    case aclk_pixel_width is
      -- One byte per pixel
      when "001" =>
        aclk_pix_incr    <= 8;
        aclk_valid_start <= aclk_crop_start(12 downto 3) & "000";
        aclk_valid_stop  <= aclk_crop_stop(12 downto 3) & "000";

      -- Two bytes per pixel
      when "010" =>
        aclk_pix_incr    <= 4;
        aclk_valid_start <= aclk_crop_start(12 downto 2) & "00";
        aclk_valid_stop  <= aclk_crop_stop(12 downto 2) & "00";

      -- Four bytes per pixel
      when "100" =>
        aclk_pix_incr    <= 2;
        aclk_valid_start <= aclk_crop_start(12 downto 1) & '0';
        aclk_valid_stop  <= aclk_crop_stop(12 downto 1) & '0';

      when others =>
        aclk_pix_incr    <= 0;
        aclk_valid_start <= (others => '0');
        aclk_valid_stop  <= (others => '0');
    end case;
  end process;


  aclk_crop_window_valid <= '1' when (aclk_pix_cntr >= aclk_valid_start and aclk_pix_cntr <= aclk_valid_stop) else
                            '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_eof_pndg : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_eof_pndg <= '0';
      else
        if (aclk_tvalid = '1' and aclk_tlast = '1' and aclk_tuser(1) = '1') then
          aclk_eof_pndg <= '1';
        elsif (aclk_state = S_EOF) then
          aclk_eof_pndg <= '0';
        end if;
      end if;
    end if;
  end process;


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
  P_aclk_crop_packer_valid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_crop_packer_valid <= (others => '0');
      else

        if (aclk_state = S_DONE) then
          aclk_crop_packer_valid <= (others => '0');
        elsif (aclk_ack = '1') then
          if (aclk_crop_window_valid = '1') then
            aclk_crop_packer_valid(1) <= '1';
            aclk_crop_packer_valid(0) <= aclk_crop_packer_valid(1);
          else
            aclk_crop_packer_valid(1) <= '0';
            aclk_crop_packer_valid(0) <= aclk_crop_packer_valid(1);
          end if;
        elsif (aclk_state = S_FLUSH) then
          aclk_crop_packer_valid(1) <= '0';
          aclk_crop_packer_valid(0) <= aclk_crop_packer_valid(1);
        end if;
      end if;
    end if;
  end process;


  aclk_crop_stop_mask_sel <= std_logic_vector(to_unsigned(to_integer(aclk_crop_stop) * to_integer(unsigned(aclk_pixel_width)), 3));


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
        elsif (aclk_ack = '1') then
          ---------------------------------------------------------------------
          -- Stop border of the valid window
          ---------------------------------------------------------------------
          if (aclk_pix_cntr < aclk_valid_stop) then
            aclk_crop_packer_ben(15 downto 8) <= (others => '1');

          elsif (aclk_pix_cntr = aclk_valid_stop) then
            case aclk_crop_stop_mask_sel is
              when "000" => aclk_crop_packer_ben(15 downto 8) <= "00000001";
              when "001" => aclk_crop_packer_ben(15 downto 8) <= "00000011";
              when "010" => aclk_crop_packer_ben(15 downto 8) <= "00000111";
              when "011" => aclk_crop_packer_ben(15 downto 8) <= "00001111";
              when "100" => aclk_crop_packer_ben(15 downto 8) <= "00011111";
              when "101" => aclk_crop_packer_ben(15 downto 8) <= "00111111";
              when "110" => aclk_crop_packer_ben(15 downto 8) <= "01111111";
              when "111" => aclk_crop_packer_ben(15 downto 8) <= "11111111";
              when others =>
                null;
            end case;

          elsif (aclk_pix_cntr > aclk_valid_stop) then
            aclk_crop_packer_ben(15 downto 8) <= (others => '0');

          end if;
          aclk_crop_packer_ben(7 downto 0) <= aclk_crop_packer_ben(15 downto 8);

        elsif (aclk_state = S_FLUSH) then
          aclk_crop_packer_ben(15 downto 8) <= (others => '0');
          aclk_crop_packer_ben(7 downto 0)  <= aclk_crop_packer_ben(15 downto 8);
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
        elsif (aclk_ack = '1') then
          if (aclk_crop_window_valid = '1') then
            aclk_crop_packer(127 downto 64) <= aclk_tdata;
            aclk_crop_packer(63 downto 0)   <= aclk_crop_packer(127 downto 64);
          else
            aclk_crop_packer(127 downto 64) <= (others => '0');
            aclk_crop_packer(63 downto 0)   <= aclk_crop_packer(127 downto 64);
          end if;
        elsif (aclk_state = S_FLUSH) then
          aclk_crop_packer(127 downto 64) <= (others => '0');
          aclk_crop_packer(63 downto 0)   <= aclk_crop_packer(127 downto 64);
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Modulo 8 equivalent equation
  -----------------------------------------------------------------------------
  aclk_crop_mux_sel <= std_logic_vector(to_unsigned(to_integer(aclk_crop_start) * to_integer(unsigned(aclk_pixel_width)), 3));


  -----------------------------------------------------------------------------
  -- Mux alignment (Align first valid pixel to byte 0)
  -----------------------------------------------------------------------------
  P_aclk_crop_mux : process (aclk) is
  begin
    if (aclk_reset = '1')then
      aclk_crop_ben_mux <= (others => '0');
    else
      if (rising_edge(aclk)) then
        if ((aclk_ack = '1' or aclk_state = S_FLUSH) and aclk_crop_packer_valid(0) = '1') then

          case aclk_crop_mux_sel is
            when "000" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(7 downto 0);
              aclk_crop_data_mux <= aclk_crop_packer(63 downto 0);
            when "001" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(8 downto 1);
              aclk_crop_data_mux <= aclk_crop_packer(71 downto 8);
            when "010" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(9 downto 2);
              aclk_crop_data_mux <= aclk_crop_packer(79 downto 16);
            when "011" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(10 downto 3);
              aclk_crop_data_mux <= aclk_crop_packer(87 downto 24);
            when "100" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(11 downto 4);
              aclk_crop_data_mux <= aclk_crop_packer(95 downto 32);
            when "101" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(12 downto 5);
              aclk_crop_data_mux <= aclk_crop_packer(103 downto 40);
            when "110" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(13 downto 6);
              aclk_crop_data_mux <= aclk_crop_packer(111 downto 48);
            when "111" =>
              aclk_crop_ben_mux  <= aclk_crop_packer_ben(14 downto 7);
              aclk_crop_data_mux <= aclk_crop_packer(119 downto 56);
            when others =>
              null;
          end case;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_crop_data_rdy : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_crop_data_rdy <= '0';
      else
        if (aclk_ack = '1' or aclk_state = S_FLUSH) then
          aclk_crop_data_rdy <= aclk_crop_packer_valid(0);
        else
          aclk_crop_data_rdy <= '0';
        end if;
      end if;
    end if;
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
              if (aclk_crop_packer_valid = "11") then
                aclk_state <= S_FLUSH;

              elsif (aclk_tuser(1) = '1') then
                aclk_state <= S_EOF;
              -- If a End of line is detected
              elsif (aclk_tuser(3) = '1') then
                aclk_state <= S_EOL;
              end if;
            else
              aclk_state <= S_WRITE;
            end if;

          -------------------------------------------------------------------
          -- S_FLUSH : End of frame encounter
          -------------------------------------------------------------------
          when S_FLUSH =>
            if (aclk_crop_packer_valid = "01") then
              if (aclk_eof_pndg = '1') then
                aclk_state <= S_EOF;
              else
                aclk_state <= S_EOL;
              end if;
            else
              aclk_state <= S_FLUSH;
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
            aclk_state <= S_DONE;


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

  aclk_nxt_buffer <= '1' when (aclk_state = S_DONE) else
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



  aclk_init_word_ptr <= '1' when (aclk_state = S_DONE) else
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

  aclk_write_en <= '1' when (aclk_crop_data_rdy = '1') else
                   '0';

  aclk_write_address <= std_logic_vector(aclk_buffer_ptr & aclk_word_ptr);
  aclk_write_data    <= aclk_crop_data_mux;


  aclk_cmd_wen <= '1' when (aclk_state = S_DONE) else
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


  aclk_cmd_last_ben <= aclk_crop_ben_mux;

  aclk_cmd_data <= aclk_cmd_last_ben & aclk_cmd_sync & aclk_cmd_buff_ptr & aclk_cmd_size;


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


  x_trim_subsampling_inst : x_trim_subsampling
    port map (
      aclk               => aclk,
      aclk_reset         => aclk_reset,
      aclk_pixel_width   => aclk_pixel_width,
      aclk_x_subsampling => aclk_x_scale,
      aclk_en            => aclk_write_en,
      aclk_init          => aclk_init_buffer_ptr,
      aclk_data_in       => aclk_write_data,
      aclk_ben_in        => aclk_crop_ben_mux,
      aclk_data_out      => open,
      aclk_ben_out       => open
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


  bclk_reset <= not bclk_reset_n;


  -----------------------------------------------------------------------------
  -- Process     : P_bclk_x_reverse
  -- Description : 
  -----------------------------------------------------------------------------
  P_bclk_x_reverse : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_x_reverse      <= '0';
        bclk_x_reverse_Meta <= '0';
      else
        bclk_x_reverse_Meta <= aclk_x_reverse;
        bclk_x_reverse      <= bclk_x_reverse_Meta;
      end if;
    end if;
  end process;


  x_trim_streamout_inst : x_trim_streamout
    generic map(
      NUMB_LINE_BUFFER    => NUMB_LINE_BUFFER,
      CMD_FIFO_DATA_WIDTH => CMD_FIFO_DATA_WIDTH,
      BUFFER_ADDR_WIDTH   => BUFFER_ADDR_WIDTH
      )
    port map(
      bclk              => bclk,
      bclk_reset        => bclk_reset,
      bclk_pixel_width  => bclk_pixel_width,
      bclk_x_reverse    => bclk_x_reverse,
      bclk_buffer_rdy   => bclk_buffer_rdy,
      bclk_full         => bclk_full,
      bclk_cmd_empty    => bclk_cmd_empty,
      bclk_cmd_ren      => bclk_cmd_ren,
      bclk_cmd_data     => bclk_cmd_data,
      bclk_read_en      => bclk_read_en,
      bclk_read_address => bclk_read_address,
      bclk_read_data    => bclk_read_data,
      bclk_tready       => bclk_tready,
      bclk_tvalid       => bclk_tvalid,
      bclk_tuser        => bclk_tuser,
      bclk_tlast        => bclk_tlast,
      bclk_tdata        => bclk_tdata
      );


end architecture rtl;
