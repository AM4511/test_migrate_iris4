-------------------------------------------------------------------------------
-- MODULE      : hispi_crc
--
-- DESCRIPTION : HiSPi 12 bits CRC counter
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.mtx_types_pkg.all;


entity hispi_crc is
  generic (
    PIXEL_SIZE : integer := 12
    );
  port (
    pclk          : in  std_logic;
    pclk_reset    : in  std_logic;
    pclk_crc_init : in  std_logic;
    pclk_crc_en   : in  std_logic;
    pclk_crc_data : in  std_logic_vector(PIXEL_SIZE-1 downto 0);
    pclk_crc1     : out std_logic_vector(PIXEL_SIZE-1 downto 0);
    pclk_crc2     : out std_logic_vector(PIXEL_SIZE-1 downto 0)
    );
end entity;


architecture rtl of hispi_crc is

  attribute mark_debug : string;
  attribute keep       : string;

  signal pclk_crc_result         : std_logic_vector(15 downto 0);
  signal pclk_crc_result_swapped : std_logic_vector(15 downto 0);


  -------------------------------------------------------------------------------
  -- Polynomial: x^16 + x^12 + x^5 + 1
  -- Data width: 12
  -- Convention: the first serial bit is D[11]
  -------------------------------------------------------------------------------
  function nextCRC16_D12(
    Data : std_logic_vector(11 downto 0);
    crc  : std_logic_vector(15 downto 0)
    )
    return std_logic_vector is

    variable d      : unsigned(11 downto 0);
    variable c      : unsigned(15 downto 0);
    variable newcrc : unsigned(15 downto 0);

  begin
    d := unsigned(Data);
    c := unsigned(crc);

    newcrc(0)  := d(11) xor d(8) xor d(4) xor d(0) xor c(4) xor c(8) xor c(12) xor c(15);
    newcrc(1)  := d(9) xor d(5) xor d(1) xor c(5) xor c(9) xor c(13);
    newcrc(2)  := d(10) xor d(6) xor d(2) xor c(6) xor c(10) xor c(14);
    newcrc(3)  := d(11) xor d(7) xor d(3) xor c(7) xor c(11) xor c(15);
    newcrc(4)  := d(8) xor d(4) xor c(8) xor c(12);
    newcrc(5)  := d(11) xor d(9) xor d(8) xor d(5) xor d(4) xor d(0) xor c(4) xor c(8) xor c(9) xor c(12) xor c(13) xor c(15);
    newcrc(6)  := d(10) xor d(9) xor d(6) xor d(5) xor d(1) xor c(5) xor c(9) xor c(10) xor c(13) xor c(14);
    newcrc(7)  := d(11) xor d(10) xor d(7) xor d(6) xor d(2) xor c(6) xor c(10) xor c(11) xor c(14) xor c(15);
    newcrc(8)  := d(11) xor d(8) xor d(7) xor d(3) xor c(7) xor c(11) xor c(12) xor c(15);
    newcrc(9)  := d(9) xor d(8) xor d(4) xor c(8) xor c(12) xor c(13);
    newcrc(10) := d(10) xor d(9) xor d(5) xor c(9) xor c(13) xor c(14);
    newcrc(11) := d(11) xor d(10) xor d(6) xor c(10) xor c(14) xor c(15);
    newcrc(12) := d(8) xor d(7) xor d(4) xor d(0) xor c(0) xor c(4) xor c(8) xor c(11) xor c(12);
    newcrc(13) := d(9) xor d(8) xor d(5) xor d(1) xor c(1) xor c(5) xor c(9) xor c(12) xor c(13);
    newcrc(14) := d(10) xor d(9) xor d(6) xor d(2) xor c(2) xor c(6) xor c(10) xor c(13) xor c(14);
    newcrc(15) := d(11) xor d(10) xor d(7) xor d(3) xor c(3) xor c(7) xor c(11) xor c(14) xor c(15);
    return std_logic_vector(newcrc);
  end nextCRC16_D12;


begin


  -----------------------------------------------------------------------------
  -- Process     : P_pclk_crc_result
  -- Description : Calculate the 12 bits CRC 
  -----------------------------------------------------------------------------
  P_pclk_crc_result : process (pclk) is
  begin
    if (rising_edge(pclk)) then
      if (pclk_reset = '1') then
        -- initialize with all 1's
        pclk_crc_result <= (others => '1');
      else
        if (pclk_crc_init = '1') then
          -- initialize with all 1's
          pclk_crc_result <= (others => '1');
        elsif (pclk_crc_en = '1') then
          pclk_crc_result <= nextCRC16_D12(pclk_crc_data, pclk_crc_result);
        end if;
      end if;
    end if;
  end process;


  G_swap : for i in 0 to 15 generate
   pclk_crc_result_swapped(15 - i) <= pclk_crc_result(i);
  end generate G_swap;
  
  pclk_crc1 <= "0001" & pclk_crc_result_swapped(15 downto 8);
  pclk_crc2 <= "0001" & pclk_crc_result_swapped(7 downto 0);



end architecture rtl;
