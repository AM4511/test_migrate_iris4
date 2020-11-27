-------------------------------------------------------------------------------
-- MODULE        : xgs_hispi_top
--
-- DESCRIPTION   : 
--
-- CLOCK DOMAINS : 
--                 
--                 
--
-- TODO          : Clarify clock domain crossing
--                 Add more explicit comments
--                 Connect x_row_start to registerfile
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.regfile_xgs_athena_pack.all;
use work.mtx_types_pkg.all;
use work.hispi_pack.all;


entity xgs_hispi_top is
  generic (
    HW_VERSION     : integer range 0 to 255 := 0;
    NUMBER_OF_LANE : integer                := 6  -- 4 or 6 lanes supported
    );
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    sclk         : in std_logic;
    sclk_reset_n : in std_logic;


    ---------------------------------------------------------------------------
    -- Registerfile clock domain
    ---------------------------------------------------------------------------
    rclk           : in    std_logic;
    rclk_reset_n   : in    std_logic;
    regfile        : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;
    rclk_irq_error : out   std_logic;


    ---------------------------------------------------------------------------
    -- XGS Controller I/F
    ---------------------------------------------------------------------------
    hispi_start_calibration  : in  std_logic;
    hispi_calibration_active : out std_logic;
    hispi_pix_clk            : out std_logic;
    hispi_eof                : out std_logic;
    hispi_ystart             : in  std_logic_vector(11 downto 0);
    hispi_ysize              : in  std_logic_vector(11 downto 0);


    ---------------------------------------------------------------------------
    -- Top HiSPI I/F
    ---------------------------------------------------------------------------
    idelay_clk      : in std_logic;
    hispi_io_clk_p  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_clk_n  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_data_p : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);
    hispi_io_data_n : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);


    ---------------------------------------------------------------------------
    -- AXI Master stream interface
    ---------------------------------------------------------------------------
    sclk_tready : in  std_logic;
    sclk_tvalid : out std_logic;
    sclk_tuser  : out std_logic_vector(3 downto 0);
    sclk_tlast  : out std_logic;
    sclk_tdata  : out PIXEL_ARRAY(7 downto 0)
    );
end entity xgs_hispi_top;


architecture rtl of xgs_hispi_top is


  component hispi_phy is
    generic (
      LANE_PER_PHY   : integer := 3;    -- Physical lane
      PIXEL_SIZE     : integer := 12;   -- Pixel size in bits
      WORD_PTR_WIDTH : integer := 6;
      PHY_ID         : integer := 0
      );
    port (
      ---------------------------------------------------------------------------
      -- HiSPi IO
      ---------------------------------------------------------------------------
      hispi_serial_clk_p   : in std_logic;
      hispi_serial_clk_n   : in std_logic;
      hispi_serial_input_p : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
      hispi_serial_input_n : in std_logic_vector(LANE_PER_PHY - 1 downto 0);


      ---------------------------------------------------------------------------
      -- To XGS_controller
      ---------------------------------------------------------------------------
      hispi_pix_clk : out std_logic;

      ---------------------------------------------------------------------------
      -- Registerfile clock domain
      ---------------------------------------------------------------------------
      rclk       : in    std_logic;
      rclk_reset : in    std_logic;
      regfile    : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

      ---------------------------------------------------------------------------
      -- System clock domain
      ---------------------------------------------------------------------------
      sclk                   : in  std_logic;
      sclk_reset             : in  std_logic;
      sclk_reset_phy         : in  std_logic;
      sclk_start_calibration : in  std_logic;
      sclk_calibration_done  : out std_logic;

      ---------------------------------------------------------------------------
      -- Sync
      ---------------------------------------------------------------------------
      sclk_sof : out std_logic_vector(LANE_PER_PHY - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Line buffer interface
      ---------------------------------------------------------------------------
      sclk_transfer_done   : in  std_logic;
      sclk_buffer_empty    : out std_logic_vector(LANE_PER_PHY - 1 downto 0);
      sclk_buffer_read_en  : in  std_logic;
      sclk_buffer_lane_id  : in  std_logic_vector(1 downto 0);
      sclk_buffer_mux_id   : in  std_logic_vector(1 downto 0);
      sclk_buffer_word_ptr : in  std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
      sclk_buffer_data     : out PIXEL_ARRAY(2 downto 0)
      );
  end component;


  component axi_line_streamer is
    generic (
      LANE_PER_PHY              : integer := 3;  -- Physical lane
      MUX_RATIO                 : integer := 4;
      LINE_BUFFER_PTR_WIDTH     : integer := 1;
      LINE_BUFFER_DATA_WIDTH    : integer := 64;
      LINE_BUFFER_ADDRESS_WIDTH : integer := 10
      );
    port (
      ---------------------------------------------------------------------------
      -- System clock interface
      ---------------------------------------------------------------------------
      sclk       : in std_logic;
      sclk_reset : in std_logic;

      ---------------------------------------------------------------------------
      -- Control interface
      ---------------------------------------------------------------------------
      streamer_en     : in  std_logic;
      streamer_busy   : out std_logic;
      init_frame      : in  std_logic;
      nb_lane_enabled : in  std_logic_vector(2 downto 0);
      frame_done      : out std_logic;

      ---------------------------------------------------------------------------
      -- Register interface (ROI parameters)
      ---------------------------------------------------------------------------
      x_start : in std_logic_vector(12 downto 0);
      x_stop  : in std_logic_vector(12 downto 0);
      y_start : in std_logic_vector(11 downto 0);
      y_size  : in std_logic_vector(11 downto 0);

      ---------------------------------------------------------------------------
      -- Lane_decode I/F
      ---------------------------------------------------------------------------
      sclk_transfer_done   : out std_logic;
      sclk_buffer_lane_id  : out std_logic_vector(1 downto 0);
      sclk_buffer_mux_id   : out std_logic_vector(1 downto 0);
      sclk_buffer_word_ptr : out std_logic_vector(5 downto 0);
      sclk_buffer_read_en  : out std_logic;

      -- Even lanes
      sclk_buffer_empty_top : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
      sclk_buffer_data_top  : in PIXEL_ARRAY(2 downto 0);

      -- Odd lanes
      sclk_buffer_empty_bottom : in std_logic_vector(LANE_PER_PHY - 1 downto 0);
      sclk_buffer_data_bottom  : in PIXEL_ARRAY(2 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      sclk_tready : in  std_logic;
      sclk_tvalid : out std_logic;
      sclk_tuser  : out std_logic_vector(3 downto 0);
      sclk_tlast  : out std_logic;
      sclk_tdata  : out PIXEL_ARRAY(7 downto 0)
      );
  end component;


  constant C_S_AXI_ADDR_WIDTH : integer              := 8;
  constant C_S_AXI_DATA_WIDTH : integer              := 32;
  constant NUMB_LINE_BUFFER   : integer range 2 to 4 := 4;
  constant LANE_PER_PHY       : integer              := NUMBER_OF_LANE/2;
  constant MUX_RATIO          : integer              := 4;

  constant LINE_BUFFER_DATA_WIDTH    : integer := 64;
  constant LINE_BUFFER_ADDRESS_WIDTH : integer := 11;
  constant LINE_BUFFER_PTR_WIDTH     : integer := 2;
  constant PIXEL_SIZE                : integer := 12;  -- Pixel size in bits
  constant WORD_PTR_WIDTH            : integer := 6;



  type FSM_TYPE is (S_DISABLED,
                    S_RESET_PHY,
                    S_IDLE,
                    S_START_CALIBRATION,
                    S_CALIBRATE,
                    S_SOF,
                    S_FRAME,
                    S_EOF,
                    S_DONE);

  signal rclk_reset          : std_logic;
  signal rclk_irq_error_vect : std_logic_vector(3 downto 0);

  signal sclk_reset     : std_logic;
  signal sclk_reset_phy : std_logic;

  signal sclk_pll_locked_Meta : std_logic;
  signal sclk_pll_locked      : std_logic;

  signal sclk_calibration_req         : std_logic;
  signal sclk_calibration_pending     : std_logic;
  signal sclk_start_calibration       : std_logic;
  signal sclk_calibration_done        : std_logic_vector(1 downto 0);
  signal sclk_xgs_ctrl_calib_req_Meta : std_logic;
  signal sclk_xgs_ctrl_calib_req      : std_logic;

  signal top_lanes_p    : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_lanes_n    : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal sof_flag       : std_logic;
  signal bottom_lanes_p : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_lanes_n : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal state          : FSM_TYPE := S_IDLE;
  signal state_mapping  : std_logic_vector(3 downto 0);

  signal sclk_transfer_done       : std_logic;
  signal sclk_buffer_read_en      : std_logic;
  signal sclk_buffer_lane_id      : std_logic_vector(1 downto 0);
  signal sclk_buffer_mux_id       : std_logic_vector(1 downto 0);
  signal sclk_buffer_word_ptr     : std_logic_vector(WORD_PTR_WIDTH-1 downto 0);
  signal sclk_sof_top             : std_logic_vector(LANE_PER_PHY - 1 downto 0);
  signal sclk_buffer_data_top     : PIXEL_ARRAY(2 downto 0);
  signal sclk_buffer_data_bottom  : PIXEL_ARRAY(2 downto 0);
  signal sclk_buffer_empty_top    : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal sclk_buffer_empty_bottom : std_logic_vector(LANE_PER_PHY-1 downto 0);


  signal sclk_x_start : std_logic_vector(12 downto 0);
  signal sclk_x_stop  : std_logic_vector(12 downto 0);
  signal sclk_y_start : std_logic_vector(11 downto 0);
  signal sclk_y_size  : std_logic_vector(11 downto 0);

  signal init_frame      : std_logic;
  signal frame_done      : std_logic;
  signal nb_lane_enabled : std_logic_vector(2 downto 0);
  signal enable_hispi    : std_logic;

  -- Status lane decoder (sldec)
  signal aggregated_fifo_overrun   : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_fifo_underrun  : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_cal_error      : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_sync_error     : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_crc_error      : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_bit_lock_error : std_logic_vector(NUMBER_OF_LANE-1 downto 0);

  -- Status lane packer (slpack)
  signal fifo_error : std_logic;
  signal crc_error  : std_logic;

  signal hispi_eof_pulse : std_logic_vector(2 downto 0);
  
begin

  rclk_reset <= not rclk_reset_n;

  -----------------------------------------------------------------------------
  -- Registerfile mapping
  -----------------------------------------------------------------------------
  sclk_reset <= (not sclk_reset_n) or regfile.HISPI.CTRL.SW_CLR_HISPI;

  enable_hispi    <= regfile.HISPI.CTRL.ENABLE_HISPI;
  nb_lane_enabled <= regfile.HISPI.PHY.NB_LANES;


  sclk_calibration_req <= '1' when (regfile.HISPI.CTRL.SW_CALIB_SERDES = '1') else
                          '1' when (sclk_xgs_ctrl_calib_req = '1') else
                          '0';


  G_lane_decoder_status : for i in 0 to NUMBER_OF_LANE-1 generate
    -- Flag bits aggregation
    aggregated_sync_error(i)     <= regfile.HISPI.LANE_DECODER_STATUS(i).PHY_SYNC_ERROR;
    aggregated_fifo_overrun(i)   <= regfile.HISPI.LANE_DECODER_STATUS(i).FIFO_OVERRUN;
    aggregated_fifo_underrun(i)  <= regfile.HISPI.LANE_DECODER_STATUS(i).FIFO_UNDERRUN;
    aggregated_cal_error(i)      <= regfile.HISPI.LANE_DECODER_STATUS(i).CALIBRATION_ERROR;
    aggregated_bit_lock_error(i) <= regfile.HISPI.LANE_DECODER_STATUS(i).PHY_BIT_LOCKED_ERROR;
    aggregated_crc_error(i)      <= regfile.HISPI.LANE_DECODER_STATUS(i).CRC_ERROR;
  end generate G_lane_decoder_status;



  -----------------------------------------------------------------------------
  -- Process     : P_rclk_irq_error_vect
  -- Description : Pulse genertor using the shift left vector technic
  -----------------------------------------------------------------------------
  P_rclk_irq_error_vect : process (rclk) is
    variable left : integer := rclk_irq_error_vect'left;
  begin
    if (rising_edge(rclk)) then
      if (rclk_reset = '1') then
        rclk_irq_error_vect <= (others => '0');
      else
        if ((regfile.HISPI.STATUS.FIFO_ERROR = '1') or
            (regfile.HISPI.STATUS.CALIBRATION_ERROR = '1') or
            (regfile.HISPI.STATUS.PHY_BIT_LOCKED_ERROR = '1')or
            (regfile.HISPI.STATUS.CRC_ERROR = '1'))
        then
          -- Set the pulse vect
          rclk_irq_error_vect <= (others => '1');
        else
          -- Shift '0' left
          rclk_irq_error_vect <= rclk_irq_error_vect(left-1 downto 0) & '0';
        end if;
      end if;
    end if;
  end process;



  rclk_irq_error <= rclk_irq_error_vect(rclk_irq_error_vect'left);


  crc_error <= '1' when (aggregated_crc_error /= (aggregated_crc_error'range => '0')) else
               '0';


  regfile.HISPI.STATUS.CRC_ERROR <= crc_error;


  fifo_error <= '1' when (aggregated_fifo_overrun /= (aggregated_fifo_overrun'range => '0')) else
                '1' when (aggregated_fifo_underrun /= (aggregated_fifo_underrun'range => '0')) else
                '0';


  regfile.HISPI.STATUS.FIFO_ERROR <= fifo_error;


  regfile.HISPI.STATUS.CALIBRATION_ERROR <= '1' when (aggregated_cal_error /= (aggregated_cal_error'range => '0')) else
                                            '0';


  regfile.HISPI.STATUS.CALIBRATION_DONE <= '1' when (sclk_calibration_done = "11") else
                                           '0';

  regfile.HISPI.STATUS.PHY_BIT_LOCKED_ERROR <= '1' when (aggregated_bit_lock_error /= (aggregated_cal_error'range => '0')) else
                                               '0';

  regfile.HISPI.STATUS.FSM <= state_mapping;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_roi
  -- Description : 
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING??
  -----------------------------------------------------------------------------
  P_sclk_roi : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_x_start <= (others => '0');
        sclk_x_stop  <= (others => '0');
        sclk_y_start <= (others => '0');
        sclk_y_size  <= (others => '0');
      else
        if (sof_flag = '1') then
          sclk_x_start <= regfile.HISPI.FRAME_CFG_X_VALID.X_START;
          sclk_x_stop  <= regfile.HISPI.FRAME_CFG_X_VALID.X_END;
          sclk_y_start <= hispi_ystart;
          sclk_y_size  <= hispi_ysize;
        end if;
      end if;
    end if;
  end process;

  
  -----------------------------------------------------------------------------
  -- Process     : P_sclk_xgs_ctrl_calib_req
  -- Description : Flag sent by the XGS_controller to initiate a calibrartion
  --               sequence
  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING??
  -----------------------------------------------------------------------------
  P_sclk_xgs_ctrl_calib_req : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_xgs_ctrl_calib_req_Meta <= '0';
        sclk_xgs_ctrl_calib_req      <= '0';
      else
        sclk_xgs_ctrl_calib_req_Meta <= hispi_start_calibration;
        sclk_xgs_ctrl_calib_req      <= sclk_xgs_ctrl_calib_req_Meta;
      end if;
    end if;
  end process;


  sclk_start_calibration <= '1' when (state = S_START_CALIBRATION) else
                            '0';


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_pll_locked
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_pll_locked : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_pll_locked_Meta <= '0';
        sclk_pll_locked      <= '0';
      else
        sclk_pll_locked_Meta <= regfile.HISPI.IDELAYCTRL_STATUS.PLL_LOCKED;
        sclk_pll_locked      <= sclk_pll_locked_Meta;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_calibration_active
  -- Description : 
  -----------------------------------------------------------------------------
  P_hispi_calibration_active : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        hispi_calibration_active <= '0';
      else
        if (state = S_CALIBRATE) then
          hispi_calibration_active <= '1';
        else
          hispi_calibration_active <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_calibration_pending
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_calibration_pending : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sclk_calibration_pending <= '0';
      else
        if (state = S_CALIBRATE) then
          sclk_calibration_pending <= '0';
        elsif (sclk_calibration_req = '1') then
          sclk_calibration_pending <= '1';
        end if;
      end if;
    end if;
  end process;




  -----------------------------------------------------------------------------
  -- HiSPi lane remapping
  -----------------------------------------------------------------------------
  G_lanes : for i in 0 to NUMBER_OF_LANE/2 - 1 generate
    -- Top lanes are the even ID lanes (Lanes 0,2,4)
    top_lanes_p(i) <= hispi_io_data_p(2*i);
    top_lanes_n(i) <= hispi_io_data_n(2*i);

    -- Bottom lanes are the odd ID lanes (Lanes 1,3,5)
    bottom_lanes_p(i) <= hispi_io_data_p(2*i+1);
    bottom_lanes_n(i) <= hispi_io_data_n(2*i+1);
  end generate G_lanes;


  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : TOP lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor top lanes.
  -----------------------------------------------------------------------------
  xhispi_phy_top : hispi_phy
    generic map(
      LANE_PER_PHY   => LANE_PER_PHY,
      PIXEL_SIZE     => PIXEL_SIZE,
      WORD_PTR_WIDTH => WORD_PTR_WIDTH,
      PHY_ID         => 0
      )
    port map(
      hispi_serial_clk_p     => hispi_io_clk_p(0),
      hispi_serial_clk_n     => hispi_io_clk_n(0),
      hispi_serial_input_p   => top_lanes_p,
      hispi_serial_input_n   => top_lanes_n,
      hispi_pix_clk          => hispi_pix_clk,
      rclk                   => rclk,
      rclk_reset             => rclk_reset,
      regfile                => regfile,
      sclk                   => sclk,
      sclk_reset             => sclk_reset,
      sclk_reset_phy         => sclk_reset_phy,
      sclk_start_calibration => sclk_start_calibration,
      sclk_calibration_done  => sclk_calibration_done(0),
      sclk_sof               => sclk_sof_top,
      sclk_transfer_done     => sclk_transfer_done,
      sclk_buffer_empty      => sclk_buffer_empty_top,
      sclk_buffer_read_en    => sclk_buffer_read_en,
      sclk_buffer_lane_id    => sclk_buffer_lane_id,
      sclk_buffer_mux_id     => sclk_buffer_mux_id,
      sclk_buffer_word_ptr   => sclk_buffer_word_ptr,
      sclk_buffer_data       => sclk_buffer_data_top
      );


  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : Bottom lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor bottom lanes.
  -----------------------------------------------------------------------------
  xhispi_phy_bottom : hispi_phy
    generic map(
      LANE_PER_PHY   => LANE_PER_PHY,
      PIXEL_SIZE     => PIXEL_SIZE,
      WORD_PTR_WIDTH => WORD_PTR_WIDTH,
      PHY_ID         => 1
      )
    port map(
      hispi_serial_clk_p     => hispi_io_clk_p(1),
      hispi_serial_clk_n     => hispi_io_clk_n(1),
      hispi_serial_input_p   => bottom_lanes_p,
      hispi_serial_input_n   => bottom_lanes_n,
      hispi_pix_clk          => open,
      rclk                   => rclk,
      rclk_reset             => rclk_reset,
      regfile                => regfile,
      sclk                   => sclk,
      sclk_reset             => sclk_reset,
      sclk_reset_phy         => sclk_reset_phy,
      sclk_start_calibration => sclk_start_calibration,
      sclk_calibration_done  => sclk_calibration_done(1),
      sclk_sof               => open,
      sclk_transfer_done     => sclk_transfer_done,
      sclk_buffer_empty      => sclk_buffer_empty_bottom,
      sclk_buffer_read_en    => sclk_buffer_read_en,
      sclk_buffer_lane_id    => sclk_buffer_lane_id,
      sclk_buffer_mux_id     => sclk_buffer_mux_id,
      sclk_buffer_word_ptr   => sclk_buffer_word_ptr,
      sclk_buffer_data       => sclk_buffer_data_bottom
      );



  -----------------------------------------------------------------------------
  -- Process     : P_sof_flag
  -- Description : 
  -----------------------------------------------------------------------------
  P_sof_flag : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        sof_flag <= '0';
      else
        if (state = S_IDLE and sclk_sof_top(0) = '1') then
          sof_flag <= '1';
        else
          sof_flag <= '0';
        end if;
      end if;
    end if;
  end process;

  -- synthesis translate_off
  assert (not(state /= S_IDLE and sclk_sof_top(0) = '1')) report "Detected SOF when not IDLE" severity error;
  -- synthesis translate_on


  -----------------------------------------------------------------------------
  -- Process     : P_sclk_reset_phy
  -- Description : 
  -----------------------------------------------------------------------------
  P_sclk_reset_phy : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        sclk_reset_phy <= '0';
      else
        if (state = S_RESET_PHY) then
          sclk_reset_phy <= '1';
        else
          sclk_reset_phy <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_state
  -- Description : Main FSM
  -----------------------------------------------------------------------------
  P_state : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1' or enable_hispi = '0') then
        state <= S_DISABLED;
      else
        case state is
          ---------------------------------------------------------------------
          -- S_DISABLED : 
          ---------------------------------------------------------------------
          when S_DISABLED =>
            state <= S_RESET_PHY;

          ---------------------------------------------------------------------
          -- S_RESET_PHY : Reset the HiSPI PHY until the PLL is locked
          ---------------------------------------------------------------------
          when S_RESET_PHY =>
            if (sclk_pll_locked = '1') then
              state <= S_IDLE;
            else
              state <= S_RESET_PHY;
            end if;

          ---------------------------------------------------------------------
          -- S_IDLE : Parking state (Wait for a frame or PHY calibration req.)
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (sclk_calibration_pending = '1') then
              state <= S_START_CALIBRATION;
            elsif (sof_flag = '1') then
              state <= S_SOF;
            end if;

          ---------------------------------------------------------------------
          -- S_START_CALIBRATION : 
          ---------------------------------------------------------------------
          when S_START_CALIBRATION =>
            state <= S_CALIBRATE;

          ---------------------------------------------------------------------
          -- S_CALIBRATE : 
          ---------------------------------------------------------------------
          when S_CALIBRATE =>
            if (sclk_calibration_done = "11") then
              state <= S_IDLE;
            else
              state <= S_CALIBRATE;
            end if;

          ---------------------------------------------------------------------
          -- S_SOF : Initialize the IP state
          ---------------------------------------------------------------------
          when S_SOF =>
            state <= S_FRAME;

          ---------------------------------------------------------------------
          -- S_FRAME : Pack incomming data from the XGS sensor to form lines
          --          in the line buffer.
          ---------------------------------------------------------------------
          when S_FRAME =>
            if (frame_done = '1') then
              state <= S_EOF;
            else
              state <= S_FRAME;

            end if;

          ---------------------------------------------------------------------
          -- S_EOF : End of frame detected
          ---------------------------------------------------------------------
          when S_EOF =>
            state <= S_DONE;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when S_DONE =>
            state <= S_IDLE;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when others =>
            null;
        end case;
      end if;
    end if;
  end process P_state;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_eof_pulse
  -- Description : 
  -----------------------------------------------------------------------------
  P_hispi_eof_pulse : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
         hispi_eof_pulse <= (others => '0');
      else
       if (state = S_EOF) then
         hispi_eof_pulse <= (others => '1');
       else
         hispi_eof_pulse <= hispi_eof_pulse(1 downto 0) & '0';
       end if;
      end if;
    end if;
  end process;

  
  hispi_eof<= hispi_eof_pulse(2);

  
  -- hispi_eof <= '1' when (state = S_EOF) else
  --              '0';


  init_frame <= '1' when (state = S_SOF) else
                '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  xaxi_line_streamer : axi_line_streamer
    generic map(
      LANE_PER_PHY              => LANE_PER_PHY,
      MUX_RATIO                 => MUX_RATIO,
      LINE_BUFFER_PTR_WIDTH     => LINE_BUFFER_PTR_WIDTH,
      LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
      LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH
      )
    port map (
      sclk                     => sclk,
      sclk_reset               => sclk_reset,
      streamer_en              => '1',
      streamer_busy            => open,
      init_frame               => init_frame,
      frame_done               => frame_done,
      nb_lane_enabled          => nb_lane_enabled,
      x_start                  => sclk_x_start,
      x_stop                   => sclk_x_stop,
      y_start                  => sclk_y_start,
      y_size                   => sclk_y_size,
      sclk_transfer_done       => sclk_transfer_done,
      sclk_buffer_lane_id      => sclk_buffer_lane_id,
      sclk_buffer_mux_id       => sclk_buffer_mux_id,
      sclk_buffer_word_ptr     => sclk_buffer_word_ptr,
      sclk_buffer_read_en      => sclk_buffer_read_en,
      sclk_buffer_empty_top    => sclk_buffer_empty_top,
      sclk_buffer_data_top     => sclk_buffer_data_top,
      sclk_buffer_empty_bottom => sclk_buffer_empty_bottom,
      sclk_buffer_data_bottom  => sclk_buffer_data_bottom,
      sclk_tready              => sclk_tready,
      sclk_tvalid              => sclk_tvalid,
      sclk_tuser               => sclk_tuser,
      sclk_tlast               => sclk_tlast,
      sclk_tdata               => sclk_tdata
      );


  P_state_mapping : process (state) is
  begin
    case state is
      when S_DISABLED          => state_mapping <= "0000";
      when S_RESET_PHY         => state_mapping <= "0001";
      when S_IDLE              => state_mapping <= "0010";
      when S_START_CALIBRATION => state_mapping <= "0011";
      when S_CALIBRATE         => state_mapping <= "0100";
      when S_SOF               => state_mapping <= "0101";
      when S_FRAME             => state_mapping <= "0110";
      when S_EOF               => state_mapping <= "0111";
      when S_DONE              => state_mapping <= "1000";
      when others              => state_mapping <= "1111";  --Reserved
    end case;
  end process;

end architecture rtl;
