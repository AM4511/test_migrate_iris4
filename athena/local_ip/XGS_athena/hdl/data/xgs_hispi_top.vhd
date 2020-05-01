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
    NUMBER_OF_LANE  : integer := 6;
    MUX_RATIO       : integer := 4;
    PIXELS_PER_LINE : integer := 4176;
    LINES_PER_FRAME : integer := 3102;
    PIXEL_SIZE      : integer := 12
    );
  port (
    ---------------------------------------------------------------------------
    -- AXI Slave interface
    ---------------------------------------------------------------------------
    axi_clk     : in std_logic;
    axi_reset_n : in std_logic;


    ---------------------------------------------------------------------------
    -- Register file
    ---------------------------------------------------------------------------
    regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;


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
    m_axis_tready : in  std_logic;
    m_axis_tvalid : out std_logic;
    m_axis_tuser  : out std_logic_vector(3 downto 0);
    m_axis_tlast  : out std_logic;
    m_axis_tdata  : out std_logic_vector(63 downto 0)
    );
end entity xgs_hispi_top;


architecture rtl of xgs_hispi_top is


  component hispi_phy is
    generic (
      LANE_PER_PHY : integer := 3;      -- Physical lane
      PIXEL_SIZE   : integer := 12      -- Pixel size in bits
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      -- Register file information
      idle_character       : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
      hispi_phy_en         : in  std_logic;
      hispi_soft_reset     : in  std_logic;

      -- Calibration 
      cal_en        : in  std_logic;
      cal_busy      : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      cal_error     : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      cal_load_tap  : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      cal_tap_value : out std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

      -- HiSPi IO
      hispi_serial_clk_p   : in  std_logic;
      hispi_serial_clk_n   : in  std_logic;
      hispi_serial_input_p : in  std_logic_vector(LANE_PER_PHY - 1 downto 0);
      hispi_serial_input_n : in  std_logic_vector(LANE_PER_PHY - 1 downto 0);

      -- Read fifo interface
      fifo_read_clk        : in  std_logic;
      fifo_read_en         : in  std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_empty           : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_read_data_valid : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      fifo_read_data       : out std32_logic_vector(LANE_PER_PHY-1 downto 0);

      -- Flags detected
      embeded_data         : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sof_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      eof_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      sol_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0);
      eol_flag             : out std_logic_vector(LANE_PER_PHY-1 downto 0)
      );
  end component;


  component lane_packer is
    generic (
      LANE_PACKER_ID            : integer              := 0;
      LINE_BUFFER_DATA_WIDTH    : integer              := 64;
      LINE_BUFFER_ADDRESS_WIDTH : integer              := 11;
      NUMBER_OF_LINE_BUFFER     : integer range 1 to 4 := 4;
      NUMBER_OF_LANE            : integer              := 6;
      MUX_RATIO                 : integer              := 4;
      PIXELS_PER_LINE           : integer              := 4176;
      LINES_PER_FRAME           : integer              := 3102;
      PIXEL_SIZE                : integer              := 12
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      -- registers
      packer_fifo_overrun  : out std_logic;
      packer_fifo_underrun : out std_logic;

      enable         : in  std_logic;
      init_frame     : in  std_logic;
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
      NUMB_LANE_PACKER          : integer              := 3;
      PIXELS_PER_LINE           : integer              := 4176;
      LINES_PER_FRAME           : integer              := 3102
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
      nxtBuffer : in std_logic;
      clrBuffer : in std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

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
      line_buffer_count   : out std_logic_vector(11 downto 0);
      line_buffer_line_id : out std_logic_vector(11 downto 0);
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
      sysclk : in std_logic;
      sysrst : in std_logic;

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
      number_of_row : in std_logic_vector(11 downto 0);

      ---------------------------------------------------------------------------
      -- Line buffer I/F
      ---------------------------------------------------------------------------
      clrBuffer           : out std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
      line_buffer_ready   : in  std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
      line_buffer_read    : out std_logic;
      line_buffer_ptr     : out std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
      line_buffer_address : out std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
      line_buffer_count   : in  std_logic_vector(11 downto 0);
      line_buffer_line_id : in  std_logic_vector(11 downto 0);
      line_buffer_data    : in  std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic_vector(3 downto 0);
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;



  constant C_S_AXI_ADDR_WIDTH : integer              := 8;
  constant C_S_AXI_DATA_WIDTH : integer              := 32;
  constant NUMB_LINE_BUFFER   : integer range 2 to 4 := 2;
  constant LANE_PER_PHY       : integer              := NUMBER_OF_LANE/2;

  constant LINE_BUFFER_DATA_WIDTH    : integer                                 := 64;
  constant LINE_BUFFER_ADDRESS_WIDTH : integer                                 := 11;
  constant LINE_BUFFER_PTR_WIDTH     : integer                                 := 1;
  constant NUMB_LANE_PACKER          : integer                                 := NUMBER_OF_LANE/2;
  constant C_IDLE_CHARACTER          : std_logic_vector(PIXEL_SIZE-1 downto 0) := X"3A6";

  signal axi_reset : std_logic;

  -- attribute IODELAY_GROUP                : string;
  -- attribute IODELAY_GROUP of xIDELAYCTRL : label is "hispi_phy_xilinx_group";


  type FSM_TYPE is (S_IDLE, S_INIT, S_DISABLED, S_CALIBRATE, S_PACK, S_SOF, S_EOF, S_SOL, S_EOL, S_FLUSH_PACKER, S_DONE);

  type PACKER_DATA_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  type PACKER_ADDR_ARRAY_TYPE is array (NUMB_LANE_PACKER-1 downto 0) of std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal idle_character           : std_logic_vector(PIXEL_SIZE-1 downto 0);
  signal new_line_pending         : std_logic;
  signal new_frame_pending        : std_logic;

  signal cal_en       : std_logic;
  signal cal_load_tap : std_logic;
  signal cal_error    : std_logic_vector(2*LANE_PER_PHY-1 downto 0);
  signal cal_busy     : std_logic_vector(2*LANE_PER_PHY-1 downto 0);
  signal calibrate_en : std_logic;


  signal top_cal_en        : std_logic;
  signal top_cal_busy      : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_cal_error     : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_cal_load_tap  : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_cal_tap_value : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);

  signal top_lanes_p              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_lanes_n              : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_embeded_data         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eof_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_sol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_eol_flag             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_en         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_empty           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data_valid : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal top_fifo_read_data       : std32_logic_vector(LANE_PER_PHY-1 downto 0);


  signal bottom_cal_en               : std_logic;
  signal bottom_cal_busy             : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_cal_error            : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_cal_load_tap         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_cal_tap_value        : std_logic_vector((5*LANE_PER_PHY)-1 downto 0);
  signal bottom_lanes_p           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_lanes_n           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_embeded_data      : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sof_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eof_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_sol_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_eol_flag          : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_en         : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_empty           : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data_valid : std_logic_vector(LANE_PER_PHY-1 downto 0);
  signal bottom_fifo_read_data       : std32_logic_vector(LANE_PER_PHY-1 downto 0);
  signal hispi_phy_en                : std_logic;

  signal state : FSM_TYPE;

  signal row_id           : std_logic_vector(11 downto 0);
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

  signal lane_packer_ack   : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_req   : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_write : std_logic_vector(NUMB_LANE_PACKER-1 downto 0);
  signal lane_packer_addr  : PACKER_ADDR_ARRAY_TYPE;
  signal lane_packer_data  : PACKER_DATA_ARRAY_TYPE;
  signal packer_enable     : std_logic;

  signal nxtBuffer         : std_logic;
  signal clrBuffer         : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);
  signal line_buffer_ready : std_logic_vector(NUMB_LINE_BUFFER-1 downto 0);

  signal buff_write : std_logic;
  signal buff_addr  : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal buff_data  : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);

  signal sync : std_logic_vector(1 downto 0);

  signal strm_packer_sel       : std_logic_vector(1 downto 0);
  signal strm_buffer_sel       : std_logic_vector(1 downto 0);
  signal strm_sbuff_clr        : std_logic;
  signal strm_sbuff_rden       : std_logic;
  signal strm_sbuff_data_valid : std_logic;
  signal strm_sbuff_rddata     : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal strm_sbuff_count      : std_logic_vector(11 downto 0);
  signal buffer_enable         : std_logic;
  signal number_of_row         : std_logic_vector(11 downto 0);

  signal line_buffer_read    : std_logic;
  signal line_buffer_ptr     : std_logic_vector(LINE_BUFFER_PTR_WIDTH-1 downto 0);
  signal line_buffer_address : std_logic_vector(LINE_BUFFER_ADDRESS_WIDTH-1 downto 0);
  signal line_buffer_count   : std_logic_vector(11 downto 0);
  signal line_buffer_line_id : std_logic_vector(11 downto 0);
  signal line_buffer_data    : std_logic_vector(LINE_BUFFER_DATA_WIDTH-1 downto 0);
  signal capture_enable      : std_logic := '1'; -- TMP should be register

begin

  -- ToDo From register_file
  calibrate_en <= '0';

  top_cal_en <= '1' when (state = S_CALIBRATE) else
                '0';

  bottom_cal_en <= '1' when (state = S_CALIBRATE) else
                   '0';


  -- NO GOOD CLOCK DOMAIN CROSSING
  cal_load_tap <= '1' when (top_cal_load_tap(0) = '1') else
                  '0';

  G_cal_error : for i in 0 to LANE_PER_PHY-1 generate
    cal_error(2*i)   <= top_cal_error(i);
    cal_error(2*i+1) <= bottom_cal_error(i);
  end generate G_cal_error;


  G_cal_busy : for i in 0 to LANE_PER_PHY-1 generate
    cal_busy(2*i)   <= top_cal_busy(i);
    cal_busy(2*i+1) <= bottom_cal_busy(i);
  end generate G_cal_busy;






  -- TBD : will eventually come from a register?
  number_of_row <= std_logic_vector(to_unsigned(LINES_PER_FRAME, number_of_row'length));

  axi_reset <= not axi_reset_n;


  -- TBD : will eventually come from a register
  idle_character <= C_IDLE_CHARACTER;


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
  top_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE
      )
    port map(
      sysclk               => axi_clk,
      sysrst               => axi_reset,
      idle_character       => idle_character,
      hispi_phy_en         => hispi_phy_en,
      hispi_soft_reset     => regfile.HISPI.CTRL.CLR,
      cal_en               => top_cal_en,
      cal_busy             => top_cal_busy,
      cal_error            => top_cal_error,
      cal_load_tap         => top_cal_load_tap,
      cal_tap_value        => top_cal_tap_value,
      hispi_serial_clk_p   => hispi_io_clk_p(0),
      hispi_serial_clk_n   => hispi_io_clk_n(0),
      hispi_serial_input_p => top_lanes_p,
      hispi_serial_input_n => top_lanes_n,
      fifo_read_clk        => axi_clk,
      fifo_read_en         => top_fifo_read_en,
      fifo_empty           => top_fifo_empty,
      fifo_read_data_valid => top_fifo_read_data_valid,
      fifo_read_data       => top_fifo_read_data,
      embeded_data         => top_embeded_data,
      sof_flag             => top_sof_flag,
      eof_flag             => top_eof_flag,
      sol_flag             => top_sol_flag,
      eol_flag             => top_eol_flag
      );



  -----------------------------------------------------------------------------
  -- Module      : hispi_phy
  -- Description : Bottom lanes hispi phy. Provides one serdes for interfacing
  --               all the XGS sensor bottom lanes.
  -----------------------------------------------------------------------------
  bottom_hispi_phy : hispi_phy
    generic map(
      LANE_PER_PHY => LANE_PER_PHY,
      PIXEL_SIZE   => PIXEL_SIZE
      )
    port map(
      sysclk               => axi_clk,
      sysrst               => axi_reset,
      idle_character       => idle_character,
      hispi_phy_en         => hispi_phy_en,
      hispi_soft_reset     => regfile.HISPI.CTRL.CLR,
      cal_en               => bottom_cal_en,
      cal_busy             => bottom_cal_busy,
      cal_error            => bottom_cal_error,
      cal_load_tap         => bottom_cal_load_tap,
      cal_tap_value        => bottom_cal_tap_value,
      hispi_serial_clk_p   => hispi_io_clk_p(1),
      hispi_serial_clk_n   => hispi_io_clk_n(1),
      hispi_serial_input_p => bottom_lanes_p,
      hispi_serial_input_n => bottom_lanes_n,
      fifo_read_clk        => axi_clk,
      fifo_read_en         => bottom_fifo_read_en,
      fifo_empty           => bottom_fifo_empty,
      fifo_read_data_valid => bottom_fifo_read_data_valid,
      fifo_read_data       => bottom_fifo_read_data,
      embeded_data         => bottom_embeded_data,
      sof_flag             => bottom_sof_flag,
      eof_flag             => bottom_eof_flag,
      sol_flag             => bottom_sol_flag,
      eol_flag             => bottom_eol_flag
      );


  -----------------------------------------------------------------------------
  -- Process     : P_new_frame_pending
  -- Description : Flag used to indicates when a start of frame is decoded from
  --               any top lane. This flag is asserted on the detection of any
  --               top SOF and cleared when it is processed by the main state
  --               machine.
  -----------------------------------------------------------------------------
  P_new_frame_pending : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
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
  P_new_line_pending : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
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


  hispi_phy_en <= '1' when (regfile.HISPI.CTRL.ENABLE = '1') else
                  '0';


  -----------------------------------------------------------------------------
  -- Process     : P_line_buffer_id
  -- Description : 
  -----------------------------------------------------------------------------
  P_buffer_id : process (axi_clk) is

  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0')then
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
  -- Process     : P_state
  -- Description : Main FSM
  -----------------------------------------------------------------------------
  P_state : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        state <= S_DISABLED;
      else
        if (capture_enable = '0') then
          state <= S_DISABLED;
        else

          case state is
            ---------------------------------------------------------------------
            -- S_DISABLED : Starting point
            ---------------------------------------------------------------------
            when S_DISABLED =>
              state <= S_CALIBRATE;

            ---------------------------------------------------------------------
            -- S_CALIBRATE : 
            ---------------------------------------------------------------------
            when S_CALIBRATE =>
              if (top_cal_load_tap(0) = '1') then
              state <= S_IDLE;
              else
                state <= S_CALIBRATE;
              end if;

            ---------------------------------------------------------------------
            -- S_IDLE : Parking state
            ---------------------------------------------------------------------
            when S_IDLE =>
              if (calibrate_en = '1') then
                state <= S_CALIBRATE;
              elsif (new_frame_pending = '1') then
                state <= S_SOF;
              elsif (new_line_pending = '1') then
                state <= S_SOL;
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
    end if;
  end process P_state;



  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_packer_enable : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        packer_enable <= '0';
      else
        if (state = S_INIT) then
          packer_enable <= '1';
        elsif (state = S_EOL or state = S_EOF or state = S_IDLE) then
          packer_enable <= '0';
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
  P_sync : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
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
  P_frame_cntr : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        frame_cntr <= 0;
      else
        if (state = S_EOF and all_packer_idle = '0') then
          frame_cntr <= frame_cntr+1;
        end if;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Process     : P_line_cntr
  -- Description : Count the complete number of lines received in the current
  --               frame
  -----------------------------------------------------------------------------
  P_line_cntr : process (axi_clk) is
  begin
    if (rising_edge(axi_clk)) then
      if (axi_reset_n = '0') then
        line_cntr <= (others => '0');
      else
        if (state = S_SOF) then
          line_cntr <= (others => '0');
        elsif (state = S_DONE) then
          line_cntr <= line_cntr+1;
        end if;
      end if;
    end if;
  end process;


  row_id <= std_logic_vector(line_cntr);




  init_frame <= '1' when (state = S_SOF) else
                '0';


  G_lane_packer : for i in 0 to NUMB_LANE_PACKER - 1 generate


    ---------------------------------------------------------------------------
    --  lane packer
    ---------------------------------------------------------------------------
    xlane_packer : lane_packer
      generic map(
        LANE_PACKER_ID            => i,
        LINE_BUFFER_DATA_WIDTH    => LINE_BUFFER_DATA_WIDTH,
        LINE_BUFFER_ADDRESS_WIDTH => LINE_BUFFER_ADDRESS_WIDTH,
        NUMBER_OF_LANE            => NUMBER_OF_LANE,
        MUX_RATIO                 => MUX_RATIO,
        PIXELS_PER_LINE           => PIXELS_PER_LINE,
        LINES_PER_FRAME           => LINES_PER_FRAME,
        PIXEL_SIZE                => PIXEL_SIZE
        )
      port map(
        sysclk                      => axi_clk,
        sysrst                      => axi_reset,
        packer_fifo_overrun         => packer_fifo_overrun(i),
        packer_fifo_underrun        => packer_fifo_underrun(i),
        enable                      => packer_enable,
        init_frame                  => init_lane_packer,
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
  begin  -- process
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
      NUMB_LANE_PACKER          => NUMB_LANE_PACKER,
      PIXELS_PER_LINE           => PIXELS_PER_LINE,
      LINES_PER_FRAME           => LINES_PER_FRAME
      )
    port map(
      sysclk              => axi_clk,
      sysrst              => axi_reset,
      row_id              => row_id,
      buffer_enable       => buffer_enable,
      init_frame          => init_frame,
      nxtBuffer           => nxtBuffer,
      clrBuffer           => clrBuffer,
      lane_packer_req     => lane_packer_req,
      lane_packer_ack     => lane_packer_ack,
      buff_write          => buff_write,
      buff_addr           => buff_addr,
      buff_data           => buff_data,
      line_buffer_ready   => line_buffer_ready,
      line_buffer_read    => line_buffer_read,
      line_buffer_ptr     => line_buffer_ptr,
      line_buffer_address => line_buffer_address,
      line_buffer_count   => line_buffer_count,
      line_buffer_line_id => line_buffer_line_id,
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
      sysclk              => axi_clk,
      sysrst              => axi_reset,
      streamer_en         => '1',
      streamer_busy       => open,
      transfert_done      => transfert_done,
      init_frame          => init_frame,
      clrBuffer           => clrBuffer,
      line_buffer_ready   => line_buffer_ready,
      number_of_row       => number_of_row,
      line_buffer_read    => line_buffer_read,
      line_buffer_ptr     => line_buffer_ptr,
      line_buffer_address => line_buffer_address,
      line_buffer_count   => line_buffer_count,
      line_buffer_line_id => line_buffer_line_id,
      line_buffer_data    => line_buffer_data,
      m_axis_tready       => m_axis_tready,
      m_axis_tvalid       => m_axis_tvalid,
      m_axis_tuser        => m_axis_tuser,
      m_axis_tlast        => m_axis_tlast,
      m_axis_tdata        => m_axis_tdata
      );



end architecture rtl;
