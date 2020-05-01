##################################################################################################
## 
##  Xilinx, Inc. 2010            www.xilinx.com 
##  Mon Jun 6 14:44:30 2016
##  Generated by MIG Version 2.3
##  
##################################################################################################
##  File name :       example_top.xdc
##  Details :     Constraints file
##                    FPGA Family:       ARTIX7
##                    FPGA Part:         XC7A35T-FGG484
##                    Speedgrade:        -1
##                    Design Entry:      VERILOG
##                    Frequency:         0 MHz
##                    Time Period:       5000 ps
##################################################################################################

##################################################################################################
## Controller 0
## Memory Device: DDR2_SDRAM->Components->mt47h32m16en8
## Data Width: 8
## Time Period: 5000
## Data Mask: 1
##################################################################################################
############## NET - IOSTANDARD ##################

##################################################################################################
## The selected data width is not a multiple of 16. Please note that MIG wizard is not taking care 
## of the 8 floating pins left on the external memory device.
##################################################################################################


set_property INTERNAL_VREF  0.900 [get_iobanks 14]