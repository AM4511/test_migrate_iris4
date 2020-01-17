-----------------------------------------------------------------------
-- $HeadURL: $
-- $Author: jlarin $
-- $Revision:  $
-- $Date: 2 $
--
-- DESCRIPTION: Top PCIe file for Artix7 variations.  Includes Xilinx A7 Endpoint
-- + user interface.
-----------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all; 
  use ieee.std_logic_unsigned.all;
library work;
  use work.int_queue_pak.all;
  use work.pciepack.all;

entity pcie_top is
  generic (
    USE_DMA           : boolean := FALSE;
    MAX_LANE_NB       : integer := 0;
  	NB_PCIE_AGENTS    : integer := 3
    );
  port (
    CFG_SUBSYS_ID_in                     : in std_logic_vector(15 downto 0) := x"0000"; -- jlarin: nous voulons un subsystem ID dependant d'un signal statique
    ---------------------------------------------------------------------------
    -- PCIe FPGA IOs (100 MHz input clock)
    ---------------------------------------------------------------------------
    pcie_sys_clk                        : in  std_logic;
    pcie_sys_rst_n                      : in  std_logic;
    pci_exp_rxp                         : in  std_logic_vector;
    pci_exp_rxn                         : in  std_logic_vector;
    
    pci_exp_txp                         : out std_logic_vector;
    pci_exp_txn                         : out std_logic_vector;

    ---------------------------------------------------------------------
    -- System clock and reset (62.5 MHz transaction interface clock)
    ---------------------------------------------------------------------
    sys_clk                              : buffer std_logic;
    sys_reset_n                          : out    std_logic;
    
    ---------------------------------------------------------------------
    -- Interrupt
    ---------------------------------------------------------------------
    int_status                          : in    std_logic_vector; -- pour les interrupt classique seulement
    int_event                           : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur

    regfile                             : in    INTERRUPT_QUEUE_TYPE;      -- definit dans int_queue_pak
    
    ---------------------------------------------------------------------
    -- Register file interface
    ---------------------------------------------------------------------
    reg_readdata                         : in    std_logic_vector(31 downto 0);
    reg_readdatavalid                    : in    std_logic;
    reg_addr                             : out   std_logic_vector;--(REG_ADDRMSB downto REG_ADDRLSB);
    reg_write                            : out   std_logic;
    reg_beN                              : out   std_logic_vector(3 downto 0);
    reg_writedata                        : out   std_logic_vector(31 downto 0);
    reg_read                             : out   std_logic;
    
    ---------------------------------------------------------------------
    -- DMA - PCIe interface
    ---------------------------------------------------------------------
    dma_tlp_req_to_send                 : in std_logic := '0';
    dma_tlp_grant                       : out  std_logic;

    dma_tlp_fmt_type                    : in std_logic_vector(6 downto 0) := (others => '0'); -- fmt and type field 
    dma_tlp_length_in_dw                : in std_logic_vector(9 downto 0) := (others => '0');

    dma_tlp_src_rdy_n                   : in std_logic := '0';
    dma_tlp_dst_rdy_n                   : out  std_logic;
    dma_tlp_data                        : in std_logic_vector(63 downto 0) := (others => '0');

    -- for master request transmit
    dma_tlp_address                     : in std_logic_vector(63 downto 2) := (others => '0'); 
    dma_tlp_ldwbe_fdwbe                 : in std_logic_vector(7 downto 0) := (others => '0');

    -- for completion transmit
    dma_tlp_attr                        : in std_logic_vector(1 downto 0) := (others => '0'); -- relaxed ordering, no snoop
    dma_tlp_transaction_id              : in std_logic_vector(23 downto 0) := (others => '0'); -- bus, device, function, tag
    dma_tlp_byte_count                  : in std_logic_vector(12 downto 0) := (others => '0'); -- byte count tenant compte des byte enables
    dma_tlp_lower_address               : in std_logic_vector(6 downto 0) := (others => '0');

    cfg_bus_mast_en                     : out   std_logic;
    cfg_setmaxpld                       : out   std_logic_vector(2 downto 0)
    
    --pcie_drp_clk                        : in STD_LOGIC                         := '1';
    --pcie_drp_en                         : in STD_LOGIC                         := '0';
    --pcie_drp_we                         : in STD_LOGIC                         := '0';
    --pcie_drp_addr                       : in STD_LOGIC_VECTOR ( 8 downto 0 )   := (others => '0');
    --pcie_drp_di                         : in STD_LOGIC_VECTOR ( 15 downto 0 )  := (others => '0');
    --pcie_drp_do                         : out STD_LOGIC_VECTOR ( 15 downto 0 );
    --pcie_drp_rdy                        : out STD_LOGIC
    

  );
end pcie_top;    

architecture functional of pcie_top is

   function get_userClk2 (
    DIV2   : string;
    UC_FREQ  : integer)
    return integer is
  begin  -- wr_mode
    if (DIV2 = "TRUE") then
      if (UC_FREQ = 4) then
        return 3;
      elsif (UC_FREQ = 3) then
        return 2;
      else
        return UC_FREQ;
      end if;
    else
      return UC_FREQ;
    end if;
  end get_userClk2;

   -- purpose: Determine Link Speed Configuration for GT
   function get_gt_lnk_spd_cfg (
     constant simulation : string)
     return integer is
   begin  -- get_gt_lnk_spd_cfg
     if (simulation = "TRUE") then
       return 2;
     else
       return 3;
     end if;
   end get_gt_lnk_spd_cfg;

	-- La doc parle d'external clocking quand on veut supporter le partial reconfig. 
	-- On ne veut pas supporter de partial reconfim (meme tandem), mais il faut bien que la clock vienne d'a quelque part?
	-- On va commencer par PCIE_EXT_CLK a false et on se ravisera.
	constant PCIE_EXT_CLK                 	: string := "FALSE";  -- Use External Clocking Module
  constant PL_FAST_TRAIN                  : string := "FALSE";

	constant C_DATA_WIDTH										: integer := 64;
  constant LINK_CAP_MAX_LINK_WIDTH_int    : integer := 1;
  constant USER_CLK_FREQ                  : integer := 1;
  constant USER_CLK2_DIV2                 : string  := "FALSE";
  constant USERCLK2_FREQ                  : integer := get_userClk2(USER_CLK2_DIV2,USER_CLK_FREQ);
  constant LNK_SPD                        : integer := get_gt_lnk_spd_cfg(PL_FAST_TRAIN);
  

  ---------------------------------------------------------------------------
  --  Xilinx A7 PCIe core
  ---------------------------------------------------------------------------
COMPONENT pcie_7x
  PORT (
      pci_exp_txp : OUT STD_LOGIC_VECTOR(pci_exp_txp'range);
      pci_exp_txn : OUT STD_LOGIC_VECTOR(pci_exp_txn'range);
      pci_exp_rxp : IN STD_LOGIC_VECTOR (pci_exp_rxp'range);
      pci_exp_rxn : IN STD_LOGIC_VECTOR (pci_exp_rxn'range);
    user_clk_out : OUT STD_LOGIC;
    user_reset_out : OUT STD_LOGIC;
    user_lnk_up : OUT STD_LOGIC;
    user_app_rdy : OUT STD_LOGIC;
    tx_buf_av : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    tx_cfg_req : OUT STD_LOGIC;
    tx_err_drop : OUT STD_LOGIC;
    s_axis_tx_tready : OUT STD_LOGIC;
    s_axis_tx_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    s_axis_tx_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axis_tx_tlast : IN STD_LOGIC;
    s_axis_tx_tvalid : IN STD_LOGIC;
    s_axis_tx_tuser : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    tx_cfg_gnt : IN STD_LOGIC;
    m_axis_rx_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_rx_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_rx_tlast : OUT STD_LOGIC;
    m_axis_rx_tvalid : OUT STD_LOGIC;
    m_axis_rx_tready : IN STD_LOGIC;
    m_axis_rx_tuser : OUT STD_LOGIC_VECTOR(21 DOWNTO 0);
    rx_np_ok : IN STD_LOGIC;
    rx_np_req : IN STD_LOGIC;
    cfg_mgmt_do : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    cfg_mgmt_rd_wr_done : OUT STD_LOGIC;
    cfg_status : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_command : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_dstatus : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_dcommand : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_lstatus : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_lcommand : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_dcommand2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    cfg_pcie_link_state : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cfg_pmcsr_pme_en : OUT STD_LOGIC;
    cfg_pmcsr_powerstate : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    cfg_pmcsr_pme_status : OUT STD_LOGIC;
    cfg_received_func_lvl_rst : OUT STD_LOGIC;
    cfg_mgmt_di : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    cfg_mgmt_byte_en : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    cfg_mgmt_dwaddr : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    cfg_mgmt_wr_en : IN STD_LOGIC;
    cfg_mgmt_rd_en : IN STD_LOGIC;
    cfg_mgmt_wr_readonly : IN STD_LOGIC;
    cfg_err_ecrc : IN STD_LOGIC;
    cfg_err_ur : IN STD_LOGIC;
    cfg_err_cpl_timeout : IN STD_LOGIC;
    cfg_err_cpl_unexpect : IN STD_LOGIC;
    cfg_err_cpl_abort : IN STD_LOGIC;
    cfg_err_posted : IN STD_LOGIC;
    cfg_err_cor : IN STD_LOGIC;
    cfg_err_atomic_egress_blocked : IN STD_LOGIC;
    cfg_err_internal_cor : IN STD_LOGIC;
    cfg_err_malformed : IN STD_LOGIC;
    cfg_err_mc_blocked : IN STD_LOGIC;
    cfg_err_poisoned : IN STD_LOGIC;
    cfg_err_norecovery : IN STD_LOGIC;
    cfg_err_tlp_cpl_header : IN STD_LOGIC_VECTOR(47 DOWNTO 0);
    cfg_err_cpl_rdy : OUT STD_LOGIC;
    cfg_err_locked : IN STD_LOGIC;
    cfg_err_acs : IN STD_LOGIC;
    cfg_err_internal_uncor : IN STD_LOGIC;
    cfg_trn_pending : IN STD_LOGIC;
    cfg_pm_halt_aspm_l0s : IN STD_LOGIC;
    cfg_pm_halt_aspm_l1 : IN STD_LOGIC;
    cfg_pm_force_state_en : IN STD_LOGIC;
    cfg_pm_force_state : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    cfg_dsn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    cfg_interrupt : IN STD_LOGIC;
    cfg_interrupt_rdy : OUT STD_LOGIC;
    cfg_interrupt_assert : IN STD_LOGIC;
    cfg_interrupt_di : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    cfg_interrupt_do : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    cfg_interrupt_mmenable : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cfg_interrupt_msienable : OUT STD_LOGIC;
    cfg_interrupt_msixenable : OUT STD_LOGIC;
    cfg_interrupt_msixfm : OUT STD_LOGIC;
    cfg_interrupt_stat : IN STD_LOGIC;
    cfg_pciecap_interrupt_msgnum : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    cfg_to_turnoff : OUT STD_LOGIC;
    cfg_turnoff_ok : IN STD_LOGIC;
    cfg_bus_number : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    cfg_device_number : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    cfg_function_number : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    cfg_pm_wake : IN STD_LOGIC;
    cfg_pm_send_pme_to : IN STD_LOGIC;
    cfg_ds_bus_number : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    cfg_ds_device_number : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    cfg_ds_function_number : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    cfg_mgmt_wr_rw1c_as_rw : IN STD_LOGIC;
    cfg_bridge_serr_en : OUT STD_LOGIC;
    cfg_slot_control_electromech_il_ctl_pulse : OUT STD_LOGIC;
    cfg_root_control_syserr_corr_err_en : OUT STD_LOGIC;
    cfg_root_control_syserr_non_fatal_err_en : OUT STD_LOGIC;
    cfg_root_control_syserr_fatal_err_en : OUT STD_LOGIC;
    cfg_root_control_pme_int_en : OUT STD_LOGIC;
    cfg_aer_rooterr_corr_err_reporting_en : OUT STD_LOGIC;
    cfg_aer_rooterr_non_fatal_err_reporting_en : OUT STD_LOGIC;
    cfg_aer_rooterr_fatal_err_reporting_en : OUT STD_LOGIC;
    cfg_aer_rooterr_corr_err_received : OUT STD_LOGIC;
    cfg_aer_rooterr_non_fatal_err_received : OUT STD_LOGIC;
    cfg_aer_rooterr_fatal_err_received : OUT STD_LOGIC;
    cfg_err_aer_headerlog : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
    cfg_aer_interrupt_msgnum : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    cfg_err_aer_headerlog_set : OUT STD_LOGIC;
    cfg_aer_ecrc_check_en : OUT STD_LOGIC;
    cfg_aer_ecrc_gen_en : OUT STD_LOGIC;
    cfg_vc_tcvc_map : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    sys_clk : IN STD_LOGIC;
    sys_rst_n : IN STD_LOGIC
    
    --pcie_drp_clk : in STD_LOGIC;
    --pcie_drp_en : in STD_LOGIC;
    --pcie_drp_we : in STD_LOGIC;
    --pcie_drp_addr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    --pcie_drp_di : in STD_LOGIC_VECTOR ( 15 downto 0 );
    --pcie_drp_do : out STD_LOGIC_VECTOR ( 15 downto 0 );
    --pcie_drp_rdy : out STD_LOGIC
    
  );
END COMPONENT;

--   component xil_pcie_axi_pipe_clock
--     generic (
--           PCIE_ASYNC_EN                : string  :=   "FALSE";     -- PCIe async enable
--           PCIE_TXBUF_EN                : string  :=   "FALSE";     -- PCIe TX buffer enable for Gen1/Gen2 only
--           PCIE_LANE                    : integer :=   1;           -- PCIe number of lanes
--           PCIE_LINK_SPEED              : integer :=   3;           -- PCIe link speed
--           PCIE_REFCLK_FREQ             : integer :=   0;           -- PCIe reference clock frequency
--           PCIE_USERCLK1_FREQ           : integer :=   3;           -- PCIe user clock 1 frequency
--           PCIE_USERCLK2_FREQ           : integer :=   3;           -- PCIe user clock 2 frequency
--           PCIE_DEBUG_MODE              : integer :=   0            -- PCIe Debug Mode
--     );
--     port  (
-- 
--           ------------ Input -------------------------------------
--           CLK_CLK                        : in std_logic;
--           CLK_TXOUTCLK                   : in std_logic;
--           CLK_RXOUTCLK_IN                : in std_logic_vector(0 downto 0);
--           CLK_RST_N                      : in std_logic;
--           CLK_PCLK_SEL                   : in std_logic_vector(0 downto 0);
--           CLK_GEN3                       : in std_logic;
-- 
--           ------------ Output ------------------------------------
--           CLK_PCLK                       : out std_logic;
--           CLK_RXUSRCLK                   : out std_logic;
--           CLK_RXOUTCLK_OUT               : out std_logic_vector(0 downto 0);
--           CLK_DCLK                       : out std_logic;
--           CLK_USERCLK1                   : out std_logic;
--           CLK_USERCLK2                   : out std_logic;
--           CLK_OOBCLK                     : out std_logic;
--           CLK_MMCM_LOCK                  : out std_logic);
--   end component;

  -----------------------------------------------------
  -- Transaction layer, receive interface
  -----------------------------------------------------
  component pcie_rx_axi is
    generic(
  	  NB_PCIE_AGENTS : integer := 3;
    --AGENT_TO_BAR   : integer_vector(NB_PCIE_AGENTS-1 downto 0);
      AGENT_TO_BAR   : integer_vector;
      C_DATA_WIDTH                                   : integer    := 64 -- pour l'instant le code est HARDCODE a 64 bits.
      );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                              : in    std_logic;
      sys_reset_n                          : in    std_logic;

      user_lnk_up                          : in    std_logic;
      ---------------------------------------------------------------------
      -- Transaction layer AXI receive interface
      ---------------------------------------------------------------------
	    -- RX
	    m_axis_rx_tdata                            : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
	    m_axis_rx_tkeep                            : in std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
	    m_axis_rx_tlast                            : in std_logic;
	    m_axis_rx_tvalid                           : in std_logic;
	    m_axis_rx_tready                           : out std_logic;
	    m_axis_rx_tuser                            : in std_logic_vector(21 downto 0);
	    rx_np_ok                                   : out std_logic;
	    rx_np_req                                  : out std_logic;

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------
    
      tlp_in_accept_data                   : in    std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_in_abort                         : in    std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      

      tlp_in_fmt_type                      : out   std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
      tlp_in_address                       : out   std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
      tlp_in_length_in_dw                  : out   std_logic_vector(10 downto 0); -- valeur maximal 4k
      tlp_in_attr                          : out   std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
      tlp_in_transaction_id                : out   std_logic_vector(23 downto 0); -- bus, device, function, tag
      tlp_in_valid                         : out   std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_in_data                          : out   std_logic_vector(31 downto 0);
      tlp_in_byte_en                       : out   std_logic_vector(3 downto 0);
      tlp_in_byte_count                    : out   std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables

      ---------------------------------------------------------------------
      -- Error detection
      ---------------------------------------------------------------------
      cfg_err_cpl_unexpect                 : out std_logic;
      cfg_err_posted                       : out std_logic;
      cfg_err_malformed                    : out std_logic;
      cfg_err_ur                           : out std_logic;
      cfg_err_cpl_abort                    : out std_logic;
      cfg_err_tlp_cpl_header               : out std_logic_vector(47 downto 0);
      cfg_err_cpl_rdy                      : in  std_logic;
      cfg_err_locked                       : out std_logic
    );
  end component;

  component pcie_reg is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                             : in    std_logic;
      sys_reset_n                         : in    std_logic;

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------
    
      tlp_in_accept_data                  : out std_logic;

      tlp_in_fmt_type                     : in  std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
      tlp_in_address                      : in  std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
      tlp_in_length_in_dw                 : in  std_logic_vector(10 downto 0);
      tlp_in_attr                         : in  std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
      tlp_in_transaction_id               : in  std_logic_vector(23 downto 0); -- bus, device, function, tag
      tlp_in_valid                        : in  std_logic;
      tlp_in_data                         : in  std_logic_vector(31 downto 0);
      tlp_in_byte_en                      : in  std_logic_vector(3 downto 0);
      tlp_in_byte_count                   : in  std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables

      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 : out std_logic;
      tlp_out_grant                       : in  std_logic;

      tlp_out_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
      tlp_out_length_in_dw                : out std_logic_vector(9 downto 0);

      tlp_out_src_rdy_n                   : out std_logic;
      tlp_out_dst_rdy_n                   : in  std_logic;
      tlp_out_data                        : out std_logic_vector(31 downto 0);

      -- for master request transmit
      tlp_out_address                     : out std_logic_vector(63 downto 2); 
      tlp_out_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
      tlp_out_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
      tlp_out_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
      tlp_out_lower_address               : out std_logic_vector(6 downto 0);

      ---------------------------------------------------------------------
      -- PCIe Register FIFO error detection
      ---------------------------------------------------------------------
      RESET_STR_REG_ERR                    : in    std_logic;
    
      reg_fifo_ovr                         : out   std_logic;
      reg_fifo_und                         : out   std_logic;

      ---------------------------------------------------------------------
      -- Memory Register file interface
      ---------------------------------------------------------------------
      reg_readdata                         : in    std_logic_vector(31 downto 0);
      reg_readdatavalid                    : in    std_logic;

      reg_addr                             : out   std_logic_vector;--(REG_ADDRMSB downto REG_ADDRLSB);
      reg_read                             : out   std_logic;
      reg_write                            : out   std_logic;
      reg_beN                              : out   std_logic_vector(3 downto 0);
      reg_writedata                        : out   std_logic_vector(31 downto 0)
    );
  end component;    


  component pcie_tx_axi is
    generic(
              NB_PCIE_AGENTS    : integer := 3;
              AGENT_IS_64_BIT   : std_logic_vector; -- l'item 0 DOIT etre a droite.
              C_DATA_WIDTH      : integer := 64 -- pour l'instant le code est HARDCODE a 64 bits.
            );
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                              : in    std_logic;
      sys_reset_n                          : in    std_logic;

      ---------------------------------------------------------------------
      -- Transaction layer AXI interface
      ---------------------------------------------------------------------
		  -- TX
		  --tx_buf_av                             : out std_logic_vector(5 downto 0); inutilise
		  --tx_cfg_req                           : out std_logic; inutilise
		  --tx_err_drop                           : out std_logic; inutilise
		  s_axis_tx_tready                      : in std_logic;
		  s_axis_tx_tdata                       : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
		  s_axis_tx_tkeep                       : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
		  s_axis_tx_tlast                       : out std_logic;
		  s_axis_tx_tvalid                      : out std_logic;
		  s_axis_tx_tuser                       : out std_logic_vector(3 downto 0);

      ---------------------------------------------------------------------
      -- Config information
      ---------------------------------------------------------------------
      cfg_bus_number                       : in    std_logic_vector(7 downto 0);
      cfg_device_number                    : in    std_logic_vector(4 downto 0);
      cfg_no_snoop_en                      : in    std_logic;
      cfg_relax_ord_en                     : in    std_logic;

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_grant                       : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);

      tlp_out_fmt_type                    : in  FMT_TYPE_ARRAY(NB_PCIE_AGENTS-1 downto 0);  -- fmt and type field 
      tlp_out_length_in_dw                : in  LENGTH_DW_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      tlp_out_src_rdy_n                   : in  std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_dst_rdy_n                   : out std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
      tlp_out_data                        : in  PCIE_DATA_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      -- for master request transmit
      tlp_out_address                     : in  PCIE_ADDRESS_ARRAY(NB_PCIE_AGENTS-1 downto 0); 
      tlp_out_ldwbe_fdwbe                 : in  LDWBE_FDWBE_ARRAY(NB_PCIE_AGENTS-1 downto 0);

      -- for completion transmit
      tlp_out_attr                        : in  ATTRIB_VECTOR(NB_PCIE_AGENTS-1 downto 0); -- relaxed ordering, no snoop
      tlp_out_transaction_id              : in  TRANS_ID(NB_PCIE_AGENTS-1 downto 0); -- bus, device, function, tag
      tlp_out_byte_count                  : in  BYTE_COUNT_ARRAY(NB_PCIE_AGENTS-1 downto 0); -- byte count tenant compte des byte enables
      tlp_out_lower_address               : in  LOWER_ADDR_ARRAY(NB_PCIE_AGENTS-1 downto 0)
     );
  end component;

  -- INT_a_n classique, et MSI
  component pcie_irq_axi is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                              : in    std_logic;
      sys_reset                            : in    std_logic;

      ---------------------------------------------------------------------
      -- Interrupt
      ---------------------------------------------------------------------
      int_status                           : in    std_logic_vector;
      msi_req                              : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur
      msi_ack                              : out   std_logic_vector;        -- confirmer l'envoie du MSI

      ---------------------------------------------------------------------
      -- PCIe core management interface
      ---------------------------------------------------------------------
      cfg_mgmt_do                         : in  std_logic_vector(31 downto 0);
      cfg_mgmt_rd_wr_done                 : in  std_logic;

      cfg_mgmt_di                         : out std_logic_vector(31 downto 0);
      cfg_mgmt_byte_en                    : out std_logic_vector(3 downto 0);
      cfg_mgmt_dwaddr                     : out std_logic_vector(9 downto 0);
      cfg_mgmt_wr_en                      : buffer std_logic;
      cfg_mgmt_rd_en                      : buffer std_logic;
      cfg_mgmt_wr_readonly                : out std_logic := '0';  -- on en a pas besoin, pour l'instant?

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_rdy                    : in std_logic;
      cfg_interrupt_msienable              : in std_logic;
      cfg_interrupt_mmenable               : in std_logic_vector(2 downto 0);
      cfg_interrupt_msixenable             : in std_logic;

      cfg_interrupt                        : out   std_logic;
      cfg_interrupt_di                     : out   std_logic_vector(7 downto 0);
      cfg_interrupt_assert                 : out   std_logic
    );
   end component;
 
  -- msi-x seulement
--   component pcie_msi_x is
--     generic(VECTOR_MSB : integer := 0);
--     port (
--       ---------------------------------------------------------------------
--       -- Reset and clock signals
--       ---------------------------------------------------------------------
--       sys_clk                             : in    std_logic;
--       sys_reset_n                         : in    std_logic;
-- 
--       ---------------------------------------------------------------------
--       -- New receive request interface
--       ---------------------------------------------------------------------
--     
--       tlp_in_accept_data                  : out std_logic;
-- 
--       tlp_in_fmt_type                     : in  std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
--       tlp_in_address                      : in  std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
--       tlp_in_length_in_dw                 : in  std_logic_vector(10 downto 0);
--       tlp_in_attr                         : in  std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
--       tlp_in_transaction_id               : in  std_logic_vector(23 downto 0); -- bus, device, function, tag
--       tlp_in_valid                        : in  std_logic;
--       tlp_in_data                         : in  std_logic_vector(31 downto 0);
--       tlp_in_byte_en                      : in  std_logic_vector(3 downto 0);
--       tlp_in_byte_count                   : in  std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
-- 
--       ---------------------------------------------------------------------
--       -- New transmit interface
--       ---------------------------------------------------------------------
--       tlp_out_req_to_send                 : out std_logic;
--       tlp_out_grant                       : in  std_logic;
-- 
--       tlp_out_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
--       tlp_out_length_in_dw                : out std_logic_vector(9 downto 0);
-- 
--       tlp_out_src_rdy_n                   : out std_logic;
--       tlp_out_dst_rdy_n                   : in  std_logic;
--       tlp_out_data                        : out std_logic_vector(31 downto 0);
-- 
--       -- for master request transmit
--       tlp_out_address                     : out std_logic_vector(63 downto 2); 
--       tlp_out_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);
-- 
--       -- for completion transmit
--       tlp_out_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
--       tlp_out_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
--       tlp_out_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
--       tlp_out_lower_address               : out std_logic_vector(6 downto 0);
--     
--       ---------------------------------------------------------------------
--       -- Interrupt
--       ---------------------------------------------------------------------
--       int_status                          : in    std_logic_vector(VECTOR_MSB downto 0);
-- 
--       ---------------------------------------------------------------------
--       -- PCIe core management interface
--       ---------------------------------------------------------------------
--       cfg_interrupt_msixenable            : in std_logic;
--       cfg_interrupt_msixfm                : in std_logic
-- 
--     );
--   end component;    

  component pcie_int_queue is
    port (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                             : in    std_logic;
      sys_reset                           : in    std_logic;

      ---------------------------------------------------------------------
      -- Interrupt IN
      ---------------------------------------------------------------------
      int_status                          : in    std_logic_vector; -- pour les interrupt classique seulement
      int_event                           : in    std_logic_vector; -- pour envoyer un MSI, 1 bit par vecteur

      ---------------------------------------------------------------------
      -- single interrupt OUT
      ---------------------------------------------------------------------
      queue_int_out                       : out   std_logic; 
      msi_req                             : out   std_logic;
      msi_ack                             : in    std_logic;

      regfile                             : in    INTERRUPT_QUEUE_TYPE;      -- definit dans int_queue_pak
    
      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 : out std_logic;
      tlp_out_grant                       : in  std_logic;

      tlp_out_fmt_type                    : out std_logic_vector(6 downto 0); -- fmt and type field 
      tlp_out_length_in_dw                : out std_logic_vector(9 downto 0);
      tlp_out_attr                        : out std_logic_vector(1 downto 0); -- relaxed ordering, no snoop

      tlp_out_src_rdy_n                   : out std_logic;
      tlp_out_dst_rdy_n                   : in  std_logic;
      tlp_out_data                        : out std_logic_vector(63 downto 0);

      -- for master request transmit
      tlp_out_address                     : out std_logic_vector(63 downto 2); 
      tlp_out_ldwbe_fdwbe                 : out std_logic_vector(7 downto 0);

      -- for completion transmit
      tlp_out_transaction_id              : out std_logic_vector(23 downto 0); -- bus, device, function, tag
      tlp_out_byte_count                  : out std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables
      tlp_out_lower_address               : out std_logic_vector(6 downto 0);

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_msienable              : in	std_logic;
      cfg_interrupt_msixenable             : in std_logic

    );
  end component;    

  ---------------------------------------------------------------------------
  --  Xilinx PCIe core
  ---------------------------------------------------------------------------
	signal sys_reset_buf_n                   : std_logic:= '0';
                                                             
  signal cfg_mgmt_do                            : std_logic_vector(31 downto 0);
  signal cfg_mgmt_rd_wr_done                    : std_logic;
  signal cfg_mgmt_di                            : std_logic_vector (31 downto 0) := (others => '0');
  signal cfg_mgmt_byte_en                       : std_logic_vector (3 downto 0) := (others => '0');
  signal cfg_mgmt_dwaddr                        : std_logic_vector (9 downto 0) := (others => '0');
  signal cfg_mgmt_wr_en                         : std_logic := '0';
  signal cfg_mgmt_rd_en                         : std_logic := '0';
  signal cfg_mgmt_wr_readonly                   : std_logic := '0';



  signal cfg_err_ur                      : std_logic := '1';
  signal cfg_err_ecrc                    : std_logic := '0'; -- on ne veux pas verifier nous-meme les CRCs
  signal cfg_err_cpl_abort               : std_logic := '0';
  signal cfg_err_cpl_unexpect            : std_logic;
  signal cfg_err_posted                  : std_logic := '1';
  signal cfg_err_malformed               : std_logic;
  signal cfg_err_tlp_cpl_header          : std_logic_vector(47 downto 0) := (others => '0');
  signal cfg_interrupt                   : std_logic;
  signal cfg_interrupt_rdy               : std_logic;
  signal cfg_interrupt_assert            : std_logic;
  signal cfg_interrupt_di                : std_logic_vector(7 downto 0);
  signal cfg_interrupt_do                : std_logic_vector(7 downto 0);
  signal cfg_interrupt_mmenable          : std_logic_vector(2 downto 0);
  signal cfg_interrupt_msienable         : std_logic;
  signal cfg_interrupt_msixenable        : std_logic;
  signal cfg_interrupt_msixfm            : std_logic;
  signal cfg_turnoff_ok                  : std_logic := '0'; 
  signal cfg_to_turnoff                  : std_logic;
  signal cfg_pm_wake                     : std_logic := '0';
  signal cfg_bus_number                  : std_logic_vector(7 downto 0);
  signal cfg_device_number               : std_logic_vector(4 downto 0);
  signal cfg_function_number             : std_logic_vector(2 downto 0);
  signal cfg_status                      : std_logic_vector(15 downto 0);
  signal cfg_command                     : std_logic_vector(15 downto 0);
  signal cfg_dstatus                     : std_logic_vector(15 downto 0);
  signal cfg_dcommand                    : std_logic_vector(15 downto 0);
  signal cfg_lstatus                     : std_logic_vector(15 downto 0);
  signal cfg_lcommand                    : std_logic_vector(15 downto 0);
  signal cfg_err_locked                  : std_logic := '1';
  signal cfg_err_cpl_rdy                 : std_logic;      

--signal received_hot_reset                : std_logic;

  ---------------------------------------------------------------------
  -- PCIe Register FILE (used by modules interfacing with PCIe core)
  ---------------------------------------------------------------------
  signal reg_read_buf                      : std_logic;
  signal reg_write_buf                     : std_logic;
  signal reg_beN_buf                       : std_logic_vector(3 downto 0);
  signal reg_writedata_buf                 : std_logic_vector(31 downto 0);

  ---------------------------------------------------------------------
  -- DMA - PCIe interface
  ---------------------------------------------------------------------
  signal cfg_no_snoop_en                   : std_logic;
  signal cfg_relax_ord_en                  : std_logic;

  ------------------------------
  -- nouvel interface interne --
  ------------------------------
  signal tlp_in_accept_data             : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '0');
  signal tlp_in_abort                   : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '0'); -- mis a 0 pour ne pas avoir d'effet sur les agents qui ne font jamais d'abort.

  signal tlp_in_fmt_type                : std_logic_vector(6 downto 0); -- fmt and type field from decoded packet 
  signal tlp_in_address                 : std_logic_vector(31 downto 0); -- 2 LSB a decoded from byte enables
  signal tlp_in_length_in_dw            : std_logic_vector(10 downto 0);
  signal tlp_in_attr                    : std_logic_vector(1 downto 0); -- relaxed ordering, no snoop
  signal tlp_in_transaction_id          : std_logic_vector(23 downto 0); -- bus, device, function, tag
  signal tlp_in_valid                   : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_in_data                    : std_logic_vector(31 downto 0);
  signal tlp_in_byte_en                 : std_logic_vector(3 downto 0);
  signal tlp_in_byte_count              : std_logic_vector(12 downto 0); -- byte count tenant compte des byte enables

  signal tlp_out_req_to_send            : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '0');
  signal tlp_out_grant                  : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  
  signal tlp_out_fmt_type               : FMT_TYPE_ARRAY(NB_PCIE_AGENTS-1 downto 0);  -- fmt and type field 
  signal tlp_out_length_in_dw           : LENGTH_DW_ARRAY(NB_PCIE_AGENTS-1 downto 0);
  
  signal tlp_out_src_rdy_n              : std_logic_vector(NB_PCIE_AGENTS-1 downto 0) := (others => '1');
  signal tlp_out_dst_rdy_n              : std_logic_vector(NB_PCIE_AGENTS-1 downto 0);
  signal tlp_out_data                   : PCIE_DATA_ARRAY(NB_PCIE_AGENTS-1 downto 0);

  -- for master request transmit
  signal tlp_out_address                : PCIE_ADDRESS_ARRAY(NB_PCIE_AGENTS-1 downto 0); 
  signal tlp_out_ldwbe_fdwbe            : LDWBE_FDWBE_ARRAY(NB_PCIE_AGENTS-1 downto 0);

  -- for completion transmit
  signal tlp_out_attr                   : ATTRIB_VECTOR(NB_PCIE_AGENTS-1 downto 0); -- relaxed ordering, no snoop
  signal tlp_out_transaction_id         : TRANS_ID(NB_PCIE_AGENTS-1 downto 0); -- bus, device, function, tag
  signal tlp_out_byte_count             : BYTE_COUNT_ARRAY(NB_PCIE_AGENTS-1 downto 0); -- byte count tenant compte des byte enables
  signal tlp_out_lower_address          : LOWER_ADDR_ARRAY(NB_PCIE_AGENTS-1 downto 0);

  signal sys_reset                      : std_logic;

  signal queue_int_status               : std_logic_vector(0 downto 0);
  signal msi_req                        : std_logic_vector(0 downto 0); -- ce code contient la queue d'interruption, donc une seul agent
  signal msi_ack                        : std_logic_vector(0 downto 0); -- ce code contient la queue d'interruption, donc une seul agent

	--------------------------------------
	-- Artix7 version of the core (AXI) --
	--------------------------------------
  -- Wires used for external clocking connectivity
  signal PIPE_PCLK_IN                       : std_logic;
  signal PIPE_RXUSRCLK_IN                   : std_logic;
  signal PIPE_RXOUTCLK_IN                   : std_logic_vector(LINK_CAP_MAX_LINK_WIDTH_int - 1 downto 0);
  signal PIPE_DCLK_IN                       : std_logic;
  signal PIPE_USERCLK1_IN                   : std_logic;
  signal PIPE_USERCLK2_IN                   : std_logic;
  signal PIPE_OOBCLK_IN                     : std_logic;
  signal PIPE_MMCM_LOCK_IN                  : std_logic;

  signal PIPE_TXOUTCLK_OUT                  : std_logic;
  signal PIPE_RXOUTCLK_OUT                  : std_logic_vector(LINK_CAP_MAX_LINK_WIDTH_int - 1 downto 0);
  signal PIPE_PCLK_SEL_OUT                  : std_logic_vector(LINK_CAP_MAX_LINK_WIDTH_int - 1 downto 0);
  signal PIPE_GEN3_OUT                      : std_logic;
  signal PIPE_MMCM_RST_N                    : std_logic := '1';

	signal user_reset                         : std_logic;
	signal user_lnk_up                       : std_logic;

	-- Flow Control
	--signal fc_cpld                                    : std_logic_vector(11 downto 0);
	--signal fc_cplh                                    : std_logic_vector(7 downto 0);
	--signal fc_npd                                     : std_logic_vector(11 downto 0);
	--signal fc_nph                                     : std_logic_vector(7 downto 0);
	--signal fc_pd                                      : std_logic_vector(11 downto 0);
	--signal fc_ph                                      : std_logic_vector(7 downto 0);
	signal fc_sel                                     : std_logic_vector(2 downto 0) := "000"; -- section inutilise dans notre design

  -- pour faire des assertions de simulation
  signal tx_err_drop                                : std_logic;

	-- AXI transmit interface
  signal s_axis_tx_tready                           : std_logic;
  signal s_axis_tx_tdata                            : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
  signal s_axis_tx_tkeep                            : std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
  signal s_axis_tx_tlast                            : std_logic;
  signal s_axis_tx_tvalid                           : std_logic;
  signal s_axis_tx_tuser                            : std_logic_vector(3 downto 0);

  -- AXI receive interface
  signal m_axis_rx_tdata                            : std_logic_vector((C_DATA_WIDTH - 1) downto 0);
  signal m_axis_rx_tkeep                            : std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
  signal m_axis_rx_tlast                            : std_logic;
  signal m_axis_rx_tvalid                           : std_logic;
  signal m_axis_rx_tready                           : std_logic;
  signal m_axis_rx_tuser                            : std_logic_vector(21 downto 0);
  signal rx_np_ok                                   : std_logic;
  signal rx_np_req                                  : std_logic;

  -- patch qui indique quel est notre agent DMA (donc celui qui ne reponds jamais au requetes BAR.
  constant DMA_AGENT_NUMBER : integer := NB_PCIE_AGENTS-1;

begin

  
  -- les fifo xilinx utilisent des reset positif, alors on place la logique aussi en posistif ici au lieu de changer ca de bord dans chaque module

  -- on va presumer qu'on n'aura pas le meme probleme de timing sur A7 pour l'instant
	sys_reset <= user_reset;
	sys_reset_buf_n <= not user_reset;

	-- Assigning output port
	sys_reset_n <= sys_reset_buf_n;
  
	reg_read      <= reg_read_buf;
	reg_write     <= reg_write_buf;
	reg_beN       <= reg_beN_buf;
	reg_writedata <= reg_writedata_buf;

  -- Ici on a un seul agent externe qui envoie des TLP. Le DMA pour l'instant. Donc avant de generaliser pour avoir des vecteur de vecteur a l'externe, on fera un 
  -- remapping de l'interface d'envoie de TLP ici.
  -- officiellement il faudra generaliser la generation de ce fichier pour les multiples variations: Avec ou sans IO BAR, 1 ou 2 bar registre, 0 ou 1 interface memoire, avec ou sans DMA
  -- et ceci, soit avec des generiques, soit avec plusieurs version de ce fichier de pcie_top. Ca reste a voir. 
  dmagen: if USE_DMA generate
    tlp_out_req_to_send(DMA_AGENT_NUMBER)    <= dma_tlp_req_to_send;

    tlp_out_fmt_type(DMA_AGENT_NUMBER)       <= dma_tlp_fmt_type;
    tlp_out_length_in_dw(DMA_AGENT_NUMBER)   <= dma_tlp_length_in_dw;       

    tlp_out_src_rdy_n(DMA_AGENT_NUMBER)      <= dma_tlp_src_rdy_n;          
    tlp_out_data(DMA_AGENT_NUMBER)           <= dma_tlp_data;               

    -- for master request transmit 
    tlp_out_address(DMA_AGENT_NUMBER)        <= dma_tlp_address;            
    tlp_out_ldwbe_fdwbe(DMA_AGENT_NUMBER)    <= dma_tlp_ldwbe_fdwbe;        

    -- for completion transmit
    tlp_out_attr(DMA_AGENT_NUMBER)           <= dma_tlp_attr;               
    tlp_out_transaction_id(DMA_AGENT_NUMBER) <= dma_tlp_transaction_id;     
    tlp_out_byte_count(DMA_AGENT_NUMBER)     <= dma_tlp_byte_count;         
    tlp_out_lower_address(DMA_AGENT_NUMBER)  <= dma_tlp_lower_address;      

    dma_tlp_grant           <= tlp_out_grant(DMA_AGENT_NUMBER);
    dma_tlp_dst_rdy_n       <= tlp_out_dst_rdy_n(DMA_AGENT_NUMBER); 
  end generate;
  
  -- Connecting DMA requester
   
  cfg_no_snoop_en  <= cfg_dcommand(11);
  cfg_relax_ord_en <= cfg_dcommand(4);

  cfg_bus_mast_en  <= cfg_command(2);
  cfg_setmaxpld    <= cfg_dcommand(7 downto 5);

-------------------------------------------------------
-- instantiations
-------------------------------------------------------
  
--   -- Generate External Clock Module if External Clocking is selected
--   ext_clk: if (not(PCIE_EXT_CLK = "FALSE")) generate
--   pipe_clock_i : xil_pcie_axi_pipe_clock
--   generic map(
--           PCIE_ASYNC_EN                  => "FALSE",             -- PCIe async enable
--           PCIE_TXBUF_EN                  => "FALSE",             -- PCIe TX buffer enable for Gen1/Gen2 only
--           PCIE_LANE                      => 1,              -- PCIe number of lanes
--           PCIE_LINK_SPEED                => LNK_SPD ,            -- PCIe link speed
--           PCIE_REFCLK_FREQ               => 0,             -- PCIe reference clock frequency
--           PCIE_USERCLK1_FREQ             => (USER_CLK_FREQ +1),  -- PCIe user clock 1 frequency
--           PCIE_USERCLK2_FREQ             => (USERCLK2_FREQ +1),  -- PCIe user clock 2 frequency
--           PCIE_DEBUG_MODE                => 0 )                  -- PCIe Debug Mode
--   port map(
--           ------------ Input -------------------------------------
--           CLK_CLK                        => pcie_sys_clk,
--           CLK_TXOUTCLK                   => PIPE_TXOUTCLK_OUT,       -- Reference clock from lane 0
--           CLK_RXOUTCLK_IN                => PIPE_RXOUTCLK_OUT,
--         -- CLK_RST_N                      => '1',
--           CLK_RST_N                      => PIPE_MMCM_RST_N,
--           CLK_PCLK_SEL                   => PIPE_PCLK_SEL_OUT,
--           CLK_GEN3                       => PIPE_GEN3_OUT,
-- 
--           ------------ Output ------------------------------------
--           CLK_PCLK                       => PIPE_PCLK_IN,
--           CLK_RXUSRCLK                   => PIPE_RXUSRCLK_IN,
--           CLK_RXOUTCLK_OUT               => PIPE_RXOUTCLK_IN,
--           CLK_DCLK                       => PIPE_DCLK_IN,
--           CLK_USERCLK1                   => PIPE_USERCLK1_IN,
--           CLK_USERCLK2                   => PIPE_USERCLK2_IN,
--           CLK_OOBCLK                     => PIPE_OOBCLK_IN,
--           CLK_MMCM_LOCK                  => PIPE_MMCM_LOCK_IN
--         );
--   end generate;

  int_clk: if ((PCIE_EXT_CLK = "FALSE")) generate
    PIPE_PCLK_IN        <= '0';
    PIPE_RXUSRCLK_IN    <= '0';
    PIPE_RXOUTCLK_IN    <= (others => '0');
    PIPE_DCLK_IN        <= '0';
    PIPE_USERCLK1_IN    <= '0';
    PIPE_USERCLK2_IN    <= '0';
    PIPE_OOBCLK_IN      <= '0';
    PIPE_MMCM_LOCK_IN   <= '0';
  end generate;

  xxil_pcie : pcie_7x
--   generic map (
--     CFG_REV_ID    => REVISION_ID,
-- 		PCIE_EXT_CLK  => PCIE_EXT_CLK--,
--     PL_FAST_TRAIN =>   PL_FAST_TRAIN,
--     CFG_SUBSYS_ID => X"0000" -- incorrect de determiner cette valeur par generique en general, mais acceptable pour Athena. 
--                              -- La bonne chose a faire est de le faire passer par port au lieu de par generique, comme on le faisait 
--                              -- sur spartan6. Je le ferai dans une revision ulterieure de l'instantiation du core, question que le 
--                              -- changement soit facile a voir dans le SVN.
--   )
  port map (
		--CFG_SUBSYS_ID_in        => CFG_SUBSYS_ID_in,
		-------------------------------------------------------------------------------------------------------------------
		-- 1. PCI Express (pci_exp) Interface                                                                            --
		-------------------------------------------------------------------------------------------------------------------
		pci_exp_txp             => pci_exp_txp,
		pci_exp_txn             => pci_exp_txn,
		pci_exp_rxp             => pci_exp_rxp,
		pci_exp_rxn             => pci_exp_rxn,

		-------------------------------------------------------------------------------------------------------------------
		-- 2. Clocking Interface  - For Partial Reconfig Support                                                         --
		-------------------------------------------------------------------------------------------------------------------
-- 		PIPE_PCLK_IN                               => PIPE_PCLK_IN,
-- 		PIPE_RXUSRCLK_IN                           => PIPE_RXUSRCLK_IN,
-- 		PIPE_RXOUTCLK_IN                           => PIPE_RXOUTCLK_IN,
-- 		PIPE_DCLK_IN                               => PIPE_DCLK_IN,
-- 		PIPE_USERCLK1_IN                           => PIPE_USERCLK1_IN,
-- 		PIPE_USERCLK2_IN                           => PIPE_USERCLK2_IN,
-- 		PIPE_OOBCLK_IN                             => PIPE_OOBCLK_IN,
-- 		PIPE_MMCM_LOCK_IN                          => PIPE_MMCM_LOCK_IN,
-- 
-- 		PIPE_TXOUTCLK_OUT                          => PIPE_TXOUTCLK_OUT,
-- 		PIPE_RXOUTCLK_OUT                          => PIPE_RXOUTCLK_OUT,
-- 		PIPE_PCLK_SEL_OUT                          => PIPE_PCLK_SEL_OUT,
-- 		PIPE_GEN3_OUT                              => PIPE_GEN3_OUT,

		-------------------------------------------------------------------------------------------------------------------
		-- 3. AXI-S Interface                                                                                            --
		-------------------------------------------------------------------------------------------------------------------
		-- Common
		user_clk_out                               => sys_clk,
		user_reset_out                             => user_reset,
		user_lnk_up                                => user_lnk_up,

    --user_app_rdy nous n'utilisons pas le tandem

		-- TX
		--tx_buf_av                                  : out std_logic_vector(5 downto 0); inutilise
		--tx_cfg_req                                 : out std_logic; inutilise
		tx_err_drop                                => tx_err_drop,
		s_axis_tx_tready                           => s_axis_tx_tready,
		s_axis_tx_tdata                            => s_axis_tx_tdata, 
		s_axis_tx_tkeep                            => s_axis_tx_tkeep, 
		s_axis_tx_tlast                            => s_axis_tx_tlast, 
		s_axis_tx_tvalid                           => s_axis_tx_tvalid,
		s_axis_tx_tuser                            => s_axis_tx_tuser, 
		tx_cfg_gnt                                 => '1', -- on permet toujours au core d'envoyer ses reponses 

		-- RX
		m_axis_rx_tdata                            => m_axis_rx_tdata,
		m_axis_rx_tkeep                            => m_axis_rx_tkeep,
		m_axis_rx_tlast                            => m_axis_rx_tlast,
		m_axis_rx_tvalid                           => m_axis_rx_tvalid,
		m_axis_rx_tready                           => m_axis_rx_tready,
		m_axis_rx_tuser                            => m_axis_rx_tuser,
		rx_np_ok                                   => rx_np_ok,
		rx_np_req                                  => rx_np_req,

		-- Flow Control
		--fc_cpld                                    : out std_logic_vector(11 downto 0);
		--fc_cplh                                    : out std_logic_vector(7 downto 0);
		--fc_npd                                     : out std_logic_vector(11 downto 0);
		--fc_nph                                     : out std_logic_vector(7 downto 0);
		--fc_pd                                      : out std_logic_vector(11 downto 0);
		--fc_ph                                      : out std_logic_vector(7 downto 0);
		--fc_sel                                     => fc_sel,

		-------------------------------------------------------------------------------------------------------------------
		-- 4. Configuration (CFG) Interface                                                                              --
		-------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------
		-- EP and RP                                                      --
		---------------------------------------------------------------------
		cfg_mgmt_do                                 => cfg_mgmt_do,
		cfg_mgmt_rd_wr_done                         => cfg_mgmt_rd_wr_done,
                                                
    --cfg_status                                  => cfg_status,               
    cfg_command                                 => cfg_command,              
    cfg_dstatus                                 => cfg_dstatus,              
    cfg_dcommand                                => cfg_dcommand,             
    cfg_lstatus                                 => cfg_lstatus,              
    cfg_lcommand                                => cfg_lcommand,             
		--cfg_dcommand2                              : out std_logic_vector(15 downto 0);
		--cfg_pcie_link_state                        : out std_logic_vector(2 downto 0);

		--cfg_pmcsr_pme_en                           : out std_logic;
		--cfg_pmcsr_powerstate                       : out std_logic_vector(1 downto 0);
		--cfg_pmcsr_pme_status                       : out std_logic;
		--cfg_received_func_lvl_rst                  : out std_logic;

		-- Management Interface
		cfg_mgmt_di                                 => cfg_mgmt_di,         
		cfg_mgmt_byte_en                            => cfg_mgmt_byte_en,    
		cfg_mgmt_dwaddr                             => cfg_mgmt_dwaddr,     
		cfg_mgmt_wr_en                              => cfg_mgmt_wr_en,      
		cfg_mgmt_rd_en                              => cfg_mgmt_rd_en,      
		cfg_mgmt_wr_readonly                        => cfg_mgmt_wr_readonly,

		-- Error Reporting Interface
    cfg_err_ecrc                                => cfg_err_ecrc,
		cfg_err_ur                                  => cfg_err_ur,
		cfg_err_cpl_timeout                         => '0', -- on ne fait jamais de read master, donc on attend jamais de completion
		cfg_err_cpl_unexpect                        => cfg_err_cpl_unexpect,
    cfg_err_cpl_abort                           => cfg_err_cpl_abort,

		cfg_err_posted                              => cfg_err_posted,
		cfg_err_cor                                 => '0', -- on ne rapporte pas d'erreur corrigeable.
		cfg_err_atomic_egress_blocked               => '0', -- on traite toute les requete atomique avec un Unsupported Request, donc on ne block rien
		cfg_err_internal_cor                        => '0', -- AER seulement
		cfg_err_malformed                           => cfg_err_malformed,
		cfg_err_mc_blocked                          => '0', -- on ne fait pas de traitement particulier pour les multicasts.
		cfg_err_poisoned                            => '0', -- pas utile car DISABLE_RX_POISONED_RESP est false
		cfg_err_norecovery                          => '0', -- on n'utilise pas poisoned ou timeout, alors c'est inutile
    cfg_err_tlp_cpl_header                      => cfg_err_tlp_cpl_header,   
		cfg_err_cpl_rdy                             => cfg_err_cpl_rdy,
		cfg_err_locked                              => cfg_err_locked,
		cfg_err_acs                                 => '0', -- le ACS, c'est pour le root complex, switch ou les multi-fonction, donc jamais notre cas.
		cfg_err_internal_uncor                      => '0', -- AER seulement
		cfg_trn_pending                             => '0', -- on ne fait jamais de requete non-posted
		cfg_pm_halt_aspm_l0s                        => '0', -- on ne veut pas limiter le power management a priori
		cfg_pm_halt_aspm_l1                         => '0', -- on ne veut pas limiter le power management a priori
		cfg_pm_force_state_en                       => '0', -- on ne veut pas force l'etat du lien, a priori
		cfg_pm_force_state                          => "00", -- on ne veut pas force l'etat du lien, a priori
		cfg_dsn                                     => x"0000000000000000",

		---------------------------------------------------------------------
		-- EP Only                                                        --
		---------------------------------------------------------------------
    cfg_interrupt                               => cfg_interrupt,
    cfg_interrupt_rdy                           => cfg_interrupt_rdy,
    cfg_interrupt_assert                        => cfg_interrupt_assert,
    cfg_interrupt_do                            => cfg_interrupt_do,         
    cfg_interrupt_di                            => cfg_interrupt_di,         
    cfg_interrupt_mmenable                      => cfg_interrupt_mmenable,   
    cfg_interrupt_msienable                     => cfg_interrupt_msienable,

		cfg_interrupt_msixenable                    => cfg_interrupt_msixenable,
		cfg_interrupt_msixfm                        => cfg_interrupt_msixfm,
		cfg_interrupt_stat                          => '0', -- on ne veux pas overrider le mechanisme de generation d'interrupt interne alors ce bit devrait etre don't-care.
		cfg_pciecap_interrupt_msgnum                => "00000", -- doit etre mis-a-jour si on active le multiple message Enable avec les MSIs. Ce n'est pas le cas pour l'instant
		cfg_to_turnoff                              => cfg_to_turnoff, -- devrait etre utilise pour flusher tous les paquets en sortie.
		cfg_turnoff_ok                              => cfg_turnoff_ok, -- presentement, on refuse de se mettre a OFF dans tous les cas. C'est a revoir
    cfg_bus_number                              => cfg_bus_number,           
    cfg_device_number                           => cfg_device_number,        
    cfg_function_number                         => cfg_function_number,      
		cfg_pm_wake                                 => '0', -- on ne veut pas reveiller le lien PCIe

		---------------------------------------------------------------------
		-- RP Only                                                        --
		---------------------------------------------------------------------
		cfg_pm_send_pme_to                          => '0',
		cfg_ds_bus_number                           => x"00",
		cfg_ds_device_number                        => "00000",
		cfg_ds_function_number                      => "000",

		cfg_mgmt_wr_rw1c_as_rw                      => '0',
		--cfg_msg_received                           : out std_logic;
		--cfg_msg_data                               : out std_logic_vector(15 downto 0);

		--cfg_bridge_serr_en                         : out std_logic;
		--cfg_slot_control_electromech_il_ctl_pulse  : out std_logic;
		--cfg_root_control_syserr_corr_err_en        : out std_logic;
		--cfg_root_control_syserr_non_fatal_err_en   : out std_logic;
		--cfg_root_control_syserr_fatal_err_en       : out std_logic;
		--cfg_root_control_pme_int_en                : out std_logic;
		--cfg_aer_rooterr_corr_err_reporting_en      : out std_logic;
		--cfg_aer_rooterr_non_fatal_err_reporting_en : out std_logic;
		--cfg_aer_rooterr_fatal_err_reporting_en     : out std_logic;
		--cfg_aer_rooterr_corr_err_received          : out std_logic;
		--cfg_aer_rooterr_non_fatal_err_received     : out std_logic;
		--cfg_aer_rooterr_fatal_err_received         : out std_logic;

		--cfg_msg_received_err_cor                   : out std_logic;
		--cfg_msg_received_err_non_fatal             : out std_logic;
		--cfg_msg_received_err_fatal                 : out std_logic;
		--cfg_msg_received_pm_as_nak                 : out std_logic;
		--cfg_msg_received_pm_pme                    : out std_logic;
		--cfg_msg_received_pme_to_ack                : out std_logic;
		--cfg_msg_received_assert_int_a              : out std_logic;
		--cfg_msg_received_assert_int_b              : out std_logic;
		--cfg_msg_received_assert_int_c              : out std_logic;
		--cfg_msg_received_assert_int_d              : out std_logic;
		--cfg_msg_received_deassert_int_a            : out std_logic;
		--cfg_msg_received_deassert_int_b            : out std_logic;
		--cfg_msg_received_deassert_int_c            : out std_logic;
		--cfg_msg_received_deassert_int_d            : out std_logic;
		--cfg_msg_received_setslotpowerlimit         : out std_logic;
    
		-------------------------------------------------------------------------------------------------------------------
		-- 5. Physical Layer Control and Status (PL) Interface                                                           --
		-------------------------------------------------------------------------------------------------------------------
		--pl_directed_link_change                    => "00", -- on ne veut pas changer le link pour l'instant
		--pl_directed_link_width                     => "00", -- on ne veut pas changer le link pour l'instant
		--pl_directed_link_speed                     => '0', -- on ne veut pas changer le link pour l'instant
		--pl_directed_link_auton                     => '0', -- on ne veut pas changer le link pour l'instant
		--pl_upstream_prefer_deemph                  => '0', -- on ne veut pas changer le link pour l'instant

		--pl_sel_lnk_rate                            : out std_logic;
		--pl_sel_lnk_width                           : out std_logic_vector(1 downto 0);
		--pl_ltssm_state                             : out std_logic_vector(5 downto 0);
		--pl_lane_reversal_mode                      : out std_logic_vector(1 downto 0);

		--pl_phy_lnk_up                              : out std_logic;
		--pl_tx_pm_state                             : out std_logic_vector(2 downto 0);
		--pl_rx_pm_state                             : out std_logic_vector(1 downto 0);
    
		--pl_link_upcfg_cap                          : out std_logic;
		--pl_link_gen2_cap                           : out std_logic;
		--pl_link_partner_gen2_supported             : out std_logic;
		--pl_initial_link_width                      : out std_logic_vector(2 downto 0);

		--pl_directed_change_done                    : out std_logic;

		---------------------------------------------------------------------
		-- EP Only                                                        --
		---------------------------------------------------------------------
		--pl_received_hot_rst                        : out std_logic;  -- un Hot Reset devrait generer un reset de toute facon, sinon un link-down qu'on va pogner autrement


		---------------------------------------------------------------------
		-- RP Only                                                        --
		---------------------------------------------------------------------
		--pl_transmit_hot_rst                        => '0',
		--pl_downstream_deemph_source                => '0',
		-------------------------------------------------------------------------------------------------------------------
		-- 6. AER interface                                                                                              --
		-------------------------------------------------------------------------------------------------------------------
		cfg_err_aer_headerlog                      => x"00000000000000000000000000000000", -- AER non-utilise
		cfg_aer_interrupt_msgnum                   => "00000",-- AER non-utilise
		--cfg_err_aer_headerlog_set                  : out std_logic;
		--cfg_aer_ecrc_check_en                      : out std_logic;
		--cfg_aer_ecrc_gen_en                        : out std_logic;
		-------------------------------------------------------------------------------------------------------------------
		-- 7. VC interface                                                                                               --
		-------------------------------------------------------------------------------------------------------------------
		--cfg_vc_tcvc_map                            : out std_logic_vector(6 downto 0);

		-------------------------------------------------------------------------------------------------------------------
		-- 8. System(SYS) Interface                                                                                      --
		-------------------------------------------------------------------------------------------------------------------
		--PIPE_MMCM_RST_N                             => PIPE_MMCM_RST_N,  -- PG055 semble suggerer que driver 1 sur ce canal est correct.     // Async      | Async
		sys_clk                                     => pcie_sys_clk,
		sys_rst_n                                   => pcie_sys_rst_n
        
        --pcie_drp_clk   =>   pcie_drp_clk, 
        --pcie_drp_en    =>   pcie_drp_en,  
        --pcie_drp_we    =>   pcie_drp_we,  
        --pcie_drp_addr  =>   pcie_drp_addr,
        --pcie_drp_di    =>   pcie_drp_di,  
        --pcie_drp_do    =>   pcie_drp_do,  
        --pcie_drp_rdy   =>   pcie_drp_rdy 
  );

  -- J'ai observe en simulation des paquets perdu. Peut-importe la raison, on veut pogner ça instantannément en simulation, pas débugger pendant 2 jours pour trouver la source
  drocheckprc:process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      assert tx_err_drop = '0' report "SIGNAL TX_ERR_DROP VENANT DU PCIe ACTIF. C'EST UNE SITUATION ANORMALE!" severity FAILURE;
    end if;
  end process;

xpcie_rx : pcie_rx_axi
  generic map (
    NB_PCIE_AGENTS => NB_PCIE_AGENTS,
    AGENT_TO_BAR   => (2 => 7,
                       1 => 7, -- la queue n'a pas de BAR associe
                       0 => 0),
    C_DATA_WIDTH   => 64
  )
  port map (

    ---------------------------------------------------------------------
    -- Reset and clock signals
    ---------------------------------------------------------------------
    sys_clk                              => sys_clk,
    sys_reset_n                          => sys_reset_buf_n,


    user_lnk_up                          => user_lnk_up,
    ---------------------------------------------------------------------
    -- Transaction layer AXI receive interface
    ---------------------------------------------------------------------
	  -- RX
	  m_axis_rx_tdata                      => m_axis_rx_tdata,      
	  m_axis_rx_tkeep                      => m_axis_rx_tkeep,      
	  m_axis_rx_tlast                      => m_axis_rx_tlast,      
	  m_axis_rx_tvalid                     => m_axis_rx_tvalid,     
	  m_axis_rx_tready                     => m_axis_rx_tready,     
	  m_axis_rx_tuser                      => m_axis_rx_tuser,
	  rx_np_ok                             => rx_np_ok,
	  rx_np_req                            => rx_np_req,
                                         
    ---------------------------------------------------------------------
    -- New receive request interface
    ---------------------------------------------------------------------
    
    tlp_in_accept_data                   => tlp_in_accept_data,   
    tlp_in_abort                         => tlp_in_abort,
                                          
    tlp_in_fmt_type                      => tlp_in_fmt_type,       
    tlp_in_address                       => tlp_in_address,       
    tlp_in_length_in_dw                  => tlp_in_length_in_dw,  
    tlp_in_attr                          => tlp_in_attr,          
    tlp_in_transaction_id                => tlp_in_transaction_id,
    tlp_in_valid                         => tlp_in_valid,         
    tlp_in_data                          => tlp_in_data,          
    tlp_in_byte_en                       => tlp_in_byte_en,       
    tlp_in_byte_count                    => tlp_in_byte_count,
                                         
    ---------------------------------------------------------------------
    -- Error detection
    ---------------------------------------------------------------------
    cfg_err_cpl_unexpect                 => cfg_err_cpl_unexpect,
    cfg_err_posted                       => cfg_err_posted,
    cfg_err_malformed                    => cfg_err_malformed,
    cfg_err_ur                           => cfg_err_ur,
    cfg_err_cpl_abort                    => cfg_err_cpl_abort,
    cfg_err_tlp_cpl_header               => cfg_err_tlp_cpl_header,
    cfg_err_cpl_rdy                      => cfg_err_cpl_rdy,
    cfg_err_locked                       => cfg_err_locked
  );

  bar0_pcie_reg: pcie_reg 
    port map(
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                             => sys_clk,
      sys_reset_n                         => sys_reset_buf_n,

      ---------------------------------------------------------------------
      -- New receive request interface
      ---------------------------------------------------------------------
      tlp_in_accept_data                  => tlp_in_accept_data(0),

      tlp_in_fmt_type                     => tlp_in_fmt_type,      
      tlp_in_address                      => tlp_in_address,       
      tlp_in_length_in_dw                 => tlp_in_length_in_dw,  
      tlp_in_attr                         => tlp_in_attr,          
      tlp_in_transaction_id               => tlp_in_transaction_id,
      tlp_in_valid                        => tlp_in_valid(0),         
      tlp_in_data                         => tlp_in_data,          
      tlp_in_byte_en                      => tlp_in_byte_en,       
      tlp_in_byte_count                   => tlp_in_byte_count,

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 => tlp_out_req_to_send(0),
      tlp_out_grant                       => tlp_out_grant(0),

      tlp_out_fmt_type                    => tlp_out_fmt_type(0),
      tlp_out_length_in_dw                => tlp_out_length_in_dw(0),   
                                                                 
      tlp_out_src_rdy_n                   => tlp_out_src_rdy_n(0),
      tlp_out_dst_rdy_n                   => tlp_out_dst_rdy_n(0),
      tlp_out_data                        => tlp_out_data(0)(31 downto 0),
                                                                  
      -- for master request transmit      
--      tlp_out_address                     => tlp_out_address,        
--      tlp_out_ldwbe_fdwbe                 => tlp_out_ldwbe_fdwbe,
                                                                
      -- for completion transmit          
      tlp_out_attr                        => tlp_out_attr(0),           
      tlp_out_transaction_id              => tlp_out_transaction_id(0), 
      tlp_out_byte_count                  => tlp_out_byte_count(0),     
      tlp_out_lower_address               => tlp_out_lower_address(0),  

      ---------------------------------------------------------------------
      -- PCIe Register FIFO error detection
      ---------------------------------------------------------------------
      RESET_STR_REG_ERR                    => '0', --RESET_STR_REG_ERR,
    
      ---------------------------------------------------------------------
      -- Memory Register file interface
      ---------------------------------------------------------------------
      reg_readdata                        => reg_readdata,
      reg_readdatavalid                   => reg_readdatavalid,

      reg_addr                            => reg_addr,--_buf,
      reg_read                            => reg_read_buf,
      reg_write                           => reg_write_buf,
      reg_beN                             => reg_beN_buf,
      reg_writedata                       => reg_writedata_buf
    );
  


  xpcie_tx : pcie_tx_axi
    generic map(
  	  NB_PCIE_AGENTS  => NB_PCIE_AGENTS,
      AGENT_IS_64_BIT => "110",  -- ce fichier hardcode deja que 0 = reg = 32bits, 1 = int queue = 64 bits, 2 = DMA = 64bits. -- l'item 0 DOIT etre a droite.
      C_DATA_WIDTH    => 64
    )
    port map (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                              => sys_clk,
      sys_reset_n                          => sys_reset_buf_n,

      ---------------------------------------------------------------------
      -- Transaction layer AXI interface
      ---------------------------------------------------------------------
		  -- TX
		  --tx_buf_av                                  =
		  --tx_cfg_req                                 : out std_logic; inutilise
		  --tx_err_drop                                : out std_logic; inutilise
		  s_axis_tx_tready                           => s_axis_tx_tready,
		  s_axis_tx_tdata                            => s_axis_tx_tdata, 
		  s_axis_tx_tkeep                            => s_axis_tx_tkeep, 
		  s_axis_tx_tlast                            => s_axis_tx_tlast, 
		  s_axis_tx_tvalid                           => s_axis_tx_tvalid,
		  s_axis_tx_tuser                            => s_axis_tx_tuser, 

      ---------------------------------------------------------------------
      -- Config information
      ---------------------------------------------------------------------
      cfg_bus_number                       => cfg_bus_number,
      cfg_device_number                    => cfg_device_number,

      cfg_no_snoop_en                      => cfg_no_snoop_en,
      cfg_relax_ord_en                     => cfg_relax_ord_en,

      ---------------------------------------------------------------------
      -- New transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 => tlp_out_req_to_send,
      tlp_out_grant                       => tlp_out_grant,

      tlp_out_fmt_type                    => tlp_out_fmt_type,
      tlp_out_length_in_dw                => tlp_out_length_in_dw,           
                                                                          
      tlp_out_src_rdy_n                   => tlp_out_src_rdy_n,              
      tlp_out_dst_rdy_n                   => tlp_out_dst_rdy_n,              
      tlp_out_data                        => tlp_out_data,                   
                                                                          
      -- for master request transmit      
      tlp_out_address                     => tlp_out_address,                
      tlp_out_ldwbe_fdwbe                 => tlp_out_ldwbe_fdwbe,            
                                                                          
      -- for completion transmit          
      tlp_out_attr                        => tlp_out_attr,                   
      tlp_out_transaction_id              => tlp_out_transaction_id,         
      tlp_out_byte_count                  => tlp_out_byte_count,             
      tlp_out_lower_address               => tlp_out_lower_address
    );
    
  -- Si on envoie des donnes invalides au core PCIe (comme du 'U' ou du 'X'), cela genere un mauvais TLP et fera planter le lien PCIe et eventuellement la simulation.
  -- c'est relativement fastidieux de reculer dans le simulation pour trouver le probleme, alors l'assertion plus bas devrait faire apparaitre la source du probleme plus rapidement
  tdatacheckprc: process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if s_axis_tx_tvalid = '1' then -- si on est en train de transmettre des donnes au core PCIe
        for i in s_axis_tx_tdata'range loop
          assert (s_axis_tx_tdata(i) = '0' or s_axis_tx_tdata(i) = '1' or s_axis_tx_tkeep(i/8) = '0') report "Valeur illegale sur s_axis_tx_tdata qui brisera le lien PCIe a ce moment-ci!" severity FAILURE;
        end loop;
      end if;
    end if;
  end process;

  xpcie_int_queue: pcie_int_queue
    port map(
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                             => sys_clk,
      sys_reset                           => user_reset,

      ---------------------------------------------------------------------
      -- Interrupt IN
      ---------------------------------------------------------------------
      int_status                          => int_status,    -- pour les interrupt classique seulement
      int_event                           => int_event,     -- pour envoyer un MSI, 1 bit par vecteur

      ---------------------------------------------------------------------
      -- single interrupt OUT
      ---------------------------------------------------------------------
      queue_int_out                       => queue_int_status(0),
      msi_req                             => msi_req(0),
      msi_ack                             => msi_ack(0),

      regfile                             => regfile,
    
      ---------------------------------------------------------------------
      -- transmit interface
      ---------------------------------------------------------------------
      tlp_out_req_to_send                 => tlp_out_req_to_send(1),
      tlp_out_grant                       => tlp_out_grant(1),

      tlp_out_fmt_type                    => tlp_out_fmt_type(1),
      tlp_out_length_in_dw                => tlp_out_length_in_dw(1),   
      tlp_out_attr                        => tlp_out_attr(1),                       
                                          
      tlp_out_src_rdy_n                   => tlp_out_src_rdy_n(1),         
      tlp_out_dst_rdy_n                   => tlp_out_dst_rdy_n(1),
      tlp_out_data                        => tlp_out_data(1),
                                          
      -- for master request transmit         
      tlp_out_address                     => tlp_out_address(1),    
      tlp_out_ldwbe_fdwbe                 => tlp_out_ldwbe_fdwbe(1),                      
                                          
      -- for completion transmit                     
      tlp_out_transaction_id              => tlp_out_transaction_id(1), 
      tlp_out_byte_count                  => tlp_out_byte_count(1),     
      tlp_out_lower_address               => tlp_out_lower_address(1),  

      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_msienable             => cfg_interrupt_msienable,
      cfg_interrupt_msixenable            => cfg_interrupt_msixenable

    );

  xpcie_irq : pcie_irq_axi
    port map (
      ---------------------------------------------------------------------
      -- Reset and clock signals
      ---------------------------------------------------------------------
      sys_clk                              => sys_clk,
      sys_reset                            => user_reset,

      ---------------------------------------------------------------------
      -- Interrupt
      ---------------------------------------------------------------------
      int_status                           => queue_int_status,
      msi_req                              => msi_req,
      msi_ack                              => msi_ack,

      ---------------------------------------------------------------------
      -- PCIe core management interface
      ---------------------------------------------------------------------
      cfg_mgmt_do                          => cfg_mgmt_do,         
      cfg_mgmt_rd_wr_done                  => cfg_mgmt_rd_wr_done, 

      cfg_mgmt_di                          => cfg_mgmt_di,         
      cfg_mgmt_byte_en                     => cfg_mgmt_byte_en,    
      cfg_mgmt_dwaddr                      => cfg_mgmt_dwaddr,     
      cfg_mgmt_wr_en                       => cfg_mgmt_wr_en,      
      cfg_mgmt_rd_en                       => cfg_mgmt_rd_en,      
      cfg_mgmt_wr_readonly                 => cfg_mgmt_wr_readonly,
                                           
      ---------------------------------------------------------------------
      -- PCIe core user interrupt interface
      ---------------------------------------------------------------------
      cfg_interrupt_rdy                    => cfg_interrupt_rdy,
      cfg_interrupt_msienable              => cfg_interrupt_msienable,
      cfg_interrupt_mmenable               => cfg_interrupt_mmenable,
      cfg_interrupt_msixenable             => cfg_interrupt_msixenable,

      cfg_interrupt                        => cfg_interrupt,
      cfg_interrupt_di                     => cfg_interrupt_di,
      cfg_interrupt_assert                 => cfg_interrupt_assert
    );

  -- Je desactive temporairement le MSI-X puisqu'avec l'architecture de MIL il n'est pas possible d'utiliser plusieurs vecteurs.
  -- xmsix: pcie_msi_x 
  --   generic map (VECTOR_MSB => int_status'high)
  --   port map(
  --     ---------------------------------------------------------------------
  --     -- Reset and clock signals
  --     ---------------------------------------------------------------------
  --     sys_clk                             => sys_clk,
  --     sys_reset_n                         => sys_reset_buf_n,
  -- 
  --     ---------------------------------------------------------------------
  --     -- receive request interface
  --     ---------------------------------------------------------------------
  --     tlp_in_accept_data                  => tlp_in_accept_data(1),
  -- 
  --     tlp_in_fmt_type                     => tlp_in_fmt_type,      
  --     tlp_in_address                      => tlp_in_address,       
  --     tlp_in_length_in_dw                 => tlp_in_length_in_dw,  
  --     tlp_in_attr                         => tlp_in_attr,          
  --     tlp_in_transaction_id               => tlp_in_transaction_id,
  --     tlp_in_valid                        => tlp_in_valid(1),         
  --     tlp_in_data                         => tlp_in_data,          
  --     tlp_in_byte_en                      => tlp_in_byte_en,       
  --     tlp_in_byte_count                   => tlp_in_byte_count,
  -- 
  --     ---------------------------------------------------------------------
  --     -- transmit interface
  --     ---------------------------------------------------------------------
  --     tlp_out_req_to_send                 => tlp_out_req_to_send(1),
  --     tlp_out_grant                       => tlp_out_grant(1),
  -- 
  --     tlp_out_fmt_type                    => tlp_out_fmt_type(1),
  --     tlp_out_length_in_dw                => tlp_out_length_in_dw(1),   
  --                                                                
  --     tlp_out_src_rdy_n                   => tlp_out_src_rdy_n(1),
  --     tlp_out_dst_rdy_n                   => tlp_out_dst_rdy_n(1),
  --     tlp_out_data                        => tlp_out_data(1)(31 downto 0),
  --                                                                 
  --     -- for master request transmit      
  --     tlp_out_address                     => tlp_out_address(1),        
  --     tlp_out_ldwbe_fdwbe                 => tlp_out_ldwbe_fdwbe(1),
  --                                                               
  --     -- for completion transmit          
  --     tlp_out_attr                        => tlp_out_attr(1),           
  --     tlp_out_transaction_id              => tlp_out_transaction_id(1), 
  --     tlp_out_byte_count                  => tlp_out_byte_count(1),     
  --     tlp_out_lower_address               => tlp_out_lower_address(1),  
  -- 
  --     ---------------------------------------------------------------------
  --     -- Interrupt
  --     ---------------------------------------------------------------------
  --     int_status                          => int_status,
  -- 
  --     ---------------------------------------------------------------------
  --     -- PCIe core management interface
  --     ---------------------------------------------------------------------
  --     cfg_interrupt_msixenable            => cfg_interrupt_msixenable,
  --     cfg_interrupt_msixfm                => cfg_interrupt_msixfm    
  --   );


end functional;
    