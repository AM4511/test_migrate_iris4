library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.regfile_xgs_athena_pack.all;


entity XGS_athena is
  generic (
    ENABLE_IDELAYCTRL     : integer range 0 to 1 := 1;
    NUMBER_OF_LANE        : integer              := 6;
    MUX_RATIO             : integer              := 4;
    PIXELS_PER_LINE       : integer              := 4176;
    LINES_PER_FRAME       : integer              := 3102;
    PIXEL_SIZE            : integer              := 12;
    MAX_PCIE_PAYLOAD_SIZE : integer              := 128;
    SYS_CLK_PERIOD        : integer              := 16;
    SENSOR_FREQ           : integer              := 32400;
    SIMULATION            : integer              := 0
    );
  port (
    ---------------------------------------------------------------------------
    -- 
    ---------------------------------------------------------------------------
    aclk         : in std_logic;
    aclk_reset_n : in std_logic;

    sclk         : in std_logic;
    sclk_reset_n : in std_logic;

    ---------------------------------------------------------------------------
    -- Interrupts
    ---------------------------------------------------------------------------
    irq : out std_logic_vector(7 downto 0);

    ------------------------------------------
    -- CMOS interface to sensor
    ------------------------------------------
    xgs_power_good : in  std_logic;
    xgs_clk_pll_en : out std_logic;
    xgs_reset_n    : out std_logic;

    xgs_fwsi_en : out std_logic;

    xgs_sclk  : out std_logic;
    xgs_cs_n  : out std_logic;
    xgs_sdout : out std_logic;
    xgs_sdin  : in  std_logic;

    xgs_trig_int : out std_logic;
    xgs_trig_rd  : out std_logic;

    xgs_monitor0 : in std_logic;
    xgs_monitor1 : in std_logic;
    xgs_monitor2 : in std_logic;

    ---------------------------------------------------------------------------
    --  Outputs 
    ---------------------------------------------------------------------------
    anput_ext_trig : in std_logic;

    anput_strobe_out   : out std_logic;  --
    anput_exposure_out : out std_logic;  --
    anput_trig_rdy_out : out std_logic;  --

    led_out : out std_logic_vector(1 downto 0);  -- led_out(0) --> vert, led_out(1) --> rouge

    ---------------------------------------------------------------------------
    --  Debug interface 
    ---------------------------------------------------------------------------
    debug_out : out std_logic_vector(3 downto 0);  -- To debug pins jmansill

    ---------------------------------------------------------------------------
    -- AXI Slave interface (Registerfile)
    ---------------------------------------------------------------------------
    aclk_awaddr  : in  std_logic_vector(10 downto 0);
    aclk_awprot  : in  std_logic_vector(2 downto 0);
    aclk_awvalid : in  std_logic;
    aclk_awready : out std_logic;
    aclk_wdata   : in  std_logic_vector(31 downto 0);
    aclk_wstrb   : in  std_logic_vector(3 downto 0);
    aclk_wvalid  : in  std_logic;
    aclk_wready  : out std_logic;
    aclk_bresp   : out std_logic_vector(1 downto 0);
    aclk_bvalid  : out std_logic;
    aclk_bready  : in  std_logic;
    aclk_araddr  : in  std_logic_vector(10 downto 0);
    aclk_arprot  : in  std_logic_vector(2 downto 0);
    aclk_arvalid : in  std_logic;
    aclk_arready : out std_logic;
    aclk_rdata   : out std_logic_vector(31 downto 0);
    aclk_rresp   : out std_logic_vector(1 downto 0);
    aclk_rvalid  : out std_logic;
    aclk_rready  : in  std_logic;


    ---------------------------------------------------------------------------
    -- Top HiSPI I/F
    ---------------------------------------------------------------------------
    idelay_clk      : in std_logic;
    hispi_io_clk_p  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_clk_n  : in std_logic_vector(1 downto 0);  -- hispi clock
    hispi_io_data_p : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);
    hispi_io_data_n : in std_logic_vector(NUMBER_OF_LANE - 1 downto 0);

    ---------------------------------------------------------------------
    -- PCIe Configuration space info (aclk)
    ---------------------------------------------------------------------
    cfg_bus_mast_en : in std_logic;
    cfg_setmaxpld   : in std_logic_vector(2 downto 0);


    ---------------------------------------------------------------------
    -- TLP Interface
    ---------------------------------------------------------------------
    tlp_req_to_send : out std_logic := '0';
    tlp_grant       : in  std_logic;

    tlp_fmt_type     : out std_logic_vector(6 downto 0);
    tlp_length_in_dw : out std_logic_vector(9 downto 0);

    tlp_src_rdy_n : out std_logic;
    tlp_dst_rdy_n : in  std_logic;
    tlp_data      : out std_logic_vector(63 downto 0);

    -- for master request transmit
    tlp_address     : out std_logic_vector(63 downto 2);
    tlp_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

    -- for completion transmit
    tlp_attr           : out std_logic_vector(1 downto 0);
    tlp_transaction_id : out std_logic_vector(23 downto 0);
    tlp_byte_count     : out std_logic_vector(12 downto 0);
    tlp_lower_address  : out std_logic_vector(6 downto 0)
    );
end entity XGS_athena;


architecture struct of XGS_athena is


  component axiSlave2RegFile
    generic(
      -- Width of S_AXI data bus
      C_S_AXI_DATA_WIDTH : integer := 32;
      -- Width of S_AXI address bus
      C_S_AXI_ADDR_WIDTH : integer := 9
      );
    port(
      ---------------------------------------------------------------------------
      -- Axi slave clock interface
      ---------------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      ---------------------------------------------------------------------------
      -- Axi write address channel
      ---------------------------------------------------------------------------
      axi_awvalid : in  std_logic;
      axi_awready : out std_logic;
      axi_awprot  : in  std_logic_vector(2 downto 0);
      axi_awaddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi write data channel
      ---------------------------------------------------------------------------
      axi_wvalid : in  std_logic;
      axi_wready : out std_logic;
      axi_wstrb  : in  std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
      axi_wdata  : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi write response channel
      ---------------------------------------------------------------------------
      axi_bready : in  std_logic;
      axi_bvalid : out std_logic;
      axi_bresp  : out std_logic_vector(1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi read address channel
      ---------------------------------------------------------------------------
      axi_arvalid : in  std_logic;
      axi_arready : out std_logic;
      axi_arprot  : in  std_logic_vector(2 downto 0);
      axi_araddr  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);

      ---------------------------------------------------------------------------
      -- Axi read data channel
      ---------------------------------------------------------------------------
      axi_rready : in  std_logic;
      axi_rvalid : out std_logic;
      axi_rdata  : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
      axi_rresp  : out std_logic_vector(1 downto 0);

      ---------------------------------------------------------------------------
      -- FDK IDE registerfile interface
      ---------------------------------------------------------------------------
      reg_read          : out std_logic;
      reg_write         : out std_logic;
      reg_addr          : out std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
      reg_beN           : out std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
      reg_writedata     : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
      reg_readdataValid : in  std_logic;
      reg_readdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0)
      );
  end component;


  component regfile_xgs_athena is
    port (
      resetN        : in    std_logic;  -- System reset
      sysclk        : in    std_logic;  -- System clock
      regfile       : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;  -- Read
      reg_write     : in    std_logic;  -- Write
      reg_addr      : in    std_logic_vector(10 downto 2);  -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);  -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)   -- Read data
      );
  end component;


  component xgs_hispi_top is
    generic (
      HW_VERSION      : integer range 0 to 255 := 0;
      NUMBER_OF_LANE  : integer                := 6;
      MUX_RATIO       : integer                := 4;
      PIXELS_PER_LINE : integer                := 4176;
      LINES_PER_FRAME : integer                := 3102;
      PIXEL_SIZE      : integer                := 12
      );
    port (
      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      sclk         : in std_logic;
      sclk_reset_n : in std_logic;


      ---------------------------------------------------------------------------
      -- Register file interface 
      ---------------------------------------------------------------------------
      rclk         : in    std_logic;
      rclk_reset_n : in    std_logic;
      regfile      : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

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
  end component;


  component xgs_mono_pipeline is
    generic (
      SIMULATION : integer := 0
      );
    port (
      ---------------------------------------------------------------------------
      -- Register file
      ---------------------------------------------------------------------------
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      sclk         : in std_logic;
      sclk_reset_n : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      sclk_tready : out std_logic;
      sclk_tvalid : in  std_logic;
      sclk_tuser  : in  std_logic_vector(3 downto 0);
      sclk_tlast  : in  std_logic;
      sclk_tdata  : in  std_logic_vector(63 downto 0);

      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      aclk         : in std_logic;
      aclk_reset_n : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI master stream output interface
      ---------------------------------------------------------------------------
      aclk_tready : in  std_logic;
      aclk_tvalid : out std_logic;
      aclk_tuser  : out std_logic_vector(3 downto 0);
      aclk_tlast  : out std_logic;
      aclk_tdata  : out std_logic_vector(63 downto 0)
      );
  end component;


  component dmawr2tlp is
    generic (
      MAX_PCIE_PAYLOAD_SIZE : integer := 128
      );
    port (
      ---------------------------------------------------------------------
      -- PCIe user domain reset and clock signals
      ---------------------------------------------------------------------
      sclk   : in std_logic;
      srst_n : in std_logic;

      ---------------------------------------------------------------------
      -- IRQ I/F
      ---------------------------------------------------------------------
      intevent : out std_logic;

      ---------------------------------------------------------------------
      -- System I/F
      ---------------------------------------------------------------------
      context_strb : in std_logic_vector(1 downto 0);

      ---------------------------------------------------------------------
      -- RegisterFile I/F
      ---------------------------------------------------------------------
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file



      ----------------------------------------------------
      -- AXI stream interface (Slave port)
      ----------------------------------------------------
      tready : out std_logic;
      tvalid : in  std_logic;
      tdata  : in  std_logic_vector(63 downto 0);
      tuser  : in  std_logic_vector(3 downto 0);
      tlast  : in  std_logic;


      ---------------------------------------------------------------------
      -- PCIe Configuration space info (axi_clk)
      ---------------------------------------------------------------------
      cfg_bus_mast_en : in std_logic;
      cfg_setmaxpld   : in std_logic_vector(2 downto 0);

      ---------------------------------------------------------------------
      -- TLP Interface
      ---------------------------------------------------------------------
      tlp_req_to_send : out std_logic := '0';
      tlp_grant       : in  std_logic;

      tlp_fmt_type     : out std_logic_vector(6 downto 0);
      tlp_length_in_dw : out std_logic_vector(9 downto 0);

      tlp_src_rdy_n : out std_logic;
      tlp_dst_rdy_n : in  std_logic;
      tlp_data      : out std_logic_vector(63 downto 0);

      -- for master request transmit
      tlp_address     : out std_logic_vector(63 downto 2);
      tlp_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_attr           : out std_logic_vector(1 downto 0);
      tlp_transaction_id : out std_logic_vector(23 downto 0);
      tlp_byte_count     : out std_logic_vector(12 downto 0);
      tlp_lower_address  : out std_logic_vector(6 downto 0)

      );
  end component;


  component XGS_controller_top
    generic (
      -- Users to add parameters here
      G_SYS_CLK_PERIOD : integer := 16;
      G_SENSOR_FREQ    : integer := 32400;
      G_SIMULATION     : integer := 0
      );
    port (
      -- Users to add ports here
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ------------------------------------------
      -- CMOS INTERFACE TO SENSOR
      ------------------------------------------
      xgs_power_good : in  std_logic;
      xgs_clk_pll_en : out std_logic;
      xgs_reset_n    : out std_logic;

      xgs_fwsi_en : out std_logic;

      xgs_sclk  : out std_logic;
      xgs_cs_n  : out std_logic;
      xgs_sdout : out std_logic;
      xgs_sdin  : in  std_logic;

      xgs_trig_int : out std_logic;
      xgs_trig_rd  : out std_logic;

      xgs_monitor0 : in std_logic;
      xgs_monitor1 : in std_logic;
      xgs_monitor2 : in std_logic;

      ---------------------------------------------------------------------------
      --  OUTPUTS 
      ---------------------------------------------------------------------------
      anput_ext_trig : in std_logic;

      anput_strobe_out   : out std_logic;  --
      anput_exposure_out : out std_logic;  --
      anput_trig_rdy_out : out std_logic;  --

      led_out : out std_logic_vector(1 downto 0);  -- led_out(0) --> vert, led_out(1) --> rouge

      ---------------------------------------------------------------------------
      --  DEBUG OUTPUTS 
      ---------------------------------------------------------------------------
      debug_out : out std_logic_vector(3 downto 0);  -- To debug pins

      ---------------------------------------------------------------------------
      --  Signals to/from Datapath/DMA
      ---------------------------------------------------------------------------
      start_calibration : out std_logic;
      -- calibration_active : in std_logic; TBD

      HISPI_pix_clk : in std_logic := '0';

      DEC_EOF : in std_logic := '0';

      abort_readout_datapath : out std_logic := '0';
      dma_idle               : in  std_logic := '1';

      strobe_DMA_P1 : out std_logic := '0';  -- Load DMA 1st stage registers  
      strobe_DMA_P2 : out std_logic := '0';  -- Load DMA 2nd stage registers 

      curr_db_GRAB_ROI2_EN : out std_logic := '0';

      curr_db_y_start_ROI1 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base
      curr_db_nblines_ROI1 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  

      curr_db_y_start_ROI2 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  
      curr_db_nblines_ROI2 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base

      curr_db_subsampling_X : out std_logic := '0';
      curr_db_subsampling_Y : out std_logic := '0';

      curr_db_BUFFER_ID : out std_logic := '0';

      first_lines_mask_cnt            : out std_logic_vector(9 downto 0);    -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

      ---------------------------------------------------------------------------
      --  IRQ to system
      ---------------------------------------------------------------------------        
      irq_eos   : out std_logic;
      irq_sos   : out std_logic;
      irq_eoe   : out std_logic;
      irq_soe   : out std_logic;
      irq_abort : out std_logic;

      ---------------------------------------------------------------------------
      --  Register file
      ---------------------------------------------------------------------------   
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE  -- Register file


      );

  end component;


  -----------------------------------------------------------------------------
  -- HW_VERSION :
  --
  -- 00000000 :  TBD
  -----------------------------------------------------------------------------
  constant HW_VERSION : integer := 0;

  constant C_S_AXI_DATA_WIDTH : integer := 32;
  constant C_S_AXI_ADDR_WIDTH : integer := 11;

  signal regfile           : REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
  signal reg_read          : std_logic;
  signal reg_write         : std_logic;
  signal reg_addr          : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal reg_beN           : std_logic_vector(3 downto 0);
  signal reg_writedata     : std_logic_vector(31 downto 0);
  signal reg_readdata      : std_logic_vector(31 downto 0);
  signal reg_readdatavalid : std_logic;

  signal aclk_tready : std_logic;
  signal aclk_tvalid : std_logic;
  signal aclk_tdata  : std_logic_vector(63 downto 0);
  signal aclk_tuser  : std_logic_vector(3 downto 0);
  signal aclk_tlast  : std_logic;

  signal sclk_tready : std_logic;
  signal sclk_tvalid : std_logic;
  signal sclk_tlast  : std_logic;
  signal sclk_tuser  : std_logic_vector(3 downto 0);
  signal sclk_tdata  : std_logic_vector(63 downto 0);

  signal load_dma_context : std_logic_vector(1 downto 0);

  signal irq_dma   : std_logic;
  signal irq_eos   : std_logic;
  signal irq_sos   : std_logic;
  signal irq_eoe   : std_logic;
  signal irq_soe   : std_logic;
  signal irq_abort : std_logic;

  signal hispi_start_calibration  : std_logic;
  signal hispi_calibration_active : std_logic;
  signal hispi_pix_clk            : std_logic;
  signal hispi_eof                : std_logic;
  signal hispi_ystart             : std_logic_vector(11 downto 0);
  signal hispi_ysize              : std_logic_vector(11 downto 0);
  signal first_lines_mask_cnt     : std_logic_vector(9 downto 0);    -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

  signal dma_idle : std_logic := '1';

begin

  -----------------------------------------------------------------------------
  -- Hardware version
  -----------------------------------------------------------------------------
  -- regfile.SYSTEM.VERSION.HW <= HW_VERSION; Assigned under xgs_hispi_top.vhd


  -----------------------------------------------------------------------------
  -- AXI Slave Interface
  -----------------------------------------------------------------------------
  xaxiSlave2RegFile : axiSlave2RegFile
    generic map(
      C_S_AXI_DATA_WIDTH => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_S_AXI_ADDR_WIDTH
      )
    port map(
      axi_clk           => aclk,
      axi_reset_n       => aclk_reset_n,
      axi_awvalid       => aclk_awvalid,
      axi_awready       => aclk_awready,
      axi_awprot        => aclk_awprot,
      axi_awaddr        => aclk_awaddr,
      axi_wvalid        => aclk_wvalid,
      axi_wready        => aclk_wready,
      axi_wstrb         => aclk_wstrb,
      axi_wdata         => aclk_wdata,
      axi_bready        => aclk_bready,
      axi_bvalid        => aclk_bvalid,
      axi_bresp         => aclk_bresp,
      axi_arvalid       => aclk_arvalid,
      axi_arready       => aclk_arready,
      axi_arprot        => aclk_arprot,
      axi_araddr        => aclk_araddr,
      axi_rready        => aclk_rready,
      axi_rvalid        => aclk_rvalid,
      axi_rdata         => aclk_rdata,
      axi_rresp         => aclk_rresp,
      reg_read          => reg_read,
      reg_write         => reg_write,
      reg_addr          => reg_addr,
      reg_beN           => reg_beN,
      reg_writedata     => reg_writedata,
      reg_readdataValid => reg_readdataValid,
      reg_readdata      => reg_readdata
      );


  -----------------------------------------------------------------------------
  -- Module      : regfile_xgs_athena
  -- Description : IP-Core main registerfile. This file is generated by the
  --               Matrox FDK-IDE tool
  -----------------------------------------------------------------------------
  xregfile_xgs_athena : regfile_xgs_athena
    port map(
      resetN        => aclk_reset_n,
      sysclk        => aclk,
      regfile       => regfile,
      reg_read      => reg_read,
      reg_write     => reg_write,
      reg_addr      => reg_addr(C_S_AXI_ADDR_WIDTH-1 downto 2),
      reg_beN       => reg_beN,
      reg_writedata => reg_writedata,
      reg_readdata  => reg_readdata
      );


  x_xgs_hispi_top : xgs_hispi_top
    generic map(
      HW_VERSION      => HW_VERSION,
      NUMBER_OF_LANE  => NUMBER_OF_LANE,
      MUX_RATIO       => MUX_RATIO,
      PIXELS_PER_LINE => PIXELS_PER_LINE,
      LINES_PER_FRAME => LINES_PER_FRAME,
      PIXEL_SIZE      => PIXEL_SIZE
      )
    port map(
      sclk                     => sclk,
      sclk_reset_n             => sclk_reset_n,
      rclk                     => aclk,
      rclk_reset_n             => aclk_reset_n,
      regfile                  => regfile,
      idelay_clk               => idelay_clk,
      hispi_start_calibration  => hispi_start_calibration,
      hispi_calibration_active => hispi_calibration_active,
      hispi_pix_clk            => hispi_pix_clk,
      hispi_eof                => hispi_eof,
      hispi_ystart             => hispi_ystart,
      hispi_ysize              => hispi_ysize,
      hispi_io_clk_p           => hispi_io_clk_p,
      hispi_io_clk_n           => hispi_io_clk_n,
      hispi_io_data_p          => hispi_io_data_p,
      hispi_io_data_n          => hispi_io_data_n,
      sclk_tready              => sclk_tready,
      sclk_tvalid              => sclk_tvalid,
      sclk_tuser               => sclk_tuser,
      sclk_tlast               => sclk_tlast,
      sclk_tdata               => sclk_tdata
      );


  xgs_mono_pipeline_inst : xgs_mono_pipeline
    generic map(
      SIMULATION => SIMULATION
      )
    port map(
      regfile      => regfile,
      sclk         => sclk,             -- TBD change to SCLK if required
      sclk_reset_n => sclk_reset_n,  -- TBD change to SCLK_RESET_N if required
      sclk_tready  => sclk_tready,
      sclk_tvalid  => sclk_tvalid,
      sclk_tuser   => sclk_tuser,
      sclk_tlast   => sclk_tlast,
      sclk_tdata   => sclk_tdata,
      aclk         => aclk,
      aclk_reset_n => aclk_reset_n,
      aclk_tready  => aclk_tready,
      aclk_tvalid  => aclk_tvalid,
      aclk_tuser   => aclk_tuser,
      aclk_tlast   => aclk_tlast,
      aclk_tdata   => aclk_tdata
      );


  xdmawr2tlp : dmawr2tlp
    generic map(
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      sclk               => aclk,
      srst_n             => aclk_reset_n,
      intevent           => irq_dma,
      context_strb       => load_dma_context,
      regfile            => regfile,
      tready             => aclk_tready,
      tvalid             => aclk_tvalid,
      tdata              => aclk_tdata,
      tuser              => aclk_tuser,
      tlast              => aclk_tlast,
      cfg_bus_mast_en    => cfg_bus_mast_en,
      cfg_setmaxpld      => cfg_setmaxpld,
      tlp_req_to_send    => tlp_req_to_send,
      tlp_grant          => tlp_grant,
      tlp_fmt_type       => tlp_fmt_type,
      tlp_length_in_dw   => tlp_length_in_dw,
      tlp_src_rdy_n      => tlp_src_rdy_n,
      tlp_dst_rdy_n      => tlp_dst_rdy_n,
      tlp_data           => tlp_data,
      tlp_address        => tlp_address,
      tlp_ldwbe_fdwbe    => tlp_ldwbe_fdwbe,
      tlp_attr           => tlp_attr,
      tlp_transaction_id => tlp_transaction_id,
      tlp_byte_count     => tlp_byte_count,
      tlp_lower_address  => tlp_lower_address
      );



  -----------------------------------------------------------------------------
  -- Process     : P_reg_readdatavalid
  -- Description : register file read data valid. Indicates when the data is
  --               return from the registerfile. By default the Matrox FDKIde
  --               does not generates by default a read data valid flag. Only
  --               when an External section is declared. In case of regular
  --               FF register, the read latency is 1 clock cycle.
  -----------------------------------------------------------------------------
  P_reg_readdatavalid : process (aclk) is
  begin
    if (rising_edge(aclk)) then
      if (aclk_reset_n = '0') then
        reg_readdatavalid <= '0';
      else
        reg_readdatavalid <= reg_read;
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- IDELAYCTRL is needed for SERDES calibration. 
  -----------------------------------------------------------------------------
  G_ENABLE_IDELAYCTRL : if (ENABLE_IDELAYCTRL > 0) generate
    xIDELAYCTRL : IDELAYCTRL
      port map (
        RDY    => regfile.HISPI.IDELAYCTRL_STATUS.PLL_LOCKED,
        REFCLK => idelay_clk,
        RST    => regfile.HISPI.CTRL.SW_CLR_IDELAYCTRL
        );
  end generate G_ENABLE_IDELAYCTRL;



  -----------------------------------------------------------------------------
  -- XGS CONTROLLER TOP 
  -----------------------------------------------------------------------------
  Inst_XGS_controller_top : XGS_controller_top
    generic map(
      -- Users to add parameters here
      G_SYS_CLK_PERIOD => SYS_CLK_PERIOD,
      G_SENSOR_FREQ    => SENSOR_FREQ,
      G_SIMULATION     => SIMULATION
      )
    port map(

      sys_clk     => aclk,
      sys_reset_n => aclk_reset_n,

      ------------------------------------------
      -- CMOS INTERFACE TO SENSOR
      ------------------------------------------
      xgs_power_good => xgs_power_good,
      xgs_clk_pll_en => xgs_clk_pll_en,
      xgs_reset_n    => xgs_reset_n,

      xgs_fwsi_en => xgs_fwsi_en,

      xgs_sclk  => xgs_sclk,
      xgs_cs_n  => xgs_cs_n,
      xgs_sdout => xgs_sdout,
      xgs_sdin  => xgs_sdin,

      xgs_trig_int => xgs_trig_int,
      xgs_trig_rd  => xgs_trig_rd,

      xgs_monitor0 => xgs_monitor0,
      xgs_monitor1 => xgs_monitor1,
      xgs_monitor2 => xgs_monitor2,

      ---------------------------------------------------------------------------
      --  OUTPUTS 
      ---------------------------------------------------------------------------
      anput_ext_trig => anput_ext_trig,

      anput_strobe_out   => anput_strobe_out,    --
      anput_exposure_out => anput_exposure_out,  --
      anput_trig_rdy_out => anput_trig_rdy_out,  --

      led_out => led_out,  -- led_out(0) --> vert, led_out(1) --> rouge

      ---------------------------------------------------------------------------
      --  DEBUG OUTPUTS 
      ---------------------------------------------------------------------------
      debug_out => debug_out,

      ---------------------------------------------------------------------------
      --  Signals to/from Datapath/DMA
      ---------------------------------------------------------------------------
      start_calibration => hispi_start_calibration,
      -- calibration_active => hispi_calibration_active, TBD

      HISPI_pix_clk => hispi_pix_clk,

      DEC_EOF => hispi_eof,

      abort_readout_datapath => open,
      dma_idle               => dma_idle,

      strobe_DMA_P1 => load_dma_context(0),
      strobe_DMA_P2 => load_dma_context(1),

      curr_db_GRAB_ROI2_EN => open,

      curr_db_y_start_ROI1 => hispi_ystart,
      curr_db_nblines_ROI1 => hispi_ysize,

      curr_db_y_start_ROI2 => open,
      curr_db_nblines_ROI2 => open,

      curr_db_subsampling_X => open,
      curr_db_subsampling_Y => open,

      curr_db_BUFFER_ID => open,

      first_lines_mask_cnt  => first_lines_mask_cnt, -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

      ---------------------------------------------------------------------------
      --  IRQ to system
      ---------------------------------------------------------------------------        
      irq_eos   => irq_eos,
      irq_sos   => irq_sos,
      irq_eoe   => irq_eoe,
      irq_soe   => irq_soe,
      irq_abort => irq_abort,

      ---------------------------------------------------------------------------
      --  Register file
      ---------------------------------------------------------------------------   
      regfile => regfile


      );



  irq(0) <= irq_dma;
  irq(1) <= irq_soe;
  irq(2) <= irq_eoe;
  irq(3) <= irq_sos;
  irq(4) <= irq_eos;
  irq(5) <= '0';
  irq(6) <= '0';
  irq(7) <= '0';


end struct;
