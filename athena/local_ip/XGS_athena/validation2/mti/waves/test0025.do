onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst_n
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_unpack
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wren
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wlength
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_weof
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Write I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wbuff_id
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Write I/F} -color Violet /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wren
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Write I/F} -color Violet /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wraddress
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Write I/F} -color Violet /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_wrdata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/srst
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_address
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_en
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_write_en
add wave -noupdate -expand -group dma_line_buffer -expand /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_address
add wave -noupdate -expand -group dma_line_buffer -expand /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_buffer_read_data_mux
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_wrdata
add wave -noupdate -expand -group dma_line_buffer /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rddata
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rden
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rlength
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_reof
add wave -noupdate -expand -group dma_line_buffer -group {Info buffer Read I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_info_rbuff_id
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} -color Gold /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sck_output_mux_sel
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} -color {Cornflower Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rden
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} -color {Cornflower Blue} -expand -subitemconfig {/testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(12) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(11) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(10) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(9) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(8) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(7) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(6) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(5) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(4) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(3) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(2) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(1) {-color {Cornflower Blue}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress(0) {-color {Cornflower Blue}}} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rdaddress
add wave -noupdate -expand -group dma_line_buffer -expand -group {Line Buffer Read I/F} -color {Cornflower Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/xdma_line_buffer/sclk_rddata
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/dma_context_P1.numb_plane
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/regfile
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/planar_en
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/clr_max_line_buffer_cnt
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_width
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/max_line_buffer_cnt
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/pcie_back_pressure_detected
add wave -noupdate -group axi_stream_in -group {AXI Stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -group axi_stream_in -group {AXI Stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -group axi_stream_in -group {AXI Stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -group axi_stream_in -group {AXI Stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -group axi_stream_in -group {AXI Stream input I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -group axi_stream_in -group {DMA I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -group axi_stream_in -group {DMA I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -group axi_stream_in -group {DMA I/F} -color {Slate Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -group axi_stream_in -group {DMA I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -group axi_stream_in -group {DMA I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -group axi_stream_in -group {DMA I/F} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/wr_state
add wave -noupdate -group axi_stream_in -radix unsigned /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rlength
add wave -noupdate -group axi_stream_in -color {Sky Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_rd_last_data
add wave -noupdate -group axi_stream_in -color {Sky Blue} /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/rd_state
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -group axi_stream_in -radix hexadecimal /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/read_sync
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/init_line_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/incr_wr_line_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/incr_rd_line_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/wr_line_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/rd_line_ptr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/distance_cntr
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/max_distance
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_full
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_empty
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/numb_line_buffer
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wren
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wlength
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_weof
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_wbuff_id
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rden
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_reof
add wave -noupdate -group axi_stream_in /testbench/system_top/DUT/xdmawr2tlp/xaxi_stream_in/sclk_info_rbuff_id
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/sys_clk
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/sys_reset_n
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/cfg_bus_mast_en
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/cfg_setmaxpld
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_req_to_send
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_grant
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_fmt_type
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_length_in_dw
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_src_rdy_n
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_dst_rdy_n
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_data
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_address
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_ldwbe_fdwbe
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_attr
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_transaction_id
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_byte_count
add wave -noupdate -group dma_write -group {tlp I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/tlp_lower_address
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/host_number_of_plane
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/host_write_address
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/host_line_pitch
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/host_line_size
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/host_reverse_y
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_idle
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_pcie_state
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/start_of_frame
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/line_ready
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/line_transfered
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/end_of_dma
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/read_enable_out
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/read_address
add wave -noupdate -group dma_write -expand -group {Read buffer I/F} /testbench/system_top/DUT/xdmawr2tlp/xdma_write/read_data
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_toreach_4kb
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_maxpayload
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_static_and_pcie
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_no_offset
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/remain_bcnt
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/bytecnt
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dwcnt
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/curr_dwcnt
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/data_byte_offset
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dw_misalig
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/ldwbe_misalig
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/ldwbe_tobe
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/plane_counter
add wave -noupdate -group dma_write -color Magenta /testbench/system_top/DUT/xdmawr2tlp/xdma_write/end_of_line
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/nxt_dma_pcie_ctrl_state
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_pcie_ctrl_state
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/line_offset
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_tlp_addr_buf
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/nb_pcie_dout
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_tlp_fdwbe
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/dma_tlp_ldwbe
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/line_ready_meta
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/line_ready_sysclk
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/end_of_dma_sysclk
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/first_write_of_line
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/ram_output_enable
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/read_data_delayed
add wave -noupdate -group dma_write /testbench/system_top/DUT/xdmawr2tlp/xdma_write/byte_shift
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5805063755 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 288
configure wave -valuecolwidth 220
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {5804912194 ps} {5805650511 ps}
