----------------------------------------------------------------------
-- $HeadURL:  $
-- $Revision:  $
-- $Date:  $
-- $Author: jlarin $
--
-- DESCRIPTION: Fichier top du FPGA de Ares 
--
-- Ce FPGA contient les users in/out pour iris3 et le profitblaze.
--
-- PROJECT: Iris3
--
-- Jean-Francois Larin ing. #121322
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_arith.all; 
  use ieee.std_logic_unsigned.all;
Library UNISIM;
use UNISIM.vcomponents.all;

library work;
use work.spider_pak.all;
use work.regfile_ares_pack.all;

entity ares is
  generic(
    BUILD_ID : std_logic_vector(31 downto 0) := x"76543210"; -- Generic passed in .tcl script
    SIMULATION                : integer := 0;
    PCIe_LANES                : integer := 1;
    --FPGA_ID                   : integer := 8;                          -- Ares for y7478-00
    FPGA_ID                   : integer := 9;                          -- Ares for y7478-01
    NB_USER_IN                : integer := 4;
    NB_USER_OUT               : integer := 3;
    GOLDEN                    : boolean := FALSE;  -- le code Golden n'a pas de Microblaze
    HOST_SPI_ACCESS           : boolean := FALSE;  -- est-ce qu'on veut donner l'acces SPI au host, pour NPI (par rapport au Microblaze)
                                                   -- veuillez noter qu'il faut AUSSI enlever le STARTUPE2 dans le module SPI dans le block design
                                                   -- et changer quelle fichier de contrainte qui est actif.
    
    --SYNTH_SPI_PAGE_256B_BURST : integer := 1;                  -- Pour ne pas implementer la capacite de burster 256Bytes mettre a '0' (1 RAM de moins)
    SYNTH_TICK_TABLES         : integer := 1;                  -- Pour ne pas implementer les TickTables mettre a '0'
    SYNTH_TIMERs              : integer := 1;                  -- Pour ne pas implementer les Timers mettre a '0'
    SYNTH_QUAD_DECs           : integer := 1;                   -- Pour ne pas implementer les Quad Dec mettre a '0'
    DDR2_BUS_WIDTH            : integer := 8
  );
  port (
    ---------------------------------------------------------------------------
    --  PCIe core
    ---------------------------------------------------------------------------
    pcie_sys_clk_n                  : in    std_logic;
    pcie_sys_clk_p                  : in    std_logic;
    pcie_sys_rst_n                  : in    std_logic;
    pcie_rx_n                       : in    std_logic_vector(PCIe_LANES-1 downto 0);
    pcie_rx_p                       : in    std_logic_vector(PCIe_LANES-1 downto 0);
    
    pcie_tx_n                       : out   std_logic_vector(PCIe_LANES-1 downto 0);
    pcie_tx_p                       : out   std_logic_vector(PCIe_LANES-1 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    spi_sdout                       : inout   std_logic;                       
    spi_sdin                        : inout   std_logic;                       
    spi_csN                         : inout   std_logic;                      
    -- synthesis translate_off
    spi_sclk                        : out   std_logic;                       --   (cpg236: cclk) (out) spi_cclk  
    -- synthesis translate_on

    ---------------------------------------------------------------------------
    --  FPGA USER IO interface
    ---------------------------------------------------------------------------
    -- user io
    user_data_in              : in    std_logic_vector(NB_USER_IN-1 downto 0); 
    user_data_out             : out   std_logic_vector(NB_USER_OUT-1 downto 0);
    pwm_out                   : out   std_logic;

    ------------------------------
    -- connexion au FPGA Athena --
    ------------------------------
    acq_led                   : in  std_logic_vector(1 downto 0);
    acq_exposure              : in  std_logic;  -- connecte sur internal_input(0)
    acq_strobe                : in  std_logic;  -- connecte sur internal_input(1)
    acq_trigger_ready         : in  std_logic;  -- connecte sur internal_input(2)
    acq_trigger               : out std_logic;
    
    ------------------------------
    -- connexion aux LEDS et SOC
    ------------------------------
    user_rled_soc             : in  std_logic;
    user_gled_soc             : in  std_logic;
    user_rled                 : out std_logic;
    user_gled                 : out std_logic;
    status_rled               : out std_logic;
    status_gled               : out std_logic;
                            
    --------------------------------------------------
    -- correctif au probleme de reset baytrail
    --------------------------------------------------
    pwrrst                    : out std_logic := 'Z';

    --------------------------------------------------
    -- NCSI et IO divers 
    --------------------------------------------------
    ncsi_clk                  : in    std_logic; 
    ncsi_rx_crs_dv            : in    std_logic;
    ncsi_rxd                  : in    std_logic_vector(1 downto 0);
    ncsi_txen                 : out   std_logic;
    ncsi_txd                  : out   std_logic_vector(1 downto 0);

    uart_txd                  : out   std_logic;
    --debug_out                 : out   std_logic;
    
    -- DDR2 memory interface
    ddr2_addr : out STD_LOGIC_VECTOR ( 12 downto 0 );
    ddr2_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr2_cas_n : out STD_LOGIC;
    ddr2_ck_n : out STD_LOGIC;
    ddr2_ck_p : out STD_LOGIC;
    ddr2_cke : out STD_LOGIC;
    ddr2_dm : out STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH/8 - 1 downto 0 );
    ddr2_dq : inout STD_LOGIC_VECTOR (DDR2_BUS_WIDTH-1 downto 0 );
    ddr2_dqs_n : inout STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH/8-1 downto 0 );
    ddr2_dqs_p : inout STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH/8-1 downto 0 );
    ddr2_odt : out STD_LOGIC;
    ddr2_ras_n : out STD_LOGIC;
    ddr2_we_n : out STD_LOGIC
  );
end ares;

architecture functional of ares is

  component pcie_top is
    generic (
      USE_DMA           : boolean := FALSE;
      MAX_LANE_NB       : integer := 0;
  	  NB_PCIE_AGENTS    : integer := 2
      );
    port (
      CFG_SUBSYS_ID_in                     : in std_logic_vector(15 downto 0) := x"0000"; -- jlarin: nous voulons un subsystem ID dependant d'un signal statique
      ---------------------------------------------------------------------------
      -- PCIe FPGA IOs (100 MHz input clock)
      ---------------------------------------------------------------------------
      pcie_sys_clk                        : in  std_logic;
      pcie_sys_rst_n                      : in  std_logic;
      pci_exp_rxp                         : in  std_logic_vector;
      pci_exp_rxn                         : in  std_logic_vector;
    
      pci_exp_txp                         : out std_logic_vector;
      pci_exp_txn                         : out std_logic_vector;

      ---------------------------------------------------------------------
      -- System clock and reset (62.5 MHz transaction interface clock)
      ---------------------------------------------------------------------
      sys_clk                              : out   std_logic;
      sys_reset_n                          : out   std_logic;
    
      ---------------------------------------------------------------------
      -- Interrupt
      ---------------------------------------------------------------------
      int_status                          : in    std_logic_vector; -- pour les interrupt classique seulement
      int_event                           : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur

      regfile                             : in    INTERRUPT_QUEUE_TYPE;      -- definit dans int_queue_pak
    
      ---------------------------------------------------------------------
      -- Register file interface
      ---------------------------------------------------------------------
      reg_readdata                         : in    std_logic_vector(31 downto 0);
      reg_readdatavalid                    : in    std_logic;
      reg_addr                             : out   std_logic_vector;
      reg_write                            : out   std_logic;
      reg_beN                              : out   std_logic_vector(3 downto 0);
      reg_writedata                        : out   std_logic_vector(31 downto 0);
      reg_read                             : out   std_logic;
    
      ---------------------------------------------------------------------
      -- DMA - PCIe interface
      ---------------------------------------------------------------------
      dma_tlp_req_to_send                 : in std_logic := '0';
      dma_tlp_grant                       : out  std_logic;

      dma_tlp_fmt_type                    : in std_logic_vector(6 downto 0) := (others => '0'); -- fmt and type field 
      dma_tlp_length_in_dw                : in std_logic_vector(9 downto 0) := (others => '0');

      dma_tlp_src_rdy_n                   : in std_logic := '0';
      dma_tlp_dst_rdy_n                   : out  std_logic;
      dma_tlp_data                        : in std_logic_vector(63 downto 0) := (others => '0');

      -- for master request transmit
      dma_tlp_address                     : in std_logic_vector(63 downto 2) := (others => '0'); 
      dma_tlp_ldwbe_fdwbe                 : in std_logic_vector(7 downto 0) := (others => '0');

      -- for completion transmit
      dma_tlp_attr                        : in std_logic_vector(1 downto 0) := (others => '0'); -- relaxed ordering, no snoop
      dma_tlp_transaction_id              : in std_logic_vector(23 downto 0) := (others => '0'); -- bus, device, function, tag
      dma_tlp_byte_count                  : in std_logic_vector(12 downto 0) := (others => '0'); -- byte count tenant compte des byte enables
      dma_tlp_lower_address               : in std_logic_vector(6 downto 0) := (others => '0');

      cfg_bus_mast_en                     : out   std_logic;
      cfg_setmaxpld                       : out   std_logic_vector(2 downto 0)

    );
  end component;    

  -- nouvelle version qui utilise les registres du FDK
  component userio_bank is
    generic(
      width           : integer range 1 to 32;
      input_active    : boolean := TRUE; -- can be used as input
      output_active   : boolean := TRUE; -- can be used as output
      int_number      : integer -- interrupt bit where the interrupts are forwarded
      );
    port(
      sysclk          : in    std_logic;
      data_in         : in    std_logic_vector(width-1 downto 0); -- input from the fpga pin
      data_out        : out   std_logic_vector(width-1 downto 0); -- output, has to go through logic or tristate driver
      dir             : out   std_logic_vector(width-1 downto 0); -- 0 if data is input, 1 if data is output
      int_line        : out   std_logic; -- interrupt line active high
    
      --regfile         : inout IO_TYPE := work.regfile_ares_pack.INIT_IO_TYPE -- interface a un fichier
      regfile         : inout work.regfile_ares_pack.IO_TYPE := work.regfile_ares_pack.INIT_IO_TYPE
    );
  end component;

  component regfile_ares is
   port (
      resetN                       : in    std_logic;                                   -- System reset
      sysclk                       : in    std_logic;                                   -- System clock
      regfile                      : inout REGFILE_ARES_TYPE := INIT_REGFILE_ARES_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_wait                     : out   std_logic;                                   -- Wait
      reg_read                     : in    std_logic;                                   -- Read
      reg_write                    : in    std_logic;                                   -- Write
      reg_addr                     : in    std_logic_vector(14 downto 2);               -- Address
      reg_beN                      : in    std_logic_vector(3 downto 0);                -- Byte enable
      reg_writedata                : in    std_logic_vector(31 downto 0);               -- Write data
      reg_readdatavalid            : out   std_logic;                                   -- Read data valid
      reg_readdata                 : out   std_logic_vector(31 downto 0);               -- Read data
      ------------------------------------------------------------------------------------
      -- Interface name: External interface
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_writeBeN                 : out   std_logic_vector(3 downto 0);                -- Write Byte Enable Bus for all external sections
      ext_writeData                : out   std_logic_vector(31 downto 0);               -- Write Data Bus for all external sections
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[0]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_0          : out   std_logic_vector(10 downto 0);               -- Address Bus for ProdCons[0] external section
      ext_ProdCons_writeEn_0       : out   std_logic;                                   -- Write enable for ProdCons[0] external section
      ext_ProdCons_readEn_0        : out   std_logic;                                   -- Read enable for ProdCons[0] external section
      ext_ProdCons_readDataValid_0 : in    std_logic;                                   -- Read Data Valid for ProdCons[0] external section
      ext_ProdCons_readData_0      : in    std_logic_vector(31 downto 0);               -- Read Data for the ProdCons[0] external section
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[1]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_1          : out   std_logic_vector(10 downto 0);               -- Address Bus for ProdCons[1] external section
      ext_ProdCons_writeEn_1       : out   std_logic;                                   -- Write enable for ProdCons[1] external section
      ext_ProdCons_readEn_1        : out   std_logic;                                   -- Read enable for ProdCons[1] external section
      ext_ProdCons_readDataValid_1 : in    std_logic;                                   -- Read Data Valid for ProdCons[1] external section
      ext_ProdCons_readData_1      : in    std_logic_vector(31 downto 0)                -- Read Data for the ProdCons[1] external section
   );
 end component;

  component Input_Conditioning
    generic( LPC_PERIOD          : integer :=30);                          -- 30 pour GPM, 40 pour GPM-Atom
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_reset_n                          : in    std_logic;
      sys_clk                              : in    std_logic;
      ---------------------------------------------------------------------
      -- Input signal: noisy
      ---------------------------------------------------------------------
      noise_user_data_in                   : in   std_logic_vector;
      ---------------------------------------------------------------------
      -- Output signal: noiseless
      ---------------------------------------------------------------------
      clean_user_data_in                   : out   std_logic_vector;
      ---------------------------------------------------------------------
      -- REGISTER 
      ---------------------------------------------------------------------
      regfile                              : inout work.regfile_ares_pack.InputConditioning_TYPE := work.regfile_ares_pack.INIT_INPUTCONDITIONING_TYPE
    );
  end component;


  component quaddecoder
    port(
      sys_reset_n           : in  std_logic;
      sys_clk               : in  std_logic;

      DecoderCntrLatch_Src_MUX    : in  std_logic_vector;

      line_inputs           : in  std_logic_vector; -- all the possible event input lines.
      
      Qdecoder_out0         : out std_logic;
      --Qdecoder_out1         : out std_logic;
      
      regfile               : inout work.regfile_ares_pack.QUADRATURE_TYPE := work.regfile_ares_pack.INIT_QUADRATURE_TYPE
  );
  end component;


  component Timer
  generic( int_number       : integer :=3;                -- interrupt bit where the interrupts are forwarded
           LPC_PERIOD       : integer :=30);              -- 30 pour GPM, 40 pour GPM-Atom
  port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in  std_logic;
    sys_clk                              : in  std_logic;
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    TimerArmSource_MUX                   : in  std_logic_vector;
    TimerTriggerSource_MUX               : in  std_logic_vector;
    ClockSource_MUX                      : in  std_logic_vector;
    
    ---------------------------------------------------------------------
    -- Output
    ---------------------------------------------------------------------
    Timer_Output                         : out  std_logic; 
    
    ---------------------------------------------------------------------
    -- IRQ
    ---------------------------------------------------------------------
    Timer_start_IRQ                      : out  std_logic; 
    Timer_end_IRQ                        : out  std_logic;
    
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout work.regfile_ares_pack.Timer_TYPE := work.regfile_ares_pack.INIT_Timer_TYPE--INIT_Timer_TYPE
  );
  end component;



  component TickTable
   generic( int_number        : integer :=1;
            CLOCK_PERIOD      : integer :=30  -- 30 pour GPM, 40 pour GPM-Atom
           );
    port (
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          : in    std_logic;
    sys_clk                              : in    std_logic;
    
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    TickClock_MUX                        : in  std_logic_vector;
    InputStampSource_MUX                 : in  std_logic_vector;
    
    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    TickTable_Out                        : out   std_logic_vector;

    ---------------------------------------------------------------------
    -- IRQ for HALF done, ALL DONE
    ---------------------------------------------------------------------
    TickTable_half_IRQ                   : out   std_logic;
    Ticktable_WA_IRQ                     : out   std_logic;
    TickTable_latch_IRQ                  : out   std_logic;
    
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              : inout work.regfile_ares_pack.TICKTABLE_TYPE := work.regfile_ares_pack.INIT_TICKTABLE_TYPE
  );
  end component;



  component Output_Conditioning
    generic( SIMULATION      : integer :=0;
             LPC_PERIOD      : integer :=30    -- 30 pour GPM, 40 pour GPM-Atom
           );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_reset_n                          : in    std_logic;
      sys_clk                              : in    std_logic;  
      ---------------------------------------------------------------------
      -- Inputs
      ---------------------------------------------------------------------
      userio_data_out                      : in   std_logic_vector;
      OutSel_MUX                           : in   std_logic_vector;
      ---------------------------------------------------------------------
      -- Output signal: noiseless
      ---------------------------------------------------------------------
      user_data_out                        : out   std_logic_vector;
      ---------------------------------------------------------------------
      -- REGISTER 
      ---------------------------------------------------------------------
      regfile                              : inout work.regfile_ares_pack.OUTPUTCONDITIONING_TYPE := work.regfile_ares_pack.INIT_OUTPUTCONDITIONING_TYPE
    );
  end component;

  component pwm_output is
     port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_reset                             : in    std_logic;
      sys_clk                               : in    std_logic;
    
      ---------------------------------------------------------------------
      -- Output signal: noiseless
      ---------------------------------------------------------------------
      pwm_Out                               : out   std_logic;

      ---------------------------------------------------------------------
      -- REGISTER 
      ---------------------------------------------------------------------
      regfile                               : inout work.regfile_ares_pack.ANALOGOUTPUT_TYPE := work.regfile_ares_pack.INIT_ANALOGOUTPUT_TYPE
    );
  end component;

  -- pris de Iris GTR
  component spi_if is

    port (
      -----------------------------------------
      -- Clocks and reset
      -----------------------------------------
      sys_reset_n                     : in        std_logic;
      sys_clk        : in std_logic;  -- register clock
  
      -----------------------------------------------------------------
      -- Flash interface
      -----------------------------------------------------------------
      spi_sdin                        : in  std_logic;                      -- data in
      spi_sdout                       : out std_logic;                      -- data out
      spi_csN                         : out std_logic;                      -- chip select
  
      -----------------------------------------------------------------
      -- Flash interface without IOB
      -----------------------------------------------------------------
      spi_sdout_iob  : out std_logic;          -- data out
      spi_sdout_ts   : out std_logic;          -- data out
      spi_csN_iob    : out std_logic;          -- chip select
      spi_csN_ts     : out std_logic;          -- chip select

      spi_sclk       : out std_logic;          -- clock
      spi_sclk_ts    : out std_logic;          -- clock

      -----------------------------------------------------------------
      -- Registers 
      -----------------------------------------------------------------
      regfile   : inout   SPI_TYPE := INIT_SPI_TYPE
  
    );
  end component;    

  component ares_pb is
  port (
    ProdCons_1_addr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    ProdCons_1_ben : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ProdCons_1_clk : in STD_LOGIC;
    ProdCons_1_read : in STD_LOGIC;
    ProdCons_1_readdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ProdCons_1_readdatavalid : out STD_LOGIC;
    ProdCons_1_reset : in STD_LOGIC;
    ProdCons_1_write : in STD_LOGIC;
    ProdCons_1_writedata : in STD_LOGIC_VECTOR ( 31 downto 0 );

    cfgmclk : out STD_LOGIC;
    mdio_mdc : out STD_LOGIC;
    mdio_mdio_i : in STD_LOGIC;
    mdio_mdio_o : out STD_LOGIC;
    mdio_mdio_t : out STD_LOGIC;
    --profinet_led_tri_o : out STD_LOGIC_VECTOR ( 1 downto 0 );
    profinet_output_tri_i : in STD_LOGIC_VECTOR ( 2 downto 0 );
    profinet_output_tri_o : out STD_LOGIC_VECTOR ( 2 downto 0 );
    profinet_output_tri_t : out STD_LOGIC_VECTOR ( 2 downto 0 );
    rmii_rtl_crs_dv : in STD_LOGIC;
    rmii_rtl_rx_er : in STD_LOGIC;
    rmii_rtl_rxd : in STD_LOGIC_VECTOR ( 1 downto 0 );
    rmii_rtl_tx_en : out STD_LOGIC;
    rmii_rtl_txd : out STD_LOGIC_VECTOR ( 1 downto 0 );
    spi_io0_i : in STD_LOGIC;
    spi_io0_o : out STD_LOGIC;
    spi_io0_t : out STD_LOGIC;
    spi_io1_i : in STD_LOGIC;
    spi_io1_o : out STD_LOGIC;
    spi_io1_t : out STD_LOGIC;
    spi_ss_i : in STD_LOGIC_VECTOR ( 0 to 0 );
    spi_ss_o : out STD_LOGIC_VECTOR ( 0 to 0 );
    spi_ss_t : out STD_LOGIC;
    --spi_sck_i : in STD_LOGIC;
    --spi_sck_o : out STD_LOGIC;
    --spi_sck_t : out STD_LOGIC;
    uart_rxd : in STD_LOGIC;
    uart_txd : out STD_LOGIC;
    ddr2_dq : inout STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH-1 downto 0 );
    ddr2_dqs_n : inout STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH/8-1 downto 0 );
    ddr2_dqs_p : inout STD_LOGIC_VECTOR ( DDR2_BUS_WIDTH/8-1 downto 0 );
    reset_n : in STD_LOGIC;
    clk_100MHz : in STD_LOGIC;
    ddr2_addr : out STD_LOGIC_VECTOR ( 12 downto 0 );
    ddr2_ba : out STD_LOGIC_VECTOR ( 1 downto 0 );
    ddr2_cas_n : out STD_LOGIC;
    ddr2_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr2_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr2_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr2_dm : out STD_LOGIC_VECTOR (DDR2_BUS_WIDTH/8 -1 downto 0 );
    ddr2_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    ddr2_ras_n : out STD_LOGIC;
    ddr2_we_n : out STD_LOGIC;
    ncsi_clk : in STD_LOGIC;
    ext_ProdCons_addr : in STD_LOGIC_VECTOR ( 10 downto 0 );
    ext_writeBeN : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ext_writeData : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sysclk : in STD_LOGIC;
    sysrst : in STD_LOGIC;
    ext_ProdCons_readData : out STD_LOGIC_VECTOR ( 31 downto 0 );
    ext_ProdCons_writeEn : in STD_LOGIC;
    ext_ProdCons_readEn : in STD_LOGIC;
    host_irq : out STD_LOGIC;
    ext_ProdCons_readDataValid : out STD_LOGIC
  );
  end component ares_pb;

  constant CLOCK_PERIOD : integer := 16;

  -- pour faire suite a une discussion avec Sebastien, la tick-table doit avoir 4 bits de large sur Ares.
  -- Cela correspond a la largeur de l'entree, tout comme sur Spider LPC. Je ne retrouve pas la garantie que cela sera toujours le cas.
  -- Je passe par cette constante pour pouvoir dissocier les deux valeur, le cas echeant.
  constant TICK_TABLE_WIDTH : integer := user_data_in'length;

  -- Signaux associe a l'interface PCIe
  signal sys_clk                              : std_logic;
  signal sys_reset_n                          : std_logic;
  signal sys_reset                            : std_logic;
  signal pcie_sys_clk                         : std_logic; -- reference venant du pcie, apres le input buffer differentiel
  signal clk_100MHz_buf                       : std_logic; -- reference, vers le microblaze
  
  signal reg_addr                     : std_logic_vector(REG_ADDRMSB downto REG_ADDRLSB);
  signal reg_write                    : std_logic;
  signal reg_beN                      : std_logic_vector(3 downto 0);
  signal reg_writedata                : std_logic_vector(31 downto 0);
  signal reg_read                     : std_logic;
  signal reg_readdata                 : std_logic_vector(31 downto 0);
  signal reg_readdatavalid            : std_logic;                                   -- Read data valid

  --attribute ASYNC_REG : string;
  
  signal userio_data_out        : std_logic_vector(user_data_out'range); 
  signal user_data_out_interne  : std_logic_vector(user_data_out'range); 
  signal zero_vector_out        : std_logic_vector(user_data_out'range);

  signal clean_user_data_in  : std_logic_vector(user_data_in'range);
  signal internal_input     : std_logic_vector(2 downto 0); -- 3 signaux specifiques inter-fpga

  signal Timer_Output        : std_logic_vector(TIMER_TYPE_ARRAY'range);

  type type_TickTable_Out        is array (TICKTABLE_TYPE_ARRAY'range) of std_logic_vector(TICK_TABLE_WIDTH-1 downto 0);
  type type_TickTable_half_IRQ   is array (TICKTABLE_TYPE_ARRAY'range) of std_logic;

  signal TickTable_Out           : type_TickTable_out;
  signal TickTableOut1DArray     : std_logic_vector(TICKTABLE_TYPE_ARRAY'length*TICK_TABLE_WIDTH-1 downto 0); -- version 1d de toutes les sorties de tick-table. Le 8 hardcode vient du 7 downto 0 hardcode plus haut
  signal TickTable_half_IRQ      : type_Ticktable_half_IRQ;
  signal Ticktable_WA_IRQ        : type_Ticktable_half_IRQ;
  signal TickTable_latch_IRQ     : type_Ticktable_half_IRQ;

  type type_timer_IRQ   is array (TIMER_TYPE_ARRAY'range) of std_logic;
  signal timer_start_IRQ         : type_timer_IRQ;
  signal timer_end_IRQ           : type_timer_IRQ;
  
  signal IO_IRQ                  : std_logic;
  signal TIMER_IRQ               : std_logic;
  
  signal TickClock_MUX            : std_logic_vector(QUADRATURE_TYPE_ARRAY'length  + user_data_in'length downto 1);
  signal InputStampSource_MUX     : std_logic_vector(TIMER_TYPE_ARRAY'length + internal_input'length + (user_data_in'length)-1 downto 0);
  signal OutSel_MUX               : std_logic_vector(internal_input'length + TIMER_TYPE_ARRAY'length + QUADRATURE_TYPE_ARRAY'length+ (TICK_TABLE_WIDTH * TICKTABLE_TYPE_ARRAY'length) downto 1);
  signal TimerArmSource_MUX       : std_logic_vector(TIMER_TYPE_ARRAY'length + internal_input'length + user_data_in'length downto 1);
  signal TimerTriggerSource_MUX   : std_logic_vector(TIMER_TYPE_ARRAY'length + QUADRATURE_TYPE_ARRAY'length  + (TICK_TABLE_WIDTH * TICKTABLE_TYPE_ARRAY'length) + internal_input'length + user_data_in'length +1 downto 2);
  signal ClockSource_MUX          : std_logic_vector(QUADRATURE_TYPE_ARRAY'length + user_data_in'length downto 1);
  signal AcqTrigger_MUX           : std_logic_vector(1 + user_data_in'length + TIMER_TYPE_ARRAY'length + QUADRATURE_TYPE_ARRAY'length + (TICK_TABLE_WIDTH * TICKTABLE_TYPE_ARRAY'length)- 1 downto 0);

  signal Qdecoder_out             : std_logic_vector(QUADRATURE_TYPE_ARRAY'range);

  -- nouveau regfile global
  signal regfile                  : REGFILE_ARES_TYPE := INIT_REGFILE_ARES_TYPE; -- Register file

  -- malheureusement, c'est trop rafine pour Vivado, alors on va hardcode le range...
  signal int_status             : std_logic_vector(7 downto 0) := (others => '0'); -- doit fitter avec le register file
  signal int_event              : std_logic_vector(31 downto 0) := (others => '0');

  -- pour faire le vecteur d'evenement, on passe par le mapping
  signal event_mapping          : INTERRUPT_QUEUE_MAPPING_TYPE;

  signal profinet_irq               : std_logic;

  -- access au SPI par le microblaze
  signal spi_io0_i                  : std_logic := '0';
  signal spi_io0_o                  : std_logic;
  signal spi_io0_t                  : std_logic;
  signal spi_io1_i                  : std_logic := '0';
  signal spi_io1_o                  : std_logic;
  signal spi_io1_t                  : std_logic;
  signal spi_ss_i                   : std_logic_vector ( 0 to 0 ) := (others => '0');
  signal spi_ss_o                   : std_logic_vector ( 0 to 0 );
  signal spi_ss_t                   : std_logic;
  -- acces au SPI par le host
  signal spi_sdout_iob              : std_logic;
  signal spi_sdout_ts               : std_logic;
  signal spi_csN_iob                : std_logic;
  signal spi_csN_ts                 : std_logic;
  signal spi_sclk_startupe2               : std_logic;
  signal spi_sclk_ts_startupe2            : std_logic;

  -- connexion register file external au Microblaze
  signal ext_writeBeN 				: STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ext_writeData 				: STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ext_ProdCons_addr 			: STD_LOGIC_VECTOR ( 10 downto 0 );
  signal ext_ProdCons_writeEn 		: STD_LOGIC;
  signal ext_ProdCons_readEn 		: STD_LOGIC;
  signal ext_ProdCons_readDataValid : STD_LOGIC := '1'; -- valeur par defaut s'il n'y a pas de profiblaze dans le code
  signal ext_ProdCons_readData 		: STD_LOGIC_VECTOR ( 31 downto 0 ) := (others => '0'); -- valeur par defaut s'il n'y a pas de profiblaze dans le code

  -- on ajoute une deuxieme interface prod-cons.  A vectoriser apres 2 unites?
  signal ProdCons_1_addr          : STD_LOGIC_VECTOR ( 10 downto 0 );
  -- ProdCons_1_clk : in STD_LOGIC;
  signal ProdCons_1_read          : STD_LOGIC;
  signal ProdCons_1_readdata      : STD_LOGIC_VECTOR ( 31 downto 0 ) := (others => '0'); -- valeur par defaut s'il n'y a pas de profiblaze dans le code
  signal ProdCons_1_readdatavalid : STD_LOGIC := '1'; -- valeur par defaut s'il n'y a pas de profiblaze dans le code
  --signal ProdCons_1_reset : in STD_LOGIC;
  signal ProdCons_1_write         : STD_LOGIC;

  signal profinet_led                     : std_logic_vector(1 downto 0) := (others => '0');
  signal profinet_internal_output         : std_logic := '0'; -- signal pour que le profiblaze puisse trigger le grab
  signal profinet_internal_output_meta    : std_logic;
  signal profinet_internal_output_sysclk  : std_logic; 
  signal user_rled_interne                : std_logic;
  
  signal uart_txd_profinet                : std_logic;
  
  constant MAX_FLASHER_COUNT              : integer := 31250000;--  1/2 seconde
  signal flasher_count                    : integer range 0 to MAX_FLASHER_COUNT := 0; -- periode PCIe = 16 ns, 1/2 seconde
  signal flasher_state                    : std_logic := '0'; -- juste pour que la simulation soit jolie, car on ne va pas resetter ce signal
  
  signal cfgmclk                          : std_logic; -- horloge sortant du block de configuration a 65 MHz +/- 50%
  signal cfgmclk_pb                       : std_logic; -- version qui sort du Microblaze
  
begin

  ------------------------------
  -- Trigger output selection --
  ------------------------------
  -- le trigger output est la sortie d'un mux prennant divers signaux interne. 
  -- Du a la relativement faible complexite de ce signal, je ne le mettrai pas dans un module reutilisable (est-ce reutilisable?)
  AcqTrigger_MUX <= profinet_internal_output_sysclk & clean_user_data_in & Timer_Output & Qdecoder_out & TickTableOut1DArray;

  process(sys_clk)
    variable AcqTrigger_AsInt : integer;
  begin
    if rising_edge(sys_clk) then
      AcqTrigger_AsInt := conv_integer(regfile.InternalOutput.OutputCond(0).Outsel);
      if AcqTrigger_AsInt < AcqTrigger_MUX'length then
        acq_trigger <= AcqTrigger_MUX(AcqTrigger_AsInt);
      else
        acq_trigger <= '0';
      end if;
    end if;
  end process;
  
  -------------------------------------------------
  -- redirection des signaux internes inter-fpga --
  -------------------------------------------------
  internal_input(0) <= acq_exposure;
  internal_input(1) <= acq_strobe;
  internal_input(2) <= acq_trigger_ready;

  ----------------------------------------------
  -- CONDITION DE SURCHAUFFE SIGNALEE PAR LED --
  ----------------------------------------------
  -- nous voulons faire un flasher a environ 1 Hz
  flashergenprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if flasher_count = 0 then
        flasher_count <= MAX_FLASHER_COUNT;
        flasher_state <= not flasher_state;
      else
        flasher_count <= flasher_count - 1;
        flasher_state <= flasher_state;
      end if;
    end if;
  end process;
    
  ------------------------------------------------------------------------
  -- redirection des LEDS. Le FPGA sert de level shifter essentiellement.
  ------------------------------------------------------------------------
  usrrledprc: process(regfile.Device_specific.FPGA_ID.PROFINET_LED, user_rled_soc, profinet_led, flasher_state,regfile.Device_specific.LED_OVERRIDE.RED_ORANGE_FLASH,regfile.Device_specific.LED_OVERRIDE.ORANGE_OFF_FLASH)
  begin
    if regfile.Device_specific.LED_OVERRIDE.RED_ORANGE_FLASH = '1' then
      -- quand on flash red-orange, le red est alume tout le temps
      user_rled_interne <= '1';
    elsif regfile.Device_specific.LED_OVERRIDE.ORANGE_OFF_FLASH = '1' then
      -- quand on flash orange off, alors la led rouge flash
      user_rled_interne <= flasher_state;
    elsif regfile.Device_specific.FPGA_ID.PROFINET_LED = '1' then
      user_rled_interne <= profinet_led(0);
    else
      -- controle par un IO du SOC
      user_rled_interne     <= user_rled_soc;
    end if;
  end process;
    
  -- sur le circuit rouge il y a un pullup pour que la led rouge s'allume par defaut.  On doit donc driver 0 pour 0 et 'z' pour 1, sinon ca fait un overdrive sur le rouge.
  user_rled <= '0' when user_rled_interne = '0' else 'Z';

                     
  --with regfile.Device_specific.FPGA_ID.PROFINET_LED select
  --  user_gled     <= user_gled_soc when '0',
  --                   profinet_led(0) when others;
  usrgledprc: process(regfile.Device_specific.FPGA_ID.PROFINET_LED, user_gled_soc, profinet_led, flasher_state,regfile.Device_specific.LED_OVERRIDE.RED_ORANGE_FLASH,regfile.Device_specific.LED_OVERRIDE.ORANGE_OFF_FLASH)
  begin
    if regfile.Device_specific.LED_OVERRIDE.RED_ORANGE_FLASH = '1' then
      -- quand on flash red-orange, le green flash
      user_gled <= flasher_state;
    elsif regfile.Device_specific.LED_OVERRIDE.ORANGE_OFF_FLASH = '1' then
      -- quand on flash orange off, alors la led verte flash
      user_gled <= flasher_state;
    elsif regfile.Device_specific.FPGA_ID.PROFINET_LED = '1' then
      user_gled <= profinet_led(1);
    else
      -- controle par un IO du SOC
      user_gled     <= user_gled_soc;
    end if;
  end process;

  -- venant de Athena
  status_gled   <= acq_led(0);

  -- sur le circuit rouge il y a un pullup pour que la led rouge s'allume par defaut.  On doit donc driver 0 pour 0 et 'z' pour 1, sinon ca fait un overdrive sur le rouge.
  status_rled   <= '0' when acq_led(1) = '0' else 'Z';
                          
  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
  refclk_ibuf : IBUFDS_GTE2
  port map (
    O                                    => pcie_sys_clk, 
    I                                    => pcie_sys_clk_p, 
    IB                                   => pcie_sys_clk_n,
    CEB                                  => '0',
    ODIV2                                => open
  ); 

  ---------------------------------------------------------------------------
  --  PCIe top level
  ---------------------------------------------------------------------------
  xpcie_top : pcie_top
    generic map(
        MAX_LANE_NB   => PCIe_LANES-1
        )
    port map(
      ---------------------------------------------------------------------------
      -- PCIe FPGA IOs (100 MHz input clock)
      ---------------------------------------------------------------------------
      pcie_sys_clk                         => pcie_sys_clk,
      pcie_sys_rst_n                       => pcie_sys_rst_n,
      pci_exp_rxp                          => pcie_rx_p,
      pci_exp_rxn                          => pcie_rx_n,
    
      pci_exp_txp                          => pcie_tx_p,
      pci_exp_txn                          => pcie_tx_n,

      ---------------------------------------------------------------------
      -- System clock and reset (62.5 MHz transaction interface clock)
      -- and 100 MHz clock (use to generate 200 MHz for memctrl IDELAY)
      ---------------------------------------------------------------------
      sys_clk                              => sys_clk,
      sys_reset_n                          => sys_reset_n,
    
      ---------------------------------------------------------------------
      -- Interrupt (active high)
      ---------------------------------------------------------------------
      int_status                           => int_status,
      int_event                            => int_event, 

      regfile                              => regfile.INTERRUPT_QUEUE,

      ---------------------------------------------------------------------
      -- Register file interface
      ---------------------------------------------------------------------
      reg_readdata                         => reg_readdata,
      reg_readdatavalid                    => reg_readdatavalid,
      reg_addr                             => reg_addr,
      reg_write                            => reg_write,
      reg_beN                              => reg_beN,
      reg_writedata                        => reg_writedata,
      reg_read                             => reg_read--,

--       ---------------------------------------------------------------------
--       -- DMA - PCIe interface
--       ---------------------------------------------------------------------
--       dma_tlp_req_to_send                  => dma_tlp_req_to_send,   
--       dma_tlp_grant                        => dma_tlp_grant,         
-- 
--       dma_tlp_fmt_type                     => dma_tlp_fmt_type,      
--       dma_tlp_length_in_dw                 => dma_tlp_length_in_dw,  
-- 
--       dma_tlp_src_rdy_n                    => dma_tlp_src_rdy_n,     
--       dma_tlp_dst_rdy_n                    => dma_tlp_dst_rdy_n,     
--       dma_tlp_data                         => dma_tlp_data,          
--                                                                   
--       -- for master request transmit          -- for master request 
--       dma_tlp_address                      => dma_tlp_address,       
--       dma_tlp_ldwbe_fdwbe                  => dma_tlp_ldwbe_fdwbe,   
--                                                                   
--       -- for completion transmit              -- for completion tran
--       dma_tlp_attr                         => dma_tlp_attr,          
--       dma_tlp_transaction_id               => dma_tlp_transaction_id,
--       dma_tlp_byte_count                   => dma_tlp_byte_count,    
--       dma_tlp_lower_address                => dma_tlp_lower_address, 
-- 
--       cfg_bus_mast_en                      => cfg_bus_mast_en,
--       cfg_setmaxpld                        => cfg_setmaxpld
    );

  -- corriger la polarite du reset
  sys_reset <= not sys_reset_n;
  


  -- Les interruptions classiques sont mappées du registre d'interruption directement.  
  -- Le driver doit aller lire les registres d'interruption secondaire en fonction de ce qu'il trouve dans le registre principal.
  int_status <= to_std_logic_vector(regfile.Device_specific.INTSTAT)(int_status'high downto int_status'low);
  
  -- mapping des sources d'evenement d'interruption en une structure   
  Q_timerirq : for Timer_IRQ_X in TIMER_TYPE_ARRAY'range generate
    event_mapping.IRQ_TIMER_END(Timer_IRQ_X)   <= timer_end_IRQ(Timer_IRQ_X)    and regfile.Device_specific.Intmaskn.IRQ_TIMER;
    event_mapping.IRQ_TIMER_START(Timer_IRQ_X) <= timer_start_IRQ(Timer_IRQ_X)  and regfile.Device_specific.Intmaskn.IRQ_TIMER;
  end generate;
  event_mapping.IO_INTSTAT      <= regfile.IO(0).IO_INTSTAT.Intstat_set;

  -- il n'y a un IRQ sur le Microblaze que s'il y a un microblaze dans le systeme
  mbeventmapgen: if GOLDEN = FALSE generate
    event_mapping.IRQ_MICROBLAZE  <= profinet_irq          and regfile.Device_specific.INTMASKn.IRQ_MICROBLAZE;
  end generate;
  mbeventmapgoldgen: if GOLDEN = TRUE generate
    event_mapping.IRQ_MICROBLAZE  <= '0';
  end generate;

  event_mapping.IRQ_TIMER       <= orN(regfile.Device_specific.INTSTAT2.IRQ_TIMER_START) or orN(regfile.Device_specific.INTSTAT2.IRQ_TIMER_END); -- pas vraiment utile puisqu'on a tous les autres bits de timer
  Q_TickTable_irqs : for TICKTABLE_IRQ_X in TICKTABLE_TYPE_ARRAY'range generate
    event_mapping.IRQ_TICK        <= TickTable_half_IRQ(TICKTABLE_IRQ_X) and regfile.Device_specific.Intmaskn.IRQ_TICK;--(TICKTABLE_IRQ_X);
    event_mapping.IRQ_TICK_LATCH  <= TickTable_latch_IRQ(TICKTABLE_IRQ_X);
    event_mapping.IRQ_TICK_WA     <= Ticktable_WA_IRQ(TICKTABLE_IRQ_X) and regfile.Device_specific.Intmaskn.IRQ_TICK_WA;--(TICKTABLE_IRQ_X);
  end generate;
  event_mapping.IRQ_IO         <= IO_IRQ and regfile.Device_specific.Intmaskn.IRQ_IO;

  int_event <= to_std_logic_vector(event_mapping);

  xglobalregfile: regfile_ares 
    port map(
      resetN        => sys_reset_n,
      sysclk        => sys_clk,
      regfile       => regfile,
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      => reg_read,
      reg_write     => reg_write,                                                       
      reg_addr      => reg_addr,
      reg_beN       => reg_beN,                                                        
      reg_writedata => reg_writedata,
      reg_readdatavalid => reg_readdatavalid,
      reg_readdata  => reg_readdata,
      ------------------------------------------------------------------------------------
      -- Interface name: External interface
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_writeBeN               => ext_writeBeN,               -- Write Byte Enable Bus for all external sections
      ext_writeData              => ext_writeData,              -- Write Data Bus for all external sections
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[0]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_0          => ext_ProdCons_addr,          -- Address Bus for ProdCons external section
      ext_ProdCons_writeEn_0       => ext_ProdCons_writeEn,       -- Write enable for ProdCons external section
      ext_ProdCons_readEn_0        => ext_ProdCons_readEn,        -- Read enable for ProdCons external section
      ext_ProdCons_readDataValid_0 => ext_ProdCons_readDataValid, -- Read Data Valid for ProdCons external section
      ext_ProdCons_readData_0      => ext_ProdCons_readData,       -- Read Data for the ProdCons external section
      
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[1]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_1          => ProdCons_1_addr,               -- Address Bus for ProdCons[1] external section
      ext_ProdCons_writeEn_1       => ProdCons_1_write,                                             -- Write enable for ProdCons[1] external section
      ext_ProdCons_readEn_1        => ProdCons_1_read,
      ext_ProdCons_readDataValid_1 => ProdCons_1_readdatavalid,
      ext_ProdCons_readData_1      => ProdCons_1_readdata
    );

  -- en premiere approximation, on va utiliser un BUFG, question de le reserve.  Idealement, pour minimiser le delai et le jitter, on tentera d'utiliser seulement un BUF, 
  -- ou plutot, on utilisera la source de clock PCIe.
  clk100mhzbuf: BUFG
    port map
     (O => clk_100MHz_buf,
      I => pcie_sys_clk);

  pbgen: if GOLDEN = FALSE generate
    ----------------
    -- Profiblaze --
    ----------------
    ares_pb_i: ares_pb
      port map (
        clk_100MHz                => clk_100MHz_buf,
        --clk_100MHz                => pcie_sys_clk,
        cfgmclk                   => cfgmclk_pb,
        ddr2_addr(12 downto 0)    => ddr2_addr(12 downto 0),
        ddr2_ba(1 downto 0)       => ddr2_ba(1 downto 0),
        ddr2_cas_n                => ddr2_cas_n,
        ddr2_ck_n(0)              => ddr2_ck_n,
        ddr2_ck_p(0)              => ddr2_ck_p,
        ddr2_cke(0)               => ddr2_cke,
        ddr2_dm                   => ddr2_dm,
        ddr2_dq                   => ddr2_dq,
        ddr2_dqs_n                => ddr2_dqs_n,
        ddr2_dqs_p                => ddr2_dqs_p,
        ddr2_odt(0)               => ddr2_odt,
        ddr2_ras_n                => ddr2_ras_n,
        ddr2_we_n                 => ddr2_we_n,
        -- pour 2015.1
        mdio_mdio_i  => '0',

        -- SPI
        spi_io0_i   => spi_io0_i,
        spi_io0_o   => spi_io0_o,
        spi_io0_t   => spi_io0_t,
        spi_io1_i   => spi_io1_i,
        spi_io1_o   => spi_io1_o,
        spi_io1_t   => spi_io1_t,
        spi_ss_i    => spi_ss_i, 
        spi_ss_o    => spi_ss_o, 
        spi_ss_t    => spi_ss_t,

        sysclk 	  => sys_clk,
        sysrst      => sys_reset,
        host_irq    => profinet_irq,

        ------------------------------------------------------------------------------------
        -- Interface name: External interface
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_writeBeN               => ext_writeBeN,
        ext_writeData              => ext_writeData,
        ------------------------------------------------------------------------------------
        -- Interface name: ProdCons
        -- Description: 
        ------------------------------------------------------------------------------------
        ext_ProdCons_addr          => ext_ProdCons_addr, 
        ext_ProdCons_writeEn       => ext_ProdCons_writeEn, 
        ext_ProdCons_readEn        => ext_ProdCons_readEn, 
        ext_ProdCons_readDataValid => ext_ProdCons_readDataValid, 
        ext_ProdCons_readData      => ext_ProdCons_readData,
      
        -- interface au deuxieme external
        ProdCons_1_addr           => ProdCons_1_addr,
        ProdCons_1_ben            => ext_writeBeN, -- partage entre les 2 interfaces
        ProdCons_1_clk            => sys_clk,
        ProdCons_1_read           => ProdCons_1_read,
        ProdCons_1_readdata       => ProdCons_1_readdata,
        ProdCons_1_readdatavalid  => ProdCons_1_readdatavalid,
        ProdCons_1_reset          => sys_reset,
        ProdCons_1_write          => ProdCons_1_write,
        ProdCons_1_writedata      => ext_writeData,
        
        --reset_n                   => sys_reset_n,  reset qui sort du PCI
        reset_n                   => pcie_sys_rst_n,  -- reset qui entre dans le core PCI
        ncsi_clk                  => ncsi_clk, 
        rmii_rtl_crs_dv           => ncsi_rx_crs_dv,
        rmii_rtl_rx_er            => '0', -- en NCSI, il n'y a pas de rx_er.  Un Phy doit corrompre le CRC s'il detecte une erreur. Je n'arrive pas a branche a 0 dans le block diagram, alors il faut le faire a l'externe
        rmii_rtl_rxd(1 downto 0)  => ncsi_rxd,
        rmii_rtl_tx_en            => ncsi_txen,
        rmii_rtl_txd(1 downto 0)  => ncsi_txd,
        --profinet_led_tri_o        => profinet_led,
      
        profinet_output_tri_i(2)  => profinet_internal_output,
        profinet_output_tri_i(1 downto 0)  => profinet_led,
        profinet_output_tri_o(2)  => profinet_internal_output,      
        profinet_output_tri_o(1 downto 0) => profinet_led,      
        profinet_output_tri_t     => open,

        uart_rxd                  => '1',
        uart_txd                  => uart_txd_profinet
      );

      -- Maintenant qu'on a 2 regions prod-cons, il faut les mapper a 2 places differente dans le register file. Ca ne peut donc plus etre statique dans le register file
      regfile.Microblaze.ProdCons(0).Offset <= conv_std_logic_vector(8192,20);
      regfile.Microblaze.ProdCons(1).Offset <= conv_std_logic_vector(16384,20);

      -- finalement, ce n'est pas facile de sortir la clock microblaze et son reset. Etant donne que le GPIO du microblaze ne peut changer que tres lentement, nous allons resynchroniser simplement avec 2 FF
      resynchprc: process(sys_clk)
      begin
        if rising_edge(sys_clk) then
          profinet_internal_output_meta   <= profinet_internal_output;
          profinet_internal_output_sysclk <= profinet_internal_output_meta;
        end if;
      end process;

      -- il ne faut que le Miroblaze drive le CFGMCLK que si nous utilisons le startupe2 dans du microblaze. 
      -- Dans la configuration NPI, il y a un microblaze, mais on ne doit pas utiliser son cfgmclk car le startupe2 est externe
      mb_mclkggen: if HOST_SPI_ACCESS = FALSE generate
        cfgmclk <= cfgmclk_pb;
      end generate;

  end generate;

  -- pour sauver de la puissance on ne drive la pin que lorsqu'on veut le debugger
  with regfile.Device_specific.FPGA_ID.PB_DEBUG_COM select
    uart_txd <= uart_txd_profinet when '1',
                'Z' when others;
  
  -- pour sauver de la puissance, on enleve le microblaze dans la version golden  
  nopbgen: if GOLDEN = TRUE generate
    --------------------------------------------------
    -- NCSI et IO divers 
    --------------------------------------------------
    ncsi_txen <= 'Z';
    ncsi_txd  <= (others => 'Z');

    uart_txd  <= 'Z';
   
    -- DDR2 memory interface
    ddr2_addr  <= (others => 'Z');
    ddr2_ba    <= (others => 'Z');
    ddr2_cas_n <= 'Z';

   nopbddr2clk : OBUFDS
   generic map (
      SLEW => "SLOW")          -- Specify the output slew rate
   port map (
      O => ddr2_ck_p,     -- Diff_p output (connect directly to top-level port)
      OB => ddr2_ck_n,   -- Diff_n output (connect directly to top-level port)
      I => '0'      -- Buffer input 
   );



    ddr2_cke   <= '0';
    ddr2_dm    <= (others => 'Z');
    ddr2_dq    <= (others => 'Z');

    dqsforgen: for i in ddr2_dqs_n'range generate
      dqs : OBUFTDS
      port map (
        O => ddr2_dqs_p(i),     -- Diff_p output (connect directly to top-level port)
        OB => ddr2_dqs_n(i),   -- Diff_n output (connect directly to top-level port)
        I => '0',     -- Buffer input
        T => '1'      -- 3-state enable input
      );
    end generate;

    ddr2_odt   <= '0';
    ddr2_ras_n <= 'Z';
    ddr2_we_n  <= 'Z';

  end generate;
  
  -- l'acces au SPI est donne a Microblaze, pour qu'il puisse aller chercher son code.
  newspigen: if HOST_SPI_ACCESS = FALSE generate
    spi_io0_iobuf: component IOBUF
      port map (
        I => spi_io0_o,
        IO => spi_sdout,
        O => spi_io0_i,
        T => spi_io0_t
      );

    spi_io1_iobuf: component IOBUF
      port map (
        I => spi_io1_o,
        IO => spi_sdin,    -- pin MISO
        O => spi_io1_i,
        T => spi_io1_t
      );

    spi_ss_iobuf_0: component IOBUF
      port map (
        I => spi_ss_o(0),
        IO => spi_csN,
        O => spi_ss_i(0),
        T => spi_ss_t
      );
      
  -- le startupe2 DOIT etre instantie DANS le Block Design, sinon le soft est defectueux     
  --startupe2_inst :  startupe2
  --generic map ( PROG_USR       => "FALSE",
  --              SIM_CCLK_FREQ  => 0.0
  --            )
  --port map    (
  --              CFGCLK    => open,
  --              CFGMCLK   => cfgmclk,
  --              EOS       => open,
  --              PREQ      => open,
  --              CLK       => '0',
  --              GSR       => '0',
  --              GTS       => '0',
  --              KEYCLEARB => '0',
  --              PACK      => '0',
  --              USRCCLKO  =>  spi_sck_o,
  --              USRCCLKTS =>  spi_sck_t,
  --              USRDONEO  => '1',
  --              USRDONETS => '1'
  --            );

  end generate;
  ---------------------------------------------------------------------
  --
  -- INPUT CLASSIQUEs
  --
  ---------------------------------------------------------------------
    bank0_INs: userio_bank
      generic map(
        width           => user_data_in'length,
        input_active    => TRUE,
        output_active   => FALSE,
        int_number      => 0
        )
      port map(
        sysclk          => sys_clk,        

        data_in         => clean_user_data_in,    -- input from Input Conditioning
        int_line        => IO_IRQ,

        regfile         => regfile.IO(0)
      );

    zero_vector_out <= (others=>'0');

  ---------------------------------------------------------------------
  --
  -- OUTPUT CLASSIQUES
  --
  ---------------------------------------------------------------------
    bank1_OUTs: userio_bank
      generic map(
        width           => user_data_out'length,
        input_active    => FALSE,
        output_active   => TRUE,
        int_number      => 0 -- output don't generate interrupts
        )
      port map(
        sysclk          => sys_clk,        

        data_in         => zero_vector_out,   -- not used in module
        data_out        => userio_data_out,   -- output, has to go through logic or tristate driver

        regfile         => regfile.IO(1)
      );


  ---------------------------------------------------------------------
  --
  -- INPUT CONDITIONING
  --
  ---------------------------------------------------------------------
  XInput_Conditioning : Input_Conditioning
  generic map ( LPC_PERIOD => CLOCK_PERIOD)
  port map(
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          => sys_reset_n,
    sys_clk                              => sys_clk,
    ---------------------------------------------------------------------
    -- Input signal: noisy
    ---------------------------------------------------------------------
    noise_user_data_in                   => user_data_in,
    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    clean_user_data_in                   => clean_user_data_in,
    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              => regfile.InputConditioning
  );

 ---------------------------------------------------------------------
  --
  -- Quad decoder x4
  --
  ---------------------------------------------------------------------
  SYNTHETISE_QUAD_DEC: if (SYNTH_QUAD_DECs = 1 )  generate
    QuadDec_gen : for QUAD_X in QUADRATURE_TYPE_ARRAY'range generate
      
      --dearraydblk: block is
      --  alias reg_QUAD is regfile.QUADRATURE;
      --begin
      
        Xquaddecoder : quaddecoder
          port map(
            sys_reset_n           => sys_reset_n,
            sys_clk               => sys_clk,

            DecoderCntrLatch_Src_MUX => InputStampSource_MUX,

            line_inputs           => clean_user_data_in,    -- all the possible event input lines.
        
            Qdecoder_out0         => Qdecoder_out(QUAD_X),
            --Qdecoder_out1         => open,
        
            regfile               => regfile.QUADRATURE(QUAD_X) -- on aura besoin d'un correctif au FDK pour generaliser.
        );
      --end block;
    end generate;
  end generate;
   
  NO_SYNTHETISE_QUAD_DEC: if (SYNTH_QUAD_DECs = 0 )  generate
    QuadDec_gen2 : for QUAD_X in QUADRATURE_TYPE_ARRAY'range generate
      Qdecoder_out(QUAD_X) <= '0';
    end generate;
  end generate;

  ---------------------------------------------------------------------
  --
  -- TIMERS 
  --
  ---------------------------------------------------------------------
  TimerArmSource_MUX(TimerArmSource_MUX'high downto 1) <=  Timer_Output & internal_input & clean_user_data_in;

  TTaggregateprc: process(TickTable_Out)
  begin
    for i in TICKTABLE_TYPE_ARRAY'range loop
      TickTableOut1DArray((i+1)*TICK_TABLE_WIDTH-1 downto i*TICK_TABLE_WIDTH) <= TickTable_Out(i);
    end loop;
  end process;

  TimerTriggerSource_MUX(TimerTriggerSource_MUX'high downto 2) <=  Timer_Output & Qdecoder_out & TickTableOut1DArray & internal_input & clean_user_data_in;
  ClockSource_MUX(QUADRATURE_TYPE_ARRAY'length + user_data_in'length downto 1) <=  Qdecoder_out & clean_user_data_in;
  
  SYNTHETISE_TIMER: if (SYNTH_TIMERs = 1 )  generate
    Timers_gen : for TIMER_X in TIMER_TYPE_ARRAY'range generate
      XTimer : Timer
      generic map ( int_number => TickTable_TYPE_ARRAY'length + 1,
                    LPC_PERIOD => CLOCK_PERIOD)
      port map(
        ---------------------------------------------------------------------
        -- Reset and clock signals
        ---------------------------------------------------------------------
        sys_reset_n                          => sys_reset_n,
        sys_clk                              => sys_clk,
        ---------------------------------------------------------------------
        -- Inputs
        ---------------------------------------------------------------------

        TimerArmSource_MUX                   => TimerArmSource_MUX,
        TimerTriggerSource_MUX               => TimerTriggerSource_MUX,
        ClockSource_MUX                      => ClockSource_MUX,
      
        ---------------------------------------------------------------------
        -- Output
        ---------------------------------------------------------------------
        Timer_Output                         => Timer_Output(TIMER_X),

        ---------------------------------------------------------------------
        -- IRQ
        ---------------------------------------------------------------------
        Timer_start_IRQ                      => timer_start_IRQ(TIMER_X),
        Timer_end_IRQ                        => timer_end_IRQ(TIMER_X),

        ---------------------------------------------------------------------
        -- REGISTER 
        ---------------------------------------------------------------------
        regfile                              => regfile.Timer(TIMER_X)
      );
    end generate;
  end generate;

  NO_SYNTHETISE_TIMER: if (SYNTH_TIMERs = 0 )  generate
    Timers_gen2 : for TIMER_X in TIMER_TYPE_ARRAY'range generate
      Timer_Output(TIMER_X) <= '0';
    end generate;  
  end generate;

  ---------------------------------------------------------------------
  --
  -- Tick TABLE 
  --
  ---------------------------------------------------------------------
  TickClock_MUX((QUADRATURE_TYPE_ARRAY'length + user_data_in'length) downto 1 ) <=  Qdecoder_out & clean_user_data_in ;      --last is reserved for clkint
  
  InputStampSource_MUX                        <= Timer_Output & internal_input & clean_user_data_in;

  SYNTHETISE_TICKTABLE: if (SYNTH_TICK_TABLES = 1 )  generate
    TickTable_gen : for TickTable_X in TickTable_TYPE_ARRAY'range generate
      XTickTable : TickTable
        generic map(  int_number => (TickTable_X+1),
                      --wa_int_number => (TickTable_X+2),
                      CLOCK_PERIOD => CLOCK_PERIOD
                   )   --TickTable0=>1  TickTable1->2
        port map(
        ---------------------------------------------------------------------
        -- Reset and clock signals
        ---------------------------------------------------------------------
        sys_reset_n                          => sys_reset_n,
        sys_clk                              => sys_clk,
    
        ---------------------------------------------------------------------
        -- Inputs
        ---------------------------------------------------------------------
        TickClock_MUX                        => TickClock_MUX,
        InputStampSource_MUX                 => InputStampSource_MUX,
      
        ---------------------------------------------------------------------
        -- Output signal: noiseless
        ---------------------------------------------------------------------
        TickTable_Out                        => TickTable_Out(TickTable_X),

        ---------------------------------------------------------------------
        -- IRQ for HALF done, ALL DONE
        ---------------------------------------------------------------------
        TickTable_half_IRQ                   => TickTable_half_IRQ(TickTable_X),
        Ticktable_WA_IRQ                     => Ticktable_WA_IRQ(TickTable_X),
        TickTable_latch_IRQ                  => TickTable_latch_IRQ(TickTable_X),
        
        ---------------------------------------------------------------------
        -- REGISTER 
        ---------------------------------------------------------------------
        regfile                              => regfile.TickTable(TickTable_X)
      );
    end generate;
  end generate;

  NO_SYNTHETISE_TICKTABLE: if (SYNTH_TICK_TABLES = 0 )  generate
    TickTable_gen2 : for TickTable_X in TickTable_TYPE_ARRAY'range generate
      TickTable_half_IRQ(TickTable_X)  <= '0';
      Ticktable_WA_IRQ(TickTable_X)    <= '0';
      TickTable_Out(TickTable_X)       <= (others =>'0');
    end generate;
  end generate;


  ---------------------------------------------------------------------
  --
  -- OUTPUT CONDITIONING
  --
  ---------------------------------------------------------------------
  OutSel_MUX(OutSel_MUX'high downto 1) <=  internal_input & Timer_Output &  Qdecoder_out & TickTableOut1DArray;
  
  XOutput_Conditioning : Output_Conditioning
  generic map ( SIMULATION      => SIMULATION,
                LPC_PERIOD      => CLOCK_PERIOD
              )
  port map(
    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_reset_n                          => sys_reset_n,
    sys_clk                              => sys_clk,
    ---------------------------------------------------------------------
    -- Inputs
    ---------------------------------------------------------------------
    userio_data_out                      =>  userio_data_out,
    OutSel_MUX                           =>  OutSel_MUX,
    ---------------------------------------------------------------------
    -- Output signal: noiseless
    ---------------------------------------------------------------------
    user_data_out                        =>  user_data_out,
    --user_data_out                        =>  user_data_out_interne,

    ---------------------------------------------------------------------
    -- REGISTER 
    ---------------------------------------------------------------------
    regfile                              =>  regfile.OutputConditioning
  );

  -- sortir les IO directement
  --user_data_out(user_data_out'high downto 1) <= user_data_out_interne(user_data_out_interne'high downto 1);
  -- port serie virtuel
  --user_data_out(0) <= not uart_txd_profinet; -- not pour compenser pour la structure open-collector de nos ios.


  ---------------------------------------------------------------------
  --
  -- ANALOG OUTPUT
  --
  ---------------------------------------------------------------------
  Xpwm_output: pwm_output 
     port map(
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_reset                             => sys_reset,
      sys_clk                               => sys_clk,
    
      ---------------------------------------------------------------------
      -- Output signal: noiseless
      ---------------------------------------------------------------------
      pwm_Out                               => pwm_out,

      ---------------------------------------------------------------------
      -- REGISTER 
      ---------------------------------------------------------------------
      regfile                               => regfile.AnalogOutput
    );


  ---------------------------------------------------------------------
  --
  -- IO IRQ DISPATCH
  --
  ---------------------------------------------------------------------

  -------------------------
  -- IO_INTSTAT Register --
  -------------------------
  Timer_irqs : for Timer_IRQ_X in TIMER_TYPE_ARRAY'range generate
    regfile.Device_specific.INTSTAT2.IRQ_TIMER_START_set(Timer_IRQ_X)   <= timer_start_IRQ(Timer_IRQ_X)  and regfile.Device_specific.Intmaskn.IRQ_TIMER;
    regfile.Device_specific.INTSTAT2.IRQ_TIMER_END_set(Timer_IRQ_X)     <= timer_end_IRQ(Timer_IRQ_X)    and regfile.Device_specific.Intmaskn.IRQ_TIMER;
  end generate;

  TickTable_irqs : for TICKTABLE_IRQ_X in TICKTABLE_TYPE_ARRAY'range generate
    regfile.Device_specific.INTSTAT.IRQ_TICK_set     <= TickTable_half_IRQ(TICKTABLE_IRQ_X) and regfile.Device_specific.Intmaskn.IRQ_TICK;--(TICKTABLE_IRQ_X);
    regfile.Device_specific.INTSTAT.IRQ_TICK_WA_set  <= Ticktable_WA_IRQ(TICKTABLE_IRQ_X)   and regfile.Device_specific.Intmaskn.IRQ_TICK_WA;--(TICKTABLE_IRQ_X);
    regfile.Device_specific.INTSTAT.IRQ_TICK_LATCH_set  <= TickTable_latch_IRQ(TICKTABLE_IRQ_X);  -- toujours enable, a la demande de Sebastien
  end generate;

  TIMER_IRQ <= orN(regfile.Device_specific.INTSTAT2.IRQ_TIMER_START) or orN(regfile.Device_specific.INTSTAT2.IRQ_TIMER_END);
  regfile.Device_specific.INTSTAT.IRQ_TIMER        <= TIMER_IRQ;  --Read Only register
  
  regfile.Device_specific.INTSTAT.IRQ_IO_set       <= IO_IRQ and regfile.Device_specific.Intmaskn.IRQ_IO;

  -- il n'y a un IRQ sur le Microblaze que s'il y a un microblaze dans le systeme
  mbgen: if GOLDEN = FALSE generate
  regfile.Device_specific.INTSTAT.IRQ_MICROBLAZE_set  <= profinet_irq          and regfile.Device_specific.INTMASKn.IRQ_MICROBLAZE;
  end generate;
  mbgoldgen: if GOLDEN = TRUE generate
    regfile.Device_specific.INTSTAT.IRQ_MICROBLAZE_set  <= '0';
  end generate;

  ------------------------------------------------------------------------------------------
  -- Field name: BUILDID(31 downto 0)
  -- Field type: RO
  ------------------------------------------------------------------------------------------
  regfile.Device_specific.BUILDID.YEAR    <= BUILD_ID(31 downto 24);
  regfile.Device_specific.BUILDID.MONTH   <= BUILD_ID(23 downto 20);
  regfile.Device_specific.BUILDID.DATE    <= BUILD_ID(19 downto 12);
  regfile.Device_specific.BUILDID.HOUR    <= BUILD_ID(11 downto 4);
  regfile.Device_specific.BUILDID.MINUTES <= BUILD_ID(3 downto 0);

  ------------------------------------------------------------------------------------------
  -- Field name: FPGA_ID(2 downto 0)
  -- Field type: RO
  ------------------------------------------------------------------------------------------
  regfile.Device_specific.FPGA_ID.FPGA_ID <= conv_std_logic_vector(FPGA_ID,regfile.Device_specific.FPGA_ID.FPGA_ID'length);



  hostspigen: if HOST_SPI_ACCESS = TRUE generate
  ---------------------------------------------------------------
  --
  --  SPI CORE
  --
  ---------------------------------------------------------------
  xspi_if : spi_if
  port map(
    -----------------------------------------
    -- Clocks and reset
    -----------------------------------------
    sys_reset_n    => sys_reset_n,
    sys_clk        => sys_clk,        -- L'horloge SPI est le sys_clk/2 c'est fait a l'interne

    -----------------------------------------------------------------
    -- Flash interface
    -----------------------------------------------------------------
    spi_sclk       => spi_sclk_startupe2,     -- out cclock
    spi_sclk_ts    => spi_sclk_ts_startupe2,  -- out cclock enableNOT
    spi_sdin       => spi_sdin,               -- in  data in
    spi_sdout      => spi_sdout,              -- out data out
    spi_csN        => spi_csN,                -- out chip select
    --spi_wpN        => open,                 -- not used for now
    --spi_holdN      => open,                 -- not used for now

    -----------------------------------------------------------------
    -- Registers 
    -----------------------------------------------------------------
    regfile        => regfile.SPI
  );

  -----------------------------------------------------------------
  -- Pour la simulation
  -----------------------------------------------------------------
  -- synthesis translate_off
  spi_sclk    <= spi_sclk_startupe2    when spi_sclk_ts_startupe2 = '0' else 'Z';
  -- synthesis translate_on


  -----------------------------------------------------------------
  -- Pour la synthese
  -----------------------------------------------------------------
  startupe2_inst :  startupe2
  generic map ( PROG_USR       => "FALSE",
                SIM_CCLK_FREQ  => 0.0
              )
  port map    (
                CFGCLK    => open,
                CFGMCLK   => cfgmclk,
                EOS       => open,
                PREQ      => open,
                CLK       => '0',
                GSR       => '0',
                GTS       => '0',
                KEYCLEARB => '0',
                PACK      => '0',
                USRCCLKO  =>  spi_sclk_startupe2,
                USRCCLKTS =>  spi_sclk_ts_startupe2,
                USRDONEO  => '1',
                USRDONETS => '1'
              );
  end generate;

  -- on ne veux mettre la patch que sur le code golden et profinet, pas sur le code NPI.
  patchgen: if GOLDEN = TRUE or HOST_SPI_ACCESS = FALSE generate
  -- je met cette logique dans un block, car c'est lie a une patch pour la plateforme hardware baytrail, ce qui n'a que peut rapport avec le reste du design
  intel4600919patch: block is
    signal reset_counter : integer range 0 to 100000000 := 100000000;  -- la clock source est 65+50% MHz = 97.5 Mhz, on veut compter une seconde.
    signal patch_poweron_reset : std_logic := '1';
    signal patch_poweron_reset_p1 : std_logic := '1';
    signal watchdog_armed         : std_logic; -- indique que la patch est active.
  begin


    -- ici c'est un peu complexe. Nous NE pouvons PAS utiliser le signal de reset, car c'est le signal que nous surveillons.
    -- ca va nous faire un gros compteur (27 bits) qui compte sur une clock sans signal de reset ou enable synchrone pour le faire partir.
    -- ce n'est pas ideal et il pourrait y avoir des faux comptes sur le premier coup de clock. Est-ce grave?
    porflow: process(cfgmclk)
    begin
      if rising_edge(cfgmclk) then
        patch_poweron_reset <= '0';
        patch_poweron_reset_p1 <= patch_poweron_reset;  -- pour garder notre compteur en reset pour les 2 premiers coups de clock
      end if;
    end process;
    
    clkprc:process(cfgmclk) -- la clock PCIe devrait etre presente car elle est genere par un circuit independant du controlleur de reset.
    begin
      if rising_edge(cfgmclk) then
        if patch_poweron_reset_p1 = '1' then
          reset_counter <= 100000000; 
          pwrrst <= 'Z'; -- on ne drive pas le reset artificiel.
        elsif reset_counter /= 0 then
          if watchdog_armed = '1' then -- on ne decremente que jusqu'a la monte du reset de la plateforme.
            reset_counter <= reset_counter - 1;
          end if;

          pwrrst <= 'Z'; -- on ne drive pas le reset artificiel.
        else
          reset_counter <= 0;
          pwrrst <= '1';  -- on demande au PMIC de faire un reset du power.  Le reset du power va faire tomber l'alimentation du FPGA ce qui va enlever le reset
        end if;

        if patch_poweron_reset_p1 = '1' then
          watchdog_armed <= '1';
        elsif pcie_sys_rst_n = '1' then -- le host a desactiver son reset. A partir de ce point, nous n'avons plus besoin de faire de watchdog jamais.
          watchdog_armed <= '0';
        end if;

      end if;
      
    end process;

  end block;
  end generate;

end functional;