-------------------------------------------------------------------------------
-- File                : dma2tlp.vhd
-- Project             : FDK
-- Module              : regfile_dma2tlp_pack
-- Created on          : 2020/04/20 11:01:50
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xEE85E3EC
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_dma2tlp_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_info_tag_ADDR           : natural := 16#0#;
   constant K_info_fid_ADDR           : natural := 16#8#;
   constant K_info_version_ADDR       : natural := 16#10#;
   constant K_info_capability_ADDR    : natural := 16#18#;
   constant K_info_scratchpad_ADDR    : natural := 16#20#;
   constant K_dma_ctrl_ADDR           : natural := 16#40#;
   constant K_dma_dstfstart_low_ADDR  : natural := 16#48#;
   constant K_dma_dstfstart_high_ADDR : natural := 16#50#;
   constant K_dma_dstlnpitch_ADDR     : natural := 16#58#;
   constant K_dma_dstlnsize_ADDR      : natural := 16#60#;
   constant K_dma_dstfstart1_low_ADDR : natural := 16#68#;
   constant K_dma_dstfstart1_high_ADDR : natural := 16#70#;
   constant K_dma_dstfstart2_low_ADDR : natural := 16#78#;
   constant K_dma_dstfstart2_high_ADDR : natural := 16#80#;
   constant K_dma_csc_ADDR            : natural := 16#88#;
   constant K_status_active_ADDR      : natural := 16#c0#;
   constant K_status_debug_ADDR       : natural := 16#c8#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: tag
   ------------------------------------------------------------------------------------------
   type INFO_TAG_TYPE is record
      value          : std_logic_vector(23 downto 0);
   end record INFO_TAG_TYPE;

   constant INIT_INFO_TAG_TYPE : INFO_TAG_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_TAG_TYPE) return std_logic_vector;
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_TAG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fid
   ------------------------------------------------------------------------------------------
   type INFO_FID_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_FID_TYPE;

   constant INIT_INFO_FID_TYPE : INFO_FID_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_FID_TYPE) return std_logic_vector;
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_FID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: version
   ------------------------------------------------------------------------------------------
   type INFO_VERSION_TYPE is record
      major          : std_logic_vector(7 downto 0);
      minor          : std_logic_vector(7 downto 0);
      hw             : std_logic_vector(7 downto 0);
   end record INFO_VERSION_TYPE;

   constant INIT_INFO_VERSION_TYPE : INFO_VERSION_TYPE := (
      major           => (others=> 'Z'),
      minor           => (others=> 'Z'),
      hw              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_VERSION_TYPE) return std_logic_vector;
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_VERSION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: capability
   ------------------------------------------------------------------------------------------
   type INFO_CAPABILITY_TYPE is record
      value          : std_logic_vector(7 downto 0);
   end record INFO_CAPABILITY_TYPE;

   constant INIT_INFO_CAPABILITY_TYPE : INFO_CAPABILITY_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_CAPABILITY_TYPE) return std_logic_vector;
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_CAPABILITY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: scratchpad
   ------------------------------------------------------------------------------------------
   type INFO_SCRATCHPAD_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_SCRATCHPAD_TYPE;

   constant INIT_INFO_SCRATCHPAD_TYPE : INFO_SCRATCHPAD_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_SCRATCHPAD_TYPE) return std_logic_vector;
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_SCRATCHPAD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type DMA_CTRL_TYPE is record
      enable         : std_logic;
   end record DMA_CTRL_TYPE;

   constant INIT_DMA_CTRL_TYPE : DMA_CTRL_TYPE := (
      enable          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CTRL_TYPE) return std_logic_vector;
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart_low
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART_LOW_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DMA_DSTFSTART_LOW_TYPE;

   constant INIT_DMA_DSTFSTART_LOW_TYPE : DMA_DSTFSTART_LOW_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART_LOW_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART_LOW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart_high
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART_HIGH_TYPE is record
      value          : std_logic_vector(3 downto 0);
   end record DMA_DSTFSTART_HIGH_TYPE;

   constant INIT_DMA_DSTFSTART_HIGH_TYPE : DMA_DSTFSTART_HIGH_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART_HIGH_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstlnpitch
   ------------------------------------------------------------------------------------------
   type DMA_DSTLNPITCH_TYPE is record
      value          : std_logic_vector(15 downto 0);
   end record DMA_DSTLNPITCH_TYPE;

   constant INIT_DMA_DSTLNPITCH_TYPE : DMA_DSTLNPITCH_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTLNPITCH_TYPE) return std_logic_vector;
   function to_DMA_DSTLNPITCH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTLNPITCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstlnsize
   ------------------------------------------------------------------------------------------
   type DMA_DSTLNSIZE_TYPE is record
      HOST_LINE_SIZE : std_logic_vector(13 downto 0);
   end record DMA_DSTLNSIZE_TYPE;

   constant INIT_DMA_DSTLNSIZE_TYPE : DMA_DSTLNSIZE_TYPE := (
      HOST_LINE_SIZE  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTLNSIZE_TYPE) return std_logic_vector;
   function to_DMA_DSTLNSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTLNSIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart1_low
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART1_LOW_TYPE is record
      GRAB_ADDR      : std_logic_vector(31 downto 0);
   end record DMA_DSTFSTART1_LOW_TYPE;

   constant INIT_DMA_DSTFSTART1_LOW_TYPE : DMA_DSTFSTART1_LOW_TYPE := (
      GRAB_ADDR       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART1_LOW_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART1_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART1_LOW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart1_high
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART1_HIGH_TYPE is record
      reserved       : std_logic_vector(27 downto 0);
      GRAB_ADDR      : std_logic_vector(3 downto 0);
   end record DMA_DSTFSTART1_HIGH_TYPE;

   constant INIT_DMA_DSTFSTART1_HIGH_TYPE : DMA_DSTFSTART1_HIGH_TYPE := (
      reserved        => (others=> 'Z'),
      GRAB_ADDR       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART1_HIGH_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART1_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART1_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart2_low
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART2_LOW_TYPE is record
      GRAB_ADDR      : std_logic_vector(31 downto 0);
   end record DMA_DSTFSTART2_LOW_TYPE;

   constant INIT_DMA_DSTFSTART2_LOW_TYPE : DMA_DSTFSTART2_LOW_TYPE := (
      GRAB_ADDR       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART2_LOW_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART2_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART2_LOW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart2_high
   ------------------------------------------------------------------------------------------
   type DMA_DSTFSTART2_HIGH_TYPE is record
      reserved       : std_logic_vector(27 downto 0);
      GRAB_ADDR      : std_logic_vector(3 downto 0);
   end record DMA_DSTFSTART2_HIGH_TYPE;

   constant INIT_DMA_DSTFSTART2_HIGH_TYPE : DMA_DSTFSTART2_HIGH_TYPE := (
      reserved        => (others=> 'Z'),
      GRAB_ADDR       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_DSTFSTART2_HIGH_TYPE) return std_logic_vector;
   function to_DMA_DSTFSTART2_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART2_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: csc
   ------------------------------------------------------------------------------------------
   type DMA_CSC_TYPE is record
      COLOR_SPACE    : std_logic_vector(2 downto 0);
      DUP_LAST_LINE  : std_logic;
      MONO10         : std_logic;
      REVERSE_Y      : std_logic;
      GRAB_REVX      : std_logic;
   end record DMA_CSC_TYPE;

   constant INIT_DMA_CSC_TYPE : DMA_CSC_TYPE := (
      COLOR_SPACE     => (others=> 'Z'),
      DUP_LAST_LINE   => 'Z',
      MONO10          => 'Z',
      REVERSE_Y       => 'Z',
      GRAB_REVX       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector;
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_CSC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: active
   ------------------------------------------------------------------------------------------
   type STATUS_ACTIVE_TYPE is record
      busy           : std_logic;
   end record STATUS_ACTIVE_TYPE;

   constant INIT_STATUS_ACTIVE_TYPE : STATUS_ACTIVE_TYPE := (
      busy            => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : STATUS_ACTIVE_TYPE) return std_logic_vector;
   function to_STATUS_ACTIVE_TYPE(stdlv : std_logic_vector(63 downto 0)) return STATUS_ACTIVE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: debug
   ------------------------------------------------------------------------------------------
   type STATUS_DEBUG_TYPE is record
      GRAB_MAX_ADD   : std_logic_vector(29 downto 0);
      OUT_OF_MEMORY_CLEAR: std_logic;
      OUT_OF_MEMORY_STAT: std_logic;
   end record STATUS_DEBUG_TYPE;

   constant INIT_STATUS_DEBUG_TYPE : STATUS_DEBUG_TYPE := (
      GRAB_MAX_ADD    => (others=> 'Z'),
      OUT_OF_MEMORY_CLEAR => 'Z',
      OUT_OF_MEMORY_STAT => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : STATUS_DEBUG_TYPE) return std_logic_vector;
   function to_STATUS_DEBUG_TYPE(stdlv : std_logic_vector(63 downto 0)) return STATUS_DEBUG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: info
   ------------------------------------------------------------------------------------------
   type INFO_TYPE is record
      tag            : INFO_TAG_TYPE;
      fid            : INFO_FID_TYPE;
      version        : INFO_VERSION_TYPE;
      capability     : INFO_CAPABILITY_TYPE;
      scratchpad     : INFO_SCRATCHPAD_TYPE;
   end record INFO_TYPE;

   constant INIT_INFO_TYPE : INFO_TYPE := (
      tag             => INIT_INFO_TAG_TYPE,
      fid             => INIT_INFO_FID_TYPE,
      version         => INIT_INFO_VERSION_TYPE,
      capability      => INIT_INFO_CAPABILITY_TYPE,
      scratchpad      => INIT_INFO_SCRATCHPAD_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: dma
   ------------------------------------------------------------------------------------------
   type DMA_TYPE is record
      ctrl           : DMA_CTRL_TYPE;
      dstfstart_low  : DMA_DSTFSTART_LOW_TYPE;
      dstfstart_high : DMA_DSTFSTART_HIGH_TYPE;
      dstlnpitch     : DMA_DSTLNPITCH_TYPE;
      dstlnsize      : DMA_DSTLNSIZE_TYPE;
      dstfstart1_low : DMA_DSTFSTART1_LOW_TYPE;
      dstfstart1_high: DMA_DSTFSTART1_HIGH_TYPE;
      dstfstart2_low : DMA_DSTFSTART2_LOW_TYPE;
      dstfstart2_high: DMA_DSTFSTART2_HIGH_TYPE;
      csc            : DMA_CSC_TYPE;
   end record DMA_TYPE;

   constant INIT_DMA_TYPE : DMA_TYPE := (
      ctrl            => INIT_DMA_CTRL_TYPE,
      dstfstart_low   => INIT_DMA_DSTFSTART_LOW_TYPE,
      dstfstart_high  => INIT_DMA_DSTFSTART_HIGH_TYPE,
      dstlnpitch      => INIT_DMA_DSTLNPITCH_TYPE,
      dstlnsize       => INIT_DMA_DSTLNSIZE_TYPE,
      dstfstart1_low  => INIT_DMA_DSTFSTART1_LOW_TYPE,
      dstfstart1_high => INIT_DMA_DSTFSTART1_HIGH_TYPE,
      dstfstart2_low  => INIT_DMA_DSTFSTART2_LOW_TYPE,
      dstfstart2_high => INIT_DMA_DSTFSTART2_HIGH_TYPE,
      csc             => INIT_DMA_CSC_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: status
   ------------------------------------------------------------------------------------------
   type STATUS_TYPE is record
      active         : STATUS_ACTIVE_TYPE;
      debug          : STATUS_DEBUG_TYPE;
   end record STATUS_TYPE;

   constant INIT_STATUS_TYPE : STATUS_TYPE := (
      active          => INIT_STATUS_ACTIVE_TYPE,
      debug           => INIT_STATUS_DEBUG_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_dma2tlp
   ------------------------------------------------------------------------------------------
   type REGFILE_DMA2TLP_TYPE is record
      info           : INFO_TYPE;
      dma            : DMA_TYPE;
      status         : STATUS_TYPE;
   end record REGFILE_DMA2TLP_TYPE;

   constant INIT_REGFILE_DMA2TLP_TYPE : REGFILE_DMA2TLP_TYPE := (
      info            => INIT_INFO_TYPE,
      dma             => INIT_DMA_TYPE,
      status          => INIT_STATUS_TYPE
   );

   
end regfile_dma2tlp_pack;

package body regfile_dma2tlp_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_TAG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_TAG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_TAG_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to INFO_TAG_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_TAG_TYPE is
   variable output : INFO_TAG_TYPE;
   begin
      output.value := stdlv(23 downto 0);
      return output;
   end to_INFO_TAG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_FID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_FID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_FID_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to INFO_FID_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_FID_TYPE is
   variable output : INFO_FID_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_FID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_VERSION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_VERSION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.major;
      output(15 downto 8) := reg.minor;
      output(7 downto 0) := reg.hw;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_VERSION_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to INFO_VERSION_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_VERSION_TYPE is
   variable output : INFO_VERSION_TYPE;
   begin
      output.major := stdlv(23 downto 16);
      output.minor := stdlv(15 downto 8);
      output.hw := stdlv(7 downto 0);
      return output;
   end to_INFO_VERSION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_CAPABILITY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_CAPABILITY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_CAPABILITY_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to INFO_CAPABILITY_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_CAPABILITY_TYPE is
   variable output : INFO_CAPABILITY_TYPE;
   begin
      output.value := stdlv(7 downto 0);
      return output;
   end to_INFO_CAPABILITY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_SCRATCHPAD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_SCRATCHPAD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_SCRATCHPAD_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to INFO_SCRATCHPAD_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(63 downto 0)) return INFO_SCRATCHPAD_TYPE is
   variable output : INFO_SCRATCHPAD_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_SCRATCHPAD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.enable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CTRL_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_CTRL_TYPE is
   variable output : DMA_CTRL_TYPE;
   begin
      output.enable := stdlv(0);
      return output;
   end to_DMA_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART_LOW_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART_LOW_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART_LOW_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART_LOW_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART_LOW_TYPE is
   variable output : DMA_DSTFSTART_LOW_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DMA_DSTFSTART_LOW_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART_HIGH_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART_HIGH_TYPE is
   variable output : DMA_DSTFSTART_HIGH_TYPE;
   begin
      output.value := stdlv(3 downto 0);
      return output;
   end to_DMA_DSTFSTART_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTLNPITCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTLNPITCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTLNPITCH_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTLNPITCH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTLNPITCH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTLNPITCH_TYPE is
   variable output : DMA_DSTLNPITCH_TYPE;
   begin
      output.value := stdlv(15 downto 0);
      return output;
   end to_DMA_DSTLNPITCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTLNSIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTLNSIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(13 downto 0) := reg.HOST_LINE_SIZE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTLNSIZE_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTLNSIZE_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTLNSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTLNSIZE_TYPE is
   variable output : DMA_DSTLNSIZE_TYPE;
   begin
      output.HOST_LINE_SIZE := stdlv(13 downto 0);
      return output;
   end to_DMA_DSTLNSIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART1_LOW_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART1_LOW_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.GRAB_ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART1_LOW_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART1_LOW_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART1_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART1_LOW_TYPE is
   variable output : DMA_DSTFSTART1_LOW_TYPE;
   begin
      output.GRAB_ADDR := stdlv(31 downto 0);
      return output;
   end to_DMA_DSTFSTART1_LOW_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART1_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART1_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 4) := reg.reserved;
      output(3 downto 0) := reg.GRAB_ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART1_HIGH_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART1_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART1_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART1_HIGH_TYPE is
   variable output : DMA_DSTFSTART1_HIGH_TYPE;
   begin
      output.reserved := stdlv(31 downto 4);
      output.GRAB_ADDR := stdlv(3 downto 0);
      return output;
   end to_DMA_DSTFSTART1_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART2_LOW_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART2_LOW_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.GRAB_ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART2_LOW_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART2_LOW_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART2_LOW_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART2_LOW_TYPE is
   variable output : DMA_DSTFSTART2_LOW_TYPE;
   begin
      output.GRAB_ADDR := stdlv(31 downto 0);
      return output;
   end to_DMA_DSTFSTART2_LOW_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_DSTFSTART2_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_DSTFSTART2_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 4) := reg.reserved;
      output(3 downto 0) := reg.GRAB_ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_DSTFSTART2_HIGH_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_DSTFSTART2_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_DSTFSTART2_HIGH_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_DSTFSTART2_HIGH_TYPE is
   variable output : DMA_DSTFSTART2_HIGH_TYPE;
   begin
      output.reserved := stdlv(31 downto 4);
      output.GRAB_ADDR := stdlv(3 downto 0);
      return output;
   end to_DMA_DSTFSTART2_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_CSC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(26 downto 24) := reg.COLOR_SPACE;
      output(23) := reg.DUP_LAST_LINE;
      output(16) := reg.MONO10;
      output(9) := reg.REVERSE_Y;
      output(8) := reg.GRAB_REVX;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CSC_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to DMA_CSC_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(63 downto 0)) return DMA_CSC_TYPE is
   variable output : DMA_CSC_TYPE;
   begin
      output.COLOR_SPACE := stdlv(26 downto 24);
      output.DUP_LAST_LINE := stdlv(23);
      output.MONO10 := stdlv(16);
      output.REVERSE_Y := stdlv(9);
      output.GRAB_REVX := stdlv(8);
      return output;
   end to_DMA_CSC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from STATUS_ACTIVE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : STATUS_ACTIVE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.busy;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_STATUS_ACTIVE_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to STATUS_ACTIVE_TYPE
   --------------------------------------------------------------------------------
   function to_STATUS_ACTIVE_TYPE(stdlv : std_logic_vector(63 downto 0)) return STATUS_ACTIVE_TYPE is
   variable output : STATUS_ACTIVE_TYPE;
   begin
      output.busy := stdlv(0);
      return output;
   end to_STATUS_ACTIVE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from STATUS_DEBUG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : STATUS_DEBUG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 2) := reg.GRAB_MAX_ADD;
      output(1) := reg.OUT_OF_MEMORY_CLEAR;
      output(0) := reg.OUT_OF_MEMORY_STAT;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_STATUS_DEBUG_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to STATUS_DEBUG_TYPE
   --------------------------------------------------------------------------------
   function to_STATUS_DEBUG_TYPE(stdlv : std_logic_vector(63 downto 0)) return STATUS_DEBUG_TYPE is
   variable output : STATUS_DEBUG_TYPE;
   begin
      output.GRAB_MAX_ADD := stdlv(31 downto 2);
      output.OUT_OF_MEMORY_CLEAR := stdlv(1);
      output.OUT_OF_MEMORY_STAT := stdlv(0);
      return output;
   end to_STATUS_DEBUG_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : dma2tlp_registerfile.vhd
-- Project             : FDK
-- Module              : regfile_dma2tlp
-- Created on          : 2020/04/20 11:01:50
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xEE85E3EC
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_dma2tlp_pack.all;


entity regfile_dma2tlp is
   
   port (
      resetN        : in    std_logic;                                         -- System reset
      sysclk        : in    std_logic;                                         -- System clock
      regfile       : inout REGFILE_DMA2TLP_TYPE := INIT_REGFILE_DMA2TLP_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                         -- Read
      reg_write     : in    std_logic;                                         -- Write
      reg_addr      : in    std_logic_vector(7 downto 3);                      -- Address
      reg_beN       : in    std_logic_vector(7 downto 0);                      -- Byte enable
      reg_writedata : in    std_logic_vector(63 downto 0);                     -- Write data
      reg_readdata  : out   std_logic_vector(63 downto 0)                      -- Read data
   );
   
end regfile_dma2tlp;

architecture rtl of regfile_dma2tlp is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                     : std_logic_vector(63 downto 0);                   -- Data readback multiplexer
signal hit                                             : std_logic_vector(16 downto 0);                   -- Address decode hit
signal wEn                                             : std_logic_vector(16 downto 0);                   -- Write Enable
signal fullAddr                                        : std_logic_vector(7 downto 0):= (others => '0');  -- Full Address
signal fullAddrAsInt                                   : integer;                                        
signal bitEnN                                          : std_logic_vector(63 downto 0);                   -- Bits enable
signal ldData                                          : std_logic;                                      
signal rb_info_tag                                     : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_info_fid                                     : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_info_version                                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_info_capability                              : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_info_scratchpad                              : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_ctrl                                     : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart_low                            : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart_high                           : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstlnpitch                               : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstlnsize                                : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart1_low                           : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart1_high                          : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart2_low                           : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_dstfstart2_high                          : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_csc                                      : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_status_active                                : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_status_debug                                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal field_rw_info_scratchpad_value                  : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_ctrl_enable                        : std_logic;                                       -- Field: enable
signal field_rw_dma_dstfstart_low_value                : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_dstfstart_high_value               : std_logic_vector(3 downto 0);                    -- Field: value
signal field_rw_dma_dstlnpitch_value                   : std_logic_vector(15 downto 0);                   -- Field: value
signal field_rw_dma_dstlnsize_HOST_LINE_SIZE           : std_logic_vector(13 downto 0);                   -- Field: HOST_LINE_SIZE
signal field_rw_dma_dstfstart1_low_GRAB_ADDR           : std_logic_vector(31 downto 0);                   -- Field: GRAB_ADDR
signal field_rw_dma_dstfstart1_high_GRAB_ADDR          : std_logic_vector(3 downto 0);                    -- Field: GRAB_ADDR
signal field_rw_dma_dstfstart2_low_GRAB_ADDR           : std_logic_vector(31 downto 0);                   -- Field: GRAB_ADDR
signal field_rw_dma_dstfstart2_high_GRAB_ADDR          : std_logic_vector(3 downto 0);                    -- Field: GRAB_ADDR
signal field_rw_dma_csc_COLOR_SPACE                    : std_logic_vector(2 downto 0);                    -- Field: COLOR_SPACE
signal field_rw_dma_csc_DUP_LAST_LINE                  : std_logic;                                       -- Field: DUP_LAST_LINE
signal field_rw_dma_csc_MONO10                         : std_logic;                                       -- Field: MONO10
signal field_rw_dma_csc_REVERSE_Y                      : std_logic;                                       -- Field: REVERSE_Y
signal field_rw_dma_csc_GRAB_REVX                      : std_logic;                                       -- Field: GRAB_REVX
signal field_rw_status_debug_GRAB_MAX_ADD              : std_logic_vector(29 downto 0);                   -- Field: GRAB_MAX_ADD
signal field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR : std_logic;                                       -- Field: OUT_OF_MEMORY_CLEAR

begin -- rtl

------------------------------------------------------------------------------------------
-- Process: P_bitEnN
------------------------------------------------------------------------------------------
P_bitEnN : process(reg_beN)
begin
   for i in 7 downto 0 loop
      for j in 7 downto 0 loop
         bitEnN(i*8+j) <= reg_beN(i);
      end loop;
   end loop;
end process P_bitEnN;

--------------------------------------------------------------------------------
-- Address decoding logic
--------------------------------------------------------------------------------
fullAddr(7 downto 3)<= reg_addr;

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,8)))	else '0'; -- Addr:  0x0000	tag
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,8)))	else '0'; -- Addr:  0x0008	fid
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,8)))	else '0'; -- Addr:  0x0010	version
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#18#,8)))	else '0'; -- Addr:  0x0018	capability
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20#,8)))	else '0'; -- Addr:  0x0020	scratchpad
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,8)))	else '0'; -- Addr:  0x0040	ctrl
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48#,8)))	else '0'; -- Addr:  0x0048	dstfstart_low
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#50#,8)))	else '0'; -- Addr:  0x0050	dstfstart_high
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#58#,8)))	else '0'; -- Addr:  0x0058	dstlnpitch
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#60#,8)))	else '0'; -- Addr:  0x0060	dstlnsize
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#68#,8)))	else '0'; -- Addr:  0x0068	dstfstart1_low
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,8)))	else '0'; -- Addr:  0x0070	dstfstart1_high
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#78#,8)))	else '0'; -- Addr:  0x0078	dstfstart2_low
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#80#,8)))	else '0'; -- Addr:  0x0080	dstfstart2_high
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#88#,8)))	else '0'; -- Addr:  0x0088	csc
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c0#,8)))	else '0'; -- Addr:  0x00C0	active
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c8#,8)))	else '0'; -- Addr:  0x00C8	debug



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_info_tag,
                            rb_info_fid,
                            rb_info_version,
                            rb_info_capability,
                            rb_info_scratchpad,
                            rb_dma_ctrl,
                            rb_dma_dstfstart_low,
                            rb_dma_dstfstart_high,
                            rb_dma_dstlnpitch,
                            rb_dma_dstlnsize,
                            rb_dma_dstfstart1_low,
                            rb_dma_dstfstart1_high,
                            rb_dma_dstfstart2_low,
                            rb_dma_dstfstart2_high,
                            rb_dma_csc,
                            rb_status_active,
                            rb_status_debug
                           )
begin
   case fullAddrAsInt is
      -- [0x00]: /info/tag
      when 16#0# =>
         readBackMux <= rb_info_tag;

      -- [0x08]: /info/fid
      when 16#8# =>
         readBackMux <= rb_info_fid;

      -- [0x10]: /info/version
      when 16#10# =>
         readBackMux <= rb_info_version;

      -- [0x18]: /info/capability
      when 16#18# =>
         readBackMux <= rb_info_capability;

      -- [0x20]: /info/scratchpad
      when 16#20# =>
         readBackMux <= rb_info_scratchpad;

      -- [0x40]: /dma/ctrl
      when 16#40# =>
         readBackMux <= rb_dma_ctrl;

      -- [0x48]: /dma/dstfstart_low
      when 16#48# =>
         readBackMux <= rb_dma_dstfstart_low;

      -- [0x50]: /dma/dstfstart_high
      when 16#50# =>
         readBackMux <= rb_dma_dstfstart_high;

      -- [0x58]: /dma/dstlnpitch
      when 16#58# =>
         readBackMux <= rb_dma_dstlnpitch;

      -- [0x60]: /dma/dstlnsize
      when 16#60# =>
         readBackMux <= rb_dma_dstlnsize;

      -- [0x68]: /dma/dstfstart1_low
      when 16#68# =>
         readBackMux <= rb_dma_dstfstart1_low;

      -- [0x70]: /dma/dstfstart1_high
      when 16#70# =>
         readBackMux <= rb_dma_dstfstart1_high;

      -- [0x78]: /dma/dstfstart2_low
      when 16#78# =>
         readBackMux <= rb_dma_dstfstart2_low;

      -- [0x80]: /dma/dstfstart2_high
      when 16#80# =>
         readBackMux <= rb_dma_dstfstart2_high;

      -- [0x88]: /dma/csc
      when 16#88# =>
         readBackMux <= rb_dma_csc;

      -- [0xc0]: /status/active
      when 16#C0# =>
         readBackMux <= rb_status_active;

      -- [0xc8]: /status/debug
      when 16#C8# =>
         readBackMux <= rb_status_debug;

      -- Default value
      when others =>
         readBackMux <= (others => '0');

   end case;

end process P_readBackMux_Mux;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdata
------------------------------------------------------------------------------------------
P_reg_readdata : process(sysclk, resetN)
begin
   if (resetN = '0') then
      reg_readdata <= (others=>'0');
   elsif (rising_edge(sysclk)) then
      if (ldData = '1') then
         reg_readdata <= readBackMux;
      end if;
   end if;
end process P_reg_readdata;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_tag
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_tag(23 downto 0) <= std_logic_vector(to_unsigned(integer(5788749),24));
regfile.info.tag.value <= rb_info_tag(23 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_fid
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_fid(31 downto 0) <= X"00000000";
regfile.info.fid.value <= rb_info_fid(31 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_version
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: major
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(23 downto 16) <= std_logic_vector(to_unsigned(integer(1),8));
regfile.info.version.major <= rb_info_version(23 downto 16);


------------------------------------------------------------------------------------------
-- Field name: minor
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(15 downto 8) <= std_logic_vector(to_unsigned(integer(5),8));
regfile.info.version.minor <= rb_info_version(15 downto 8);


------------------------------------------------------------------------------------------
-- Field name: hw(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_info_version(7 downto 0) <= regfile.info.version.hw;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_capability
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_capability(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.info.capability.value <= rb_info_capability(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_scratchpad
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_info_scratchpad(31 downto 0) <= field_rw_info_scratchpad_value(31 downto 0);
regfile.info.scratchpad.value <= field_rw_info_scratchpad_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_info_scratchpad_value
------------------------------------------------------------------------------------------
P_info_scratchpad_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_info_scratchpad_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(4) = '1' and bitEnN(j) = '0') then
            field_rw_info_scratchpad_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_info_scratchpad_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_ctrl(0) <= field_rw_dma_ctrl_enable;
regfile.dma.ctrl.enable <= field_rw_dma_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_dma_ctrl_enable
------------------------------------------------------------------------------------------
P_dma_ctrl_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_ctrl_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(5) = '1' and bitEnN(0) = '0') then
         field_rw_dma_ctrl_enable <= reg_writedata(0);
      end if;
   end if;
end process P_dma_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart_low
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart_low(31 downto 0) <= field_rw_dma_dstfstart_low_value(31 downto 0);
regfile.dma.dstfstart_low.value <= field_rw_dma_dstfstart_low_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart_low_value
------------------------------------------------------------------------------------------
P_dma_dstfstart_low_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(6) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart_low_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart_low_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart_high
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart_high(3 downto 0) <= field_rw_dma_dstfstart_high_value(3 downto 0);
regfile.dma.dstfstart_high.value <= field_rw_dma_dstfstart_high_value(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart_high_value
------------------------------------------------------------------------------------------
P_dma_dstfstart_high_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  3 downto 0  loop
         if(wEn(7) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart_high_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart_high_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstlnpitch
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstlnpitch(15 downto 0) <= field_rw_dma_dstlnpitch_value(15 downto 0);
regfile.dma.dstlnpitch.value <= field_rw_dma_dstlnpitch_value(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstlnpitch_value
------------------------------------------------------------------------------------------
P_dma_dstlnpitch_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  15 downto 0  loop
         if(wEn(8) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstlnpitch_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstlnpitch_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstlnsize
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: HOST_LINE_SIZE(13 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstlnsize(13 downto 0) <= field_rw_dma_dstlnsize_HOST_LINE_SIZE(13 downto 0);
regfile.dma.dstlnsize.HOST_LINE_SIZE <= field_rw_dma_dstlnsize_HOST_LINE_SIZE(13 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstlnsize_HOST_LINE_SIZE
------------------------------------------------------------------------------------------
P_dma_dstlnsize_HOST_LINE_SIZE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_dstlnsize_HOST_LINE_SIZE <= std_logic_vector(to_unsigned(integer(0),14));
   elsif (rising_edge(sysclk)) then
      for j in  13 downto 0  loop
         if(wEn(9) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstlnsize_HOST_LINE_SIZE(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstlnsize_HOST_LINE_SIZE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart1_low
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_ADDR(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart1_low(31 downto 0) <= field_rw_dma_dstfstart1_low_GRAB_ADDR(31 downto 0);
regfile.dma.dstfstart1_low.GRAB_ADDR <= field_rw_dma_dstfstart1_low_GRAB_ADDR(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart1_low_GRAB_ADDR
------------------------------------------------------------------------------------------
P_dma_dstfstart1_low_GRAB_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(10) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart1_low_GRAB_ADDR(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart1_low_GRAB_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart1_high
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_dma_dstfstart1_high(31 downto 4) <= std_logic_vector(to_unsigned(integer(0),28));
regfile.dma.dstfstart1_high.reserved <= rb_dma_dstfstart1_high(31 downto 4);


------------------------------------------------------------------------------------------
-- Field name: GRAB_ADDR(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart1_high(3 downto 0) <= field_rw_dma_dstfstart1_high_GRAB_ADDR(3 downto 0);
regfile.dma.dstfstart1_high.GRAB_ADDR <= field_rw_dma_dstfstart1_high_GRAB_ADDR(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart1_high_GRAB_ADDR
------------------------------------------------------------------------------------------
P_dma_dstfstart1_high_GRAB_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  3 downto 0  loop
         if(wEn(11) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart1_high_GRAB_ADDR(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart1_high_GRAB_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart2_low
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_ADDR(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart2_low(31 downto 0) <= field_rw_dma_dstfstart2_low_GRAB_ADDR(31 downto 0);
regfile.dma.dstfstart2_low.GRAB_ADDR <= field_rw_dma_dstfstart2_low_GRAB_ADDR(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart2_low_GRAB_ADDR
------------------------------------------------------------------------------------------
P_dma_dstfstart2_low_GRAB_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(12) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart2_low_GRAB_ADDR(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart2_low_GRAB_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_dstfstart2_high
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_dma_dstfstart2_high(31 downto 4) <= std_logic_vector(to_unsigned(integer(0),28));
regfile.dma.dstfstart2_high.reserved <= rb_dma_dstfstart2_high(31 downto 4);


------------------------------------------------------------------------------------------
-- Field name: GRAB_ADDR(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_dstfstart2_high(3 downto 0) <= field_rw_dma_dstfstart2_high_GRAB_ADDR(3 downto 0);
regfile.dma.dstfstart2_high.GRAB_ADDR <= field_rw_dma_dstfstart2_high_GRAB_ADDR(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_dstfstart2_high_GRAB_ADDR
------------------------------------------------------------------------------------------
P_dma_dstfstart2_high_GRAB_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      for j in  3 downto 0  loop
         if(wEn(13) = '1' and bitEnN(j) = '0') then
            field_rw_dma_dstfstart2_high_GRAB_ADDR(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_dstfstart2_high_GRAB_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_csc
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: COLOR_SPACE(26 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(26 downto 24) <= field_rw_dma_csc_COLOR_SPACE(2 downto 0);
regfile.dma.csc.COLOR_SPACE <= field_rw_dma_csc_COLOR_SPACE(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_COLOR_SPACE
------------------------------------------------------------------------------------------
P_dma_csc_COLOR_SPACE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_COLOR_SPACE <= std_logic_vector(to_unsigned(integer(0),3));
   elsif (rising_edge(sysclk)) then
      for j in  26 downto 24  loop
         if(wEn(14) = '1' and bitEnN(j) = '0') then
            field_rw_dma_csc_COLOR_SPACE(j-24) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_csc_COLOR_SPACE;

------------------------------------------------------------------------------------------
-- Field name: DUP_LAST_LINE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(23) <= field_rw_dma_csc_DUP_LAST_LINE;
regfile.dma.csc.DUP_LAST_LINE <= field_rw_dma_csc_DUP_LAST_LINE;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_DUP_LAST_LINE
------------------------------------------------------------------------------------------
P_dma_csc_DUP_LAST_LINE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_DUP_LAST_LINE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(14) = '1' and bitEnN(23) = '0') then
         field_rw_dma_csc_DUP_LAST_LINE <= reg_writedata(23);
      end if;
   end if;
end process P_dma_csc_DUP_LAST_LINE;

------------------------------------------------------------------------------------------
-- Field name: MONO10
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(16) <= field_rw_dma_csc_MONO10;
regfile.dma.csc.MONO10 <= field_rw_dma_csc_MONO10;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_MONO10
------------------------------------------------------------------------------------------
P_dma_csc_MONO10 : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_MONO10 <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(14) = '1' and bitEnN(16) = '0') then
         field_rw_dma_csc_MONO10 <= reg_writedata(16);
      end if;
   end if;
end process P_dma_csc_MONO10;

------------------------------------------------------------------------------------------
-- Field name: REVERSE_Y
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(9) <= field_rw_dma_csc_REVERSE_Y;
regfile.dma.csc.REVERSE_Y <= field_rw_dma_csc_REVERSE_Y;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_REVERSE_Y
------------------------------------------------------------------------------------------
P_dma_csc_REVERSE_Y : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_REVERSE_Y <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(14) = '1' and bitEnN(9) = '0') then
         field_rw_dma_csc_REVERSE_Y <= reg_writedata(9);
      end if;
   end if;
end process P_dma_csc_REVERSE_Y;

------------------------------------------------------------------------------------------
-- Field name: GRAB_REVX
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(8) <= field_rw_dma_csc_GRAB_REVX;
regfile.dma.csc.GRAB_REVX <= field_rw_dma_csc_GRAB_REVX;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_GRAB_REVX
------------------------------------------------------------------------------------------
P_dma_csc_GRAB_REVX : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_GRAB_REVX <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(14) = '1' and bitEnN(8) = '0') then
         field_rw_dma_csc_GRAB_REVX <= reg_writedata(8);
      end if;
   end if;
end process P_dma_csc_GRAB_REVX;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: status_active
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: busy
-- Field type: RO
------------------------------------------------------------------------------------------
rb_status_active(0) <= regfile.status.active.busy;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: status_debug
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(16) <= (hit(16)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: GRAB_MAX_ADD(31 downto 2)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_status_debug(31 downto 2) <= field_rw_status_debug_GRAB_MAX_ADD(29 downto 0);
regfile.status.debug.GRAB_MAX_ADD <= field_rw_status_debug_GRAB_MAX_ADD(29 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_status_debug_GRAB_MAX_ADD
------------------------------------------------------------------------------------------
P_status_debug_GRAB_MAX_ADD : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_status_debug_GRAB_MAX_ADD <= std_logic_vector(to_unsigned(integer(1073741823),30));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 2  loop
         if(wEn(16) = '1' and bitEnN(j) = '0') then
            field_rw_status_debug_GRAB_MAX_ADD(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_status_debug_GRAB_MAX_ADD;

------------------------------------------------------------------------------------------
-- Field name: OUT_OF_MEMORY_CLEAR
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_status_debug(1) <= '0';
regfile.status.debug.OUT_OF_MEMORY_CLEAR <= field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR;


------------------------------------------------------------------------------------------
-- Process: P_status_debug_OUT_OF_MEMORY_CLEAR
------------------------------------------------------------------------------------------
P_status_debug_OUT_OF_MEMORY_CLEAR : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(16) = '1' and bitEnN(1) = '0') then
         field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR <= reg_writedata(1);
      else
         field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR <= '0';
      end if;
   end if;
end process P_status_debug_OUT_OF_MEMORY_CLEAR;

------------------------------------------------------------------------------------------
-- Field name: OUT_OF_MEMORY_STAT
-- Field type: RO
------------------------------------------------------------------------------------------
rb_status_debug(0) <= regfile.status.debug.OUT_OF_MEMORY_STAT;


ldData <= reg_read;

end rtl;

