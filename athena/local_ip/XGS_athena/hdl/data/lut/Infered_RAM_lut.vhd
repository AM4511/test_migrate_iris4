-----------------------------------------------------------------------
-- File:        Infered_RAM_lut
-- Decription:  SIMPLE INFERED RAM, with ramp initialisation
--              
-------------------------------------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.std_logic_unsigned.all;
  use IEEE.std_logic_arith.conv_std_logic_vector;
  use ieee.numeric_std.all;


library UNISIM;
  use UNISIM.VCOMPONENTS.all;

entity Infered_RAM_lut is
   generic (
           C_RAM_WIDTH      : integer := 8;                                                  -- Specify data width 
           C_RAM_DEPTH      : integer := 10                                                  -- Specify RAM depth (bits de l'adresse de la ram)
           );
   port (  
           RAM_W_clk        : in  std_logic;
           RAM_W_WRn        : in  std_logic:='1';                                            -- Write cycle
           RAM_W_enable     : in  std_logic:='0';                                            -- Write/READn enable
           RAM_W_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Write address bus, width determined from RAM_DEPTH
           RAM_W_data       : in  std_logic_vector(C_RAM_WIDTH-1 downto 0);                  -- RAM input data
           RAM_W_dataR      : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0');  -- RAM read data

           RAM_R_clk        : in  std_logic;
           RAM_R_enable     : in  std_logic:='0';                                            -- Read enable
           RAM_R_address    : in  std_logic_vector(C_RAM_DEPTH-1 downto 0);                  -- Read address bus, width determined from RAM_DEPTH
           RAM_R_data       : out std_logic_vector(C_RAM_WIDTH-1 downto 0):= (others=>'0')   -- RAM output data
        );
end Infered_RAM_lut;

------------------------------------------------------
-- Begin architecture structure
------------------------------------------------------

architecture functional of Infered_RAM_lut is


----------------------------------------------
--  Signals
----------------------------------------------
type ram_type is array ((2**C_RAM_DEPTH)-1 downto 0) of std_logic_vector (C_RAM_WIDTH-1 downto 0);          -- 2D Array Declaration for RAM signal
--signal shared_ram : ram_type := (others => (others => '0'));


--
-- Initialisation function
--
function init_ram(init_mode : in integer )
  return ram_type is 
  variable tmp : ram_type := (others => (others => '0'));
  begin 
    
	if(init_mode=8) then
      for addr_pos in 0 to ((2**C_RAM_DEPTH)/4 - 1) loop 
       -- Initialize 10 bits address x 8 bits data 
       tmp((addr_pos*4) + 0 ) := std_logic_vector(to_unsigned(addr_pos, C_RAM_WIDTH));
       tmp((addr_pos*4) + 1 ) := std_logic_vector(to_unsigned(addr_pos, C_RAM_WIDTH));
       tmp((addr_pos*4) + 2 ) := std_logic_vector(to_unsigned(addr_pos, C_RAM_WIDTH));
       tmp((addr_pos*4) + 3 ) := std_logic_vector(to_unsigned(addr_pos, C_RAM_WIDTH));
      end loop;
	elsif(init_mode=10)	then
      for addr_pos in 0 to ((2**C_RAM_DEPTH) - 1) loop 
        -- Initialize 10 bits address x 10 bits data 
        tmp(addr_pos ) := std_logic_vector(to_unsigned(addr_pos, C_RAM_WIDTH));
      end loop;
    end if;
	
  return tmp;
end init_ram;

signal shared_ram : ram_type := init_ram(C_RAM_WIDTH);




BEGIN

  -------------------------------------------------------
  -- INFERED RAM
  -------------------------------------------------------

  -- WRITE RAM INFERE
  process(RAM_W_clk) begin
    if(RAM_W_clk'event and RAM_W_clk = '1') then
      if(RAM_W_enable = '1') then                                              --Write cycle
        if(RAM_W_WRn='1') then
          shared_ram(to_integer(unsigned(RAM_W_address))) <= RAM_W_data;
        else                                                                   --Read cycle
          RAM_W_dataR <= shared_ram(to_integer(unsigned(RAM_W_address)));
        end if;
      end if;
    end if;
  end process;


  -- READ RAM INFERE
  process(RAM_R_clk)
  begin
    if(RAM_R_clk'event and RAM_R_clk = '1') then
      if(RAM_R_enable = '1') then
        RAM_R_data <= shared_ram(to_integer(unsigned(RAM_R_address)));
      end if;
    end if;
  end process;



End functional;





