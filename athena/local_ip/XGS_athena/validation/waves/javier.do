onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/xgs_model_GenImage
add wave -noupdate /testbench/DUT/regfile
add wave -noupdate /testbench/XGS_MODEL/xgs_image_inst/frame
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_req_to_send
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_grant
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_fmt_type
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_length_in_dw
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_src_rdy_n
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_dst_rdy_n
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_data
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_address
add wave -noupdate -group TLP /testbench/inst_pcie_tx_axi/tlp_out_ldwbe_fdwbe
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/regfile
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_sof_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_sol_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/xtop_hispi_phy/G_lane_decoder(0)/inst_lane_decoder/pclk_packer_0_valid
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_eol_flag(0)
add wave -noupdate /testbench/DUT/x_xgs_hispi_top/bottom_eof_flag(0)
add wave -noupdate -divider {New Divider}
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/trigger_int
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/emb_data
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/first_line
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/last_line
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/dataline_valid
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/dataline_nxt
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame_length
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/roi_start
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/roi_size
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/ext_emb_data
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/cmc_patgen_en
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/active_ctxt
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/nested_readout
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/x_subsampling
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/y_subsampling
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/y_reversed
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/swap_top_bottom
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/sequencer_enable
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/slave_triggered_mode
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame_count
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/test_pattern_mode
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/test_data_red
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/test_data_greenr
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/test_data_blue
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/test_data_greenb
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame_nxt
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame_valid
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/line_count
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/frame_count_int
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line0
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line1
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line2
add wave -noupdate -group XGS_MODEL_image /testbench/XGS_MODEL/xgs_image_inst/xgs_model_GenImage
add wave -noupdate -divider {New Divider}
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_reset
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_en
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/streamer_busy
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/transfert_done
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/init_frame
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_start
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/x_row_stop
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_start
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/y_row_stop
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_clr
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ready
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_read
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_ptr
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_address
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_row_id
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/line_buffer_data
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/m_wait
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/state
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_length
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/burst_cntr
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_en
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/read_data_valid
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/first_row
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/last_row
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/buffer_read_ptr
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/start_transfer
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid_int
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tvalid
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tready
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tdata
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tuser
add wave -noupdate -group LineStreamer /testbench/DUT/x_xgs_hispi_top/xaxi_line_streamer/sclk_tlast
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/aClr
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClk
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wEn
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wData
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFull
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClk
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEn
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rData
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEmpty
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClr
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wClr_FF
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtr
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrNxt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrGray
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wPtrGrayNxt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wRdPtrGray
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wRdPtrGray_Meta
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFullInt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/wFiFoWrEn
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClr
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rClr_FF
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtr
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrNxt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrGray
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rPtrGrayNxt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rWrPtrGray
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rWrPtrGray_Meta
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rEmptyInt
add wave -noupdate -group MonoPipeline -expand -group MonoPipeline -group output_fifo /testbench/DUT/xgs_mono_pipeline_inst/xoutput_fifo/rFiFoRdEn
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -group MonoPipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/enable_hispi
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/hispi_io_data_p
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/hispi_io_clk_p
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/buff_write
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/buff_data
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/buff_addr
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/bottom_sof_flag
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/bottom_sol_flag
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/bottom_eol_flag
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/bottom_eof_flag
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_sync_error
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_packer_fifo_underrun
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_packer_fifo_overrun
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_underrun
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_fifo_overrun
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_cal_error
add wave -noupdate -group HiSpiTOP /testbench/DUT/x_xgs_hispi_top/aggregated_bit_lock_error
add wave -noupdate -expand -group Model_Image -label SER_BUSY /testbench/DUT/regfile.ACQ.ACQ_SER_STAT.SER_BUSY
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_model_GenImage
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/test_pattern_mode
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/trigger_int
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/emb_data
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/first_line
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/last_line
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/dataline_valid
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/dataline_nxt
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame_length
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/roi_start
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/roi_size
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/ext_emb_data
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/cmc_patgen_en
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/active_ctxt
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/nested_readout
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/x_subsampling
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/y_subsampling
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/y_reversed
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/swap_top_bottom
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/sequencer_enable
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/slave_triggered_mode
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame_count
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/test_data_red
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/test_data_greenr
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/test_data_blue
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/test_data_greenb
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame_nxt
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame_valid
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/line_count
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame_count_int
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line0
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line1
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/debug_frame_line2
add wave -noupdate -expand -group Model_Image /testbench/XGS_MODEL/xgs_image_inst/frame
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/regfile
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset_n
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tready
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tvalid
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tdata
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tuser
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_tlast
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_reset_n
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tready
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tuser
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tdata
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_state
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_reset
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_wen
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_full
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_phase
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_load_data
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_last_data
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_sync_packer
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_data_packer
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/sclk_packer_valid
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_empty
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tvalid_int
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_read_data_valid
add wave -noupdate -group MONOpipeline /testbench/DUT/xgs_mono_pipeline_inst/aclk_tlast_int
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color {Dark Orchid} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/wrclock
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color {Dark Orchid} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/wren
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color {Dark Orchid} /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/wraddress
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color Red /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/data
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color Red /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/rdclock
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color Red /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/rdaddress
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM -color Red /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/rden
add wave -noupdate -group AXI_Stream_IN -group AXI_Stream -expand -group dualportRAM /testbench/DUT/xdmawr2tlp/xaxi_stream_in/xdual_port_ram/q
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/sclk
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/srst_n
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tready
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tvalid
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tdata
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tlast
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/s_axis_tuser
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/start_of_frame
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_ready
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_transfered
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/end_of_dma
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_en
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_address
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/line_buffer_read_data
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/state
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_en
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_address
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_write_data
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_en
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_address
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/buffer_read_data
add wave -noupdate -group AXI_Stream_IN /testbench/DUT/xdmawr2tlp/xaxi_stream_in/last_row
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/sys_clk
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/sys_reset_n
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/cfg_bus_mast_en
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/cfg_setmaxpld
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_req_to_send
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_grant
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_fmt_type
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_length_in_dw
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_src_rdy_n
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_dst_rdy_n
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_data
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_address
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_ldwbe_fdwbe
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_attr
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_transaction_id
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_byte_count
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/tlp_lower_address
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/host_number_of_plane
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/host_write_address
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/host_line_pitch
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/host_line_size
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/host_reverse_y
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_idle
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_pcie_state
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/start_of_frame
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/line_ready
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/line_transfered
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/end_of_dma
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/read_enable_out
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/read_address
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/read_data
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_toreach_4kb
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_static_and_pcie
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_maxpayload_no_offset
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/remain_bcnt
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/bytecnt
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dwcnt
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/curr_dwcnt
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/data_byte_offset
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dw_misalig
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/ldwbe_misalig
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/ldwbe_tobe
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/nxt_dma_pcie_ctrl_state
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_pcie_ctrl_state
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/end_of_line
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/line_offset
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_addr_buf
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/nb_pcie_dout
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_fdwbe
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/dma_tlp_ldwbe
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/line_ready_meta
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/line_ready_sysclk
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/end_of_dma_sysclk
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/first_write_of_line
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/plane_counter
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/ram_output_enable
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/read_data_delayed
add wave -noupdate -group DMA_WRITE /testbench/DUT/xdmawr2tlp/xdma_write/byte_shift
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/sys_reset_n
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/sys_clk
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tvalid
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tready
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tdata
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tlast
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tuser
add wave -noupdate -expand -group PCIe_TX_AXI -color Magenta /testbench/inst_pcie_tx_axi/s_axis_tx_tkeep
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/cfg_bus_number
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/cfg_device_number
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/cfg_no_snoop_en
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/cfg_relax_ord_en
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_req_to_send
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_grant
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_fmt_type
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_length_in_dw
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_src_rdy_n
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_dst_rdy_n
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_data
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_address
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_ldwbe_fdwbe
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_attr
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_transaction_id
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_byte_count
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_lower_address
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/nxt_tlp_tx_state
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_tx_state
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/nxt_gnt_id
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/gnt_id
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tvalid
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/dst_rdy
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/new_grant
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/fmt_type
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_length
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/byte_count
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/ldwbe_fdwbe
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/transaction_id
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/lower_address
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/address
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/attr
add wave -noupdate -expand -group PCIe_TX_AXI /testbench/inst_pcie_tx_axi/tlp_out_data_p1
add wave -noupdate -radix unsigned /testbench/XGS_MODEL/xgs_image_inst/G_PXL_ARRAY_COLUMNS
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1455495962 ps} 0} {{Cursor 2} {629460179 ps} 0} {{Cursor 3} {998280000 ps} 0}
quietly wave cursor active 3
configure wave -namecolwidth 203
configure wave -valuecolwidth 134
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {982369981 ps} {1015952533 ps}
