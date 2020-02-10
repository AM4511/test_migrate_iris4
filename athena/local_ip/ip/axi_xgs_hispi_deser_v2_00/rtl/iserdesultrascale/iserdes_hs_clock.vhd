-- *********************************************************************
-- Copyright 2012, ON Semiconductor Corporation.
--
-- This software is owned by ON Semiconductor Corporation (ON)
-- and is protected by United States copyright laws and international
-- treaty provisions.  Therefore, you must treat this software like any
-- other copyrighted material (e.g., book, or musical recording), with
-- the exception that one copy may be made for personal use or
-- evaluation.  Reproduction, modification, translation, compilation, or
-- representation of this software in any other form (e.g., paper,
-- magnetic, optical, silicon, etc.) is prohibited without the express
-- written permission of ON.
--
-- Disclaimer: ON makes no warranty of any kind, express or
-- implied, with regard to this material, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular
-- purpose. ON reserves the right to make changes without further
-- notice to the materials described herein. ON does not assume any
-- liability arising out of the application or use of any product or
-- circuit described herein. ON's products described herein are not
-- authorized for use as components in life-support devices.
--
-- This software is protected by and subject to worldwide patent
-- coverage, including U.S. and foreign patents. Use may be limited by
-- and subject to the ON Software License Agreement.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

library unisim;
use unisim.vcomponents.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
entity iserdes_hs_clock is
  generic (
        SIMULATION          : integer := 0;
        MAX_DATAWIDTH       : integer := 18;
        SERDES_DATAWIDTH    : integer := 6;
        DATA_RATE           : string  := "DDR";
        CLKSPEED            : integer := 62;
        SIM_DEVICE          : string  := "VIRTEX5";
        DIFF_TERM           : boolean := TRUE;
        USE_DIFF_HS_CLK_IN  : boolean := FALSE;
        USE_HS_REGIONAL_CLK : boolean := FALSE;
        C_CALWIDTH          : integer := 5;
        USE_CALIBRATION     : boolean := FALSE;
        REFCLK_F            : real    := 200.0;
        USE_HSCLK_BUFIO     : boolean := TRUE;
        USE_SYNC_LOGIC      : boolean := TRUE
  );
  port (
        CLOCK               : in    std_logic;
        RESET               : in    std_logic;

        HS_IN_CLK           : in    std_logic;
        HS_IN_CLKb          : in    std_logic;

        HS_CLK_MON          : out   std_logic;

        --input calibration
        IODELAY_CAL         : in    std_logic_vector((C_CALWIDTH)-1 downto 0);

        --divider synchro logic
        START_ALIGN         : in    std_logic;

        BUFR_CLR_OUT        : out   std_logic := '0';
        BUFR_CE_OUT         : out   std_logic := '0';

        BUFR_CLR_IN         : in    std_logic;
        BUFR_CE_IN          : in    std_logic;

        -- to iserdes
        CLK                 : out   std_logic;
        CLKb                : out   std_logic;
        CLKDIV              : out   std_logic;
        CLKDIV_RESET        : out   std_logic;
        CLKSYNC             : out   std_logic;

        --lowspeed clk status
        CLK_STATUS          : out   std_logic_vector(15 downto 0)
       );
end iserdes_hs_clock;

architecture rtl of iserdes_hs_clock is
--
function calcserdesplldivider(
                                SERDES_DATAWIDTH    : integer;
                                DATA_RATE    : string;
                                CLKSPEED     : integer
                                )
                                return integer is
variable output : integer := 0;

begin
    if (DATA_RATE = "SDR") then
        output := SERDES_DATAWIDTH;
    else
        output := integer (real(SERDES_DATAWIDTH)/2.0);
    end if;

    return output;
end function;

function setlocktime(           SIM_DEVICE   : string;
                                SIMULATION   : integer;
                                CLKSPEED     : integer
                                )
                                return std_logic_vector is
variable output : std_logic_vector(23 downto 0) := X"000000";
begin
    if (SIMULATION > 0) then
        output :=  X"000080";
    else
        if (SIM_DEVICE = "VIRTEX5") then --Virtex5 PLL lock time is always 100us
            output :=  std_logic_vector(to_unsigned((CLKSPEED*100),24));
        elsif (SIM_DEVICE = "VIRTEX6") then --Virtex6 PLL lock time is always 100us
            output :=  std_logic_vector(to_unsigned((CLKSPEED*100),24));
        else --locktime is worst case for 30MHz; 5000us resulting in 150000 clocks
            --FIXME: add support for 7series and ultrascale
            output :=  std_logic_vector(to_unsigned((CLKSPEED*100),24));
        end if;
    end if;

    return output;
end function;
--
----constants
constant serdes_divider  : integer := calcserdesplldivider(SERDES_DATAWIDTH, DATA_RATE, CLKSPEED);

--
constant zero            : std_logic := '0';
constant one             : std_logic := '1';
constant zeros           : std_logic_vector(31 downto 0) := X"00000000";
constant ones            : std_logic_vector(31 downto 0) := X"FFFFFFFF";

constant LockTimeDIV     : std_logic_vector(23 downto 0) := setlocktime(SIM_DEVICE, SIMULATION, CLKSPEED);
constant ResetTime        : std_logic_vector(23 downto 0) := X"000100";
----signals
type   lockedmonitorstatetp is (
                                    Idle,
                                    AssertReset2,
                                    WaitLocked2,
                                    CheckLocked2,
                                    AssertReset3,
                                    WaitLocked3,
                                    CheckLocked3
                                );

signal lockedmonitorstate : lockedmonitorstatetp;

signal Cntr              : std_logic_vector(23 downto 0);

--
signal hsinclk           : std_logic;
signal hsinclkb          : std_logic;

signal hsinclk_d         : std_logic;
signal hsinclkb_d        : std_logic;

signal clk_i             : std_logic;

signal DIV_CLK0          : std_logic := '0';
signal DIV_CLKDV         : std_logic := '0';
signal DIV_LOCKED        : std_logic := '0';

signal DIV_CLKIN         : std_logic := '0';
signal DIV_RST           : std_logic := '1';
signal DIV_DO            : std_logic_vector(15 downto 0) := (others => '0');
--only for PLL
signal DIV_PLLFBI        : std_logic := '0';
signal DIV_PLLFBO        : std_logic := '0';

signal DIV_CLKFBSTOPPED  : std_logic := '0';
signal DIV_CLKINSTOPPED  : std_logic := '0';

signal LOCKED            : std_logic := '0';

---- lock signals AND'ed with DRP DO(1)

signal divider_lock      : std_logic  := '0';
signal divider_lock_r    : std_logic  := '0';
signal divider_lock_r2   : std_logic  := '0';

-- output of reset sequencer
signal divider_status    : std_logic;

--synchronisation stuff

type reqsynchrostatetp is ( Idle,
                            Req
                          );

signal reqsynchrostate : reqsynchrostatetp := Idle;

type acksynchrostatetp is ( Idle,
                          Clr,
                          Ce,
                          WaitReqLow
                          );

signal acksynchrostate : acksynchrostatetp := Idle;

signal synch_ack : std_logic := '0';
signal synch_req : std_logic := '0';

signal SynchroClk : std_logic := '0';

signal clkdiv_reset_i  : std_logic := '1';
signal clkdiv_reset_i3 : std_logic := '1';
signal clkdiv_resetpipe : std_logic_vector(4 downto 0);

signal CLKDIV_i   : std_logic := '0';

attribute syn_preserve : boolean;
attribute equivalent_register_removal : string;
attribute shreg_extract : string;

attribute equivalent_register_removal of divider_lock_r     : signal is "no";
attribute syn_preserve                of divider_lock_r     : signal is true;
attribute shreg_extract               of divider_lock_r     : signal is "no";

attribute equivalent_register_removal of divider_lock_r2     : signal is "no";
attribute syn_preserve                of divider_lock_r2     : signal is true;
attribute shreg_extract               of divider_lock_r2     : signal is "no";

attribute keep : string;
attribute keep of hsinclk : signal is "true";

begin

-- DO bit assignment (MMCM only)
-- DO[0]: Phase shift overflow
-- DO[1]: Clkin stopped
-- DO[2]: Clkfx stopped
-- DO[3]: Clkfb stopped
--
--
--CLK_STATUS(15)          <= '0';
--CLK_STATUS(14)          <= divider_lock;
--CLK_STATUS(13)          <= DIV_LOCKED;
--CLK_STATUS(12 downto 9) <= DIV_DO(3 downto 0);
--CLK_STATUS(8)           <= divider_status;

CLK_STATUS(0) <= LOCKED;
CLK_STATUS(1) <= DIV_CLKFBSTOPPED;
CLK_STATUS(2) <= DIV_CLKINSTOPPED;
CLK_STATUS(15 downto 3) <= (others => '0');

CLKDIV <= CLKDIV_i;

  --synchronise reset to CLKDIV clk domain
--  CLKDIV_resetsync1 : FDRE
--      generic map (
--          INIT => '1') -- Initial value of register ('0' or '1')
--      port map (
--          Q => clkdiv_reset_i2, -- Data output
--          C => CLKDIV_i, -- Clock input
--          CE => one, -- Clock enable input
--          R => zero, -- Synchronous reset input
--          D => clkdiv_reset_i -- Data input
--      );

--  CLKDIV_resetsync2 : SRL16E
--      generic map (
--      INIT => X"FFFF")
--      port map (
--      Q => clkdiv_reset_i3, -- SRL data output
--      A0 => zero, -- Select[0] input
--      A1 => one, -- Select[1] input
--      A2 => zero, -- Select[2] input
--      A3 => zero, -- Select[3] input
--      CE => one, -- Clock enable input
--      CLK => CLKDIV_i, -- Clock input
--      D => clkdiv_reset_i2 -- SRL data input
--      );

Synchro_CLKDIV_reset: process(clkdiv_reset_i, CLKDIV_i)
begin
    if (clkdiv_reset_i = '1') then
        clkdiv_resetpipe  <= (others => '1');
    elsif (CLKDIV_i'event and CLKDIV_i = '1') then

        clkdiv_resetpipe(0) <= '0';

        for i in 0 to clkdiv_resetpipe'high-1 loop
            clkdiv_resetpipe(i+1) <= clkdiv_resetpipe(i);
        end loop;

    end if;
end process;

clkdiv_reset_i3 <= clkdiv_resetpipe(clkdiv_resetpipe'high);

  CLKDIV_resetsync3 : FDRE
     generic map (
         INIT => '1') -- Initial value of register ('0' or '1')
     port map (
         Q => CLKDIV_RESET, -- Data output
         C => CLKDIV_i, -- Clock input
         CE => one, -- Clock enable input
         R => zero, -- Synchronous reset input
         D => clkdiv_reset_i3 -- Data input
     );

gen_differential_buffer: if (USE_DIFF_HS_CLK_IN = True) generate
     IBUFDS_DIFF_OUT_inst : IBUFDS_DIFF_OUT
      generic map (
        DIFF_TERM => DIFF_TERM, -- Differential Termination
        IBUF_LOW_PWR => FALSE,  -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
        IOSTANDARD => "DEFAULT") -- Specify the input I/O standard
      port map (
        O => hsinclk, -- Buffer diff_p output
        OB => hsinclkb, -- Buffer diff_n output
        I => HS_IN_CLK, -- Diff_p buffer input (connect directly to top-level port)
        IB => HS_IN_CLKb -- Diff_n buffer input (connect directly to top-level port)
      );
end generate;

gen_no_differential_buffer: if (USE_DIFF_HS_CLK_IN = False) generate
    hsinclk      <= HS_IN_CLK;
    hsinclkb     <= not HS_IN_CLK;
end generate;

HS_CLK_MON <= hsinclk;

--check whether additional jitter makes this usefull?
--only valid for Virtex6 at this time
gen_idelay: if (USE_CALIBRATION = True) generate
    IODELAYE1_inst : IODELAYE1
          generic map (
            CINVCTRL_SEL                => FALSE,           -- Enable dynamic clock inversion ("TRUE"/"FALSE")
            DELAY_SRC                   => "I",             -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
            HIGH_PERFORMANCE_MODE       => TRUE,            -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
            IDELAY_TYPE                 => "VAR_LOADABLE",  -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE"
            IDELAY_VALUE                => 0,               -- Input delay tap setting (0-32)
            ODELAY_TYPE                 => "FIXED",         -- "FIXED", "VARIABLE", or "VAR_LOADABLE"
            ODELAY_VALUE                => 0,               -- Output delay tap setting (0-32)
            REFCLK_FREQUENCY            => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz
            SIGNAL_PATTERN              => "DATA"           -- "DATA" or "CLOCK" input signal
          )
          port map (
            CNTVALUEOUT                 => open                     , -- 5-bit output - Counter value for monitoring purpose
            DATAOUT                     => hsinclk_d                , -- 1-bit output - Delayed data output
            C                           => CLOCK                    , -- 1-bit input - Clock input
            CE                          => zero                     , -- 1-bit input - Active high enable increment/decrement function
            CINVCTRL                    => zero                     , -- 1-bit input - Dynamically inverts the Clock (C) polarity
            CLKIN                       => CLOCK                    , -- 1-bit input - Clock Access into the IODELAY
            CNTVALUEIN                  => IODELAY_CAL((C_CALWIDTH-1) downto 0), -- 5-bit input - Counter value for loadable counter application
            DATAIN                      => zero                     , -- 1-bit input - Internal delay data
            IDATAIN                     => hsinclk                  , -- 1-bit input - Delay data input
            INC                         => zero                     , -- 1-bit input - Increment / Decrement tap delay
            ODATAIN                     => zero                     , -- 1-bit input - Data input for the output datapath from the device
            RST                         => RESET                    , -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
            T                           => one                        -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or
                                                                      -- tie low for output only.
        );

        IODELAYE1_instb : IODELAYE1
          generic map (
            CINVCTRL_SEL                => FALSE,           -- Enable dynamic clock inversion ("TRUE"/"FALSE")
            DELAY_SRC                   => "I",             -- Delay input ("I", "CLKIN", "DATAIN", "IO", "O")
            HIGH_PERFORMANCE_MODE       => TRUE,            -- Reduced jitter ("TRUE"), Reduced power ("FALSE")
            IDELAY_TYPE                 => "VAR_LOADABLE",  -- "DEFAULT", "FIXED", "VARIABLE", or "VAR_LOADABLE"
            IDELAY_VALUE                => 0,               -- Input delay tap setting (0-32)
            ODELAY_TYPE                 => "FIXED",         -- "FIXED", "VARIABLE", or "VAR_LOADABLE"
            ODELAY_VALUE                => 0,               -- Output delay tap setting (0-32)
            REFCLK_FREQUENCY            => REFCLK_F,        -- IDELAYCTRL clock input frequency in MHz
            SIGNAL_PATTERN              => "DATA"           -- "DATA" or "CLOCK" input signal
          )
          port map (
            CNTVALUEOUT                 => open                     , -- 5-bit output - Counter value for monitoring purpose
            DATAOUT                     => hsinclkb_d               , -- 1-bit output - Delayed data output
            C                           => CLOCK                    , -- 1-bit input - Clock input
            CE                          => zero                     , -- 1-bit input - Active high enable increment/decrement function
            CINVCTRL                    => zero                     , -- 1-bit input - Dynamically inverts the Clock (C) polarity
            CLKIN                       => CLOCK                    , -- 1-bit input - Clock Access into the IODELAY
            CNTVALUEIN                  => IODELAY_CAL((C_CALWIDTH-1) downto 0), -- 5-bit input - Counter value for loadable counter application
            DATAIN                      => zero                     , -- 1-bit input - Internal delay data
            IDATAIN                     => hsinclkb                 , -- 1-bit input - Delay data input
            INC                         => zero                     , -- 1-bit input - Increment / Decrement tap delay
            ODATAIN                     => zero                     , -- 1-bit input - Data input for the output datapath from the device
            RST                         => RESET                    , -- 1-bit input - Active high, synchronous reset, resets delay chain to IDELAY_VALUE/ODELAY_VALUE tap. If no value is specified, the default is 0.
            T                           => one                        -- 1-bit input - 3-state input control. Tie high for input-only or internal delay or
                                                                      -- tie low for output only.
        );
end generate;

gen_no_idelay: if (USE_CALIBRATION = False) generate
     hsinclk_d      <= hsinclk;
     hsinclkb_d     <= hsinclkb;
end generate;

gen_regional_clock: if (USE_HS_REGIONAL_CLK = True) generate

    --synchronisation logic
    --BUFR synchronisation logic
    gen_sync_logic: if (USE_SYNC_LOGIC=True) generate

        gen_old_series: if (SIM_DEVICE /= "ULTRASCALE") generate
            BUFR_regional_hs_clk_in_b : BUFR
                generic map (
                    BUFR_DIVIDE => integer'image(serdes_divider), -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                    SIM_DEVICE  => SIM_DEVICE
                    )
                port map (
                    O       => SynchroClk        ,   -- Clock buffer output
                    CE      => one               ,
                    CLR     => DIV_RST           ,
                    I       => hsinclk_d     -- Clock buffer input
                    );

            BUFR_regional_hs_clk_in : BUFR
              generic map (
                BUFR_DIVIDE => integer'image(serdes_divider), -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                SIM_DEVICE  => SIM_DEVICE
                )
              port map (
                O       => CLKDIV_i     ,   -- Clock buffer output
                CE      => BUFR_CE_IN   ,
                CLR     => BUFR_CLR_IN  ,
                I       => hsinclk_d      -- Clock buffer input
                );
        end generate;

        gen_ultrascale_series: if (SIM_DEVICE = "ULTRASCALE") generate
            BUFGCE_DIV_regional_hs_clk_in_b : BUFGCE_DIV
                generic map (
                    BUFGCE_DIVIDE => serdes_divider, -- 1-8
                    -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                    IS_CE_INVERTED => '0', -- Optional inversion for CE
                    IS_CLR_INVERTED => '0', -- Optional inversion for CLR
                    IS_I_INVERTED => '0' -- Optional inversion for I
                )
                port map (
                    O => SynchroClk, -- 1-bit output: Buffer
                    CE => one, -- 1-bit input: Buffer enable
                    CLR => DIV_RST, -- 1-bit input: Asynchronous clear
                    I => hsinclk_d -- 1-bit input: Buffer
                );

            BUFGCE_DIV_regional_hs_clk_in : BUFGCE_DIV
              generic map (
                BUFGCE_DIVIDE => serdes_divider, -- 1-8
                -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                IS_CE_INVERTED => '0', -- Optional inversion for CE
                IS_CLR_INVERTED => '0', -- Optional inversion for CLR
                IS_I_INVERTED => '0' -- Optional inversion for I
              )
              port map (
                O => CLKDIV_i, -- 1-bit output: Buffer
                CE => BUFR_CE_IN, -- 1-bit input: Buffer enable
                CLR => BUFR_CLR_IN, -- 1-bit input: Asynchronous clear
                I => hsinclk_d -- 1-bit input: Buffer
              );
        end generate;

        CLKSYNC <= SynchroClk;

        synchroreq_pr : process (RESET, CLOCK)
          begin
            if (RESET = '1') then
                synch_req <= '0';
                reqsynchrostate <= Idle;

            elsif (CLOCK = '1' and CLOCK'event) then
                case reqsynchrostate is
                    when Idle =>
                        synch_req <= '0';
                        if START_ALIGN = '1' then
                            synch_req <= '1';
                            reqsynchrostate <= Req;
                        end if;

                    when Req =>
                        synch_req <= '1';
                        if synch_ack = '1' and START_ALIGN = '0' then
                            synch_req <= '0';
                            reqsynchrostate <= Idle;
                        end if;

                    when others =>
                        synch_req <= '0';
                        reqsynchrostate <= Idle;
                end case;
            end if;
        end process;

        synchroack_pr : process (RESET, SynchroClk)
          begin
            if (RESET = '1') then
                acksynchrostate <= Idle;
                synch_ack       <= '0';
                BUFR_CLR_OUT    <= '0';
                BUFR_CE_OUT     <= '1';


            elsif (SynchroClk = '1' and SynchroClk'event) then
                case acksynchrostate is
                    when Idle =>
                        synch_ack       <= '0';
                        BUFR_CLR_OUT    <= '0';
                        BUFR_CE_OUT     <= '1';

                        if synch_req = '1' then
                            BUFR_CLR_OUT    <= '1';
                            BUFR_CE_OUT     <= '0';
                            acksynchrostate <= Clr;
                        end if;

                    when Clr =>
                        synch_ack       <= '0';
                        BUFR_CLR_OUT    <= '0';
                        BUFR_CE_OUT     <= '0';
                        acksynchrostate <= Ce;

                    when Ce =>
                        BUFR_CLR_OUT    <= '0';
                        BUFR_CE_OUT     <= '1';
                        synch_ack       <= '1';
                        acksynchrostate <= WaitReqLow;

                    when WaitReqLow =>
                        synch_ack       <= '1';
                        BUFR_CLR_OUT    <= '0';
                        BUFR_CE_OUT     <= '1';
                        if synch_req = '0' then
                            synch_ack       <= '0';
                            acksynchrostate <= Idle;
                        end if;

                    when others =>
                        acksynchrostate <= Idle;
                end case;
            end if;
        end process;
    end generate;

    gen_nosync_logic: if (USE_SYNC_LOGIC=False) generate
        --acksynchrostate <= Idle;
        synch_ack       <= '0';
        BUFR_CLR_OUT    <= '0';
        BUFR_CE_OUT     <= '0';
        synch_req <= '0';
        --reqsynchrostate <= Idle;
        gen_old_series: if (SIM_DEVICE /= "ULTRASCALE") generate
            BUFR_regional_hs_clk_in : BUFR
              generic map (
                BUFR_DIVIDE => integer'image(serdes_divider), -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8"
                SIM_DEVICE  => SIM_DEVICE
                )
              port map (
                O       => CLKDIV_i     ,   -- Clock buffer output
                CE      => '1'          ,
                CLR     => '0'          ,
                I       => hsinclk_d      -- Clock buffer input
                );
        end generate;

        gen_ultrascale_series: if (SIM_DEVICE = "ULTRASCALE") generate
            BUFGCE_DIV_regional_hs_clk_in : BUFGCE_DIV
              generic map (
                BUFGCE_DIVIDE => serdes_divider, -- 1-8
                -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
                IS_CE_INVERTED => '0', -- Optional inversion for CE
                IS_CLR_INVERTED => '0', -- Optional inversion for CLR
                IS_I_INVERTED => '0' -- Optional inversion for I
              )
              port map (
                O => CLKDIV_i, -- 1-bit output: Buffer
                CE => '1', -- 1-bit input: Buffer enable
                CLR => '0', -- 1-bit input: Asynchronous clear
                I => hsinclk_d -- 1-bit input: Buffer
              );
        end generate;
    end generate;
    --end synchronisation logic


  DIV_LOCKED <= '1';
  divider_lock <= '1';
  clkdiv_reset_i <= RESET;

  --hs clk
  CLK <= Clk_i;
  CLKb <= not Clk_i;

  gen_regional_bufio: if (USE_HSCLK_BUFIO = TRUE) generate
    gen_old_series: if (SIM_DEVICE /= "ULTRASCALE") generate
        --BUFIO: I/O Clock Buffer
        BUFIO_hsclk : BUFIO
        port map (
        O => Clk_i,  -- Buffer output
        I => hsinclk_d -- Buffer input
    );
    end generate;
    gen_ultrascale_series: if (SIM_DEVICE = "ULTRASCALE") generate
        --BUFIO: I/O Clock Buffer
        BUFG_hsclk : BUFG
        port map (
        O => Clk_i,  -- Buffer output
        I => hsinclk_d -- Buffer input
    );
    end generate;
  end generate;

  gen_no_regional_bufio: if (USE_HSCLK_BUFIO = FALSE) generate
    Clk_i <= hsinclk_d;
  end generate;


end generate;

gen_global_clock: if (USE_HS_REGIONAL_CLK = False) generate

    CLKSYNC <= '0';

    BUFR_CLR_OUT <= '0';
    BUFR_CE_OUT  <= '0';

    gen_virtex5_pll: if (SIM_DEVICE = "VIRTEX5") generate
        PLL_ADV_INST : PLL_ADV
            generic map( BANDWIDTH          => "OPTIMIZED",
                         CLKIN1_PERIOD      => 2.000,
                         CLKIN2_PERIOD      => 10.000,
                         CLKOUT0_DIVIDE     => serdes_divider*2,               -- serdes bit width
                         CLKOUT0_PHASE      => 0.000,
                         CLKOUT0_DUTY_CYCLE => 0.500,
                         CLKOUT1_DIVIDE     => 2,
                         CLKOUT1_PHASE      => 0.000,
                         CLKOUT1_DUTY_CYCLE => 0.500,
                         COMPENSATION       => "SOURCE_SYNCHRONOUS",
                         DIVCLK_DIVIDE      => 1,
                         CLKFBOUT_MULT      => 2,               --this could be wrong for other implementations
                         CLKFBOUT_PHASE     => 0.0,
                         REF_JITTER         => 0.005000
            )
            port map (
                         CLKFBIN            => DIV_PLLFBO,
                         CLKINSEL           => one,
                         CLKIN1             => DIV_CLKIN,
                         CLKIN2             => zero,
                         DADDR(4 downto 0)  => zeros(4 downto 0),
                         DCLK               => CLOCK,
                         DEN                => zero,
                         DI(15 downto 0)    => zeros(15 downto 0),
                         DWE                => zero,
                         REL                => zero,
                         RST                => DIV_RST,
                         CLKFBDCM           => open,
                         CLKFBOUT           => DIV_PLLFBI,       -- naming not ideal, matches DCM naming
                         CLKOUTDCM0         => open,
                         CLKOUTDCM1         => open,
                         CLKOUTDCM2         => open,
                         CLKOUTDCM3         => open,
                         CLKOUTDCM4         => open,
                         CLKOUTDCM5         => open,
                         CLKOUT0            => DIV_CLKDV,      -- CLK_DIV, SERDES word CLK
                         CLKOUT1            => DIV_CLK0,       -- SERDES Bit CLK
                         CLKOUT2            => open,
                         CLKOUT3            => open,
                         CLKOUT4            => open,
                         CLKOUT5            => open,
                         DO                 => DIV_DO,
                         DRDY               => open,
                         LOCKED             => DIV_LOCKED
            );

    DIV_CLKFBSTOPPED <= '0';
    DIV_CLKINSTOPPED <= '0';

    end generate;

    gen_virtex6_pll: if (SIM_DEVICE = "VIRTEX6") generate

        -- MMCM_ADV: Advanced Mixed Mode Clock Manager
        -- Virtex-6
        -- Xilinx HDL Libraries Guide, version 13.4
        MMCM_ADV_inst : MMCM_ADV
          generic map (
            BANDWIDTH => "OPTIMIZED", -- Jitter programming ("HIGH","LOW","OPTIMIZED")
            CLKFBOUT_MULT_F => 5.0, -- Multiply value for all CLKOUT (5.0-64.0).
            CLKFBOUT_PHASE => 0.0, -- Phase offset in degrees of CLKFB (0.00-360.00).
            -- CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            CLKIN1_PERIOD => 0.0,
            CLKIN2_PERIOD => 0.0,
            CLKOUT0_DIVIDE_F => real(serdes_divider*5), -- Divide amount for CLKOUT0 (1.000-128.000).
            -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
            CLKOUT0_DUTY_CYCLE => 0.5,
            CLKOUT1_DUTY_CYCLE => 0.5,
            CLKOUT2_DUTY_CYCLE => 0.5,
            CLKOUT3_DUTY_CYCLE => 0.5,
            CLKOUT4_DUTY_CYCLE => 0.5,
            CLKOUT5_DUTY_CYCLE => 0.5,
            CLKOUT6_DUTY_CYCLE => 0.5,
            -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
            CLKOUT0_PHASE => 0.0,
            CLKOUT1_PHASE => 0.0,
            CLKOUT2_PHASE => 0.0,
            CLKOUT3_PHASE => 0.0,
            CLKOUT4_PHASE => 0.0,
            CLKOUT5_PHASE => 0.0,
            CLKOUT6_PHASE => 0.0,
            -- CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
            CLKOUT1_DIVIDE => 5,
            CLKOUT2_DIVIDE => 1,
            CLKOUT3_DIVIDE => 1,
            CLKOUT4_DIVIDE => 1,
            CLKOUT5_DIVIDE => 1,
            CLKOUT6_DIVIDE => 1,
            CLKOUT4_CASCADE => FALSE, -- Cascase CLKOUT4 counter with CLKOUT6 (TRUE/FALSE)
            CLOCK_HOLD => FALSE, -- Hold VCO Frequency (TRUE/FALSE)
            COMPENSATION => "ZHOLD", -- "ZHOLD", "INTERNAL", "EXTERNAL", "CASCADE" or "BUF_IN"
            DIVCLK_DIVIDE => 1, -- Master division value (1-80)
            -- REF_JITTER: Reference input jitter in UI (0.000-0.999).
            REF_JITTER1 => 0.0,
            REF_JITTER2 => 0.0,
            STARTUP_WAIT => FALSE, -- Not supported. Must be set to FALSE.
            -- USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
            CLKFBOUT_USE_FINE_PS => FALSE,
            CLKOUT0_USE_FINE_PS => FALSE,
            CLKOUT1_USE_FINE_PS => FALSE,
            CLKOUT2_USE_FINE_PS => FALSE,
            CLKOUT3_USE_FINE_PS => FALSE,
            CLKOUT4_USE_FINE_PS => FALSE,
            CLKOUT5_USE_FINE_PS => FALSE,
            CLKOUT6_USE_FINE_PS => FALSE
          )
          port map (
            -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
            CLKOUT0     => DIV_CLKDV, -- 1-bit output: CLKOUT0 output
            CLKOUT0B    => open, -- 1-bit output: Inverted CLKOUT0 output
            CLKOUT1     => DIV_CLK0, -- 1-bit output: CLKOUT1 output
            CLKOUT1B    => open, -- 1-bit output: Inverted CLKOUT1 output
            CLKOUT2     => open, -- 1-bit output: CLKOUT2 output
            CLKOUT2B    => open, -- 1-bit output: Inverted CLKOUT2 output
            CLKOUT3     => open, -- 1-bit output: CLKOUT3 output
            CLKOUT3B    => open, -- 1-bit output: Inverted CLKOUT3 output
            CLKOUT4     => open, -- 1-bit output: CLKOUT4 output
            CLKOUT5     => open, -- 1-bit output: CLKOUT5 output
            CLKOUT6     => open, -- 1-bit output: CLKOUT6 output
            -- DRP Ports: 16-bit (each) output: Dynamic reconfigration ports
            DO          => DIV_DO, -- 16-bit output: DRP data output
            DRDY        => open, -- 1-bit output: DRP ready output
            -- Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
            PSDONE      => open, -- 1-bit output: Phase shift done output
            -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
            CLKFBOUT    => DIV_PLLFBI, -- 1-bit output: Feedback clock output
            CLKFBOUTB   => open, -- 1-bit output: Inverted CLKFBOUT
            -- Status Ports: 1-bit (each) output: MMCM status ports
            CLKFBSTOPPED => DIV_CLKFBSTOPPED, -- 1-bit output: Feedback clock stopped output
            CLKINSTOPPED => DIV_CLKINSTOPPED, -- 1-bit output: Input clock stopped output
            LOCKED      => DIV_LOCKED, -- 1-bit output: LOCK output
            -- Clock Inputs: 1-bit (each) input: Clock inputs
            CLKIN1      => DIV_CLKIN, -- 1-bit input: Primary clock input
            CLKIN2      => zero, -- 1-bit input: Secondary clock input
            -- Control Ports: 1-bit (each) input: MMCM control ports
            CLKINSEL    => zero, -- 1-bit input: Clock select input
            PWRDWN      => zero, -- 1-bit input: Power-down input
            RST         => DIV_RST, -- 1-bit input: Reset input
            -- DRP Ports: 7-bit (each) input: Dynamic reconfigration ports
            DADDR       => zeros(6 downto 0), -- 7-bit input: DRP adrress input
            DCLK        => zero, -- 1-bit input: DRP clock input
            DEN         => zero, -- 1-bit input: DRP enable input
            DI          => zeros(15 downto 0), -- 16-bit input: DRP data input
            DWE         => zero, -- 1-bit input: DRP write enable input
            -- Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
            PSCLK       => zero, -- 1-bit input: Phase shift clock input
            PSEN        => zero, -- 1-bit input: Phase shift enable input
            PSINCDEC    => zero, -- 1-bit input: Phase shift increment/decrement input
            -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
            CLKFBIN     => DIV_PLLFBO -- 1-bit input: Feedback clock input
          );
    -- End of MMCM_ADV_inst instantiation
    end generate;

    gen_7series_pll: if (SIM_DEVICE = "7SERIES") generate
        --FIXME: populate code
    end generate;

    gen_ultrascale_pll: if (SIM_DEVICE = "ULTRASCALE") generate
        --FIXME: populate code
    end generate;


    DIV_CLKIN <= hsinclk_d;
    divider_lock <= DIV_LOCKED;
    clkdiv_reset_i <= not DIV_LOCKED;

    div_PLLfeedback_BUFG_inst : BUFG
      port map (
        O => DIV_PLLFBO, -- Clock buffer output
        I => DIV_PLLFBI -- Clock buffer input
    );

    DIVCLK_BUFG_inst : BUFG
    port map (
    O => CLKDIV_i, -- Clock buffer output
    I => DIV_CLKDV -- Clock buffer input
    );

    --hs clk
    CLK <= Clk_i;
    CLKb <= not Clk_i;

    --alternatively use differential BUFG here
    CLK_BUFG_inst : BUFG
    port map (
    O => Clk_i, -- Clock buffer output
    I => DIV_CLK0 -- Clock buffer input
    );

end generate;

-- only divider lock needs to be registered, multiplier lock is generated on same clock domain
register_process : process (RESET, CLOCK)
begin
    if (RESET = '1') then
        divider_lock_r      <= '0';
        divider_lock_r2     <= '0';
    elsif (CLOCK = '1' and CLOCK'event) then
        divider_lock_r      <= divider_lock;
        divider_lock_r2     <= divider_lock_r;
    end if;
end process;

locked_monitor_process : process (RESET, CLOCK)
begin
if (RESET = '1') then
    DIV_RST     <= '1';
    LOCKED      <= '0';
    divider_status    <= '0';
    Cntr        <= (others => '1');
    lockedmonitorstate <= Idle;

elsif (CLOCK = '1' and CLOCK'event) then

    LOCKED      <= divider_status;

    case lockedmonitorstate is
        when Idle =>
            Cntr                <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
            if (divider_lock_r2 = '0') then
                divider_status      <= '0';
                DIV_RST             <= '1';
                lockedmonitorstate  <= AssertReset2;
            else
                divider_status      <= '1';
                DIV_RST     <= '0';
            end if;

        when AssertReset2 =>
            If (Cntr(Cntr'high) = '1') then
                DIV_RST             <= '0';
                Cntr                <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate  <= WaitLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked2 =>
            if (Cntr(Cntr'high) = '1') then
                DIV_RST             <= '0';
                lockedmonitorstate  <= CheckLocked2;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked2 =>
            if (divider_lock_r2 = '1') then
                DIV_RST             <= '1';
                Cntr                <= ResetTime; --reset should be asserted minimum one CLKDIV cycle
                lockedmonitorstate  <= AssertReset3;
            else
            -- only reset divider DCM again in this state. Otherwise highspeedclock will not be available when no sensor is inserted (debug)
                DIV_RST             <= '1';
                Cntr                <= ResetTime;
                lockedmonitorstate  <= AssertReset2;
            end if;

        -- code needs to lock twice to avoid power up problems.
        when AssertReset3 =>
            If (Cntr(Cntr'high) = '1') then
                DIV_RST             <= '0';
                Cntr                <= LockTimeDIV; --Cntr should be as long as lock time
                lockedmonitorstate  <= WaitLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

        when WaitLocked3 =>
            if (Cntr(Cntr'high) = '1') then
                DIV_RST             <= '0';
                lockedmonitorstate  <= CheckLocked3;
            else
                Cntr <= Cntr - '1';
            end if;

         when CheckLocked3 =>
            if (divider_lock_r2 = '1') then
                divider_status      <= '1';
                lockedmonitorstate  <= Idle;
            else
                -- only reset divider DCM again in this state. Otherwise highspeedclock will not be available when no sensor is inserted (debug)
                    DIV_RST             <= '1';
                    Cntr                <= ResetTime;
                    lockedmonitorstate  <= AssertReset2;
            end if;

        when others =>
            lockedmonitorstate  <= Idle;

    end case;

end if;
end process;

end rtl;
