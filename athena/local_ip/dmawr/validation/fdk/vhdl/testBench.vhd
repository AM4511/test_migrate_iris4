-------------------------------------------------------------------------------
-- File : testBench.vhd
-- Project : FDK
-- Module  : 
-- Purpose : 
-- Limitations : 
-- Created by : amarchan 
-- Created on : 2013/06/27 11:33:08
-- 
-- FDK IDE Version: 4.2.0_beta2
-- Build ID: I20130418-1619
-- 
-------------------------------------------------------------------------------
-- IEEE libraries
library ieee;
use ieee.std_logic_1164.all;

-- Work library
library work;



entity testBench is
  generic (
    CLKPERIOD : time := 10 ns
    );


end testBench;

architecture rtl of testBench is

  component avalon_system is
    port (
      modelfdksram_0_events_init                 : in  std_logic                    := '0';
      modelfdksram_0_events_dump                 : in  std_logic                    := '0';
      modelfdksram_0_events_activity             : out std_logic;
      modelfdksram_1_events_init                 : in  std_logic                    := '0';
      modelfdksram_1_events_dump                 : in  std_logic                    := '0';
      modelfdksram_1_events_activity             : out std_logic;
      modelfdksram_2_events_init                 : in  std_logic                    := '0';
      modelfdksram_2_events_dump                 : in  std_logic                    := '0';
      modelfdksram_2_events_activity             : out std_logic;
      modelfdksram_3_events_init                 : in  std_logic                    := '0';
      modelfdksram_3_events_dump                 : in  std_logic                    := '0';
      modelfdksram_3_events_activity             : out std_logic;
      dmawr_sub2_0_export_interface_LSBOF        : in  std_logic_vector(6 downto 0) := (others => '0');
      dmawr_sub2_0_export_interface_intevent     : out std_logic;
      modelfdkstreamoutputport_0_events_lsbof    : out std_logic_vector(6 downto 0);
      modelfdkstreamoutputport_0_events_intevent : in  std_logic_vector(7 downto 0) := (others => '0');
      modelfdkstreamoutputport_0_events_init     : out std_logic;
      modelfdkstreamoutputport_0_events_trigger  : out std_logic;
      modelfdkstreamoutputport_0_events_dump     : out std_logic;
      modelfdkstreamoutputport_3_events_lsbof    : out std_logic_vector(6 downto 0);
      modelfdkstreamoutputport_3_events_intevent : in  std_logic_vector(7 downto 0) := (others => '0');
      modelfdkstreamoutputport_3_events_init     : out std_logic;
      modelfdkstreamoutputport_3_events_trigger  : out std_logic;
      modelfdkstreamoutputport_3_events_dump     : out std_logic;
      modelfdkstreamoutputport_1_events_lsbof    : out std_logic_vector(6 downto 0);
      modelfdkstreamoutputport_1_events_intevent : in  std_logic_vector(7 downto 0) := (others => '0');
      modelfdkstreamoutputport_1_events_init     : out std_logic;
      modelfdkstreamoutputport_1_events_trigger  : out std_logic;
      modelfdkstreamoutputport_1_events_dump     : out std_logic;
      modelfdkstreamoutputport_2_events_lsbof    : out std_logic_vector(6 downto 0);
      modelfdkstreamoutputport_2_events_intevent : in  std_logic_vector(7 downto 0) := (others => '0');
      modelfdkstreamoutputport_2_events_init     : out std_logic;
      modelfdkstreamoutputport_2_events_trigger  : out std_logic;
      modelfdkstreamoutputport_2_events_dump     : out std_logic;
      modelfdksdram_0_events_init                : in  std_logic                    := '0';
      modelfdksdram_0_events_dump                : in  std_logic                    := '0';
      modelfdksdram_0_events_activity            : out std_logic;
      dmawr_sub4_0_export_interface_LSBOF        : in  std_logic_vector(6 downto 0) := (others => '0');
      dmawr_sub4_0_export_interface_intevent     : out std_logic;
      dmawr_sub6_0_export_interface_LSBOF        : in  std_logic_vector(6 downto 0) := (others => '0');
      dmawr_sub6_0_export_interface_intevent     : out std_logic_vector(3 downto 0);
      dmawr_sub7_0_export_interface_LSBOF        : in  std_logic_vector(6 downto 0) := (others => '0');
      dmawr_sub7_0_export_interface_intevent     : out std_logic_vector(1 downto 0);
      dmawr_sub5_0_export_interface_LSBOF        : in  std_logic_vector(6 downto 0) := (others => '0');
      dmawr_sub5_0_export_interface_intevent     : out std_logic;
      modelfdkmaster_0_events_intevent           : in  std_logic_vector(7 downto 0) := (others => '0');
      modelfdkmaster_0_events_lsbof              : out std_logic_vector(6 downto 0);
      modelfdkmaster_0_events_init               : out std_logic;
      modelfdkmaster_0_events_trigger            : out std_logic;
      modelfdkmaster_0_events_dump               : out std_logic
      );
  end component;


------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
  signal init                : std_logic                    := '0';
  signal dump                : std_logic                    := '0';
  signal trigger             : std_logic                    := '0';
  signal intevent            : std_logic_vector(7 downto 0) := (others => '0');
  signal dmawr_sub7_intevent : std_logic_vector(1 downto 0) := (others => '0');
begin


  xavalon_system : avalon_system
    port map(
      modelfdksram_0_events_init                             => init,
      modelfdksram_0_events_dump                             => dump,
      modelfdksram_0_events_activity                         => open,
      modelfdksram_1_events_init                             => init,
      modelfdksram_1_events_dump                             => dump,
      modelfdksram_1_events_activity                         => open,
      modelfdksram_2_events_init                             => init,
      modelfdksram_2_events_dump                             => dump,
      modelfdksram_2_events_activity                         => open,
      modelfdksram_3_events_init                             => init,
      modelfdksram_3_events_dump                             => dump,
      modelfdksram_3_events_activity                         => open,
      dmawr_sub2_0_export_interface_LSBOF                    => "0000000",
      dmawr_sub2_0_export_interface_intevent                 => intevent(0),
      modelfdkstreamoutputport_0_events_lsbof                => open,
      modelfdkstreamoutputport_0_events_intevent(0)          => trigger,
      modelfdkstreamoutputport_0_events_intevent(7 downto 1) => "0000000",
      modelfdkstreamoutputport_0_events_init                 => open,
      modelfdkstreamoutputport_0_events_trigger              => open,
      modelfdkstreamoutputport_0_events_dump                 => open,
      modelfdkstreamoutputport_3_events_lsbof                => open,
      modelfdkstreamoutputport_3_events_intevent(0)          => trigger,
      modelfdkstreamoutputport_3_events_intevent(7 downto 1) => "0000000",
      modelfdkstreamoutputport_3_events_init                 => open,
      modelfdkstreamoutputport_3_events_trigger              => open,
      modelfdkstreamoutputport_3_events_dump                 => open,
      modelfdkstreamoutputport_1_events_lsbof                => open,
      modelfdkstreamoutputport_1_events_intevent(0)          => trigger,
      modelfdkstreamoutputport_1_events_intevent(7 downto 1) => "0000000",
      modelfdkstreamoutputport_1_events_init                 => open,
      modelfdkstreamoutputport_1_events_trigger              => open,
      modelfdkstreamoutputport_1_events_dump                 => open,
      modelfdkstreamoutputport_2_events_lsbof                => open,
      modelfdkstreamoutputport_2_events_intevent(0)          => trigger,
      modelfdkstreamoutputport_2_events_intevent(7 downto 1) => "0000000",
      modelfdkstreamoutputport_2_events_init                 => open,
      modelfdkstreamoutputport_2_events_trigger              => open,
      modelfdkstreamoutputport_2_events_dump                 => open,
      modelfdksdram_0_events_init                            => init,
      modelfdksdram_0_events_dump                            => dump,
      modelfdksdram_0_events_activity                        => open,
      dmawr_sub4_0_export_interface_LSBOF                    => "0000001",
      dmawr_sub4_0_export_interface_intevent                 => intevent(1),
      dmawr_sub6_0_export_interface_LSBOF                    => "0000011",
      dmawr_sub6_0_export_interface_intevent                 => intevent(6 downto 3),
      dmawr_sub7_0_export_interface_LSBOF                    => "0000100",
      dmawr_sub7_0_export_interface_intevent                 => dmawr_sub7_intevent,
      dmawr_sub5_0_export_interface_LSBOF                    => "0000010",
      dmawr_sub5_0_export_interface_intevent                 => intevent(2),
      modelfdkmaster_0_events_intevent                       => intevent,
      modelfdkmaster_0_events_lsbof                          => open,
      modelfdkmaster_0_events_init                           => init,
      modelfdkmaster_0_events_trigger                        => trigger,
      modelfdkmaster_0_events_dump                           => dump
      );


  intevent(7) <= dmawr_sub7_intevent(0) or dmawr_sub7_intevent(1);
  
end architecture rtl;
