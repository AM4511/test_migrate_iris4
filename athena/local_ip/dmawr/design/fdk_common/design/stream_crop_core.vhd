----------------------------------------------------------------------
--  $HeadURL: svn://brainstorm/svn_ipcore/trunk/Matrox/Imaging/FDK/hw/cores/common/design/stream_crop_core.vhd $
--  $Revision: 8647 $
--  $Date: 2009-03-11 14:59:23 -0400 (Wed, 11 Mar 2009) $
--  $Author: palepin $
--
--  Description             : Stream crop core module
--
--  Functionality           : masks out a portion of a stream by disactivating the byte enables
--                            of the unwanted portion.
--
--  Generics Description    : S_DATA_WIDTH              = width of si_data and so_data signals: 64, 128, etc.
--                            PIPELINE_OUTPUT           = register output signals so_write, so_sync, so_data and so_beN
--                            SO_WAIT_REGISTERED        = register input signal so_wait and add extra glue logic on so_* output signals
--
--  Modules Used            : stream_buffer_core
--                            
--
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
  use ieee.std_logic_arith.all;

entity stream_crop_core is
  generic (

    MAX_LNSIZE                : integer := 16#7FFFFFFF#;     
    MAX_NBLINE                : integer := 16#7FFFFFFF#;
    S_DATA_WIDTH              : integer := 64     ;     -- width of s*_data signal: 64, 128, etc.
    PIPELINE_OUTPUT           : boolean := TRUE   ;       
    SO_WAIT_REGISTERED        : boolean := TRUE       

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ABORT                : in        std_logic;
    LNSIZE               : in        integer;     -- 0 = no horizontal cropping
    NBLINE               : in        integer;     -- 0 = no vertical cropping
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : buffer    std_logic;
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : buffer    std_logic;
    so_sync              : buffer    std_logic_vector(1 downto 0);
    so_data              : buffer    std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN               : buffer    std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic

  );
end stream_crop_core;




architecture functional of stream_crop_core is


-------------------------------------------------
-- stream_buffer_core
-------------------------------------------------
component stream_buffer_core 
  generic (

    S_DATA_WIDTH         : integer := 64        ; -- width of s*_data signal: 64, 128, etc.
    S_CONTEXT_WIDTH      : integer := 0         ; -- width of s*_context signals
    SI_BUS_REGISTERED    : boolean := TRUE      ;
    SO_WAIT_REGISTERED   : boolean := TRUE      

  );
  port (

    ----------------------------------------------------
    -- Reset, clock and mode signals
    ----------------------------------------------------
    sysrstN              : in        std_logic;
    sysclk               : in        std_logic;
    ----------------------------------------------------
    -- stream input port (slave)
    ----------------------------------------------------
    si_write             : in        std_logic;
    si_sync              : in        std_logic_vector(1 downto 0);
    si_data              : in        std_logic_vector(S_DATA_WIDTH-1 downto 0);
    si_beN               : in        std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    si_wait              : buffer    std_logic;
    si_context           : in        std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0'); -- range shifted by 1 to prevent negative index
    ----------------------------------------------------
    -- stream output port (master)  
    ----------------------------------------------------
    so_write             : buffer    std_logic;
    so_sync              : buffer    std_logic_vector(1 downto 0);
    so_data              : buffer    std_logic_vector(S_DATA_WIDTH-1 downto 0);
    so_beN               : buffer    std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);
    so_wait              : in        std_logic;
    so_context           : buffer    std_logic_vector(S_CONTEXT_WIDTH downto 1) := (others => '0')  -- range shifted by 1 to prevent negative index

  );
end component;


  -----------------------------------------------------
  -- functions
  -----------------------------------------------------

  -----------------------------------------------------
  -- bo2sl
  -- boolean to std_logic
  -----------------------------------------------------
  function bo2sl            ( s                     : boolean         
                            ) return                  std_logic is

  begin
    case s is
      when false => return '0';
      when true  => return '1';
    end case;
  end bo2sl;


  -----------------------------------------------------
  -- log2
  -----------------------------------------------------
  function log2             ( arg                   : integer         
                            ) return                  integer is

  variable result       : integer := 0;
  variable comparevalue : integer := 1;
  begin

    assert arg /= 0
      report "invalid arg value 0 in log2"
      severity FAILURE;

    while (comparevalue < arg) loop
      comparevalue := comparevalue * 2;
      result := result + 1;
    end loop;

    return result;
  end;


  -----------------------------------------------------
  -- AndN
  -----------------------------------------------------
  function AndN (arg: std_logic_vector) return std_logic is
    variable result : std_logic;
  begin
    result := '1';

    for i in arg'range loop
      result := result and arg(i);
    end loop;

    return result;
  end AndN;

  
  -----------------------------------------------------
  -- gen_beN_end
  -----------------------------------------------------
  function gen_beN_end      ( end_addr              : integer;
                              result_length         : integer
                            ) return                  std_logic_vector is

  variable result           : std_logic_vector(result_length-1 downto 0) := (others => '0');
  variable end_addr_lsb     : integer := end_addr mod result_length;
  begin

    if (end_addr_lsb /= 0) then
      for i in 1 to result_length-1 loop
        if (i >= end_addr_lsb) then
          result(i) := '1';
        end if;
      end loop;
    end if;
    
    return result;

  end gen_beN_end;


  -----------------------------------------------------
  -- signals
  -----------------------------------------------------
  signal si_sol                      : std_logic;
  signal si_eof                      : std_logic;

  signal counter_x                   : integer range 0 to MAX_LNSIZE;
  signal counter_x_inc               : integer range 0 to MAX_LNSIZE;
  signal counter_y                   : integer range 0 to MAX_NBLINE;
  signal counter_y_inc               : integer range 0 to MAX_NBLINE;
  signal crop_beN                    : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal crop_beN_sol                : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal crop_beN_cont               : std_logic_vector(S_DATA_WIDTH/8-1 downto 0);
  signal crop_enable_x               : std_logic;
  signal crop_enable_y               : std_logic;
  
  signal si_write_int                : std_logic;
  signal so_beN_int                  : std_logic_vector(S_DATA_WIDTH/8 - 1 downto 0);




begin


-------------------------------------------------
-- stream_buffer_core
-------------------------------------------------
xstream_output_buffer : stream_buffer_core 
  generic map (

    S_DATA_WIDTH         => S_DATA_WIDTH         ,
    S_CONTEXT_WIDTH      => 0                    ,
    SI_BUS_REGISTERED    => PIPELINE_OUTPUT      ,
    SO_WAIT_REGISTERED   => SO_WAIT_REGISTERED

  )
  port map (

    sysrstN              => sysrstN              ,
    sysclk               => sysclk               ,
    si_write             => si_write_int         ,
    si_sync              => si_sync              ,
    si_data              => si_data              ,
    si_beN               => so_beN_int           ,
    si_wait              => si_wait              ,
    si_context           => open                 ,
    so_write             => so_write             ,
    so_sync              => so_sync              ,
    so_data              => so_data              ,
    so_beN               => so_beN               ,
    so_wait              => so_wait              ,
    so_context           => open                 

  );


-------------------------------------------------------------------------------
-- clocked events
-------------------------------------------------------------------------------
process (sysrstN, sysclk)
   
begin  

  ----------
  -- reset
  ----------
  if (sysrstN = '0') then
    
    counter_x          <= 0;
    counter_y          <= 0;
    crop_beN_sol       <= (others => '0');
    crop_beN_cont      <= (others => '0');

  elsif (sysclk'event and sysclk = '1') then                                         



    -----------------
    -- counter_x    
    -- Note: is not valid during SOL
    -- FLOPPED
    -----------------
    if (si_sol = '1') then
      counter_x <= S_DATA_WIDTH/8;
    elsif (si_write = '1' and si_wait = '0' and counter_x < LNSIZE + 1) then
      counter_x <= counter_x_inc;
    else
      counter_x <= counter_x;
    end if;
    
    
    -----------------
    -- counter_y
    -- Note: is not valid during SOL
    -- FLOPPED
    -----------------
    if (ABORT = '1'  or
        si_eof = '1'
       ) then
      counter_y <= 0;
    elsif (si_write = '1' and si_wait = '0' and counter_y < (NBLINE + 1) and si_sync(1) = '0') then -- si_sync[1] = '0' => SOF or EOL
      counter_y <= counter_y_inc;
    else
      counter_y <= counter_y;
    end if;


    -----------------
    -- crop_beN_sol
    -----------------
    if ((crop_enable_y = '1' and counter_y_inc > NBLINE) or
        (crop_enable_y = '1' and counter_y_inc = NBLINE and si_sol = '1')
       )
     then
      crop_beN_sol <= (others => '1');
    elsif (crop_enable_x = '0' or
           LNSIZE > S_DATA_WIDTH/8
          ) then
      crop_beN_sol <= (others => '0');
    else
      crop_beN_sol <= gen_beN_end(LNSIZE, S_DATA_WIDTH/8);
    end if;


    -----------------
    -- crop_beN_cont
    -- FLOPPED
    -----------------
    if ((crop_enable_y = '1' and counter_y > NBLINE) or
        (crop_enable_y = '1' and counter_y = NBLINE and si_sol = '1') or
        (crop_enable_x = '1' and counter_x_inc >= LNSIZE and si_write = '1' and si_wait = '0' and si_sol = '0') or
        (crop_enable_x = '1' and LNSIZE <= S_DATA_WIDTH/8 and si_sol = '1')
       ) then
      crop_beN_cont <= (others => '1');
    elsif (crop_enable_x = '0' or
           (counter_x_inc < (LNSIZE - S_DATA_WIDTH/8) and si_write = '1' and si_wait = '0') or
           (LNSIZE > 2*(S_DATA_WIDTH/8) and si_sol = '1')
          ) then
      crop_beN_cont <= (others => '0');
    elsif (si_write = '1' and si_wait = '0') then
      crop_beN_cont <= gen_beN_end(LNSIZE, S_DATA_WIDTH/8);
    else
      crop_beN_cont <= crop_beN_cont;
    end if;


  end if;

end process;


  -----------------
  -- si_sol
  -- si_sync[1] = '0' => SOF or EOL
  -----------------
  si_sol <= si_write and not si_wait and not si_sync(1);

  
  -----------------
  -- si_eof
  -- si_sync = "11" => EOF
  -----------------
  si_eof <= si_write and not si_wait and si_sync(1) and si_sync(0);

  
  -----------------
  -- crop_enable_x
  -----------------
  crop_enable_x <= bo2sl(LNSIZE /= 0);

  
  -----------------
  -- crop_enable_y
  -----------------
  crop_enable_y <= bo2sl(NBLINE /= 0);

  
  -----------------
  -- counter_x_inc
  -----------------
  counter_x_inc <= counter_x + S_DATA_WIDTH/8;


  -----------------
  -- counter_y_inc
  -----------------
  counter_y_inc <= counter_y + 1;


  -----------------
  -- crop_beN
  -----------------
  crop_beN <= crop_beN_sol when si_sol = '1' else crop_beN_cont;


  -----------------
  -- si_write_int
  -- force to '0' when sync /= EOF and all byte enables are disabled
  -----------------
  si_write_int <= si_write and (bo2sl(si_sync = "11") or 
                                not AndN(so_beN_int)
                               );


  -----------------
  -- so_beN_int
  -----------------
  so_beN_int <= si_beN or crop_beN;







end functional;

