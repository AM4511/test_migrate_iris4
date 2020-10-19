----------------------------------------------------------------------
-- $HeadURL:  $
-- $Revision:  $
-- $Date:  $
-- Author: amarchan
--
-- DESCRIPTION: Fichier top du FPGA de Ares_test
--
-- Ce FPGA contient un system IPI de test pour valider l'interface
-- HyperRam
--
-- PROJECT: Iris4
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;


entity ares_test is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0;

    -- Deprecated
    --BUILD_ID        : std_logic_vector(31 downto 0) := x"76543210";  -- Generic passed in .tcl script
    --SIMULATION      : integer                       := 0;
    PCIe_LANES  : integer := 1;
    --FPGA_ID                   : integer := 8;                          -- Ares for y7478-00
    --FPGA_ID         : integer                       := 9;  -- Ares for y7478-01
    NB_USER_IN  : integer := 4;
    NB_USER_OUT : integer := 3
    --GOLDEN          : boolean                       := false;  -- le code Golden n'a pas de Microblaze
    -- HOST_SPI_ACCESS : boolean                       := false;  -- est-ce qu'on veut donner l'acces SPI au host, pour NPI (par rapport au Microblaze)
    -- veuillez noter qu'il faut AUSSI enlever le STARTUPE2 dans le module SPI dans le block design
    -- et changer quelle fichier de contrainte qui est actif.

   --SYNTH_SPI_PAGE_256B_BURST : integer := 1;                  -- Pour ne pas implementer la capacite de burster 256Bytes mettre a '0' (1 RAM de moins)
   -- SYNTH_TICK_TABLES : integer := 1;  -- Pour ne pas implementer les TickTables mettre a '0'
   --SYNTH_TIMERs      : integer := 1;  -- Pour ne pas implementer les Timers mettre a '0'
   --SYNTH_QUAD_DECs   : integer := 1  -- Pour ne pas implementer les Quad Dec mettre a '0'
    );
  port (
    sys_rst_in_n   : in std_logic;
    ref_clk_100MHz : in std_logic;
    fpga_straps    : in std_logic_vector(3 downto 0);

    ---------------------------------------------------------------------------
    --eSPI interface
    ---------------------------------------------------------------------------
    espi_reset_n : in    std_logic;
    espi_clk     : in    std_logic;
    espi_cs_n    : in    std_logic;
    espi_io      : inout std_logic_vector(3 downto 0);
    espi_alert_n : out   std_logic;

    ---------------------------------------------------------------------------
    --  PCIe core
    ---------------------------------------------------------------------------
    pcie_sys_clk_n : in  std_logic;
    pcie_sys_clk_p : in  std_logic;
    pcie_rxn       : in  std_logic_vector(PCIe_LANES-1 downto 0);
    pcie_rxp       : in  std_logic_vector(PCIe_LANES-1 downto 0);
    pcie_txn       : out std_logic_vector(PCIe_LANES-1 downto 0);
    pcie_txp       : out std_logic_vector(PCIe_LANES-1 downto 0);


    ---------------------------------------------------------------------------
    -- CPU debug interface
    ---------------------------------------------------------------------------
    debug_uart_rxd : in  std_logic;
    debug_uart_txd : out std_logic;


    ------------------------------
    -- connexion au FPGA Athena --
    ------------------------------
    acq_led           : in  std_logic_vector(1 downto 0);
    acq_exposure      : in  std_logic;  -- connecte sur internal_input(0)
    acq_strobe        : in  std_logic;  -- connecte sur internal_input(1)
    acq_trigger_ready : in  std_logic;  -- connecte sur internal_input(2)
    acq_trigger       : out std_logic;

    ------------------------------
    -- connexion aux LEDS et SOC
    ------------------------------
    user_rled_soc : in  std_logic;
    user_gled_soc : in  std_logic;
    user_rled     : out std_logic;
    user_gled     : out std_logic;
    status_rled   : out std_logic;
    status_gled   : out std_logic;


    --------------------------------------------------
    -- NCSI et IO divers 
    --------------------------------------------------
    ncsi_clk       : out std_logic;
    ncsi_rx_crs_dv : in  std_logic;
    ncsi_rxd       : in  std_logic_vector(1 downto 0);
    ncsi_tx_en     : out std_logic;
    ncsi_txd       : out std_logic_vector(1 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH QUADSPI user interface
    ---------------------------------------------------------------------------
    spi_cs_n : inout std_logic;
    spi_sd   : inout std_logic_vector(3 downto 0);

    ---------------------------------------------------------------------------
    -- HyperRam I/F
    ---------------------------------------------------------------------------
    hb_ck    : out   std_logic;
    hb_ck_n  : out   std_logic;
    hb_cs_n  : out   std_logic;
    hb_dq    : inout std_logic_vector (7 downto 0);
    --hb_int_n  : in    std_logic;
    hb_rst_n : out   std_logic;
    --hb_rsto_n : in    std_logic;
    hb_rwds  : inout std_logic;
    --hb_wp_n   : out   std_logic;

    ---------------------------------------------------------------------------
    --  FPGA USER IO interface
    ---------------------------------------------------------------------------
    -- user io
    pwm_out       : out std_logic;
    user_data_in  : in  std_logic_vector(NB_USER_IN-1 downto 0);
    user_data_out : out std_logic_vector(NB_USER_OUT-1 downto 0);

    --------------------------------------------------
    -- correctif au probleme de reset baytrail
    --------------------------------------------------
    sys_rst_out_n : out std_logic := 'Z'
    );
end ares_test;


architecture struct of ares_test is



  component ares_pb_wrapper is
    port (
  FPGA_Info_board_info : in STD_LOGIC_VECTOR ( 3 downto 0 );
    FPGA_Info_fpga_build_id : in STD_LOGIC_VECTOR ( 31 downto 0 );
    FPGA_Info_fpga_device_id : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FPGA_Info_fpga_firmware_type : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FPGA_Info_fpga_major_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FPGA_Info_fpga_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    FPGA_Info_fpga_sub_minor_ver : in STD_LOGIC_VECTOR ( 7 downto 0 );
    hb_ck : out STD_LOGIC;
    hb_ck_n : out STD_LOGIC;
    hb_cs0_n : out STD_LOGIC;
    hb_dq : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    hb_rst_n : out STD_LOGIC;
    hb_rwds : inout STD_LOGIC;
    hb_wp_n : out STD_LOGIC;
    mtxSPI_0_spi_csn : out STD_LOGIC;
    mtxSPI_0_spi_sdin : in STD_LOGIC;
    mtxSPI_0_spi_sdout : out STD_LOGIC;
    ncsi_clk : out STD_LOGIC;
    ncsi_crs_dv : in STD_LOGIC;
    ncsi_rx_er : in STD_LOGIC;
    ncsi_rxd : in STD_LOGIC_VECTOR ( 1 downto 0 );
    ncsi_tx_en : out STD_LOGIC;
    ncsi_txd : out STD_LOGIC_VECTOR ( 1 downto 0 );
    pcie_mgt_0_rxn : in STD_LOGIC;
    pcie_mgt_0_rxp : in STD_LOGIC;
    pcie_mgt_0_txn : out STD_LOGIC;
    pcie_mgt_0_txp : out STD_LOGIC;
    pcie_sys_clk : in STD_LOGIC;
    refclk_50MHz : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    uart_rxd : in STD_LOGIC;
    uart_txd : out STD_LOGIC
      );
  end component ares_pb_wrapper;


   signal pcie_sys_clk_buf : std_logic;  -- reference venant du pcie, apres le input buffer differentiel
   signal refclk_50MHz_buf : std_logic;  -- reference, vers le microblaze


begin


  -- Pour avoir access a la pin dedie du core PCIe, il faut instantier le IBUFDS_GTE2
   refclk_ibuf : IBUFDS_GTE2
     port map (
       O     => pcie_sys_clk_buf,
       I     => pcie_sys_clk_p,
       IB    => pcie_sys_clk_n,
       CEB   => '0',
       ODIV2 => open
       );


  -- en premiere approximation, on va utiliser un BUFG, question de le reserve.  Idealement, pour minimiser le delai et le jitter, on tentera d'utiliser seulement un BUF, 
  -- ou plutot, on utilisera la source de clock PCIe.
  clk100mhzbuf : BUFG
    port map
    (
      O => refclk_50MHz_buf,
--      I => pcie_sys_clk
      I => ref_clk_100MHz
      );

  ----------------
  -- Profiblaze --
  ----------------
  ares_pb_i : ares_pb_wrapper
    port map (
      FPGA_Info_board_info         => fpga_straps,
      FPGA_Info_fpga_build_id      => std_logic_vector(to_unsigned(FPGA_BUILD_DATE, 32)),
      FPGA_Info_fpga_device_id     => std_logic_vector(to_unsigned(FPGA_DEVICE_ID, 8)),
      FPGA_Info_fpga_firmware_type => std_logic_vector(to_unsigned(FPGA_IS_NPI_GOLDEN, 8)),
      FPGA_Info_fpga_major_ver     => std_logic_vector(to_unsigned(FPGA_MAJOR_VERSION, 8)),
      FPGA_Info_fpga_minor_ver     => std_logic_vector(to_unsigned(FPGA_MINOR_VERSION, 8)),
      FPGA_Info_fpga_sub_minor_ver => std_logic_vector(to_unsigned(FPGA_SUB_MINOR_VERSION, 8)),
      hb_ck                        => hb_ck,
      hb_ck_n                      => hb_ck_n,
      hb_cs0_n                     => hb_cs_n,
      hb_dq                        => hb_dq,
      hb_rst_n                     => hb_rst_n,
      hb_rwds                      => hb_rwds,
      mtxSPI_0_spi_csn             => open,
      mtxSPI_0_spi_sdin            => '0',
      mtxSPI_0_spi_sdout           => open,
      ncsi_clk                     => ncsi_clk,
      ncsi_crs_dv                  => ncsi_rx_crs_dv,
      ncsi_rx_er                   => '0',
      ncsi_rxd                     => ncsi_rxd,
      ncsi_tx_en                   => ncsi_tx_en,
      ncsi_txd                     => ncsi_txd,
      pcie_mgt_0_rxn               => pcie_rxn(0),
      pcie_mgt_0_rxp               => pcie_rxp(0),
      pcie_mgt_0_txn               => pcie_txn(0),
      pcie_mgt_0_txp               => pcie_txp(0),
      pcie_sys_clk                 => pcie_sys_clk_buf,
      refclk_50MHz                 => refclk_50MHz_buf,
      reset_n                      => sys_rst_in_n,
      uart_rxd                     => debug_uart_rxd,
      uart_txd                     => debug_uart_txd
      );

end struct;
