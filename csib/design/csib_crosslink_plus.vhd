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



entity csib_crosslink_plus is
  generic(
    FPGA_MAJOR_VERSION     : integer := 0;
    FPGA_MINOR_VERSION     : integer := 0;
    FPGA_SUB_MINOR_VERSION : integer := 0;
    FPGA_BUILD_DATE        : integer := 0;
    FPGA_IS_NPI_GOLDEN     : integer := 0;
    FPGA_DEVICE_ID         : integer := 0;
    NUMB_BLOCK             : integer := 4;
    LANE_PER_BLOCK         : integer := 1
    );
  port (
    ref_clk  : in std_logic;
    sysrst_n : in std_logic;

    ---------------------------------------------------------------------------
    -- CSI-2 DPHY
    ---------------------------------------------------------------------------
    csi2_dphy_clk_n_o : inout std_logic;
    csi2_dphy_clk_p_o : inout std_logic;
    csi2_dphy_d0_n_io : inout std_logic;
    csi2_dphy_d0_p_io : inout std_logic;
    csi2_dphy_d1_n_o  : inout std_logic;
    csi2_dphy_d1_p_o  : inout std_logic;
    csi2_dphy_d2_n_o  : inout std_logic;
    csi2_dphy_d2_p_o  : inout std_logic;
    csi2_dphy_d3_n_o  : inout std_logic;
    csi2_dphy_d3_p_o  : inout std_logic;


    ---------------------------------------------------------------------------
    -- HiSPi sensor interface
    ---------------------------------------------------------------------------
    -- hispi_data_n       : in std_logic_vector (3 downto 0);
    -- hispi_data_p       : in std_logic_vector (3 downto 0);
    -- hispi_serial_clk_n : in std_logic_vector (3 downto 0);
    -- hispi_serial_clk_p : in std_logic_vector (3 downto 0)

    -- HiSPI I/F
    hispi_serial_clk_p : in std_logic_vector(NUMB_BLOCK - 1 downto 0);  -- hispi clock
    hispi_serial_clk_n : in std_logic_vector(NUMB_BLOCK - 1 downto 0);  -- hispi clock
    hispi_data_p       : in std_logic_vector((NUMB_BLOCK*LANE_PER_BLOCK) - 1 downto 0);
    hispi_data_n       : in std_logic_vector((NUMB_BLOCK*LANE_PER_BLOCK) - 1 downto 0)

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    -- spi_cs_n : inout std_logic;
    -- spi_sd   : inout std_logic_vector (3 downto 0);

   -- ---------------------------------------------------------------------------
   -- -- MTX advance IO
   -- ---------------------------------------------------------------------------
   -- user_data_in  : in  std_logic_vector (3 downto 0);
   -- user_data_out : out std_logic_vector (2 downto 0)
    );
end csib_crosslink_plus;


architecture struct of csib_crosslink_plus is


  component hispi_top is
    generic (
      FPGA_MANUFACTURER    : string  := "INTEL";
      NUMB_BLOCK           : integer := 6;
      TOTAL_NUMBER_OF_LANE : integer := 24;
      MUX_RATIO            : integer := 4;
      LANE_PER_BLOCK       : integer := 1;
      WORD_SIZE            : integer := 12;
      PIXELS_PER_LINE      : integer := 1280;
      LINES_PER_FRAME      : integer := 960
      );
    port (
      sysclk : in std_logic;
      sysrst : in std_logic;

      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read          : in  std_logic;  -- Read
      reg_write         : in  std_logic;  -- Write
      reg_addr          : in  std_logic_vector(7 downto 2);   -- Address
      reg_beN           : in  std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata     : in  std_logic_vector(31 downto 0);  -- Write data
      reg_readdatavalid : out std_logic;  -- Read data valid
      reg_readdata      : out std_logic_vector(31 downto 0);  -- Read data

      -- HiSPI I/F
      hispi_serial_clk_p : in std_logic_vector(NUMB_BLOCK - 1 downto 0);  -- hispi clock
      hispi_serial_clk_n : in std_logic_vector(NUMB_BLOCK - 1 downto 0);  -- hispi clock
      hispi_data_p       : in std_logic_vector((NUMB_BLOCK*LANE_PER_BLOCK) - 1 downto 0);
      hispi_data_n       : in std_logic_vector((NUMB_BLOCK*LANE_PER_BLOCK) - 1 downto 0);

      -- Stream I/F
      ---------------------------------------------------------------------------
      -- AXI Master stream interface
      ---------------------------------------------------------------------------
      m_axis_tready : in  std_logic;
      m_axis_tvalid : out std_logic;
      m_axis_tdata  : out std_logic_vector(63 downto 0);
      m_axis_tstrb  : out std_logic_vector(7 downto 0);
      m_axis_tlast  : out std_logic;

      ---------------------------------------------------------------------------
      -- AXI Slave stream interface
      ---------------------------------------------------------------------------
      s_axis_tready : out std_logic;
      s_axis_tvalid : in  std_logic;
      s_axis_tdata  : in  std_logic_vector(63 downto 0);
      s_axis_tstrb  : in  std_logic_vector(7 downto 0);
      s_axis_tlast  : in  std_logic
      );
  end component;

  component csi2_phy is
    port (
      csi2_dphy_byte_data_i     : in    std_logic_vector(63 downto 0);
      csi2_dphy_dt_i            : in    std_logic_vector(5 downto 0);
      csi2_dphy_vc_i            : in    std_logic_vector(1 downto 0);
      csi2_dphy_wc_i            : in    std_logic_vector(15 downto 0);
      csi2_dphy_byte_clk_o      : out   std_logic;
      csi2_dphy_byte_data_en_i  : in    std_logic;
      csi2_dphy_clk_hs_en_i     : in    std_logic;
      csi2_dphy_clk_n_o         : inout std_logic;
      csi2_dphy_clk_p_o         : inout std_logic;
      csi2_dphy_d0_n_io         : inout std_logic;
      csi2_dphy_d0_p_io         : inout std_logic;
      csi2_dphy_d1_n_o          : inout std_logic;
      csi2_dphy_d1_p_o          : inout std_logic;
      csi2_dphy_d2_n_o          : inout std_logic;
      csi2_dphy_d2_p_o          : inout std_logic;
      csi2_dphy_d3_n_o          : inout std_logic;
      csi2_dphy_d3_p_o          : inout std_logic;
      csi2_dphy_d_hs_en_i       : in    std_logic;
      csi2_dphy_d_hs_rdy_o      : out   std_logic;
      csi2_dphy_lp_en_i         : in    std_logic;
      csi2_dphy_pd_dphy_i       : in    std_logic;
      csi2_dphy_pix2byte_rstn_o : out   std_logic;
      csi2_dphy_pll_lock_o      : out   std_logic;
      csi2_dphy_ref_clk_i       : in    std_logic;
      csi2_dphy_reset_n_i       : in    std_logic;
      csi2_dphy_sp_en_i         : in    std_logic;
      csi2_dphy_tinit_done_o    : out   std_logic
      );
  end component;  -- sbp_module=true 

  constant FPGA_MANUFACTURER    : string  := "LATTICE";
  constant TOTAL_NUMBER_OF_LANE : integer := 24;
  constant MUX_RATIO            : integer := 4;
  constant WORD_SIZE            : integer := 12;
  constant PIXELS_PER_LINE      : integer := 1280;
  constant LINES_PER_FRAME      : integer := 960;

  signal m_axis_tready : std_logic;
  signal m_axis_tvalid : std_logic;
  signal m_axis_tdata  : std_logic_vector(63 downto 0);
  signal m_axis_tstrb  : std_logic_vector(7 downto 0);
  signal m_axis_tlast  : std_logic;

  signal s_axis_tready     : std_logic;
  signal s_axis_tvalid     : std_logic;
  signal s_axis_tdata      : std_logic_vector(63 downto 0);
  signal s_axis_tstrb      : std_logic_vector(7 downto 0);
  signal s_axis_tlast      : std_logic;
  signal sysrst            : std_logic;
  signal reg_read          : std_logic;                      -- Read
  signal reg_write         : std_logic;                      -- Write
  signal reg_addr          : std_logic_vector(7 downto 2);   -- Address
  signal reg_beN           : std_logic_vector(3 downto 0);   -- Byte enable
  signal reg_writedata     : std_logic_vector(31 downto 0);  -- Write data
  signal reg_readdatavalid : std_logic;                      -- Read data valid
  signal reg_readdata      : std_logic_vector(31 downto 0);  -- Read data



  signal csi2_dphy_byte_data_i     : std_logic_vector(63 downto 0);
  signal csi2_dphy_dt_i            : std_logic_vector(5 downto 0);
  signal csi2_dphy_vc_i            : std_logic_vector(1 downto 0);
  signal csi2_dphy_wc_i            : std_logic_vector(15 downto 0);
  signal csi2_dphy_byte_clk_o      : std_logic;
  signal csi2_dphy_byte_data_en_i  : std_logic;
  signal csi2_dphy_clk_hs_en_i     : std_logic;
  signal csi2_dphy_d_hs_en_i       : std_logic;
  signal csi2_dphy_d_hs_rdy_o      : std_logic;
  signal csi2_dphy_lp_en_i         : std_logic;
  signal csi2_dphy_pd_dphy_i       : std_logic;
  signal csi2_dphy_pix2byte_rstn_o : std_logic;
  signal csi2_dphy_pll_lock_o      : std_logic;
  signal csi2_dphy_ref_clk_i       : std_logic;
  signal csi2_dphy_reset_n_i       : std_logic;
  signal csi2_dphy_sp_en_i         : std_logic;
  signal csi2_dphy_tinit_done_o    : std_logic;




begin

  sysrst <= not sysrst_n;

  xhispi_top : hispi_top
    generic map(
      FPGA_MANUFACTURER    => FPGA_MANUFACTURER,
      NUMB_BLOCK           => NUMB_BLOCK,
      TOTAL_NUMBER_OF_LANE => TOTAL_NUMBER_OF_LANE,
      MUX_RATIO            => MUX_RATIO,
      LANE_PER_BLOCK       => LANE_PER_BLOCK,
      WORD_SIZE            => WORD_SIZE,
      PIXELS_PER_LINE      => PIXELS_PER_LINE,
      LINES_PER_FRAME      => LINES_PER_FRAME
      )
    port map(
      sysclk             => ref_clk,
      sysrst             => sysrst,
      reg_read           => reg_read,
      reg_write          => reg_write,
      reg_addr           => reg_addr(7 downto 2),
      reg_beN            => reg_beN,
      reg_writedata      => reg_writedata,
      reg_readdatavalid  => reg_readdatavalid,
      reg_readdata       => reg_readdata,
      hispi_serial_clk_p => hispi_serial_clk_p,
      hispi_serial_clk_n => hispi_serial_clk_n,
      hispi_data_p       => hispi_data_p,
      hispi_data_n       => hispi_data_n,
      m_axis_tready      => m_axis_tready,
      m_axis_tvalid      => m_axis_tvalid,
      m_axis_tdata       => m_axis_tdata,
      m_axis_tstrb       => m_axis_tstrb,
      m_axis_tlast       => m_axis_tlast,
      s_axis_tready      => s_axis_tready,
      s_axis_tvalid      => s_axis_tvalid,
      s_axis_tdata       => s_axis_tdata,
      s_axis_tstrb       => s_axis_tstrb,
      s_axis_tlast       => s_axis_tlast
      );

  m_axis_tready <= '1';

  csi2_dphy_byte_data_i    <= m_axis_tdata;
  csi2_dphy_byte_data_en_i <= m_axis_tvalid;
  csi2_dphy_dt_i           <= "000000";
  csi2_dphy_vc_i           <= "00";
  csi2_dphy_wc_i           <= "0000000000000000";
  csi2_dphy_clk_hs_en_i    <= '0';
  csi2_dphy_d_hs_en_i      <= '0';
  csi2_dphy_lp_en_i        <= '0';
  csi2_dphy_pd_dphy_i      <= '0';      -- No power down      
  csi2_dphy_sp_en_i        <= '1';

  s_axis_tvalid <= '0';
  s_axis_tdata  <= (others => '0');
  s_axis_tstrb  <= (others => '0');
  s_axis_tlast  <= '0';
  reg_read      <= '0';                 -- Read
  reg_write     <= '0';
  reg_addr      <= (others => '0');
  reg_beN       <= (others => '0');
  reg_writedata <= (others => '0');

-- csi2_dphy_byte_clk_o      
-- csi2_dphy_pll_lock_o      
-- csi2_dphy_tinit_done_o    
-- csi2_dphy_pix2byte_rstn_o 
-- csi2_dphy_d_hs_rdy_o      


  xlattice_ip : csi2_phy
    port map (
      csi2_dphy_byte_data_i     => csi2_dphy_byte_data_i,
      csi2_dphy_dt_i            => csi2_dphy_dt_i,
      csi2_dphy_vc_i            => csi2_dphy_vc_i,
      csi2_dphy_wc_i            => csi2_dphy_wc_i,
      csi2_dphy_byte_clk_o      => csi2_dphy_byte_clk_o,
      csi2_dphy_byte_data_en_i  => csi2_dphy_byte_data_en_i,
      csi2_dphy_clk_hs_en_i     => csi2_dphy_clk_hs_en_i,
      csi2_dphy_clk_n_o         => csi2_dphy_clk_n_o,
      csi2_dphy_clk_p_o         => csi2_dphy_clk_p_o,
      csi2_dphy_d0_n_io         => csi2_dphy_d0_n_io,
      csi2_dphy_d0_p_io         => csi2_dphy_d0_p_io,
      csi2_dphy_d1_n_o          => csi2_dphy_d1_n_o,
      csi2_dphy_d1_p_o          => csi2_dphy_d1_p_o,
      csi2_dphy_d2_n_o          => csi2_dphy_d2_n_o,
      csi2_dphy_d2_p_o          => csi2_dphy_d2_p_o,
      csi2_dphy_d3_n_o          => csi2_dphy_d3_n_o,
      csi2_dphy_d3_p_o          => csi2_dphy_d3_p_o,
      csi2_dphy_d_hs_en_i       => csi2_dphy_d_hs_en_i,
      csi2_dphy_d_hs_rdy_o      => csi2_dphy_d_hs_rdy_o,
      csi2_dphy_lp_en_i         => csi2_dphy_lp_en_i,
      csi2_dphy_pd_dphy_i       => csi2_dphy_pd_dphy_i,
      csi2_dphy_pix2byte_rstn_o => open,
      csi2_dphy_pll_lock_o      => open,
      csi2_dphy_ref_clk_i       => ref_clk,
      csi2_dphy_reset_n_i       => sysrst_n,
      csi2_dphy_sp_en_i         => csi2_dphy_sp_en_i,
      csi2_dphy_tinit_done_o    => open
      );

end struct;
