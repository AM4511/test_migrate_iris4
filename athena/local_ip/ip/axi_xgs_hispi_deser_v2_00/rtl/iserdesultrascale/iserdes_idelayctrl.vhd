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
library unisim;
use unisim.vcomponents.all;

entity iserdes_idelayctrl is
  generic (
    NROF_DELAYCTRLS     : integer;
    IDELAYCLK_MULT      : integer;
    IDELAYCLK_DIV       : integer;
    GENIDELAYCLK        : boolean;
    C_FAMILY            : string
    );
  port (
    CLOCK            : in std_logic;
    RESET            : in std_logic;
    CLKREF           : in std_logic;
    idelay_ctrl_rdy  : out std_logic
  );
end entity iserdes_idelayctrl;

architecture syn of iserdes_idelayctrl is

function NrofDelayCtrlsClip( input : in    integer) return integer is
    variable output : integer;
    begin
        if (input < 1) then
            output := 1;
        else
            output := input;
        end if;
    return output;
end function NrofDelayCtrlsClip;

constant NrofDelayCtrlsClipped : integer := NrofDelayCtrlsClip(NROF_DELAYCTRLS);

constant ONES            : std_logic_vector(NrofDelayCtrlsClipped-1 downto 0) := (others => '1');

constant zeros           : std_logic_vector(15 downto 0) := (others => '0');
constant zero            : std_logic := '0';

signal idelay_ctrl_rdy_i : std_logic_vector(NrofDelayCtrlsClipped-1 downto 0) := (others => '0');

signal REF_CLK0          : std_logic := '0';
signal REF_CLK180        : std_logic := '0';
signal REF_CLK270        : std_logic := '0';
signal REF_CLK2X         : std_logic := '0';
signal REF_CLK2X180      : std_logic := '0';
signal REF_CLK90         : std_logic := '0';
signal REF_CLKDV         : std_logic := '0';
signal REF_CLKFX         : std_logic := '0';
signal REF_CLKFX180      : std_logic := '0';

signal REF_LOCKED        : std_logic := '0';
signal REF_CLKFB         : std_logic := '0';
signal REF_CLKIN         : std_logic := '0';

signal RESET_DELAYCTRL   : std_logic := '1';

signal REF_CLK           : std_logic := '0';

constant RST_SYNC_NUM              : integer := 25;
signal rst_sync_r                  : std_logic_vector(RST_SYNC_NUM-1 downto 0) := (others => '1');
signal reset_sync        : std_logic := '1';

attribute S: string;
attribute S of idelay_ctrl_rdy_i : signal is "TRUE";

begin
--
gen_delayctrls: if (NROF_DELAYCTRLS > 0) generate
    gen_own_clk: if (GENIDELAYCLK = TRUE) generate
        --needs bufg on feedback & output
    
        ref_out_BUFG_inst : BUFG
        port map (
        O => REF_CLK, -- Clock buffer output
        I => REF_CLKFX -- Clock buffer input
        );
    
        REF_CLKIN <= CLOCK;
        
        RESET_DELAYCTRL <= not REF_LOCKED;
        
        gen_virtex5: if C_FAMILY = "VIRTEX5" generate
          DCM_ADV_inst : DCM_ADV
            generic map (
                CLKDV_DIVIDE            => 2.0, -- Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5,7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
                CLKFX_DIVIDE            => IDELAYCLK_DIV, -- Can be any integer from 1 to 32
                CLKFX_MULTIPLY          => IDELAYCLK_MULT, -- Can be any integer from 2 to 32
                CLKIN_DIVIDE_BY_2       => FALSE, -- TRUE/FALSE to enable CLKIN divide by two feature
                CLKIN_PERIOD            => 10.0, -- Specify period of input clock in ns from 1.25 to 1000.00
                CLKOUT_PHASE_SHIFT      => "NONE", -- Specify phase shift mode of NONE, FIXED,
                -- VARIABLE_POSITIVE, VARIABLE_CENTER or DIRECT
                CLK_FEEDBACK            => "1X", -- Specify clock feedback of NONE or 1X
                DCM_AUTOCALIBRATION     => TRUE, -- DCM calibration circuitry TRUE/FALSE
                DCM_PERFORMANCE_MODE    => "MAX_SPEED", -- Can be MAX_SPEED or MAX_RANGE
                DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS", -- SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                -- an integer from 0 to 15
                DFS_FREQUENCY_MODE      => "HIGH", -- HIGH or LOW frequency mode for frequency synthesis
                                                   -- HIGH:  25MHz < CLKIN < 350MHz
                                                   --     : 140MHz < CLKFX < 350MHz
                DLL_FREQUENCY_MODE      => "LOW", -- LOW, HIGH, or HIGH_SER frequency mode for DLL
                                                   -- HIGH or LOW frequency mode for frequency synthesis
                DUTY_CYCLE_CORRECTION   => TRUE,   -- Duty cycle correction, TRUE or FALSE
                FACTORY_JF              => X"F0F0", -- FACTORY JF Values Suggested to be set to X"F0F0"
                PHASE_SHIFT             => 0, -- Amount of fixed phase shift from -255 to 1023
                SIM_DEVICE              => "VIRTEX5", -- Set target device, "VIRTEX4" or "VIRTEX5"
                STARTUP_WAIT            => FALSE -- Delay configuration DONE until DCM LOCK, TRUE/FALSE
                )
            port map (
                CLK0            => REF_CLK0,            -- 0 degree DCM CLK output
                CLK180          => REF_CLK180,          -- 180 degree DCM CLK output
                CLK270          => REF_CLK270,          -- 270 degree DCM CLK output
                CLK2X           => REF_CLK2X,           -- 2X DCM CLK output
                CLK2X180        => REF_CLK2X180,        -- 2X, 180 degree DCM CLK out
                CLK90           => REF_CLK90,           -- 90 degree DCM CLK output
                CLKDV           => REF_CLKDV,           -- Divided DCM CLK out (CLKDV_DIVIDE)
                CLKFX           => REF_CLKFX,           -- DCM CLK synthesis out (M/D)
                CLKFX180        => REF_CLKFX180,        -- 180 degree CLK synthesis out
                DO              => open,                -- 16-bit data output for Dynamic Reconfiguration Port (DRP)
                DRDY            => open,                -- Ready output signal from the DRP
                LOCKED          => REF_LOCKED,          -- DCM LOCK status output
                PSDONE          => open,                -- Dynamic phase adjust done output
                CLKFB           => REF_CLKFB,           -- DCM clock feedback
                CLKIN           => REF_CLKIN,           -- Clock input (from IBUFG, BUFG or DCM)
                DADDR           => zeros(6 downto 0),   -- 7-bit address for the DRP
                DCLK            => zero,                -- Clock for the DRP
                DEN             => zero,                -- Enable input for the DRP
                DI              => zeros(15 downto 0),  -- 16-bit data input for the DRP
                DWE             => zero,                -- Active high allows for writing configuration memory
                PSCLK           => zero,                -- Dynamic phase adjust clock input
                PSEN            => zero,                -- Dynamic phase adjust enable input
                PSINCDEC        => zero,                -- Dynamic phase adjust increment/decrement
                RST             => RESET                -- DCM asynchronous reset input
            );
            
            ref_feedback_BUFG_inst : BUFG
              port map (
                O => REF_CLKFB, -- Clock buffer output
                I => REF_CLK0 -- Clock buffer input
              );
        end generate;
       
        gen_virtex6: if C_FAMILY = "VIRTEX6" generate 
          MMCM_BASE_inst : MMCM_BASE
            generic map (
            BANDWIDTH => "OPTIMIZED", -- Jitter programming ("HIGH","LOW","OPTIMIZED")
            CLKFBOUT_MULT_F => real(5*IDELAYCLK_MULT), -- Multiply value for all CLKOUT (5.0-64.0).
            CLKFBOUT_PHASE => 0.0, -- Phase offset in degrees of CLKFB (0.00-360.00).
            CLKIN1_PERIOD => 0.0, -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
            CLKOUT0_DIVIDE_F => real(IDELAYCLK_DIV*5), -- Divide amount for CLKOUT0 (1.000-128.000).
            -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
            CLKOUT0_DUTY_CYCLE => 0.5,
            CLKOUT1_DUTY_CYCLE => 0.5,
            CLKOUT2_DUTY_CYCLE => 0.5,
            CLKOUT3_DUTY_CYCLE => 0.5,
            CLKOUT4_DUTY_CYCLE => 0.5,
            CLKOUT5_DUTY_CYCLE => 0.5,
            CLKOUT6_DUTY_CYCLE => 0.5,
            -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
            CLKOUT0_PHASE => 0.0,
            CLKOUT1_PHASE => 0.0,
            CLKOUT2_PHASE => 0.0,
            CLKOUT3_PHASE => 0.0,
            CLKOUT4_PHASE => 0.0,
            CLKOUT5_PHASE => 0.0,
            CLKOUT6_PHASE => 0.0,
            -- CLKOUT1_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
            CLKOUT1_DIVIDE => 1,
            CLKOUT2_DIVIDE => 1,
            CLKOUT3_DIVIDE => 1,
            CLKOUT4_DIVIDE => 1,
            CLKOUT5_DIVIDE => 1,
            CLKOUT6_DIVIDE => 1,
            CLKOUT4_CASCADE => FALSE, -- Cascase CLKOUT4 counter with CLKOUT6 (TRUE/FALSE)
            CLOCK_HOLD => FALSE, -- Hold VCO Frequency (TRUE/FALSE)
            DIVCLK_DIVIDE => 1, -- Master division value (1-80)
            REF_JITTER1 => 0.0, -- Reference input jitter in UI (0.000-0.999).
            STARTUP_WAIT => FALSE -- Not supported. Must be set to FALSE.
            )
            port map (
            -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
            CLKOUT0     => REF_CLKFX, -- 1-bit output: CLKOUT0 output
            CLKOUT0B    => open, -- 1-bit output: Inverted CLKOUT0 output
            CLKOUT1     => open, -- 1-bit output: CLKOUT1 output
            CLKOUT1B    => open, -- 1-bit output: Inverted CLKOUT1 output
            CLKOUT2     => open, -- 1-bit output: CLKOUT2 output
            CLKOUT2B    => open, -- 1-bit output: Inverted CLKOUT2 output
            CLKOUT3     => open, -- 1-bit output: CLKOUT3 output
            CLKOUT3B    => open, -- 1-bit output: Inverted CLKOUT3 output
            CLKOUT4     => open, -- 1-bit output: CLKOUT4 output
            CLKOUT5     => open, -- 1-bit output: CLKOUT5 output
            CLKOUT6     => open, -- 1-bit output: CLKOUT6 output
            -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
            CLKFBOUT    => REF_CLKFB, -- 1-bit output: Feedback clock output
            CLKFBOUTB   => open, -- 1-bit output: Inverted CLKFBOUT output
            -- Status Port: 1-bit (each) output: MMCM status ports
            LOCKED      => REF_LOCKED, -- 1-bit output: LOCK output
            -- Clock Input: 1-bit (each) input: Clock input
            CLKIN1      => REF_CLKIN,
            -- Control Ports: 1-bit (each) input: MMCM control ports
            PWRDWN      => zero, -- 1-bit input: Power-down input
            RST         => RESET, -- 1-bit input: Reset input
            -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
            CLKFBIN     => REF_CLKFB -- 1-bit input: Feedback clock input
            );
        end generate;
        
        --fixme: add support for 7series & ultrascale
        
    end generate;
    
    use_ext_clk: if (GENIDELAYCLK = FALSE) generate
        RESET_DELAYCTRL <= RESET;
        REF_CLK <= CLKREF;
    end generate;

   --reset synchronisation
   --go async in reset but go sync out of reset
    process (REF_CLK, RESET_DELAYCTRL)
      begin
        if (RESET_DELAYCTRL = '1') then
            rst_sync_r <= (others => '1');
        elsif (REF_CLK = '1' and REF_CLK'event) then
            rst_sync_r <= rst_sync_r(RST_SYNC_NUM-2 downto 0) & '0';
        end if;
    end process;

    reset_sync <= rst_sync_r(RST_SYNC_NUM-1);

    gen_7series_ultrascale: if (C_FAMILY = "ULTRASCALE" or  C_FAMILY = "7SERIES") generate
        IDELAYCTRL_INST : for bnk_i in 0 to NROF_DELAYCTRLS-1 generate
          u_idelayctrl : IDELAYCTRL
            generic map (
              SIM_DEVICE    => C_FAMILY
            )
            port map (
              rdy     => idelay_ctrl_rdy_i(bnk_i),
              refclk  => REF_CLK,
              rst     => reset_sync
            );
        end generate IDELAYCTRL_INST;
    end generate;
    
    gen_others: if (C_FAMILY /= "ULTRASCALE" and C_FAMILY /= "7SERIES") generate
        IDELAYCTRL_INST : for bnk_i in 0 to NROF_DELAYCTRLS-1 generate
          u_idelayctrl : IDELAYCTRL
            port map (
              rdy     => idelay_ctrl_rdy_i(bnk_i),
              refclk  => REF_CLK,
              rst     => reset_sync
            );
        end generate IDELAYCTRL_INST;
    end generate;
end generate;
--
gen_no_delayctrls: if (NROF_DELAYCTRLS < 1) generate
       idelay_ctrl_rdy_i <= (others => '1');
end generate;

idelay_ctrl_rdy <= '1' when (idelay_ctrl_rdy_i = ONES) else
                   '0';

end architecture syn;
