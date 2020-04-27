// This wrapper is used to overwrite sub parameters
// in the Xilinx pcie core, using defparam

// IP VLNV: xilinx.com:ip:pcie_7x:3.3
// IP Revision: 9


`timescale 1ns/1ps

module pcie_7x_0_mtx_wrapper # (
				parameter         CFG_VEND_ID        = 16'h102b,
				parameter         CFG_DEV_ID         = 16'hffff,
				parameter         CFG_REV_ID         =  8'hFF,
				parameter         CFG_SUBSYS_VEND_ID = 16'h102b,
				parameter         CFG_SUBSYS_ID      = 16'hffff
				)
   (
    pci_exp_txp,
    pci_exp_txn,
    pci_exp_rxp,
    pci_exp_rxn,
    user_clk_out,
    user_reset_out,
    user_lnk_up,
    user_app_rdy,
    tx_buf_av,
    tx_cfg_req,
    tx_err_drop,
    s_axis_tx_tready,
    s_axis_tx_tdata,
    s_axis_tx_tkeep,
    s_axis_tx_tlast,
    s_axis_tx_tvalid,
    s_axis_tx_tuser,
    tx_cfg_gnt,
    m_axis_rx_tdata,
    m_axis_rx_tkeep,
    m_axis_rx_tlast,
    m_axis_rx_tvalid,
    m_axis_rx_tready,
    m_axis_rx_tuser,
    rx_np_ok,
    rx_np_req,
    cfg_status,
    cfg_command,
    cfg_dstatus,
    cfg_dcommand,
    cfg_lstatus,
    cfg_lcommand,
    cfg_dcommand2,
    cfg_pcie_link_state,
    cfg_pmcsr_pme_en,
    cfg_pmcsr_powerstate,
    cfg_pmcsr_pme_status,
    cfg_received_func_lvl_rst,
    cfg_err_ecrc,
    cfg_err_ur,
    cfg_err_cpl_timeout,
    cfg_err_cpl_unexpect,
    cfg_err_cpl_abort,
    cfg_err_posted,
    cfg_err_cor,
    cfg_err_atomic_egress_blocked,
    cfg_err_internal_cor,
    cfg_err_malformed,
    cfg_err_mc_blocked,
    cfg_err_poisoned,
    cfg_err_norecovery,
    cfg_err_tlp_cpl_header,
    cfg_err_cpl_rdy,
    cfg_err_locked,
    cfg_err_acs,
    cfg_err_internal_uncor,
    cfg_trn_pending,
    cfg_pm_halt_aspm_l0s,
    cfg_pm_halt_aspm_l1,
    cfg_pm_force_state_en,
    cfg_pm_force_state,
    cfg_dsn,
    cfg_interrupt,
    cfg_interrupt_rdy,
    cfg_interrupt_assert,
    cfg_interrupt_di,
    cfg_interrupt_do,
    cfg_interrupt_mmenable,
    cfg_interrupt_msienable,
    cfg_interrupt_msixenable,
    cfg_interrupt_msixfm,
    cfg_interrupt_stat,
    cfg_pciecap_interrupt_msgnum,
    cfg_to_turnoff,
    cfg_turnoff_ok,
    cfg_bus_number,
    cfg_device_number,
    cfg_function_number,
    cfg_pm_wake,
    cfg_pm_send_pme_to,
    cfg_ds_bus_number,
    cfg_ds_device_number,
    cfg_ds_function_number,
    cfg_bridge_serr_en,
    cfg_slot_control_electromech_il_ctl_pulse,
    cfg_root_control_syserr_corr_err_en,
    cfg_root_control_syserr_non_fatal_err_en,
    cfg_root_control_syserr_fatal_err_en,
    cfg_root_control_pme_int_en,
    cfg_aer_rooterr_corr_err_reporting_en,
    cfg_aer_rooterr_non_fatal_err_reporting_en,
    cfg_aer_rooterr_fatal_err_reporting_en,
    cfg_aer_rooterr_corr_err_received,
    cfg_aer_rooterr_non_fatal_err_received,
    cfg_aer_rooterr_fatal_err_received,
    cfg_err_aer_headerlog,
    cfg_aer_interrupt_msgnum,
    cfg_err_aer_headerlog_set,
    cfg_aer_ecrc_check_en,
    cfg_aer_ecrc_gen_en,
    cfg_vc_tcvc_map,
    sys_clk,
    sys_rst_n
    );




   output wire [0 : 0] pci_exp_txp;
   output wire [0 : 0] pci_exp_txn;
   input wire [0 : 0]  pci_exp_rxp;
   input wire [0 : 0]  pci_exp_rxn;
   output wire 	       user_clk_out;
   output wire 	       user_reset_out;
   output wire 	       user_lnk_up;
   output wire 	       user_app_rdy;
   output wire [5 : 0] tx_buf_av;
   output wire 	       tx_cfg_req;
   output wire 	       tx_err_drop;
   output wire 	       s_axis_tx_tready;
   input wire [63 : 0] s_axis_tx_tdata;
   input wire [7 : 0]  s_axis_tx_tkeep;
   input wire 	       s_axis_tx_tlast;
   input wire 	       s_axis_tx_tvalid;
   input wire [3 : 0]  s_axis_tx_tuser;
   input wire 	       tx_cfg_gnt;
   output wire [63 : 0] m_axis_rx_tdata;
   output wire [7 : 0] 	m_axis_rx_tkeep;
   output wire 		m_axis_rx_tlast;
   output wire 		m_axis_rx_tvalid;
   input wire 		m_axis_rx_tready;
   output wire [21 : 0] m_axis_rx_tuser;
   input wire 		rx_np_ok;
   input wire 		rx_np_req;
   output wire [15 : 0] cfg_status;
   output wire [15 : 0] cfg_command;
   output wire [15 : 0] cfg_dstatus;
   output wire [15 : 0] cfg_dcommand;
   output wire [15 : 0] cfg_lstatus;
   output wire [15 : 0] cfg_lcommand;
   output wire [15 : 0] cfg_dcommand2;
   output wire [2 : 0] 	cfg_pcie_link_state;
   output wire 		cfg_pmcsr_pme_en;
   output wire [1 : 0] 	cfg_pmcsr_powerstate;
   output wire 		cfg_pmcsr_pme_status;
   output wire 		cfg_received_func_lvl_rst;
   input wire 		cfg_err_ecrc;
   input wire 		cfg_err_ur;
   input wire 		cfg_err_cpl_timeout;
   input wire 		cfg_err_cpl_unexpect;
   input wire 		cfg_err_cpl_abort;
   input wire 		cfg_err_posted;
   input wire 		cfg_err_cor;
   input wire 		cfg_err_atomic_egress_blocked;
   input wire 		cfg_err_internal_cor;
   input wire 		cfg_err_malformed;
   input wire 		cfg_err_mc_blocked;
   input wire 		cfg_err_poisoned;
   input wire 		cfg_err_norecovery;
   input wire [47 : 0] 	cfg_err_tlp_cpl_header;
   output wire 		cfg_err_cpl_rdy;
   input wire 		cfg_err_locked;
   input wire 		cfg_err_acs;
   input wire 		cfg_err_internal_uncor;
   input wire 		cfg_trn_pending;
   input wire 		cfg_pm_halt_aspm_l0s;
   input wire 		cfg_pm_halt_aspm_l1;
   input wire 		cfg_pm_force_state_en;
   input wire [1 : 0] 	cfg_pm_force_state;
   input wire [63 : 0] 	cfg_dsn;
   input wire 		cfg_interrupt;
   output wire 		cfg_interrupt_rdy;
   input wire 		cfg_interrupt_assert;
   input wire [7 : 0] 	cfg_interrupt_di;
   output wire [7 : 0] 	cfg_interrupt_do;
   output wire [2 : 0] 	cfg_interrupt_mmenable;
   output wire 		cfg_interrupt_msienable;
   output wire 		cfg_interrupt_msixenable;
   output wire 		cfg_interrupt_msixfm;
   input wire 		cfg_interrupt_stat;
   input wire [4 : 0] 	cfg_pciecap_interrupt_msgnum;
   output wire 		cfg_to_turnoff;
   input wire 		cfg_turnoff_ok;
   output wire [7 : 0] 	cfg_bus_number;
   output wire [4 : 0] 	cfg_device_number;
   output wire [2 : 0] 	cfg_function_number;
   input wire 		cfg_pm_wake;
   input wire 		cfg_pm_send_pme_to;
   input wire [7 : 0] 	cfg_ds_bus_number;
   input wire [4 : 0] 	cfg_ds_device_number;
   input wire [2 : 0] 	cfg_ds_function_number;
   output wire 		cfg_bridge_serr_en;
   output wire 		cfg_slot_control_electromech_il_ctl_pulse;
   output wire 		cfg_root_control_syserr_corr_err_en;
   output wire 		cfg_root_control_syserr_non_fatal_err_en;
   output wire 		cfg_root_control_syserr_fatal_err_en;
   output wire 		cfg_root_control_pme_int_en;
   output wire 		cfg_aer_rooterr_corr_err_reporting_en;
   output wire 		cfg_aer_rooterr_non_fatal_err_reporting_en;
   output wire 		cfg_aer_rooterr_fatal_err_reporting_en;
   output wire 		cfg_aer_rooterr_corr_err_received;
   output wire 		cfg_aer_rooterr_non_fatal_err_received;
   output wire 		cfg_aer_rooterr_fatal_err_received;
   input wire [127 : 0] cfg_err_aer_headerlog;
   input wire [4 : 0] 	cfg_aer_interrupt_msgnum;
   output wire 		cfg_err_aer_headerlog_set;
   output wire 		cfg_aer_ecrc_check_en;
   output wire 		cfg_aer_ecrc_gen_en;
   output wire [6 : 0] 	cfg_vc_tcvc_map;
   input wire 		sys_clk;
   input wire 		sys_rst_n;
  
  // OVERWRITE XILINX PARAMETERS SET BY THE WIZARD
   defparam pcie_7x_0_xil_wrapper.inst.inst.CFG_VEND_ID         =   CFG_VEND_ID;
   defparam pcie_7x_0_xil_wrapper.inst.inst.CFG_DEV_ID          =   CFG_DEV_ID;
   defparam pcie_7x_0_xil_wrapper.inst.inst.CFG_REV_ID          =   CFG_REV_ID;
   defparam pcie_7x_0_xil_wrapper.inst.inst.CFG_SUBSYS_VEND_ID  =   CFG_SUBSYS_VEND_ID;
   defparam pcie_7x_0_xil_wrapper.inst.inst.CFG_SUBSYS_ID       =   CFG_SUBSYS_ID;
   

pcie_7x_0 pcie_7x_0_xil_wrapper (
  .pci_exp_txp(pci_exp_txp),                                                                // output wire [0 : 0] pci_exp_txp
  .pci_exp_txn(pci_exp_txn),                                                                // output wire [0 : 0] pci_exp_txn
  .pci_exp_rxp(pci_exp_rxp),                                                                // input wire [0 : 0] pci_exp_rxp
  .pci_exp_rxn(pci_exp_rxn),                                                                // input wire [0 : 0] pci_exp_rxn
  .user_clk_out(user_clk_out),                                                              // output wire user_clk_out
  .user_reset_out(user_reset_out),                                                          // output wire user_reset_out
  .user_lnk_up(user_lnk_up),                                                                // output wire user_lnk_up
  .user_app_rdy(user_app_rdy),                                                              // output wire user_app_rdy
  .tx_buf_av(tx_buf_av),                                                                    // output wire [5 : 0] tx_buf_av
  .tx_cfg_req(tx_cfg_req),                                                                  // output wire tx_cfg_req
  .tx_err_drop(tx_err_drop),                                                                // output wire tx_err_drop
  .s_axis_tx_tready(s_axis_tx_tready),                                                      // output wire s_axis_tx_tready
  .s_axis_tx_tdata(s_axis_tx_tdata),                                                        // input wire [63 : 0] s_axis_tx_tdata
  .s_axis_tx_tkeep(s_axis_tx_tkeep),                                                        // input wire [7 : 0] s_axis_tx_tkeep
  .s_axis_tx_tlast(s_axis_tx_tlast),                                                        // input wire s_axis_tx_tlast
  .s_axis_tx_tvalid(s_axis_tx_tvalid),                                                      // input wire s_axis_tx_tvalid
  .s_axis_tx_tuser(s_axis_tx_tuser),                                                        // input wire [3 : 0] s_axis_tx_tuser
  .tx_cfg_gnt(tx_cfg_gnt),                                                                  // input wire tx_cfg_gnt
  .m_axis_rx_tdata(m_axis_rx_tdata),                                                        // output wire [63 : 0] m_axis_rx_tdata
  .m_axis_rx_tkeep(m_axis_rx_tkeep),                                                        // output wire [7 : 0] m_axis_rx_tkeep
  .m_axis_rx_tlast(m_axis_rx_tlast),                                                        // output wire m_axis_rx_tlast
  .m_axis_rx_tvalid(m_axis_rx_tvalid),                                                      // output wire m_axis_rx_tvalid
  .m_axis_rx_tready(m_axis_rx_tready),                                                      // input wire m_axis_rx_tready
  .m_axis_rx_tuser(m_axis_rx_tuser),                                                        // output wire [21 : 0] m_axis_rx_tuser
  .rx_np_ok(rx_np_ok),                                                                      // input wire rx_np_ok
  .rx_np_req(rx_np_req),                                                                    // input wire rx_np_req
  .cfg_status(cfg_status),                                                                  // output wire [15 : 0] cfg_status
  .cfg_command(cfg_command),                                                                // output wire [15 : 0] cfg_command
  .cfg_dstatus(cfg_dstatus),                                                                // output wire [15 : 0] cfg_dstatus
  .cfg_dcommand(cfg_dcommand),                                                              // output wire [15 : 0] cfg_dcommand
  .cfg_lstatus(cfg_lstatus),                                                                // output wire [15 : 0] cfg_lstatus
  .cfg_lcommand(cfg_lcommand),                                                              // output wire [15 : 0] cfg_lcommand
  .cfg_dcommand2(cfg_dcommand2),                                                            // output wire [15 : 0] cfg_dcommand2
  .cfg_pcie_link_state(cfg_pcie_link_state),                                                // output wire [2 : 0] cfg_pcie_link_state
  .cfg_pmcsr_pme_en(cfg_pmcsr_pme_en),                                                      // output wire cfg_pmcsr_pme_en
  .cfg_pmcsr_powerstate(cfg_pmcsr_powerstate),                                              // output wire [1 : 0] cfg_pmcsr_powerstate
  .cfg_pmcsr_pme_status(cfg_pmcsr_pme_status),                                              // output wire cfg_pmcsr_pme_status
  .cfg_received_func_lvl_rst(cfg_received_func_lvl_rst),                                    // output wire cfg_received_func_lvl_rst
  .cfg_err_ecrc(cfg_err_ecrc),                                                              // input wire cfg_err_ecrc
  .cfg_err_ur(cfg_err_ur),                                                                  // input wire cfg_err_ur
  .cfg_err_cpl_timeout(cfg_err_cpl_timeout),                                                // input wire cfg_err_cpl_timeout
  .cfg_err_cpl_unexpect(cfg_err_cpl_unexpect),                                              // input wire cfg_err_cpl_unexpect
  .cfg_err_cpl_abort(cfg_err_cpl_abort),                                                    // input wire cfg_err_cpl_abort
  .cfg_err_posted(cfg_err_posted),                                                          // input wire cfg_err_posted
  .cfg_err_cor(cfg_err_cor),                                                                // input wire cfg_err_cor
  .cfg_err_atomic_egress_blocked(cfg_err_atomic_egress_blocked),                            // input wire cfg_err_atomic_egress_blocked
  .cfg_err_internal_cor(cfg_err_internal_cor),                                              // input wire cfg_err_internal_cor
  .cfg_err_malformed(cfg_err_malformed),                                                    // input wire cfg_err_malformed
  .cfg_err_mc_blocked(cfg_err_mc_blocked),                                                  // input wire cfg_err_mc_blocked
  .cfg_err_poisoned(cfg_err_poisoned),                                                      // input wire cfg_err_poisoned
  .cfg_err_norecovery(cfg_err_norecovery),                                                  // input wire cfg_err_norecovery
  .cfg_err_tlp_cpl_header(cfg_err_tlp_cpl_header),                                          // input wire [47 : 0] cfg_err_tlp_cpl_header
  .cfg_err_cpl_rdy(cfg_err_cpl_rdy),                                                        // output wire cfg_err_cpl_rdy
  .cfg_err_locked(cfg_err_locked),                                                          // input wire cfg_err_locked
  .cfg_err_acs(cfg_err_acs),                                                                // input wire cfg_err_acs
  .cfg_err_internal_uncor(cfg_err_internal_uncor),                                          // input wire cfg_err_internal_uncor
  .cfg_trn_pending(cfg_trn_pending),                                                        // input wire cfg_trn_pending
  .cfg_pm_halt_aspm_l0s(cfg_pm_halt_aspm_l0s),                                              // input wire cfg_pm_halt_aspm_l0s
  .cfg_pm_halt_aspm_l1(cfg_pm_halt_aspm_l1),                                                // input wire cfg_pm_halt_aspm_l1
  .cfg_pm_force_state_en(cfg_pm_force_state_en),                                            // input wire cfg_pm_force_state_en
  .cfg_pm_force_state(cfg_pm_force_state),                                                  // input wire [1 : 0] cfg_pm_force_state
  .cfg_dsn(cfg_dsn),                                                                        // input wire [63 : 0] cfg_dsn
  .cfg_interrupt(cfg_interrupt),                                                            // input wire cfg_interrupt
  .cfg_interrupt_rdy(cfg_interrupt_rdy),                                                    // output wire cfg_interrupt_rdy
  .cfg_interrupt_assert(cfg_interrupt_assert),                                              // input wire cfg_interrupt_assert
  .cfg_interrupt_di(cfg_interrupt_di),                                                      // input wire [7 : 0] cfg_interrupt_di
  .cfg_interrupt_do(cfg_interrupt_do),                                                      // output wire [7 : 0] cfg_interrupt_do
  .cfg_interrupt_mmenable(cfg_interrupt_mmenable),                                          // output wire [2 : 0] cfg_interrupt_mmenable
  .cfg_interrupt_msienable(cfg_interrupt_msienable),                                        // output wire cfg_interrupt_msienable
  .cfg_interrupt_msixenable(cfg_interrupt_msixenable),                                      // output wire cfg_interrupt_msixenable
  .cfg_interrupt_msixfm(cfg_interrupt_msixfm),                                              // output wire cfg_interrupt_msixfm
  .cfg_interrupt_stat(cfg_interrupt_stat),                                                  // input wire cfg_interrupt_stat
  .cfg_pciecap_interrupt_msgnum(cfg_pciecap_interrupt_msgnum),                              // input wire [4 : 0] cfg_pciecap_interrupt_msgnum
  .cfg_to_turnoff(cfg_to_turnoff),                                                          // output wire cfg_to_turnoff
  .cfg_turnoff_ok(cfg_turnoff_ok),                                                          // input wire cfg_turnoff_ok
  .cfg_bus_number(cfg_bus_number),                                                          // output wire [7 : 0] cfg_bus_number
  .cfg_device_number(cfg_device_number),                                                    // output wire [4 : 0] cfg_device_number
  .cfg_function_number(cfg_function_number),                                                // output wire [2 : 0] cfg_function_number
  .cfg_pm_wake(cfg_pm_wake),                                                                // input wire cfg_pm_wake
  .cfg_pm_send_pme_to(cfg_pm_send_pme_to),                                                  // input wire cfg_pm_send_pme_to
  .cfg_ds_bus_number(cfg_ds_bus_number),                                                    // input wire [7 : 0] cfg_ds_bus_number
  .cfg_ds_device_number(cfg_ds_device_number),                                              // input wire [4 : 0] cfg_ds_device_number
  .cfg_ds_function_number(cfg_ds_function_number),                                          // input wire [2 : 0] cfg_ds_function_number
  .cfg_bridge_serr_en(cfg_bridge_serr_en),                                                  // output wire cfg_bridge_serr_en
  .cfg_slot_control_electromech_il_ctl_pulse(cfg_slot_control_electromech_il_ctl_pulse),    // output wire cfg_slot_control_electromech_il_ctl_pulse
  .cfg_root_control_syserr_corr_err_en(cfg_root_control_syserr_corr_err_en),                // output wire cfg_root_control_syserr_corr_err_en
  .cfg_root_control_syserr_non_fatal_err_en(cfg_root_control_syserr_non_fatal_err_en),      // output wire cfg_root_control_syserr_non_fatal_err_en
  .cfg_root_control_syserr_fatal_err_en(cfg_root_control_syserr_fatal_err_en),              // output wire cfg_root_control_syserr_fatal_err_en
  .cfg_root_control_pme_int_en(cfg_root_control_pme_int_en),                                // output wire cfg_root_control_pme_int_en
  .cfg_aer_rooterr_corr_err_reporting_en(cfg_aer_rooterr_corr_err_reporting_en),            // output wire cfg_aer_rooterr_corr_err_reporting_en
  .cfg_aer_rooterr_non_fatal_err_reporting_en(cfg_aer_rooterr_non_fatal_err_reporting_en),  // output wire cfg_aer_rooterr_non_fatal_err_reporting_en
  .cfg_aer_rooterr_fatal_err_reporting_en(cfg_aer_rooterr_fatal_err_reporting_en),          // output wire cfg_aer_rooterr_fatal_err_reporting_en
  .cfg_aer_rooterr_corr_err_received(cfg_aer_rooterr_corr_err_received),                    // output wire cfg_aer_rooterr_corr_err_received
  .cfg_aer_rooterr_non_fatal_err_received(cfg_aer_rooterr_non_fatal_err_received),          // output wire cfg_aer_rooterr_non_fatal_err_received
  .cfg_aer_rooterr_fatal_err_received(cfg_aer_rooterr_fatal_err_received),                  // output wire cfg_aer_rooterr_fatal_err_received
  .cfg_err_aer_headerlog(cfg_err_aer_headerlog),                                            // input wire [127 : 0] cfg_err_aer_headerlog
  .cfg_aer_interrupt_msgnum(cfg_aer_interrupt_msgnum),                                      // input wire [4 : 0] cfg_aer_interrupt_msgnum
  .cfg_err_aer_headerlog_set(cfg_err_aer_headerlog_set),                                    // output wire cfg_err_aer_headerlog_set
  .cfg_aer_ecrc_check_en(cfg_aer_ecrc_check_en),                                            // output wire cfg_aer_ecrc_check_en
  .cfg_aer_ecrc_gen_en(cfg_aer_ecrc_gen_en),                                                // output wire cfg_aer_ecrc_gen_en
  .cfg_vc_tcvc_map(cfg_vc_tcvc_map),                                                        // output wire [6 : 0] cfg_vc_tcvc_map
  .sys_clk(sys_clk),                                                                        // input wire sys_clk
  .sys_rst_n(sys_rst_n)                                                                     // input wire sys_rst_n
);

endmodule
