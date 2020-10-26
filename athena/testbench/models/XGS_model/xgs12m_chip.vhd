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

entity xgs12m_chip is
  generic(
    constant G_MODEL_ID       : std_logic_vector(15 downto 0) := X"0058";
    constant G_REV_ID         : std_logic_vector(15 downto 0) := X"0002";
    constant G_NUM_PHY        : integer                       := 6;
    constant G_PXL_PER_COLRAM : integer                       := 174;
    constant G_PXL_ARRAY_ROWS : integer                       := 3100
    );

  port (
  
    xgs_model_GenImage : in std_logic;
	
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
end xgs12m_chip;

architecture behaviour of xgs12m_chip is

  component xgs_hispi is
    generic(G_PXL_PER_COLRAM : integer := 174);
    port(
      bit_clock_period : in time;

      TRIGGER_READOUT : in std_logic;

      hispi_if_enable     : in std_logic;
      output_msb_first    : in std_logic;
      hispi_enable_crc    : in std_logic;
      hispi_standby_state : in std_logic;
      hispi_mux_sel       : in std_logic_vector(1 downto 0);
      vert_left_bar_en    : in std_logic;
      hispi_pixel_depth   : in std_logic_vector(2 downto 0);  --0x4 = 10bit and 0x5 = 12bit
      blanking_data       : in std_logic_vector(11 downto 0);

      dataline       : in  t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
      emb_data       : in  std_logic;
      first_line     : in  std_logic;   --indicates first line of a frame
      last_line      : in  std_logic;   --indicates last line of a frame
      dataline_valid : in  std_logic;
      dataline_nxt   : out std_logic;

      line_time : in std_logic_vector(15 downto 0);

      D_CLK_N  : out std_logic;
      D_CLK_P  : out std_logic;
      DATA_0_N : out std_logic;
      DATA_0_P : out std_logic;
      DATA_1_N : out std_logic;
      DATA_1_P : out std_logic;
      DATA_2_N : out std_logic;
      DATA_2_P : out std_logic;
      DATA_3_N : out std_logic;
      DATA_3_P : out std_logic
      );

  end component;

  component xgs_spi_i2c is
    port(
      reg_addr    : out std_logic_vector(14 downto 0);
      reg_wr      : out std_logic;
      reg_wr_data : out std_logic_vector(15 downto 0);
      reg_rd_data : in  std_logic_vector(15 downto 0);

      SCLK     : in  std_logic;
      SDATA    : in  std_logic;
      FWSI_EN  : in  std_logic;
      CS       : in  std_logic;
      SDATAOUT : out std_logic
      );
  end component;

  component xgs_sensor_config is
    generic(G_MODEL_ID       : std_logic_vector(15 downto 0) := X"0058";
            G_REV_ID         : std_logic_vector(15 downto 0) := X"0002";
            G_PXL_ARRAY_ROWS : integer                       := 3072);
    port(
      RESET_B : in std_logic;
      EXTCLK  : in std_logic;

      --Register interface
      reg_addr    : in  std_logic_vector(14 downto 0);
      reg_wr      : in  std_logic;
      reg_wr_data : in  std_logic_vector(15 downto 0);
      reg_rd_data : out std_logic_vector(15 downto 0);

      --Output to HiSPi module
      bit_clock_period : out time;

      sensor_fsm_state : out std_logic_vector(4 downto 0);

      hispi_if_enable     : out std_logic;
      output_msb_first    : out std_logic;
      hispi_enable_crc    : out std_logic;
      hispi_standby_state : out std_logic;
      hispi_mux_sel       : out std_logic_vector(1 downto 0);
      vert_left_bar_en    : out std_logic;
      hispi_pixel_depth   : out std_logic_vector(2 downto 0);  --0x4 = 10bit and 0x5 = 12bit
      blanking_data       : out std_logic_vector(11 downto 0);

      line_time : out std_logic_vector(15 downto 0);

      --Output to Image module
      slave_triggered_mode : out std_logic;
      frame_length         : out std_logic_vector(15 downto 0);
      roi_start            : out integer range G_PXL_ARRAY_ROWS downto 0;
      roi_size             : out integer range G_PXL_ARRAY_ROWS downto 0;
      ext_emb_data         : out std_logic;
      cmc_patgen_en        : out std_logic;
      active_ctxt          : out std_logic_vector(2 downto 0);
      nested_readout       : out std_logic;
      x_subsampling        : out std_logic;
      y_subsampling        : out std_logic;
      y_reversed           : out std_logic;
      swap_top_bottom      : out std_logic;
      sequencer_enable     : out std_logic;
      frame_count          : in  std_logic_vector(7 downto 0);
      test_pattern_mode    : out std_logic_vector(2 downto 0);
      test_data_red        : out std_logic_vector(12 downto 0);
      test_data_greenr     : out std_logic_vector(12 downto 0);
      test_data_blue       : out std_logic_vector(12 downto 0);
      test_data_greenb     : out std_logic_vector(12 downto 0)

      );
  end component;

  component xgs_image is
    generic(G_XGS45M         : integer := 0;
            G_NUM_PHY        : integer := 6;
            G_PXL_ARRAY_ROWS : integer := 3100;
            G_PXL_PER_COLRAM : integer := 174
            );
    port(
      xgs_model_GenImage : in std_logic;

	  trigger_int : in std_logic;

      dataline       : out t_dataline(0 to G_NUM_PHY*4*G_PXL_PER_COLRAM-1);
      emb_data       : out std_logic;
      first_line     : out std_logic;   --indicates first line of a frame
      last_line      : out std_logic;   --indicates last line of a frame
      dataline_valid : out std_logic;
      dataline_nxt   : in  std_logic;

      frame_length         : in  std_logic_vector(15 downto 0);
      roi_start            : in  integer range G_PXL_ARRAY_ROWS downto 0;
      roi_size             : in  integer range G_PXL_ARRAY_ROWS downto 0;
      ext_emb_data         : in  std_logic;
      cmc_patgen_en        : in  std_logic;
      active_ctxt          : in  std_logic_vector(2 downto 0);
      nested_readout       : in  std_logic;
      x_subsampling        : in  std_logic;
      y_subsampling        : in  std_logic;
      y_reversed           : in  std_logic;
      swap_top_bottom      : in  std_logic;
      sequencer_enable     : in  std_logic;
      slave_triggered_mode : in  std_logic;
      frame_count          : out std_logic_vector(7 downto 0);

      test_pattern_mode : in std_logic_vector(2 downto 0);
      test_data_red     : in std_logic_vector(12 downto 0);
      test_data_greenr  : in std_logic_vector(12 downto 0);
      test_data_blue    : in std_logic_vector(12 downto 0);
      test_data_greenb  : in std_logic_vector(12 downto 0)

      );
  end component;


  signal reg_addr    : std_logic_vector(14 downto 0);
  signal reg_wr      : std_logic;
  signal reg_wr_data : std_logic_vector(15 downto 0);
  signal reg_rd_data : std_logic_vector(15 downto 0);

  signal bit_clock_period : time := 1.2857 ns;

  signal sensor_fsm_state : std_logic_vector(4 downto 0);

  signal hispi_if_enable     : std_logic;
  signal output_msb_first    : std_logic;
  signal hispi_enable_crc    : std_logic;
  signal hispi_standby_state : std_logic;
  signal hispi_mux_sel       : std_logic_vector(1 downto 0);
  signal vert_left_bar_en    : std_logic;
  signal hispi_pixel_depth   : std_logic_vector(2 downto 0);
  signal blanking_data       : std_logic_vector(11 downto 0);

  signal dataline       : t_dataline(0 to G_NUM_PHY*4*G_PXL_PER_COLRAM-1);
  signal dataline0      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal dataline1      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal dataline2      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal dataline3      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal dataline4      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal dataline5      : t_dataline(0 to 4*G_PXL_PER_COLRAM-1);
  signal emb_data       : std_logic;
  signal first_line     : std_logic;    --indicates first line of a frame
  signal last_line      : std_logic;    --indicates last line of a frame
  signal dataline_valid : std_logic;
  signal dataline_nxt   : std_logic;

  signal line_time : std_logic_vector(15 downto 0);

  signal line_number          : integer;
  signal slave_triggered_mode : std_logic;

  signal frame_length    : std_logic_vector(15 downto 0);
  signal frame_length_DB : std_logic_vector(15 downto 0);
  signal roi_size        : integer range G_PXL_ARRAY_ROWS downto 0;
  signal roi_size_DB     : integer range G_PXL_ARRAY_ROWS downto 0;
  signal roi_start       : integer range G_PXL_ARRAY_ROWS downto 0;
  signal roi_start_DB    : integer range G_PXL_ARRAY_ROWS downto 0;


  signal ext_emb_data      : std_logic;
  signal cmc_patgen_en     : std_logic;
  signal active_ctxt       : std_logic_vector(2 downto 0);
  signal nested_readout    : std_logic;
  signal x_subsampling     : std_logic;
  signal y_subsampling     : std_logic;
  signal x_subsampling_DB  : std_logic;
  signal y_subsampling_DB  : std_logic;

  signal y_reversed        : std_logic;
  signal swap_top_bottom   : std_logic;
  signal sequencer_enable  : std_logic;
  signal frame_count       : std_logic_vector(7 downto 0);
  signal test_pattern_mode : std_logic_vector(2 downto 0);
  signal test_data_red     : std_logic_vector(12 downto 0);
  signal test_data_greenr  : std_logic_vector(12 downto 0);
  signal test_data_blue    : std_logic_vector(12 downto 0);
  signal test_data_greenb  : std_logic_vector(12 downto 0);


  signal SFOT            : std_logic := '0';
  signal INTEGRATION     : std_logic := '0';
  signal EFOT            : std_logic := '0';
  signal TRIGGER_READOUT : std_logic := '0';

  signal NEW_LINE            : std_logic := '0';

begin


--split in major behavioural blocks
--1/ HiSPi PHY - implement 4 lanes per PHY 
--             - include mux modes
--             - blanking value 
--             - linetime (generate error if it lower than the number of pixels to be sent for a single line)
--             - phy_enable / phy_standby_mode
--             - hispi bit clock period
--             - pixel bit size (10bit or 12bit)
--2/ Data path - generates lines with pixel data either from test pattern or from input file
--3/ Sensor config - implements model for SPI/I2C and register access.
--                 - implement power-up and reset
--                 - include PLL and clock reset generation
--                 - include sequencer control


  xgs_spi_i2c_inst : xgs_spi_i2c
    port map(
      reg_addr    => reg_addr,
      reg_wr      => reg_wr,
      reg_wr_data => reg_wr_data,
      reg_rd_data => reg_rd_data,

      SCLK     => SCLK,
      SDATA    => SDATA,
      FWSI_EN  => FWSI_EN,
      CS       => CS,
      SDATAOUT => SDATAOUT
      );

  xgs_sensor_config_inst : xgs_sensor_config
    generic map(G_MODEL_ID       => G_MODEL_ID,
                G_REV_ID         => G_REV_ID,
                G_PXL_ARRAY_ROWS => G_PXL_ARRAY_ROWS)
    port map(
      RESET_B => RESET_B,
      EXTCLK  => EXTCLK,

      --Register interface
      reg_addr    => reg_addr,
      reg_wr      => reg_wr,
      reg_wr_data => reg_wr_data,
      reg_rd_data => reg_rd_data,

      --Output to HiSPi module
      bit_clock_period => bit_clock_period,

      sensor_fsm_state => sensor_fsm_state,

      hispi_if_enable     => hispi_if_enable,
      output_msb_first    => output_msb_first,
      hispi_enable_crc    => hispi_enable_crc,
      hispi_standby_state => hispi_standby_state,
      hispi_mux_sel       => hispi_mux_sel,
      vert_left_bar_en    => vert_left_bar_en,
      hispi_pixel_depth   => hispi_pixel_depth,
      blanking_data       => blanking_data,

      line_time => line_time,

      --Output to Image module
      slave_triggered_mode => slave_triggered_mode,
      frame_length         => frame_length,
      roi_start            => roi_start,
      roi_size             => roi_size,
      ext_emb_data         => ext_emb_data,
      cmc_patgen_en        => cmc_patgen_en,
      active_ctxt          => active_ctxt,
      nested_readout       => nested_readout,
      x_subsampling        => x_subsampling,
      y_subsampling        => y_subsampling,
      y_reversed           => y_reversed,
      swap_top_bottom      => swap_top_bottom,
      sequencer_enable     => sequencer_enable,
      frame_count          => frame_count,
      test_pattern_mode    => test_pattern_mode,
      test_data_red        => test_data_red,
      test_data_greenr     => test_data_greenr,
      test_data_blue       => test_data_blue,
      test_data_greenb     => test_data_greenb
      );

  xgs_image_inst : xgs_image
    generic map(G_XGS45M         => 0,
                G_NUM_PHY        => G_NUM_PHY,
                G_PXL_ARRAY_ROWS => G_PXL_ARRAY_ROWS,
                G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
    port map(
	
	  xgs_model_GenImage => xgs_model_GenImage,

      trigger_int     => TRIGGER_READOUT,

      dataline        => dataline,
      emb_data        => emb_data,
      first_line      => first_line,
      last_line       => last_line,
      dataline_valid  => dataline_valid,
      dataline_nxt    => dataline_nxt,
      frame_length    => frame_length_DB,
      roi_start       => roi_start_DB,
      roi_size        => roi_size_DB,
      ext_emb_data    => ext_emb_data,
      cmc_patgen_en   => cmc_patgen_en,
      active_ctxt     => active_ctxt,
      nested_readout  => nested_readout,
      x_subsampling   => x_subsampling_DB,
      y_subsampling   => y_subsampling_DB,
      y_reversed      => y_reversed,
      swap_top_bottom => swap_top_bottom,

      sequencer_enable     => sequencer_enable,
      slave_triggered_mode => slave_triggered_mode,
      frame_count          => frame_count,

      test_pattern_mode => test_pattern_mode,
      test_data_red     => test_data_red,
      test_data_greenr  => test_data_greenr,
      test_data_blue    => test_data_blue,
      test_data_greenb  => test_data_greenb
      );

  GEN_12M_dataline : if G_NUM_PHY = 6 generate
    dataline0(0 to G_PXL_PER_COLRAM-1)                    <= dataline(0 to G_PXL_PER_COLRAM-1);
    dataline0(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1);
    dataline0(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(4*G_PXL_PER_COLRAM to 5*G_PXL_PER_COLRAM-1);
    dataline0(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(6*G_PXL_PER_COLRAM to 7*G_PXL_PER_COLRAM-1);

    dataline1(0 to G_PXL_PER_COLRAM-1)                    <= dataline(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1);
    dataline1(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1);
    dataline1(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(5*G_PXL_PER_COLRAM to 6*G_PXL_PER_COLRAM-1);
    dataline1(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(7*G_PXL_PER_COLRAM to 8*G_PXL_PER_COLRAM-1);

    dataline2(0 to G_PXL_PER_COLRAM-1)                    <= dataline(8*G_PXL_PER_COLRAM to 9*G_PXL_PER_COLRAM-1);
    dataline2(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(10*G_PXL_PER_COLRAM to 11*G_PXL_PER_COLRAM-1);
    dataline2(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(12*G_PXL_PER_COLRAM to 13*G_PXL_PER_COLRAM-1);
    dataline2(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(14*G_PXL_PER_COLRAM to 15*G_PXL_PER_COLRAM-1);

    dataline3(0 to G_PXL_PER_COLRAM-1)                    <= dataline(9*G_PXL_PER_COLRAM to 10*G_PXL_PER_COLRAM-1);
    dataline3(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(11*G_PXL_PER_COLRAM to 12*G_PXL_PER_COLRAM-1);
    dataline3(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(13*G_PXL_PER_COLRAM to 14*G_PXL_PER_COLRAM-1);
    dataline3(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(15*G_PXL_PER_COLRAM to 16*G_PXL_PER_COLRAM-1);

    dataline4(0 to G_PXL_PER_COLRAM-1)                    <= dataline(16*G_PXL_PER_COLRAM to 17*G_PXL_PER_COLRAM-1);
    dataline4(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(18*G_PXL_PER_COLRAM to 19*G_PXL_PER_COLRAM-1);
    dataline4(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(20*G_PXL_PER_COLRAM to 21*G_PXL_PER_COLRAM-1);
    dataline4(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(22*G_PXL_PER_COLRAM to 23*G_PXL_PER_COLRAM-1);

    dataline5(0 to G_PXL_PER_COLRAM-1)                    <= dataline(17*G_PXL_PER_COLRAM to 18*G_PXL_PER_COLRAM-1);
    dataline5(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(19*G_PXL_PER_COLRAM to 20*G_PXL_PER_COLRAM-1);
    dataline5(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(21*G_PXL_PER_COLRAM to 22*G_PXL_PER_COLRAM-1);
    dataline5(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(23*G_PXL_PER_COLRAM to 24*G_PXL_PER_COLRAM-1);
  end generate GEN_12M_dataline;



  GEN_5M_dataline : if G_NUM_PHY = 4 generate
    dataline0(0 to G_PXL_PER_COLRAM-1)                    <= dataline(0 to G_PXL_PER_COLRAM-1);
    dataline0(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1);
    dataline0(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(4*G_PXL_PER_COLRAM to 5*G_PXL_PER_COLRAM-1);
    dataline0(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(6*G_PXL_PER_COLRAM to 7*G_PXL_PER_COLRAM-1);

    dataline1(0 to G_PXL_PER_COLRAM-1)                    <= dataline(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1);
    dataline1(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1);
    dataline1(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(5*G_PXL_PER_COLRAM to 6*G_PXL_PER_COLRAM-1);
    dataline1(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(7*G_PXL_PER_COLRAM to 8*G_PXL_PER_COLRAM-1);

    dataline2(0 to G_PXL_PER_COLRAM-1)                    <= dataline(8*G_PXL_PER_COLRAM to 9*G_PXL_PER_COLRAM-1);
    dataline2(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(10*G_PXL_PER_COLRAM to 11*G_PXL_PER_COLRAM-1);
    dataline2(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(12*G_PXL_PER_COLRAM to 13*G_PXL_PER_COLRAM-1);
    dataline2(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(14*G_PXL_PER_COLRAM to 15*G_PXL_PER_COLRAM-1);

    dataline3(0 to G_PXL_PER_COLRAM-1)                    <= dataline(9*G_PXL_PER_COLRAM to 10*G_PXL_PER_COLRAM-1);
    dataline3(G_PXL_PER_COLRAM to 2*G_PXL_PER_COLRAM-1)   <= dataline(11*G_PXL_PER_COLRAM to 12*G_PXL_PER_COLRAM-1);
    dataline3(2*G_PXL_PER_COLRAM to 3*G_PXL_PER_COLRAM-1) <= dataline(13*G_PXL_PER_COLRAM to 14*G_PXL_PER_COLRAM-1);
    dataline3(3*G_PXL_PER_COLRAM to 4*G_PXL_PER_COLRAM-1) <= dataline(15*G_PXL_PER_COLRAM to 16*G_PXL_PER_COLRAM-1);

  end generate GEN_5M_dataline;






  xgs_hispi_0_inst : xgs_hispi
    generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
    port map(
      bit_clock_period => bit_clock_period,

      TRIGGER_READOUT => TRIGGER_READOUT,

      hispi_if_enable     => hispi_if_enable,
      output_msb_first    => output_msb_first,
      hispi_enable_crc    => hispi_enable_crc,
      hispi_standby_state => hispi_standby_state,
      hispi_mux_sel       => hispi_mux_sel,
      vert_left_bar_en    => vert_left_bar_en,
      hispi_pixel_depth   => hispi_pixel_depth,
      blanking_data       => blanking_data,

      dataline       => dataline0,
      emb_data       => emb_data,
      first_line     => first_line,
      last_line      => last_line,
      dataline_valid => dataline_valid,
      dataline_nxt   => dataline_nxt,

      line_time => line_time,

      D_CLK_N  => D_CLK_0_N,
      D_CLK_P  => D_CLK_0_P,
      DATA_0_N => DATA_0_N,
      DATA_0_P => DATA_0_P,
      DATA_1_N => DATA_2_N,
      DATA_1_P => DATA_2_P,
      DATA_2_N => DATA_4_N,
      DATA_2_P => DATA_4_P,
      DATA_3_N => DATA_6_N,
      DATA_3_P => DATA_6_P
      );

  xgs_hispi_1_inst : xgs_hispi
    generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
    port map(
      bit_clock_period => bit_clock_period,

      TRIGGER_READOUT => TRIGGER_READOUT,

      hispi_if_enable     => hispi_if_enable,
      output_msb_first    => output_msb_first,
      hispi_enable_crc    => hispi_enable_crc,
      hispi_standby_state => hispi_standby_state,
      hispi_mux_sel       => hispi_mux_sel,
      vert_left_bar_en    => vert_left_bar_en,
      hispi_pixel_depth   => hispi_pixel_depth,
      blanking_data       => blanking_data,

      dataline       => dataline1,
      emb_data       => emb_data,
      first_line     => first_line,
      last_line      => last_line,
      dataline_valid => dataline_valid,
      dataline_nxt   => dataline_nxt,

      line_time => line_time,

      D_CLK_N  => D_CLK_1_N,
      D_CLK_P  => D_CLK_1_P,
      DATA_0_N => DATA_1_N,
      DATA_0_P => DATA_1_P,
      DATA_1_N => DATA_3_N,
      DATA_1_P => DATA_3_P,
      DATA_2_N => DATA_5_N,
      DATA_2_P => DATA_5_P,
      DATA_3_N => DATA_7_N,
      DATA_3_P => DATA_7_P
      );

  xgs_hispi_2_inst : xgs_hispi
    generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
    port map(
      bit_clock_period => bit_clock_period,

      TRIGGER_READOUT => TRIGGER_READOUT,

      hispi_if_enable     => hispi_if_enable,
      output_msb_first    => output_msb_first,
      hispi_enable_crc    => hispi_enable_crc,
      hispi_standby_state => hispi_standby_state,
      hispi_mux_sel       => hispi_mux_sel,
      vert_left_bar_en    => vert_left_bar_en,
      hispi_pixel_depth   => hispi_pixel_depth,
      blanking_data       => blanking_data,

      dataline       => dataline2,
      emb_data       => emb_data,
      first_line     => first_line,
      last_line      => last_line,
      dataline_valid => dataline_valid,
      dataline_nxt   => dataline_nxt,

      line_time => line_time,

      D_CLK_N  => D_CLK_2_N,
      D_CLK_P  => D_CLK_2_P,
      DATA_0_N => DATA_8_N,
      DATA_0_P => DATA_8_P,
      DATA_1_N => DATA_10_N,
      DATA_1_P => DATA_10_P,
      DATA_2_N => DATA_12_N,
      DATA_2_P => DATA_12_P,
      DATA_3_N => DATA_14_N,
      DATA_3_P => DATA_14_P
      );

  xgs_hispi_3_inst : xgs_hispi
    generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
    port map(
      bit_clock_period => bit_clock_period,

      TRIGGER_READOUT => TRIGGER_READOUT,

      hispi_if_enable     => hispi_if_enable,
      output_msb_first    => output_msb_first,
      hispi_enable_crc    => hispi_enable_crc,
      hispi_standby_state => hispi_standby_state,
      hispi_mux_sel       => hispi_mux_sel,
      vert_left_bar_en    => vert_left_bar_en,
      hispi_pixel_depth   => hispi_pixel_depth,
      blanking_data       => blanking_data,

      dataline       => dataline3,
      emb_data       => emb_data,
      first_line     => first_line,
      last_line      => last_line,
      dataline_valid => dataline_valid,
      dataline_nxt   => dataline_nxt,

      line_time => line_time,

      D_CLK_N  => D_CLK_3_N,
      D_CLK_P  => D_CLK_3_P,
      DATA_0_N => DATA_9_N,
      DATA_0_P => DATA_9_P,
      DATA_1_N => DATA_11_N,
      DATA_1_P => DATA_11_P,
      DATA_2_N => DATA_13_N,
      DATA_2_P => DATA_13_P,
      DATA_3_N => DATA_15_N,
      DATA_3_P => DATA_15_P
      );


  GEN_12M_xgs_hiSpi : if G_NUM_PHY = 6 generate
    xgs_hispi_4_inst : xgs_hispi
      generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
      port map(
        bit_clock_period => bit_clock_period,

        TRIGGER_READOUT => TRIGGER_READOUT,

        hispi_if_enable     => hispi_if_enable,
        output_msb_first    => output_msb_first,
        hispi_enable_crc    => hispi_enable_crc,
        hispi_standby_state => hispi_standby_state,
        hispi_mux_sel       => hispi_mux_sel,
        vert_left_bar_en    => vert_left_bar_en,
        hispi_pixel_depth   => hispi_pixel_depth,
        blanking_data       => blanking_data,

        dataline       => dataline4,
        emb_data       => emb_data,
        first_line     => first_line,
        last_line      => last_line,
        dataline_valid => dataline_valid,
        dataline_nxt   => dataline_nxt,

        line_time => line_time,

        D_CLK_N  => D_CLK_4_N,
        D_CLK_P  => D_CLK_4_P,
        DATA_0_N => DATA_16_N,
        DATA_0_P => DATA_16_P,
        DATA_1_N => DATA_18_N,
        DATA_1_P => DATA_18_P,
        DATA_2_N => DATA_20_N,
        DATA_2_P => DATA_20_P,
        DATA_3_N => DATA_22_N,
        DATA_3_P => DATA_22_P
        );


    xgs_hispi_5_inst : xgs_hispi
      generic map(G_PXL_PER_COLRAM => G_PXL_PER_COLRAM)
      port map(
        bit_clock_period => bit_clock_period,

        TRIGGER_READOUT => TRIGGER_READOUT,

        hispi_if_enable     => hispi_if_enable,
        output_msb_first    => output_msb_first,
        hispi_enable_crc    => hispi_enable_crc,
        hispi_standby_state => hispi_standby_state,
        hispi_mux_sel       => hispi_mux_sel,
        vert_left_bar_en    => vert_left_bar_en,
        hispi_pixel_depth   => hispi_pixel_depth,
        blanking_data       => blanking_data,

        dataline       => dataline5,
        emb_data       => emb_data,
        first_line     => first_line,
        last_line      => last_line,
        dataline_valid => dataline_valid,
        dataline_nxt   => dataline_nxt,

        line_time => line_time,

        D_CLK_N  => D_CLK_5_N,
        D_CLK_P  => D_CLK_5_P,
        DATA_0_N => DATA_17_N,
        DATA_0_P => DATA_17_P,
        DATA_1_N => DATA_19_N,
        DATA_1_P => DATA_19_P,
        DATA_2_N => DATA_21_N,
        DATA_2_P => DATA_21_P,
        DATA_3_N => DATA_23_N,
        DATA_3_P => DATA_23_P
        );
  end generate;


  GEN_5M_xgs_hiSpi : if G_NUM_PHY = 4 generate
    D_CLK_4_N <= 'X';
    D_CLK_4_P <= 'X';
    DATA_16_N <= 'X';
    DATA_16_P <= 'X';
    DATA_18_N <= 'X';
    DATA_18_P <= 'X';
    DATA_20_N <= 'X';
    DATA_20_P <= 'X';
    DATA_22_N <= 'X';
    DATA_22_P <= 'X';

    D_CLK_5_N <= 'X';
    D_CLK_5_P <= 'X';
    DATA_17_N <= 'X';
    DATA_17_P <= 'X';
    DATA_19_N <= 'X';
    DATA_19_P <= 'X';
    DATA_21_N <= 'X';
    DATA_21_P <= 'X';
    DATA_23_N <= 'X';
    DATA_23_P <= 'X';
  end generate GEN_5M_xgs_hiSpi;


  VAAHV_NPIX  <= 'Z';
  VREF1_BOT_0 <= 'Z';
  VREF1_BOT_1 <= 'Z';
  VREF1_TOP_0 <= 'Z';
  VREF1_TOP_1 <= 'Z';
  ATEST_BTM   <= 'Z';
  ATEST_TOP   <= 'Z';
  ASPARE_TOP  <= 'Z';
  ASPARE_BTM  <= 'Z';

  VRESPD_HI_0  <= 'Z';
  VRESPD_HI_1  <= 'Z';
  VRESFD_HI_0  <= 'Z';
  VRESFD_HI_1  <= 'Z';
  VSG_HI_0     <= 'Z';
  VSG_HI_1     <= 'Z';
  VRS_HI_0     <= 'Z';
  VRS_HI_1     <= 'Z';
  VTX1_HI_0    <= 'Z';
  VTX1_HI_1    <= 'Z';
  VTX0_HI_0    <= 'Z';
  VTX0_HI_1    <= 'Z';
  VRESFD_LO1_0 <= 'Z';
  VRESFD_LO1_1 <= 'Z';
  VRESFD_LO2_0 <= 'Z';
  VRESFD_LO2_1 <= 'Z';
  VRESPD_LO1_0 <= 'Z';
  VRESPD_LO1_1 <= 'Z';
  VSG_LO1_0    <= 'Z';
  VSG_LO1_1    <= 'Z';
  VTX1_LO1_0   <= 'Z';
  VTX1_LO1_1   <= 'Z';
  VTX1_LO2_0   <= 'Z';
  VTX1_LO2_1   <= 'Z';
  VTX0_LO1_0   <= 'Z';
  VTX0_LO1_1   <= 'Z';
  VPSUB_LO_0   <= 'Z';
  VPSUB_LO_1   <= 'Z';

  --FWSI_EN      <= 'Z';
  --CS           <= 'Z';

  DSPARE0 <= 'Z';
  DSPARE1 <= 'Z';
  DSPARE2 <= 'Z';

  MONITOR0 <= INTEGRATION;
  MONITOR1 <= EFOT;
  MONITOR2 <= NEW_LINE;



  ------------------------------------------------
  --   
  -- Simple SFOT, EFOT, INTEGRATION
  --
  ------------------------------------------------

  process is
  begin
    wait on TRIGGER_INT until TRIGGER_INT = '1';
    SFOT <= '1';
    wait for 5 us;                      --SFOT_DURATION;            
    SFOT <= '0';

  -- [AM] The line below does not compile in Modelsim
  -- wait on TRIGGER_INT'event;     
  -- if(TRIGGER_INT='1') then
  --   SFOT            <= '1';     
  --   wait for 5 us; --SFOT_DURATION;            
  --   SFOT            <= '0';
  -- end if;   
  end process;

  process is
    variable fot_duration : time;
  begin
    -- [AM] The line below does not compile in Modelsim
    --wait on SFOT'event;     
    --if(SFOT='1') then

    wait on SFOT;
    if (rising_edge(SFOT))then

      INTEGRATION <= '0';
      EFOT        <= '0';

      wait for 1 us;

      INTEGRATION <= '1';
      EFOT        <= '0';

    else

      INTEGRATION <= '1';
      EFOT        <= '0';

      wait until TRIGGER_INT = '0';     -- Exposure DURATION 

      if(dataline_valid = '1') then  -- wait end current readout (Exposure end before readout! illegal!)
        wait until dataline_valid = '0';
      end if;

      -- Simulate EXPOSURE DURING EFOT
      INTEGRATION     <= '1';
      EFOT            <= '1';
      TRIGGER_READOUT <= '0';
      wait for 5360 ns;

      --NO more EXPOSURE during EFOT
      INTEGRATION     <= '0';
      EFOT            <= '1';
      TRIGGER_READOUT <= '0';

      -- [AM] The line below does not compile in Modelsim
      --wait for integer(integer( to_integer(unsigned(line_time))*8*15.4329)- 5360) * 1 ns ; --FOT Duration is around 8 lines of the sensor.

      -------------------------------------------------------------------------
      -- [AM] FOT Duration is around 8 lines of the sensor.
      -------------------------------------------------------------------------
      fot_duration := (real(8*to_integer(unsigned(line_time)))*15.4329 ns) - 5360 ns;
      wait for fot_duration;


      INTEGRATION     <= '0';
      EFOT            <= '1';
      TRIGGER_READOUT <= '1';
      wait for 20 ns;

      INTEGRATION     <= '0';
      EFOT            <= '0';
      TRIGGER_READOUT <= '0';



    end if;
  end process;



  process is
  begin
    -- [AM] The line below do not compile in Modelsim
    -- wait on EFOT'event;     
    -- if(EFOT='1') then    
    wait on EFOT until rising_edge(EFOT);
    frame_length_DB <= frame_length;
    roi_size_DB     <= roi_size;
    roi_start_DB    <= roi_start;
	x_subsampling_DB<= x_subsampling;
    y_subsampling_DB<= y_subsampling;
  --end if;
  end process;

-- For keep-out trigger zone simulation
  process is
  begin
    -- [AM] Lines below do not compile in Modelsim
    --    wait on dataline_nxt'event;
    --    if(dataline_nxt = '1') then
    wait on dataline_nxt until rising_edge(dataline_nxt);
    NEW_LINE <= '1';
    
    wait for 15432 ps;
    NEW_LINE <= '0';
  --end if;
  end process;





end behaviour;
