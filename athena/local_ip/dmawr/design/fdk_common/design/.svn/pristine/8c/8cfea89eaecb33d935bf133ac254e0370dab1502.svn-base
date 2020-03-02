----------------------------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/bus_buffer_core.vhd $
-- $Revision: 9391 $
-- $Date: 2009-08-06 12:55:08 -0400 (Thu, 06 Aug 2009) $
-- $Author: mpoirie1 $
--
-- Description   : bus_buffer_core module
--
-- Functionality : Configurable module that adds a pipeline to a data path
--
--             .                          .                                 .
--             .     A_BUS_REGISTERED     .       B_WAIT_REGISTERED         .
--             .                          .                                 .
--             .                          .                                 .
--             .                          .                                 .
--             .                          .                                 .
--             .        ______            .                       |\        .
--             .       |      |           .                       | \       .
--             .       |      |           .                       |  \      .
--  A_bus(i) ----------|D    Q|-----------------------------------|0  |     .
--  (in)       .       |      |           .    |                  |   |     .
--             .       |  e   |           .    |     ______       |   |___________ B_bus(i)
--             .        ¯¯¯¯¯¯            .    |    |      |      |   |     .      (out)
--             .          |               .    |    |      |      |   |     .
--             .          |               .    -----|D    Q|------|1  |     .
--             .          |               .         |      |      |  /      .
--             .          |               .         |  e   |      | /|      .
--             .          |               .          ¯¯¯¯¯¯       |/ |      .
--             .          |               .            |             |      .
--             .          --------------------------------------------      .
--             .                          .    |                            .
--             .                          .    |     ______                 .
--             .                          .    |    |      |                .
--             .                          .    |    |      |                .
--  A_wait   ---------------------------------------|Q    D|---------------------- B_wait
--  (out)      .                          .         |      |                .      (in)
--             .                          .         |      |                .
--             .                          .          ¯¯¯¯¯¯                 .
--             .                          .                                 .
--             .                          .                                 .
--             .                          .                                 .
--             .                          .                                 .
--
--
--
--  Note: A_bus_reset allows to assign a specific pattern to A_bus registers
--         during reset (when A_BUS_REGISTERED = TRUE)
--
--
----------------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all; 


entity bus_buffer_core is
  generic (

    BUS_WIDTH                 : integer               ; -- width of A_bus/B_bus ports
    A_BUS_REGISTERED          : boolean := TRUE       ; -- add a register on A_bus input port
    B_WAIT_REGISTERED         : boolean := TRUE         -- add a register on B_wait input port and extra glue logic

  );
  port (

    ---------------------------------------------------------------------
    -- Reset, clock and mode signals
    ---------------------------------------------------------------------
    sysrstN                   : in        std_logic                     ;
    sysclk                    : in        std_logic                     ;
    ---------------------------------------------------------------------
    -- input side
    ---------------------------------------------------------------------
    A_bus_reset               : in        std_logic_vector(BUS_WIDTH-1 downto 0) := (others => '0');
    A_bus                     : in        std_logic_vector(BUS_WIDTH-1 downto 0);
    A_wait                    : buffer    std_logic                     ;
    ---------------------------------------------------------------------
    -- output side
    ---------------------------------------------------------------------
    B_bus                     : buffer    std_logic_vector(BUS_WIDTH-1 downto 0);
    B_wait                    : in        std_logic                     

  );
end bus_buffer_core;


architecture functional of bus_buffer_core is


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal A_bus_ff                  : std_logic_vector(BUS_WIDTH-1 downto 0);
  signal int_bus                   : std_logic_vector(BUS_WIDTH-1 downto 0);
  signal int_bus_ff                : std_logic_vector(BUS_WIDTH-1 downto 0);
  signal B_wait_ff                 : std_logic;                     
  signal B_bus_int                 : std_logic_vector(BUS_WIDTH-1 downto 0);
  signal A_wait_int                : std_logic;                     

  -----------------------------------------------------
  -- attributes
  -----------------------------------------------------


-------------------------------------------------------------------------------
-- Debut des process
-------------------------------------------------------------------------------
begin



-------------------------------------------------------------------------------
-- A_BUS_REGISTERED
-------------------------------------------------------------------------------
gen_A_bus_ff : if A_BUS_REGISTERED = TRUE generate

  process (sysrstN, sysclk, A_bus_reset)
    
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      A_bus_ff <= A_bus_reset;

       
    elsif (sysclk'event and sysclk = '1') then                                         

      -----------------
      -- A_bus_ff
      -- FLOPPED
      -----------------
      if (A_wait_int = '0') then
        A_bus_ff <= A_bus;   
      else
        A_bus_ff <= A_bus_ff;   
      end if;

    end if;
    
  end process;

  --------------
  -- int_bus
  --------------
  int_bus <= A_bus_ff;

end generate;

gen_A_bus : if A_BUS_REGISTERED /= TRUE generate
  --------------
  -- int_bus
  --------------
  int_bus <= A_bus;
end generate;


-------------------------------------------------------------------------------
-- B_WAIT_REGISTERED
-------------------------------------------------------------------------------
gen_B_wait_ff : if B_WAIT_REGISTERED = TRUE generate

  process (sysrstN, sysclk, A_bus_reset)
    
  begin  

    ----------
    -- reset
    ----------
    if (sysrstN = '0') then

      int_bus_ff     <= A_bus_reset;
      B_wait_ff      <= '0';

       
    elsif (sysclk'event and sysclk = '1') then                                         

      -----------------
      -- int_bus_ff
      -- FLOPPED
      -----------------
      if (A_wait_int = '0') then
        int_bus_ff <= int_bus;
      else
        int_bus_ff <= int_bus_ff;
      end if;


      -----------------
      -- B_wait_ff
      -- FLOPPED
      -----------------
      B_wait_ff <= B_wait;


    end if;
    
  end process;
  
  --------------
  -- B_bus
  --------------
  B_bus_int <= int_bus_ff when A_wait_int = '1' else int_bus;

  --------------
  -- A_wait
  --------------
  A_wait_int <= B_wait_ff;

end generate;

gen_B_wait : if B_WAIT_REGISTERED /= TRUE generate
  --------------
  -- B_bus
  --------------
  B_bus_int <= int_bus;

  --------------
  -- A_wait
  --------------
  A_wait_int <= B_wait;
end generate;


B_bus  <= B_bus_int;
A_wait <= A_wait_int;


end functional;


