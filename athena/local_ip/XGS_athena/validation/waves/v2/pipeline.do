onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/frame_done
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/nb_lane_enabled
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_start
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_stop
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_start
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_size
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_lane_id
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_id
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_mux_id
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_word_ptr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_read_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_top
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_top
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_top
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_empty_bottom
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_sync_bottom
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_buffer_data_bottom
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_data
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_data_slv
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_sync
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_write_aggregated_data
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer_rdy
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_full
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_ptr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/pixel_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_valid_x_roi
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_data_packer
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_load_data
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_data
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_id_cntr_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr_max
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/lane_id_cntr_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/word_cntr_init
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/mux_id_cntr_en
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_start
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_x_stop
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_start
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/current_y_stop
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/odd_line
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} -color Cyan /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_en
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_data_slv
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_data
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_read_sync
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_usedw
add wave -noupdate -group {AXI line streamer} -group {FiFo Read I/F} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_fifo_empty
add wave -noupdate -group {AXI line streamer} -color Cyan /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/strm_state
add wave -noupdate -group {AXI line streamer} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/stream_pace_cntr
add wave -noupdate -group {AXI line streamer} -color Gold /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -group {AXI line streamer} -expand -group {AXI stream output} -color {Sky Blue} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -group {AXI line streamer} -expand -group {AXI stream output} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -group {AXI line streamer} -expand -group {AXI stream output} -color Magenta -subitemconfig {/testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser(3) {-color Magenta -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser(2) {-color Magenta -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser(1) {-color Magenta -height 15} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser(0) {-color Magenta -height 15}} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -group {AXI line streamer} -expand -group {AXI stream output} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -group {AXI line streamer} -expand -group {AXI stream output} /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} -expand /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -group xgs_mono_pipeline -group {AXI stream input} /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_en
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_pix_cntr_init
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_sync_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_packer
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_en
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_pix_cntr_init
add wave -noupdate -group xgs_mono_pipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser_int
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} -expand /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -group xgs_mono_pipeline -expand -group {AXI stream output} /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate -group {DPC filter} /testbench/DUT/xdpc_filter/axi_clk
add wave -noupdate -group {DPC filter} /testbench/DUT/xdpc_filter/axi_reset_n
add wave -noupdate -group {DPC filter} -group {AXI stream input} /testbench/DUT/xdpc_filter/s_axis_tvalid
add wave -noupdate -group {DPC filter} -group {AXI stream input} /testbench/DUT/xdpc_filter/s_axis_tready
add wave -noupdate -group {DPC filter} -group {AXI stream input} /testbench/DUT/xdpc_filter/s_axis_tuser
add wave -noupdate -group {DPC filter} -group {AXI stream input} /testbench/DUT/xdpc_filter/s_axis_tlast
add wave -noupdate -group {DPC filter} -group {AXI stream input} /testbench/DUT/xdpc_filter/s_axis_tdata
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xstart
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xend
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Ystart
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Yend
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xsub
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Ysub
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/load_dma_context_EOFOT
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_length
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_ver
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_color
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_enable
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_pattern0_cfg
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_fifo_rst
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_fifo_ovr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_fifo_und
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_wrn
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_add
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_ss
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_count
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_corr_pattern
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_corr_y
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_corr_x
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_list_corr_rd
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_firstlast_line_rem
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/axi_reset
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_tready_int
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_first_line
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_first_prefetch
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_prefetch
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_prefetch_done
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_prefetch_cnt
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_line_gap
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_line_wait
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/s_axis_frame_done
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xstart_corr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xend_corr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xstart_integer
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/curr_Xend_integer
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/BAYER_Sensor
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_enable_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/REG_dpc_enable_DB
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_sol_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_enable_start
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_enable_stop
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_enable_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_bypass
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_in_100_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_data_in_100_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eol_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eol_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eol_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eof_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eof_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eof_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_eof_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_kernel_10x3_sol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_kernel_10x3_eof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_en
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_out
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_curr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_X_pix_curr_nosub
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_X_pix_curr_sub
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_X_pix_curr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_first_col
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_last_col
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sof_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sol_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_en_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eol_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eof_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sol_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_en_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eol_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eof_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sol_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_en_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eol_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eof_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_sol_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_en_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eol_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_eof_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_sol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_en
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_data
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_eol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/proc_eof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_first_line
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_last_line
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_first_col
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/kernel_10x3_last_col
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr_sof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr_sol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr_en
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr_eol
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/Pix_corr_eof
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_enable
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_enable_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_address
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_data
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_end
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_R_end_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/RAM_W_data
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_P3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_P4
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_P5
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_data
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_write
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_list_rdy
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/dpc_fifo_reset_done
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/m_axis_tvalid_int
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/m_axis_tdata_int
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/m_axis_tuser_int
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/m_axis_wait_data
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/m_axis_wait
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_proc_data_3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_proc_data_2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_proc_data_1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_proc_data_0
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_4_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_3_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_2_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_1_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_0_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_L_P2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_3_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_2_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_1_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_dpc_data_in_100_0_P1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_3
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_2
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_1
add wave -noupdate -group {DPC filter} -group {New Group} /testbench/DUT/xdpc_filter/alias_fpnprnu_corr_data_0
add wave -noupdate -group {DPC filter} -expand -group {AXI stream output} /testbench/DUT/xdpc_filter/m_axis_tready
add wave -noupdate -group {DPC filter} -expand -group {AXI stream output} /testbench/DUT/xdpc_filter/m_axis_tvalid
add wave -noupdate -group {DPC filter} -expand -group {AXI stream output} -expand /testbench/DUT/xdpc_filter/m_axis_tuser
add wave -noupdate -group {DPC filter} -expand -group {AXI stream output} /testbench/DUT/xdpc_filter/m_axis_tlast
add wave -noupdate -group {DPC filter} -expand -group {AXI stream output} /testbench/DUT/xdpc_filter/m_axis_tdata
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/axi_clk
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/axi_reset_n
add wave -noupdate -group axi_lut -group {AXI stream input} /testbench/DUT/xaxi_lut/s_axis_tvalid
add wave -noupdate -group axi_lut -group {AXI stream input} /testbench/DUT/xaxi_lut/s_axis_tready
add wave -noupdate -group axi_lut -group {AXI stream input} /testbench/DUT/xaxi_lut/s_axis_tuser
add wave -noupdate -group axi_lut -group {AXI stream input} /testbench/DUT/xaxi_lut/s_axis_tlast
add wave -noupdate -group axi_lut -group {AXI stream input} /testbench/DUT/xaxi_lut/s_axis_tdata
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/regfile
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/s_axis_tdata_p1
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_W_enable
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_W_address
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_W_data
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_R_enable
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_R_enable_ored
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_R_address
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/RAM_R_data
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/axi_state
add wave -noupdate -group axi_lut /testbench/DUT/xaxi_lut/m_axis_tuser_int
add wave -noupdate -group {AXI stream out} /testbench/DUT/xaxi_lut/m_axis_tready
add wave -noupdate -group {AXI stream out} /testbench/DUT/xaxi_lut/m_axis_tvalid
add wave -noupdate -group {AXI stream out} /testbench/DUT/xaxi_lut/m_axis_tuser
add wave -noupdate -group {AXI stream out} /testbench/DUT/xaxi_lut/m_axis_tlast
add wave -noupdate -group {AXI stream out} /testbench/DUT/xaxi_lut/m_axis_tdata
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/sclk
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/srst_n
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/intevent
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/context_strb
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/regfile
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} /testbench/DUT/xdmawr2tlp/tready
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} /testbench/DUT/xdmawr2tlp/tvalid
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} /testbench/DUT/xdmawr2tlp/tdata
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} /testbench/DUT/xdmawr2tlp/tuser
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} /testbench/DUT/xdmawr2tlp/tlast
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/clr_max_line_buffer_cnt
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_width
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/max_line_buffer_cnt
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/pcie_back_pressure_detected
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in -expand /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/wr_state
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/rd_state
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/read_sync
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/init_line_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/incr_wr_line_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/incr_rd_line_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/wr_line_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/rd_line_ptr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ptr_mask
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/distance_cntr
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/max_distance
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_full
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_empty
add wave -noupdate -group dmawr2tlp -expand -group {AXI stream input} -group axi_strean_in /testbench/DUT/xdmawr2tlp/xaxi_stream_in/numb_line_buffer
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/cfg_bus_mast_en
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/cfg_setmaxpld
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/tlp_req_to_send
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/tlp_grant
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_idle
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_pcie_state
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/start_of_frame
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_ready
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_transfered
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/end_of_dma
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_buffer_read_en
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_buffer_read_address
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_buffer_read_data
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/color_space
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/clr_max_line_buffer_cnt
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/line_ptr_width
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/max_line_buffer_cnt
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/pcie_back_pressure_detected
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_context_mapping
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_context_p0
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_context_P1
add wave -noupdate -group dmawr2tlp /testbench/DUT/xdmawr2tlp/dma_context_mux
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_fmt_type
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_length_in_dw
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_src_rdy_n
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_dst_rdy_n
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_data
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_address
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_ldwbe_fdwbe
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_attr
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_transaction_id
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_byte_count
add wave -noupdate -group dmawr2tlp -group {TLP interface} /testbench/DUT/xdmawr2tlp/tlp_lower_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1576166245 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {1364853928 ps} {2005872874 ps}
