----------------------------------------------------------------------------------------
-- Name:        mtxDualPortRam
-- Type:        Inferred Generic RAM Bloc
-- Project:     mtx
--
-- Description: Inferred generic ram bloc used by the IP-Core.
--
-- Author(s):   Alain Marchand, Matrox Electronic Systems Ltd.
----------------------------------------------------------------------------------------
-- History:     V0.01 (am)
--               * initial release
----------------------------------------------------------------------------------------
-- SVN:         $Revision: 1530 $
--              $LastChangedDate: 2012-11-29 18:12:32 -0500 (Thu, 29 Nov 2012) $
--              $HeadURL:$
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mtxDualPortRam is
  generic
    (
      BYTESIZE  : integer := 8;         -- 8 or 9
      DATAWIDTH : integer := 32;        -- 32,36,40,64,128, etc.
      ADDRWIDTH : integer := 12
      );
  port
    (
      ben       : in  std_logic_vector ((DATAWIDTH/BYTESIZE)-1 downto 0);
      data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
      rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
      rdclock   : in  std_logic;
      rden      : in  std_logic := '1';
      wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
      wrclock   : in  std_logic := '1';
      wren      : in  std_logic := '0';
      q         : out std_logic_vector (DATAWIDTH-1 downto 0)
      );
end mtxDualPortRam;


architecture rtl of mtxDualPortRam is

  
  component altera_ram2p2c is
    generic
      (
        BYTESIZE  : integer := 8;       -- 8 or 9
        DATAWIDTH : integer := 32;      -- 32,36,40,64,128, etc.
        ADDRWIDTH : integer := 12
        );
    port
      (
        byteena_a : in  std_logic_vector ((DATAWIDTH/BYTESIZE)-1 downto 0) := (others => '1');
        data      : in  std_logic_vector (DATAWIDTH-1 downto 0);
        rdaddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        rdclock   : in  std_logic;
        rden      : in  std_logic                                          := '1';
        wraddress : in  std_logic_vector (ADDRWIDTH-1 downto 0);
        wrclock   : in  std_logic                                          := '1';
        wren      : in  std_logic                                          := '0';
        q         : out std_logic_vector (DATAWIDTH-1 downto 0)
        );
  end component;


  
begin

  xaltera_ram2p2c : altera_ram2p2c
    generic map (
      BYTESIZE  => BYTESIZE,
      DATAWIDTH => DATAWIDTH,
      ADDRWIDTH => ADDRWIDTH
      )
    port map (
      byteena_a => ben,
      data      => data,
      rdaddress => rdaddress,
      rdclock   => rdclock,
      rden      => rden,
      wraddress => wraddress,
      wrclock   => wrclock,
      wren      => wren,
      q         => q
      );

end rtl;
