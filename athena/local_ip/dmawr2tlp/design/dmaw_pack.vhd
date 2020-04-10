library ieee;
  use ieee.std_logic_1164.all; 

package dma_pack is

  type HOST_ADDRESS_ARRAY is array(natural range <>) of std_logic_vector(63 downto 0);

  -- les parametres necessaires au DMA sont regroupes ici pour que le CSC (line_transfer) puisse enregistrer ces donnees
  -- et les garder valides au bon moment en fonction du handshake avec le DMA
  type DMA_PARAMETER_TYPE is record
    host_number_of_plane                : integer;
    host_write_address                  : HOST_ADDRESS_ARRAY(2 downto 0); -- ici on defini avec le nombre maximal de plan.  Si dans un projet specifique nous en avons plus, il faudra ajuster
    host_line_pitch                     : std_logic_vector(15 downto 0);
    host_line_size                      : std_logic_vector(13 downto 0);
    host_reverse_y                      : std_logic; -- ecrire a l'envers.
  end record DMA_PARAMETER_TYPE;
  -- La structure est definie ici car c'est fixe en fonction du DMA. Si le DMA est generalise et qu'il faut des structures differente dependant des projet, il faudra demenager cette structure.
  -- c'est seulement pratique de la mettre ici car elle est associe au DMA plus bas.


end dma_pack;


