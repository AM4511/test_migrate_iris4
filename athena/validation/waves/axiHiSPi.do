onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group axiHiSPi -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/idelay_clk
add wave -noupdate -expand -group axiHiSPi -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/axi_clk
add wave -noupdate -expand -group axiHiSPi -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/axi_reset_n
add wave -noupdate -expand -group axiHiSPi -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/axi_reset
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_awaddr
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_awprot
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_awvalid
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_awready
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_wdata
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_wstrb
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_wvalid
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_wready
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_bresp
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_bvalid
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_bready
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_araddr
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_arprot
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_arvalid
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_arready
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_rdata
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_rresp
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_rvalid
add wave -noupdate -expand -group axiHiSPi -group {AXI Slave} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/s_axi_rready
add wave -noupdate -expand -group axiHiSPi -group {HiSPi I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/hispi_io_clk_p
add wave -noupdate -expand -group axiHiSPi -group {HiSPi I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/hispi_io_clk_n
add wave -noupdate -expand -group axiHiSPi -group {HiSPi I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/hispi_io_data_p
add wave -noupdate -expand -group axiHiSPi -group {HiSPi I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/hispi_io_data_n
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_read
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_write
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_addr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_beN
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_writedata
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_readdatavalid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/reg_readdata
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/idle_character
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/new_line_pending
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/new_frame_pending
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_lanes_p
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_lanes_n
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_embeded_data
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_sof_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_eof_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_sol_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_eol_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_lanes_p
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_lanes_n
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_embeded_data
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_sof_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_eof_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_sol_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_eol_flag
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_fifo_read_en
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_fifo_empty
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_fifo_read_data_valid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/top_fifo_read_data
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_fifo_read_en
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_fifo_empty
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_fifo_read_data_valid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/bottom_fifo_read_data
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/hispi_phy_en
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/regfile
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/state
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/row_id
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/flush_lane_packer
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/packer_busy
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/all_packer_busy
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/init_lane_packer
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/line_buffer_id
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/packer_fifo_overrun
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/packer_fifo_underrun
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/frame_cntr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/line_cntr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/line_valid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/transfert_done
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/init_line_buffer_ptr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/transaction_en
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_rden
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_en
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_rdaddr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_data_valid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_rddata
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_clr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_rdy
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sbuff_count_array
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/sync
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_packer_sel
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_buffer_sel
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_sbuff_clr
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_sbuff_rden
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_sbuff_data_valid
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_sbuff_rddata
add wave -noupdate -expand -group axiHiSPi /testbench_athena/DUT/system_i/axiHiSPi_0/U0/strm_sbuff_count
add wave -noupdate -expand -group {AXI Master Stream I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/m_axis_tready
add wave -noupdate -expand -group {AXI Master Stream I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/m_axis_tvalid
add wave -noupdate -expand -group {AXI Master Stream I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/m_axis_tuser
add wave -noupdate -expand -group {AXI Master Stream I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/m_axis_tlast
add wave -noupdate -expand -group {AXI Master Stream I/F} /testbench_athena/DUT/system_i/axiHiSPi_0/U0/m_axis_tdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {514672193 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1899735611 ps}
