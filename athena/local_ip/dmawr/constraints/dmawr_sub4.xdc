#### USE THIS SECTION when added to project directly
##constraints for RW registers
#set_false_path -from [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~ *field_rw_*_*reg[*]}]
#set_false_path -from [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~ *field_rw_*_*reg}]
#
##constraints for reg_readdata mux
#set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*field_rw_*_*reg[*]}] -filter {REF_PIN_NAME == C}]  -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
#set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*field_rw_*_*reg}] -filter {REF_PIN_NAME == C}]     -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
#set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_addr*}] -filter {REF_PIN_NAME == C}]              -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
#set_multicycle_path 2 -setup  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*field_rw_*_*reg[*]}] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
#set_multicycle_path 2 -setup  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*field_rw_*_*reg}] -filter {REF_PIN_NAME == C}]    -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
#set_multicycle_path 2 -setup  -from [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_addr*}] -filter {REF_PIN_NAME == C}]             -to [get_pins -of [get_cells -hierarchical -filter {name=~*dmawr_sub4* && name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]

# USE THIS SECTION when packaged with the IP and then ran as out-of-context
#constraints for RW registers
set_false_path -from [get_cells -hierarchical -filter {name=~ *field_rw_*_*reg[*]}]
set_false_path -from [get_cells -hierarchical -filter {name=~ *field_rw_*_*reg}]

#constraints for reg_readdata mux
set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*field_rw_*_*reg[*]}] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*field_rw_*_*reg}] -filter {REF_PIN_NAME == C}]    -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
set_multicycle_path 1 -hold  -from [get_pins -of [get_cells -hierarchical -filter {name=~*reg_addr*}] -filter {REF_PIN_NAME == C}]          -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
set_multicycle_path 2 -setup -from [get_pins -of [get_cells -hierarchical -filter {name=~*field_rw_*_*reg[*]}] -filter {REF_PIN_NAME == C}] -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
set_multicycle_path 2 -setup -from [get_pins -of [get_cells -hierarchical -filter {name=~*field_rw_*_*reg}] -filter {REF_PIN_NAME == C}]    -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
set_multicycle_path 2 -setup -from [get_pins -of [get_cells -hierarchical -filter {name=~*reg_addr*}] -filter {REF_PIN_NAME == C}]          -to [get_pins -of [get_cells -hierarchical -filter {name=~*reg_readdata_reg*}] -filter {REF_PIN_NAME == D}]
