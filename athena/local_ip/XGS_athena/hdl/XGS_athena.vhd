-----------------------------------------------------------------------
-- MODULE        : XGS_athena
--
-- DESCRIPTION   : Matrox Custom OnSemi XGS sensor interface.
--
-- CLOCK DOMAINS : aclk       : AXI stream interface clock (Derived from PCIe CLK)
--                 sclk       : System clock (Pixel processing path)
--                 idelay_clk : Xilinx IDELAY BLOCK reference clock (200MHZ) 
--
-----------------------------------------------------------------------
--  PARAMETERS
--
--  ENABLE_IDELAYCTRL    : Instantiate or not the Xilinx IDELAYCTRL module
--                         under the Xilinx deserializer IP (hispi_phy_xilinx_selectio_wiz.v)
--
--                           0 : No IDELAYCTRL module is instantiated
--                           1 : One IDELAYCTRL module is instantiated
--                          
--  NUMBER_OF_LANE       : Determine the number of physical lanes implemented in
--                         the port map. The only supported values for now are 4
--                         and 6.
--
--                           4 : 4 lanes implemented (XGS 5000)
--                           6 : 6 lanes implemented (XGS 12000/16000) (default)
--                           Others => Not supported!
--
-- MAX_PCIE_PAYLOAD_SIZE : PCIe packets maximum payload size
--
--
-- SYS_CLK_PERIOD        : Indicates the System clock period in ns
--
-- SENSOR_FREQ           : Indicates the sensor reference frequency value in KHz
--
-- SIMULATION            : Indicate if the ip is used in the context of a
--                         simulation or in place and route (Implementation).
--                         Shorten XGS initialisation time in simulation only
--                         for faster simulation run time.
--
--                           0 : Used in Vivado (default)
--                           1 : Used in functionnal simulation
--
-- COLOR                 : Configure the pixel processing path for a Monochrome
--                         or color Pipeline
--
--                           0 : XGS_athena is configured for mono sensors (default) 
--                           1 : XGS_athena is configured for color sensors
-----------------------------------------------------------------------
--
-- TODO : 
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.regfile_xgs_athena_pack.all;
use work.hispi_pack.all;


entity XGS_athena is
  generic (
    ENABLE_IDELAYCTRL     : integer range 0 to 1 := 1;      -- Boolean (0 or 1)
    NUMBER_OF_LANE        : integer              := 6;      -- 4 or 6 lanes only
    MAX_PCIE_PAYLOAD_SIZE : integer              := 128;
    SYS_CLK_PERIOD        : integer              := 16;     -- Units in ns
    SENSOR_FREQ           : integer              := 32400;  -- Units in KHz
    SIMULATION            : integer              := 0;
    COLOR                 : integer range 0 to 1 := 0       -- Boolean (0 or 1)
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

    anput_strobe_out   : out std_logic;
    anput_exposure_out : out std_logic;
    anput_trig_rdy_out : out std_logic;

    led_out : out std_logic_vector(1 downto 0);  -- led_out(0) --> vert, led_out(1) --> rouge

    ---------------------------------------------------------------------------
    --  Debug interface 
    ---------------------------------------------------------------------------
    debug_out : out std_logic_vector(3 downto 0);

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


  ---------------------------------------------------------------------------
  --  Xilinx SYSTEM MONITOR MODULE
  ---------------------------------------------------------------------------
  component system_monitor
    port(
      daddr_in            : in  std_logic_vector (6 downto 0);  -- Address bus for the dynamic reconfiguration port
      den_in              : in  std_logic;  -- Enable Signal for the dynamic reconfiguration port
      di_in               : in  std_logic_vector (15 downto 0);  -- Input data bus for the dynamic reconfiguration port
      dwe_in              : in  std_logic;  -- Write Enable for the dynamic reconfiguration port
      do_out              : out std_logic_vector (15 downto 0);  -- Output data bus for dynamic reconfiguration port
      drdy_out            : out std_logic;  -- Data ready signal for the dynamic reconfiguration port
      dclk_in             : in  std_logic;  -- Clock input for the dynamic reconfiguration port
      reset_in            : in  std_logic;  -- Reset signal for the System Monitor control logic
      busy_out            : out std_logic;  -- ADC Busy signal
      channel_out         : out std_logic_vector (4 downto 0);  -- Channel Selection Outputs
      eoc_out             : out std_logic;  -- End of Conversion Signal
      eos_out             : out std_logic;  -- End of Sequence Signal
      user_temp_alarm_out : out std_logic;  -- Temperature-sensor alarm output
      alarm_out           : out std_logic;  -- OR'ed output of all the Alarms
      vp_in               : in  std_logic;  -- Dedicated Analog Input Pair
      vn_in               : in  std_logic
      );
  end component;

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
      resetN            : in    std_logic;  -- System reset
      sysclk            : in    std_logic;  -- System clock
      regfile           : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read          : in    std_logic;  -- Read
      reg_write         : in    std_logic;  -- Write
      reg_addr          : in    std_logic_vector(10 downto 2);  -- Address
      reg_beN           : in    std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata     : in    std_logic_vector(31 downto 0);  -- Write data
      reg_readdata      : out   std_logic_vector(31 downto 0);  -- Read data
      reg_readdatavalid : out   std_logic;  -- Read data valid

      ------------------------------------------------------------------------------------
      -- Interface name: SYSMONXIL
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_SYSMONXIL_addr          : out std_logic_vector(5 downto 0);  -- Address Bus for SYSMONXIL external section
      ext_SYSMONXIL_readEn        : out std_logic;  -- Read enable for SYSMONXIL external section
      ext_SYSMONXIL_readDataValid : in  std_logic;  -- Read Data Valid for SYSMONXIL external section
      ext_SYSMONXIL_readData      : in  std_logic_vector(31 downto 0)  -- Read Data for the SYSMONXIL external section


      );
  end component;


  component xgs_hispi_top is
    generic (
      HW_VERSION     : integer range 0 to 255 := 0;
      NUMBER_OF_LANE : integer                := 6; -- 4 or 6 lanes supported
      COLOR          : integer                := 0  -- 0 Mono; 1 Color
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
      hispi_subY               : in  std_logic;

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
      sclk_tdata  : out std_logic_vector(79 downto 0)
      );
  end component;


  -- component xgs_mono_pipeline is
    -- generic (
      -- SIMULATION : integer := 0
      -- );
    -- port (
      -- ---------------------------------------------------------------------------
      -- -- Register file
      -- ---------------------------------------------------------------------------
      -- regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;

      -- ---------------------------------------------------------------------------
      -- -- AXI Slave interface
      -- ---------------------------------------------------------------------------
      -- sclk         : in std_logic;
      -- sclk_reset_n : in std_logic;

      -- ---------------------------------------------------------------------------
      -- -- AXI slave stream input interface
      -- ---------------------------------------------------------------------------
      -- sclk_tready : out std_logic;
      -- sclk_tvalid : in  std_logic;
      -- sclk_tuser  : in  std_logic_vector(3 downto 0);
      -- sclk_tlast  : in  std_logic;
      -- sclk_tdata  : in  std_logic_vector(79 downto 0);

      -- ---------------------------------------------------------------------------
      -- -- AXI Slave interface
      -- ---------------------------------------------------------------------------
      -- aclk         : in std_logic;
      -- aclk_reset_n : in std_logic;

      -- ---------------------------------------------------------------------------
      -- -- AXI master stream output interface
      -- ---------------------------------------------------------------------------
      -- aclk_tready : in  std_logic;
      -- aclk_tvalid : out std_logic;
      -- aclk_tuser  : out std_logic_vector(3 downto 0);
      -- aclk_tlast  : out std_logic;
      -- aclk_tdata  : out std_logic_vector(79 downto 0)
      -- );
  -- end component;


  component dpc_filter is
    generic(DPC_CORR_PIXELS_DEPTH : integer := 6);  --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024

    port(


      ---------------------------------------------------------------------
      -- Pixel domain reset and clock signals
      ---------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      curr_Xstart : in std_logic_vector(12 downto 0) := (others => '0');  --pixel
      curr_Xend   : in std_logic_vector(12 downto 0) := (others => '1');  --pixel

      curr_Ystart : in std_logic_vector(11 downto 0) := (others => '0');  --line
      curr_Yend   : in std_logic_vector(11 downto 0) := (others => '1');  --line    

      curr_Ysub : in std_logic := '0';

      load_dma_context_EOFOT : in std_logic := '0';  -- in axi_clk

      ---------------------------------------------------------------------
      -- Registers
      ---------------------------------------------------------------------
      REG_dpc_list_length : out std_logic_vector(11 downto 0);
      REG_dpc_ver         : out std_logic_vector(3 downto 0);

      REG_color : in std_logic := '0';  -- to bypass in color modes

      REG_dpc_enable : in std_logic := '1';

      REG_dpc_pattern0_cfg : in std_logic := '0';

      REG_dpc_fifo_rst : in  std_logic := '0';
      REG_dpc_fifo_ovr : out std_logic;
      REG_dpc_fifo_und : out std_logic;

      REG_dpc_list_wrn   : in std_logic;
      REG_dpc_list_add   : in std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);
      REG_dpc_list_ss    : in std_logic;
      REG_dpc_list_count : in std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);

      REG_dpc_list_corr_pattern : in std_logic_vector(7 downto 0);
      REG_dpc_list_corr_y       : in std_logic_vector(11 downto 0);
      REG_dpc_list_corr_x       : in std_logic_vector(12 downto 0);

      REG_dpc_list_corr_rd : out std_logic_vector(32 downto 0);

      REG_dpc_firstlast_line_rem : in std_logic := '0';

      ---------------------------------------------------------------------
      -- AXI in
      ---------------------------------------------------------------------  
      s_axis_tvalid : in  std_logic;
      s_axis_tready : out std_logic;
      s_axis_tuser  : in  std_logic_vector(3 downto 0);
      s_axis_tlast  : in  std_logic;
      s_axis_tdata  : in  std_logic_vector;

      ---------------------------------------------------------------------
      -- AXI out
      ---------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic_vector(3 downto 0);
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(79 downto 0)
      );
  end component;


  component axi_lut
    port (
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- AXI in
      ---------------------------------------------------------------------  
      s_axis_tvalid : in  std_logic;
      s_axis_tready : out std_logic;
      s_axis_tuser  : in  std_logic_vector(3 downto 0);
      s_axis_tlast  : in  std_logic;
      s_axis_tdata  : in  std_logic_vector;

      ---------------------------------------------------------------------
      -- AXI out 
      ---------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic_vector(3 downto 0);
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0);

      ---------------------------------------------------------------------------
      --  Registers
      ---------------------------------------------------------------------------
      regfile : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE
      );
  end component;

  component axis_width_conv 
   port (  

           ---------------------------------------------------------------------
           -- Axi domain reset and clock signals
           ---------------------------------------------------------------------
           axi_clk                                 : in    std_logic;
           axi_reset_n                             : in    std_logic;

           ---------------------------------------------------------------------
           -- AXI in
           ---------------------------------------------------------------------  
           s_axis_tvalid                           : in   std_logic;
           s_axis_tready                           : out  std_logic;
           s_axis_tuser                            : in   std_logic_vector(3 downto 0);
           s_axis_tlast                            : in   std_logic;
           s_axis_tdata                            : in   std_logic_vector(79 downto 0);	
           
           ---------------------------------------------------------------------
           -- AXI out
           ---------------------------------------------------------------------
           m_axis_tready                           : in  std_logic;
           m_axis_tvalid                           : out std_logic;
           m_axis_tuser                            : out std_logic_vector(3 downto 0);
           m_axis_tlast                            : out std_logic;
           m_axis_tdata                            : out std_logic_vector(19 downto 0)

        );
  end component;  
  
  
  component xgs_color_proc
    generic(DPC_CORR_PIXELS_DEPTH : integer := 9  --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024

            );
    port (

      ---------------------------------------------------------------------
      -- Axi domain reset and clock signals
      ---------------------------------------------------------------------
      axi_clk     : in std_logic;
      axi_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- AXI in
      ---------------------------------------------------------------------  
      s_axis_tvalid : in  std_logic;
      s_axis_tready : out std_logic;
      --s_axis_tready_int                       : in   std_logic;   --temporaire on va juste se hooker
      s_axis_tuser  : in  std_logic_vector(3 downto 0);
      s_axis_tlast  : in  std_logic;
      s_axis_tdata  : in  std_logic_vector(19 downto 0);

      ---------------------------------------------------------------------
      -- AXI out
      ---------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tuser  : out std_logic_vector(3 downto 0);
      m_axis_tlast  : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0);

      ---------------------------------------------------------------------
      -- Grab params
      ---------------------------------------------------------------------                
      curr_Xstart : in std_logic_vector(12 downto 0) := (others => '0');  --pixel
      curr_Xend   : in std_logic_vector(12 downto 0) := (others => '1');  --pixel                                                                               
      curr_Ystart : in std_logic_vector(11 downto 0) := (others => '0');  --line
      curr_Yend   : in std_logic_vector(11 downto 0) := (others => '1');  --line                                                                                                
      curr_Ysub   : in std_logic                     := '0';

      ---------------------------------------------------------------------
      -- Registers
      ---------------------------------------------------------------------
      REG_dpc_list_length : out std_logic_vector(11 downto 0);
      REG_dpc_ver         : out std_logic_vector(3 downto 0);

      REG_dpc_enable : in std_logic := '1';

      REG_dpc_pattern0_cfg : in std_logic := '0';

      REG_dpc_list_wrn   : in std_logic;
      REG_dpc_list_add   : in std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);
      REG_dpc_list_ss    : in std_logic;
      REG_dpc_list_count : in std_logic_vector(DPC_CORR_PIXELS_DEPTH-1 downto 0);

      REG_dpc_list_corr_pattern : in std_logic_vector(7 downto 0);
      REG_dpc_list_corr_y       : in std_logic_vector(11 downto 0);
      REG_dpc_list_corr_x       : in std_logic_vector(12 downto 0);

      REG_dpc_list_corr_rd : out std_logic_vector(32 downto 0);

      REG_wb_b_acc : out std_logic_vector(30 downto 0);
      REG_wb_g_acc : out std_logic_vector(31 downto 0);
      REG_wb_r_acc : out std_logic_vector(30 downto 0);

      REG_WB_MULT_R : in std_logic_vector(15 downto 0) := "0001000000000000";
      REG_WB_MULT_G : in std_logic_vector(15 downto 0) := "0001000000000000";
      REG_WB_MULT_B : in std_logic_vector(15 downto 0) := "0001000000000000";

      REG_bayer_ver : out std_logic_vector(1 downto 0);	     

      load_dma_context  : in std_logic_vector(1 downto 0):=(others=>'0');
	  REG_COLOR_SPACE   : in std_logic_vector(2 downto 0);	   

      REG_LUT_BYPASS       : in std_logic;
      REG_LUT_BYPASS_COLOR : in std_logic;
      REG_LUT_SEL    : in std_logic_vector(3 downto 0);
      REG_LUT_SS     : in std_logic;
      REG_LUT_WRN    : in std_logic;
      REG_LUT_ADD    : in std_logic_vector;
      REG_LUT_DATA_W : in std_logic_vector;
	  
	  CCM_EN         : in std_logic;
	  
      KRr            : in std_logic_vector(11 downto 0);
      KRg            : in std_logic_vector(11 downto 0); 
      KRb            : in std_logic_vector(11 downto 0);
      Offr           : in std_logic_vector(8 downto 0); 

      KGr            : in std_logic_vector(11 downto 0);
      KGg            : in std_logic_vector(11 downto 0); 
      KGb            : in std_logic_vector(11 downto 0);
      Offg           : in std_logic_vector(8 downto 0); 

      KBr            : in std_logic_vector(11 downto 0);
      KBg            : in std_logic_vector(11 downto 0); 
      KBb            : in std_logic_vector(11 downto 0);
      Offb           : in std_logic_vector(8 downto 0) 



      );
  end component;


  component trim is
    generic (
      NUMB_LINE_BUFFER : integer range 2 to 4 := 2
      );
    port (
      ---------------------------------------------------------------------------
      -- Register file
      ---------------------------------------------------------------------------
      aclk_grab_queue_en : in std_logic;
      aclk_load_context  : in std_logic_vector(1 downto 0);
      aclk_color_space   : in std_logic_vector(2 downto 0);
      aclk_x_crop_en     : in std_logic;
      aclk_x_start       : in std_logic_vector(12 downto 0);
      aclk_x_size        : in std_logic_vector(12 downto 0);
      aclk_x_scale       : in std_logic_vector(3 downto 0);
      aclk_x_reverse     : in std_logic;
      aclk_y_roi_en      : in std_logic;
      aclk_y_start       : in std_logic_vector(12 downto 0);
      aclk_y_size        : in std_logic_vector(12 downto 0);

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
  end component;



  component dmawr2tlp is
    generic (
      COLOR                 : integer := 0;
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

      --curr_db_GRAB_ROI2_EN : out std_logic := '0';

      curr_db_y_start_ROI1 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base
      curr_db_y_end_ROI1   : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  
      curr_db_y_size_ROI1  : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base    

      curr_db_x_start_ROI1 : out std_logic_vector(12 downto 0) := (others => '0');  -- 1-base
      curr_db_x_end_ROI1   : out std_logic_vector(12 downto 0) := (others => '0');  -- 1-base  
      curr_db_x_size_ROI1  : out std_logic_vector(12 downto 0) := (others => '0');  -- 1-base    

      --curr_db_y_start_ROI2 : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  
      --curr_db_y_end_ROI2   : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  
      --curr_db_y_size_ROI2  : out std_logic_vector(11 downto 0) := (others => '0');  -- 1-base  

      curr_db_subsampling_X : out std_logic := '0';
      curr_db_subsampling_Y : out std_logic := '0';

      curr_db_BUFFER_ID : out std_logic := '0';

      first_lines_mask_cnt : out std_logic_vector(9 downto 0);  -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

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

  ----------------------------------------
  -- DPC MODULE 
  -- Nombre de pixels maximum a corriger
  ----------------------------------------
  -- DPC_CORR_PIXELS_DEPTH=6  =>   63 pixels, 6+1+4:  11 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=7  =>  127 pixels, 6+1+4:  11 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=8  =>  255 pixels, 6+1+4:  11 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=9  =>  511 pixels, 6+1+4:  11 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=10 => 1023 pixels, 6+1+8:  15 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=11 => 2047 pixels, 6+2+16: 24 RAM36K 
  -- DPC_CORR_PIXELS_DEPTH=12 => 4095 pixels, 6+4+32: 42 RAM36K   
  constant DPC_CORR_PIXELS_DEPTH : integer := 9;

  signal aclk_reset : std_logic;

  signal regfile           : REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE;  -- Register file
  signal reg_read          : std_logic;
  signal reg_write         : std_logic;
  signal reg_addr          : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal reg_beN           : std_logic_vector(3 downto 0);
  signal reg_writedata     : std_logic_vector(31 downto 0);
  signal reg_readdata      : std_logic_vector(31 downto 0);
  signal reg_readdatavalid : std_logic;

  -- External SysMon
  signal ext_SYSMONXIL_addr          : std_logic_vector(5 downto 0);
  signal ext_SYSMONXIL_readEn        : std_logic;
  signal ext_SYSMONXIL_readDataValid : std_logic;
  signal ext_SYSMONXIL_readData      : std_logic_vector(15 downto 0);

  ----------------------------------------------------------------------
  -- system_monitor
  ----------------------------------------------------------------------
  signal sysmon_dadddr           : std_logic_vector(5 downto 0);
  signal sysmon_readEn           : std_logic;
  signal sysmon_readData         : std_logic_vector(15 downto 0);
  signal sysmon_readDataValid    : std_logic;
  signal sysmon_busy             : std_logic;
  signal sysmon_reg_readEn       : std_logic;
  signal ext_SYSMONXIL_readEn_ff : std_logic;
  signal ext_SYSMONXIL_addr_ff   : std_logic_vector(5 downto 0);

  -- AXI drive by xgs_hispi_top
  signal sclk_tready : std_logic;
  signal sclk_tvalid : std_logic;
  signal sclk_tlast  : std_logic;
  signal sclk_tuser  : std_logic_vector(3 downto 0);
  signal sclk_tdata  : std_logic_vector(79 downto 0);

  -- AXI drive by mono pipeline --sys_clk : 62.5mhz
  signal aclk_tready : std_logic;
  signal aclk_tvalid : std_logic;
  --signal aclk_tdata  : std_logic_vector(63 downto 0);
  signal aclk_tdata  : std_logic_vector(79 downto 0);
  signal aclk_tuser  : std_logic_vector(3 downto 0);
  signal aclk_tlast  : std_logic;
  --signal tmp_tdata   : std_logic_vector(79 downto 0);

  -- AXI drive by DCP --sys_clk : 62.5mhz
  signal dcp_tready : std_logic;
  signal dcp_tvalid : std_logic;
  signal dcp_tdata  : std_logic_vector(79 downto 0);
  signal dcp_tuser  : std_logic_vector(3 downto 0);
  signal dcp_tlast  : std_logic;

  -- axi from dwidth converter 
  signal conv_tvalid : std_logic;
  signal conv_tready : std_logic;
  signal conv_tuser  : std_logic_vector(3 downto 0);
  signal conv_tlast  : std_logic;
  signal conv_tdata  : std_logic_vector(19 downto 0);
  
  -- AXI drive by LUT in Modo (COLOR=0) or by
  -- xgs_color_proc in color mode (COLOR=1)
  -- sys_clk : 62.5mhz
  signal trim_pixel_width : std_logic_vector(2 downto 0):= "000";  --temp
  
  signal trim_tready : std_logic;
  signal trim_tvalid : std_logic;
  signal trim_tdata  : std_logic_vector(63 downto 0);
  signal trim_tuser  : std_logic_vector(3 downto 0);
  signal trim_tlast  : std_logic;


  -- AXI received by DMA
  signal dma_tready : std_logic;
  signal dma_tvalid : std_logic;
  signal dma_tdata  : std_logic_vector(63 downto 0);
  signal dma_tuser  : std_logic_vector(3 downto 0);
  signal dma_tlast  : std_logic;




  signal load_dma_context : std_logic_vector(1 downto 0);

  signal irq_dma                  : std_logic;
  signal irq_eos                  : std_logic;
  signal irq_sos                  : std_logic;
  signal irq_eoe                  : std_logic;
  signal irq_soe                  : std_logic;
  signal irq_abort                : std_logic;
  signal irq_hispi_error          : std_logic;
  signal hispi_start_calibration  : std_logic;
  signal hispi_calibration_active : std_logic;
  signal hispi_pix_clk            : std_logic;
  signal hispi_eof                : std_logic;
  signal hispi_ystart             : std_logic_vector(11 downto 0);
  signal hispi_yend               : std_logic_vector(11 downto 0);
  signal hispi_ysize              : std_logic_vector(11 downto 0);
  signal hispi_ydiv2_en           : std_logic;
  signal hispi_xstart             : std_logic_vector(12 downto 0);
  signal hispi_xend               : std_logic_vector(12 downto 0);
  signal hispi_xsize              : std_logic_vector(12 downto 0);

  signal hispi_subX           : std_logic;
  signal hispi_subY           : std_logic;
  signal first_lines_mask_cnt : std_logic_vector(9 downto 0);  -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

  signal dma_idle : std_logic := '1';

  signal REG_DPC_FIFO_OVR     : std_logic                     := '0';
  signal REG_DPC_FIFO_UND     : std_logic                     := '0';
  signal REG_dpc_list_corr_rd : std_logic_vector(32 downto 0) := (others => '0');
  signal REG_dpc_list_length  : std_logic_vector(11 downto 0);
  signal REG_dpc_ver          : std_logic_vector(3 downto 0);

  signal REG_bayer_ver        : std_logic_vector(1 downto 0); 
  
  
  signal trim_x_scale         : std_logic_vector(regfile.DMA.CSC.SUB_X'range);
  
  -- signal temporaire pour d/veloppement
  signal tmp_valid : std_logic;


begin

  -----------------------------------------------------------------------------
  -- Hardware version
  -----------------------------------------------------------------------------
  -- regfile.SYSTEM.VERSION.HW <= HW_VERSION; Assigned under xgs_hispi_top.vhd

  --invert reset to sys monitor
  aclk_reset <= not(aclk_reset_n);

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
      resetN                               => aclk_reset_n,
      sysclk                               => aclk,
      regfile                              => regfile,
      reg_read                             => reg_read,
      reg_write                            => reg_write,
      reg_addr                             => reg_addr(C_S_AXI_ADDR_WIDTH-1 downto 2),
      reg_beN                              => reg_beN,
      reg_writedata                        => reg_writedata,
      reg_readdata                         => reg_readdata,
      reg_readdatavalid                    => reg_readdatavalid,
      ------------------------------------------------------------------------------------
      -- Interface name: SYSMONXIL
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_SYSMONXIL_addr                   => ext_SYSMONXIL_addr,  -- Address Bus for SYSMONXIL external section
      ext_SYSMONXIL_readEn                 => ext_SYSMONXIL_readEn,  -- Read enable for SYSMONXIL external section
      ext_SYSMONXIL_readDataValid          => ext_SYSMONXIL_readDataValid,
      ext_SYSMONXIL_readData(31 downto 16) => X"0000",
      ext_SYSMONXIL_readData(15 downto 0)  => ext_SYSMONXIL_readData

      );


  x_xgs_hispi_top : xgs_hispi_top
    generic map(
      HW_VERSION     => HW_VERSION,
      NUMBER_OF_LANE => NUMBER_OF_LANE,
      COLOR          => COLOR
      )
    port map(
      -- sclk                     => sclk,
      -- sclk_reset_n             => sclk_reset_n,
      sclk                     => aclk,
      sclk_reset_n             => aclk_reset_n,
      rclk                     => aclk,
      rclk_reset_n             => aclk_reset_n,
      regfile                  => regfile,
      rclk_irq_error           => irq_hispi_error,
      idelay_clk               => idelay_clk,
      hispi_start_calibration  => hispi_start_calibration,
      hispi_calibration_active => hispi_calibration_active,
      hispi_pix_clk            => hispi_pix_clk,
      hispi_eof                => hispi_eof,
      hispi_ystart             => hispi_ystart,
      hispi_ysize              => hispi_ysize,
      hispi_subY               => hispi_subY,
      hispi_io_clk_p           => hispi_io_clk_p,
      hispi_io_clk_n           => hispi_io_clk_n,
      hispi_io_data_p          => hispi_io_data_p,
      hispi_io_data_n          => hispi_io_data_n,
      sclk_tready              => aclk_tready,
      sclk_tvalid              => aclk_tvalid,
      sclk_tuser               => aclk_tuser,
      sclk_tlast               => aclk_tlast,
      sclk_tdata               => aclk_tdata
      );


  -- xgs_mono_pipeline_inst : xgs_mono_pipeline
  --   generic map(
  --     SIMULATION => SIMULATION
  --     )
  --   port map(
  --     regfile      => regfile,
  --     sclk         => sclk,
  --     sclk_reset_n => sclk_reset_n,
  --     sclk_tready  => sclk_tready,
  --     sclk_tvalid  => sclk_tvalid,
  --     sclk_tuser   => sclk_tuser,
  --     sclk_tlast   => sclk_tlast,
  --     sclk_tdata   => sclk_tdata,

  --     aclk         => aclk,
  --     aclk_reset_n => aclk_reset_n,
  --     aclk_tready  => aclk_tready,
  --     aclk_tvalid  => aclk_tvalid,
  --     aclk_tuser   => aclk_tuser,
  --     aclk_tlast   => aclk_tlast,
  --     aclk_tdata   => aclk_tdata
  --     );


  ----------------------------------
  --
  -- MONO PIPELINE
  --
  ----------------------------------
  G_MONO_PIPELINE : if (COLOR = 0) generate
    ----------------------------------
    --
    -- DCP
    --
    ----------------------------------
    xdpc_filter : dpc_filter
      generic map (DPC_CORR_PIXELS_DEPTH => DPC_CORR_PIXELS_DEPTH)  --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024

      port map(

        ---------------------------------------------------------------------
        -- System and Pixel domain reset and clock signals
        ---------------------------------------------------------------------
        axi_clk     => aclk,
        axi_reset_n => aclk_reset_n,

        ---------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------
        curr_Xstart => regfile.HISPI.FRAME_CFG_X_VALID.X_START,  -- This register includes blanking, BL, Dummy, interpolations. It will be corrected internally 
        curr_Xend   => regfile.HISPI.FRAME_CFG_X_VALID.X_END,  -- This register includes blanking, BL, Dummy, interpolations. It will be corrected internally

        curr_Ystart => hispi_ystart,
        curr_Yend   => hispi_yend,

        curr_Ysub => hispi_subY,

        load_dma_context_EOFOT => load_dma_context(1),

        ---------------------------------------------------------------------
        -- Registers
        ---------------------------------------------------------------------
        REG_dpc_list_length => REG_dpc_list_length,
        REG_dpc_ver         => REG_dpc_ver,


        REG_color => '0',               -- to bypass in color modes

        REG_dpc_enable => regfile.DPC.DPC_LIST_CTRL.dpc_enable,

        REG_dpc_pattern0_cfg => regfile.DPC.DPC_LIST_CTRL.dpc_pattern0_cfg,

        REG_dpc_fifo_rst => regfile.DPC.DPC_LIST_CTRL.dpc_fifo_reset,
        REG_dpc_fifo_ovr => REG_DPC_FIFO_OVR,
        REG_dpc_fifo_und => REG_DPC_FIFO_UND,

        REG_dpc_list_wrn   => regfile.DPC.DPC_LIST_CTRL.dpc_list_WRn,
        REG_dpc_list_add   => regfile.DPC.DPC_LIST_CTRL.dpc_list_add(DPC_CORR_PIXELS_DEPTH-1 downto 0),
        REG_dpc_list_ss    => regfile.DPC.DPC_LIST_CTRL.dpc_list_ss,
        REG_dpc_list_count => regfile.DPC.DPC_LIST_CTRL.dpc_list_count(DPC_CORR_PIXELS_DEPTH-1 downto 0),

        REG_dpc_list_corr_pattern => regfile.DPC.DPC_LIST_DATA2.dpc_list_corr_pattern,
        REG_dpc_list_corr_y       => regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_y,
        REG_dpc_list_corr_x       => regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_x,

        REG_dpc_list_corr_rd => REG_dpc_list_corr_rd,

        REG_dpc_firstlast_line_rem => regfile.DPC.DPC_LIST_CTRL.dpc_firstlast_line_rem,

        ---------------------------------------------------------------------
        -- AXI in (SLAVE)
        ---------------------------------------------------------------------  
        s_axis_tvalid => aclk_tvalid,
        s_axis_tready => aclk_tready,
        s_axis_tuser  => aclk_tuser,
        s_axis_tlast  => aclk_tlast,
        s_axis_tdata  => aclk_tdata,

        ---------------------------------------------------------------------
        -- AXI out (MASTER)
        ---------------------------------------------------------------------
        m_axis_tvalid => dcp_tvalid,
        m_axis_tready => dcp_tready,
        m_axis_tuser  => dcp_tuser,
        m_axis_tlast  => dcp_tlast,
        m_axis_tdata  => dcp_tdata
        );

    --DCP REGISTERS  
    regfile.DPC.DPC_CAPABILITIES.DPC_LIST_LENGTH <= REG_dpc_list_length;
    regfile.DPC.DPC_CAPABILITIES.DPC_VER         <= REG_dpc_ver;

    regfile.DPC.DPC_LIST_STAT.dpc_fifo_overrun          <= REG_DPC_FIFO_OVR;
    regfile.DPC.DPC_LIST_STAT.dpc_fifo_underrun         <= REG_DPC_FIFO_UND;
    regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_x       <= REG_dpc_list_corr_rd(12 downto 0);  --13 bits
    regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_y       <= REG_dpc_list_corr_rd(24 downto 13);  --12 bits
    regfile.DPC.DPC_LIST_DATA2_RD.dpc_list_corr_pattern <= REG_dpc_list_corr_rd(32 downto 25);  --8 bits   

    ----------------------------------
    --
    -- LUT
    --
    ----------------------------------
    xaxi_lut : axi_lut
      port map (
        axi_clk     => aclk,
        axi_reset_n => aclk_reset_n,

        ---------------------------------------------------------------------
        -- AXI in
        ---------------------------------------------------------------------  
        s_axis_tvalid => dcp_tvalid,
        s_axis_tready => dcp_tready,
        s_axis_tuser  => dcp_tuser,
        s_axis_tlast  => dcp_tlast,
        s_axis_tdata  => dcp_tdata,

        ---------------------------------------------------------------------
        -- AXI out
        ---------------------------------------------------------------------
        m_axis_tvalid => trim_tvalid,
        m_axis_tready => trim_tready,
        m_axis_tuser  => trim_tuser,
        m_axis_tlast  => trim_tlast,
        m_axis_tdata  => trim_tdata,

        ---------------------------------------------------------------------------
        --  Registers
        ---------------------------------------------------------------------------
        regfile => regfile
        );


    regfile.BAYER.WB_B_ACC.B_ACC <= (others => '0');
    regfile.BAYER.WB_G_ACC.G_ACC <= (others => '0');
    regfile.BAYER.WB_R_ACC.R_ACC <= (others => '0');
    
	regfile.BAYER.BAYER_CAPABILITIES.BAYER_VER  <= "00";

    ---------------------------
    -- MONO
    ---------------------------
    -- lut_tready <= dma_tready;
    -- dma_tvalid <= lut_tvalid;
    -- dma_tdata  <= lut_tdata;
    -- dma_tuser  <= lut_tuser;
    -- dma_tlast  <= lut_tlast;


    --------------------------------------------------------------------
    -- To bypass DPC and LUT to have more RAM to chipscope
    --
    -- 1) comment DPC and LUT component declaration
    -- 2) comment DPC and LUT component instantation
    -- 3) remove regfile DPC and LUT sections and compile regifile
    --------------------------------------------------------------------
    --
    --lut_tvalid  <= aclk_tvalid;
    --aclk_tready <= lut_tready;
    --lut_tuser   <= aclk_tuser; 
    --lut_tlast   <= aclk_tlast; 
    --lut_tdata   <= aclk_tdata(79 downto 72) & aclk_tdata(69 downto 62) & aclk_tdata(59 downto 52) & aclk_tdata(49 downto 42) &
    --               aclk_tdata(39 downto 32) & aclk_tdata(29 downto 22) & aclk_tdata(19 downto 12) & aclk_tdata(9  downto  2) ; 

    trim_pixel_width <= "001";

    
  end generate G_MONO_PIPELINE;  --MONO PIPELINE






  ----------------------------------
  --
  -- COLOR PIPELINE
  --
  ----------------------------------
  G_COLOR_PIPELINE : if (COLOR = 1) generate

  
  
  Xaxis_width_conv : axis_width_conv
   port map(  

           ---------------------------------------------------------------------
           -- Axi domain reset and clock signals
           ---------------------------------------------------------------------
           axi_clk                                 => aclk,
           axi_reset_n                             => aclk_reset_n,

           ---------------------------------------------------------------------
           -- AXI in
           ---------------------------------------------------------------------  
           s_axis_tvalid                           => aclk_tvalid,
           s_axis_tready                           => aclk_tready,
           s_axis_tuser                            => aclk_tuser,
           s_axis_tlast                            => aclk_tlast,
           s_axis_tdata                            => aclk_tdata,	
           
           ---------------------------------------------------------------------
           -- AXI out
           ---------------------------------------------------------------------
           m_axis_tready                           => conv_tready,
           m_axis_tvalid                           => conv_tvalid,
           m_axis_tuser                            => conv_tuser,
           m_axis_tlast                            => conv_tlast,
           m_axis_tdata                            => conv_tdata

        );

  
    Xxgs_color_proc : xgs_color_proc
      generic map(DPC_CORR_PIXELS_DEPTH => DPC_CORR_PIXELS_DEPTH  --6=>64,  7=>128, 8=>256, 9=>512, 10=>1024

                  )
      port map(

        ---------------------------------------------------------------------
        -- Axi domain reset and clock signals
        ---------------------------------------------------------------------
        axi_clk     => aclk,
        axi_reset_n => aclk_reset_n,

        ---------------------------------------------------------------------
        -- AXI in
        ---------------------------------------------------------------------         
        s_axis_tvalid => conv_tvalid,
        s_axis_tready => conv_tready,
        s_axis_tuser  => conv_tuser,
        s_axis_tlast  => conv_tlast,
        s_axis_tdata  => conv_tdata,

        ---------------------------------------------------------------------
        -- AXI out
        ---------------------------------------------------------------------
        m_axis_tready => trim_tready,
        m_axis_tvalid => trim_tvalid,
        m_axis_tuser  => trim_tuser,
        m_axis_tlast  => trim_tlast,
        m_axis_tdata  => trim_tdata,

        -- m_axis_tready => dma_tready,
        -- m_axis_tvalid => dma_tvalid,
        -- m_axis_tuser  => dma_tuser,
        -- m_axis_tlast  => dma_tlast,
        -- m_axis_tdata  => dma_tdata,
        
        
        ---------------------------------------------------------------------              
        -- Grab parameters         
        ---------------------------------------------------------------------
        curr_Xstart   => regfile.HISPI.FRAME_CFG_X_VALID.X_START,  -- This register includes blanking, BL, Dummy, interpolations. It will be corrected internally 
        curr_Xend     => regfile.HISPI.FRAME_CFG_X_VALID.X_END,  -- This register includes blanking, BL, Dummy, interpolations. It will be corrected internally

        curr_Ystart => hispi_ystart,
        curr_Yend   => hispi_yend,

        curr_Ysub => hispi_subY,


        ---------------------------------------------------------------------
        -- Regfile
        ---------------------------------------------------------------------
        REG_dpc_list_length => REG_dpc_list_length,
        REG_dpc_ver         => REG_dpc_ver,

        REG_dpc_enable       => regfile.DPC.DPC_LIST_CTRL.dpc_enable,
        REG_dpc_pattern0_cfg => regfile.DPC.DPC_LIST_CTRL.dpc_pattern0_cfg,
        REG_dpc_list_wrn     => regfile.DPC.DPC_LIST_CTRL.dpc_list_WRn,
        REG_dpc_list_add     => regfile.DPC.DPC_LIST_CTRL.dpc_list_add(DPC_CORR_PIXELS_DEPTH-1 downto 0),
        REG_dpc_list_ss      => regfile.DPC.DPC_LIST_CTRL.dpc_list_ss,
        REG_dpc_list_count   => regfile.DPC.DPC_LIST_CTRL.dpc_list_count(DPC_CORR_PIXELS_DEPTH-1 downto 0),

        REG_dpc_list_corr_pattern => regfile.DPC.DPC_LIST_DATA2.dpc_list_corr_pattern,
        REG_dpc_list_corr_y       => regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_y,
        REG_dpc_list_corr_x       => regfile.DPC.DPC_LIST_DATA1.dpc_list_corr_x,

        REG_dpc_list_corr_rd => REG_dpc_list_corr_rd,
        REG_wb_b_acc         => regfile.BAYER.WB_B_ACC.B_ACC,
        REG_wb_g_acc         => regfile.BAYER.WB_G_ACC.G_ACC,
        REG_wb_r_acc         => regfile.BAYER.WB_R_ACC.R_ACC,

        REG_WB_MULT_R => regfile.BAYER.WB_MUL2.WB_MULT_R,
        REG_WB_MULT_G => regfile.BAYER.WB_MUL1.WB_MULT_G,
        REG_WB_MULT_B => regfile.BAYER.WB_MUL1.WB_MULT_B,

  	    REG_bayer_ver     => REG_bayer_ver,

        load_dma_context  =>  load_dma_context,  
		REG_COLOR_SPACE   =>  regfile.DMA.CSC.COLOR_SPACE, 

        REG_LUT_BYPASS       => regfile.LUT.LUT_CTRL.LUT_BYPASS,
        REG_LUT_BYPASS_COLOR => regfile.LUT.LUT_CTRL.LUT_BYPASS_COLOR,
		
        REG_LUT_SEL    => regfile.LUT.LUT_CTRL.LUT_SEL,
        REG_LUT_SS     => regfile.LUT.LUT_CTRL.LUT_SS,
        REG_LUT_WRN    => regfile.LUT.LUT_CTRL.LUT_WRN,
        REG_LUT_ADD    => regfile.LUT.LUT_CTRL.LUT_ADD,
        REG_LUT_DATA_W => regfile.LUT.LUT_CTRL.LUT_DATA_W,

        CCM_EN		   => regfile.BAYER.CCM_CTRL.CCM_EN,
	    
		KRr            => regfile.BAYER.CCM_KR1.Kr,
        KRg            => regfile.BAYER.CCM_KR1.Kg,
        KRb            => regfile.BAYER.CCM_KR2.Kb,
        Offr           => regfile.BAYER.CCM_KR2.KOff,

        KGr            => regfile.BAYER.CCM_KG1.Kr,  
        KGg            => regfile.BAYER.CCM_KG1.Kg,   
        KGb            => regfile.BAYER.CCM_KG2.Kb,  
        Offg           => regfile.BAYER.CCM_KG2.KOff,  
        
        KBr            => regfile.BAYER.CCM_KB1.Kr,  
        KBg            => regfile.BAYER.CCM_KB1.Kg,   
        KBb            => regfile.BAYER.CCM_KB2.Kb,   
        Offb           => regfile.BAYER.CCM_KB2.KOff  		

        );

    regfile.LUT.LUT_CAPABILITIES.LUT_VER         <= conv_std_logic_vector(1, regfile.LUT.LUT_CAPABILITIES.LUT_VER'length);
    regfile.LUT.LUT_CAPABILITIES.LUT_SIZE_CONFIG <= conv_std_logic_vector(2, regfile.LUT.LUT_CAPABILITIES.LUT_SIZE_CONFIG'length);
    regfile.LUT.LUT_RB.LUT_RB                    <= (others => '0');

    regfile.DPC.DPC_CAPABILITIES.DPC_LIST_LENGTH <= "000111111111";
    regfile.DPC.DPC_CAPABILITIES.DPC_VER         <= "0001";  --color

    regfile.DPC.DPC_LIST_STAT.dpc_fifo_overrun          <= REG_DPC_FIFO_OVR;
    regfile.DPC.DPC_LIST_STAT.dpc_fifo_underrun         <= REG_DPC_FIFO_UND;
    regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_x       <= REG_dpc_list_corr_rd(12 downto 0);  --13 bits
    regfile.DPC.DPC_LIST_DATA1_RD.dpc_list_corr_y       <= REG_dpc_list_corr_rd(24 downto 13);  --12 bits
    regfile.DPC.DPC_LIST_DATA2_RD.dpc_list_corr_pattern <= REG_dpc_list_corr_rd(32 downto 25);  --8 bits   

    regfile.BAYER.BAYER_CAPABILITIES.BAYER_VER          <= REG_bayer_ver;

    -- trim_pixel_width <= "001" when (regfile.DMA.CSC.COLOR_SPACE = "101") else    --RAW
    --                     "100" when (regfile.DMA.CSC.COLOR_SPACE = "001") else    --RGB32
    --     					"010" when (regfile.DMA.CSC.COLOR_SPACE = "010") else    --YUV
    --     					"001";
						
  end generate G_COLOR_PIPELINE;


  
  -- For the moment bypass X_TRIM in color mode    
  --G_MONO_TRIM : if (COLOR = 0) generate
    trim_inst : trim
      generic map(
        NUMB_LINE_BUFFER => 2
        )
      port map(
        aclk_grab_queue_en => regfile.DMA.CTRL.GRAB_QUEUE_EN,
        aclk_load_context  => load_dma_context,
        aclk_color_space   => regfile.DMA.CSC.COLOR_SPACE,
        aclk_x_crop_en     => regfile.DMA.ROI_X.ROI_EN,
        aclk_x_start       => regfile.DMA.ROI_X.X_START,
        aclk_x_size        => regfile.DMA.ROI_X.X_SIZE,
        --aclk_x_scale       => trim_x_scale,
        aclk_x_scale       => regfile.DMA.CSC.SUB_X,
        aclk_x_reverse     => regfile.DMA.CSC.REVERSE_X,
        aclk_y_roi_en      => regfile.DMA.ROI_Y.ROI_EN,
        aclk_y_start       => regfile.DMA.ROI_Y.Y_START,
        aclk_y_size        => regfile.DMA.ROI_Y.Y_SIZE,
        aclk               => aclk,
        aclk_reset_n       => aclk_reset_n,
        aclk_tready        => trim_tready,
        aclk_tvalid        => trim_tvalid,
        aclk_tuser         => trim_tuser,
        aclk_tlast         => trim_tlast,
        aclk_tdata         => trim_tdata,
        bclk               => aclk,
        bclk_reset_n       => aclk_reset_n,
        bclk_tready        => dma_tready,
        bclk_tvalid        => dma_tvalid,
        bclk_tuser         => dma_tuser,
        bclk_tlast         => dma_tlast,
        bclk_tdata         => dma_tdata
        );
  --end generate;  


  -- trim_x_scale <= "0011" when (regfile.DMA.CSC.COLOR_SPACE = "101") else  -- RAW mode (div4)
  --                  regfile.DMA.CSC.SUB_X;                                -- Normal scaling in color mode
                   



  xdmawr2tlp : dmawr2tlp
    generic map(
      COLOR                 => COLOR,
      MAX_PCIE_PAYLOAD_SIZE => MAX_PCIE_PAYLOAD_SIZE
      )
    port map(
      sclk         => aclk,
      srst_n       => aclk_reset_n,
      intevent     => irq_dma,
      context_strb => load_dma_context,
      regfile      => regfile,

      tready => dma_tready,
      tvalid => dma_tvalid,
      tdata  => dma_tdata,
      tuser  => dma_tuser,
      tlast  => dma_tlast,

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

      --curr_db_GRAB_ROI2_EN => open,

      curr_db_y_start_ROI1 => hispi_ystart,  --ROI before SUB_Y
      curr_db_y_end_ROI1   => hispi_yend,   --ROI before SUB_Y
      curr_db_y_size_ROI1  => hispi_ysize,  --NB lines after SUBSAMPLING Y APPLIED

      curr_db_x_start_ROI1 => hispi_xstart,  --ROI before SUB_X
      curr_db_x_end_ROI1   => hispi_xend,   --ROI before SUB_X
      curr_db_x_size_ROI1  => hispi_xsize,  --NB pixels after SUBSAMPLING X APPLIED

      --curr_db_y_start_ROI2 => open,
      --curr_db_y_end_ROI2   => open,
      --curr_db_y_size_ROI2  => open,

      curr_db_subsampling_X => hispi_subX,
      curr_db_subsampling_Y => hispi_subY,

      curr_db_BUFFER_ID => open,

      first_lines_mask_cnt => first_lines_mask_cnt,  -- 1(embedded)+ Calibration Black lines programmed. Ici je ne double buff pas car ca va etre statique apres le load de la dcf

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


  -----------------------------------------------------------------------------
  -- INTERRUPT EVENT MAPPING:
  --
  -- Important, all interrupts events must be signalled by an active high
  -- monotonic pulse. These pulse are sampled by the main registerfile clock
  -- domain. You must ensure that the pulse is wide enough the be sampled by
  -- the registerfile clock domain. 
  -----------------------------------------------------------------------------
  irq(0) <= irq_dma;                    -- End of DMA 
  irq(1) <= irq_soe;                    -- Start of Exposure
  irq(2) <= irq_eoe;                    -- End of Exposure 
  irq(3) <= irq_sos;                    -- Start of Strobe  
  irq(4) <= irq_eos;                    -- End of Strobe 
  irq(5) <= load_dma_context(1);        -- End Of FOT (START OF GRAB)
  irq(6) <= irq_abort;
  irq(7) <= irq_hispi_error;

  ----------------------------------------------------
  -- System monitor
  ----------------------------------------------------
  process(aclk)
  begin
    if rising_edge(aclk) then
      -- Hold address when read request is done
      if ext_SYSMONXIL_readEn = '1' then
        ext_SYSMONXIL_addr_ff <= ext_SYSMONXIL_addr;
      end if;

      -- Hold readdata when valid
      if sysmon_readDataValid = '1' then
        ext_SYSMONXIL_readData <= sysmon_readData;
      end if;


      if aclk_reset = '1' then
        ext_SYSMONXIL_readEn_ff     <= '0';
        ext_SYSMONXIL_readDataValid <= '0';
        sysmon_busy                 <= '0';
        sysmon_reg_readEn           <= '0';
      else

        ext_SYSMONXIL_readEn_ff     <= ext_SYSMONXIL_readEn;
        ext_SYSMONXIL_readDataValid <= sysmon_readDataValid;

        -- system monitor is busy until data valid is returned
        if sysmon_readEn = '1' then
          sysmon_busy <= '1';
        elsif sysmon_readDataValid = '1' then
          sysmon_busy <= '0';
        end if;

        -- Hold read request from regfile until sysmon is not busy
        if ext_SYSMONXIL_readEn_ff = '1' and sysmon_busy = '1' then
          sysmon_reg_readEn <= '1';
        elsif sysmon_busy = '0' then
          sysmon_reg_readEn <= '0';
        end if;

      end if;

    end if;
  end process;


  sysmon_dadddr <= ext_SYSMONXIL_addr_ff when (ext_SYSMONXIL_readEn_ff = '1' or sysmon_reg_readEn = '1') else (others => '0');
  sysmon_readEn <= (ext_SYSMONXIL_readEn_ff or sysmon_reg_readEn) and not sysmon_busy;

  xsystem_monitor : system_monitor
    port map (
      daddr_in(6)          => '0',
      daddr_in(5 downto 0) => sysmon_dadddr,    -- Address bus
      den_in               => sysmon_readEn,    -- Enable Signal (*)
      di_in                => (others => '0'),  -- Input data bus
      dwe_in               => '0',      -- Write Enable
      do_out               => sysmon_readData,
      drdy_out             => sysmon_readDataValid,
      dclk_in              => aclk,     -- Clock input
      reset_in             => aclk_reset,       -- Reset signal (active high)
      busy_out             => open,     -- ADC Busy signal
      channel_out          => open,     -- Channel Selection Outputs
      eoc_out              => open,     -- End of Conversion Signal
      eos_out              => open,     -- End of Sequence Signal
      user_temp_alarm_out  => open,     -- sysmon_temp_alarm,  
      alarm_out            => open,     -- OR'ed output of all the Alarms
      vp_in                => '1',      -- xadc_vp_in
      vn_in                => '0'       -- xadc_vn_in
      );
  -- (*) Would have to be ored with write enable if we ever support write to system monitor


end struct;
