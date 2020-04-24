-------------------------------------------------------------------------------
-- File    : regfile_dmawr.vhd
-- Project : FDK
-- Module  : regfile_dmawr_pack
-- Created on : 2019/05/06 15:58:21
-- Created by : jdesilet
-- FDK IDE Version: 4.5.0_beta6
-- Build ID: I20160216-1844
--
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_dmawr_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_HEADER_fstruc_ADDR  : natural := 16#0#;
   constant K_HEADER_fid_ADDR     : natural := 16#8#;
   constant K_HEADER_fsize_ADDR   : natural := 16#10#;
   constant K_HEADER_fctrl_ADDR   : natural := 16#18#;
   constant K_HEADER_foffset_ADDR : natural := 16#20#;
   constant K_HEADER_fint_ADDR    : natural := 16#28#;
   constant K_HEADER_fversion_ADDR : natural := 16#30#;
   constant K_HEADER_frsvd3_ADDR  : natural := 16#38#;
   constant K_USER_dstfstart_ADDR : natural := 16#40#;
   constant K_USER_dstlnpitch_ADDR : natural := 16#48#;
   constant K_USER_dstlnsize_ADDR : natural := 16#50#;
   constant K_USER_dstnbline_ADDR : natural := 16#58#;
   constant K_USER_DSTFSTART1_ADDR : natural := 16#60#;
   constant K_USER_DSTFSTART2_ADDR : natural := 16#68#;
   constant K_USER_DSTFSTART3_ADDR : natural := 16#70#;
   constant K_USER_DSTCTRL_ADDR   : natural := 16#78#;
   constant K_USER_DSTCLRPTRN_ADDR : natural := 16#80#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fstruc
   ------------------------------------------------------------------------------------------
   type HEADER_FSTRUC_TYPE is record
      tag            : std_logic_vector(23 downto 0);
      mjver          : std_logic_vector(3 downto 0);
      mnver          : std_logic_vector(3 downto 0);
   end record HEADER_FSTRUC_TYPE;

   constant INIT_HEADER_FSTRUC_TYPE : HEADER_FSTRUC_TYPE := (
      tag             => (others=> 'Z'),
      mjver           => (others=> 'Z'),
      mnver           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FSTRUC_TYPE) return std_logic_vector;
   function to_HEADER_FSTRUC_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FSTRUC_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fid
   ------------------------------------------------------------------------------------------
   type HEADER_FID_TYPE is record
      fid            : std_logic_vector(15 downto 0);
      CAPABILITY     : std_logic_vector(15 downto 0);
   end record HEADER_FID_TYPE;

   constant INIT_HEADER_FID_TYPE : HEADER_FID_TYPE := (
      fid             => (others=> 'Z'),
      CAPABILITY      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FID_TYPE) return std_logic_vector;
   function to_HEADER_FID_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fsize
   ------------------------------------------------------------------------------------------
   type HEADER_FSIZE_TYPE is record
      fullsize       : std_logic_vector(15 downto 0);
      usersize       : std_logic_vector(15 downto 0);
   end record HEADER_FSIZE_TYPE;

   constant INIT_HEADER_FSIZE_TYPE : HEADER_FSIZE_TYPE := (
      fullsize        => (others=> 'Z'),
      usersize        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FSIZE_TYPE) return std_logic_vector;
   function to_HEADER_FSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FSIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fctrl
   ------------------------------------------------------------------------------------------
   type HEADER_FCTRL_TYPE is record
      snppdg         : std_logic;
      active         : std_logic;
      snpsht         : std_logic;
      abort          : std_logic;
      ipferr         : std_logic_vector(7 downto 0);
   end record HEADER_FCTRL_TYPE;

   constant INIT_HEADER_FCTRL_TYPE : HEADER_FCTRL_TYPE := (
      snppdg          => 'Z',
      active          => 'Z',
      snpsht          => 'Z',
      abort           => 'Z',
      ipferr          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FCTRL_TYPE) return std_logic_vector;
   function to_HEADER_FCTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FCTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: foffset
   ------------------------------------------------------------------------------------------
   type HEADER_FOFFSET_TYPE is record
      ioctloff       : std_logic_vector(15 downto 0);
      useroff        : std_logic_vector(15 downto 0);
   end record HEADER_FOFFSET_TYPE;

   constant INIT_HEADER_FOFFSET_TYPE : HEADER_FOFFSET_TYPE := (
      ioctloff        => (others=> 'Z'),
      useroff         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FOFFSET_TYPE) return std_logic_vector;
   function to_HEADER_FOFFSET_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FOFFSET_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fint
   ------------------------------------------------------------------------------------------
   type HEADER_FINT_TYPE is record
      lsbof          : std_logic_vector(6 downto 0);
      ipevent        : std_logic_vector(2 downto 0);
   end record HEADER_FINT_TYPE;

   constant INIT_HEADER_FINT_TYPE : HEADER_FINT_TYPE := (
      lsbof           => (others=> 'Z'),
      ipevent         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FINT_TYPE) return std_logic_vector;
   function to_HEADER_FINT_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FINT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fversion
   ------------------------------------------------------------------------------------------
   type HEADER_FVERSION_TYPE is record
      SUBFID         : std_logic_vector(7 downto 0);
      ipmjver        : std_logic_vector(3 downto 0);
      ipmnver        : std_logic_vector(3 downto 0);
      iphwver        : std_logic_vector(4 downto 0);
   end record HEADER_FVERSION_TYPE;

   constant INIT_HEADER_FVERSION_TYPE : HEADER_FVERSION_TYPE := (
      SUBFID          => (others=> 'Z'),
      ipmjver         => (others=> 'Z'),
      ipmnver         => (others=> 'Z'),
      iphwver         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FVERSION_TYPE) return std_logic_vector;
   function to_HEADER_FVERSION_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FVERSION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: frsvd3
   ------------------------------------------------------------------------------------------
   type HEADER_FRSVD3_TYPE is record
      frsvd3         : std_logic_vector(31 downto 0);
   end record HEADER_FRSVD3_TYPE;

   constant INIT_HEADER_FRSVD3_TYPE : HEADER_FRSVD3_TYPE := (
      frsvd3          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : HEADER_FRSVD3_TYPE) return std_logic_vector;
   function to_HEADER_FRSVD3_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FRSVD3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstfstart
   ------------------------------------------------------------------------------------------
   type USER_DSTFSTART_TYPE is record
      fstart         : std_logic_vector(35 downto 0);
   end record USER_DSTFSTART_TYPE;

   constant INIT_USER_DSTFSTART_TYPE : USER_DSTFSTART_TYPE := (
      fstart          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTFSTART_TYPE) return std_logic_vector;
   function to_USER_DSTFSTART_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstlnpitch
   ------------------------------------------------------------------------------------------
   type USER_DSTLNPITCH_TYPE is record
      lnpitch        : std_logic_vector(35 downto 0);
   end record USER_DSTLNPITCH_TYPE;

   constant INIT_USER_DSTLNPITCH_TYPE : USER_DSTLNPITCH_TYPE := (
      lnpitch         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTLNPITCH_TYPE) return std_logic_vector;
   function to_USER_DSTLNPITCH_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTLNPITCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstlnsize
   ------------------------------------------------------------------------------------------
   type USER_DSTLNSIZE_TYPE is record
      lnsize         : std_logic_vector(30 downto 0);
   end record USER_DSTLNSIZE_TYPE;

   constant INIT_USER_DSTLNSIZE_TYPE : USER_DSTLNSIZE_TYPE := (
      lnsize          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTLNSIZE_TYPE) return std_logic_vector;
   function to_USER_DSTLNSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTLNSIZE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: dstnbline
   ------------------------------------------------------------------------------------------
   type USER_DSTNBLINE_TYPE is record
      nbline         : std_logic_vector(30 downto 0);
   end record USER_DSTNBLINE_TYPE;

   constant INIT_USER_DSTNBLINE_TYPE : USER_DSTNBLINE_TYPE := (
      nbline          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTNBLINE_TYPE) return std_logic_vector;
   function to_USER_DSTNBLINE_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTNBLINE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DSTFSTART1
   ------------------------------------------------------------------------------------------
   type USER_DSTFSTART1_TYPE is record
      FSTART         : std_logic_vector(35 downto 0);
   end record USER_DSTFSTART1_TYPE;

   constant INIT_USER_DSTFSTART1_TYPE : USER_DSTFSTART1_TYPE := (
      FSTART          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTFSTART1_TYPE) return std_logic_vector;
   function to_USER_DSTFSTART1_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DSTFSTART2
   ------------------------------------------------------------------------------------------
   type USER_DSTFSTART2_TYPE is record
      FSTART         : std_logic_vector(35 downto 0);
   end record USER_DSTFSTART2_TYPE;

   constant INIT_USER_DSTFSTART2_TYPE : USER_DSTFSTART2_TYPE := (
      FSTART          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTFSTART2_TYPE) return std_logic_vector;
   function to_USER_DSTFSTART2_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DSTFSTART3
   ------------------------------------------------------------------------------------------
   type USER_DSTFSTART3_TYPE is record
      FSTART         : std_logic_vector(35 downto 0);
   end record USER_DSTFSTART3_TYPE;

   constant INIT_USER_DSTFSTART3_TYPE : USER_DSTFSTART3_TYPE := (
      FSTART          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTFSTART3_TYPE) return std_logic_vector;
   function to_USER_DSTFSTART3_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DSTCTRL
   ------------------------------------------------------------------------------------------
   type USER_DSTCTRL_TYPE is record
      BUFCLR         : std_logic;
      DTE3           : std_logic;
      DTE2           : std_logic;
      DTE1           : std_logic;
      DTE0           : std_logic;
      BITWDTH        : std_logic;
      NBCONTX        : std_logic_vector(1 downto 0);
   end record USER_DSTCTRL_TYPE;

   constant INIT_USER_DSTCTRL_TYPE : USER_DSTCTRL_TYPE := (
      BUFCLR          => 'Z',
      DTE3            => 'Z',
      DTE2            => 'Z',
      DTE1            => 'Z',
      DTE0            => 'Z',
      BITWDTH         => 'Z',
      NBCONTX         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTCTRL_TYPE) return std_logic_vector;
   function to_USER_DSTCTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTCTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DSTCLRPTRN
   ------------------------------------------------------------------------------------------
   type USER_DSTCLRPTRN_TYPE is record
      CLRPTRN        : std_logic_vector(31 downto 0);
   end record USER_DSTCLRPTRN_TYPE;

   constant INIT_USER_DSTCLRPTRN_TYPE : USER_DSTCLRPTRN_TYPE := (
      CLRPTRN         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : USER_DSTCLRPTRN_TYPE) return std_logic_vector;
   function to_USER_DSTCLRPTRN_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTCLRPTRN_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: HEADER
   ------------------------------------------------------------------------------------------
   type HEADER_TYPE is record
      fstruc         : HEADER_FSTRUC_TYPE;
      fid            : HEADER_FID_TYPE;
      fsize          : HEADER_FSIZE_TYPE;
      fctrl          : HEADER_FCTRL_TYPE;
      foffset        : HEADER_FOFFSET_TYPE;
      fint           : HEADER_FINT_TYPE;
      fversion       : HEADER_FVERSION_TYPE;
      frsvd3         : HEADER_FRSVD3_TYPE;
   end record HEADER_TYPE;

   constant INIT_HEADER_TYPE : HEADER_TYPE := (
      fstruc          => INIT_HEADER_FSTRUC_TYPE,
      fid             => INIT_HEADER_FID_TYPE,
      fsize           => INIT_HEADER_FSIZE_TYPE,
      fctrl           => INIT_HEADER_FCTRL_TYPE,
      foffset         => INIT_HEADER_FOFFSET_TYPE,
      fint            => INIT_HEADER_FINT_TYPE,
      fversion        => INIT_HEADER_FVERSION_TYPE,
      frsvd3          => INIT_HEADER_FRSVD3_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: USER
   ------------------------------------------------------------------------------------------
   type USER_TYPE is record
      dstfstart      : USER_DSTFSTART_TYPE;
      dstlnpitch     : USER_DSTLNPITCH_TYPE;
      dstlnsize      : USER_DSTLNSIZE_TYPE;
      dstnbline      : USER_DSTNBLINE_TYPE;
      DSTFSTART1     : USER_DSTFSTART1_TYPE;
      DSTFSTART2     : USER_DSTFSTART2_TYPE;
      DSTFSTART3     : USER_DSTFSTART3_TYPE;
      DSTCTRL        : USER_DSTCTRL_TYPE;
      DSTCLRPTRN     : USER_DSTCLRPTRN_TYPE;
   end record USER_TYPE;

   constant INIT_USER_TYPE : USER_TYPE := (
      dstfstart       => INIT_USER_DSTFSTART_TYPE,
      dstlnpitch      => INIT_USER_DSTLNPITCH_TYPE,
      dstlnsize       => INIT_USER_DSTLNSIZE_TYPE,
      dstnbline       => INIT_USER_DSTNBLINE_TYPE,
      DSTFSTART1      => INIT_USER_DSTFSTART1_TYPE,
      DSTFSTART2      => INIT_USER_DSTFSTART2_TYPE,
      DSTFSTART3      => INIT_USER_DSTFSTART3_TYPE,
      DSTCTRL         => INIT_USER_DSTCTRL_TYPE,
      DSTCLRPTRN      => INIT_USER_DSTCLRPTRN_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_dmawr
   ------------------------------------------------------------------------------------------
   type REGFILE_DMAWR_TYPE is record
      HEADER         : HEADER_TYPE;
      USER           : USER_TYPE;
   end record REGFILE_DMAWR_TYPE;

   constant INIT_REGFILE_DMAWR_TYPE : REGFILE_DMAWR_TYPE := (
      HEADER          => INIT_HEADER_TYPE,
      USER            => INIT_USER_TYPE
   );

   
end regfile_dmawr_pack;

package body regfile_dmawr_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FSTRUC_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FSTRUC_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 8) := reg.tag;
      output(7 downto 4) := reg.mjver;
      output(3 downto 0) := reg.mnver;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FSTRUC_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FSTRUC_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FSTRUC_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FSTRUC_TYPE is
   variable output : HEADER_FSTRUC_TYPE;
   begin
      output.tag := stdlv(31 downto 8);
      output.mjver := stdlv(7 downto 4);
      output.mnver := stdlv(3 downto 0);
      return output;
   end to_HEADER_FSTRUC_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.fid;
      output(15 downto 0) := reg.CAPABILITY;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FID_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FID_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FID_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FID_TYPE is
   variable output : HEADER_FID_TYPE;
   begin
      output.fid := stdlv(31 downto 16);
      output.CAPABILITY := stdlv(15 downto 0);
      return output;
   end to_HEADER_FID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FSIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FSIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.fullsize;
      output(15 downto 0) := reg.usersize;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FSIZE_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FSIZE_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FSIZE_TYPE is
   variable output : HEADER_FSIZE_TYPE;
   begin
      output.fullsize := stdlv(31 downto 16);
      output.usersize := stdlv(15 downto 0);
      return output;
   end to_HEADER_FSIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FCTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FCTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(29) := reg.snppdg;
      output(28) := reg.active;
      output(25) := reg.snpsht;
      output(24) := reg.abort;
      output(23 downto 16) := reg.ipferr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FCTRL_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FCTRL_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FCTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FCTRL_TYPE is
   variable output : HEADER_FCTRL_TYPE;
   begin
      output.snppdg := stdlv(29);
      output.active := stdlv(28);
      output.snpsht := stdlv(25);
      output.abort := stdlv(24);
      output.ipferr := stdlv(23 downto 16);
      return output;
   end to_HEADER_FCTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FOFFSET_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FOFFSET_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 16) := reg.ioctloff;
      output(15 downto 0) := reg.useroff;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FOFFSET_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FOFFSET_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FOFFSET_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FOFFSET_TYPE is
   variable output : HEADER_FOFFSET_TYPE;
   begin
      output.ioctloff := stdlv(31 downto 16);
      output.useroff := stdlv(15 downto 0);
      return output;
   end to_HEADER_FOFFSET_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FINT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FINT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(14 downto 8) := reg.lsbof;
      output(2 downto 0) := reg.ipevent;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FINT_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FINT_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FINT_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FINT_TYPE is
   variable output : HEADER_FINT_TYPE;
   begin
      output.lsbof := stdlv(14 downto 8);
      output.ipevent := stdlv(2 downto 0);
      return output;
   end to_HEADER_FINT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FVERSION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FVERSION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.SUBFID;
      output(15 downto 12) := reg.ipmjver;
      output(11 downto 8) := reg.ipmnver;
      output(7 downto 3) := reg.iphwver;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FVERSION_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FVERSION_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FVERSION_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FVERSION_TYPE is
   variable output : HEADER_FVERSION_TYPE;
   begin
      output.SUBFID := stdlv(23 downto 16);
      output.ipmjver := stdlv(15 downto 12);
      output.ipmnver := stdlv(11 downto 8);
      output.iphwver := stdlv(7 downto 3);
      return output;
   end to_HEADER_FVERSION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from HEADER_FRSVD3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : HEADER_FRSVD3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.frsvd3;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_HEADER_FRSVD3_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to HEADER_FRSVD3_TYPE
   --------------------------------------------------------------------------------
   function to_HEADER_FRSVD3_TYPE(stdlv : std_logic_vector(63 downto 0)) return HEADER_FRSVD3_TYPE is
   variable output : HEADER_FRSVD3_TYPE;
   begin
      output.frsvd3 := stdlv(31 downto 0);
      return output;
   end to_HEADER_FRSVD3_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTFSTART_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTFSTART_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(35 downto 0) := reg.fstart;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTFSTART_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTFSTART_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTFSTART_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART_TYPE is
   variable output : USER_DSTFSTART_TYPE;
   begin
      output.fstart := stdlv(35 downto 0);
      return output;
   end to_USER_DSTFSTART_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTLNPITCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTLNPITCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(35 downto 0) := reg.lnpitch;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTLNPITCH_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTLNPITCH_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTLNPITCH_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTLNPITCH_TYPE is
   variable output : USER_DSTLNPITCH_TYPE;
   begin
      output.lnpitch := stdlv(35 downto 0);
      return output;
   end to_USER_DSTLNPITCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTLNSIZE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTLNSIZE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.lnsize;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTLNSIZE_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTLNSIZE_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTLNSIZE_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTLNSIZE_TYPE is
   variable output : USER_DSTLNSIZE_TYPE;
   begin
      output.lnsize := stdlv(30 downto 0);
      return output;
   end to_USER_DSTLNSIZE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTNBLINE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTNBLINE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(30 downto 0) := reg.nbline;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTNBLINE_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTNBLINE_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTNBLINE_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTNBLINE_TYPE is
   variable output : USER_DSTNBLINE_TYPE;
   begin
      output.nbline := stdlv(30 downto 0);
      return output;
   end to_USER_DSTNBLINE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTFSTART1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTFSTART1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(35 downto 0) := reg.FSTART;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTFSTART1_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTFSTART1_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTFSTART1_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART1_TYPE is
   variable output : USER_DSTFSTART1_TYPE;
   begin
      output.FSTART := stdlv(35 downto 0);
      return output;
   end to_USER_DSTFSTART1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTFSTART2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTFSTART2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(35 downto 0) := reg.FSTART;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTFSTART2_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTFSTART2_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTFSTART2_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART2_TYPE is
   variable output : USER_DSTFSTART2_TYPE;
   begin
      output.FSTART := stdlv(35 downto 0);
      return output;
   end to_USER_DSTFSTART2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTFSTART3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTFSTART3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(35 downto 0) := reg.FSTART;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTFSTART3_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTFSTART3_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTFSTART3_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTFSTART3_TYPE is
   variable output : USER_DSTFSTART3_TYPE;
   begin
      output.FSTART := stdlv(35 downto 0);
      return output;
   end to_USER_DSTFSTART3_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTCTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTCTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7) := reg.BUFCLR;
      output(6) := reg.DTE3;
      output(5) := reg.DTE2;
      output(4) := reg.DTE1;
      output(3) := reg.DTE0;
      output(2) := reg.BITWDTH;
      output(1 downto 0) := reg.NBCONTX;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTCTRL_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTCTRL_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTCTRL_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTCTRL_TYPE is
   variable output : USER_DSTCTRL_TYPE;
   begin
      output.BUFCLR := stdlv(7);
      output.DTE3 := stdlv(6);
      output.DTE2 := stdlv(5);
      output.DTE1 := stdlv(4);
      output.DTE0 := stdlv(3);
      output.BITWDTH := stdlv(2);
      output.NBCONTX := stdlv(1 downto 0);
      return output;
   end to_USER_DSTCTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from USER_DSTCLRPTRN_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : USER_DSTCLRPTRN_TYPE) return std_logic_vector is
   variable output : std_logic_vector(63 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.CLRPTRN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_USER_DSTCLRPTRN_TYPE
   -- Description: Cast from std_logic_vector(63 downto 0) to USER_DSTCLRPTRN_TYPE
   --------------------------------------------------------------------------------
   function to_USER_DSTCLRPTRN_TYPE(stdlv : std_logic_vector(63 downto 0)) return USER_DSTCLRPTRN_TYPE is
   variable output : USER_DSTCLRPTRN_TYPE;
   begin
      output.CLRPTRN := stdlv(31 downto 0);
      return output;
   end to_USER_DSTCLRPTRN_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File : regfile_dmawr.vhd
-- Project : FDK
-- Module : regfile_dmawr
-- Created on : 2019/05/06 15:58:21
-- Created by : jdesilet
-- FDK IDE Version: 4.5.0_beta6
-- Build ID: I20160216-1844
-- 
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_dmawr_pack.all;


entity regfile_dmawr is
   
   port (
      sysrstN       : in    std_logic;                                     -- System reset
      sysclk        : in    std_logic;                                     -- System clock
      regfile       : inout REGFILE_DMAWR_TYPE := INIT_REGFILE_DMAWR_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                     -- Read
      reg_write     : in    std_logic;                                     -- Write
      reg_addr      : in    std_logic_vector(8 downto 3);                  -- Address
      reg_beN       : in    std_logic_vector(7 downto 0);                  -- Byte enable
      reg_writedata : in    std_logic_vector(63 downto 0);                 -- Write data
      reg_readdata  : out   std_logic_vector(63 downto 0)                  -- Read data
   );
   
end regfile_dmawr;

architecture rtl of regfile_dmawr is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                        : std_logic_vector(63 downto 0);                   -- Data readback multiplexer
signal hit                                : std_logic_vector(16 downto 0);                   -- Address decode hit
signal wEn                                : std_logic_vector(16 downto 0);                   -- Write Enable
signal fullAddr                           : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                      : integer;                                        
signal bitEnN                             : std_logic_vector(63 downto 0);                   -- Bits enable
signal ldData                             : std_logic;                                      
signal rb_HEADER_fstruc                   : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_fid                      : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_fsize                    : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_fctrl                    : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_foffset                  : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_fint                     : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_fversion                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_HEADER_frsvd3                   : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_dstfstart                  : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_dstlnpitch                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_dstlnsize                  : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_dstnbline                  : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_DSTFSTART1                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_DSTFSTART2                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_DSTFSTART3                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_DSTCTRL                    : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal rb_USER_DSTCLRPTRN                 : std_logic_vector(63 downto 0):= (others => '0'); -- Readback Register
signal field_wautoclr_HEADER_fctrl_snpsht : std_logic;                                       -- Field: snpsht
signal field_rw_HEADER_fctrl_abort        : std_logic;                                       -- Field: abort
signal field_rw_USER_dstfstart_fstart     : std_logic_vector(35 downto 0);                   -- Field: fstart
signal field_rw_USER_dstlnpitch_lnpitch   : std_logic_vector(35 downto 0);                   -- Field: lnpitch
signal field_rw_USER_dstlnsize_lnsize     : std_logic_vector(30 downto 0);                   -- Field: lnsize
signal field_rw_USER_dstnbline_nbline     : std_logic_vector(30 downto 0);                   -- Field: nbline
signal field_rw_USER_DSTFSTART1_FSTART    : std_logic_vector(35 downto 0);                   -- Field: FSTART
signal field_rw_USER_DSTFSTART2_FSTART    : std_logic_vector(35 downto 0);                   -- Field: FSTART
signal field_rw_USER_DSTFSTART3_FSTART    : std_logic_vector(35 downto 0);                   -- Field: FSTART
signal field_rw_USER_DSTCTRL_BUFCLR       : std_logic;                                       -- Field: BUFCLR
signal field_rw_USER_DSTCTRL_DTE3         : std_logic;                                       -- Field: DTE3
signal field_rw_USER_DSTCTRL_DTE2         : std_logic;                                       -- Field: DTE2
signal field_rw_USER_DSTCTRL_DTE1         : std_logic;                                       -- Field: DTE1
signal field_rw_USER_DSTCTRL_DTE0         : std_logic;                                       -- Field: DTE0
signal field_rw_USER_DSTCTRL_BITWDTH      : std_logic;                                       -- Field: BITWDTH
signal field_rw_USER_DSTCTRL_NBCONTX      : std_logic_vector(1 downto 0);                    -- Field: NBCONTX
signal field_rw_USER_DSTCLRPTRN_CLRPTRN   : std_logic_vector(31 downto 0);                   -- Field: CLRPTRN

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
fullAddr(8 downto 3)<= reg_addr;

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	fstruc
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	fid
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,12)))	else '0'; -- Addr:  0x0010	fsize
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#18#,12)))	else '0'; -- Addr:  0x0018	fctrl
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20#,12)))	else '0'; -- Addr:  0x0020	foffset
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#28#,12)))	else '0'; -- Addr:  0x0028	fint
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#30#,12)))	else '0'; -- Addr:  0x0030	fversion
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#38#,12)))	else '0'; -- Addr:  0x0038	frsvd3
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,12)))	else '0'; -- Addr:  0x0040	dstfstart
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48#,12)))	else '0'; -- Addr:  0x0048	dstlnpitch
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#50#,12)))	else '0'; -- Addr:  0x0050	dstlnsize
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#58#,12)))	else '0'; -- Addr:  0x0058	dstnbline
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#60#,12)))	else '0'; -- Addr:  0x0060	DSTFSTART1
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#68#,12)))	else '0'; -- Addr:  0x0068	DSTFSTART2
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,12)))	else '0'; -- Addr:  0x0070	DSTFSTART3
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#78#,12)))	else '0'; -- Addr:  0x0078	DSTCTRL
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#80#,12)))	else '0'; -- Addr:  0x0080	DSTCLRPTRN



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_HEADER_fstruc,
                            rb_HEADER_fid,
                            rb_HEADER_fsize,
                            rb_HEADER_fctrl,
                            rb_HEADER_foffset,
                            rb_HEADER_fint,
                            rb_HEADER_fversion,
                            rb_HEADER_frsvd3,
                            rb_USER_dstfstart,
                            rb_USER_dstlnpitch,
                            rb_USER_dstlnsize,
                            rb_USER_dstnbline,
                            rb_USER_DSTFSTART1,
                            rb_USER_DSTFSTART2,
                            rb_USER_DSTFSTART3,
                            rb_USER_DSTCTRL,
                            rb_USER_DSTCLRPTRN
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /HEADER/fstruc
      when 16#0# =>
         readBackMux <= rb_HEADER_fstruc;

      -- [0x008]: /HEADER/fid
      when 16#8# =>
         readBackMux <= rb_HEADER_fid;

      -- [0x010]: /HEADER/fsize
      when 16#10# =>
         readBackMux <= rb_HEADER_fsize;

      -- [0x018]: /HEADER/fctrl
      when 16#18# =>
         readBackMux <= rb_HEADER_fctrl;

      -- [0x020]: /HEADER/foffset
      when 16#20# =>
         readBackMux <= rb_HEADER_foffset;

      -- [0x028]: /HEADER/fint
      when 16#28# =>
         readBackMux <= rb_HEADER_fint;

      -- [0x030]: /HEADER/fversion
      when 16#30# =>
         readBackMux <= rb_HEADER_fversion;

      -- [0x038]: /HEADER/frsvd3
      when 16#38# =>
         readBackMux <= rb_HEADER_frsvd3;

      -- [0x040]: /USER/dstfstart
      when 16#40# =>
         readBackMux <= rb_USER_dstfstart;

      -- [0x048]: /USER/dstlnpitch
      when 16#48# =>
         readBackMux <= rb_USER_dstlnpitch;

      -- [0x050]: /USER/dstlnsize
      when 16#50# =>
         readBackMux <= rb_USER_dstlnsize;

      -- [0x058]: /USER/dstnbline
      when 16#58# =>
         readBackMux <= rb_USER_dstnbline;

      -- [0x060]: /USER/DSTFSTART1
      when 16#60# =>
         readBackMux <= rb_USER_DSTFSTART1;

      -- [0x068]: /USER/DSTFSTART2
      when 16#68# =>
         readBackMux <= rb_USER_DSTFSTART2;

      -- [0x070]: /USER/DSTFSTART3
      when 16#70# =>
         readBackMux <= rb_USER_DSTFSTART3;

      -- [0x078]: /USER/DSTCTRL
      when 16#78# =>
         readBackMux <= rb_USER_DSTCTRL;

      -- [0x080]: /USER/DSTCLRPTRN
      when 16#80# =>
         readBackMux <= rb_USER_DSTCLRPTRN;

      -- Default value
      when others =>
         readBackMux <= (others => '0');

   end case;

end process P_readBackMux_Mux;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdata
------------------------------------------------------------------------------------------
P_reg_readdata : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      reg_readdata <= (others=>'0');
   elsif (rising_edge(sysclk)) then
      if (ldData = '1') then
         reg_readdata <= readBackMux;
      end if;
   end if;
end process P_reg_readdata;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fstruc
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: tag
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fstruc(31 downto 8) <= std_logic_vector(to_unsigned(integer(5067864),24));
regfile.HEADER.fstruc.tag <= rb_HEADER_fstruc(31 downto 8);


------------------------------------------------------------------------------------------
-- Field name: mjver
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fstruc(7 downto 4) <= std_logic_vector(to_unsigned(integer(1),4));
regfile.HEADER.fstruc.mjver <= rb_HEADER_fstruc(7 downto 4);


------------------------------------------------------------------------------------------
-- Field name: mnver
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fstruc(3 downto 0) <= std_logic_vector(to_unsigned(integer(4),4));
regfile.HEADER.fstruc.mnver <= rb_HEADER_fstruc(3 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fid
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: fid
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fid(31 downto 16) <= std_logic_vector(to_unsigned(integer(49169),16));
regfile.HEADER.fid.fid <= rb_HEADER_fid(31 downto 16);


------------------------------------------------------------------------------------------
-- Field name: CAPABILITY
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fid(15 downto 0) <= std_logic_vector(to_unsigned(integer(0),16));
regfile.HEADER.fid.CAPABILITY <= rb_HEADER_fid(15 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fsize
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: fullsize
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fsize(31 downto 16) <= std_logic_vector(to_unsigned(integer(64),16));
regfile.HEADER.fsize.fullsize <= rb_HEADER_fsize(31 downto 16);


------------------------------------------------------------------------------------------
-- Field name: usersize
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fsize(15 downto 0) <= std_logic_vector(to_unsigned(integer(8),16));
regfile.HEADER.fsize.usersize <= rb_HEADER_fsize(15 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: snppdg
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HEADER_fctrl(29) <= regfile.HEADER.fctrl.snppdg;


------------------------------------------------------------------------------------------
-- Field name: active
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HEADER_fctrl(28) <= regfile.HEADER.fctrl.active;


------------------------------------------------------------------------------------------
-- Field name: snpsht
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_HEADER_fctrl(25) <= '0';
regfile.HEADER.fctrl.snpsht <= field_wautoclr_HEADER_fctrl_snpsht;


------------------------------------------------------------------------------------------
-- Process: P_HEADER_fctrl_snpsht
------------------------------------------------------------------------------------------
P_HEADER_fctrl_snpsht : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_wautoclr_HEADER_fctrl_snpsht <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(3) = '1' and bitEnN(25) = '0') then
         field_wautoclr_HEADER_fctrl_snpsht <= reg_writedata(25);
      else
         field_wautoclr_HEADER_fctrl_snpsht <= '0';
      end if;
   end if;
end process P_HEADER_fctrl_snpsht;

------------------------------------------------------------------------------------------
-- Field name: abort
-- Field type: RW
------------------------------------------------------------------------------------------
rb_HEADER_fctrl(24) <= field_rw_HEADER_fctrl_abort;
regfile.HEADER.fctrl.abort <= field_rw_HEADER_fctrl_abort;


------------------------------------------------------------------------------------------
-- Process: P_HEADER_fctrl_abort
------------------------------------------------------------------------------------------
P_HEADER_fctrl_abort : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_HEADER_fctrl_abort <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(3) = '1' and bitEnN(24) = '0') then
         field_rw_HEADER_fctrl_abort <= reg_writedata(24);
      end if;
   end if;
end process P_HEADER_fctrl_abort;

------------------------------------------------------------------------------------------
-- Field name: ipferr
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fctrl(23 downto 16) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.HEADER.fctrl.ipferr <= rb_HEADER_fctrl(23 downto 16);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_foffset
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ioctloff
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_foffset(31 downto 16) <= std_logic_vector(to_unsigned(integer(0),16));
regfile.HEADER.foffset.ioctloff <= rb_HEADER_foffset(31 downto 16);


------------------------------------------------------------------------------------------
-- Field name: useroff
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_foffset(15 downto 0) <= std_logic_vector(to_unsigned(integer(8),16));
regfile.HEADER.foffset.useroff <= rb_HEADER_foffset(15 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fint
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: lsbof(6 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HEADER_fint(14 downto 8) <= regfile.HEADER.fint.lsbof;


------------------------------------------------------------------------------------------
-- Field name: ipevent
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fint(2 downto 0) <= std_logic_vector(to_unsigned(integer(1),3));
regfile.HEADER.fint.ipevent <= rb_HEADER_fint(2 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_fversion
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SUBFID(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HEADER_fversion(23 downto 16) <= regfile.HEADER.fversion.SUBFID;


------------------------------------------------------------------------------------------
-- Field name: ipmjver
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fversion(15 downto 12) <= std_logic_vector(to_unsigned(integer(2),4));
regfile.HEADER.fversion.ipmjver <= rb_HEADER_fversion(15 downto 12);


------------------------------------------------------------------------------------------
-- Field name: ipmnver
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_fversion(11 downto 8) <= std_logic_vector(to_unsigned(integer(2),4));
regfile.HEADER.fversion.ipmnver <= rb_HEADER_fversion(11 downto 8);


------------------------------------------------------------------------------------------
-- Field name: iphwver(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_HEADER_fversion(7 downto 3) <= regfile.HEADER.fversion.iphwver;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: HEADER_frsvd3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: frsvd3
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_HEADER_frsvd3(31 downto 0) <= std_logic_vector(to_unsigned(integer(0),32));
regfile.HEADER.frsvd3.frsvd3 <= rb_HEADER_frsvd3(31 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_dstfstart
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: fstart(35 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_dstfstart(35 downto 0) <= field_rw_USER_dstfstart_fstart(35 downto 0);
regfile.USER.dstfstart.fstart <= field_rw_USER_dstfstart_fstart(35 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_dstfstart_fstart
------------------------------------------------------------------------------------------
P_USER_dstfstart_fstart : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_dstfstart_fstart <= std_logic_vector(to_unsigned(integer(0),36));
   elsif (rising_edge(sysclk)) then
      for j in  35 downto 0  loop
         if(wEn(8) = '1' and bitEnN(j) = '0') then
            field_rw_USER_dstfstart_fstart(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_dstfstart_fstart;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_dstlnpitch
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: lnpitch(35 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_dstlnpitch(35 downto 0) <= field_rw_USER_dstlnpitch_lnpitch(35 downto 0);
regfile.USER.dstlnpitch.lnpitch <= field_rw_USER_dstlnpitch_lnpitch(35 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_dstlnpitch_lnpitch
------------------------------------------------------------------------------------------
P_USER_dstlnpitch_lnpitch : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_dstlnpitch_lnpitch <= std_logic_vector(to_unsigned(integer(0),36));
   elsif (rising_edge(sysclk)) then
      for j in  35 downto 0  loop
         if(wEn(9) = '1' and bitEnN(j) = '0') then
            field_rw_USER_dstlnpitch_lnpitch(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_dstlnpitch_lnpitch;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_dstlnsize
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: lnsize(30 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_dstlnsize(30 downto 0) <= field_rw_USER_dstlnsize_lnsize(30 downto 0);
regfile.USER.dstlnsize.lnsize <= field_rw_USER_dstlnsize_lnsize(30 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_dstlnsize_lnsize
------------------------------------------------------------------------------------------
P_USER_dstlnsize_lnsize : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_dstlnsize_lnsize <= std_logic_vector(to_unsigned(integer(0),31));
   elsif (rising_edge(sysclk)) then
      for j in  30 downto 0  loop
         if(wEn(10) = '1' and bitEnN(j) = '0') then
            field_rw_USER_dstlnsize_lnsize(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_dstlnsize_lnsize;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_dstnbline
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: nbline(30 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_dstnbline(30 downto 0) <= field_rw_USER_dstnbline_nbline(30 downto 0);
regfile.USER.dstnbline.nbline <= field_rw_USER_dstnbline_nbline(30 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_dstnbline_nbline
------------------------------------------------------------------------------------------
P_USER_dstnbline_nbline : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_dstnbline_nbline <= std_logic_vector(to_unsigned(integer(0),31));
   elsif (rising_edge(sysclk)) then
      for j in  30 downto 0  loop
         if(wEn(11) = '1' and bitEnN(j) = '0') then
            field_rw_USER_dstnbline_nbline(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_dstnbline_nbline;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_DSTFSTART1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FSTART(35 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTFSTART1(35 downto 0) <= field_rw_USER_DSTFSTART1_FSTART(35 downto 0);
regfile.USER.DSTFSTART1.FSTART <= field_rw_USER_DSTFSTART1_FSTART(35 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTFSTART1_FSTART
------------------------------------------------------------------------------------------
P_USER_DSTFSTART1_FSTART : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTFSTART1_FSTART <= std_logic_vector(to_unsigned(integer(0),36));
   elsif (rising_edge(sysclk)) then
      for j in  35 downto 0  loop
         if(wEn(12) = '1' and bitEnN(j) = '0') then
            field_rw_USER_DSTFSTART1_FSTART(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_DSTFSTART1_FSTART;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_DSTFSTART2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FSTART(35 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTFSTART2(35 downto 0) <= field_rw_USER_DSTFSTART2_FSTART(35 downto 0);
regfile.USER.DSTFSTART2.FSTART <= field_rw_USER_DSTFSTART2_FSTART(35 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTFSTART2_FSTART
------------------------------------------------------------------------------------------
P_USER_DSTFSTART2_FSTART : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTFSTART2_FSTART <= std_logic_vector(to_unsigned(integer(0),36));
   elsif (rising_edge(sysclk)) then
      for j in  35 downto 0  loop
         if(wEn(13) = '1' and bitEnN(j) = '0') then
            field_rw_USER_DSTFSTART2_FSTART(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_DSTFSTART2_FSTART;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_DSTFSTART3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FSTART(35 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTFSTART3(35 downto 0) <= field_rw_USER_DSTFSTART3_FSTART(35 downto 0);
regfile.USER.DSTFSTART3.FSTART <= field_rw_USER_DSTFSTART3_FSTART(35 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTFSTART3_FSTART
------------------------------------------------------------------------------------------
P_USER_DSTFSTART3_FSTART : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTFSTART3_FSTART <= std_logic_vector(to_unsigned(integer(0),36));
   elsif (rising_edge(sysclk)) then
      for j in  35 downto 0  loop
         if(wEn(14) = '1' and bitEnN(j) = '0') then
            field_rw_USER_DSTFSTART3_FSTART(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_DSTFSTART3_FSTART;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_DSTCTRL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: BUFCLR
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(7) <= field_rw_USER_DSTCTRL_BUFCLR;
regfile.USER.DSTCTRL.BUFCLR <= field_rw_USER_DSTCTRL_BUFCLR;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_BUFCLR
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_BUFCLR : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_BUFCLR <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(7) = '0') then
         field_rw_USER_DSTCTRL_BUFCLR <= reg_writedata(7);
      end if;
   end if;
end process P_USER_DSTCTRL_BUFCLR;

------------------------------------------------------------------------------------------
-- Field name: DTE3
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(6) <= field_rw_USER_DSTCTRL_DTE3;
regfile.USER.DSTCTRL.DTE3 <= field_rw_USER_DSTCTRL_DTE3;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_DTE3
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_DTE3 : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_DTE3 <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(6) = '0') then
         field_rw_USER_DSTCTRL_DTE3 <= reg_writedata(6);
      end if;
   end if;
end process P_USER_DSTCTRL_DTE3;

------------------------------------------------------------------------------------------
-- Field name: DTE2
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(5) <= field_rw_USER_DSTCTRL_DTE2;
regfile.USER.DSTCTRL.DTE2 <= field_rw_USER_DSTCTRL_DTE2;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_DTE2
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_DTE2 : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_DTE2 <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(5) = '0') then
         field_rw_USER_DSTCTRL_DTE2 <= reg_writedata(5);
      end if;
   end if;
end process P_USER_DSTCTRL_DTE2;

------------------------------------------------------------------------------------------
-- Field name: DTE1
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(4) <= field_rw_USER_DSTCTRL_DTE1;
regfile.USER.DSTCTRL.DTE1 <= field_rw_USER_DSTCTRL_DTE1;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_DTE1
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_DTE1 : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_DTE1 <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(4) = '0') then
         field_rw_USER_DSTCTRL_DTE1 <= reg_writedata(4);
      end if;
   end if;
end process P_USER_DSTCTRL_DTE1;

------------------------------------------------------------------------------------------
-- Field name: DTE0
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(3) <= field_rw_USER_DSTCTRL_DTE0;
regfile.USER.DSTCTRL.DTE0 <= field_rw_USER_DSTCTRL_DTE0;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_DTE0
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_DTE0 : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_DTE0 <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(3) = '0') then
         field_rw_USER_DSTCTRL_DTE0 <= reg_writedata(3);
      end if;
   end if;
end process P_USER_DSTCTRL_DTE0;

------------------------------------------------------------------------------------------
-- Field name: BITWDTH
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(2) <= field_rw_USER_DSTCTRL_BITWDTH;
regfile.USER.DSTCTRL.BITWDTH <= field_rw_USER_DSTCTRL_BITWDTH;


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_BITWDTH
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_BITWDTH : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_BITWDTH <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(15) = '1' and bitEnN(2) = '0') then
         field_rw_USER_DSTCTRL_BITWDTH <= reg_writedata(2);
      end if;
   end if;
end process P_USER_DSTCTRL_BITWDTH;

------------------------------------------------------------------------------------------
-- Field name: NBCONTX(1 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCTRL(1 downto 0) <= field_rw_USER_DSTCTRL_NBCONTX(1 downto 0);
regfile.USER.DSTCTRL.NBCONTX <= field_rw_USER_DSTCTRL_NBCONTX(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCTRL_NBCONTX
------------------------------------------------------------------------------------------
P_USER_DSTCTRL_NBCONTX : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCTRL_NBCONTX <= std_logic_vector(to_unsigned(integer(0),2));
   elsif (rising_edge(sysclk)) then
      for j in  1 downto 0  loop
         if(wEn(15) = '1' and bitEnN(j) = '0') then
            field_rw_USER_DSTCTRL_NBCONTX(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_DSTCTRL_NBCONTX;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: USER_DSTCLRPTRN
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(16) <= (hit(16)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CLRPTRN(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_USER_DSTCLRPTRN(31 downto 0) <= field_rw_USER_DSTCLRPTRN_CLRPTRN(31 downto 0);
regfile.USER.DSTCLRPTRN.CLRPTRN <= field_rw_USER_DSTCLRPTRN_CLRPTRN(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_USER_DSTCLRPTRN_CLRPTRN
------------------------------------------------------------------------------------------
P_USER_DSTCLRPTRN_CLRPTRN : process(sysclk, sysrstN)
begin
   if (sysrstN = '0') then
      field_rw_USER_DSTCLRPTRN_CLRPTRN <= std_logic_vector(to_unsigned(integer(0),32));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(16) = '1' and bitEnN(j) = '0') then
            field_rw_USER_DSTCLRPTRN_CLRPTRN(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_USER_DSTCLRPTRN_CLRPTRN;

ldData <= reg_read;

end rtl;

