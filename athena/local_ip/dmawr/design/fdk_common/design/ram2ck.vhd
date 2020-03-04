-- Following libraries have to be used
library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity ram2ck is
  generic
    (
      C_NB_COL          : integer              := 4;  -- Specify number of colums (number of bytes)
      C_COL_WIDTH       : integer range 8 to 9 := 8;  -- Specify column width (byte width, typically 8 or 9)
      C_ADDRWIDTH       : integer              := 12
      );
  port
    (
      wr_clk   : in  std_logic := '1';
      wr_en    : in  std_logic := '0';
      wr_data  : in  std_logic_vector ((C_NB_COL*C_COL_WIDTH)-1 downto 0);
      wr_addr  : in  std_logic_vector (C_ADDRWIDTH-1 downto 0);
      wr_ben   : in  std_logic_vector (C_NB_COL-1 downto 0);
      rd_clk   : in  std_logic;
      rd_addr  : in  std_logic_vector (C_ADDRWIDTH-1 downto 0);
      rd_en    : in  std_logic := '1';
      rd_data  : out std_logic_vector((C_NB_COL*C_COL_WIDTH)-1 downto 0)
      );
end ram2ck;


architecture rtl of ram2ck is

  constant C_RAM_DEPTH : integer := 2**C_ADDRWIDTH;
  constant C_DATAWIDTH : integer := C_NB_COL*C_COL_WIDTH;
  type RAM_ARRAY_TYPE is array (C_RAM_DEPTH-1 downto 0) of std_logic_vector (C_DATAWIDTH-1 downto 0);

  signal ram_array   : RAM_ARRAY_TYPE;


begin


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_ram_write : process(wr_clk)
    variable waddr : integer;
    variable lsb : integer;
    variable msb : integer;
  begin
    if(rising_edge(wr_clk)) then
      for i in 0 to C_NB_COL-1 loop
        if(wr_ben(i) = '1') then
          waddr := to_integer(unsigned(wr_addr));
          lsb   := i*C_COL_WIDTH;
          msb   := lsb+C_COL_WIDTH-1;

          ram_array(waddr)(msb downto lsb) <= wr_data(msb downto lsb);
        end if;
      end loop;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_ram_read : process(rd_clk)
  begin
    if(rising_edge(rd_clk)) then
      if(rd_en = '1') then
        rd_data <= ram_array(to_integer(unsigned(rd_addr)));
      end if;
    end if;
  end process;



end rtl;
