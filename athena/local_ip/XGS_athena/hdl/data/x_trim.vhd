-----------------------------------------------------------------------
-- MODULE        : x_trim
-- 
-- DESCRIPTION   : Receive axi streamed rows (lines) from the current frame
--                 and apply the following processing fonction in the
--                 following order:
--
--                     * Line cropping (Region Of Interest - ROI)
--                     * X subsampling with a scaling factor from 1 to 16
--                     * X mirror (a.k.a line reversal)
--
--                 This module supports Monochrome and Color input rows 
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity x_trim is
  generic (
    NUMB_LINE_BUFFER : integer range 2 to 4 := 2;
    COLOR            : integer range 0 to 1 := 0  -- Boolean (0 or 1)
    );
  port (
    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    aclk_grab_queue_en : in std_logic;
    aclk_load_context  : in std_logic_vector(1 downto 0);
    aclk_csc           : in std_logic_vector(2 downto 0);
    aclk_x_crop_en     : in std_logic;
    aclk_x_start       : in std_logic_vector(12 downto 0);
    aclk_x_size        : in std_logic_vector(12 downto 0);
    aclk_x_scale       : in std_logic_vector(3 downto 0);
    aclk_x_reverse     : in std_logic;

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
      aclk_en   : in std_logic;
      aclk_init : in std_logic;

      aclk_last_data_in : in std_logic;
      aclk_data_in      : in std_logic_vector(63 downto 0);
      aclk_ben_in       : in std_logic_vector(7 downto 0);

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      aclk_empty          : out std_logic;
      aclk_data_valid_out : out std_logic;
      aclk_last_data_out  : out std_logic;
      aclk_data_out       : out std_logic_vector(63 downto 0);
      aclk_ben_out        : out std_logic_vector(7 downto 0)
      );
  end component;


  component x_trim_streamout is
    generic (
      NUMB_LINE_BUFFER    : integer range 2 to 4 := 2;
      CMD_FIFO_DATA_WIDTH : integer;
      BUFFER_ADDR_WIDTH   : integer;
      WORD_PTR_WIDTH      : integer              := 11;
      BUFF_PTR_WIDTH      : integer              := 1
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


  type STRM_CONTEXT_TYPE is record
    csc       : std_logic_vector(2 downto 0);
    x_crop_en : std_logic;
    x_start   : std_logic_vector(12 downto 0);
    x_size    : std_logic_vector(12 downto 0);
    x_scale   : std_logic_vector(3 downto 0);
    x_reverse : std_logic;
  end record STRM_CONTEXT_TYPE;


  constant INIT_STRM_CONTEXT_TYPE : STRM_CONTEXT_TYPE := (
    csc       => (others => '0'),
    x_crop_en => '0',
    x_start   => (others => '0'),
    x_size    => (others => '0'),
    x_scale   => (others => '0'),
    x_reverse => '0'
    );



  type FSM_TYPE is (S_IDLE, S_SOF, S_SOL, S_WRITE, S_FLUSH, S_EOL, S_DONE);


  --constant WORD_PTR_WIDTH      : integer := 9;
  constant WORD_PTR_WIDTH      : integer := 9 + (2*COLOR);
  constant BUFF_PTR_WIDTH      : integer := 1;
  constant CMD_FIFO_ADDR_WIDTH : integer := 1;
  constant CMD_FIFO_DATA_WIDTH : integer := 8 + 2 + WORD_PTR_WIDTH + BUFF_PTR_WIDTH;

  -- If in color mode the buffer needs to be 4x deeper (4 bytes/pix). This is
  -- why we add (2*COLOR) to the address width.
  constant BUFFER_ADDR_WIDTH : integer := BUFF_PTR_WIDTH + WORD_PTR_WIDTH;  -- in bits
  constant BUFFER_DATA_WIDTH : integer := 64;

  -----------------------------------------------------------------------------
  -- ACLK clock domain
  -----------------------------------------------------------------------------
  signal aclk_strm_context_in  : STRM_CONTEXT_TYPE;
  signal aclk_strm_context_P0  : STRM_CONTEXT_TYPE;
  signal aclk_strm_context_P1  : STRM_CONTEXT_TYPE;
  signal aclk_strm             : STRM_CONTEXT_TYPE;
  signal aclk_ld_strm_ctx      : std_logic_vector(1 downto 0);
  signal aclk_ld_strm_ctx_FF1  : std_logic_vector(1 downto 0);
  signal aclk_ld_strm_ctx_FF2  : std_logic_vector(1 downto 0);
  signal aclk_reset            : std_logic;
  signal aclk_state            : FSM_TYPE := S_IDLE;
  signal aclk_full             : std_logic;
  signal aclk_tready_int       : std_logic;
  signal aclk_init_word_ptr    : std_logic;
  signal aclk_word_ptr         : unsigned(WORD_PTR_WIDTH-1 downto 0);
  signal aclk_buffer_ptr       : unsigned(BUFF_PTR_WIDTH-1 downto 0);
  signal aclk_init_buffer_ptr  : std_logic;
  signal aclk_init_subsampling : std_logic;
  signal aclk_nxt_buffer       : std_logic;
  signal aclk_write_en         : std_logic;
  signal aclk_write_address    : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal aclk_write_data       : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal aclk_cmd_wen          : std_logic;
  signal aclk_cmd_full         : std_logic;
  signal aclk_cmd_data         : std_logic_vector(CMD_FIFO_DATA_WIDTH-1 downto 0);
  signal aclk_cmd_sync         : std_logic_vector(1 downto 0);
  signal aclk_cmd_size         : std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
  signal aclk_cmd_buff_ptr     : std_logic_vector(BUFF_PTR_WIDTH-1 downto 0);
  signal aclk_cmd_last_ben     : std_logic_vector(7 downto 0);
  signal aclk_pixel_width      : std_logic_vector(2 downto 0);

  signal aclk_ack         : std_logic;
  signal aclk_pix_cntr    : unsigned(12 downto 0);
  signal aclk_pix_incr    : integer range 0 to 8;
  signal aclk_valid_start : unsigned(aclk_pix_cntr'range);
  signal aclk_valid_stop  : unsigned(aclk_pix_cntr'range);

  signal aclk_crop_start         : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_stop          : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_size          : unsigned(aclk_pix_cntr'range);
  signal aclk_crop_stop_mask_sel : std_logic_vector(2 downto 0);
  signal aclk_crop_data_rdy      : std_logic;

  signal aclk_crop_window_valid  : std_logic;
  signal aclk_crop_packer        : std_logic_vector(127 downto 0);
  signal aclk_crop_packer_ben    : std_logic_vector(15 downto 0);
  signal aclk_crop_data_mux      : std_logic_vector(63 downto 0);
  signal aclk_crop_last_data_mux : std_logic;
  signal aclk_crop_ben_mux       : std_logic_vector(7 downto 0);
  signal aclk_crop_mux_sel       : std_logic_vector(2 downto 0);
  signal aclk_crop_packer_valid  : std_logic_vector(1 downto 0);

  signal aclk_subs_empty      : std_logic;
  signal aclk_subs_data_valid : std_logic;
  signal aclk_subs_last_data  : std_logic;
  signal aclk_subs_data       : std_logic_vector(63 downto 0);
  signal aclk_subs_ben        : std_logic_vector(7 downto 0);

  -----------------------------------------------------------------------------
  -- BCLK clock domain
  -----------------------------------------------------------------------------
  signal bclk_x_reverse_Meta : std_logic;
  signal bclk_x_reverse      : std_logic;
  signal bclk_pixel_width    : std_logic_vector(2 downto 0);

  signal bclk_reset : std_logic;
  signal bclk_full  : std_logic;


  signal bclk_read_address : std_logic_vector(BUFFER_ADDR_WIDTH-1 downto 0);
  signal bclk_read_en      : std_logic;
  signal bclk_read_data    : std_logic_vector(BUFFER_DATA_WIDTH-1 downto 0);
  signal bclk_buffer_rdy   : std_logic;
  signal bclk_cmd_ren      : std_logic;
  signal bclk_cmd_empty    : std_logic;
  signal bclk_cmd_data     : std_logic_vector(CMD_FIFO_DATA_WIDTH-1 downto 0);


  -----------------------------------------------------------------------------
  -- Debug attributes 
  -----------------------------------------------------------------------------
  -- attribute mark_debug of bclk_tready          : signal is "true";


begin

  aclk_reset  <= not aclk_reset_n;
  aclk_tready <= aclk_tready_int;


  -----------------------------------------------------------------------------
  -- Remap stream context from registerfile
  -----------------------------------------------------------------------------
  aclk_strm_context_in.csc       <= aclk_csc;
  aclk_strm_context_in.x_crop_en <= aclk_x_crop_en;
  aclk_strm_context_in.x_start   <= aclk_x_start;
  aclk_strm_context_in.x_size    <= aclk_x_size;
  aclk_strm_context_in.x_scale   <= aclk_x_scale;
  aclk_strm_context_in.x_reverse <= aclk_x_reverse;


  -----------------------------------------------------------------------------
  -- Stream context management
  --
  -- Les contextes doivent etre loades sur le rising edge du signal. Il a été allongé 
  -- a 4 clk sysclk ds le controlleur pour l'envoyer dans le domaine pclk.
  -----------------------------------------------------------------------------
  P_aclk_strm : process(aclk)
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_ld_strm_ctx_FF1 <= (others => '0');
        aclk_ld_strm_ctx_FF2 <= (others => '0');
        aclk_strm_context_P0 <= INIT_STRM_CONTEXT_TYPE;
        aclk_strm_context_P1 <= INIT_STRM_CONTEXT_TYPE;

      else
        aclk_ld_strm_ctx_FF1 <= aclk_load_context;
        aclk_ld_strm_ctx_FF2 <= aclk_ld_strm_ctx_FF1;


        -----------------------------------------------------------------------
        -- On rising edge of aclk_load_context(0) store aclk_strm_context_in
        -- in the pipelined version 0
        -----------------------------------------------------------------------
        if (aclk_ld_strm_ctx_FF2(0) = '0' and aclk_ld_strm_ctx_FF1(0) = '1') then
          aclk_strm_context_P0 <= aclk_strm_context_in;
        end if;


        -----------------------------------------------------------------------
        -- On rising edge of aclk_load_context(1) we shift the stream context
        -- of pipeline 0 to pipeline 1.
        -----------------------------------------------------------------------
        if (aclk_ld_strm_ctx_FF2(1) = '0' and aclk_ld_strm_ctx_FF1(1) = '1') then
          aclk_strm_context_P1 <= aclk_strm_context_P0;
        end if;


      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Stream context selection MUX
  -----------------------------------------------------------------------------
  aclk_strm <= aclk_strm_context_P1 when (aclk_grab_queue_en = '1') else
               aclk_strm_context_in;


  aclk_tready_int <= '1' when (aclk_state = S_IDLE and aclk_full = '0') else
                     '1' when (aclk_state = S_WRITE) else
                     '0';




  aclk_ack <= '1' when (aclk_tready_int = '1'and aclk_tvalid = '1') else
              '0';


  aclk_crop_start <= unsigned(aclk_strm.x_start(aclk_pix_cntr'range)) when (aclk_strm.x_crop_en = '1') else
                     (aclk_pix_cntr'range => '0');
  aclk_crop_size <= unsigned(aclk_strm.x_size(aclk_pix_cntr'range));
  aclk_crop_stop <= aclk_crop_start + aclk_crop_size -1 when (aclk_strm.x_crop_en = '1') else
                    (aclk_pix_cntr'range => '1');



  -----------------------------------------------------------------------------
  -- Calculate the number of bytes per pixels in function of the selected color
  -- space.the CSC value is a direct value from the field:
  --       regfile_xgs_athena.DMA.CSC.COLOR_SPACE[2:0]
  -----------------------------------------------------------------------------
  P_aclk_pixel_width : process (aclk_strm) is
  begin
    case aclk_strm.csc is
      -------------------------------------------------------------------------
      -- Mono 8 bits : 1 byte/pixel 
      -------------------------------------------------------------------------
      when "000" =>
        aclk_pixel_width <= "001";

      -------------------------------------------------------------------------
      -- BGR32 : 4 bytes/pixel
      -------------------------------------------------------------------------
      when "001" =>
        aclk_pixel_width <= "100";

      -------------------------------------------------------------------------
      -- YUV4:2:2 : 2 bytes/pixel 
      -------------------------------------------------------------------------
      when "010" =>
        aclk_pixel_width <= "010";

      -------------------------------------------------------------------------
      -- Planar 8 bits : 4 bytes/pixel 
      -------------------------------------------------------------------------
      when "011" =>
        aclk_pixel_width <= "100";

      -------------------------------------------------------------------------
      -- RAW : 4 bytes/pixel 
      -------------------------------------------------------------------------
      when "101" =>
        aclk_pixel_width <= "100";

      when others =>
        aclk_pixel_width <= "001";

    end case;
  end process;



  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_aclk_pixel_param : process (aclk_pixel_width, aclk_crop_start, aclk_crop_stop) is
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
  -- 
  -----------------------------------------------------------------------------
  P_aclk_crop_last_data_mux : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_crop_last_data_mux <= '0';
      else
        if (aclk_ack = '1' or aclk_state = S_FLUSH) then
          if (aclk_crop_packer_valid = "01") then
            aclk_crop_last_data_mux <= '1';
          else
            aclk_crop_last_data_mux <= '0';
          end if;
        else
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
            if (aclk_tvalid = '1' and aclk_tlast = '1') then
              if (aclk_crop_packer_valid /= "00" or aclk_subs_empty = '0') then
                aclk_state <= S_FLUSH;
              else
                aclk_state <= S_EOL;
              end if;
            end if;

          -------------------------------------------------------------------
          -- S_FLUSH : 
          -------------------------------------------------------------------
          when S_FLUSH =>
            if (aclk_crop_packer_valid = "00" and aclk_subs_empty = '1') then
              aclk_state <= S_EOL;

            else
              aclk_state <= S_FLUSH;
            end if;

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


  P_aclk_cmd_last_ben : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset = '1')then
        aclk_cmd_last_ben <= (others => '0');
      else
        if (aclk_init_subsampling = '1') then
          aclk_cmd_last_ben <= (others => '0');
        elsif (aclk_subs_last_data = '1' and aclk_subs_data_valid = '1') then
          aclk_cmd_last_ben <= aclk_subs_ben;
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


  aclk_init_subsampling <= '1' when (aclk_state = S_SOF or aclk_state = S_SOL) else
                           '0';


  x_trim_subsampling_inst : x_trim_subsampling
    port map (
      aclk                => aclk,
      aclk_reset          => aclk_reset,
      aclk_pixel_width    => aclk_pixel_width,
      aclk_x_subsampling  => aclk_strm.x_scale,
      aclk_en             => aclk_crop_data_rdy,
      aclk_init           => aclk_init_subsampling,
      aclk_last_data_in   => aclk_crop_last_data_mux,
      aclk_data_in        => aclk_crop_data_mux,
      aclk_ben_in         => aclk_crop_ben_mux,
      aclk_empty          => aclk_subs_empty,
      aclk_data_valid_out => aclk_subs_data_valid,
      aclk_last_data_out  => aclk_subs_last_data,
      aclk_data_out       => aclk_subs_data,
      aclk_ben_out        => aclk_subs_ben
      );


  aclk_write_address <= std_logic_vector(aclk_buffer_ptr & aclk_word_ptr);
  aclk_write_data    <= aclk_subs_data;

  aclk_write_en <= '1' when (aclk_subs_data_valid = '1') else
                   '0';


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


  -----------------------------------------------------------------------------
  -- Module      : M_bclk_buffer_rdy
  -- Description : Resynchronize aclk_nxt_buffer on bclk. This is a oclock
  --               pulse edge detect on bclk. 
  -----------------------------------------------------------------------------
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
  -- Description : Resynchronized version of aclk_strm.x_reverse on bclk
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!! This is a one bit flag so we use the 2FF
  -- resynchroniser to absorb Meta-stability.
  -----------------------------------------------------------------------------
  P_bclk_x_reverse : process (bclk) is
  begin
    if (rising_edge(bclk)) then
      if (bclk_reset = '1')then
        bclk_x_reverse      <= '0';
        bclk_x_reverse_Meta <= '0';
      else
        bclk_x_reverse_Meta <= aclk_strm.x_reverse;
        bclk_x_reverse      <= bclk_x_reverse_Meta;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING!!! This value is assumed to be a false path
  -- so it is assume to be safe domaine crossing.
  -----------------------------------------------------------------------------
  bclk_pixel_width <= aclk_pixel_width;


  x_trim_streamout_inst : x_trim_streamout
    generic map(
      NUMB_LINE_BUFFER    => NUMB_LINE_BUFFER,
      CMD_FIFO_DATA_WIDTH => CMD_FIFO_DATA_WIDTH,
      BUFFER_ADDR_WIDTH   => BUFFER_ADDR_WIDTH,
      WORD_PTR_WIDTH      => WORD_PTR_WIDTH,
      BUFF_PTR_WIDTH      => BUFF_PTR_WIDTH
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
