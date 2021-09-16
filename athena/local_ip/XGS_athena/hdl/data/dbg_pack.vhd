library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package dbg_pack is
  -- synthesis translate_off
  component dbg_strm is
    generic (
      output_file : string;
      module_name : string
      );
    port (
      ---------------------------------------------------------------------------
      -- AXI Slave interface
      ---------------------------------------------------------------------------
      aclk : in std_logic;

      ---------------------------------------------------------------------------
      -- AXI slave stream input interface
      ---------------------------------------------------------------------------
      aclk_tvalid : in std_logic;
      aclk_tuser  : in std_logic_vector(3 downto 0);
      aclk_tlast  : in std_logic;
      aclk_tdata  : in std_logic_vector(63 downto 0)
      );
  end component;
  -- synthesis translate_on

end package dbg_pack;

package body dbg_pack is


end package body dbg_pack;
