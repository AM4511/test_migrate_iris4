-------------------------------------------------------------------------------
-- File    : regfile_miox.vhd
-- Project : FDK
-- Module  : regfile_miox_pack
-- Created on : 2018/10/30 10:44:38
-- Created by : amarchan
-- FDK IDE Version: 4.5.0_beta5
-- Build ID: I20151222-1010
--
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_miox_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_info_tag_ADDR     : natural := 16#0#;
   constant K_info_version_ADDR : natural := 16#4#;
   constant K_info_git_ADDR     : natural := 16#8#;
   constant K_info_build_id_ADDR : natural := 16#c#;
   constant K_info_scratch_ADDR : natural := 16#10#;
   constant K_debug_ctrl_ADDR   : natural := 16#20#;
   
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
   -- Register Name: git
   ------------------------------------------------------------------------------------------
   type INFO_GIT_TYPE is record
      sha32          : std_logic_vector(31 downto 0);
   end record INFO_GIT_TYPE;

   constant INIT_INFO_GIT_TYPE : INFO_GIT_TYPE := (
      sha32           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_GIT_TYPE) return std_logic_vector;
   function to_INFO_GIT_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_GIT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: build_id
   ------------------------------------------------------------------------------------------
   type INFO_BUILD_ID_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_BUILD_ID_TYPE;

   constant INIT_INFO_BUILD_ID_TYPE : INFO_BUILD_ID_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_BUILD_ID_TYPE) return std_logic_vector;
   function to_INFO_BUILD_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_BUILD_ID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: scratch
   ------------------------------------------------------------------------------------------
   type INFO_SCRATCH_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_SCRATCH_TYPE;

   constant INIT_INFO_SCRATCH_TYPE : INFO_SCRATCH_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_SCRATCH_TYPE) return std_logic_vector;
   function to_INFO_SCRATCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type DEBUG_CTRL_TYPE is record
      zynq_term_en   : std_logic_vector(1 downto 0);
   end record DEBUG_CTRL_TYPE;

   constant INIT_DEBUG_CTRL_TYPE : DEBUG_CTRL_TYPE := (
      zynq_term_en    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_CTRL_TYPE) return std_logic_vector;
   function to_DEBUG_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: info
   ------------------------------------------------------------------------------------------
   type INFO_TYPE is record
      tag            : INFO_TAG_TYPE;
      version        : INFO_VERSION_TYPE;
      git            : INFO_GIT_TYPE;
      build_id       : INFO_BUILD_ID_TYPE;
      scratch        : INFO_SCRATCH_TYPE;
   end record INFO_TYPE;

   constant INIT_INFO_TYPE : INFO_TYPE := (
      tag             => INIT_INFO_TAG_TYPE,
      version         => INIT_INFO_VERSION_TYPE,
      git             => INIT_INFO_GIT_TYPE,
      build_id        => INIT_INFO_BUILD_ID_TYPE,
      scratch         => INIT_INFO_SCRATCH_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: debug
   ------------------------------------------------------------------------------------------
   type DEBUG_TYPE is record
      ctrl           : DEBUG_CTRL_TYPE;
   end record DEBUG_TYPE;

   constant INIT_DEBUG_TYPE : DEBUG_TYPE := (
      ctrl            => INIT_DEBUG_CTRL_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_miox
   ------------------------------------------------------------------------------------------
   type REGFILE_MIOX_TYPE is record
      info           : INFO_TYPE;
      debug          : DEBUG_TYPE;
   end record REGFILE_MIOX_TYPE;

   constant INIT_REGFILE_MIOX_TYPE : REGFILE_MIOX_TYPE := (
      info            => INIT_INFO_TYPE,
      debug           => INIT_DEBUG_TYPE
   );

   
end regfile_miox_pack;

package body regfile_miox_pack is
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
   -- Description: Cast from INFO_GIT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_GIT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.sha32;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_GIT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_GIT_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_GIT_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_GIT_TYPE is
   variable output : INFO_GIT_TYPE;
   begin
      output.sha32 := stdlv(31 downto 0);
      return output;
   end to_INFO_GIT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_BUILD_ID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_BUILD_ID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_BUILD_ID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_BUILD_ID_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_BUILD_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_BUILD_ID_TYPE is
   variable output : INFO_BUILD_ID_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_BUILD_ID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_SCRATCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_SCRATCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_SCRATCH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_SCRATCH_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_SCRATCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCH_TYPE is
   variable output : INFO_SCRATCH_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_SCRATCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(1 downto 0) := reg.zynq_term_en;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_CTRL_TYPE is
   variable output : DEBUG_CTRL_TYPE;
   begin
      output.zynq_term_en := stdlv(1 downto 0);
      return output;
   end to_DEBUG_CTRL_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File : regfile_miox.vhd
-- Project : FDK
-- Module : regfile_miox
-- Created on : 2018/10/30 10:44:38
-- Created by : amarchan
-- FDK IDE Version: 4.5.0_beta5
-- Build ID: I20151222-1010
-- 
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_miox_pack.all;


entity regfile_miox is
   
   port (
      resetN        : in    std_logic;                                   -- System reset
      sysclk        : in    std_logic;                                   -- System clock
      regfile       : inout REGFILE_MIOX_TYPE := INIT_REGFILE_MIOX_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                   -- Read
      reg_write     : in    std_logic;                                   -- Write
      reg_addr      : in    std_logic_vector(8 downto 2);                -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);               -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                -- Read data
   );
   
end regfile_miox;

architecture rtl of regfile_miox is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                      : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                              : std_logic_vector(5 downto 0);                    -- Address decode hit
signal wEn                              : std_logic_vector(5 downto 0);                    -- Write Enable
signal fullAddr                         : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                    : integer;                                        
signal bitEnN                           : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                           : std_logic;                                      
signal rb_info_tag                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_version                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_git                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_build_id                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_scratch                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_ctrl                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_info_scratch_value      : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_debug_ctrl_zynq_term_en : std_logic_vector(1 downto 0);                    -- Field: zynq_term_en

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
fullAddr(8 downto 2)<= reg_addr;

hit(0) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	tag
hit(1) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,12)))	else '0'; -- Addr:  0x0004	version
hit(2) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	git
hit(3) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,12)))	else '0'; -- Addr:  0x000C	build_id
hit(4) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,12)))	else '0'; -- Addr:  0x0010	scratch
hit(5) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20#,12)))	else '0'; -- Addr:  0x0020	ctrl



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_info_tag,
                            rb_info_version,
                            rb_info_git,
                            rb_info_build_id,
                            rb_info_scratch,
                            rb_debug_ctrl
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /info/tag
      when 16#0# =>
         readBackMux <= rb_info_tag;

      -- [0x004]: /info/version
      when 16#4# =>
         readBackMux <= rb_info_version;

      -- [0x008]: /info/git
      when 16#8# =>
         readBackMux <= rb_info_git;

      -- [0x00c]: /info/build_id
      when 16#C# =>
         readBackMux <= rb_info_build_id;

      -- [0x010]: /info/scratch
      when 16#10# =>
         readBackMux <= rb_info_scratch;

      -- [0x020]: /debug/ctrl
      when 16#20# =>
         readBackMux <= rb_debug_ctrl;

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
-- Register name: info_version
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

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
rb_info_version(15 downto 8) <= std_logic_vector(to_unsigned(integer(1),8));
regfile.info.version.minor <= rb_info_version(15 downto 8);


------------------------------------------------------------------------------------------
-- Field name: hw(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_info_version(7 downto 0) <= regfile.info.version.hw;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_git
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: sha32(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_info_git(31 downto 0) <= regfile.info.git.sha32;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_build_id
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_info_build_id(31 downto 0) <= regfile.info.build_id.value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_scratch
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_info_scratch(31 downto 0) <= field_rw_info_scratch_value(31 downto 0);
regfile.info.scratch.value <= field_rw_info_scratch_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_info_scratch_value
------------------------------------------------------------------------------------------
P_info_scratch_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_info_scratch_value <= std_logic_vector(to_unsigned(integer(0),32));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(4) = '1' and bitEnN(j) = '0') then
            field_rw_info_scratch_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_info_scratch_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: zynq_term_en(1 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_debug_ctrl(1 downto 0) <= field_rw_debug_ctrl_zynq_term_en(1 downto 0);
regfile.debug.ctrl.zynq_term_en <= field_rw_debug_ctrl_zynq_term_en(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_debug_ctrl_zynq_term_en
------------------------------------------------------------------------------------------
P_debug_ctrl_zynq_term_en : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_debug_ctrl_zynq_term_en <= std_logic_vector(to_unsigned(integer(0),2));
   elsif (rising_edge(sysclk)) then
      for j in  1 downto 0  loop
         if(wEn(5) = '1' and bitEnN(j) = '0') then
            field_rw_debug_ctrl_zynq_term_en(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_debug_ctrl_zynq_term_en;

ldData <= reg_read;

end rtl;

