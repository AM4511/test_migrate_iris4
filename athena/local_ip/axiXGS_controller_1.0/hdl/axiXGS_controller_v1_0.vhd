library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

library  work;
use work.regfile_xgs_ctrl_pack.all;

entity axiXGS_controller_v1_0 is 
	generic (
		-- Users to add parameters here
        G_SYS_CLK_PERIOD    : integer  := 16;
        G_SENSOR_FREQ       : integer  := 32400; 
		G_SIMULATION        : integer  := 0;
        G_KU706             : integer  := 0;
        -- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 12
	);
	port (
		-- Users to add ports here

        ------------------------------------------
        -- CMOS INTERFACE TO SENSOR
        ------------------------------------------
        xgs_power_good          : in  std_logic;
        xgs_clk_pll_en          : out std_logic;
        xgs_reset_n             : out std_logic;
        
        xgs_fwsi_en             : out std_logic;
        
        xgs_sclk                : out std_logic;
        xgs_cs_n                : out std_logic;
        xgs_sdout               : out std_logic;
        xgs_sdin                : in  std_logic;
        
        xgs_trig_int            : out std_logic;
        xgs_trig_rd             : out std_logic;
        
        xgs_monitor0            : in std_logic;
        xgs_monitor1            : in std_logic;
        xgs_monitor2            : in std_logic;
        
        ---------------------------------------------------------------------------
        --  OUTPUTS 
        ---------------------------------------------------------------------------
        anput_ext_trig         : in    std_logic;    
        
        anput_strobe_out       : out   std_logic;                       --
        anput_exposure_out     : out   std_logic;                       --
        anput_trig_rdy_out     : out   std_logic;                       --
        
        led_out                : out   std_logic_vector(1 downto 0);     -- led_out(0) --> vert, led_out(1) --> rouge

        
        ---------------------------------------------------------------------------
        --  Signals to/from Datapath/DMA
        ---------------------------------------------------------------------------
        HISPI_pix_clk                   : in    std_logic := '0'; 
        
        DEC_EOF                         : in    std_logic := '0';
        
        abort_readout_datapath          : out   std_logic := '0';
        dma_idle                        : in    std_logic := '1';

        strobe_DMA_P1                   : out   std_logic := '0';            -- Load DMA 1st stage registers  
        strobe_DMA_P2                   : out   std_logic := '0';            -- Load DMA 2nd stage registers 
        
        curr_db_GRAB_ROI2_EN            : out   std_logic := '0';
        
        curr_db_y_start_ROI1            : out   std_logic_vector(11 downto 0):= (others=>'0');     -- 1-base
        curr_db_nblines_ROI1            : out   std_logic_vector(11 downto 0):= (others=>'0');     -- 1-base  
                 
        curr_db_y_start_ROI2            : out   std_logic_vector(11 downto 0):= (others=>'0');     -- 1-base  
        curr_db_nblines_ROI2            : out   std_logic_vector(11 downto 0):= (others=>'0');     -- 1-base

        curr_db_subsampling_X           : out   std_logic:='0';
        curr_db_subsampling_Y           : out   std_logic:='0';
        
        curr_db_BUFFER_ID               : out   std_logic:='0';
        
        
        ---------------------------------------------------------------------------
        --  IRQ to system
        ---------------------------------------------------------------------------        
        irq_eos                         : out   std_logic;
        irq_sos                         : out   std_logic;  
        irq_eoe                         : out   std_logic;  
        irq_soe                         : out   std_logic;  
        irq_abort                       : out   std_logic;
        
        
		-- User ports ends
		-- Do not modify the ports beyond this line

		-- Ports of Axi Slave Bus Interface S00_AXI
		s_axi_aclk	    : in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	    : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	    : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp	    : out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata	    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	    : out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic
	);
end axiXGS_controller_v1_0;

architecture arch_imp of axiXGS_controller_v1_0 is

  -------------------------------
  -- COMPONENT AxiSlave2Reg 
  -------------------------------
  component AxiSlave2Reg 
	generic (
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	: integer	:= 12
	);
	port (
		-- Users to add ports here
        ---------------------------------------------------------------------------
        -- FDK IDE registerfile interface
        ---------------------------------------------------------------------------
        reg_read          : out std_logic;
        reg_write         : out std_logic;
        reg_addr          : out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);
        reg_beN           : out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        reg_writedata     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        reg_readdataValid : in  std_logic;
        reg_readdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

        ---------------------------------------------------------------------------
        -- AXI S MM 
        ---------------------------------------------------------------------------    
        S_AXI_ACLK        : in std_logic;
        S_AXI_ARESETN     : in std_logic;
        S_AXI_AWADDR      : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        --S_AXI_AWPROT      : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID     : in std_logic;
        S_AXI_AWREADY     : out std_logic;
        
        S_AXI_WDATA       : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB       : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID      : in std_logic;
        S_AXI_WREADY      : out std_logic;
        
        S_AXI_BRESP       : out std_logic_vector(1 downto 0);
        S_AXI_BVALID      : out std_logic;
        S_AXI_BREADY      : in std_logic;
        
        S_AXI_ARADDR      : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        --S_AXI_ARPROT      : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID     : in std_logic;
        S_AXI_ARREADY     : out std_logic;
        
        S_AXI_RDATA       : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP       : out std_logic_vector(1 downto 0);
        S_AXI_RVALID      : out std_logic;
        S_AXI_RREADY      : in std_logic
        
	);
  end component;

  
  -------------------------------
  -- COMPONENT regfile_xgs_ctrl
  -------------------------------
  component regfile_xgs_ctrl
    port (
      resetN        : in    std_logic;                                           -- System reset
      sysclk        : in    std_logic;                                           -- System clock
      regfile       : inout REGFILE_XGS_CTRL_TYPE := INIT_REGFILE_XGS_CTRL_TYPE;     -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                           -- Read
      reg_write     : in    std_logic;                                           -- Write
      reg_addr      : in    std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);     -- Address
      reg_beN       : in    std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0); -- Byte enable
      reg_writedata : in    std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);     -- Write data
      reg_readdata  : out   std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)      -- Read data
    );
  end component;

  
  -------------------------------
  -- COMPONENT XGS CONTROLLER
  -------------------------------  
   component xgs_ctrl
   generic(  G_KU706               : integer := 0;
             G_SIMULATION          : integer := 0;
             G_SYS_CLK_PERIOD      : integer := 16;
             G_SENSOR_FREQ         : integer := 32400            
          );
   port (  
           sys_reset_n                     : in  std_logic;      --Reset pour le controleur au complet
           sys_reset_n_power               : in  std_logic;      --Reset pour le module de power
           
           sys_clk                         : in  std_logic;

           ---------------------------------------------------------------------------
           --  CMOS IF signals
           ---------------------------------------------------------------------------
           xgs_power_good                  : in  std_logic;      -- power good
           xgs_osc_en                      : out std_logic;
           xgs_reset_n                     : out std_logic;
         
           xgs_sclk                        : out std_logic;
           xgs_ssn                         : out std_logic;
           xgs_mosi                        : out std_logic;
           xgs_miso                        : in  std_logic;

           xgs_trig_int                    : out std_logic;
           xgs_trig_rd                     : out std_logic;

           xgs_monitor0                    : in std_logic;  --EXP
           xgs_monitor1                    : in std_logic;  --ROT 
           xgs_monitor2                    : in std_logic;  -- A definir
           
           ---------------------------------------------------------------------------
           --  OUTPUTS TO other fpga
           ---------------------------------------------------------------------------
           strobe_out                      : out   std_logic;
           strobe_A_out                    : out   std_logic;
           strobe_B_out                    : out   std_logic;
           exposure_out                    : out   std_logic;
           trig_rdy_out                    : out   std_logic;
           
           xgs_monitor0_sysclk             : out   std_logic;
           xgs_monitor1_sysclk             : out   std_logic;
           
           ---------------------------------------------------------------------------
           --  INPUTS FROM other fpga
           ---------------------------------------------------------------------------
           ext_trig                        : in    std_logic;
           acquisition_start               : in    std_logic :='0';
           exposure_select                 : in    std_logic_vector(1 downto 0) := "00";   
           
           ---------------------------------------------------------------------------
           -- Debug out
           ---------------------------------------------------------------------------
           debug_ctrl16                    : out std_logic_vector(15 downto 0);

           ---------------------------------------------------------------------------
           -- IRQ
           ---------------------------------------------------------------------------
           irq_eos                         : out   std_logic;  --Strobe
           irq_sos                         : out   std_logic;  --Strobe
           irq_eoe                         : out   std_logic;  --Exposure
           irq_soe                         : out   std_logic;  --Exposure
           irq_abort                       : out   std_logic;
           
           ---------------------------------------------------------------------------
           --   signals
           ---------------------------------------------------------------------------          
           --start_calibration               : out std_logic;
           DEC_EOF_SYS                     : in    std_logic := '0';

           abort_readout_datapath          : out std_logic;
           dma_idle                        : in  std_logic;

           strobe_DMA_P1                   : out std_logic;            -- Load DMA 1st stage registers  
           strobe_DMA_P2                   : out std_logic;            -- Load DMA 2nd stage registers 

           
           curr_db_GRAB_ROI2_EN            : out std_logic;
                      
           curr_db_y_start_ROI1            : out std_logic_vector;     -- 1-base
           curr_db_nblines_ROI1            : out std_logic_vector;     -- 1-base  

           curr_db_y_start_ROI2            : out std_logic_vector;     -- 1-base  
           curr_db_nblines_ROI2            : out std_logic_vector;     -- 1-base

           curr_db_subsampling_X           : out std_logic;
           curr_db_subsampling_Y           : out std_logic;
                      
           curr_db_BUFFER_ID               : out std_logic;
       
           regfile                         : inout REGFILE_XGS_CTRL_TYPE-- := INIT_REGFILE_TYPE

           


           
           
        );
  end component;  
  

  ------------------------------------------
  --  LED STATUS
  ------------------------------------------
  component led_status is
     generic( G_SYS_CLK_PERIOD : integer    := 16     -- Sysclock frequency
          );
     port (   
       sys_reset_n         : in  std_logic;
       sys_clk             : in  std_logic;

       pix_clk             : in  std_logic;

       led_out             : out std_logic_vector(1 downto 0);
       reg_pixclk_error    : out std_logic;
       
       Green_Led_event_sys : in std_logic:='0';
       
       REG_LED_TEST        : in  std_logic                    := '0';
       REG_LED_TEST_COLOR  : in  std_logic_vector(1 downto 0) := "00"

    );
  end component;



  -------------------------------
  -- Signals 
  -------------------------------

  signal sys_clk           : std_logic;
  signal sys_reset_n       : std_logic;
  signal sys_reset_n_ctrl  : std_logic;
  
  signal xgs_sclk_int      : std_logic;
  signal xgs_cs_n_int      : std_logic;
  signal xgs_sdout_int     : std_logic;                 
  signal xgs_power_goodN   : std_logic;  
  
  
  signal xgs_monitor0_sysclk     : std_logic := '0';
  signal xgs_monitor1_sysclk     : std_logic := '0';
  signal xgs_monitor1_sysclk_P1  : std_logic := '0'; 
  signal Green_Led_event_sys : std_logic := '0';
  
  
  -------------------------------------------
  -- Register file from IP Integrator
  -------------------------------------------
  signal reg_read            :  std_logic;                                                     -- Read
  signal reg_write           :  std_logic;                                                     -- Write
  signal reg_addr            :  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 2);               -- Address
  signal reg_beN             :  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);           -- Byte enable
  signal reg_writedata       :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);               -- Write data
  signal reg_readdatavalid   :  std_logic;                                                     -- Read data valid
  signal reg_readdata        :  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);               -- Read data
  signal regfile             :  REGFILE_XGS_CTRL_TYPE;  
    
  
  
  
begin


  sys_clk      <= s_axi_aclk;
  sys_reset_n  <= s_axi_aresetn;



    X_AxiSlave2Reg : AxiSlave2Reg 
	generic map(
		-- Width of S_AXI data bus
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH ,
		-- Width of S_AXI address bus
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map(

        ---------------------------------------------------------------------------
        -- FDK IDE registerfile interface
        ---------------------------------------------------------------------------
        reg_read          => reg_read,         
        reg_write         => reg_write,        
        reg_addr          => reg_addr,         
        reg_beN           => reg_beN,         
        reg_writedata     => reg_writedata,    
        reg_readdataValid => reg_readdataValid,
        reg_readdata      => reg_readdata,     
        
        S_AXI_ACLK        => S_AXI_ACLK,   
        S_AXI_ARESETN     => S_AXI_ARESETN,
        S_AXI_AWADDR      => S_AXI_AWADDR, 
        --S_AXI_AWPROT      => S_AXI_AWPROT, 
        S_AXI_AWVALID     => S_AXI_AWVALID,
        S_AXI_AWREADY     => S_AXI_AWREADY,
                         
        S_AXI_WDATA       => S_AXI_WDATA,  
        S_AXI_WSTRB       => S_AXI_WSTRB,  
        S_AXI_WVALID      => S_AXI_WVALID, 
        S_AXI_WREADY      => S_AXI_WREADY, 
                         
        S_AXI_BRESP       => S_AXI_BRESP,  
        S_AXI_BVALID      => S_AXI_BVALID, 
        S_AXI_BREADY      => S_AXI_BREADY, 
                         
        S_AXI_ARADDR      => S_AXI_ARADDR, 
        --S_AXI_ARPROT      => S_AXI_ARPROT, 
        S_AXI_ARVALID     => S_AXI_ARVALID,
        S_AXI_ARREADY     => S_AXI_ARREADY,
                         
        S_AXI_RDATA       => S_AXI_RDATA,  
        S_AXI_RRESP       => S_AXI_RRESP,  
        S_AXI_RVALID      => S_AXI_RVALID, 
        S_AXI_RREADY      => S_AXI_RREADY 
        
        
        
	);




 
  -------------------------------
  -- COMPONENT regfile_xgs_ctrl
  -------------------------------
  Xregfile_xgs : regfile_xgs_ctrl
   port map (
      resetN          =>  S_AXI_ARESETN,   -- System reset
      sysclk          =>  S_AXI_ACLK,       -- System clock
      regfile         =>  regfile,       -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read        => reg_read,                   -- Read
      reg_write       => reg_write,                  -- Write
      reg_addr        => reg_addr,                   -- Address
      reg_beN         => reg_beN,                    -- Byte enable
      reg_writedata   => reg_writedata,              -- Write data
      reg_readdata    => reg_readdata                -- Read data
   );

  ---------------------------------------------------------------------------
  -- Connecting BUILD ID to register file
  ---------------------------------------------------------------------------
  regfile.SYSTEM.ID.StaticID <= X"C0CAC01A";
   
   
  -- Pour dire au module axi quand sampler le data de lecture regbus, le readdata_valid est juste genere par le regfile s'il y a un external
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK)) then
      if(S_AXI_ARESETN='0') then
        reg_readdataValid <= '0';
      else
        reg_readdataValid <= reg_read;
      end if;
    end if;
  end process;


  
  
  
  
  
  -------------------------------------------------------------------------------
  --
  --        SPI : Let interface in HI_Z until VCC powergood is ok.
  --              Il y a une pullup ou diode de clamping sur SSN, dans la sequence
  --              de powerup il y a un leakage! 
  -------------------------------------------------------------------------------
  xgs_fwsi_en <= '1';  --Use SPI 4 wire interface  
  
  xgs_sclk    <=  xgs_sclk_int  when (xgs_power_good='1')  else 'Z';
  xgs_sdout   <=  xgs_sdout_int when (xgs_power_good='1')  else 'Z';
  xgs_cs_n    <=  xgs_cs_n_int  when (xgs_power_goodN='0') else 'Z';
  
  --Pour enlever DRC vivado le ff du enable et le ff du data des registres IOB doivent avoir le meme set/reset
  process (sys_clk)
  begin  
    if (sys_clk'event and sys_clk = '1') then  
      if(sys_reset_n_ctrl='0') then
        xgs_power_goodN <= '1';
      else
        xgs_power_goodN <= not(xgs_power_good);
      end if;  
    end if;
  end process;  
   
  sys_reset_n_ctrl <= '0' when (sys_reset_n='0' or REGFILE.ACQ.GRAB_CTRL.RESET_GRAB='1') else '1';
 
 

   
  ------------------------------------------
  --  Pour le moment pour aider le debug le
  --  reset du controlleur est gate, pour 
  --  etre en mesure de tout reseter, sans 
  --  devoir rebooter la machine.
  ------------------------------------------
  sys_reset_n_ctrl <= '0' when (sys_reset_n='0' or REGFILE.ACQ.GRAB_CTRL.RESET_GRAB='1') else '1'; 
 
 

  -------------------------------
  -- COMPONENT XGS CONTROLLER
  -------------------------------  
   Inst_xgs_ctrl : xgs_ctrl
   generic map(  G_KU706                   => G_KU706,
                 G_SIMULATION              => G_SIMULATION,
                 G_SYS_CLK_PERIOD          => G_SYS_CLK_PERIOD,
                 G_SENSOR_FREQ             => G_SENSOR_FREQ
          )
   port map(  
           sys_reset_n                     => sys_reset_n_ctrl,      --Reset pour le controleur au complet
           sys_reset_n_power               => sys_reset_n,           --Reset pour le module de power
           
           sys_clk                         => sys_clk,

           ---------------------------------------------------------------------------
           --  CMOS IF signals
           ---------------------------------------------------------------------------
           xgs_power_good                  => xgs_power_good,
           xgs_osc_en                      => xgs_clk_pll_en,
           xgs_reset_n                     => xgs_reset_n,
         
           xgs_sclk                        => xgs_sclk_int,
           xgs_ssn                         => xgs_cs_n_int,
           xgs_mosi                        => xgs_sdout_int,
           xgs_miso                        => xgs_sdin,

           xgs_trig_int                    => xgs_trig_int,
           xgs_trig_rd                     => xgs_trig_rd, 

           xgs_monitor0                    => xgs_monitor0,  --EXP
           xgs_monitor1                    => xgs_monitor1,  --FOT 
           xgs_monitor2                    => xgs_monitor2,  --NEW LINE, a cause du bug
           
           ---------------------------------------------------------------------------
           --  OUTPUTS TO other fpga
           ---------------------------------------------------------------------------
           strobe_out                      => anput_strobe_out,
           strobe_A_out                    => open,
           strobe_B_out                    => open,
           exposure_out                    => anput_exposure_out,
           trig_rdy_out                    => anput_trig_rdy_out,
           
           xgs_monitor0_sysclk             => xgs_monitor0_sysclk,
           xgs_monitor1_sysclk             => xgs_monitor1_sysclk,
           
           ---------------------------------------------------------------------------
           --  INPUTS FROM other fpga
           ---------------------------------------------------------------------------
           ext_trig                        => anput_ext_trig,
           acquisition_start               => '0',
           exposure_select                 => "00",

          
           ---------------------------------------------------------------------------
           -- Debug out
           ---------------------------------------------------------------------------
           debug_ctrl16                    => open,

           ---------------------------------------------------------------------------
           -- IRQ
           ---------------------------------------------------------------------------
           irq_eos                         => irq_eos  ,  --End   Of Strobe
           irq_sos                         => irq_sos  ,  --Start Of Strobe
           irq_eoe                         => irq_eoe  ,  --End   Of Exposure
           irq_soe                         => irq_soe  ,  --Start Of Exposure
           irq_abort                       => irq_abort,  --End   Of Abort
           
           ---------------------------------------------------------------------------
           --  Signals to Datapath/DMA
           ---------------------------------------------------------------------------
           --start_calibration               => open,

           DEC_EOF_sys                     => DEC_EOF,           -- A negotier avec Amarchan, ds quel domaine d'horloge il va arriver
           
           abort_readout_datapath          => abort_readout_datapath,
           dma_idle                        => dma_idle,

           strobe_DMA_P1                   => strobe_DMA_P1,            -- Load DMA 1st stage registers  
           strobe_DMA_P2                   => strobe_DMA_P2,            -- Load DMA 2nd stage registers 
           
           curr_db_GRAB_ROI2_EN            => curr_db_GRAB_ROI2_EN,
          
           curr_db_y_start_ROI1            => curr_db_y_start_ROI1,     -- 1-base
           curr_db_nblines_ROI1            => curr_db_nblines_ROI1,     -- 1-base  
                    
           curr_db_y_start_ROI2            => curr_db_y_start_ROI2,     -- 1-base  
           curr_db_nblines_ROI2            => curr_db_nblines_ROI2,     -- 1-base

           curr_db_subsampling_X           => curr_db_subsampling_X,
           curr_db_subsampling_Y           => curr_db_subsampling_Y,
           
           curr_db_BUFFER_ID               => curr_db_BUFFER_ID,

           ---------------------------------------------------------------------------
           --  RegFile
           ---------------------------------------------------------------------------       
           regfile                         => regfile

        );
 
 
 
  ------------------------------------------
  --  LED STATUS
  ------------------------------------------
  process (sys_clk)
  begin  
    if (sys_clk'event and sys_clk = '1') then  
      xgs_monitor1_sysclk_P1     <= xgs_monitor1_sysclk;
      Green_Led_event_sys        <= xgs_monitor1_sysclk and not(xgs_monitor1_sysclk_P1);
    end if;
  end process; 
  
  Xled_status :  led_status 
   generic map(G_SYS_CLK_PERIOD => G_SYS_CLK_PERIOD)
   port map(
     sys_reset_n         => sys_reset_n,
     sys_clk             => sys_clk,

     pix_clk             => HISPI_pix_clk,

     led_out             => led_out,
     reg_pixclk_error    => open,
     
     Green_Led_event_sys => Green_Led_event_sys,
     
     REG_LED_TEST        => regfile.ACQ.DEBUG.LED_TEST,
     REG_LED_TEST_COLOR  => regfile.ACQ.DEBUG.LED_TEST_COLOR
  );


 

end arch_imp;