-- *********************************************************************
-- Copyright 2019, ON Semiconductor Corporation.
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
-- *********************************************************************

+++++++++++++++++++++++++++++++
X-class family simulation model
+++++++++++++++++++++++++++++++

This file gives an overview of the X-class family simulation model that can be used to verify the integration 
of the X-class sensor in the system before the X-class sensor is available.
The behavioural model mimics the behaviour of the pins of the X-class sensor.
It contains only limited functionality. 

Major features that are covered are :
- Implementation of read/write of limited set of registers using the SPI and/or I2C interface.
- Implementation of all test image patterns as implemented on the X-class sensor.

Overview
========
The model is written in VHDL and requires the VHDL 93 compile option to be enabled.
The model has one toplevel and 4 subblocks
- xgs12m_chip.vhd : this is the toplevel of the model which integrates the 4 functional subblocks
- xgs_spi_i2c.vhd : this subblock translates the SPI or I2C operations on the control interface into register accesses.
- xgs_sensor_config.vhd : this subblock implements all registers that can be read/written on the sensor.
- xgs_image.vhd   : this subblock generates the lines of pixel data that needs to be transmitted on the HiSPi interface
- xgs_hispi.vhd   : this block translates the pixel data it gets from the xgs_image module into 
                    a bit pattern that goes on the HiSPi data and clock lanes

Integration of the model in the toplevel testbench
==================================================
The model contains all pins as the silicon.
When integrating the sensor, some of the pins can be left unconnected.
A first set that does not need to be connected are all power and analog test pins.
The trigger pins don't need to be connected because the model only supports master mode.
No triggered readout mode is currently supported

   VAAHV_NPIX   => open,
   VREF1_BOT_0  => open,
   VREF1_BOT_1  => open,
   VREF1_TOP_0  => open,
   VREF1_TOP_1  => open,
   ATEST_BTM    => open,
   ATEST_TOP    => open,
   ASPARE_TOP   => open,
   ASPARE_BTM   => open,

   VRESPD_HI_0  => open,
   VRESPD_HI_1  => open,
   VRESFD_HI_0  => open,
   VRESFD_HI_1  => open,
   VSG_HI_0     => open,
   VSG_HI_1     => open,
   VRS_HI_0     => open,
   VRS_HI_1     => open,
   VTX1_HI_0    => open,
   VTX1_HI_1    => open,
   VTX0_HI_0    => open,
   VTX0_HI_1    => open,
   VRESFD_LO1_0 => open,
   VRESFD_LO1_1 => open,
   VRESFD_LO2_0 => open,
   VRESFD_LO2_1 => open,
   VRESPD_LO1_0 => open,
   VRESPD_LO1_1 => open,
   VSG_LO1_0    => open,
   VSG_LO1_1    => open,
   VTX1_LO1_0   => open,
   VTX1_LO1_1   => open,
   VTX1_LO2_0   => open,
   VTX1_LO2_1   => open,
   VTX0_LO1_0   => open,
   VTX0_LO1_1   => open,
   VPSUB_LO_0   => open,
   VPSUB_LO_1   => open,

   TEST         => open,

   TRIGGER0     => open,
   TRIGGER1     => open,
   TRIGGER2     => open,

   DSPARE0      => open,
   DSPARE1      => open,
   DSPARE2      => open,

   MONITOR0     => open,
   MONITOR1     => open,
   MONITOR2     => open,

RESET_B is an active low reset signal. At the start of the simulation, the RESET_B pin
must be driven low for at least 30 EXTCLK clock cycles to allow the model to initialize all its internal values

EXTCLK : the external reference clock must be applied on this pin with a reference
frequency as specified in the datasheet

FSWI_EN : this pin must be driven either high (SPI) or low (I2C) dependent on the
interface protocol that is used.

The following pins must be driven according to the SPI or I2C protocol 
to read/write registers

SCLK    : SPI or I2C input clock
SDATA   : SPI input data or I2C bidirectional data pin
CS      : chip select pin when SPI is used. Unused when using I2C protocol
SDATAOUT: SPI output data. Unused when using I2C protocol

HiSPi clock and data pins
D_CLK_#_P/N : HiSPi clock pins
DATA_#_P/N  : HiSPi data pins

Model usage
===========
In order to allow the model to generate specific test image patterns 
on the HiSPi, the following register programming must be done on the control interface.
This must be done after the reset has been completed. 
- Drive reset low
- Enable EXTCLK
- Wait for at least 30 EXTCL clock cycles 
- Drive reset high
- Wait for at least 200 microseconds
- Start programming registers using the control interface

Programming sequence for test image:
====================================
The following registers must be programmed with the specified value to enable test image generation on the HiSPi interface.
The commands below specify the register address followed by the register value.
In case of I2C, it must use the I2C slave address 0x20/0x21 as defined in the datasheet.
- REG Write = 0x3700, 0x001C
- Wait at least 500us for the PLL to start and all clocks to be stable.
- REG Write = 0x3E3E, 0x0001
- REG Write = 0x3E0E, <any value from 0x1 to 0x7>. This selects the testpattern to be sent
- Optional : REG Write = 0x3E10, <test_data_red>
- Optional : REG Write = 0x3E12, <test_data_greenr>
- Optional : REG Write = 0x3E14, <test_data_blue>
- Optional : REG Write = 0x3E16, <test_data_greenb>
- REG Write = 0x3A06, (0x8000 && <number of clock cycles between the start of two rows>)
- REG Write = 0x3A08, <number of active lines transmitted for a test image frame>
- REG Write = 0x3A0A, 0x8000 && (<number of lines between the last row of the test image and the first row of the next test image> << 6) 
                             &&  <number of test image frames to be transmitted>

Other registers that are implemented in the model:
==================================================
The following set of registers is also implemented in the model
Register address 0x0000 : Model ID
Register address 0x3000 : Model ID
Register address 0x31FE : Revision ID
Register address 0x3800 : this is used for enabling the sequencer when test image must be generated using the sequencer timing
Register address 0x3810 : line_time register
Register address 0x381C : ROI0 size register
Register address 0x383A : frame length context 0
Register address 0x3E28 : HiSPi control common register - controls the mux mode
Register address 0x3E32 : blanking data

Compilation script for modelsim
===============================
The lines below show the compilation script when using modelsim

        vcom -93 -quiet -nologo -work chip_lib xgs_model_pkg.vhd
        vcom -93 -quiet -nologo -work chip_lib xgs_hispi.vhd
        vcom -93 -quiet -nologo -work chip_lib xgs_spi_i2c.vhd
        vcom -93 -quiet -nologo -work chip_lib xgs_sensor_config.vhd
        vcom -93 -quiet -nologo -work chip_lib xgs_image.vhd
        vcom -93 -quiet -nologo -work chip_lib xgs12m_chip.vhd
