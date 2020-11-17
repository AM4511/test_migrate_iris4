library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package hispi_pack is
  -- constant HISPI_PIXEL_SIZE    : integer := 20;
  -- constant MAX_PIXELS_PER_LINE : integer := 1280;
  -- constant MAX_LINES_PER_FRAME : integer := 960;
  type FSM_STATE_TYPE is (S_DISABLED, S_IDLE, S_EMBEDED, S_SOF, S_EOF, S_SOL, S_EOL, S_FLR, S_AIL, S_CRC1, S_CRC2, S_ERROR);

  subtype PIXEL_TYPE is std_logic_vector(9 downto 0);
  type PIXEL_ARRAY is array (natural range <>) of PIXEL_TYPE;

  function to_pixel(stdlv            : std_logic_vector(9 downto 0)) return PIXEL_TYPE;
  function to_std_logic_vector(pixel : PIXEL_TYPE) return std_logic_vector;

end package hispi_pack;

package body hispi_pack is

  --------------------------------------------------------------------------------
  -- Function Name: to_pixel
  -- Description: Cast from std_logic_vector(9 downto 0) to PIXEL_TYPE
  --------------------------------------------------------------------------------
  function to_pixel(stdlv : std_logic_vector(9 downto 0)) return PIXEL_TYPE is
    variable pixel : PIXEL_TYPE;
  begin
    pixel := stdlv(9 downto 0);
    return pixel;
  end to_pixel;

  --------------------------------------------------------------------------------
  -- Function Name: std_logic_vector
  -- Description: Cast from SYSTEM_VERSION_TYPE to std_logic_vector
  --------------------------------------------------------------------------------
  function to_std_logic_vector(pixel : PIXEL_TYPE) return std_logic_vector is
    variable slv : std_logic_vector(pixel'range);
  begin
    slv := pixel;
    return slv;
  end to_std_logic_vector;


end package body hispi_pack;
