----------------------------------------------------------------------
-- DESCRIPTION: Athena XGS
--
-- Top level history:
-- =============================================
-- V0.1     : 
-- V0.2     : 
--
-- PROJECT: Iris-4
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


entity csib_xczu2cg is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0
    );
  port (
    ext_sync_ext_sync_en  : out std_logic;
    ext_sync_ext_sync_in  : in  std_logic;
    ext_sync_ext_sync_out : out std_logic;
    hispi_data_n          : in  std_logic_vector (5 downto 0);
    hispi_data_p          : in  std_logic_vector (5 downto 0);
    hispi_serial_clk_n    : in  std_logic_vector (5 downto 0);
    hispi_serial_clk_p    : in  std_logic_vector (5 downto 0);
    rmii_crs_dv           : in  std_logic;
    rmii_rx_er            : in  std_logic;
    rmii_rxd              : in  std_logic_vector (1 downto 0);
    rmii_tx_en            : out std_logic;
    rmii_txd              : out std_logic_vector (1 downto 0);
    user_data_in          : in  std_logic_vector (3 downto 0);
    user_data_out         : out std_logic_vector (2 downto 0)
    );
end csib_xczu2cg;


architecture struct of csib_xczu2cg is


  component system_pb_wrapper is
    port (
      ext_sync_ext_sync_en  : out std_logic;
      ext_sync_ext_sync_in  : in  std_logic;
      ext_sync_ext_sync_out : out std_logic;
      hispi_data_n          : in  std_logic_vector (5 downto 0);
      hispi_data_p          : in  std_logic_vector (5 downto 0);
      hispi_serial_clk_n    : in  std_logic_vector (5 downto 0);
      hispi_serial_clk_p    : in  std_logic_vector (5 downto 0);
      rmii_crs_dv           : in  std_logic;
      rmii_rx_er            : in  std_logic;
      rmii_rxd              : in  std_logic_vector (1 downto 0);
      rmii_tx_en            : out std_logic;
      rmii_txd              : out std_logic_vector (1 downto 0);
      user_data_in          : in  std_logic_vector (3 downto 0);
      user_data_out         : out std_logic_vector (2 downto 0)
      );
  end component;


  constant PB_DEBUG_COM : std_logic := '0';

  signal UNCONNECTED  : std_logic_vector (53 downto 0);
  signal pcie_sys_clk : std_logic;
  signal spi_in       : std_logic_vector (3 downto 0);
  signal spi_out      : std_logic_vector (3 downto 0);
  signal spi_out_en   : std_logic_vector (3 downto 0);
  signal spi_cs_in    : std_logic_vector (0 to 0);
  signal spi_cs_out   : std_logic_vector (0 to 0);
  signal spi_cs_en    : std_logic;

begin


  xsystem_pb_wrapper : system_pb_wrapper
    port map(
      ext_sync_ext_sync_en  => open,
      ext_sync_ext_sync_in  => '0',
      ext_sync_ext_sync_out => open,
      hispi_data_n          => hispi_data_n,
      hispi_data_p          => hispi_data_p,
      hispi_serial_clk_n    => hispi_serial_clk_n,
      hispi_serial_clk_p    => hispi_serial_clk_p,
      rmii_crs_dv           => rmii_crs_dv,
      rmii_rx_er            => rmii_rx_er,
      rmii_rxd              => rmii_rxd,
      rmii_tx_en            => rmii_tx_en,
      rmii_txd              => rmii_txd,
      user_data_in          => user_data_in,
      user_data_out         => user_data_out
      );

end struct;
