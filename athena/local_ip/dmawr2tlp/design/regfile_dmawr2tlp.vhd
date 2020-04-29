-------------------------------------------------------------------------------
-- File                : dmawr2tlp.vhd
-- Project             : FDK
-- Module              : regfile_dmawr2tlp_pack
-- Created on          : 2020/04/23 12:39:55
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x7A6095C5
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_dmawr2tlp_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_info_tag_ADDR           : natural := 16#0#;
   constant K_info_fid_ADDR           : natural := 16#4#;
   constant K_info_version_ADDR       : natural := 16#8#;
   constant K_info_capability_ADDR    : natural := 16#c#;
   constant K_info_scratchpad_ADDR    : natural := 16#10#;
   constant K_dma_ctrl_ADDR           : natural := 16#40#;
   constant K_dma_status_ADDR         : natural := 16#4c#;
   constant K_dma_frame_start_0_ADDR  : natural := 16#50#;
   constant K_dma_frame_start_1_ADDR  : natural := 16#54#;
   constant K_dma_frame_start_g_0_ADDR : natural := 16#58#;
   constant K_dma_frame_start_g_1_ADDR : natural := 16#5c#;
   constant K_dma_frame_start_r_0_ADDR : natural := 16#60#;
   constant K_dma_frame_start_r_1_ADDR : natural := 16#64#;
   constant K_dma_line_size_ADDR      : natural := 16#68#;
   constant K_dma_line_pitch_ADDR     : natural := 16#6c#;
   constant K_dma_csc_ADDR            : natural := 16#70#;
   constant K_status_debug_ADDR       : natural := 16#c0#;
   
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
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_TAG_TYPE;
   
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
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_FID_TYPE;
   
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
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_VERSION_TYPE;
   
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
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_CAPABILITY_TYPE;
   
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
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCHPAD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type DMA_CTRL_TYPE is record
      grab_queue_enable: std_logic;
      enable         : std_logic;
   end record DMA_CTRL_TYPE;

   constant INIT_DMA_CTRL_TYPE : DMA_CTRL_TYPE := (
      grab_queue_enable => 'Z',
      enable          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CTRL_TYPE) return std_logic_vector;
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: status
   ------------------------------------------------------------------------------------------
   type DMA_STATUS_TYPE is record
      busy           : std_logic;
   end record DMA_STATUS_TYPE;

   constant INIT_DMA_STATUS_TYPE : DMA_STATUS_TYPE := (
      busy            => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_STATUS_TYPE) return std_logic_vector;
   function to_DMA_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_STATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: frame_start
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DMA_FRAME_START_TYPE;

   constant INIT_DMA_FRAME_START_TYPE : DMA_FRAME_START_TYPE := (
      value           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: DMA_FRAME_START_TYPE
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_TYPE_ARRAY is array (1 downto 0) of DMA_FRAME_START_TYPE;
   constant INIT_DMA_FRAME_START_TYPE_ARRAY : DMA_FRAME_START_TYPE_ARRAY := (others => INIT_DMA_FRAME_START_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FRAME_START_TYPE) return std_logic_vector;
   function to_DMA_FRAME_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: frame_start_g
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_G_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DMA_FRAME_START_G_TYPE;

   constant INIT_DMA_FRAME_START_G_TYPE : DMA_FRAME_START_G_TYPE := (
      value           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: DMA_FRAME_START_G_TYPE
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_G_TYPE_ARRAY is array (1 downto 0) of DMA_FRAME_START_G_TYPE;
   constant INIT_DMA_FRAME_START_G_TYPE_ARRAY : DMA_FRAME_START_G_TYPE_ARRAY := (others => INIT_DMA_FRAME_START_G_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FRAME_START_G_TYPE) return std_logic_vector;
   function to_DMA_FRAME_START_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_G_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: frame_start_r
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_R_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DMA_FRAME_START_R_TYPE;

   constant INIT_DMA_FRAME_START_R_TYPE : DMA_FRAME_START_R_TYPE := (
      value           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: DMA_FRAME_START_R_TYPE
   ------------------------------------------------------------------------------------------
   type DMA_FRAME_START_R_TYPE_ARRAY is array (1 downto 0) of DMA_FRAME_START_R_TYPE;
   constant INIT_DMA_FRAME_START_R_TYPE_ARRAY : DMA_FRAME_START_R_TYPE_ARRAY := (others => INIT_DMA_FRAME_START_R_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : DMA_FRAME_START_R_TYPE) return std_logic_vector;
   function to_DMA_FRAME_START_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_R_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: line_size
   ------------------------------------------------------------------------------------------
   type DMA_LINE_SIZE_TYPE is record
      value          : std_logic_vector(13 downto 0);
   end record DMA_LINE_SIZE_TYPE;

   constant INIT_DMA_LINE_SIZE_TYPE : DMA_LINE_SIZE_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_LINE_SIZE_TYPE) return std_logic_vector;
   function to_DMA_LINE_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_SIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: line_pitch
   ------------------------------------------------------------------------------------------
   type DMA_LINE_PITCH_TYPE is record
      value          : std_logic_vector(15 downto 0);
   end record DMA_LINE_PITCH_TYPE;

   constant INIT_DMA_LINE_PITCH_TYPE : DMA_LINE_PITCH_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_LINE_PITCH_TYPE) return std_logic_vector;
   function to_DMA_LINE_PITCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_PITCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: csc
   ------------------------------------------------------------------------------------------
   type DMA_CSC_TYPE is record
      color_space    : std_logic_vector(2 downto 0);
      duplicate_last_line: std_logic;
      reverse_y      : std_logic;
      reverse_x      : std_logic;
   end record DMA_CSC_TYPE;

   constant INIT_DMA_CSC_TYPE : DMA_CSC_TYPE := (
      color_space     => (others=> 'Z'),
      duplicate_last_line => 'Z',
      reverse_y       => 'Z',
      reverse_x       => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector;
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CSC_TYPE;
   
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
   function to_STATUS_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return STATUS_DEBUG_TYPE;
   
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
      status         : DMA_STATUS_TYPE;
      frame_start    : DMA_FRAME_START_TYPE_ARRAY;
      frame_start_g  : DMA_FRAME_START_G_TYPE_ARRAY;
      frame_start_r  : DMA_FRAME_START_R_TYPE_ARRAY;
      line_size      : DMA_LINE_SIZE_TYPE;
      line_pitch     : DMA_LINE_PITCH_TYPE;
      csc            : DMA_CSC_TYPE;
   end record DMA_TYPE;

   constant INIT_DMA_TYPE : DMA_TYPE := (
      ctrl            => INIT_DMA_CTRL_TYPE,
      status          => INIT_DMA_STATUS_TYPE,
      frame_start     => INIT_DMA_FRAME_START_TYPE_ARRAY,
      frame_start_g   => INIT_DMA_FRAME_START_G_TYPE_ARRAY,
      frame_start_r   => INIT_DMA_FRAME_START_R_TYPE_ARRAY,
      line_size       => INIT_DMA_LINE_SIZE_TYPE,
      line_pitch      => INIT_DMA_LINE_PITCH_TYPE,
      csc             => INIT_DMA_CSC_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: status
   ------------------------------------------------------------------------------------------
   type STATUS_TYPE is record
      debug          : STATUS_DEBUG_TYPE;
   end record STATUS_TYPE;

   constant INIT_STATUS_TYPE : STATUS_TYPE := (
      debug           => INIT_STATUS_DEBUG_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_dmawr2tlp
   ------------------------------------------------------------------------------------------
   type REGFILE_DMAWR2TLP_TYPE is record
      info           : INFO_TYPE;
      dma            : DMA_TYPE;
      status         : STATUS_TYPE;
   end record REGFILE_DMAWR2TLP_TYPE;

   constant INIT_REGFILE_DMAWR2TLP_TYPE : REGFILE_DMAWR2TLP_TYPE := (
      info            => INIT_INFO_TYPE,
      dma             => INIT_DMA_TYPE,
      status          => INIT_STATUS_TYPE
   );

   
end regfile_dmawr2tlp_pack;

package body regfile_dmawr2tlp_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_TAG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_TAG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_TAG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_TAG_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_TAG_TYPE is
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
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_FID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_FID_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_FID_TYPE is
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
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.major;
      output(15 downto 8) := reg.minor;
      output(7 downto 0) := reg.hw;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_VERSION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_VERSION_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_VERSION_TYPE is
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
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_CAPABILITY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_CAPABILITY_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_CAPABILITY_TYPE is
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
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_SCRATCHPAD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_SCRATCHPAD_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCHPAD_TYPE is
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
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(1) := reg.grab_queue_enable;
      output(0) := reg.enable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CTRL_TYPE is
   variable output : DMA_CTRL_TYPE;
   begin
      output.grab_queue_enable := stdlv(1);
      output.enable := stdlv(0);
      return output;
   end to_DMA_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.busy;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_STATUS_TYPE is
   variable output : DMA_STATUS_TYPE;
   begin
      output.busy := stdlv(0);
      return output;
   end to_DMA_STATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FRAME_START_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FRAME_START_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FRAME_START_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FRAME_START_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FRAME_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_TYPE is
   variable output : DMA_FRAME_START_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DMA_FRAME_START_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FRAME_START_G_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FRAME_START_G_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FRAME_START_G_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FRAME_START_G_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FRAME_START_G_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_G_TYPE is
   variable output : DMA_FRAME_START_G_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DMA_FRAME_START_G_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_FRAME_START_R_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_FRAME_START_R_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_FRAME_START_R_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_FRAME_START_R_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_FRAME_START_R_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_FRAME_START_R_TYPE is
   variable output : DMA_FRAME_START_R_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DMA_FRAME_START_R_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_LINE_SIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_LINE_SIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(13 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_LINE_SIZE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_LINE_SIZE_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_LINE_SIZE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_SIZE_TYPE is
   variable output : DMA_LINE_SIZE_TYPE;
   begin
      output.value := stdlv(13 downto 0);
      return output;
   end to_DMA_LINE_SIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_LINE_PITCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_LINE_PITCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_LINE_PITCH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_LINE_PITCH_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_LINE_PITCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_LINE_PITCH_TYPE is
   variable output : DMA_LINE_PITCH_TYPE;
   begin
      output.value := stdlv(15 downto 0);
      return output;
   end to_DMA_LINE_PITCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DMA_CSC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DMA_CSC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(26 downto 24) := reg.color_space;
      output(23) := reg.duplicate_last_line;
      output(9) := reg.reverse_y;
      output(8) := reg.reverse_x;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DMA_CSC_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DMA_CSC_TYPE
   --------------------------------------------------------------------------------
   function to_DMA_CSC_TYPE(stdlv : std_logic_vector(31 downto 0)) return DMA_CSC_TYPE is
   variable output : DMA_CSC_TYPE;
   begin
      output.color_space := stdlv(26 downto 24);
      output.duplicate_last_line := stdlv(23);
      output.reverse_y := stdlv(9);
      output.reverse_x := stdlv(8);
      return output;
   end to_DMA_CSC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from STATUS_DEBUG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : STATUS_DEBUG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 2) := reg.GRAB_MAX_ADD;
      output(1) := reg.OUT_OF_MEMORY_CLEAR;
      output(0) := reg.OUT_OF_MEMORY_STAT;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_STATUS_DEBUG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to STATUS_DEBUG_TYPE
   --------------------------------------------------------------------------------
   function to_STATUS_DEBUG_TYPE(stdlv : std_logic_vector(31 downto 0)) return STATUS_DEBUG_TYPE is
   variable output : STATUS_DEBUG_TYPE;
   begin
      output.GRAB_MAX_ADD := stdlv(31 downto 2);
      output.OUT_OF_MEMORY_CLEAR := stdlv(1);
      output.OUT_OF_MEMORY_STAT := stdlv(0);
      return output;
   end to_STATUS_DEBUG_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_dmawr2tlp.vhd
-- Project             : FDK
-- Module              : regfile_dmawr2tlp
-- Created on          : 2020/04/23 12:39:55
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x7A6095C5
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_dmawr2tlp_pack.all;


entity regfile_dmawr2tlp is
   
   port (
      resetN        : in    std_logic;                                             -- System reset
      sysclk        : in    std_logic;                                             -- System clock
      regfile       : inout REGFILE_DMAWR2TLP_TYPE := INIT_REGFILE_DMAWR2TLP_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                             -- Read
      reg_write     : in    std_logic;                                             -- Write
      reg_addr      : in    std_logic_vector(7 downto 2);                          -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                          -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);                         -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                          -- Read data
   );
   
end regfile_dmawr2tlp;

architecture rtl of regfile_dmawr2tlp is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                     : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                             : std_logic_vector(16 downto 0);                   -- Address decode hit
signal wEn                                             : std_logic_vector(16 downto 0);                   -- Write Enable
signal fullAddr                                        : std_logic_vector(7 downto 0):= (others => '0');  -- Full Address
signal fullAddrAsInt                                   : integer;                                        
signal bitEnN                                          : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                          : std_logic;                                      
signal rb_info_tag                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_fid                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_version                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_capability                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_scratchpad                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_ctrl                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_status                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_0                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_1                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_g_0                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_g_1                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_r_0                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_frame_start_r_1                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_line_size                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_line_pitch                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_dma_csc                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_status_debug                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_info_scratchpad_value                  : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_ctrl_grab_queue_enable             : std_logic;                                       -- Field: grab_queue_enable
signal field_rw_dma_ctrl_enable                        : std_logic;                                       -- Field: enable
signal field_rw_dma_frame_start_0_value                : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_frame_start_1_value                : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_frame_start_g_0_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_frame_start_g_1_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_frame_start_r_0_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_frame_start_r_1_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_dma_line_size_value                    : std_logic_vector(13 downto 0);                   -- Field: value
signal field_rw_dma_line_pitch_value                   : std_logic_vector(15 downto 0);                   -- Field: value
signal field_rw_dma_csc_color_space                    : std_logic_vector(2 downto 0);                    -- Field: color_space
signal field_rw_dma_csc_duplicate_last_line            : std_logic;                                       -- Field: duplicate_last_line
signal field_rw_dma_csc_reverse_y                      : std_logic;                                       -- Field: reverse_y
signal field_rw_dma_csc_reverse_x                      : std_logic;                                       -- Field: reverse_x
signal field_rw_status_debug_GRAB_MAX_ADD              : std_logic_vector(29 downto 0);                   -- Field: GRAB_MAX_ADD
signal field_wautoclr_status_debug_OUT_OF_MEMORY_CLEAR : std_logic;                                       -- Field: OUT_OF_MEMORY_CLEAR

begin -- rtl

------------------------------------------------------------------------------------------
-- Process: P_bitEnN
------------------------------------------------------------------------------------------
P_bitEnN : process(reg_beN)
begin
   for i in 3 downto 0 loop
      for j in 7 downto 0 loop
         bitEnN(i*8+j) <= reg_beN(i);
      end loop;
   end loop;
end process P_bitEnN;

--------------------------------------------------------------------------------
-- Address decoding logic
--------------------------------------------------------------------------------
fullAddr(7 downto 2)<= reg_addr;

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,8)))	else '0'; -- Addr:  0x0000	tag
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,8)))	else '0'; -- Addr:  0x0004	fid
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,8)))	else '0'; -- Addr:  0x0008	version
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,8)))	else '0'; -- Addr:  0x000C	capability
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,8)))	else '0'; -- Addr:  0x0010	scratchpad
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,8)))	else '0'; -- Addr:  0x0040	ctrl
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c#,8)))	else '0'; -- Addr:  0x004C	status
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#50#,8)))	else '0'; -- Addr:  0x0050	frame_start[0]
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#54#,8)))	else '0'; -- Addr:  0x0054	frame_start[1]
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#58#,8)))	else '0'; -- Addr:  0x0058	frame_start_g[0]
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#5c#,8)))	else '0'; -- Addr:  0x005C	frame_start_g[1]
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#60#,8)))	else '0'; -- Addr:  0x0060	frame_start_r[0]
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#64#,8)))	else '0'; -- Addr:  0x0064	frame_start_r[1]
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#68#,8)))	else '0'; -- Addr:  0x0068	line_size
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#6c#,8)))	else '0'; -- Addr:  0x006C	line_pitch
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,8)))	else '0'; -- Addr:  0x0070	csc
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c0#,8)))	else '0'; -- Addr:  0x00C0	debug



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
                            rb_dma_status,
                            rb_dma_frame_start_0,
                            rb_dma_frame_start_1,
                            rb_dma_frame_start_g_0,
                            rb_dma_frame_start_g_1,
                            rb_dma_frame_start_r_0,
                            rb_dma_frame_start_r_1,
                            rb_dma_line_size,
                            rb_dma_line_pitch,
                            rb_dma_csc,
                            rb_status_debug
                           )
begin
   case fullAddrAsInt is
      -- [0x00]: /info/tag
      when 16#0# =>
         readBackMux <= rb_info_tag;

      -- [0x04]: /info/fid
      when 16#4# =>
         readBackMux <= rb_info_fid;

      -- [0x08]: /info/version
      when 16#8# =>
         readBackMux <= rb_info_version;

      -- [0x0c]: /info/capability
      when 16#C# =>
         readBackMux <= rb_info_capability;

      -- [0x10]: /info/scratchpad
      when 16#10# =>
         readBackMux <= rb_info_scratchpad;

      -- [0x40]: /dma/ctrl
      when 16#40# =>
         readBackMux <= rb_dma_ctrl;

      -- [0x4c]: /dma/status
      when 16#4C# =>
         readBackMux <= rb_dma_status;

      -- [0x50]: /dma/frame_start_0
      when 16#50# =>
         readBackMux <= rb_dma_frame_start_0;

      -- [0x54]: /dma/frame_start_1
      when 16#54# =>
         readBackMux <= rb_dma_frame_start_1;

      -- [0x58]: /dma/frame_start_g_0
      when 16#58# =>
         readBackMux <= rb_dma_frame_start_g_0;

      -- [0x5c]: /dma/frame_start_g_1
      when 16#5C# =>
         readBackMux <= rb_dma_frame_start_g_1;

      -- [0x60]: /dma/frame_start_r_0
      when 16#60# =>
         readBackMux <= rb_dma_frame_start_r_0;

      -- [0x64]: /dma/frame_start_r_1
      when 16#64# =>
         readBackMux <= rb_dma_frame_start_r_1;

      -- [0x68]: /dma/line_size
      when 16#68# =>
         readBackMux <= rb_dma_line_size;

      -- [0x6c]: /dma/line_pitch
      when 16#6C# =>
         readBackMux <= rb_dma_line_pitch;

      -- [0x70]: /dma/csc
      when 16#70# =>
         readBackMux <= rb_dma_csc;

      -- [0xc0]: /status/debug
      when 16#C0# =>
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
rb_info_version(23 downto 16) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.info.version.major <= rb_info_version(23 downto 16);


------------------------------------------------------------------------------------------
-- Field name: minor
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(15 downto 8) <= std_logic_vector(to_unsigned(integer(1),8));
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
-- Field name: grab_queue_enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_ctrl(1) <= field_rw_dma_ctrl_grab_queue_enable;
regfile.dma.ctrl.grab_queue_enable <= field_rw_dma_ctrl_grab_queue_enable;


------------------------------------------------------------------------------------------
-- Process: P_dma_ctrl_grab_queue_enable
------------------------------------------------------------------------------------------
P_dma_ctrl_grab_queue_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_ctrl_grab_queue_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(5) = '1' and bitEnN(1) = '0') then
         field_rw_dma_ctrl_grab_queue_enable <= reg_writedata(1);
      end if;
   end if;
end process P_dma_ctrl_grab_queue_enable;

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
-- Register name: dma_status
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: busy
-- Field type: RO
------------------------------------------------------------------------------------------
rb_dma_status(0) <= regfile.dma.status.busy;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_0(31 downto 0) <= field_rw_dma_frame_start_0_value(31 downto 0);
regfile.dma.frame_start(0).value <= field_rw_dma_frame_start_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_0_value
------------------------------------------------------------------------------------------
P_dma_frame_start_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_0_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(7) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_0_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_1(31 downto 0) <= field_rw_dma_frame_start_1_value(31 downto 0);
regfile.dma.frame_start(1).value <= field_rw_dma_frame_start_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_1_value
------------------------------------------------------------------------------------------
P_dma_frame_start_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_1_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(8) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_1_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_g_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_g_0(31 downto 0) <= field_rw_dma_frame_start_g_0_value(31 downto 0);
regfile.dma.frame_start_g(0).value <= field_rw_dma_frame_start_g_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_g_0_value
------------------------------------------------------------------------------------------
P_dma_frame_start_g_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_g_0_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(9) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_g_0_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_g_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_g_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_g_1(31 downto 0) <= field_rw_dma_frame_start_g_1_value(31 downto 0);
regfile.dma.frame_start_g(1).value <= field_rw_dma_frame_start_g_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_g_1_value
------------------------------------------------------------------------------------------
P_dma_frame_start_g_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_g_1_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(10) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_g_1_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_g_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_r_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_r_0(31 downto 0) <= field_rw_dma_frame_start_r_0_value(31 downto 0);
regfile.dma.frame_start_r(0).value <= field_rw_dma_frame_start_r_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_r_0_value
------------------------------------------------------------------------------------------
P_dma_frame_start_r_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_r_0_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(11) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_r_0_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_r_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_frame_start_r_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_frame_start_r_1(31 downto 0) <= field_rw_dma_frame_start_r_1_value(31 downto 0);
regfile.dma.frame_start_r(1).value <= field_rw_dma_frame_start_r_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_frame_start_r_1_value
------------------------------------------------------------------------------------------
P_dma_frame_start_r_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_frame_start_r_1_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(12) = '1' and bitEnN(j) = '0') then
            field_rw_dma_frame_start_r_1_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_frame_start_r_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_line_size
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(13 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_line_size(13 downto 0) <= field_rw_dma_line_size_value(13 downto 0);
regfile.dma.line_size.value <= field_rw_dma_line_size_value(13 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_line_size_value
------------------------------------------------------------------------------------------
P_dma_line_size_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_line_size_value <= std_logic_vector(to_unsigned(integer(0),14));
   elsif (rising_edge(sysclk)) then
      for j in  13 downto 0  loop
         if(wEn(13) = '1' and bitEnN(j) = '0') then
            field_rw_dma_line_size_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_line_size_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_line_pitch
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_line_pitch(15 downto 0) <= field_rw_dma_line_pitch_value(15 downto 0);
regfile.dma.line_pitch.value <= field_rw_dma_line_pitch_value(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_line_pitch_value
------------------------------------------------------------------------------------------
P_dma_line_pitch_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_line_pitch_value <= std_logic_vector(to_unsigned(integer(0),16));
   elsif (rising_edge(sysclk)) then
      for j in  15 downto 0  loop
         if(wEn(14) = '1' and bitEnN(j) = '0') then
            field_rw_dma_line_pitch_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_line_pitch_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: dma_csc
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: color_space(26 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(26 downto 24) <= field_rw_dma_csc_color_space(2 downto 0);
regfile.dma.csc.color_space <= field_rw_dma_csc_color_space(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_color_space
------------------------------------------------------------------------------------------
P_dma_csc_color_space : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_color_space <= std_logic_vector(to_unsigned(integer(0),3));
   elsif (rising_edge(sysclk)) then
      for j in  26 downto 24  loop
         if(wEn(15) = '1' and bitEnN(j) = '0') then
            field_rw_dma_csc_color_space(j-24) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_dma_csc_color_space;

------------------------------------------------------------------------------------------
-- Field name: duplicate_last_line
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(23) <= field_rw_dma_csc_duplicate_last_line;
regfile.dma.csc.duplicate_last_line <= field_rw_dma_csc_duplicate_last_line;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_duplicate_last_line
------------------------------------------------------------------------------------------
P_dma_csc_duplicate_last_line : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_duplicate_last_line <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(23) = '0') then
         field_rw_dma_csc_duplicate_last_line <= reg_writedata(23);
      end if;
   end if;
end process P_dma_csc_duplicate_last_line;

------------------------------------------------------------------------------------------
-- Field name: reverse_y
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(9) <= field_rw_dma_csc_reverse_y;
regfile.dma.csc.reverse_y <= field_rw_dma_csc_reverse_y;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_reverse_y
------------------------------------------------------------------------------------------
P_dma_csc_reverse_y : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_reverse_y <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(9) = '0') then
         field_rw_dma_csc_reverse_y <= reg_writedata(9);
      end if;
   end if;
end process P_dma_csc_reverse_y;

------------------------------------------------------------------------------------------
-- Field name: reverse_x
-- Field type: RW
------------------------------------------------------------------------------------------
rb_dma_csc(8) <= field_rw_dma_csc_reverse_x;
regfile.dma.csc.reverse_x <= field_rw_dma_csc_reverse_x;


------------------------------------------------------------------------------------------
-- Process: P_dma_csc_reverse_x
------------------------------------------------------------------------------------------
P_dma_csc_reverse_x : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_dma_csc_reverse_x <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(8) = '0') then
         field_rw_dma_csc_reverse_x <= reg_writedata(8);
      end if;
   end if;
end process P_dma_csc_reverse_x;



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

