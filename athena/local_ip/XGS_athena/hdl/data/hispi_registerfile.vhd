-------------------------------------------------------------------------------
-- File                : hispi_registerfile.vhd
-- Project             : FDK
-- Module              : regfile_hispi_registerfile_pack
-- Created on          : 2020/04/14 14:10:13
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x5C4A3DCB
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_hispi_registerfile_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_info_tag_ADDR            : natural := 16#0#;
   constant K_info_fid_ADDR            : natural := 16#4#;
   constant K_info_version_ADDR        : natural := 16#8#;
   constant K_info_capability_ADDR     : natural := 16#c#;
   constant K_info_scratchpad_ADDR     : natural := 16#10#;
   constant K_core_ctrl_ADDR           : natural := 16#30#;
   constant K_core_pixels_per_line_ADDR : natural := 16#34#;
   constant K_core_line_per_frame_ADDR : natural := 16#38#;
   constant K_phy_ctrl_ADDR            : natural := 16#40#;
   constant K_phy_status_ADDR          : natural := 16#44#;
   
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
   type CORE_CTRL_TYPE is record
      capture_enable : std_logic;
      reset          : std_logic;
   end record CORE_CTRL_TYPE;

   constant INIT_CORE_CTRL_TYPE : CORE_CTRL_TYPE := (
      capture_enable  => 'Z',
      reset           => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : CORE_CTRL_TYPE) return std_logic_vector;
   function to_CORE_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: pixels_per_line
   ------------------------------------------------------------------------------------------
   type CORE_PIXELS_PER_LINE_TYPE is record
      value          : std_logic_vector(15 downto 0);
   end record CORE_PIXELS_PER_LINE_TYPE;

   constant INIT_CORE_PIXELS_PER_LINE_TYPE : CORE_PIXELS_PER_LINE_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : CORE_PIXELS_PER_LINE_TYPE) return std_logic_vector;
   function to_CORE_PIXELS_PER_LINE_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_PIXELS_PER_LINE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: line_per_frame
   ------------------------------------------------------------------------------------------
   type CORE_LINE_PER_FRAME_TYPE is record
      value          : std_logic_vector(15 downto 0);
   end record CORE_LINE_PER_FRAME_TYPE;

   constant INIT_CORE_LINE_PER_FRAME_TYPE : CORE_LINE_PER_FRAME_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : CORE_LINE_PER_FRAME_TYPE) return std_logic_vector;
   function to_CORE_LINE_PER_FRAME_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_LINE_PER_FRAME_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type PHY_CTRL_TYPE is record
      reset_idelayctrl: std_logic;
   end record PHY_CTRL_TYPE;

   constant INIT_PHY_CTRL_TYPE : PHY_CTRL_TYPE := (
      reset_idelayctrl => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : PHY_CTRL_TYPE) return std_logic_vector;
   function to_PHY_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return PHY_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: status
   ------------------------------------------------------------------------------------------
   type PHY_STATUS_TYPE is record
      pll_locked     : std_logic;
   end record PHY_STATUS_TYPE;

   constant INIT_PHY_STATUS_TYPE : PHY_STATUS_TYPE := (
      pll_locked      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : PHY_STATUS_TYPE) return std_logic_vector;
   function to_PHY_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return PHY_STATUS_TYPE;
   
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
   -- Section Name: core
   ------------------------------------------------------------------------------------------
   type CORE_TYPE is record
      ctrl           : CORE_CTRL_TYPE;
      pixels_per_line: CORE_PIXELS_PER_LINE_TYPE;
      line_per_frame : CORE_LINE_PER_FRAME_TYPE;
   end record CORE_TYPE;

   constant INIT_CORE_TYPE : CORE_TYPE := (
      ctrl            => INIT_CORE_CTRL_TYPE,
      pixels_per_line => INIT_CORE_PIXELS_PER_LINE_TYPE,
      line_per_frame  => INIT_CORE_LINE_PER_FRAME_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: phy
   ------------------------------------------------------------------------------------------
   type PHY_TYPE is record
      ctrl           : PHY_CTRL_TYPE;
      status         : PHY_STATUS_TYPE;
   end record PHY_TYPE;

   constant INIT_PHY_TYPE : PHY_TYPE := (
      ctrl            => INIT_PHY_CTRL_TYPE,
      status          => INIT_PHY_STATUS_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_hispi_registerfile
   ------------------------------------------------------------------------------------------
   type REGFILE_HISPI_REGISTERFILE_TYPE is record
      info           : INFO_TYPE;
      core           : CORE_TYPE;
      phy            : PHY_TYPE;
   end record REGFILE_HISPI_REGISTERFILE_TYPE;

   constant INIT_REGFILE_HISPI_REGISTERFILE_TYPE : REGFILE_HISPI_REGISTERFILE_TYPE := (
      info            => INIT_INFO_TYPE,
      core            => INIT_CORE_TYPE,
      phy             => INIT_PHY_TYPE
   );

   
end regfile_hispi_registerfile_pack;

package body regfile_hispi_registerfile_pack is
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
   -- Description: Cast from CORE_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : CORE_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.capture_enable;
      output(1) := reg.reset;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_CORE_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to CORE_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_CORE_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_CTRL_TYPE is
   variable output : CORE_CTRL_TYPE;
   begin
      output.capture_enable := stdlv(0);
      output.reset := stdlv(1);
      return output;
   end to_CORE_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from CORE_PIXELS_PER_LINE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : CORE_PIXELS_PER_LINE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_CORE_PIXELS_PER_LINE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to CORE_PIXELS_PER_LINE_TYPE
   --------------------------------------------------------------------------------
   function to_CORE_PIXELS_PER_LINE_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_PIXELS_PER_LINE_TYPE is
   variable output : CORE_PIXELS_PER_LINE_TYPE;
   begin
      output.value := stdlv(15 downto 0);
      return output;
   end to_CORE_PIXELS_PER_LINE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from CORE_LINE_PER_FRAME_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : CORE_LINE_PER_FRAME_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_CORE_LINE_PER_FRAME_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to CORE_LINE_PER_FRAME_TYPE
   --------------------------------------------------------------------------------
   function to_CORE_LINE_PER_FRAME_TYPE(stdlv : std_logic_vector(31 downto 0)) return CORE_LINE_PER_FRAME_TYPE is
   variable output : CORE_LINE_PER_FRAME_TYPE;
   begin
      output.value := stdlv(15 downto 0);
      return output;
   end to_CORE_LINE_PER_FRAME_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from PHY_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : PHY_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.reset_idelayctrl;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_PHY_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to PHY_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_PHY_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return PHY_CTRL_TYPE is
   variable output : PHY_CTRL_TYPE;
   begin
      output.reset_idelayctrl := stdlv(0);
      return output;
   end to_PHY_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from PHY_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : PHY_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.pll_locked;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_PHY_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to PHY_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_PHY_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return PHY_STATUS_TYPE is
   variable output : PHY_STATUS_TYPE;
   begin
      output.pll_locked := stdlv(0);
      return output;
   end to_PHY_STATUS_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : hispi_registerfile.vhd
-- Project             : FDK
-- Module              : regfile_hispi_registerfile
-- Created on          : 2020/04/14 14:10:13
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x5C4A3DCB
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_hispi_registerfile_pack.all;


entity regfile_hispi_registerfile is
   
   port (
      resetN        : in    std_logic;                                                               -- System reset
      sysclk        : in    std_logic;                                                               -- System clock
      regfile       : inout REGFILE_HISPI_REGISTERFILE_TYPE := INIT_REGFILE_HISPI_REGISTERFILE_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                                               -- Read
      reg_write     : in    std_logic;                                                               -- Write
      reg_addr      : in    std_logic_vector(7 downto 2);                                            -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                                            -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);                                           -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                                            -- Read data
   );
   
end regfile_hispi_registerfile;

architecture rtl of regfile_hispi_registerfile is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                         : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                 : std_logic_vector(9 downto 0);                    -- Address decode hit
signal wEn                                 : std_logic_vector(9 downto 0);                    -- Write Enable
signal fullAddr                            : std_logic_vector(7 downto 0):= (others => '0');  -- Full Address
signal fullAddrAsInt                       : integer;                                        
signal bitEnN                              : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                              : std_logic;                                      
signal rb_info_tag                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_fid                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_version                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_capability                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_scratchpad                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_core_ctrl                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_core_pixels_per_line             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_core_line_per_frame              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_phy_ctrl                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_phy_status                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_info_scratchpad_value      : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_core_ctrl_capture_enable   : std_logic;                                       -- Field: capture_enable
signal field_rw_core_ctrl_reset            : std_logic;                                       -- Field: reset
signal field_rw_core_pixels_per_line_value : std_logic_vector(15 downto 0);                   -- Field: value
signal field_rw_core_line_per_frame_value  : std_logic_vector(15 downto 0);                   -- Field: value
signal field_rw_phy_ctrl_reset_idelayctrl  : std_logic;                                       -- Field: reset_idelayctrl

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

hit(0) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,8)))	else '0'; -- Addr:  0x0000	tag
hit(1) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,8)))	else '0'; -- Addr:  0x0004	fid
hit(2) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,8)))	else '0'; -- Addr:  0x0008	version
hit(3) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,8)))	else '0'; -- Addr:  0x000C	capability
hit(4) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,8)))	else '0'; -- Addr:  0x0010	scratchpad
hit(5) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#30#,8)))	else '0'; -- Addr:  0x0030	ctrl
hit(6) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#34#,8)))	else '0'; -- Addr:  0x0034	pixels_per_line
hit(7) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#38#,8)))	else '0'; -- Addr:  0x0038	line_per_frame
hit(8) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,8)))	else '0'; -- Addr:  0x0040	ctrl
hit(9) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#44#,8)))	else '0'; -- Addr:  0x0044	status



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
                            rb_core_ctrl,
                            rb_core_pixels_per_line,
                            rb_core_line_per_frame,
                            rb_phy_ctrl,
                            rb_phy_status
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

      -- [0x30]: /core/ctrl
      when 16#30# =>
         readBackMux <= rb_core_ctrl;

      -- [0x34]: /core/pixels_per_line
      when 16#34# =>
         readBackMux <= rb_core_pixels_per_line;

      -- [0x38]: /core/line_per_frame
      when 16#38# =>
         readBackMux <= rb_core_line_per_frame;

      -- [0x40]: /phy/ctrl
      when 16#40# =>
         readBackMux <= rb_phy_ctrl;

      -- [0x44]: /phy/status
      when 16#44# =>
         readBackMux <= rb_phy_status;

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
-- Register name: core_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: capture_enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_core_ctrl(0) <= field_rw_core_ctrl_capture_enable;
regfile.core.ctrl.capture_enable <= field_rw_core_ctrl_capture_enable;


------------------------------------------------------------------------------------------
-- Process: P_core_ctrl_capture_enable
------------------------------------------------------------------------------------------
P_core_ctrl_capture_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_core_ctrl_capture_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(5) = '1' and bitEnN(0) = '0') then
         field_rw_core_ctrl_capture_enable <= reg_writedata(0);
      end if;
   end if;
end process P_core_ctrl_capture_enable;

------------------------------------------------------------------------------------------
-- Field name: reset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_core_ctrl(1) <= field_rw_core_ctrl_reset;
regfile.core.ctrl.reset <= field_rw_core_ctrl_reset;


------------------------------------------------------------------------------------------
-- Process: P_core_ctrl_reset
------------------------------------------------------------------------------------------
P_core_ctrl_reset : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_core_ctrl_reset <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(5) = '1' and bitEnN(1) = '0') then
         field_rw_core_ctrl_reset <= reg_writedata(1);
      end if;
   end if;
end process P_core_ctrl_reset;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: core_pixels_per_line
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_core_pixels_per_line(15 downto 0) <= field_rw_core_pixels_per_line_value(15 downto 0);
regfile.core.pixels_per_line.value <= field_rw_core_pixels_per_line_value(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_core_pixels_per_line_value
------------------------------------------------------------------------------------------
P_core_pixels_per_line_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_core_pixels_per_line_value <= std_logic_vector(to_unsigned(integer(0),16));
   elsif (rising_edge(sysclk)) then
      for j in  15 downto 0  loop
         if(wEn(6) = '1' and bitEnN(j) = '0') then
            field_rw_core_pixels_per_line_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_core_pixels_per_line_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: core_line_per_frame
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(15 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_core_line_per_frame(15 downto 0) <= field_rw_core_line_per_frame_value(15 downto 0);
regfile.core.line_per_frame.value <= field_rw_core_line_per_frame_value(15 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_core_line_per_frame_value
------------------------------------------------------------------------------------------
P_core_line_per_frame_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_core_line_per_frame_value <= std_logic_vector(to_unsigned(integer(0),16));
   elsif (rising_edge(sysclk)) then
      for j in  15 downto 0  loop
         if(wEn(7) = '1' and bitEnN(j) = '0') then
            field_rw_core_line_per_frame_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_core_line_per_frame_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: phy_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reset_idelayctrl
-- Field type: RW
------------------------------------------------------------------------------------------
rb_phy_ctrl(0) <= field_rw_phy_ctrl_reset_idelayctrl;
regfile.phy.ctrl.reset_idelayctrl <= field_rw_phy_ctrl_reset_idelayctrl;


------------------------------------------------------------------------------------------
-- Process: P_phy_ctrl_reset_idelayctrl
------------------------------------------------------------------------------------------
P_phy_ctrl_reset_idelayctrl : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_phy_ctrl_reset_idelayctrl <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(8) = '1' and bitEnN(0) = '0') then
         field_rw_phy_ctrl_reset_idelayctrl <= reg_writedata(0);
      end if;
   end if;
end process P_phy_ctrl_reset_idelayctrl;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: phy_status
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: pll_locked
-- Field type: RO
------------------------------------------------------------------------------------------
rb_phy_status(0) <= regfile.phy.status.pll_locked;


ldData <= reg_read;

end rtl;

