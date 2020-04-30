
-- (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component hispi_phy_xilinx
generic
 (-- width of the data for the system
  SYS_W       : integer := 3;
  -- width of the data for the device
  DEV_W       : integer := 18);
port
 (
  -- From the system into the device
  data_in_from_pins_p     : in    std_logic_vector(SYS_W-1 downto 0);
  data_in_from_pins_n     : in    std_logic_vector(SYS_W-1 downto 0);
  data_in_to_device       : out   std_logic_vector(DEV_W-1 downto 0);

-- Input, Output delay control signals
  in_delay_reset          : in    std_logic;                    -- Active high synchronous reset for input delay
  in_delay_data_ce        : in    std_logic_vector(SYS_W -1 downto 0);                    -- Enable signal for delay 
  in_delay_data_inc       : in    std_logic_vector(SYS_W -1 downto 0);                    -- Delay increment (high), decrement (low) signal
  in_delay_tap_in         : in    std_logic_vector(5*SYS_W -1 downto 0); -- Dynamically loadable delay tap value for input delay
  in_delay_tap_out        : out   std_logic_vector(5*SYS_W -1 downto 0); -- Delay tap value for monitoring input delay
  bitslip                 : in    std_logic_vector(SYS_W-1 downto 0);                    -- Bitslip module is enabled in NETWORKING mode
                                                                -- User should tie it to '0' if not needed
 
-- Clock and reset signals
  clk_in_p                : in    std_logic;                    -- Differential fast clock from IOB
  clk_in_n                : in    std_logic;
  clk_div_out             : out   std_logic;                    -- Slow clock output
  clk_reset               : in    std_logic;                    -- Reset signal for Clock circuit
  io_reset                : in    std_logic);                   -- Reset signal for IO circuit
end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

-- User NOTES:
-- None

your_instance_name : hispi_phy_xilinx
   port map 
   ( 
   data_in_from_pins_p => data_in_from_pins_p,
   data_in_from_pins_n => data_in_from_pins_n,
   data_in_to_device => data_in_to_device,
   in_delay_reset => in_delay_reset,                    
   in_delay_data_ce => in_delay_data_ce,      
   in_delay_data_inc => in_delay_data_inc,     
   in_delay_tap_in => in_delay_tap_in,          
   in_delay_tap_out => in_delay_tap_out,         
   bitslip => bitslip,                           
   clk_in_p => clk_in_p,                          
   clk_in_n => clk_in_n,
   clk_div_out => clk_div_out,                       
   clk_reset => clk_reset,
   io_reset => io_reset
);

-- INST_TAG_END ------ End INSTANTIATION Template ------------
