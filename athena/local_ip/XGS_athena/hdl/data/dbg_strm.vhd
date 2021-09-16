-------------------------------------------------------------------------------
-- MODULE        : 
-- 
-- DESCRIPTION   : 
--
-------------------------------------------------------------------------------
library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;          -- I/O for logic types

entity dbg_strm is
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
end dbg_strm;


architecture behavior of dbg_strm is

  file FILEH : text open write_mode is output_file;

begin


  -----------------------------------------------------------------------------
  -- Stream context management
  --
  -- Les contextes doivent etre loades sur le rising edge du signal. Il a été allongé 
  -- a 4 clk sysclk ds le controlleur pour l'envoyer dans le domaine pclk.
  -----------------------------------------------------------------------------
  P_aclk_write : process(aclk)
    variable message  : line;
    variable frame_id : integer := 0;
    variable row_id   : integer := 0;

  begin
    if (rising_edge(aclk)) then
      if (aclk_tvalid = '1') then
        deallocate(message);

        -----------------------------------------------------------------------
        -- Start of frame
        -----------------------------------------------------------------------
        if (aclk_tuser(0) = '1') then
          write(message, string'("###########################################"));
          writeline(FILEH, message);
          
          write(message, string'("# Frame ID : "));
          write(message, frame_id);
          writeline(FILEH, message);
          
          write(message, string'("###########################################"));
          writeline(FILEH, message);

          write(message, string'("# Row ID : "));
          write(message, row_id);
          writeline(FILEH, message);
        end if;

        
        -----------------------------------------------------------------------
        -- Start of row
        -----------------------------------------------------------------------
        if (aclk_tuser(2) = '1' and aclk_tuser(0) = '0') then
          write(message, string'("# Row ID : "));
          write(message, row_id);
          writeline(FILEH, message);
        end if;

        
        -----------------------------------------------------------------------
        -- Stream data
        -----------------------------------------------------------------------
        deallocate(message);
        write(message, now);
        write(message, string'(", "));
        hwrite(message, aclk_tdata);
        write(message, string'(", "));
        hwrite(message, aclk_tuser);
        writeline(FILEH, message);

        
        -----------------------------------------------------------------------
        -- End of frame
        -----------------------------------------------------------------------
        if (aclk_tuser(1) = '1') then
          write(message, string'("# End of Frame ID : "));
          write(message, frame_id);
          writeline(FILEH, message);
          frame_id := frame_id + 1;
          row_id   := 0;
        end if;
        
        -----------------------------------------------------------------------
        -- End of line
        -----------------------------------------------------------------------
        if (aclk_tuser(3) = '1') then
          row_id   := row_id + 1;
        end if;
        
      end if;
    end if;
  end process;

end architecture behavior;
