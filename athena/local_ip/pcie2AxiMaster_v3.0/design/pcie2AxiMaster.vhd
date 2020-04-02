-----------------------------------------------------------------------
-- $HeadURL: svn://brainstorm/fpga/trunk/Matrox/Imaging/FPGA/vmecpugp/mvb/design/pcie2vme.vhd $
-- $Author: amarchan $
-- $Revision: 17806 $
-- $Date: 2017-08-07 16:17:55 -0400 (Mon, 07 Aug 2017) $
--
-- DESCRIPTION: Top PCIe file for Artix7 variations.  Includes Xilinx A7 Endpoint
-- + user interface.
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.regfile_pcie2AxiMaster_pack.all;
use work.pciepack.all;


entity pcie2AxiMaster is
  generic(
    NUMB_IRQ              : integer range 0 to 64 := 8;
    PCIE_VENDOR_ID        : integer               := 16#102B#;
    PCIE_DEVICE_ID        : integer               := 16#0000#;
    PCIE_REV_ID           : integer               := 8#00#;
    PCIE_SUBSYS_VENDOR_ID : integer               := 16#102B#;
    PCIE_SUBSYS_ID        : integer               := 16#0000#;
    AXI_ID_WIDTH          : integer range 1 to 8  := 6;
    ENABLE_DMA            : integer range 0 to 1  := 0;
    ENABLE_MTX_SPI        : integer range 0 to 1  := 0;
    DEBUG_IN_WIDTH        : integer range 0 to 32 := 0;
    DEBUG_OUT_WIDTH       : integer range 0 to 32 := 0
    );
  port (
    ---------------------------------------------------------------------------
    -- PCIe FPGA IOs (100 MHz input clock)
    ---------------------------------------------------------------------------
    pcie_sys_rst_n : in  std_logic;
    pcie_sys_clk   : in  std_logic;
    pcie_rxp       : in  std_logic;
    pcie_rxn       : in  std_logic;
    pcie_txp       : out std_logic;
    pcie_txn       : out std_logic;

    ---------------------------------------------------------------------------
    --  FPGA Info
    ---------------------------------------------------------------------------
    fpga_build_id      : in std_logic_vector(31 downto 0) := (others => '0');
    fpga_major_ver     : in std_logic_vector(7 downto 0)  := (others => '0');
    fpga_minor_ver     : in std_logic_vector(7 downto 0)  := (others => '0');
    fpga_sub_minor_ver : in std_logic_vector(7 downto 0)  := (others => '0');
    fpga_firmware_type : in std_logic_vector(7 downto 0)  := (others => '0');
    fpga_device_id     : in std_logic_vector(7 downto 0)  := (others => '0');
    board_info         : in std_logic_vector(3 downto 0)  := (others => '0');

    ---------------------------------------------------------------------------
    --  Optional_debug signals
    ---------------------------------------------------------------------------
    debug_in  : in  std_logic_vector(DEBUG_IN_WIDTH-1 downto 0);
    debug_out : out std_logic_vector(DEBUG_OUT_WIDTH-1 downto 0);

    ---------------------------------------------------------------------------
    --  FPGA FLASH SPI user interface
    ---------------------------------------------------------------------------
    spi_cs_n  : out std_logic;
    spi_sdout : out std_logic;
    spi_sdin  : in  std_logic;

    ---------------------------------------------------------------------------
    -- TLP DMA interface
    ---------------------------------------------------------------------------
    tlp_req_to_send : in  std_logic := '0';
    tlp_grant       : out std_logic;

    tlp_fmt_type     : in std_logic_vector(6 downto 0) := (others => '0');  -- fmt and type field 
    tlp_length_in_dw : in std_logic_vector(9 downto 0) := (others => '0');

    tlp_src_rdy_n : in  std_logic                     := '0';
    tlp_dst_rdy_n : out std_logic;
    tlp_data      : in  std_logic_vector(63 downto 0) := (others => '0');

    -- for master request transmit
    tlp_address     : in std_logic_vector(63 downto 2) := (others => '0');
    tlp_ldwbe_fdwbe : in std_logic_vector(7 downto 0)  := (others => '0');

    -- for completion transmit
    tlp_attr           : in std_logic_vector(1 downto 0)  := (others => '0');  -- relaxed ordering, no snoop
    tlp_transaction_id : in std_logic_vector(23 downto 0) := (others => '0');  -- bus, device, function, tag
    tlp_byte_count     : in std_logic_vector(12 downto 0) := (others => '0');  -- byte count tenant compte des byte enables
    tlp_lower_address  : in std_logic_vector(6 downto 0)  := (others => '0');

    cfg_bus_mast_en : out std_logic;
    cfg_setmaxpld   : out std_logic_vector(2 downto 0);


    ---------------------------------------------------------------------------
    -- Interrupt interface
    ---------------------------------------------------------------------------
    irq_event : in std_logic_vector(NUMB_IRQ-1 downto 0);


    ---------------------------------------------------------------------------
    -- Clock
    ---------------------------------------------------------------------------
    axim_clk   : out std_logic;
    axim_rst_n : out std_logic;

    ---------------------------------------------------------------------------
    -- Write Address Channel
    ---------------------------------------------------------------------------
    axim_awready : in  std_logic;
    axim_awvalid : out std_logic;

    axim_awid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_awaddr  : out std_logic_vector(31 downto 0);
    axim_awlen   : out std_logic_vector(7 downto 0);
    axim_awsize  : out std_logic_vector(2 downto 0);
    axim_awburst : out std_logic_vector(1 downto 0);
    axim_awlock  : out std_logic;
    axim_awcache : out std_logic_vector(3 downto 0);
    axim_awprot  : out std_logic_vector(2 downto 0);
    axim_awqos   : out std_logic_vector(3 downto 0);


    ---------------------------------------------------------------------------
    -- Write Data Channel
    ---------------------------------------------------------------------------
    axim_wready : in  std_logic;
    axim_wvalid : out std_logic;
    axim_wid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_wdata  : out std_logic_vector(31 downto 0);
    axim_wstrb  : out std_logic_vector(3 downto 0);
    axim_wlast  : out std_logic;


    ---------------------------------------------------------------------------
    -- AXI Write response
    ---------------------------------------------------------------------------
    axim_bvalid : in  std_logic;
    axim_bready : out std_logic;
    axim_bid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_bresp  : in  std_logic_vector(1 downto 0);


    ---------------------------------------------------------------------------
    --  Read Address Channel
    ---------------------------------------------------------------------------
    axim_arready : in  std_logic;
    axim_arvalid : out std_logic;
    axim_arid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_araddr  : out std_logic_vector(31 downto 0);
    axim_arlen   : out std_logic_vector(7 downto 0);
    axim_arsize  : out std_logic_vector(2 downto 0);
    axim_arburst : out std_logic_vector(1 downto 0);
    axim_arlock  : out std_logic;
    axim_arcache : out std_logic_vector(3 downto 0);
    axim_arprot  : out std_logic_vector(2 downto 0);
    axim_arqos   : out std_logic_vector(3 downto 0);


    ---------------------------------------------------------------------------
    -- AXI Read data channel
    ---------------------------------------------------------------------------
    axim_rready : out std_logic;
    axim_rvalid : in  std_logic;
    axim_rid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axim_rdata  : in  std_logic_vector(31 downto 0);
    axim_rresp  : in  std_logic_vector(1 downto 0);
    axim_rlast  : in  std_logic
    );
end pcie2AxiMaster;


architecture struct of pcie2AxiMaster is

  constant C_DATA_WIDTH   : integer := 64;
  constant NB_PCIE_AGENTS : integer := 3 + ENABLE_DMA;  -- number of BAR agents + number of master agents
  constant DMA_AGENT_ID : integer := NB_PCIE_AGENTS-1;

  component spi_if is

    port (
      -----------------------------------------
      -- Clocks and reset
      -----------------------------------------
      sys_reset_n : in std_logic;
      sys_clk     : in std_logic;       -- register clock

      -----------------------------------------------------------------
      -- Flash interface
      -----------------------------------------------------------------
      spi_sdin  : in  std_logic;        -- data in
      spi_sdout : out std_logic;        -- data out
      spi_csN   : out std_logic;        -- chip select

      -----------------------------------------------------------------
      -- Flash interface without IOB
      -----------------------------------------------------------------
      spi_sdout_iob : out std_logic;    -- data out
      spi_sdout_ts  : out std_logic;    -- data out
      spi_csN_iob   : out std_logic;    -- chip select
      spi_csN_ts    : out std_logic;    -- chip select

      spi_sclk    : out std_logic;      -- clock
      spi_sclk_ts : out std_logic;      -- clock

      -----------------------------------------------------------------
      -- Registers 
      -----------------------------------------------------------------
      regfile : inout SPI_TYPE := INIT_SPI_TYPE

      );
  end component;


  ---------------------------------------------------------------------------
  --  Xilinx A7 PCIe core
  ---------------------------------------------------------------------------
  --component pcie_7x_0
  component pcie_7x_0_mtx_wrapper
    generic (
      CFG_VEND_ID        : integer := 16#102b#;
      CFG_DEV_ID         : integer := 16#FFFF#;
      CFG_REV_ID         : integer := 16#FF#;
      CFG_SUBSYS_VEND_ID : integer := 16#102b#;
      CFG_SUBSYS_ID      : integer := 16#FFFF#
      );
    port (
      pci_exp_txp                                : out std_logic_vector(0 downto 0);
      pci_exp_txn                                : out std_logic_vector(0 downto 0);
      pci_exp_rxp                                : in  std_logic_vector(0 downto 0);
      pci_exp_rxn                                : in  std_logic_vector(0 downto 0);
      user_clk_out                               : out std_logic;
      user_reset_out                             : out std_logic;
      user_lnk_up                                : out std_logic;
      user_app_rdy                               : out std_logic;
      tx_buf_av                                  : out std_logic_vector(5 downto 0);
      tx_cfg_req                                 : out std_logic;
      tx_err_drop                                : out std_logic;
      s_axis_tx_tready                           : out std_logic;
      s_axis_tx_tdata                            : in  std_logic_vector(63 downto 0);
      s_axis_tx_tkeep                            : in  std_logic_vector(7 downto 0);
      s_axis_tx_tlast                            : in  std_logic;
      s_axis_tx_tvalid                           : in  std_logic;
      s_axis_tx_tuser                            : in  std_logic_vector(3 downto 0);
      tx_cfg_gnt                                 : in  std_logic;
      m_axis_rx_tdata                            : out std_logic_vector(63 downto 0);
      m_axis_rx_tkeep                            : out std_logic_vector(7 downto 0);
      m_axis_rx_tlast                            : out std_logic;
      m_axis_rx_tvalid                           : out std_logic;
      m_axis_rx_tready                           : in  std_logic;
      m_axis_rx_tuser                            : out std_logic_vector(21 downto 0);
      rx_np_ok                                   : in  std_logic;
      rx_np_req                                  : in  std_logic;
      -- cfg_mgmt_do                                : out std_logic_vector(31 downto 0);
      -- cfg_mgmt_rd_wr_done                        : out std_logic;
      cfg_status                                 : out std_logic_vector(15 downto 0);
      cfg_command                                : out std_logic_vector(15 downto 0);
      cfg_dstatus                                : out std_logic_vector(15 downto 0);
      cfg_dcommand                               : out std_logic_vector(15 downto 0);
      cfg_lstatus                                : out std_logic_vector(15 downto 0);
      cfg_lcommand                               : out std_logic_vector(15 downto 0);
      cfg_dcommand2                              : out std_logic_vector(15 downto 0);
      cfg_pcie_link_state                        : out std_logic_vector(2 downto 0);
      cfg_pmcsr_pme_en                           : out std_logic;
      cfg_pmcsr_powerstate                       : out std_logic_vector(1 downto 0);
      cfg_pmcsr_pme_status                       : out std_logic;
      cfg_received_func_lvl_rst                  : out std_logic;
      -- cfg_mgmt_di                                : in  std_logic_vector(31 downto 0);
      -- cfg_mgmt_byte_en                           : in  std_logic_vector(3 downto 0);
      -- cfg_mgmt_dwaddr                            : in  std_logic_vector(9 downto 0);
      -- cfg_mgmt_wr_en                             : in  std_logic;
      -- cfg_mgmt_rd_en                             : in  std_logic;
      -- cfg_mgmt_wr_readonly                       : in  std_logic;
      cfg_err_ecrc                               : in  std_logic;
      cfg_err_ur                                 : in  std_logic;
      cfg_err_cpl_timeout                        : in  std_logic;
      cfg_err_cpl_unexpect                       : in  std_logic;
      cfg_err_cpl_abort                          : in  std_logic;
      cfg_err_posted                             : in  std_logic;
      cfg_err_cor                                : in  std_logic;
      cfg_err_atomic_egress_blocked              : in  std_logic;
      cfg_err_internal_cor                       : in  std_logic;
      cfg_err_malformed                          : in  std_logic;
      cfg_err_mc_blocked                         : in  std_logic;
      cfg_err_poisoned                           : in  std_logic;
      cfg_err_norecovery                         : in  std_logic;
      cfg_err_tlp_cpl_header                     : in  std_logic_vector(47 downto 0);
      cfg_err_cpl_rdy                            : out std_logic;
      cfg_err_locked                             : in  std_logic;
      cfg_err_acs                                : in  std_logic;
      cfg_err_internal_uncor                     : in  std_logic;
      cfg_trn_pending                            : in  std_logic;
      cfg_pm_halt_aspm_l0s                       : in  std_logic;
      cfg_pm_halt_aspm_l1                        : in  std_logic;
      cfg_pm_force_state_en                      : in  std_logic;
      cfg_pm_force_state                         : in  std_logic_vector(1 downto 0);
      cfg_dsn                                    : in  std_logic_vector(63 downto 0);
      cfg_interrupt                              : in  std_logic;
      cfg_interrupt_rdy                          : out std_logic;
      cfg_interrupt_assert                       : in  std_logic;
      cfg_interrupt_di                           : in  std_logic_vector(7 downto 0);
      cfg_interrupt_do                           : out std_logic_vector(7 downto 0);
      cfg_interrupt_mmenable                     : out std_logic_vector(2 downto 0);
      cfg_interrupt_msienable                    : out std_logic;
      cfg_interrupt_msixenable                   : out std_logic;
      cfg_interrupt_msixfm                       : out std_logic;
      cfg_interrupt_stat                         : in  std_logic;
      cfg_pciecap_interrupt_msgnum               : in  std_logic_vector(4 downto 0);
      cfg_to_turnoff                             : out std_logic;
      cfg_turnoff_ok                             : in  std_logic;
      cfg_bus_number                             : out std_logic_vector(7 downto 0);
      cfg_device_number                          : out std_logic_vector(4 downto 0);
      cfg_function_number                        : out std_logic_vector(2 downto 0);
      cfg_pm_wake                                : in  std_logic;
      cfg_pm_send_pme_to                         : in  std_logic;
      cfg_ds_bus_number                          : in  std_logic_vector(7 downto 0);
      cfg_ds_device_number                       : in  std_logic_vector(4 downto 0);
      cfg_ds_function_number                     : in  std_logic_vector(2 downto 0);
      --     cfg_mgmt_wr_rw1c_as_rw                     : in  std_logic;
      cfg_bridge_serr_en                         : out std_logic;
      cfg_slot_control_electromech_il_ctl_pulse  : out std_logic;
      cfg_root_control_syserr_corr_err_en        : out std_logic;
      cfg_root_control_syserr_non_fatal_err_en   : out std_logic;
      cfg_root_control_syserr_fatal_err_en       : out std_logic;
      cfg_root_control_pme_int_en                : out std_logic;
      cfg_aer_rooterr_corr_err_reporting_en      : out std_logic;
      cfg_aer_rooterr_non_fatal_err_reporting_en : out std_logic;
      cfg_aer_rooterr_fatal_err_reporting_en     : out std_logic;
      cfg_aer_rooterr_corr_err_received          : out std_logic;
      cfg_aer_rooterr_non_fatal_err_received     : out std_logic;
      cfg_aer_rooterr_fatal_err_received         : out std_logic;
      cfg_err_aer_headerlog                      : in  std_logic_vector(127 downto 0);
      cfg_aer_interrupt_msgnum                   : in  std_logic_vector(4 downto 0);
      cfg_err_aer_headerlog_set                  : out std_logic;
      cfg_aer_ecrc_check_en                      : out std_logic;
      cfg_aer_ecrc_gen_en                        : out std_logic;
      cfg_vc_tcvc_map                            : out std_logic_vector(6 downto 0);
      sys_clk                                    : in  std_logic;
      sys_rst_n                                  : in  std_logic
      );
  end component;


  component pcie_tx_axi is
    generic(
      NB_PCIE_AGENTS  : integer := 3;
      AGENT_IS_64_BIT : std_logic_vector;  -- l'item 0 DOIT etre a droite.
      C_DATA_WIDTH    : integer := 64
      );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- Transaction layer AXI interface
      ---------------------------------------------------------------------

      s_axis_tx_tready : in  std_logic;
      s_axis_tx_tdata  : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      s_axis_tx_tkeep  : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      s_axis_tx_tlast  : out std_logic;
      s_axis_tx_tvalid : out std_logic;
      s_axis_tx_tuser  : out std_logic_vector(3 downto 0);

      ---------------------------------------------------------------------
      -- Config information
      ---------------------------------------------------------------------
      cfg_bus_number    : in std_logic_vector(7 downto 0);
      cfg_device_number : in std_logic_vector(4 downto 0);
      cfg_no_snoop_en   : in std_logic;
      cfg_relax_ord_en  : in std_logic;

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_grant       : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);

      tlp_out_fmt_type     : in FMT_TYPE_ARRAY(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_length_in_dw : in LENGTH_DW_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      tlp_out_src_rdy_n : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_dst_rdy_n : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_data      : in  PCIE_DATA_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      -- for master request transmit
      tlp_out_address     : in PCIE_ADDRESS_ARRAY(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_ldwbe_fdwbe : in LDWBE_FDWBE_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      -- for completion transmit
      tlp_out_attr           : in ATTRIB_VECTOR(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_transaction_id : in TRANS_ID(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_byte_count     : in BYTE_COUNT_ARRAY(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_lower_address  : in LOWER_ADDR_ARRAY(NB_PCIE_AGENTS-1 downto 0)
      );
  end component;


  component pcie_rx_axi is
    generic(
      NB_PCIE_AGENTS : integer := 3;
      --AGENT_TO_BAR   : integer_vector(NB_PCIE_AGENTS-1 downto 0);
      AGENT_TO_BAR   : integer_vector;
      C_DATA_WIDTH   : integer := 64  -- pour l'instant le code est HARDCODE a 64 bits.
      );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;
      user_lnk_up : in std_logic;

      ---------------------------------------------------------------------
      -- Transaction layer AXI receive interface
      ---------------------------------------------------------------------
      -- RX
      m_axis_rx_tdata  : in  std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      m_axis_rx_tkeep  : in  std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      m_axis_rx_tlast  : in  std_logic;
      m_axis_rx_tvalid : in  std_logic;
      m_axis_rx_tready : out std_logic;
      m_axis_rx_tuser  : in  std_logic_vector(21 downto 0);
      rx_np_ok         : out std_logic;
      rx_np_req        : out std_logic;

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------

      tlp_in_accept_data : in std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_in_abort       : in std_logic_vector(NB_PCIE_AGENTS-1 downto 0);

      tlp_in_fmt_type       : out std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet
      tlp_in_address        : out std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
      tlp_in_length_in_dw   : out std_logic_vector(10 downto 0);  -- valeur maximal 4k
      tlp_in_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_in_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_in_valid          : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_in_data           : out std_logic_vector(31 downto 0);
      tlp_in_byte_en        : out std_logic_vector(3 downto 0);
      tlp_in_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables

      ---------------------------------------------------------------------
      -- Error detection
      ---------------------------------------------------------------------
      cfg_err_cpl_unexpect   : out std_logic;
      cfg_err_posted         : out std_logic;
      cfg_err_malformed      : out std_logic;
      cfg_err_ur             : out std_logic;
      cfg_err_cpl_abort      : out std_logic;
      cfg_err_tlp_cpl_header : out std_logic_vector(47 downto 0);
      cfg_err_cpl_rdy        : in  std_logic;  -- on devrait latcher les erreurs jusqu'a ce qu'on recoive le ready
      cfg_err_locked         : out std_logic
      );
  end component;


  component pcie_irq_axi is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk   : in std_logic;
      sys_reset : in std_logic;

      ---------------------------------------------------------------------
      -- Interrupt
      ---------------------------------------------------------------------
      int_status : in  std_logic_vector;
      msi_req    : in  std_logic_vector;  -- pour envoyer un MSI, 1 bit par vecteur
      msi_ack    : out std_logic_vector;  -- confirmer l'envoie du MSI

      ---------------------------------------------------------------------
      -- PCIe core management interface
      ---------------------------------------------------------------------
      cfg_mgmt_do         : in std_logic_vector(31 downto 0);
      cfg_mgmt_rd_wr_done : in std_logic;

      cfg_mgmt_di          : out    std_logic_vector(31 downto 0);
      cfg_mgmt_byte_en     : out    std_logic_vector(3 downto 0);
      cfg_mgmt_dwaddr      : out    std_logic_vector(9 downto 0);
      cfg_mgmt_wr_en       : buffer std_logic;
      cfg_mgmt_rd_en       : buffer std_logic;
      cfg_mgmt_wr_readonly : buffer std_logic;  -- on en a pas besoin, pour l'instant?

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_rdy        : in std_logic;
      cfg_interrupt_msienable  : in std_logic;
      cfg_interrupt_mmenable   : in std_logic_vector(2 downto 0);
      cfg_interrupt_msixenable : in std_logic;

      cfg_interrupt        : out std_logic;
      cfg_interrupt_di     : out std_logic_vector(7 downto 0);
      cfg_interrupt_assert : out std_logic
      );
  end component;


  component pcie_int_queue is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk   : in std_logic;
      sys_reset : in std_logic;

      ---------------------------------------------------------------------
      -- Interrupt IN
      ---------------------------------------------------------------------
      int_status : in std_logic_vector;  -- pour les interrupt classique seulement
      int_event  : in std_logic_vector;  -- pour envoyer un MSI, 1 bit par vecteur

      ---------------------------------------------------------------------
      -- single interrupt OUT
      ---------------------------------------------------------------------
      queue_int_out : out std_logic;
      msi_req       : out std_logic;
      msi_ack       : in  std_logic;

      regfile : in INTERRUPT_QUEUE_TYPE;  -- definit dans int_queue_pak

      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send : out std_logic;
      tlp_out_grant       : in  std_logic;

      tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field
      tlp_out_length_in_dw : out std_logic_vector(9 downto 0);
      tlp_out_attr         : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop

      tlp_out_src_rdy_n : out std_logic;
      tlp_out_dst_rdy_n : in  std_logic;
      tlp_out_data      : out std_logic_vector(63 downto 0);

      -- for master request transmit
      tlp_out_address     : out std_logic_vector(63 downto 2);
      tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
      tlp_out_lower_address  : out std_logic_vector(6 downto 0);

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_msienable  : in std_logic;
      cfg_interrupt_msixenable : in std_logic

      );
  end component;


  component tlp_to_axi_master is
    generic (
      BAR_ADDR_WIDTH : integer range 10 to 30 := 25;
      AXI_ID_WIDTH   : integer range 1 to 8   := 6
      );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------
      tlp_in_valid       : in  std_logic;
      tlp_in_abort       : out std_logic;
      tlp_in_accept_data : out std_logic;

      tlp_in_fmt_type       : in std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet
      tlp_in_address        : in std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
      tlp_in_length_in_dw   : in std_logic_vector(10 downto 0);
      tlp_in_attr           : in std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_in_transaction_id : in std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_in_data           : in std_logic_vector(31 downto 0);
      tlp_in_byte_en        : in std_logic_vector(3 downto 0);
      tlp_in_byte_count     : in std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send : out std_logic;
      tlp_out_grant       : in  std_logic;

      tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field
      tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

      tlp_out_src_rdy_n : out std_logic;
      tlp_out_dst_rdy_n : in  std_logic;
      tlp_out_data      : out std_logic_vector(31 downto 0);

      -- for master request transmit
      tlp_out_address     : out std_logic_vector(63 downto 2);
      tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
      tlp_out_lower_address  : out std_logic_vector(6 downto 0);

      -- TLP Status
      tlp_timeout_value    : in  std_logic_vector(31 downto 0);
      tlp_abort_cntr_init  : in  std_logic;
      tlp_abort_cntr_value : out std_logic_vector(30 downto 0);

      ---------------------------------------------------------------------------
      -- AXI windowing
      ---------------------------------------------------------------------------
      axi_window : inout AXI_WINDOW_TYPE_array := INIT_AXI_WINDOW_TYPE_array;

      ---------------------------------------------------------------------------
      -- Write Address Channel
      ---------------------------------------------------------------------------
      axim_awready : in  std_logic;
      axim_awvalid : out std_logic;

      axim_awid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axim_awaddr  : out std_logic_vector(31 downto 0);
      axim_awlen   : out std_logic_vector(7 downto 0);
      axim_awsize  : out std_logic_vector(2 downto 0);
      axim_awburst : out std_logic_vector(1 downto 0);
      axim_awlock  : out std_logic;
      axim_awcache : out std_logic_vector(3 downto 0);
      axim_awprot  : out std_logic_vector(2 downto 0);
      axim_awqos   : out std_logic_vector(3 downto 0);


      ---------------------------------------------------------------------------
      -- Write Data Channel
      ---------------------------------------------------------------------------
      axim_wready : in  std_logic;
      axim_wvalid : out std_logic;
      axim_wid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axim_wdata  : out std_logic_vector(31 downto 0);
      axim_wstrb  : out std_logic_vector(3 downto 0);
      axim_wlast  : out std_logic;


      ---------------------------------------------------------------------------
      -- AXI Write response
      ---------------------------------------------------------------------------
      axim_bvalid : in  std_logic;
      axim_bready : out std_logic;
      axim_bid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axim_bresp  : in  std_logic_vector(1 downto 0);


      ---------------------------------------------------------------------------
      --  Read Address Channel
      ---------------------------------------------------------------------------
      axim_arready : in  std_logic;
      axim_arvalid : out std_logic;
      axim_arid    : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axim_araddr  : out std_logic_vector(31 downto 0);
      axim_arlen   : out std_logic_vector(7 downto 0);
      axim_arsize  : out std_logic_vector(2 downto 0);
      axim_arburst : out std_logic_vector(1 downto 0);
      axim_arlock  : out std_logic;
      axim_arcache : out std_logic_vector(3 downto 0);
      axim_arprot  : out std_logic_vector(2 downto 0);
      axim_arqos   : out std_logic_vector(3 downto 0);


      ---------------------------------------------------------------------------
      -- AXI Read data channel
      ---------------------------------------------------------------------------
      axim_rready : out std_logic;
      axim_rvalid : in  std_logic;
      axim_rid    : in  std_logic_vector(AXI_ID_WIDTH-1 downto 0);
      axim_rdata  : in  std_logic_vector(31 downto 0);
      axim_rresp  : in  std_logic_vector(1 downto 0);
      axim_rlast  : in  std_logic
      );
  end component;


  component pcie_reg is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     : in std_logic;
      sys_reset_n : in std_logic;

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------

      tlp_in_accept_data : out std_logic;

      tlp_in_fmt_type       : in std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet 
      tlp_in_address        : in std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
      tlp_in_length_in_dw   : in std_logic_vector(10 downto 0);
      tlp_in_attr           : in std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_in_transaction_id : in std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_in_valid          : in std_logic;
      tlp_in_data           : in std_logic_vector(31 downto 0);
      tlp_in_byte_en        : in std_logic_vector(3 downto 0);
      tlp_in_byte_count     : in std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables

      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send : out std_logic;
      tlp_out_grant       : in  std_logic;

      tlp_out_fmt_type     : out std_logic_vector(6 downto 0);  -- fmt and type field 
      tlp_out_length_in_dw : out std_logic_vector(9 downto 0);

      tlp_out_src_rdy_n : out std_logic;
      tlp_out_dst_rdy_n : in  std_logic;
      tlp_out_data      : out std_logic_vector(31 downto 0);

      -- for master request transmit
      tlp_out_address     : out std_logic_vector(63 downto 2);
      tlp_out_ldwbe_fdwbe : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_attr           : out std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
      tlp_out_transaction_id : out std_logic_vector(23 downto 0);  -- bus, device, function, tag
      tlp_out_byte_count     : out std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
      tlp_out_lower_address  : out std_logic_vector(6 downto 0);

      ---------------------------------------------------------------------
      -- PCIe Register FIFO error detection
      ---------------------------------------------------------------------
      RESET_STR_REG_ERR : in std_logic;

      reg_fifo_ovr : out std_logic;
      reg_fifo_und : out std_logic;

      ---------------------------------------------------------------------
      -- Memory Register file interface
      ---------------------------------------------------------------------
      reg_readdata      : in std_logic_vector(31 downto 0);
      reg_readdatavalid : in std_logic;

      reg_addr      : out std_logic_vector;  --(REG_ADDRMSB downto REG_ADDRLSB);
      reg_read      : out std_logic;
      reg_write     : out std_logic;
      reg_beN       : out std_logic_vector(3 downto 0);
      reg_writedata : out std_logic_vector(31 downto 0)
      );
  end component;



  component regfile_pcie2AxiMaster is
    port (
      resetN        : in    std_logic;  -- System reset
      sysclk        : in    std_logic;  -- System clock
      regfile       : inout REGFILE_PCIE2AXIMASTER_TYPE := INIT_REGFILE_PCIE2AXIMASTER_TYPE;  -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;  -- Read
      reg_write     : in    std_logic;  -- Write
      reg_addr      : in    std_logic_vector(9 downto 2);   -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);   -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);  -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)   -- Read data
      );
  end component;

  ---------------------------------------------------------------------------
  --  Xilinx PCIe core
  ---------------------------------------------------------------------------
  attribute mark_debug : string;
  constant PCI_BAR0    : integer   := 0;
  constant PCI_BAR2    : integer   := 2;
  constant NO_PCI_BAR  : integer   := 7;
  constant YES         : std_logic := '1';
  constant NO          : std_logic := '0';

  -- BAR Address Bus Width mapping (in bits)
  constant BAR0_8MB  : integer := 23;
  constant BAR0_16MB : integer := 24;
  constant BAR0_32MB : integer := 25;
  constant BAR0_64MB : integer := 26;

  signal sys_reset   : std_logic;
  signal sys_reset_n : std_logic;
  signal sys_clk     : std_logic;

  ---------------------------------------------------------------------------
  --  Xilinx PCIe core
  ---------------------------------------------------------------------------
  signal pci_exp_txp                                : std_logic_vector(0 downto 0);
  signal pci_exp_txn                                : std_logic_vector(0 downto 0);
  signal pci_exp_rxp                                : std_logic_vector(0 downto 0);
  signal pci_exp_rxn                                : std_logic_vector(0 downto 0);
  signal user_lnk_up                                : std_logic;
  signal user_app_rdy                               : std_logic;
  signal tx_buf_av                                  : std_logic_vector(5 downto 0);
  signal tx_cfg_req                                 : std_logic;
  signal tx_err_drop                                : std_logic;
  signal s_axis_tx_tready                           : std_logic;
  signal s_axis_tx_tdata                            : std_logic_vector(63 downto 0);
  signal s_axis_tx_tkeep                            : std_logic_vector(7 downto 0);
  signal s_axis_tx_tlast                            : std_logic;
  signal s_axis_tx_tvalid                           : std_logic;
  signal s_axis_tx_tuser                            : std_logic_vector(3 downto 0);
  signal tx_cfg_gnt                                 : std_logic;
  signal m_axis_rx_tdata                            : std_logic_vector(63 downto 0);
  signal m_axis_rx_tkeep                            : std_logic_vector(7 downto 0);
  signal m_axis_rx_tlast                            : std_logic;
  signal m_axis_rx_tvalid                           : std_logic;
  signal m_axis_rx_tready                           : std_logic;
  signal m_axis_rx_tuser                            : std_logic_vector(21 downto 0);
  signal rx_np_ok                                   : std_logic;
  signal rx_np_req                                  : std_logic;
  -- signal cfg_mgmt_do                                : std_logic_vector(31 downto 0);
  -- signal cfg_mgmt_rd_wr_done                        : std_logic;
  signal cfg_status                                 : std_logic_vector(15 downto 0);
  signal cfg_command                                : std_logic_vector(15 downto 0);
  signal cfg_dstatus                                : std_logic_vector(15 downto 0);
  signal cfg_dcommand                               : std_logic_vector(15 downto 0);
  signal cfg_lstatus                                : std_logic_vector(15 downto 0);
  signal cfg_lcommand                               : std_logic_vector(15 downto 0);
  signal cfg_dcommand2                              : std_logic_vector(15 downto 0);
  signal cfg_pcie_link_state                        : std_logic_vector(2 downto 0);
  signal cfg_pmcsr_pme_en                           : std_logic;
  signal cfg_pmcsr_powerstate                       : std_logic_vector(1 downto 0);
  signal cfg_pmcsr_pme_status                       : std_logic;
  signal cfg_received_func_lvl_rst                  : std_logic;
  -- signal cfg_mgmt_di                                : std_logic_vector(31 downto 0);
  -- signal cfg_mgmt_byte_en                           : std_logic_vector(3 downto 0);
  -- signal cfg_mgmt_dwaddr                            : std_logic_vector(9 downto 0);
  -- signal cfg_mgmt_wr_en                             : std_logic;
  -- signal cfg_mgmt_rd_en                             : std_logic;
  -- signal cfg_mgmt_wr_readonly                       : std_logic;
  signal cfg_err_ecrc                               : std_logic;
  signal cfg_err_ur                                 : std_logic;
  signal cfg_err_cpl_timeout                        : std_logic;
  signal cfg_err_cpl_unexpect                       : std_logic;
  signal cfg_err_cpl_abort                          : std_logic;
  signal cfg_err_posted                             : std_logic;
  signal cfg_err_cor                                : std_logic;
  signal cfg_err_atomic_egress_blocked              : std_logic;
  signal cfg_err_internal_cor                       : std_logic;
  signal cfg_err_malformed                          : std_logic;
  signal cfg_err_mc_blocked                         : std_logic;
  signal cfg_err_poisoned                           : std_logic;
  signal cfg_err_norecovery                         : std_logic;
  signal cfg_err_tlp_cpl_header                     : std_logic_vector(47 downto 0);
  signal cfg_err_cpl_rdy                            : std_logic;
  signal cfg_err_locked                             : std_logic;
  signal cfg_err_acs                                : std_logic;
  signal cfg_err_internal_uncor                     : std_logic;
  signal cfg_trn_pending                            : std_logic;
  signal cfg_pm_halt_aspm_l0s                       : std_logic;
  signal cfg_pm_halt_aspm_l1                        : std_logic;
  signal cfg_pm_force_state_en                      : std_logic;
  signal cfg_pm_force_state                         : std_logic_vector(1 downto 0);
  signal cfg_dsn                                    : std_logic_vector(63 downto 0);
  signal cfg_interrupt                              : std_logic;
  signal cfg_interrupt_rdy                          : std_logic;
  signal cfg_interrupt_assert                       : std_logic;
  signal cfg_interrupt_di                           : std_logic_vector(7 downto 0);
  signal cfg_interrupt_do                           : std_logic_vector(7 downto 0);
  signal cfg_interrupt_mmenable                     : std_logic_vector(2 downto 0);
  signal cfg_interrupt_msienable                    : std_logic;
  signal cfg_interrupt_msixenable                   : std_logic;
  signal cfg_interrupt_msixfm                       : std_logic;
  signal cfg_interrupt_stat                         : std_logic;
  signal cfg_pciecap_interrupt_msgnum               : std_logic_vector(4 downto 0);
  signal cfg_to_turnoff                             : std_logic;
  signal cfg_turnoff_ok                             : std_logic;
  signal cfg_bus_number                             : std_logic_vector(7 downto 0);
  signal cfg_device_number                          : std_logic_vector(4 downto 0);
  signal cfg_function_number                        : std_logic_vector(2 downto 0);
  signal cfg_pm_wake                                : std_logic;
  signal cfg_pm_send_pme_to                         : std_logic;
  signal cfg_ds_bus_number                          : std_logic_vector(7 downto 0);
  signal cfg_ds_device_number                       : std_logic_vector(4 downto 0);
  signal cfg_ds_function_number                     : std_logic_vector(2 downto 0);
  signal cfg_mgmt_wr_rw1c_as_rw                     : std_logic;
  signal cfg_bridge_serr_en                         : std_logic;
  signal cfg_slot_control_electromech_il_ctl_pulse  : std_logic;
  signal cfg_root_control_syserr_corr_err_en        : std_logic;
  signal cfg_root_control_syserr_non_fatal_err_en   : std_logic;
  signal cfg_root_control_syserr_fatal_err_en       : std_logic;
  signal cfg_root_control_pme_int_en                : std_logic;
  signal cfg_aer_rooterr_corr_err_reporting_en      : std_logic;
  signal cfg_aer_rooterr_non_fatal_err_reporting_en : std_logic;
  signal cfg_aer_rooterr_fatal_err_reporting_en     : std_logic;
  signal cfg_aer_rooterr_corr_err_received          : std_logic;
  signal cfg_aer_rooterr_non_fatal_err_received     : std_logic;
  signal cfg_aer_rooterr_fatal_err_received         : std_logic;
  signal cfg_err_aer_headerlog                      : std_logic_vector(127 downto 0);
  signal cfg_aer_interrupt_msgnum                   : std_logic_vector(4 downto 0);
  signal cfg_err_aer_headerlog_set                  : std_logic;
  signal cfg_aer_ecrc_check_en                      : std_logic;
  signal cfg_aer_ecrc_gen_en                        : std_logic;
  signal cfg_vc_tcvc_map                            : std_logic_vector(6 downto 0);


  ---------------------------------------------------------------------
  -- DMA - PCIe interface
  ---------------------------------------------------------------------
  signal cfg_no_snoop_en  : std_logic;
  signal cfg_relax_ord_en : std_logic;

  ------------------------------
  -- nouvel interface interne --
  ------------------------------
  signal tlp_in_abort          : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_in_valid          : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_in_accept_data    : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '0');
  signal tlp_in_address        : std_logic_vector(31 downto 0);  -- 2 LSB a decoded from byte enables
  signal tlp_in_length_in_dw   : std_logic_vector(10 downto 0);
  signal tlp_in_byte_count     : std_logic_vector(12 downto 0);  -- byte count tenant compte des byte enables
  signal tlp_in_fmt_type       : std_logic_vector(6 downto 0);  -- fmt and type field from decoded packet
  signal tlp_in_attr           : std_logic_vector(1 downto 0);  -- relaxed ordering, no snoop
  signal tlp_in_transaction_id : std_logic_vector(23 downto 0);  -- bus, device, function, tag
  signal tlp_in_byte_en        : std_logic_vector(3 downto 0);
  signal tlp_in_data           : std_logic_vector(31 downto 0);


  signal tlp_out_req_to_send    : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '0');
  signal tlp_out_grant          : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_out_fmt_type       : FMT_TYPE_ARRAY(NB_PCIE_AGENTS-1 downto 0);  -- fmt and type field
  signal tlp_out_length_in_dw   : LENGTH_DW_ARRAY(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_out_src_rdy_n      : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '1');
  signal tlp_out_dst_rdy_n      : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_out_data           : PCIE_DATA_ARRAY(NB_PCIE_AGENTS-1 downto 0);
  -- for master request transmit
  signal tlp_out_address        : PCIE_ADDRESS_ARRAY(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_out_ldwbe_fdwbe    : LDWBE_FDWBE_ARRAY(NB_PCIE_AGENTS-1 downto 0);
  -- for completion transmit
  signal tlp_out_attr           : ATTRIB_VECTOR(NB_PCIE_AGENTS-1 downto 0);  -- relaxed ordering, no snoop
  signal tlp_out_transaction_id : TRANS_ID(NB_PCIE_AGENTS-1 downto 0);  -- bus, device, function, tag
  signal tlp_out_byte_count     : BYTE_COUNT_ARRAY(NB_PCIE_AGENTS-1 downto 0);  -- byte count tenant compte des byte enables
  signal tlp_out_lower_address  : LOWER_ADDR_ARRAY(NB_PCIE_AGENTS-1 downto 0);


  signal int_status       : std_logic_vector(63 downto 0) := (others => '0');
  signal int_event        : std_logic_vector(63 downto 0) := (others => '0');
  signal irq_event_Meta   : std_logic_vector(63 downto 0) := (others => '0');
  signal irq_event_resync : std_logic_vector(63 downto 0) := (others => '0');
  signal msi_req          : std_logic_vector(0 downto 0);
  signal msi_ack          : std_logic_vector(0 downto 0);
  signal queue_irq        : std_logic_vector(0 downto 0);  -- pour les interrupt classique seulement

  signal msi_req_masked   : std_logic_vector(0 downto 0);
  signal queue_irq_masked : std_logic_vector(0 downto 0);  -- pour les interrupt classique seulement


  signal reg_read          : std_logic;                      -- Read
  signal reg_write         : std_logic;                      -- Write
  signal reg_addr          : std_logic_vector(9 downto 2);   -- Address
  signal reg_beN           : std_logic_vector(3 downto 0);   -- Byte enable
  signal reg_writedata     : std_logic_vector(31 downto 0);  -- Write data
  signal reg_readdata      : std_logic_vector(31 downto 0);  -- Read data
  signal reg_readdatavalid : std_logic;
  signal regfile           : REGFILE_PCIE2AXIMASTER_TYPE := INIT_REGFILE_PCIE2AXIMASTER_TYPE;  -- Register file

  signal spi_sclk_startupe2    : std_logic;
  signal spi_sclk_ts_startupe2 : std_logic;

  signal debug_in_sig_meta : std_logic_vector(31 downto 0) := (others => '0');
  signal debug_in_sig      : std_logic_vector(31 downto 0) := (others => '0');
  signal debug_out_sig     : std_logic_vector(31 downto 0) := (others => '0');


begin


  tlp_in_abort(1) <= '0';
  tlp_in_abort(2) <= '0';

  -- Derived from pcie_sys_rst_n
  sys_reset_n <= not sys_reset;

  cfg_no_snoop_en  <= cfg_dcommand(11);
  cfg_relax_ord_en <= cfg_dcommand(4);

  -- cfg_no_snoop_en  <= '0';
  -- cfg_relax_ord_en <= '0';

  axim_clk   <= sys_clk;
  axim_rst_n <= sys_reset_n;

  ---------------------------------------------------------------
  --
  --  SPI CORE
  --
  ---------------------------------------------------------------
  xspi_if : spi_if
    port map(
      -----------------------------------------
      -- Clocks and reset
      -----------------------------------------
      sys_reset_n => sys_reset_n,
      sys_clk     => sys_clk,

      -----------------------------------------------------------------
      -- Flash interface
      -----------------------------------------------------------------
      spi_sclk    => spi_sclk_startupe2,
      spi_sclk_ts => spi_sclk_ts_startupe2,
      spi_sdin    => spi_sdin,
      spi_sdout   => spi_sdout,
      spi_csN     => spi_cs_n,

      -----------------------------------------------------------------
      -- Registers 
      -----------------------------------------------------------------
      regfile => regfile.spi
      );

  -----------------------------------------------------------------
  -- Pour la synthese
  -----------------------------------------------------------------
  startupe2_inst : startupe2
    generic map (PROG_USR      => "FALSE",
                 SIM_CCLK_FREQ => 0.0
                 )
    port map (
      CFGCLK    => open,
      CFGMCLK   => open,
      EOS       => open,
      PREQ      => open,
      CLK       => '0',
      GSR       => '0',
      GTS       => '0',
      KEYCLEARB => '0',
      PACK      => '0',
      USRCCLKO  => spi_sclk_startupe2,
      USRCCLKTS => spi_sclk_ts_startupe2,
      USRDONEO  => '1',
      USRDONETS => '1'
      );


  -- synthesis translate_off
  P_drocheckprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      assert tx_err_drop = '0' report "SIGNAL TX_ERR_DROP VENANT DU PCIe ACTIF. C'EST UNE SITUATION ANORMALE!" severity failure;
    end if;
  end process;



  -- Si on envoie des donnes invalides au core PCIe (comme du 'U' ou du 'X'), cela genere un mauvais TLP et fera planter le lien PCIe et eventuellement la simulation.
  -- c'est relativement fastidieux de reculer dans le simulation pour trouver le probleme, alors l'assertion plus bas devrait faire apparaitre la source du probleme plus rapidement
  P_tdatacheckprc : process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if s_axis_tx_tvalid = '1' then  -- si on est en train de transmettre des donnes au core PCIe
        for i in s_axis_tx_tdata'range loop
          assert (s_axis_tx_tdata(i) = '0' or s_axis_tx_tdata(i) = '1' or s_axis_tx_tkeep(i/8) = '0') report "Valeur illegale sur s_axis_tx_tdata qui brisera le lien PCIe a ce moment-ci!" severity failure;
        end loop;
      end if;
    end if;
  end process;

  -- synthesis translate_on


  -----------------------------------------------------------------------------
  -- PCIe core unused input mapping
  -----------------------------------------------------------------------------
  tx_cfg_gnt                    <= '1';
  cfg_err_ecrc                  <= '0';
  cfg_err_cpl_timeout           <= '0';  -- on ne fait jamais de read master, donc on attend jamais de completion
  cfg_err_cor                   <= '0';  -- on ne rapporte pas d'erreur corrigeable.
  cfg_err_atomic_egress_blocked <= '0';  -- on traite toute les requete atomique avec un Unsupported Request, donc on ne block rien
  cfg_err_internal_cor          <= '0';  -- AER seulement
  cfg_err_mc_blocked            <= '0';  -- on ne fait pas de traitement particulier pour les multicasts.
  cfg_err_poisoned              <= '0';  -- pas utile car DISABLE_RX_POISONED_RESP est false
  cfg_err_norecovery            <= '0';  -- on n'utilise pas poisoned ou timeout, alors c'est inutile
  cfg_err_acs                   <= '0';  -- le ACS, c'est pour le root complex, switch ou les multi-fonction, donc jamais notre cas.
  cfg_err_internal_uncor        <= '0';  -- AER seulement
  cfg_trn_pending               <= '0';  -- on ne fait jamais de requete non-posted
  cfg_pm_halt_aspm_l0s          <= '0';  -- on ne veut pas limiter le power management a priori
  cfg_pm_halt_aspm_l1           <= '0';  -- on ne veut pas limiter le power management a priori
  cfg_pm_force_state_en         <= '0';  -- on ne veut pas force l'etat du lien, a priori
  cfg_pm_force_state            <= "00";  -- on ne veut pas force l'etat du lien, a priori
  cfg_dsn                       <= x"0000000000000000";
  cfg_interrupt_stat            <= '0';  -- on ne veux pas overrider le mechanisme de generation d'interrupt interne alors ce bit devrait etre don't-care.
  cfg_turnoff_ok                <= '0';
  cfg_pciecap_interrupt_msgnum  <= "00000";  -- doit etre mis-a-jour si on active le multiple message Enable avec les MSIs. Ce n'est pas le cas pour l'instant
  cfg_pm_wake                   <= '0';  -- on ne veut pas reveiller le lien PCIe
  cfg_pm_send_pme_to            <= '0';
  cfg_ds_bus_number             <= x"00";
  cfg_ds_device_number          <= "00000";
  cfg_ds_function_number        <= "000";
--  cfg_mgmt_wr_rw1c_as_rw        <= '0';
  cfg_err_aer_headerlog         <= x"00000000000000000000000000000000";  -- AER non-utilise
  cfg_aer_interrupt_msgnum      <= "00000";  -- AER non-utilise


  pcie_txp       <= pci_exp_txp(0);
  pcie_txn       <= pci_exp_txn(0);
  pci_exp_rxp(0) <= pcie_rxp;
  pci_exp_rxn(0) <= pcie_rxn;


  -----------------------------------------------------------------------------
  -- Vendor ID : 0x102b (Matrox)
  -- Device ID : 0x4687 (Hallux)
  -----------------------------------------------------------------------------
--  xxil_pcie : pcie_7x_0
  xxil_pcie : pcie_7x_0_mtx_wrapper
    generic map(
      CFG_VEND_ID        => PCIE_VENDOR_ID,
      CFG_DEV_ID         => PCIE_DEVICE_ID,
      CFG_REV_ID         => PCIE_REV_ID,
      CFG_SUBSYS_VEND_ID => PCIE_SUBSYS_VENDOR_ID,
      CFG_SUBSYS_ID      => PCIE_SUBSYS_ID
      )
    port map (
      pci_exp_txp                                => pci_exp_txp,
      pci_exp_txn                                => pci_exp_txn,
      pci_exp_rxp                                => pci_exp_rxp,
      pci_exp_rxn                                => pci_exp_rxn,
      user_clk_out                               => sys_clk,
      user_reset_out                             => sys_reset,
      user_lnk_up                                => user_lnk_up,  -- pcie_rx_axi
      user_app_rdy                               => user_app_rdy,  -- Out unused
      tx_buf_av                                  => tx_buf_av,   -- Out unused
      tx_cfg_req                                 => tx_cfg_req,  -- Out unused
      tx_err_drop                                => tx_err_drop,  -- Out unused
      s_axis_tx_tready                           => s_axis_tx_tready,  -- pcie_tx_axi
      s_axis_tx_tdata                            => s_axis_tx_tdata,  -- pcie_tx_axi
      s_axis_tx_tkeep                            => s_axis_tx_tkeep,  -- pcie_tx_axi
      s_axis_tx_tlast                            => s_axis_tx_tlast,  -- pcie_tx_axi
      s_axis_tx_tvalid                           => s_axis_tx_tvalid,  -- pcie_tx_axi
      s_axis_tx_tuser                            => s_axis_tx_tuser,  -- pcie_tx_axi
      tx_cfg_gnt                                 => tx_cfg_gnt,
      m_axis_rx_tdata                            => m_axis_rx_tdata,  -- pcie_rx_axi
      m_axis_rx_tkeep                            => m_axis_rx_tkeep,  -- pcie_rx_axi
      m_axis_rx_tlast                            => m_axis_rx_tlast,  -- pcie_rx_axi
      m_axis_rx_tvalid                           => m_axis_rx_tvalid,  -- pcie_rx_axi
      m_axis_rx_tready                           => m_axis_rx_tready,  -- pcie_rx_axi
      m_axis_rx_tuser                            => m_axis_rx_tuser,  -- pcie_rx_axi
      rx_np_ok                                   => rx_np_ok,    -- pcie_rx_axi
      rx_np_req                                  => rx_np_req,   -- pcie_rx_axi
      -- cfg_mgmt_do                                => cfg_mgmt_do,  -- pcie_irq_axi
      -- cfg_mgmt_rd_wr_done                        => cfg_mgmt_rd_wr_done,  -- pcie_irq_axi
      cfg_status                                 => cfg_status,  -- Out unused
      cfg_command                                => cfg_command,  -- Out unused
      cfg_dstatus                                => cfg_dstatus,  -- Out unused
      cfg_dcommand                               => cfg_dcommand,  -- pcie_tx_axi
      cfg_lstatus                                => cfg_lstatus,  -- Out unused
      cfg_lcommand                               => cfg_lcommand,  -- Out unused
      cfg_dcommand2                              => cfg_dcommand2,  -- Out unused
      cfg_pcie_link_state                        => cfg_pcie_link_state,  -- Out unused
      cfg_pmcsr_pme_en                           => cfg_pmcsr_pme_en,  -- Out unused
      cfg_pmcsr_powerstate                       => cfg_pmcsr_powerstate,  -- Out unused
      cfg_pmcsr_pme_status                       => cfg_pmcsr_pme_status,  -- Out unused
      cfg_received_func_lvl_rst                  => cfg_received_func_lvl_rst,  -- Out unused
      -- cfg_mgmt_di                                => cfg_mgmt_di,  -- pcie_irq_axi
      -- cfg_mgmt_byte_en                           => cfg_mgmt_byte_en,  -- pcie_irq_axi
      -- cfg_mgmt_dwaddr                            => cfg_mgmt_dwaddr,  -- pcie_irq_axi
      -- cfg_mgmt_wr_en                             => cfg_mgmt_wr_en,  -- pcie_irq_axi
      -- cfg_mgmt_rd_en                             => cfg_mgmt_rd_en,  -- pcie_irq_axi
      -- cfg_mgmt_wr_readonly                       => cfg_mgmt_wr_readonly,  -- pcie_irq_axi
      cfg_err_ecrc                               => cfg_err_ecrc,  -- static '0'
      cfg_err_ur                                 => cfg_err_ur,  -- pcie_rx_axi
      cfg_err_cpl_timeout                        => cfg_err_cpl_timeout,  -- static '0'
      cfg_err_cpl_unexpect                       => cfg_err_cpl_unexpect,  -- pcie_rx_axi
      cfg_err_cpl_abort                          => cfg_err_cpl_abort,  -- pcie_rx_axi
      cfg_err_posted                             => cfg_err_posted,  -- pcie_rx_axi
      cfg_err_cor                                => cfg_err_cor,  -- static '0'
      cfg_err_atomic_egress_blocked              => cfg_err_atomic_egress_blocked,  -- static '0'
      cfg_err_internal_cor                       => cfg_err_internal_cor,  -- static '0'
      cfg_err_malformed                          => cfg_err_malformed,  -- pcie_rx_axi
      cfg_err_mc_blocked                         => cfg_err_mc_blocked,  -- static '0'
      cfg_err_poisoned                           => cfg_err_poisoned,  -- static '0'
      cfg_err_norecovery                         => cfg_err_norecovery,  -- static '0'
      cfg_err_tlp_cpl_header                     => cfg_err_tlp_cpl_header,  -- pcie_rx_axi
      cfg_err_cpl_rdy                            => cfg_err_cpl_rdy,  -- pcie_rx_axi
      cfg_err_locked                             => cfg_err_locked,  -- pcie_rx_axi
      cfg_err_acs                                => cfg_err_acs,  -- static '0'
      cfg_err_internal_uncor                     => cfg_err_internal_uncor,  -- static '0'
      cfg_trn_pending                            => cfg_trn_pending,  -- static '0'
      cfg_pm_halt_aspm_l0s                       => cfg_pm_halt_aspm_l0s,  -- static '0'
      cfg_pm_halt_aspm_l1                        => cfg_pm_halt_aspm_l1,  -- static '0'
      cfg_pm_force_state_en                      => cfg_pm_force_state_en,  -- static '0'
      cfg_pm_force_state                         => cfg_pm_force_state,  -- static '0'
      cfg_dsn                                    => cfg_dsn,     -- static '0'
      cfg_interrupt                              => cfg_interrupt,  -- pcie_irq_axi
      cfg_interrupt_rdy                          => cfg_interrupt_rdy,  -- pcie_irq_axi
      cfg_interrupt_assert                       => cfg_interrupt_assert,  -- pcie_irq_axi
      cfg_interrupt_di                           => cfg_interrupt_di,  -- pcie_irq_axi
      cfg_interrupt_do                           => cfg_interrupt_do,  -- Out unused
      cfg_interrupt_mmenable                     => cfg_interrupt_mmenable,  -- pcie_irq_axi
      cfg_interrupt_msienable                    => cfg_interrupt_msienable,  -- pcie_irq_axi + pcie_int_queue
      cfg_interrupt_msixenable                   => cfg_interrupt_msixenable,  -- pcie_irq_axi + pcie_int_queue
      cfg_interrupt_msixfm                       => cfg_interrupt_msixfm,  -- Out unused
      cfg_interrupt_stat                         => cfg_interrupt_stat,  -- static '0'
      cfg_pciecap_interrupt_msgnum               => cfg_pciecap_interrupt_msgnum,  -- static '0'
      cfg_to_turnoff                             => cfg_to_turnoff,  -- Out unused
      cfg_turnoff_ok                             => cfg_turnoff_ok,  -- 
      cfg_bus_number                             => cfg_bus_number,  -- pcie_tx_axi
      cfg_device_number                          => cfg_device_number,  -- pcie_tx_axi
      cfg_function_number                        => cfg_function_number,  -- Out unused
      cfg_pm_wake                                => cfg_pm_wake,  -- static '0'
      cfg_pm_send_pme_to                         => cfg_pm_send_pme_to,  -- static '0'
      cfg_ds_bus_number                          => cfg_ds_bus_number,  -- static '0'
      cfg_ds_device_number                       => cfg_ds_device_number,  -- static '0'
      cfg_ds_function_number                     => cfg_ds_function_number,  -- static '0'
      -- cfg_mgmt_wr_rw1c_as_rw                     => cfg_mgmt_wr_rw1c_as_rw,  -- static '0'
      cfg_bridge_serr_en                         => cfg_bridge_serr_en,  -- Out unused
      cfg_slot_control_electromech_il_ctl_pulse  => cfg_slot_control_electromech_il_ctl_pulse,  -- Out unused
      cfg_root_control_syserr_corr_err_en        => cfg_root_control_syserr_corr_err_en,  -- Out unused
      cfg_root_control_syserr_non_fatal_err_en   => cfg_root_control_syserr_non_fatal_err_en,  -- Out unused
      cfg_root_control_syserr_fatal_err_en       => cfg_root_control_syserr_fatal_err_en,  -- Out unused
      cfg_root_control_pme_int_en                => cfg_root_control_pme_int_en,  -- Out unused
      cfg_aer_rooterr_corr_err_reporting_en      => cfg_aer_rooterr_corr_err_reporting_en,  -- Out unused
      cfg_aer_rooterr_non_fatal_err_reporting_en => cfg_aer_rooterr_non_fatal_err_reporting_en,  -- Out unused
      cfg_aer_rooterr_fatal_err_reporting_en     => cfg_aer_rooterr_fatal_err_reporting_en,  -- Out unused
      cfg_aer_rooterr_corr_err_received          => cfg_aer_rooterr_corr_err_received,  -- Out unused
      cfg_aer_rooterr_non_fatal_err_received     => cfg_aer_rooterr_non_fatal_err_received,  -- Out unused
      cfg_aer_rooterr_fatal_err_received         => cfg_aer_rooterr_fatal_err_received,
      cfg_err_aer_headerlog                      => cfg_err_aer_headerlog,  -- static '0'
      cfg_aer_interrupt_msgnum                   => cfg_aer_interrupt_msgnum,  -- static '0'
      cfg_err_aer_headerlog_set                  => cfg_err_aer_headerlog_set,  -- Out unused
      cfg_aer_ecrc_check_en                      => cfg_aer_ecrc_check_en,  -- Out unused
      cfg_aer_ecrc_gen_en                        => cfg_aer_ecrc_gen_en,  -- Out unused
      cfg_vc_tcvc_map                            => cfg_vc_tcvc_map,  -- Out unused
      sys_clk                                    => pcie_sys_clk,
      sys_rst_n                                  => pcie_sys_rst_n
      );


  -----------------------------------------------------------------------------
  -- G_DMA_EN : Receive messages from host
  --
  -----------------------------------------------------------------------------
  G_DMA_EN : if (ENABLE_DMA > 0) generate
    tlp_out_req_to_send(DMA_AGENT_ID) <= tlp_req_to_send;

    tlp_out_fmt_type(DMA_AGENT_ID)     <= tlp_fmt_type;
    tlp_out_length_in_dw(DMA_AGENT_ID) <= tlp_length_in_dw;

    tlp_out_src_rdy_n(DMA_AGENT_ID) <= tlp_src_rdy_n;
    tlp_out_data(DMA_AGENT_ID)      <= tlp_data;

    -- for master request transmit 
    tlp_out_address(DMA_AGENT_ID)     <= tlp_address;
    tlp_out_ldwbe_fdwbe(DMA_AGENT_ID) <= tlp_ldwbe_fdwbe;

    -- for completion transmit
    tlp_out_attr(DMA_AGENT_ID)           <= tlp_attr;
    tlp_out_transaction_id(DMA_AGENT_ID) <= tlp_transaction_id;
    tlp_out_byte_count(DMA_AGENT_ID)     <= tlp_byte_count;
    tlp_out_lower_address(DMA_AGENT_ID)  <= tlp_lower_address;

    tlp_grant     <= tlp_out_grant(DMA_AGENT_ID);
    tlp_dst_rdy_n <= tlp_out_dst_rdy_n(DMA_AGENT_ID);
    
  end generate;


  -----------------------------------------------------------------------------
  -- pcie_rx_axi : Receive messages from host
  --
  -- NB_PCIE_AGENTS  : 2 
  -- AGENT[0]        : BAR0  (tlp_to_axi_master) 
  -- AGENT[1]        : BAR2  (pcie_reg) 
  -- C_DATA_WIDTH    : 64 bits
  -----------------------------------------------------------------------------
  xpcie_rx : pcie_rx_axi
    generic map(
      NB_PCIE_AGENTS  => NB_PCIE_AGENTS,
      AGENT_TO_BAR(0) => PCI_BAR0,
      AGENT_TO_BAR(1) => PCI_BAR2,
      AGENT_TO_BAR(2) => NO_PCI_BAR,
      C_DATA_WIDTH    => C_DATA_WIDTH
      )
    port map (
      sys_clk                => sys_clk,
      sys_reset_n            => sys_reset_n,
      user_lnk_up            => user_lnk_up,
      m_axis_rx_tdata        => m_axis_rx_tdata,
      m_axis_rx_tkeep        => m_axis_rx_tkeep,
      m_axis_rx_tlast        => m_axis_rx_tlast,
      m_axis_rx_tvalid       => m_axis_rx_tvalid,
      m_axis_rx_tready       => m_axis_rx_tready,
      m_axis_rx_tuser        => m_axis_rx_tuser,
      rx_np_ok               => rx_np_ok,
      rx_np_req              => rx_np_req,
      tlp_in_accept_data     => tlp_in_accept_data,
      tlp_in_abort           => tlp_in_abort,
      tlp_in_fmt_type        => tlp_in_fmt_type,
      tlp_in_address         => tlp_in_address,
      tlp_in_length_in_dw    => tlp_in_length_in_dw,
      tlp_in_attr            => tlp_in_attr,
      tlp_in_transaction_id  => tlp_in_transaction_id,
      tlp_in_valid           => tlp_in_valid,
      tlp_in_data            => tlp_in_data,
      tlp_in_byte_en         => tlp_in_byte_en,
      tlp_in_byte_count      => tlp_in_byte_count,
      cfg_err_cpl_unexpect   => cfg_err_cpl_unexpect,
      cfg_err_posted         => cfg_err_posted,
      cfg_err_malformed      => cfg_err_malformed,
      cfg_err_ur             => cfg_err_ur,
      cfg_err_cpl_abort      => cfg_err_cpl_abort,
      cfg_err_tlp_cpl_header => cfg_err_tlp_cpl_header,
      cfg_err_cpl_rdy        => cfg_err_cpl_rdy,
      cfg_err_locked         => cfg_err_locked
      );


  -----------------------------------------------------------------------------
  -- pcie_tx_axi : Send messages to host
  --
  -- NB_PCIE_AGENTS     : 3
  -- AGENT_IS_64_BIT[0] : NO  (tlp_to_axi_master : Data width = 32 bits)
  -- AGENT_IS_64_BIT[1] : NO  (pcie_reg : Data width = 32 bits)
  -- AGENT_IS_64_BIT[2] : YES (pcie_int_queue : Data width = 64 bits)
  -- C_DATA_WIDTH       : 64 bits
  -----------------------------------------------------------------------------
  xpcie_tx : pcie_tx_axi
    generic map(
      NB_PCIE_AGENTS  => NB_PCIE_AGENTS,
      -- AGENT_IS_64_BIT(0) => NO,
      -- AGENT_IS_64_BIT(1) => NO,
      -- AGENT_IS_64_BIT(2) => YES,
      AGENT_IS_64_BIT => "100",
      C_DATA_WIDTH    => C_DATA_WIDTH
      )
    port map (
      sys_clk                => sys_clk,
      sys_reset_n            => sys_reset_n,
      s_axis_tx_tready       => s_axis_tx_tready,
      s_axis_tx_tdata        => s_axis_tx_tdata,
      s_axis_tx_tkeep        => s_axis_tx_tkeep,
      s_axis_tx_tlast        => s_axis_tx_tlast,
      s_axis_tx_tvalid       => s_axis_tx_tvalid,
      s_axis_tx_tuser        => s_axis_tx_tuser,
      cfg_bus_number         => cfg_bus_number,
      cfg_device_number      => cfg_device_number,
      cfg_no_snoop_en        => cfg_no_snoop_en,
      cfg_relax_ord_en       => cfg_relax_ord_en,
      tlp_out_req_to_send    => tlp_out_req_to_send,
      tlp_out_grant          => tlp_out_grant,
      tlp_out_fmt_type       => tlp_out_fmt_type,
      tlp_out_length_in_dw   => tlp_out_length_in_dw,
      tlp_out_src_rdy_n      => tlp_out_src_rdy_n,
      tlp_out_dst_rdy_n      => tlp_out_dst_rdy_n,
      tlp_out_data           => tlp_out_data,
      tlp_out_address        => tlp_out_address,
      tlp_out_ldwbe_fdwbe    => tlp_out_ldwbe_fdwbe,
      tlp_out_attr           => tlp_out_attr,
      tlp_out_transaction_id => tlp_out_transaction_id,
      tlp_out_byte_count     => tlp_out_byte_count,
      tlp_out_lower_address  => tlp_out_lower_address
      );


  -----------------------------------------------------------------------------
  -- AXI master bus
  -- TLP agent[0],mapped on BAR0
  -----------------------------------------------------------------------------
  xtlp_to_axi_master : tlp_to_axi_master
    generic map(
      BAR_ADDR_WIDTH => BAR0_64MB,
      AXI_ID_WIDTH   => AXI_ID_WIDTH
      )
    port map(
      sys_clk                => sys_clk,
      sys_reset_n            => sys_reset_n,
      tlp_in_valid           => tlp_in_valid(0),
      tlp_in_abort           => tlp_in_abort(0),
      tlp_in_accept_data     => tlp_in_accept_data(0),
      tlp_in_fmt_type        => tlp_in_fmt_type,
      tlp_in_address         => tlp_in_address(31 downto 0),
      tlp_in_length_in_dw    => tlp_in_length_in_dw,
      tlp_in_attr            => tlp_in_attr,
      tlp_in_transaction_id  => tlp_in_transaction_id,
      tlp_in_data            => tlp_in_data,
      tlp_in_byte_en         => tlp_in_byte_en,
      tlp_in_byte_count      => tlp_in_byte_count,
      tlp_out_req_to_send    => tlp_out_req_to_send(0),
      tlp_out_grant          => tlp_out_grant(0),
      tlp_out_fmt_type       => tlp_out_fmt_type(0),
      tlp_out_length_in_dw   => tlp_out_length_in_dw(0),
      tlp_out_src_rdy_n      => tlp_out_src_rdy_n(0),
      tlp_out_dst_rdy_n      => tlp_out_dst_rdy_n(0),
      tlp_out_data           => tlp_out_data(0)(31 downto 0),
      tlp_out_attr           => tlp_out_attr(0),
      tlp_out_transaction_id => tlp_out_transaction_id(0),
      tlp_out_byte_count     => tlp_out_byte_count(0),
      tlp_out_lower_address  => tlp_out_lower_address(0),
      tlp_timeout_value      => regfile.tlp.timeout.value,
      tlp_abort_cntr_init    => regfile.tlp.transaction_abort_cntr.clr,
      tlp_abort_cntr_value   => regfile.tlp.transaction_abort_cntr.value,
      axi_window             => regfile.axi_window,
      axim_awready           => axim_awready,
      axim_awvalid           => axim_awvalid,
      axim_awid              => axim_awid,
      axim_awaddr            => axim_awaddr,
      axim_awlen             => axim_awlen,
      axim_awsize            => axim_awsize,
      axim_awburst           => axim_awburst,
      axim_awlock            => axim_awlock,
      axim_awcache           => axim_awcache,
      axim_awprot            => axim_awprot,
      axim_awqos             => axim_awqos,
      axim_wready            => axim_wready,
      axim_wvalid            => axim_wvalid,
      axim_wid               => axim_wid,
      axim_wdata             => axim_wdata,
      axim_wstrb             => axim_wstrb,
      axim_wlast             => axim_wlast,
      axim_bvalid            => axim_bvalid,
      axim_bready            => axim_bready,
      axim_bid               => axim_bid,
      axim_bresp             => axim_bresp,
      axim_arready           => axim_arready,
      axim_arvalid           => axim_arvalid,
      axim_arid              => axim_arid,
      axim_araddr            => axim_araddr,
      axim_arlen             => axim_arlen,
      axim_arsize            => axim_arsize,
      axim_arburst           => axim_arburst,
      axim_arlock            => axim_arlock,
      axim_arcache           => axim_arcache,
      axim_arprot            => axim_arprot,
      axim_arqos             => axim_arqos,
      axim_rready            => axim_rready,
      axim_rvalid            => axim_rvalid,
      axim_rid               => axim_rid,
      axim_rresp             => axim_rresp,
      axim_rlast             => axim_rlast,
      axim_rdata             => axim_rdata
      );

--tlp_out_data(0)(63 downto 32) <= X"CAFEBABE";
  -- xpcie_irq : pcie_irq_axi
  --   port map (
  --     sys_clk                  => sys_clk,
  --     sys_reset                => sys_reset,
  --     int_status               => queue_irq_masked,
  --     msi_req                  => msi_req_masked,
  --     msi_ack                  => msi_ack,
  --     cfg_mgmt_do              => cfg_mgmt_do,
  --     cfg_mgmt_rd_wr_done      => cfg_mgmt_rd_wr_done,
  --     cfg_mgmt_di              => cfg_mgmt_di,
  --     cfg_mgmt_byte_en         => cfg_mgmt_byte_en,
  --     cfg_mgmt_dwaddr          => cfg_mgmt_dwaddr,
  --     cfg_mgmt_wr_en           => cfg_mgmt_wr_en,
  --     cfg_mgmt_rd_en           => cfg_mgmt_rd_en,
  --     cfg_mgmt_wr_readonly     => cfg_mgmt_wr_readonly,
  --     cfg_interrupt_rdy        => cfg_interrupt_rdy,
  --     cfg_interrupt_msienable  => cfg_interrupt_msienable,
  --     cfg_interrupt_mmenable   => cfg_interrupt_mmenable,
  --     cfg_interrupt_msixenable => cfg_interrupt_msixenable,
  --     cfg_interrupt            => cfg_interrupt,
  --     cfg_interrupt_di         => cfg_interrupt_di,
  --     cfg_interrupt_assert     => cfg_interrupt_assert
  --     );

  xpcie_irq : pcie_irq_axi
    port map (
      sys_clk                  => sys_clk,
      sys_reset                => sys_reset,
      int_status               => queue_irq_masked,
      msi_req                  => msi_req_masked,
      msi_ack                  => msi_ack,
      cfg_mgmt_do              => (others => '0'),
      cfg_mgmt_rd_wr_done      => '0',
      cfg_mgmt_di              => open,
      cfg_mgmt_byte_en         => open,
      cfg_mgmt_dwaddr          => open,
      cfg_mgmt_wr_en           => open,
      cfg_mgmt_rd_en           => open,
      cfg_mgmt_wr_readonly     => open,
      cfg_interrupt_rdy        => cfg_interrupt_rdy,
      cfg_interrupt_msienable  => cfg_interrupt_msienable,
      cfg_interrupt_mmenable   => cfg_interrupt_mmenable,
      cfg_interrupt_msixenable => cfg_interrupt_msixenable,
      cfg_interrupt            => cfg_interrupt,
      cfg_interrupt_di         => cfg_interrupt_di,
      cfg_interrupt_assert     => cfg_interrupt_assert
      );


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------

  xpcie_int_queue : pcie_int_queue
    port map(
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk   => sys_clk,
      sys_reset => sys_reset,

      ---------------------------------------------------------------------
      -- Interrupt IN
      ---------------------------------------------------------------------
      int_status => int_status,  -- pour les interrupt classique seulement
      int_event  => int_event,   -- pour envoyer un MSI, 1 bit par vecteur

      ---------------------------------------------------------------------
      -- single interrupt OUT
      ---------------------------------------------------------------------
      queue_int_out => queue_irq(0),
      msi_req       => msi_req(0),
      msi_ack       => msi_ack(0),

      regfile => regfile.INTERRUPT_QUEUE,

      ---------------------------------------------------------------------
      -- TLP transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send => tlp_out_req_to_send(2),
      tlp_out_grant       => tlp_out_grant(2),

      tlp_out_fmt_type     => tlp_out_fmt_type(2),
      tlp_out_length_in_dw => tlp_out_length_in_dw(2),
      tlp_out_attr         => tlp_out_attr(2),

      tlp_out_src_rdy_n => tlp_out_src_rdy_n(2),
      tlp_out_dst_rdy_n => tlp_out_dst_rdy_n(2),
      tlp_out_data      => tlp_out_data(2),

      -- for master request transmit
      tlp_out_address     => tlp_out_address(2),
      tlp_out_ldwbe_fdwbe => tlp_out_ldwbe_fdwbe(2),

      -- for completion transmit
      tlp_out_transaction_id => tlp_out_transaction_id(2),
      tlp_out_byte_count     => tlp_out_byte_count(2),
      tlp_out_lower_address  => tlp_out_lower_address(2),

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_msienable  => cfg_interrupt_msienable,
      cfg_interrupt_msixenable => cfg_interrupt_msixenable

      );


  -----------------------------------------------------------------------------
  -- Registerfile
  -- TLP agent[1], mapped on BAR[2]
  -----------------------------------------------------------------------------
  bar2_pcie_reg : pcie_reg
    port map(
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk     => sys_clk,
      sys_reset_n => sys_reset_n,

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------
      tlp_in_accept_data => tlp_in_accept_data(1),

      tlp_in_fmt_type       => tlp_in_fmt_type,
      tlp_in_address        => tlp_in_address,
      tlp_in_length_in_dw   => tlp_in_length_in_dw,
      tlp_in_attr           => tlp_in_attr,
      tlp_in_transaction_id => tlp_in_transaction_id,
      tlp_in_valid          => tlp_in_valid(1),
      tlp_in_data           => tlp_in_data,
      tlp_in_byte_en        => tlp_in_byte_en,
      tlp_in_byte_count     => tlp_in_byte_count,

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send => tlp_out_req_to_send(1),
      tlp_out_grant       => tlp_out_grant(1),

      tlp_out_fmt_type     => tlp_out_fmt_type(1),
      tlp_out_length_in_dw => tlp_out_length_in_dw(1),

      tlp_out_src_rdy_n => tlp_out_src_rdy_n(1),
      tlp_out_dst_rdy_n => tlp_out_dst_rdy_n(1),
      tlp_out_data      => tlp_out_data(1)(31 downto 0),

      -- for completion transmit
      tlp_out_attr           => tlp_out_attr(1),
      tlp_out_transaction_id => tlp_out_transaction_id(1),
      tlp_out_byte_count     => tlp_out_byte_count(1),
      tlp_out_lower_address  => tlp_out_lower_address(1),

      ---------------------------------------------------------------------
      -- PCIe Register FIFO error detection
      ---------------------------------------------------------------------
      RESET_STR_REG_ERR => '0',         --RESET_STR_REG_ERR,

      ---------------------------------------------------------------------
      -- Memory Register file interface
      ---------------------------------------------------------------------
      reg_readdata      => reg_readdata,
      reg_readdatavalid => reg_readdatavalid,

      reg_addr      => reg_addr,
      reg_read      => reg_read,
      reg_write     => reg_write,
      reg_beN       => reg_beN,
      reg_writedata => reg_writedata
      );


  xregfile_pcie2AxiMaster : regfile_pcie2AxiMaster
    port map(
      resetN        => sys_reset_n,
      sysclk        => sys_clk,
      regfile       => regfile,
      reg_read      => reg_read,
      reg_write     => reg_write,
      reg_addr      => reg_addr,
      reg_beN       => reg_beN,
      reg_writedata => reg_writedata,
      reg_readdata  => reg_readdata
      );


  P_reg_readdadavalid : process (sys_clk) is
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset_n = '0') then
        reg_readdatavalid <= '0';
      else
        reg_readdatavalid <= reg_read;
      end if;
    end if;
  end process P_reg_readdadavalid;


  regfile.fpga.build_id.value        <= fpga_build_id;
  regfile.fpga.version.major         <= fpga_major_ver;
  regfile.fpga.version.minor         <= fpga_minor_ver;
  regfile.fpga.version.sub_minor     <= fpga_sub_minor_ver;
  regfile.fpga.version.firmware_type <= fpga_firmware_type;
  regfile.fpga.device.id             <= fpga_device_id;
  regfile.fpga.board_info.capability <= board_info;


  -----------------------------------------------------------------------------
  -- IRQ Mapping
  -----------------------------------------------------------------------------
  G_irq_mapping_low : for i in 0 to 31 generate
    regfile.interrupts.status(0).value_set(i) <= irq_event_resync(i) and regfile.interrupts.enable(0).value(i);
    int_status(i)                             <= regfile.interrupts.status(0).value(i) and (not regfile.interrupts.mask(0).value(i));
    int_event(i)                              <= irq_event_resync(i) and regfile.interrupts.enable(0).value(i);
  end generate G_irq_mapping_low;


  G_irq_mapping_high : for i in 0 to 31 generate
    regfile.interrupts.status(1).value_set(i) <= irq_event_resync(32+i) and regfile.interrupts.enable(1).value(i);
    int_status(32+i)                          <= regfile.interrupts.status(1).value(i) and (not regfile.interrupts.mask(1).value(i));
    int_event(32+i)                           <= irq_event_resync(32+i) and regfile.interrupts.enable(1).value(i);
  end generate G_irq_mapping_high;

  -- Mask Legacy IRQ  
  queue_irq_masked <= queue_irq when(regfile.interrupts.ctrl.global_mask = '0') else
                      (others => '0');

  -- Mask MSI request
  msi_req_masked <= msi_req when(regfile.interrupts.ctrl.global_mask = '0') else
                    (others => '0');

  -- Return in the registerfile the number of Physical IRQ implemented
  regfile.interrupts.ctrl.num_irq <= std_logic_vector(to_unsigned(NUMB_IRQ, 7));




  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- DEBUG INTERFACE
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- WARNING CLOCK DOMAIN CROSSING
  -----------------------------------------------------------------------------
  G_debug_in : if (DEBUG_IN_WIDTH > 0) generate

    P_debug_in_sig : process (sys_clk) is
    begin
      if (rising_edge(sys_clk)) then
        if (sys_reset_n = '0') then
          debug_in_sig_meta <= (others => '0');
          debug_in_sig      <= (others => '0');
        else
          debug_in_sig_meta(debug_in'range) <= debug_in;
          debug_in_sig                      <= debug_in_sig_meta;
        end if;
      end if;
    end process P_debug_in_sig;

  end generate G_debug_in;

  regfile.debug.input.value <= debug_in_sig;
  debug_out_sig             <= regfile.debug.output.value;

  G_debug_out : if (DEBUG_OUT_WIDTH > 0) generate
    debug_out <= debug_out_sig(debug_out'range);
  end generate G_debug_out;


  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  P_irq_event_resync : process (sys_clk) is
  begin
    if (rising_edge(sys_clk)) then
      if (sys_reset_n = '0') then
        irq_event_resync <= (others => '0');
        irq_event_Meta   <= (others => '0');
      else
        irq_event_Meta(irq_event'range) <= irq_event;
        irq_event_resync                <= irq_event_Meta;
      end if;
    end if;
  end process P_irq_event_resync;


end struct;
