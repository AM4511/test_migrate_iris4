library ieee;
use ieee.std_logic_1164.all;

package dma_pack is

  type HOST_ADDRESS_ARRAY is array(natural range <>) of std_logic_vector(63 downto 0);

  type DMA_CONTEXT_TYPE is record
    frame_start : HOST_ADDRESS_ARRAY(2 downto 0);
    line_pitch  : std_logic_vector(15 downto 0);
    line_size   : std_logic_vector(14 downto 0);
    reverse_y   : std_logic;
    numb_plane  : integer;
  end record DMA_CONTEXT_TYPE;

  constant INIT_DMA_CONTEXT_TYPE : DMA_CONTEXT_TYPE := (
    frame_start => (others => (others => '0')),
    line_pitch  => (others => '0'),
    line_size   => (others => '0'),
    reverse_y   => '0',
    numb_plane  => 0
    );


end dma_pack;


