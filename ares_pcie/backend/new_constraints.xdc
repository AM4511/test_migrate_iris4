create_generated_clock -name hb_ck_n -source [get_pins ares_pb_i/ares_pb_i/rpc2_ctrl_controller_0/inst/rpc2_ctrl_io/io_oddr_ckn/ODDR_inst/C] -divide_by 1 -invert [get_ports hb_ck_n]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks clk_125mhz] -group [get_clocks -include_generated_clocks clk_250mhz]
