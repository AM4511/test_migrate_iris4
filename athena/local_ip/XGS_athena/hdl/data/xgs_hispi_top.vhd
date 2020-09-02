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
    sclk_tdata  : out std_logic_vector(63 downto 0)
    );
end entity xgs_hispi_top;


architecture rtl of xgs_hispi_top is


  component hispi_phy is
    generic (
      LANE_PER_PHY : integer := 3;      -- Physical lane
      PIXEL_SIZE   : integer := 12;     -- Pixel size in bits
      PHY_ID       : integer := 0
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
      -- sclk clock domain
      ---------------------------------------------------------------------------
      sclk                   : in  std_logic;
      sclk_reset             : in  std_logic;
      sclk_reset_phy         : in  std_logic;
      sclk_start_calibration : in  std_logic;
      sclk_calibration_done  : out std_logic;

      -- Read fifo interface
      sclk_fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);

      -- Flags 
      sclk_sof_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_eof_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_sol_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sclk_eol_flag : out std_logic_vector(LANE_PER_PHY-1 downto 0)
      );
  end component;


  component lane_packer is
    generic (
      LANE_PACKER_ID            : integer := 0;
      LINE_BUFFER_DATA_WIDTH    : integer := 64;
      LINE_BUFFER_ADDRESS_WIDTH : integer := 11
      );
    port (
      ---------------------------------------------------------------------------
      -- Registerfile  clock domain
      ---------------------------------------------------------------------------
      rclk       : in    std_logic;
      rclk_reset : in    std_logic;
      regfile    : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

      ---------------------------------------------------------------------------
      -- sclk clock domain
      ---------------------------------------------------------------------------
      sclk       : in std_logic;
      sclk_reset : in std_logic;

      enable         : in  std_logic;
      init_packer    : in  std_logic;
      odd_line       : in  std_logic;
      line_valid     : in  std_logic;
      busy           : out std_logic;
      line_buffer_id : in  std_logic_vector(1 downto 0);

      -- Top Lane
      top_sync                 : in  std_logic_vector(3 downto 0);
      top_fifo_read_en         : out std_logic;
      top_fifo_empty           : in  std_logic;
      top_fifo_read_data_valid : in  std_logic;
      top_fifo_read_data       : in  std_logic_vector(31 downto 0);

      -- Bottom Lane
      bottom_sync                 : in  std_logic_vector(3 downto 0);
      bottom_fifo_read_en         : out std_logic;
      bottom_fifo_empty           : in  std_logic;
      bottom_fifo_read_data_valid : in  std_logic;
      bottom_fifo_read_data       : in  std_logic_vector(31 downto 0);

      -- Line buffer interface
      lane_packer_ack   : in  std_logic;
      lane_packer_req   : out std_logic;
      lane_packer_write : out std_logic;
      lane_packer_addr  : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      lane_packer_data  : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
      );
  end component;


  component line_buffer is
    generic (
      NUMB_LINE_BUFFER          : integer range 2 to 4 := 2;
      LINE_BUFFER_PTR_WIDTH     : integer              := 1;
      LINE_BUFFER_ADDRESS_WIDTH : integer              := 11;
      LINE_BUFFER_DATA_WIDTH    : integer              := 64;
      NUMB_LANE_PACKER          : integer              := 3
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: System
      -- Description: 
      ------------------------------------------------------------------------------------
      row_id        : in std_logic_vector(11 downto 0);
      buffer_enable : in std_logic;
      init_frame    : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: Buffer control
      -- Description: 
      ------------------------------------------------------------------------------------
      nxtBuffer       : in std_logic;
      line_buffer_clr : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      lane_packer_req : in  std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      lane_packer_ack : out std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
      buff_write      : in  std_logic;
      buff_addr       : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      buff_data       : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      line_buffer_ready   : out std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
      line_buffer_read    : in  std_logic;
      line_buffer_ptr     : in  std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
      line_buffer_address : in  std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      line_buffer_row_id  : out std_logic_vector(11 downto 0);
      line_buffer_data    : out std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0)
      );
  end component;


  component axi_line_streamer is
    generic (
      NUMB_LINE_BUFFER          : integer;
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
      streamer_en    : in  std_logic;
      streamer_busy  : out std_logic;
      transfert_done : out std_logic;
      init_frame     : in  std_logic;

      ---------------------------------------------------------------------------
      -- Register interface
      ---------------------------------------------------------------------------
      x_row_start : in std_logic_vector(12 downto 0);
      x_row_stop  : in std_logic_vector(12 downto 0);
      y_row_start : in std_logic_vector(11 downto 0);
      y_row_stop  : in std_logic_vector(11 downto 0);

      ---------------------------------------------------------------------------
      -- Line buffer I/F
      ---------------------------------------------------------------------------
      line_buffer_clr     : out std_logic;
      line_buffer_ready   : in  std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
      line_buffer_read    : out std_logic;
      line_buffer_ptr     : out std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
      line_buffer_address : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      line_buffer_row_id  : in  std_logic_vector(11 downto 0);
      line_buffer_data    : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      sclk_tready : in  std_logic;
      sclk_tvalid : out std_logic;
      sclk_tuser  : out std_logic_vector(3 downto 0);
      sclk_tlast  : out std_logic;
      sclk_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;


  constant C_S_AXI_ADDR_WIDTH : integer              := 8;
  constant C_S_AXI_DATA_WIDTH : integer              := 32;
  constant NUMB_LINE_BUFFER   : integer range 2 to 4 := 4;
  constant LANE_PER_PHY       : integer              := NUMBER_OF_LANE/2;

  constant LINE_BUFFER_DATA_WIDTH    : integer := 64;
  constant LINE_BUFFER_ADDRESS_WIDTH : integer := 11;
  constant LINE_BUFFER_PTR_WIDTH     : integer := 2;
  constant NUMB_LANE_PACKER          : integer := NUMBER_OF_LANE/2;
  constant PIXEL_SIZE                : integer := 12;  -- Pixel size in bits



  type FSM_TYPE is (S_IDLE, S_DISABLED, S_RESET_PHY, S_INIT, S_START_CALIBRATION, S_CALIBRATE, S_PACK, S_SOF, S_EOF, S_SOL, S_EOL, S_FLUSH_PACKER, S_DONE);

  type PACKER_DATA_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  type PACKER_ADDR_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);

  type PACKER_INFO_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(3 downto 0);

  signal rclk_reset          : std_logic;
  signal rclk_irq_error_vect : std_logic_vector(3 downto 0);
  signal sclk_reset          : std_logic;
  signal new_line_pending    : std_logic;
  signal new_frame_pending   : std_logic;

  signal sclk_reset_phy : std_logic;

  signal sclk_pll_locked_Meta : std_logic;
  signal sclk_pll_locked      : std_logic;

  signal sclk_calibration_req         : std_logic;
  signal sclk_calibration_pending     : std_logic;
  signal sclk_start_calibration       : std_logic;
  signal sclk_calibration_done        : std_logic_vector(1 downto 0);
  signal sclk_cal_error               : std_logic_vector(2*LANE_PER_PHY-1 downto 0);
  signal sclk_xgs_ctrl_calib_req_Meta : std_logic;
  signal sclk_xgs_ctrl_calib_req      : std_logic;
  signal top_cal_done                 : std_logic;

  signal top_lanes_p                 : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_lanes_n                 : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sof_flag                : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eof_flag                : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sol_flag                : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eol_flag                : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_en            : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_empty              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data_valid    : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data          : std32_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_cal_done             : std_logic;
  signal bottom_lanes_p              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_lanes_n              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_en         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_empty           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data_valid : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data       : std32_logic_vector(LANE_PER_PHY-1 downto 0);
  signal state                       : FSM_TYPE := S_IDLE;
  signal state_mapping               : std_logic_vector(3 downto 0);

  signal row_id           : std_logic_vector(11 downto 0);
  signal row_last         : std_logic;
  signal packer_busy      : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal all_packer_idle  : std_logic;
  signal init_lane_packer : std_logic;


  signal line_buffer_id       : std_logic_vector(1 downto 0);
  signal packer_fifo_overrun  : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal packer_fifo_underrun : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);

  signal frame_cntr : integer;
  signal line_cntr  : unsigned(11 downto 0);
  signal line_valid : std_logic;

  signal transfert_done : std_logic;
  signal init_frame     : std_logic;

  signal lane_packer_ack    : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_req    : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_write  : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_addr   : PACKER_ADDR_ARRAY_TYPE;
  signal lane_packer_data   : PACKER_DATA_ARRAY_TYPE;
  signal lane_packer_enable : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);

  signal nxtBuffer         : std_logic;
  signal line_buffer_clr   : std_logic;
  signal line_buffer_ready : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

  signal buff_write : std_logic;
  signal buff_addr  : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal buff_data  : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

  signal sync            : std_logic_vector(1 downto 0);
  signal hispi_eof_pulse : std_logic_vector(3 downto 0);
  signal buffer_enable   : std_logic;
  signal x_row_start     : std_logic_vector(12 downto 0);
  signal x_row_stop      : std_logic_vector(12 downto 0);
  signal y_row_start     : std_logic_vector(11 downto 0);
  signal y_row_stop      : std_logic_vector(11 downto 0);

  signal line_buffer_read    : std_logic;
  signal line_buffer_ptr     : std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal line_buffer_address : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal line_buffer_row_id  : std_logic_vector(11 downto 0);
  signal line_buffer_data    : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

  -- register mapping signals
  signal enable_hispi : std_logic;

  -- Status lane decoder (sldec)
  signal aggregated_fifo_overrun  : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_fifo_underrun : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_cal_error     : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_sync_error    : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal aggregated_crc_error     : std_logic_vector(NUMBER_OF_LANE-1 downto 0);

  -- Status lane packer (slpack)
  signal aggregated_packer_fifo_overrun  : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal aggregated_packer_fifo_underrun : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal fifo_error                      : std_logic;
  signal crc_error                       : std_logic;

  signal aggregated_bit_lock_error : std_logic_vector(NUMBER_OF_LANE-1 downto 0);
  signal nb_lane_enabled           : std_logic_vector(2 downto 0);

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


  G_lane_packer_status : for i in 0 to NUMB_LANE_PACKER-1 generate
    aggregated_packer_fifo_overrun(i)  <= regfile.HISPI.LANE_PACKER_STATUS(i).FIFO_OVERRUN;
    aggregated_packer_fifo_underrun(i) <= regfile.HISPI.LANE_PACKER_STATUS(i).FIFO_UNDERRUN;
  end generate G_lane_packer_status;



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


  crc_error <=  '1' when (aggregated_crc_error /= (aggregated_crc_error'range => '0')) else
                '0';

  
  regfile.HISPI.STATUS.CRC_ERROR <= crc_error;


  fifo_error <= '1' when (aggregated_fifo_overrun /= (aggregated_fifo_overrun'range => '0')) else
                '1' when (aggregated_fifo_underrun /= (aggregated_fifo_underrun'range               => '0')) else
                '1' when (aggregated_packer_fifo_overrun /= (aggregated_packer_fifo_overrun'range   => '0')) else
                '1' when (aggregated_packer_fifo_underrun /= (aggregated_packer_fifo_underrun'range => '0')) else
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
  -- Process     : P_x_row_start
  -- Description : Units in pixels
  -----------------------------------------------------------------------------
  P_x_row_start : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        x_row_start <= (others => '0');
      else
        if (state = S_SOF) then
          --ToDO should come from register
          x_row_start <= regfile.HISPI.FRAME_CFG_X_VALID.X_START;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_row_stop
  -- Description : Units in pixels
  -----------------------------------------------------------------------------
  P_x_row_stop : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        x_row_stop <= (others => '0');
      else
        if (state = S_SOF) then
          x_row_stop <= regfile.HISPI.FRAME_CFG_X_VALID.X_END;
        end if;
      end if;
    end if;
  end process;



  -----------------------------------------------------------------------------
  -- Process     : P_row_start
  -- Description : 
  -----------------------------------------------------------------------------
  P_y_row_start : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        y_row_start <= (others => '0');
      else
        if (state = S_SOF) then
          y_row_start <= hispi_ystart;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_row_stop
  -- Description :
  -----------------------------------------------------------------------------
  P_y_row_stop : process (sclk) is
    variable start : unsigned(11 downto 0);
    variable size  : unsigned(11 downto 0);
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        y_row_stop <= (others => '0');
      else
        if (state = S_SOF) then
          start      := unsigned(hispi_ystart);
          size       := unsigned(hispi_ysize);
          y_row_stop <= std_logic_vector(start + (size - 1));
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



  -- TBD : manage line valid, RoI, embeded data
  line_valid <= '1';

  -- TBD : manage buffer control
  buffer_enable <= '1';




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
  xtop_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE,
      PHY_ID       => 0
      )
    port map(
      hispi_serial_clk_p        => hispi_io_clk_p(0),
      hispi_serial_clk_n        => hispi_io_clk_n(0),
      hispi_serial_input_p      => top_lanes_p,
      hispi_serial_input_n      => top_lanes_n,
      hispi_pix_clk             => hispi_pix_clk,
      rclk                      => rclk,
      rclk_reset                => rclk_reset,
      regfile                   => regfile,
      sclk                      => sclk,
      sclk_reset                => sclk_reset,
      sclk_reset_phy            => sclk_reset_phy,
      sclk_start_calibration    => sclk_start_calibration,
      sclk_calibration_done     => sclk_calibration_done(0),
      sclk_fifo_read_en         => top_fifo_read_en,
      sclk_fifo_empty           => top_fifo_empty,
      sclk_fifo_read_data_valid => top_fifo_read_data_valid,
      sclk_fifo_read_data       => top_fifo_read_data,
      sclk_sof_flag             => top_sof_flag,
      sclk_eof_flag             => top_eof_flag,
      sclk_sol_flag             => top_sol_flag,
      sclk_eol_flag             => top_eol_flag
      );


  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : Bottom lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor bottom lanes.
  -----------------------------------------------------------------------------
  xbottom_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE,
      PHY_ID       => 1
      )
    port map(
      hispi_serial_clk_p        => hispi_io_clk_p(1),
      hispi_serial_clk_n        => hispi_io_clk_n(1),
      hispi_serial_input_p      => bottom_lanes_p,
      hispi_serial_input_n      => bottom_lanes_n,
      hispi_pix_clk             => open,
      rclk                      => rclk,
      rclk_reset                => rclk_reset,
      regfile                   => regfile,
      sclk                      => sclk,
      sclk_reset                => sclk_reset,
      sclk_reset_phy            => sclk_reset_phy,
      sclk_start_calibration    => sclk_start_calibration,
      sclk_calibration_done     => sclk_calibration_done(1),
      sclk_fifo_read_en         => bottom_fifo_read_en,
      sclk_fifo_empty           => bottom_fifo_empty,
      sclk_fifo_read_data_valid => bottom_fifo_read_data_valid,
      sclk_fifo_read_data       => bottom_fifo_read_data,
      sclk_sof_flag             => bottom_sof_flag,
      sclk_eof_flag             => bottom_eof_flag,
      sclk_sol_flag             => bottom_sol_flag,
      sclk_eol_flag             => bottom_eol_flag
      );


  -----------------------------------------------------------------------------
  -- Process     : P_new_frame_pending
  -- Description : Flag used to indicates when a start of frame is decoded from
  --               any top lane. This flag is asserted on the detection of any
  --               top SOF and cleared when it is processed by the main state
  --               machine.
  -----------------------------------------------------------------------------
  P_new_frame_pending : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        new_frame_pending <= '0';
      else
        -- A SOF is detected on any top lane
        if (top_sof_flag /= (top_sof_flag'range => '0')) then
          new_frame_pending <= '1';

        -- This flag is cleared once processed by the state
        -- machine
        elsif (state <= S_SOF) then
          new_frame_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_new_line_pending
  -- Description : Flag used to indicates when a start of line is decoded from
  --               any top lane. This flag is asserted on the detection of any
  --               top SOL and cleared when it is processed by the main state
  --               machine.
  -----------------------------------------------------------------------------
  P_new_line_pending : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        new_line_pending <= '0';
      else
        -- A SOL is detected on any top lane
        if (top_sol_flag /= (top_sol_flag'range => '0')) then
          new_line_pending <= '1';

        -- This flag is cleared once processed by the state
        -- machine
        elsif (state <= S_SOL) then
          new_line_pending <= '0';
        end if;
      end if;
    end if;
  end process;


  init_lane_packer <= '1' when (state = S_INIT) else
                      '0';


  all_packer_idle <= '1' when (packer_busy = (packer_busy'range => '0')) else
                     '0';


  -----------------------------------------------------------------------------
  -- Process     : P_line_buffer_id
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_id : process (sclk) is

  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1')then
        line_buffer_id <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- Initialize the offset counter
        -----------------------------------------------------------------------
        if (state = S_INIT) then
          line_buffer_id <= (others => '0');

        elsif (state = S_DONE) then
          line_buffer_id <= std_logic_vector(unsigned(line_buffer_id)+1);
        end if;
      end if;
    end if;
  end process;


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
          -- S_START_CALIBRATION : 
          ---------------------------------------------------------------------
          when S_DISABLED =>
            state <= S_RESET_PHY;


          ---------------------------------------------------------------------
          -- S_RESET_PHY : 
          ---------------------------------------------------------------------
          when S_RESET_PHY =>
            if (sclk_pll_locked = '1') then
              state <= S_IDLE;
            end if;


          ---------------------------------------------------------------------
          -- S_IDLE : Parking state
          ---------------------------------------------------------------------
          when S_IDLE =>
            if (sclk_calibration_pending = '1') then
              state <= S_START_CALIBRATION;
            elsif (new_frame_pending = '1') then
              state <= S_SOF;
            elsif (new_line_pending = '1') then
              state <= S_SOL;
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
          -- S_SOL : Start of line detected
          ---------------------------------------------------------------------
          when S_SOL =>
            state <= S_INIT;

          ---------------------------------------------------------------------
          -- S_SOF : Start of frame detected
          ---------------------------------------------------------------------
          when S_SOF =>
            state <= S_INIT;


          ---------------------------------------------------------------------
          -- S_INIT : Initialize the IP state
          ---------------------------------------------------------------------
          when S_INIT =>
            state <= S_PACK;

          ---------------------------------------------------------------------
          -- S_PACK : Pack incomming data from the XGS sensor to form lines
          --          in the line buffer.
          ---------------------------------------------------------------------
          when S_PACK =>
            if (bottom_eof_flag(0) = '1') then
              state <= S_EOF;

            elsif (bottom_eol_flag(0) = '1') then
              state <= S_EOL;
            else
              state <= S_PACK;

            end if;

          ---------------------------------------------------------------------
          -- S_EOL : End of line detected 
          ---------------------------------------------------------------------
          when S_EOL =>
            state <= S_FLUSH_PACKER;


          ---------------------------------------------------------------------
          -- S_EOF : End of frame detected
          ---------------------------------------------------------------------
          when S_EOF =>
            state <= S_FLUSH_PACKER;

          ---------------------------------------------------------------------
          -- 
          ---------------------------------------------------------------------
          when S_FLUSH_PACKER =>
            if (all_packer_idle = '1') then
              state <= S_DONE;
            else
              state <= S_FLUSH_PACKER;
            end if;



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
  -- 
  -----------------------------------------------------------------------------
  P_row_last : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        row_last <= '0';
      else
        if (state = S_IDLE) then
          row_last <= '0';
        elsif (state = S_EOF) then
          row_last <= '1';
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 00 : SOF
  -- 01 : EOL
  -- 10 : CONT
  -- 11 : EOF
  -----------------------------------------------------------------------------
  P_sync : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        sync <= "10";
      else
        case state is
          when S_SOF  => sync <= "00";
          when S_EOF  => sync <= "11";
          when S_EOL  => sync <= "01";
          when others => sync <= "10";
        end case;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_frame_cntr
  -- Description : Count the complete number of frame received
  -----------------------------------------------------------------------------
  P_frame_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        frame_cntr <= 0;
      else
        if (state = S_EOF and all_packer_idle = '0') then
          frame_cntr <= frame_cntr+1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_hispi_eof_pulse
  -- Description : Generate a pulse with a predefined width
  --               (hispi_eof_pulse'length)
  -----------------------------------------------------------------------------
  P_hispi_eof_pulse : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        hispi_eof_pulse <= (others => '0');
      else
        if (state = S_EOF and all_packer_idle = '0') then
          hispi_eof_pulse <= (others => '1');
        else
          -- Shift 0 left
          hispi_eof_pulse(0)                             <= '0';
          hispi_eof_pulse(hispi_eof_pulse'left downto 1) <= hispi_eof_pulse(hispi_eof_pulse'left-1 downto 0);
        end if;
      end if;
    end if;
  end process;
  hispi_eof <= hispi_eof_pulse(hispi_eof_pulse'left);


  -----------------------------------------------------------------------------
  -- Process     : P_line_cntr
  -- Description : Count the complete number of lines received in the current
  --               frame
  -----------------------------------------------------------------------------
  P_line_cntr : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        line_cntr <= (others => '0');
      else
        if (state = S_SOF) then
          line_cntr <= unsigned(hispi_ystart);
        elsif (state = S_DONE) then
          line_cntr <= line_cntr+1;
        end if;
      end if;
    end if;
  end process;


  row_id <= std_logic_vector(line_cntr);




  init_frame <= '1' when (state = S_SOF) else
                '0';

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_lane_packer_enable : process (sclk) is
  begin
    if (rising_edge(sclk)) then
      if (sclk_reset = '1') then
        lane_packer_enable <= (others => '0');
      else
        -----------------------------------------------------------------------
        -- In the init state we activate the required lane_packers
        -----------------------------------------------------------------------
        if (state = S_INIT) then
          if (nb_lane_enabled = "100") then
            -- 4 lanes enabled => 2 packers required
            lane_packer_enable <= "011";
          elsif (nb_lane_enabled = "110") then
            -- 6 lanes enabled => 3 packers required
            lane_packer_enable <= "111";
          else
            -- Others not supported case => all packers disabled
            lane_packer_enable <= (others => '0');
          end if;
        -----------------------------------------------------------------------
        -- At the end of line or end of frame, we disable all packers 
        -----------------------------------------------------------------------
        elsif (state = S_EOL or state = S_EOF or state = S_IDLE) then
          lane_packer_enable <= (others => '0');
        end if;
      end if;
    end if;
  end process;


  G_lane_packer : for i in 0 to NUMB_LANE_PACKER - 1 generate


    ---------------------------------------------------------------------------
    --  lane packer
    ---------------------------------------------------------------------------
    xlane_packer : lane_packer
      generic map(
        LANE_PACKER_ID            => i,
        LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
        LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH
        )
      port map(
        rclk                        => rclk,
        rclk_reset                  => rclk_reset,
        regfile                     => regfile,
        sclk                        => sclk,
        sclk_reset                  => sclk_reset,
        enable                      => lane_packer_enable(i),
        init_packer                 => init_lane_packer,
        odd_line                    => row_id(0),
        line_valid                  => line_valid,
        busy                        => packer_busy(i),
        line_buffer_id              => line_buffer_id,
        top_sync(0)                 => bottom_sof_flag(i),
        top_sync(1)                 => bottom_eof_flag(i),
        top_sync(2)                 => bottom_sol_flag(i),
        top_sync(3)                 => bottom_eol_flag(i),
        top_fifo_read_en            => top_fifo_read_en(i),
        top_fifo_empty              => top_fifo_empty(i),
        top_fifo_read_data_valid    => top_fifo_read_data_valid(i),
        top_fifo_read_data          => top_fifo_read_data(i),
        bottom_sync(0)              => bottom_sof_flag(i),
        bottom_sync(1)              => bottom_eof_flag(i),
        bottom_sync(2)              => bottom_sol_flag(i),
        bottom_sync(3)              => bottom_eol_flag(i),
        bottom_fifo_read_en         => bottom_fifo_read_en(i),
        bottom_fifo_empty           => bottom_fifo_empty(i),
        bottom_fifo_read_data_valid => bottom_fifo_read_data_valid(i),
        bottom_fifo_read_data       => bottom_fifo_read_data(i),
        lane_packer_ack             => lane_packer_ack(i),
        lane_packer_req             => lane_packer_req(i),
        lane_packer_write           => lane_packer_write(i),
        lane_packer_addr            => lane_packer_addr(i),
        lane_packer_data            => lane_packer_data(i)
        );
  end generate G_lane_packer;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_buff_write_mux : process (lane_packer_ack, lane_packer_write, lane_packer_addr, lane_packer_data) is
  begin
    for i in 0 to NUMB_LANE_PACKER-1 loop
      if (lane_packer_ack(i) = '1') then
        buff_write <= lane_packer_write(i);
        buff_addr  <= lane_packer_addr(i);
        buff_data  <= lane_packer_data(i);
        exit;
      else
        buff_write <= '0';
        buff_addr  <= (others => '0');
        buff_data  <= (others => '0');
      end if;
    end loop;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  xline_buffer : line_buffer
    generic map(
      NUMB_LINE_BUFFER          => NUMB_LINE_BUFFER,
      LINE_BUFFER_PTR_WIDTH     => LINE_BUFFER_PTR_WIDTH,
      LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH,
      LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
      NUMB_LANE_PACKER          => NUMB_LANE_PACKER
      )
    port map(
      sysclk              => sclk,
      sysrst              => sclk_reset,
      row_id              => row_id,
      buffer_enable       => buffer_enable,
      init_frame          => init_frame,
      nxtBuffer           => nxtBuffer,
      line_buffer_clr     => line_buffer_clr,
      lane_packer_req     => lane_packer_req,
      lane_packer_ack     => lane_packer_ack,
      buff_write          => buff_write,
      buff_addr           => buff_addr,
      buff_data           => buff_data,
      line_buffer_ready   => line_buffer_ready,
      line_buffer_read    => line_buffer_read,
      line_buffer_ptr     => line_buffer_ptr,
      line_buffer_address => line_buffer_address,
      line_buffer_row_id  => line_buffer_row_id,
      line_buffer_data    => line_buffer_data
      );


  nxtBuffer <= '1' when (state = S_DONE) else
               '0';


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  xaxi_line_streamer : axi_line_streamer
    generic map(
      NUMB_LINE_BUFFER          => NUMB_LINE_BUFFER,
      LINE_BUFFER_PTR_WIDTH     => LINE_BUFFER_PTR_WIDTH,
      LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
      LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH
      )
    port map (
      sclk                => sclk,
      sclk_reset          => sclk_reset,
      streamer_en         => '1',
      streamer_busy       => open,
      transfert_done      => transfert_done,
      init_frame          => init_frame,
      x_row_start         => x_row_start,
      x_row_stop          => x_row_stop,
      y_row_start         => y_row_start,
      y_row_stop          => y_row_stop,
      line_buffer_clr     => line_buffer_clr,
      line_buffer_ready   => line_buffer_ready,
      line_buffer_read    => line_buffer_read,
      line_buffer_ptr     => line_buffer_ptr,
      line_buffer_address => line_buffer_address,
      line_buffer_row_id  => line_buffer_row_id,
      line_buffer_data    => line_buffer_data,
      sclk_tready         => sclk_tready,
      sclk_tvalid         => sclk_tvalid,
      sclk_tuser          => sclk_tuser,
      sclk_tlast          => sclk_tlast,
      sclk_tdata          => sclk_tdata
      );


  P_state_mapping : process (state) is
  begin
    case state is
      when S_DISABLED          => state_mapping <= "0000";
      when S_IDLE              => state_mapping <= "0001";
      when S_RESET_PHY         => state_mapping <= "0010";
      when S_INIT              => state_mapping <= "0011";
      when S_START_CALIBRATION => state_mapping <= "0100";
      when S_CALIBRATE         => state_mapping <= "0101";
      when S_PACK              => state_mapping <= "0110";
      when S_FLUSH_PACKER      => state_mapping <= "0111";
      when S_SOF               => state_mapping <= "1000";
      when S_EOF               => state_mapping <= "1001";
      when S_SOL               => state_mapping <= "1010";
      when S_EOL               => state_mapping <= "1011";
      when S_DONE              => state_mapping <= "1111";
      when others              => state_mapping <= "1110";  --Reserved
    end case;
  end process;

end architecture rtl;
