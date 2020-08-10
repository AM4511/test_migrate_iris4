-------------------------------------------------------------------------------
-- File                : regfile_i2c.vhd
-- Project             : FDK
-- Module              : regfile_i2c_pack
-- Created on          : 2020/08/06 14:21:42
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x8865ADCE
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_i2c_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_I2C_I2C_ID_ADDR       : natural := 16#0#;
   constant K_I2C_I2C_CTRL0_ADDR    : natural := 16#8#;
   constant K_I2C_I2C_CTRL1_ADDR    : natural := 16#10#;
   constant K_I2C_I2C_SEMAPHORE_ADDR : natural := 16#18#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: I2C_ID
   ------------------------------------------------------------------------------------------
   type I2C_I2C_ID_TYPE is record
      CLOCK_STRETCHING: std_logic;
      NI_ACCESS      : std_logic;
      ID             : std_logic_vector(11 downto 0);
   end record I2C_I2C_ID_TYPE;

   constant INIT_I2C_I2C_ID_TYPE : I2C_I2C_ID_TYPE := (
      CLOCK_STRETCHING => 'Z',
      NI_ACCESS       => 'Z',
      ID              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : I2C_I2C_ID_TYPE) return std_logic_vector;
   function to_I2C_I2C_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_ID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: I2C_CTRL0
   ------------------------------------------------------------------------------------------
   type I2C_I2C_CTRL0_TYPE is record
      I2C_INDEX      : std_logic_vector(7 downto 0);
      NI_ACC         : std_logic;
      BUS_SEL        : std_logic_vector(1 downto 0);
      TRIGGER        : std_logic;
      I2C_DATA_READ  : std_logic_vector(7 downto 0);
      I2C_DATA_WRITE : std_logic_vector(7 downto 0);
   end record I2C_I2C_CTRL0_TYPE;

   constant INIT_I2C_I2C_CTRL0_TYPE : I2C_I2C_CTRL0_TYPE := (
      I2C_INDEX       => (others=> 'Z'),
      NI_ACC          => 'Z',
      BUS_SEL         => (others=> 'Z'),
      TRIGGER         => 'Z',
      I2C_DATA_READ   => (others=> 'Z'),
      I2C_DATA_WRITE  => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : I2C_I2C_CTRL0_TYPE) return std_logic_vector;
   function to_I2C_I2C_CTRL0_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_CTRL0_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: I2C_CTRL1
   ------------------------------------------------------------------------------------------
   type I2C_I2C_CTRL1_TYPE is record
      I2C_ERROR      : std_logic;
      BUSY           : std_logic;
      WRITING        : std_logic;
      READING        : std_logic;
      I2C_DEVICE_ID  : std_logic_vector(6 downto 0);
      I2C_RW         : std_logic;
   end record I2C_I2C_CTRL1_TYPE;

   constant INIT_I2C_I2C_CTRL1_TYPE : I2C_I2C_CTRL1_TYPE := (
      I2C_ERROR       => 'Z',
      BUSY            => 'Z',
      WRITING         => 'Z',
      READING         => 'Z',
      I2C_DEVICE_ID   => (others=> 'Z'),
      I2C_RW          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : I2C_I2C_CTRL1_TYPE) return std_logic_vector;
   function to_I2C_I2C_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_CTRL1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: I2C_SEMAPHORE
   ------------------------------------------------------------------------------------------
   type I2C_I2C_SEMAPHORE_TYPE is record
      I2C_IN_USE     : std_logic;
      I2C_IN_USE_set : std_logic;
   end record I2C_I2C_SEMAPHORE_TYPE;

   constant INIT_I2C_I2C_SEMAPHORE_TYPE : I2C_I2C_SEMAPHORE_TYPE := (
      I2C_IN_USE      => 'Z',
      I2C_IN_USE_set  => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : I2C_I2C_SEMAPHORE_TYPE) return std_logic_vector;
   function to_I2C_I2C_SEMAPHORE_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_SEMAPHORE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: I2C
   ------------------------------------------------------------------------------------------
   type I2C_TYPE is record
      I2C_ID         : I2C_I2C_ID_TYPE;
      I2C_CTRL0      : I2C_I2C_CTRL0_TYPE;
      I2C_CTRL1      : I2C_I2C_CTRL1_TYPE;
      I2C_SEMAPHORE  : I2C_I2C_SEMAPHORE_TYPE;
   end record I2C_TYPE;

   constant INIT_I2C_TYPE : I2C_TYPE := (
      I2C_ID          => INIT_I2C_I2C_ID_TYPE,
      I2C_CTRL0       => INIT_I2C_I2C_CTRL0_TYPE,
      I2C_CTRL1       => INIT_I2C_I2C_CTRL1_TYPE,
      I2C_SEMAPHORE   => INIT_I2C_I2C_SEMAPHORE_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_i2c
   ------------------------------------------------------------------------------------------
   type REGFILE_I2C_TYPE is record
      I2C            : I2C_TYPE;
   end record REGFILE_I2C_TYPE;

   constant INIT_REGFILE_I2C_TYPE : REGFILE_I2C_TYPE := (
      I2C             => INIT_I2C_TYPE
   );

   
end regfile_i2c_pack;

package body regfile_i2c_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from I2C_I2C_ID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : I2C_I2C_ID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(17) := reg.CLOCK_STRETCHING;
      output(16) := reg.NI_ACCESS;
      output(11 downto 0) := reg.ID;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_I2C_I2C_ID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to I2C_I2C_ID_TYPE
   --------------------------------------------------------------------------------
   function to_I2C_I2C_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_ID_TYPE is
   variable output : I2C_I2C_ID_TYPE;
   begin
      output.CLOCK_STRETCHING := stdlv(17);
      output.NI_ACCESS := stdlv(16);
      output.ID := stdlv(11 downto 0);
      return output;
   end to_I2C_I2C_ID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from I2C_I2C_CTRL0_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : I2C_I2C_CTRL0_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.I2C_INDEX;
      output(23) := reg.NI_ACC;
      output(18 downto 17) := reg.BUS_SEL;
      output(16) := reg.TRIGGER;
      output(15 downto 8) := reg.I2C_DATA_READ;
      output(7 downto 0) := reg.I2C_DATA_WRITE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_I2C_I2C_CTRL0_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to I2C_I2C_CTRL0_TYPE
   --------------------------------------------------------------------------------
   function to_I2C_I2C_CTRL0_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_CTRL0_TYPE is
   variable output : I2C_I2C_CTRL0_TYPE;
   begin
      output.I2C_INDEX := stdlv(31 downto 24);
      output.NI_ACC := stdlv(23);
      output.BUS_SEL := stdlv(18 downto 17);
      output.TRIGGER := stdlv(16);
      output.I2C_DATA_READ := stdlv(15 downto 8);
      output.I2C_DATA_WRITE := stdlv(7 downto 0);
      return output;
   end to_I2C_I2C_CTRL0_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from I2C_I2C_CTRL1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : I2C_I2C_CTRL1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.I2C_ERROR;
      output(27) := reg.BUSY;
      output(26) := reg.WRITING;
      output(25) := reg.READING;
      output(7 downto 1) := reg.I2C_DEVICE_ID;
      output(0) := reg.I2C_RW;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_I2C_I2C_CTRL1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to I2C_I2C_CTRL1_TYPE
   --------------------------------------------------------------------------------
   function to_I2C_I2C_CTRL1_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_CTRL1_TYPE is
   variable output : I2C_I2C_CTRL1_TYPE;
   begin
      output.I2C_ERROR := stdlv(28);
      output.BUSY := stdlv(27);
      output.WRITING := stdlv(26);
      output.READING := stdlv(25);
      output.I2C_DEVICE_ID := stdlv(7 downto 1);
      output.I2C_RW := stdlv(0);
      return output;
   end to_I2C_I2C_CTRL1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from I2C_I2C_SEMAPHORE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : I2C_I2C_SEMAPHORE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.I2C_IN_USE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_I2C_I2C_SEMAPHORE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to I2C_I2C_SEMAPHORE_TYPE
   --------------------------------------------------------------------------------
   function to_I2C_I2C_SEMAPHORE_TYPE(stdlv : std_logic_vector(31 downto 0)) return I2C_I2C_SEMAPHORE_TYPE is
   variable output : I2C_I2C_SEMAPHORE_TYPE;
   begin
      output.I2C_IN_USE := stdlv(0);
      return output;
   end to_I2C_I2C_SEMAPHORE_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_i2c.vhd
-- Project             : FDK
-- Module              : regfile_i2c
-- Created on          : 2020/08/06 14:21:42
-- Created by          : imaval
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0x8865ADCE
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_i2c_pack.all;


entity regfile_i2c is
   
   port (
      resetN        : in    std_logic;                                 -- System reset
      sysclk        : in    std_logic;                                 -- System clock
      regfile       : inout REGFILE_I2C_TYPE := INIT_REGFILE_I2C_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                 -- Read
      reg_write     : in    std_logic;                                 -- Write
      reg_addr      : in    std_logic_vector(11 downto 2);             -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);              -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);             -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)              -- Read data
   );
   
end regfile_i2c;

architecture rtl of regfile_i2c is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                             : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                     : std_logic_vector(3 downto 0);                    -- Address decode hit
signal wEn                                     : std_logic_vector(3 downto 0);                    -- Write Enable
signal fullAddr                                : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                           : integer;                                        
signal bitEnN                                  : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                  : std_logic;                                      
signal rb_I2C_I2C_ID                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_I2C_I2C_CTRL0                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_I2C_I2C_CTRL1                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_I2C_I2C_SEMAPHORE                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_I2C_I2C_CTRL0_I2C_INDEX        : std_logic_vector(7 downto 0);                    -- Field: I2C_INDEX
signal field_rw_I2C_I2C_CTRL0_NI_ACC           : std_logic;                                       -- Field: NI_ACC
signal field_wautoclr_I2C_I2C_CTRL0_TRIGGER    : std_logic;                                       -- Field: TRIGGER
signal field_rw_I2C_I2C_CTRL0_I2C_DATA_WRITE   : std_logic_vector(7 downto 0);                    -- Field: I2C_DATA_WRITE
signal field_rw_I2C_I2C_CTRL1_I2C_DEVICE_ID    : std_logic_vector(6 downto 0);                    -- Field: I2C_DEVICE_ID
signal field_rw_I2C_I2C_CTRL1_I2C_RW           : std_logic;                                       -- Field: I2C_RW
signal field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE : std_logic;                                       -- Field: I2C_IN_USE

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
fullAddr(11 downto 2)<= reg_addr;

hit(0) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	I2C_ID
hit(1) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	I2C_CTRL0
hit(2) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,12)))	else '0'; -- Addr:  0x0010	I2C_CTRL1
hit(3) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#18#,12)))	else '0'; -- Addr:  0x0018	I2C_SEMAPHORE



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_I2C_I2C_ID,
                            rb_I2C_I2C_CTRL0,
                            rb_I2C_I2C_CTRL1,
                            rb_I2C_I2C_SEMAPHORE
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /I2C/I2C_ID
      when 16#0# =>
         readBackMux <= rb_I2C_I2C_ID;

      -- [0x008]: /I2C/I2C_CTRL0
      when 16#8# =>
         readBackMux <= rb_I2C_I2C_CTRL0;

      -- [0x010]: /I2C/I2C_CTRL1
      when 16#10# =>
         readBackMux <= rb_I2C_I2C_CTRL1;

      -- [0x018]: /I2C/I2C_SEMAPHORE
      when 16#18# =>
         readBackMux <= rb_I2C_I2C_SEMAPHORE;

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
-- Register name: I2C_I2C_ID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CLOCK_STRETCHING
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_ID(17) <= regfile.I2C.I2C_ID.CLOCK_STRETCHING;


------------------------------------------------------------------------------------------
-- Field name: NI_ACCESS
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_ID(16) <= regfile.I2C.I2C_ID.NI_ACCESS;


------------------------------------------------------------------------------------------
-- Field name: ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_I2C_I2C_ID(11 downto 0) <= std_logic_vector(to_unsigned(integer(300),12));
regfile.I2C.I2C_ID.ID <= rb_I2C_I2C_ID(11 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: I2C_I2C_CTRL0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: I2C_INDEX(31 downto 24)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(31 downto 24) <= field_rw_I2C_I2C_CTRL0_I2C_INDEX(7 downto 0);
regfile.I2C.I2C_CTRL0.I2C_INDEX <= field_rw_I2C_I2C_CTRL0_I2C_INDEX(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL0_I2C_INDEX
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL0_I2C_INDEX : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_I2C_I2C_CTRL0_I2C_INDEX <= std_logic_vector(to_unsigned(integer(0),8));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 24  loop
         if(wEn(1) = '1' and bitEnN(j) = '0') then
            field_rw_I2C_I2C_CTRL0_I2C_INDEX(j-24) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_I2C_I2C_CTRL0_I2C_INDEX;

------------------------------------------------------------------------------------------
-- Field name: NI_ACC
-- Field type: RW
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(23) <= field_rw_I2C_I2C_CTRL0_NI_ACC;
regfile.I2C.I2C_CTRL0.NI_ACC <= field_rw_I2C_I2C_CTRL0_NI_ACC;


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL0_NI_ACC
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL0_NI_ACC : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_I2C_I2C_CTRL0_NI_ACC <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(1) = '1' and bitEnN(23) = '0') then
         field_rw_I2C_I2C_CTRL0_NI_ACC <= reg_writedata(23);
      end if;
   end if;
end process P_I2C_I2C_CTRL0_NI_ACC;

------------------------------------------------------------------------------------------
-- Field name: BUS_SEL
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(18 downto 17) <= std_logic_vector(to_unsigned(integer(0),2));
regfile.I2C.I2C_CTRL0.BUS_SEL <= rb_I2C_I2C_CTRL0(18 downto 17);


------------------------------------------------------------------------------------------
-- Field name: TRIGGER
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(16) <= '0';
regfile.I2C.I2C_CTRL0.TRIGGER <= field_wautoclr_I2C_I2C_CTRL0_TRIGGER;


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL0_TRIGGER
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL0_TRIGGER : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_I2C_I2C_CTRL0_TRIGGER <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(1) = '1' and bitEnN(16) = '0') then
         field_wautoclr_I2C_I2C_CTRL0_TRIGGER <= reg_writedata(16);
      else
         field_wautoclr_I2C_I2C_CTRL0_TRIGGER <= '0';
      end if;
   end if;
end process P_I2C_I2C_CTRL0_TRIGGER;

------------------------------------------------------------------------------------------
-- Field name: I2C_DATA_READ(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(15 downto 8) <= regfile.I2C.I2C_CTRL0.I2C_DATA_READ;


------------------------------------------------------------------------------------------
-- Field name: I2C_DATA_WRITE(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL0(7 downto 0) <= field_rw_I2C_I2C_CTRL0_I2C_DATA_WRITE(7 downto 0);
regfile.I2C.I2C_CTRL0.I2C_DATA_WRITE <= field_rw_I2C_I2C_CTRL0_I2C_DATA_WRITE(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL0_I2C_DATA_WRITE
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL0_I2C_DATA_WRITE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_I2C_I2C_CTRL0_I2C_DATA_WRITE <= std_logic_vector(to_unsigned(integer(0),8));
   elsif (rising_edge(sysclk)) then
      for j in  7 downto 0  loop
         if(wEn(1) = '1' and bitEnN(j) = '0') then
            field_rw_I2C_I2C_CTRL0_I2C_DATA_WRITE(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_I2C_I2C_CTRL0_I2C_DATA_WRITE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: I2C_I2C_CTRL1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: I2C_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(28) <= regfile.I2C.I2C_CTRL1.I2C_ERROR;


------------------------------------------------------------------------------------------
-- Field name: BUSY
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(27) <= regfile.I2C.I2C_CTRL1.BUSY;


------------------------------------------------------------------------------------------
-- Field name: WRITING
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(26) <= regfile.I2C.I2C_CTRL1.WRITING;


------------------------------------------------------------------------------------------
-- Field name: READING
-- Field type: RO
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(25) <= regfile.I2C.I2C_CTRL1.READING;


------------------------------------------------------------------------------------------
-- Field name: I2C_DEVICE_ID(7 downto 1)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(7 downto 1) <= field_rw_I2C_I2C_CTRL1_I2C_DEVICE_ID(6 downto 0);
regfile.I2C.I2C_CTRL1.I2C_DEVICE_ID <= field_rw_I2C_I2C_CTRL1_I2C_DEVICE_ID(6 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL1_I2C_DEVICE_ID
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL1_I2C_DEVICE_ID : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_I2C_I2C_CTRL1_I2C_DEVICE_ID <= std_logic_vector(to_unsigned(integer(68),7));
   elsif (rising_edge(sysclk)) then
      for j in  7 downto 1  loop
         if(wEn(2) = '1' and bitEnN(j) = '0') then
            field_rw_I2C_I2C_CTRL1_I2C_DEVICE_ID(j-1) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_I2C_I2C_CTRL1_I2C_DEVICE_ID;

------------------------------------------------------------------------------------------
-- Field name: I2C_RW
-- Field type: RW
------------------------------------------------------------------------------------------
rb_I2C_I2C_CTRL1(0) <= field_rw_I2C_I2C_CTRL1_I2C_RW;
regfile.I2C.I2C_CTRL1.I2C_RW <= field_rw_I2C_I2C_CTRL1_I2C_RW;


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_CTRL1_I2C_RW
------------------------------------------------------------------------------------------
P_I2C_I2C_CTRL1_I2C_RW : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_I2C_I2C_CTRL1_I2C_RW <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(2) = '1' and bitEnN(0) = '0') then
         field_rw_I2C_I2C_CTRL1_I2C_RW <= reg_writedata(0);
      end if;
   end if;
end process P_I2C_I2C_CTRL1_I2C_RW;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: I2C_I2C_SEMAPHORE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: I2C_IN_USE
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_I2C_I2C_SEMAPHORE(0) <= field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE;
regfile.I2C.I2C_SEMAPHORE.I2C_IN_USE <= field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE;


------------------------------------------------------------------------------------------
-- Process: P_I2C_I2C_SEMAPHORE_I2C_IN_USE
------------------------------------------------------------------------------------------
P_I2C_I2C_SEMAPHORE_I2C_IN_USE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(3) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
         -- Clear the field to '0'
         field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE <= '0';
      else
         -- Set the field to '1'
         field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE <= field_rw2c_I2C_I2C_SEMAPHORE_I2C_IN_USE or regfile.I2C.I2C_SEMAPHORE.I2C_IN_USE_set;
      end if;
   end if;
end process P_I2C_I2C_SEMAPHORE_I2C_IN_USE;

ldData <= reg_read;

end rtl;

