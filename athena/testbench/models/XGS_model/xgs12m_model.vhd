-- *********************************************************************
-- Copyright 2019, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--
-- *********************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.xgs_model_pkg.all;


entity xgs12m_model is
  generic(
    G_PXL_PER_COLRAM : integer := 174;
    G_PXL_ARRAY_ROWS : integer := 3100
    );
  port (
    SCLK        : in  std_logic;
    SDATA       : in  std_logic;
    TRIGGER_INT : in  std_logic := '0';
    RESET_B     : in  std_logic;
    FWSI_EN     : in  std_logic;
    CS          : in  std_logic;
    SDATAOUT    : out std_logic;

    ---------------------------------------------------------------------------
    -- Monitor
    ---------------------------------------------------------------------------
    MONITOR0 : out std_logic;
    MONITOR1 : out std_logic;
    MONITOR2 : out std_logic;

    ---------------------------------------------------------------------------
    -- Top HiSPI I/F
    ---------------------------------------------------------------------------
    hispi_io_clk_p  : out std_logic_vector(1 downto 0);
    hispi_io_clk_n  : out std_logic_vector(1 downto 0);
    hispi_io_data_p : out std_logic_vector(5 downto 0);
    hispi_io_data_n : out std_logic_vector(5 downto 0)
    );
end xgs12m_model;


architecture behaviour of xgs12m_model is


  component xgs12m_chip is
    generic(
      constant G_MODEL_ID       : std_logic_vector(15 downto 0) := X"0058";
      constant G_REV_ID         : std_logic_vector(15 downto 0) := X"0002";
      constant G_NUM_PHY        : integer                       := 6;
      constant G_PXL_PER_COLRAM : integer                       := 174;
      constant G_PXL_ARRAY_ROWS : integer                       := 3100
      );

    port (
      VAAHV_NPIX  : inout std_logic;
      VREF1_BOT_0 : inout std_logic;
      VREF1_BOT_1 : inout std_logic;
      VREF1_TOP_0 : inout std_logic;
      VREF1_TOP_1 : inout std_logic;
      ATEST_BTM   : inout std_logic;
      ATEST_TOP   : inout std_logic;
      ASPARE_TOP  : inout std_logic;
      ASPARE_BTM  : inout std_logic;

      VRESPD_HI_0  : inout std_logic;
      VRESPD_HI_1  : inout std_logic;
      VRESFD_HI_0  : inout std_logic;
      VRESFD_HI_1  : inout std_logic;
      VSG_HI_0     : inout std_logic;
      VSG_HI_1     : inout std_logic;
      VRS_HI_0     : inout std_logic;
      VRS_HI_1     : inout std_logic;
      VTX1_HI_0    : inout std_logic;
      VTX1_HI_1    : inout std_logic;
      VTX0_HI_0    : inout std_logic;
      VTX0_HI_1    : inout std_logic;
      VRESFD_LO1_0 : inout std_logic;
      VRESFD_LO1_1 : inout std_logic;
      VRESFD_LO2_0 : inout std_logic;
      VRESFD_LO2_1 : inout std_logic;
      VRESPD_LO1_0 : inout std_logic;
      VRESPD_LO1_1 : inout std_logic;
      VSG_LO1_0    : inout std_logic;
      VSG_LO1_1    : inout std_logic;
      VTX1_LO1_0   : inout std_logic;
      VTX1_LO1_1   : inout std_logic;
      VTX1_LO2_0   : inout std_logic;
      VTX1_LO2_1   : inout std_logic;
      VTX0_LO1_0   : inout std_logic;
      VTX0_LO1_1   : inout std_logic;
      VPSUB_LO_0   : inout std_logic;
      VPSUB_LO_1   : inout std_logic;

      SCLK        : in  std_logic;
      SDATA       : in  std_logic;
      TRIGGER_INT : in  std_logic := '0';
      TEST        : in  std_logic;
      RESET_B     : in  std_logic;
      EXTCLK      : in  std_logic;
      FWSI_EN     : in  std_logic;
      CS          : in  std_logic;
      SDATAOUT    : out std_logic;

      DSPARE0 : inout std_logic;
      DSPARE1 : inout std_logic;
      DSPARE2 : inout std_logic;

      MONITOR0 : inout std_logic;
      MONITOR1 : inout std_logic;
      MONITOR2 : inout std_logic;

      D_CLK_0_N : out std_logic;
      D_CLK_0_P : out std_logic;
      D_CLK_1_N : out std_logic;
      D_CLK_1_P : out std_logic;
      D_CLK_2_N : out std_logic;
      D_CLK_2_P : out std_logic;
      D_CLK_3_N : out std_logic;
      D_CLK_3_P : out std_logic;
      D_CLK_4_N : out std_logic;
      D_CLK_4_P : out std_logic;
      D_CLK_5_N : out std_logic;
      D_CLK_5_P : out std_logic;
      DATA_2_N  : out std_logic;
      DATA_2_P  : out std_logic;
      DATA_0_N  : out std_logic;
      DATA_0_P  : out std_logic;
      DATA_1_P  : out std_logic;
      DATA_1_N  : out std_logic;
      DATA_3_P  : out std_logic;
      DATA_3_N  : out std_logic;
      DATA_4_N  : out std_logic;
      DATA_4_P  : out std_logic;
      DATA_5_N  : out std_logic;
      DATA_5_P  : out std_logic;
      DATA_6_N  : out std_logic;
      DATA_6_P  : out std_logic;
      DATA_7_N  : out std_logic;
      DATA_7_P  : out std_logic;
      DATA_8_N  : out std_logic;
      DATA_8_P  : out std_logic;
      DATA_9_N  : out std_logic;
      DATA_9_P  : out std_logic;
      DATA_10_N : out std_logic;
      DATA_10_P : out std_logic;
      DATA_11_N : out std_logic;
      DATA_11_P : out std_logic;
      DATA_12_N : out std_logic;
      DATA_12_P : out std_logic;
      DATA_13_N : out std_logic;
      DATA_13_P : out std_logic;
      DATA_14_N : out std_logic;
      DATA_14_P : out std_logic;
      DATA_15_N : out std_logic;
      DATA_15_P : out std_logic;
      DATA_16_N : out std_logic;
      DATA_16_P : out std_logic;
      DATA_17_N : out std_logic;
      DATA_17_P : out std_logic;
      DATA_18_N : out std_logic;
      DATA_18_P : out std_logic;
      DATA_19_N : out std_logic;
      DATA_19_P : out std_logic;
      DATA_20_N : out std_logic;
      DATA_20_P : out std_logic;
      DATA_21_N : out std_logic;
      DATA_21_P : out std_logic;
      DATA_22_N : out std_logic;
      DATA_22_P : out std_logic;
      DATA_23_N : out std_logic;
      DATA_23_P : out std_logic
      );
  end component;


  constant G_MODEL_ID : std_logic_vector(15 downto 0) := X"0058";
  constant G_REV_ID   : std_logic_vector(15 downto 0) := X"0002";

  signal ref_clk : std_logic := '0';
  signal monitor_bus : std_logic_vector(2 downto 0);

begin

  ref_clk <= not ref_clk after 15.432 ns;

  -- Monitor bus remapping
  MONITOR0 <= monitor_bus(0);
  MONITOR1 <= monitor_bus(1);
  MONITOR2 <= monitor_bus(2);
 
  inst_xgs12m_chip : xgs12m_chip
    generic map(
      G_MODEL_ID       => G_MODEL_ID,
      G_REV_ID         => G_REV_ID,
      G_NUM_PHY        => 6,
      G_PXL_PER_COLRAM => G_PXL_PER_COLRAM,
      G_PXL_ARRAY_ROWS => G_PXL_ARRAY_ROWS
      )
    port map(
      VAAHV_NPIX  => open,
      VREF1_BOT_0 => open,
      VREF1_BOT_1 => open,
      VREF1_TOP_0 => open,
      VREF1_TOP_1 => open,
      ATEST_BTM   => open,
      ATEST_TOP   => open,
      ASPARE_TOP  => open,
      ASPARE_BTM  => open,

      VRESPD_HI_0  => open,
      VRESPD_HI_1  => open,
      VRESFD_HI_0  => open,
      VRESFD_HI_1  => open,
      VSG_HI_0     => open,
      VSG_HI_1     => open,
      VRS_HI_0     => open,
      VRS_HI_1     => open,
      VTX1_HI_0    => open,
      VTX1_HI_1    => open,
      VTX0_HI_0    => open,
      VTX0_HI_1    => open,
      VRESFD_LO1_0 => open,
      VRESFD_LO1_1 => open,
      VRESFD_LO2_0 => open,
      VRESFD_LO2_1 => open,
      VRESPD_LO1_0 => open,
      VRESPD_LO1_1 => open,
      VSG_LO1_0    => open,
      VSG_LO1_1    => open,
      VTX1_LO1_0   => open,
      VTX1_LO1_1   => open,
      VTX1_LO2_0   => open,
      VTX1_LO2_1   => open,
      VTX0_LO1_0   => open,
      VTX0_LO1_1   => open,
      VPSUB_LO_0   => open,
      VPSUB_LO_1   => open,

      SCLK        => SCLK,
      SDATA       => SDATA,
      TRIGGER_INT => TRIGGER_INT,
      TEST        => '0',
      RESET_B     => RESET_B,
      EXTCLK      => ref_clk,
      FWSI_EN     => FWSI_EN,
      CS          => CS,
      SDATAOUT    => SDATAOUT,

      DSPARE0 => open,
      DSPARE1 => open,
      DSPARE2 => open,

      MONITOR0 => monitor_bus(0),
      MONITOR1 => monitor_bus(1),
      MONITOR2 => monitor_bus(2),

      D_CLK_0_N => open,
      D_CLK_0_P => open,

      D_CLK_1_N => open,
      D_CLK_1_P => open,

      D_CLK_2_N => hispi_io_clk_n(0),
      D_CLK_2_P => hispi_io_clk_p(0),

      D_CLK_3_N => hispi_io_clk_n(1),
      D_CLK_3_P => hispi_io_clk_p(1),

      D_CLK_4_N => open,
      D_CLK_4_P => open,

      D_CLK_5_N => open,
      D_CLK_5_P => open,

      DATA_0_N => hispi_io_data_n(0),
      DATA_0_P => hispi_io_data_p(0),

      DATA_1_N => hispi_io_data_n(1),
      DATA_1_P => hispi_io_data_p(1),

      DATA_2_N => open,
      DATA_2_P => open,

      DATA_3_N => open,
      DATA_3_P => open,

      DATA_4_N => open,
      DATA_4_P => open,

      DATA_5_N => open,
      DATA_5_P => open,

      DATA_6_N => open,
      DATA_6_P => open,

      DATA_7_N => open,
      DATA_7_P => open,

      DATA_8_N => hispi_io_data_n(2),
      DATA_8_P => hispi_io_data_p(2),

      DATA_9_N => hispi_io_data_n(3),
      DATA_9_P => hispi_io_data_p(3),

      DATA_10_N => open,
      DATA_10_P => open,

      DATA_11_N => open,
      DATA_11_P => open,

      DATA_12_N => open,
      DATA_12_P => open,

      DATA_13_N => open,
      DATA_13_P => open,

      DATA_14_N => open,
      DATA_14_P => open,

      DATA_15_N => open,
      DATA_15_P => open,

      DATA_16_N => hispi_io_data_n(4),
      DATA_16_P => hispi_io_data_p(4),

      DATA_17_N => hispi_io_data_n(5),
      DATA_17_P => hispi_io_data_p(5),

      DATA_18_N => open,
      DATA_18_P => open,

      DATA_19_N => open,
      DATA_19_P => open,

      DATA_20_N => open,
      DATA_20_P => open,

      DATA_21_N => open,
      DATA_21_P => open,

      DATA_22_N => open,
      DATA_22_P => open,

      DATA_23_N => open,
      DATA_23_P => open
      );

end behaviour;
