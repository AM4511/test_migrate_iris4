library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all; 

library work;
    use work.regfile_xgs_athena_pack.all;



entity XGS_controller_top is 
	generic (
		-- Users to add parameters here
        G_SYS_CLK_PERIOD    : integer  := 16;
        G_SENSOR_FREQ       : integer  := 32400; 
		G_SIMULATION        : integer  := 0;
        G_KU706             : integer  := 0
	);
	port (
		
        sys_clk      : in  std_logic;
        sys_reset_n  : in  std_logic;

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
        
        ---------------------------------------------------------------------------
        --  Register file
        ---------------------------------------------------------------------------   
        regfile       : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE -- Register file


	);
end XGS_controller_top;

architecture arch_imp of XGS_controller_top is



  
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

           ---------------------------------------------------------------------------
           --  Register file
           ---------------------------------------------------------------------------        
           regfile                         : inout REGFILE_XGS_ATHENA_TYPE := INIT_REGFILE_XGS_ATHENA_TYPE -- Register file

           


           
           
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

  signal sys_reset_n_ctrl  : std_logic;
  
  signal xgs_sclk_int      : std_logic;
  signal xgs_cs_n_int      : std_logic;
  signal xgs_sdout_int     : std_logic;                 
  signal xgs_power_goodN   : std_logic;  
  
  
  signal xgs_monitor0_sysclk     : std_logic := '0';
  signal xgs_monitor1_sysclk     : std_logic := '0';
  signal xgs_monitor1_sysclk_P1  : std_logic := '0'; 
  signal Green_Led_event_sys : std_logic := '0';
  
  
  
  
  
begin


  




  
  
  
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
