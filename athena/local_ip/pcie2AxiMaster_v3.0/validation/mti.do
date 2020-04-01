echo "START COMPILING pcie_7x_0_pipe_rate.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_rate.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_rate.v  
echo "DONE COMPILING pcie_7x_0_pipe_rate.v" 

echo "START COMPILING pcie_7x_0_pipe_sync.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_sync.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_sync.v  
echo "DONE COMPILING pcie_7x_0_pipe_sync.v" 

echo "START COMPILING pcie_7x_0_gt_common.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gt_common.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gt_common.v  
echo "DONE COMPILING pcie_7x_0_gt_common.v" 

echo "START COMPILING pcie_7x_0_qpll_wrapper.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_qpll_wrapper.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_qpll_wrapper.v  
echo "DONE COMPILING pcie_7x_0_qpll_wrapper.v" 

echo "START COMPILING pcie_7x_0_gtx_cpllpd_ovrd.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gtx_cpllpd_ovrd.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gtx_cpllpd_ovrd.v  
echo "DONE COMPILING pcie_7x_0_gtx_cpllpd_ovrd.v" 

echo "START COMPILING pcie_7x_0_gt_rx_valid_filter_7x.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_gt_rx_valid_filter_7x.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gt_rx_valid_filter_7x.vhd  
echo "DONE COMPILING pcie_7x_0_gt_rx_valid_filter_7x.vhd" 

echo "START COMPILING pcie_7x_0_gt_top.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_gt_top.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gt_top.vhd  
echo "DONE COMPILING pcie_7x_0_gt_top.vhd" 

echo "START COMPILING pcie_7x_0_pcie_pipe_misc.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_pipe_misc.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_pipe_misc.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_pipe_misc.vhd" 

echo "START COMPILING pcie_7x_0_pcie_pipe_lane.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_pipe_lane.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_pipe_lane.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_pipe_lane.vhd" 

echo "START COMPILING pcie_7x_0_gtp_pipe_reset.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gtp_pipe_reset.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gtp_pipe_reset.v  
echo "DONE COMPILING pcie_7x_0_gtp_pipe_reset.v" 

echo "START COMPILING pcie_7x_0_pipe_drp.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_drp.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_drp.v  
echo "DONE COMPILING pcie_7x_0_pipe_drp.v" 

echo "START COMPILING pcie_7x_0_qpll_drp.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_qpll_drp.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_qpll_drp.v  
echo "DONE COMPILING pcie_7x_0_qpll_drp.v" 

echo "START COMPILING pcie_7x_0_axi_basic_rx_null_gen.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_rx_null_gen.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_rx_null_gen.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_rx_null_gen.vhd" 

echo "START COMPILING pcie_7x_0_axi_basic_rx_pipeline.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_rx_pipeline.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_rx_pipeline.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_rx_pipeline.vhd" 

echo "START COMPILING pcie_7x_0_axi_basic_rx.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_rx.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_rx.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_rx.vhd" 

echo "START COMPILING pcie_7x_0_gt_wrapper.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gt_wrapper.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gt_wrapper.v  
echo "DONE COMPILING pcie_7x_0_gt_wrapper.v" 

echo "START COMPILING pcie_7x_0_pcie_bram_7x.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_bram_7x.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_bram_7x.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_bram_7x.vhd" 

echo "START COMPILING pcie_7x_0_pcie_brams_7x.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_brams_7x.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_brams_7x.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_brams_7x.vhd" 

echo "START COMPILING pcie_7x_0_pcie_bram_top_7x.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_bram_top_7x.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_bram_top_7x.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_bram_top_7x.vhd" 

echo "START COMPILING pcie_7x_0_rxeq_scan.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_rxeq_scan.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_rxeq_scan.v  
echo "DONE COMPILING pcie_7x_0_rxeq_scan.v" 

echo "START COMPILING pcie_7x_0_pipe_wrapper.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_wrapper.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_wrapper.v  
echo "DONE COMPILING pcie_7x_0_pipe_wrapper.v" 

echo "START COMPILING pcie_7x_0_gtp_pipe_rate.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gtp_pipe_rate.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gtp_pipe_rate.v  
echo "DONE COMPILING pcie_7x_0_gtp_pipe_rate.v" 

echo "START COMPILING pcie_7x_0_axi_basic_tx_thrtl_ctl.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_tx_thrtl_ctl.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_tx_thrtl_ctl.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_tx_thrtl_ctl.vhd" 

echo "START COMPILING pcie_7x_0_gtp_cpllpd_ovrd.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gtp_cpllpd_ovrd.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gtp_cpllpd_ovrd.v  
echo "DONE COMPILING pcie_7x_0_gtp_cpllpd_ovrd.v" 

echo "START COMPILING pcie_7x_0_axi_basic_tx_pipeline.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_tx_pipeline.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_tx_pipeline.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_tx_pipeline.vhd" 

echo "START COMPILING pcie_7x_0_gtp_pipe_drp.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_gtp_pipe_drp.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_gtp_pipe_drp.v  
echo "DONE COMPILING pcie_7x_0_gtp_pipe_drp.v" 

echo "START COMPILING pcie_7x_0_qpll_reset.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_qpll_reset.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_qpll_reset.v  
echo "DONE COMPILING pcie_7x_0_qpll_reset.v" 

echo "START COMPILING pcie_7x_0_pipe_eq.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_eq.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_eq.v  
echo "DONE COMPILING pcie_7x_0_pipe_eq.v" 

echo "START COMPILING pcie_7x_0_pipe_clock.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_clock.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_clock.v  
echo "DONE COMPILING pcie_7x_0_pipe_clock.v" 

echo "START COMPILING pcie_7x_0_pipe_user.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_user.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_user.v  
echo "DONE COMPILING pcie_7x_0_pipe_user.v" 

echo "START COMPILING pcie_7x_0_pipe_reset.v "
onerror {echo "COMPILE_ERROR pcie_7x_0_pipe_reset.v"; }
vlog -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib  -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pipe_reset.v  
echo "DONE COMPILING pcie_7x_0_pipe_reset.v" 

echo "START COMPILING tlp_to_axi_master.vhd "
onerror {echo "COMPILE_ERROR tlp_to_axi_master.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/tlp_to_axi_master.vhd  
echo "DONE COMPILING tlp_to_axi_master.vhd" 

echo "START COMPILING pcie_7x_0.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0.vhd  
echo "DONE COMPILING pcie_7x_0.vhd" 

echo "START COMPILING pcie2AxiMaster.vhd "
onerror {echo "COMPILE_ERROR pcie2AxiMaster.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie2AxiMaster.vhd  
echo "DONE COMPILING pcie2AxiMaster.vhd" 

echo "START COMPILING pcie_7x_0_pcie_pipe_pipeline.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_pipe_pipeline.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_pipe_pipeline.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_pipe_pipeline.vhd" 

echo "START COMPILING pcie_7x_0_pcie_7x.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_7x.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_7x.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_7x.vhd" 

echo "START COMPILING pcie_7x_0_axi_basic_tx.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_tx.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_tx.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_tx.vhd" 

echo "START COMPILING pcie_7x_0_axi_basic_top.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_axi_basic_top.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_axi_basic_top.vhd  
echo "DONE COMPILING pcie_7x_0_axi_basic_top.vhd" 

echo "START COMPILING pcie_7x_0_pcie_top.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie_top.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie_top.vhd  
echo "DONE COMPILING pcie_7x_0_pcie_top.vhd" 

echo "START COMPILING pcie_7x_0_core_top.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_core_top.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_core_top.vhd  
echo "DONE COMPILING pcie_7x_0_core_top.vhd" 

echo "START COMPILING pcie_7x_0_pcie2_top.vhd "
onerror {echo "COMPILE_ERROR pcie_7x_0_pcie2_top.vhd"; }
vcom  -explicit -modelsimini D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/modelsim.ini -work  D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.lib -source D:/git/gitlab/concordG2/ipcores/pcie2AxiMaster/validation/mti/pcie2AxiMaster.source/pcie_7x_0_pcie2_top.vhd  
echo "DONE COMPILING pcie_7x_0_pcie2_top.vhd" 

quit -f
