library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package hispi_pack is
  -- constant HISPI_PIXEL_SIZE    : integer := 20;
  -- constant MAX_PIXELS_PER_LINE : integer := 1280;
  -- constant MAX_LINES_PER_FRAME : integer := 960;
  type FSM_STATE_TYPE is (S_DISABLED, S_IDLE, S_EMBEDED, S_SOF, S_EOF, S_SOL, S_EOL, S_FLR, S_AIL, S_CRC1, S_CRC2, S_ERROR);



end package hispi_pack;

package body hispi_pack is



end package body hispi_pack;
