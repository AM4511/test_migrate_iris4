-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/Iris2/cores/common/design/resetsync.vhd $
-- $Author: mchampou $
-- $Revision: 5117 $
-- $Date: 2009-09-14 10:22:04 -0400 (Mon, 14 Sep 2009) $
--------------------------------------------------------------------------------
--  Entity       :   resetsync
--
--  Description  :   This component is used to synchronized the reset deassertion.
--                   The active high resetoutP and active low resetoutN are registered
--                   asynchronous reset signals (i.e. they are asynchronously asserted, but 
--                   synchronously deasserted). Preserve-type attributes are also added to 
--                   prevent synthesis tools from removing the synchronization logic.
--
--
--
--                                      
--                                           ______        ______
--                                          |      |      |      |
--                                          |      |      |      |
--                                '0' ------|D    Q|------|D    Q| -------------- resetoutP
--                                          |      |      |      |      
--                                          |     _|      |     _|           
--                                       |--|>    Q|   |--|>    Q|--------------- resetoutN
--                                       |  |      |   |  |      |            
--                                       |  |__S___|   |  |__S___|           
--                                       |     |       |     |           
--                   clk  ---------------------|--------     |
--                               ______        |             |
--                              |      |       |             |
--                resetin ------|      |----------------------
--                              | XNOR |  resetin_activeH
--    ACTIVE_HIGH_RESETIN ------|      |
--                  =TRUE       |      |                           
--                               ------
--
--
--
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity resetsync is
  generic (

    ACTIVE_HIGH_RESETIN  : boolean := TRUE

  );
  port (

    clk                  : in        std_logic; -- synchronization clock
    resetin              : in        std_logic; -- input reset 
    resetoutP            : out       std_logic; -- active high synchronized reset
    resetoutN            : out       std_logic  -- active low  synchronized reset

  );

end resetsync;


architecture functional of resetsync is

  -------------------------------------------------------------------------------
  -- signals
  -------------------------------------------------------------------------------
  signal resetin_activeH          : std_logic;
  signal resetout_m1              : std_logic;
  signal resetout_int             : std_logic;
   

  -------------------------------------------------------------------------------
  -- attributes
  -------------------------------------------------------------------------------
  -- ALTERA  : use attribute 'preserve'
  -- SYNOPSYS: use attribute 'preserve_signal'
  -- SYNPLIFY: use attribute 'syn_preserve'
  -- XILINX  : use attribute 'KEEP'
  attribute preserve        : boolean;
  attribute preserve_signal : boolean;
  attribute syn_preserve    : boolean;
  attribute KEEP            : boolean;
  attribute dont_touch      : boolean; --Vivado
  
  attribute preserve        of resetout_m1  : signal is true;
  attribute preserve        of resetout_int : signal is true;

  attribute preserve_signal of resetout_m1  : signal is true;
  attribute preserve_signal of resetout_int : signal is true;

  attribute syn_preserve    of resetout_m1  : signal is true;
  attribute syn_preserve    of resetout_int : signal is true;

  attribute KEEP            of resetout_m1  : signal is true;
  attribute KEEP            of resetout_int : signal is true;

  attribute dont_touch      of resetout_m1  : signal is true;
  attribute dont_touch      of resetout_int : signal is true;

begin
   


----------------------
-- resetin_activeH
----------------------
resetin_activeH <= resetin when ACTIVE_HIGH_RESETIN = TRUE else not resetin;


----------------------
-- resetout_m1
-- resetout_int
----------------------
process(resetin_activeH, clk)
begin

   if (resetin_activeH = '1') then

      resetout_m1  <= '1';
      resetout_int <= '1';

   elsif (clk'event and clk='1') then

      resetout_m1  <= '0';
      resetout_int <= resetout_m1;

   end if;

end process;


----------------------
-- resetoutP
----------------------
resetoutP <= resetout_int;


----------------------
-- resetoutN
----------------------
resetoutN <= not resetout_int;


end functional;
