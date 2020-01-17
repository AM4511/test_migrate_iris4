------------------------------------------------------------------------------
-- File:        userio_bank.vhd
-- Decription:  User I/O.
--              Every bit can:
--              -output one data (controlled by the user or one exposure)
--              -Input one data (with polarity control)
--              -Generate one interrupt (resync on sysclk and edge detection)
--              
--              NOTE: to be more reusable, we split the data in 3 busses. Data_out,
--                    data_in and dir.  To use it with a Inout pin, write:
--                    data_pin <= data_out when dir = '1' else 'z';
--                    data_in <= data_pin;
--                    dir_pin <= dir; (if applicable)
--
--                    To use it with open drain driver (1 data in and 1 data out):
--                    data_out_pin <= '1' when dir = '1' else data_out;
--                    data_in <= data_in_pin;
--
-- Created by:  Jean-Francois Larin
-- Date:        23 juillet 2013
-- Project:     Spider GPM
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
--use work.regfile_spider_lpc_pack.all;
use work.spider_pak.all;

entity userio_bank is
  generic(
    width           : integer range 1 to 32;
    input_active    : boolean := TRUE; -- can be used as input
    output_active   : boolean := TRUE; -- can be used as output
    int_number      : integer -- interrupt bit where the interrupts are forwarded
    );
  port(
    sysclk          : in    std_logic;

    data_in         : in    std_logic_vector(width-1 downto 0); -- input from the fpga pin
    data_out        : out   std_logic_vector(width-1 downto 0); -- output, has to go through logic or tristate driver

    dir             : out   std_logic_vector(width-1 downto 0); -- 0 if data is input, 1 if data is output
    int_line        : out   std_logic; -- interrupt line active high
    
    regfile         : inout IO_TYPE := INIT_IO_TYPE-- interface a un fichier
  );
end userio_bank;

architecture functionnal of userio_bank is



  --signal io_out   : std_logic_vector(data_out'range);

  signal dir_interne      : std_logic_vector(data_out'range);
  signal dir_interne_buf  : std_logic_vector(data_out'range);
  signal in_pol           : std_logic_vector(data_out'range) := (others => '0');  -- pour enlever un faux warning, car il n'y a pas d'interrupt s'il n'y a pas d'input.
  --signal io_outsel        : std_logic_vector(data_out'range);
  --signal io_outsel_buf    : std_logic_vector(data_out'range);
  --signal io_outsel_sel    : std_logic; -- for address decode for the readback of the data
  signal pin_value_p1     : std_logic_vector(data_out'range);
  signal pin_value_p2     : std_logic_vector(data_out'range);
  signal intmaskn         : std_logic_vector(data_out'range);
  --signal intstat          : std_logic_vector(data_out'range);
  --signal capabilities     : std_logic_vector(31 downto 12);
  signal pin_value_edge   : std_logic_vector(data_out'range);
  signal dummy            : std_logic;
begin


  ------------------------------
  -- CAPABILITIES IO Register --
 ------------------------------
  capgen: process(sysclk)
  begin
    regfile.CAPABILITIES_IO.N_port <= conv_std_logic_vector(width-1,5);
    if input_active = TRUE then
      regfile.CAPABILITIES_IO.Input <= '1';
    else
      regfile.CAPABILITIES_IO.Input <= '0';
    end if;      
    if output_active = TRUE then
      regfile.CAPABILITIES_IO.Output <= '1';
    else
      regfile.CAPABILITIES_IO.Output <= '0';
    end if;      
    regfile.CAPABILITIES_IO.Intnum <= conv_std_logic_vector(int_number,5);
    --    wait;
    if rising_edge(sysclk) then
      dummy <= '0';
    end if;
  end process;


  ---------------------
  -- IO_PIN Register --
  ---------------------
  rb_gen: if input_active = TRUE generate
    process(pin_value_p2)
    begin
      regfile.IO_PIN.Pin_value <= (others => '0');
      regfile.IO_PIN.Pin_value(pin_value_p2'range) <= pin_value_p2;
    end process;
  end generate;

  ---------------------
  -- IO_OUT Register --
  ---------------------
  io_outgen: if output_active = TRUE generate
    data_out <= regfile.IO_OUT.Out_value(data_out'range);
  end generate;

  ---------------------
  -- IO_DIR Register --
  ---------------------
  dirgen: if input_active = TRUE and output_active = TRUE generate
    dir_interne_buf <= regfile.IO_DIR.Dir(dir_interne_buf'range);
    dir_interne <= dir_interne_buf;
  end generate;

  nodirnoin_gen: if input_active = FALSE generate
    dir_interne <= (others => '1');
  end generate;

  nodirnoout_gen: if output_active = FALSE generate
    dir_interne <= (others => '0');
  end generate;

  ---------------------
  -- IO_POL Register --
  ---------------------
  polgen: if input_active = TRUE generate
    in_pol <= regfile.IO_POL.In_pol(in_pol'range);
  end generate;

  -------------------------
  -- IO_INTSTAT Register --
  -------------------------
  process(pin_value_edge,intmaskn)
  begin
    regfile.IO_INTSTAT.Intstat_set <= (others => '0');
    regfile.IO_INTSTAT.Intstat_set(intmaskn'range) <= (pin_value_edge and intmaskn); -- l'interrupt apparait seulement si le mask le permet
  end process;

  -- interrupt processing
  -- and interrupt is only asserted when one interrupt is active (intstat)
  int_line <= '0' when conv_integer(regfile.IO_INTSTAT.Intstat) = 0 else '1';

  -------------------------
  -- IO_INTMASKn Register --
  -------------------------
  intmaskn <= regfile.IO_INTMASKn.Intmaskn(intmaskn'range);

  ------------------------
  -- IO_OUTSEL Register --
  ------------------------
  --outselgen: if alternate_output_active = TRUE generate
    -- a etre code, si jamais reutilise sur spider.
  --end generate;

  -- if no alternate, then we must hardcode to 0
  --nooutselgen: if alternate_output_active = FALSE generate
  --  io_outsel <= (others => '0');
  --end generate;

  -- output of this module
  dir <= dir_interne;

  --edge detection
  edge_det: process(sysclk)
  begin
    if rising_edge(sysclk) then
      pin_value_p1 <= data_in;
      pin_value_p2 <= pin_value_p1;
      for i in pin_value_p1'range loop
        if regfile.IO_ANYEDGE.In_AnyEdge(i) =  '1' then
          pin_value_edge(i) <= pin_value_p1(i) xor pin_value_p2(i); -- any edge
        elsif in_pol(i) = '0' then
          pin_value_edge(i) <= pin_value_p1(i) and not pin_value_p2(i); -- rising edge
        else
          pin_value_edge(i) <= not pin_value_p1(i) and pin_value_p2(i); -- falling edge
        end if;
      end loop;
    end if;
  end process;  

end functionnal;
               

