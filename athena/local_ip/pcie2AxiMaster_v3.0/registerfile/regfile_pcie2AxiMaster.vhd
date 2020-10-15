-------------------------------------------------------------------------------
-- File                : regfile_pcie2AxiMaster.vhd
-- Project             : FDK
-- Module              : regfile_pcie2AxiMaster_pack
-- Created on          : 2020/09/15 18:41:27
-- Created by          : amarchan
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xC43C8CD6
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_pcie2AxiMaster_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_info_tag_ADDR                    : natural := 16#0#;
   constant K_info_fid_ADDR                    : natural := 16#4#;
   constant K_info_version_ADDR                : natural := 16#8#;
   constant K_info_capability_ADDR             : natural := 16#c#;
   constant K_info_scratchpad_ADDR             : natural := 16#10#;
   constant K_fpga_version_ADDR                : natural := 16#20#;
   constant K_fpga_build_id_ADDR               : natural := 16#24#;
   constant K_fpga_device_ADDR                 : natural := 16#28#;
   constant K_fpga_board_info_ADDR             : natural := 16#2c#;
   constant K_interrupts_ctrl_ADDR             : natural := 16#40#;
   constant K_interrupts_status_0_ADDR         : natural := 16#44#;
   constant K_interrupts_status_1_ADDR         : natural := 16#48#;
   constant K_interrupts_enable_0_ADDR         : natural := 16#4c#;
   constant K_interrupts_enable_1_ADDR         : natural := 16#50#;
   constant K_interrupts_mask_0_ADDR           : natural := 16#54#;
   constant K_interrupts_mask_1_ADDR           : natural := 16#58#;
   constant K_interrupt_queue_control_ADDR     : natural := 16#60#;
   constant K_interrupt_queue_cons_idx_ADDR    : natural := 16#64#;
   constant K_interrupt_queue_addr_low_ADDR    : natural := 16#68#;
   constant K_interrupt_queue_addr_high_ADDR   : natural := 16#6c#;
   constant K_tlp_timeout_ADDR                 : natural := 16#70#;
   constant K_tlp_transaction_abort_cntr_ADDR  : natural := 16#74#;
   constant K_spi_SPIREGIN_ADDR                : natural := 16#e0#;
   constant K_spi_SPIREGOUT_ADDR               : natural := 16#e8#;
   constant K_arbiter_ARBITER_CAPABILITIES_ADDR : natural := 16#f0#;
   constant K_arbiter_AGENT_0_ADDR             : natural := 16#f4#;
   constant K_arbiter_AGENT_1_ADDR             : natural := 16#f8#;
   constant K_axi_window_0_ctrl_ADDR           : natural := 16#100#;
   constant K_axi_window_0_pci_bar0_start_ADDR : natural := 16#104#;
   constant K_axi_window_0_pci_bar0_stop_ADDR  : natural := 16#108#;
   constant K_axi_window_0_axi_translation_ADDR : natural := 16#10c#;
   constant K_axi_window_1_ctrl_ADDR           : natural := 16#110#;
   constant K_axi_window_1_pci_bar0_start_ADDR : natural := 16#114#;
   constant K_axi_window_1_pci_bar0_stop_ADDR  : natural := 16#118#;
   constant K_axi_window_1_axi_translation_ADDR : natural := 16#11c#;
   constant K_axi_window_2_ctrl_ADDR           : natural := 16#120#;
   constant K_axi_window_2_pci_bar0_start_ADDR : natural := 16#124#;
   constant K_axi_window_2_pci_bar0_stop_ADDR  : natural := 16#128#;
   constant K_axi_window_2_axi_translation_ADDR : natural := 16#12c#;
   constant K_axi_window_3_ctrl_ADDR           : natural := 16#130#;
   constant K_axi_window_3_pci_bar0_start_ADDR : natural := 16#134#;
   constant K_axi_window_3_pci_bar0_stop_ADDR  : natural := 16#138#;
   constant K_axi_window_3_axi_translation_ADDR : natural := 16#13c#;
   constant K_debug_input_ADDR                 : natural := 16#200#;
   constant K_debug_output_ADDR                : natural := 16#204#;
   constant K_debug_DMA_DEBUG1_ADDR            : natural := 16#208#;
   constant K_debug_DMA_DEBUG2_ADDR            : natural := 16#20c#;
   constant K_debug_DMA_DEBUG3_ADDR            : natural := 16#210#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: tag
   ------------------------------------------------------------------------------------------
   type INFO_TAG_TYPE is record
      value          : std_logic_vector(23 downto 0);
   end record INFO_TAG_TYPE;

   constant INIT_INFO_TAG_TYPE : INFO_TAG_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_TAG_TYPE) return std_logic_vector;
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_TAG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: fid
   ------------------------------------------------------------------------------------------
   type INFO_FID_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_FID_TYPE;

   constant INIT_INFO_FID_TYPE : INFO_FID_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_FID_TYPE) return std_logic_vector;
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_FID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: version
   ------------------------------------------------------------------------------------------
   type INFO_VERSION_TYPE is record
      major          : std_logic_vector(7 downto 0);
      minor          : std_logic_vector(7 downto 0);
      sub_minor      : std_logic_vector(7 downto 0);
   end record INFO_VERSION_TYPE;

   constant INIT_INFO_VERSION_TYPE : INFO_VERSION_TYPE := (
      major           => (others=> 'Z'),
      minor           => (others=> 'Z'),
      sub_minor       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_VERSION_TYPE) return std_logic_vector;
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_VERSION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: capability
   ------------------------------------------------------------------------------------------
   type INFO_CAPABILITY_TYPE is record
      value          : std_logic_vector(7 downto 0);
   end record INFO_CAPABILITY_TYPE;

   constant INIT_INFO_CAPABILITY_TYPE : INFO_CAPABILITY_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_CAPABILITY_TYPE) return std_logic_vector;
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_CAPABILITY_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: scratchpad
   ------------------------------------------------------------------------------------------
   type INFO_SCRATCHPAD_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INFO_SCRATCHPAD_TYPE;

   constant INIT_INFO_SCRATCHPAD_TYPE : INFO_SCRATCHPAD_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INFO_SCRATCHPAD_TYPE) return std_logic_vector;
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCHPAD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: version
   ------------------------------------------------------------------------------------------
   type FPGA_VERSION_TYPE is record
      firmware_type  : std_logic_vector(7 downto 0);
      major          : std_logic_vector(7 downto 0);
      minor          : std_logic_vector(7 downto 0);
      sub_minor      : std_logic_vector(7 downto 0);
   end record FPGA_VERSION_TYPE;

   constant INIT_FPGA_VERSION_TYPE : FPGA_VERSION_TYPE := (
      firmware_type   => (others=> 'Z'),
      major           => (others=> 'Z'),
      minor           => (others=> 'Z'),
      sub_minor       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : FPGA_VERSION_TYPE) return std_logic_vector;
   function to_FPGA_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_VERSION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: build_id
   ------------------------------------------------------------------------------------------
   type FPGA_BUILD_ID_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record FPGA_BUILD_ID_TYPE;

   constant INIT_FPGA_BUILD_ID_TYPE : FPGA_BUILD_ID_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : FPGA_BUILD_ID_TYPE) return std_logic_vector;
   function to_FPGA_BUILD_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_BUILD_ID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: device
   ------------------------------------------------------------------------------------------
   type FPGA_DEVICE_TYPE is record
      id             : std_logic_vector(7 downto 0);
   end record FPGA_DEVICE_TYPE;

   constant INIT_FPGA_DEVICE_TYPE : FPGA_DEVICE_TYPE := (
      id              => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : FPGA_DEVICE_TYPE) return std_logic_vector;
   function to_FPGA_DEVICE_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_DEVICE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: board_info
   ------------------------------------------------------------------------------------------
   type FPGA_BOARD_INFO_TYPE is record
      capability     : std_logic_vector(3 downto 0);
   end record FPGA_BOARD_INFO_TYPE;

   constant INIT_FPGA_BOARD_INFO_TYPE : FPGA_BOARD_INFO_TYPE := (
      capability      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : FPGA_BOARD_INFO_TYPE) return std_logic_vector;
   function to_FPGA_BOARD_INFO_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_BOARD_INFO_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_CTRL_TYPE is record
      sw_irq         : std_logic;
      num_irq        : std_logic_vector(6 downto 0);
      global_mask    : std_logic;
   end record INTERRUPTS_CTRL_TYPE;

   constant INIT_INTERRUPTS_CTRL_TYPE : INTERRUPTS_CTRL_TYPE := (
      sw_irq          => 'Z',
      num_irq         => (others=> 'Z'),
      global_mask     => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPTS_CTRL_TYPE) return std_logic_vector;
   function to_INTERRUPTS_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: status
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_STATUS_TYPE is record
      value          : std_logic_vector(31 downto 0);
      value_set      : std_logic_vector(31 downto 0);
   end record INTERRUPTS_STATUS_TYPE;

   constant INIT_INTERRUPTS_STATUS_TYPE : INTERRUPTS_STATUS_TYPE := (
      value           => (others=> 'Z'),
      value_set       => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: INTERRUPTS_STATUS_TYPE
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_STATUS_TYPE_ARRAY is array (1 downto 0) of INTERRUPTS_STATUS_TYPE;
   constant INIT_INTERRUPTS_STATUS_TYPE_ARRAY : INTERRUPTS_STATUS_TYPE_ARRAY := (others => INIT_INTERRUPTS_STATUS_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPTS_STATUS_TYPE) return std_logic_vector;
   function to_INTERRUPTS_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_STATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: enable
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_ENABLE_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INTERRUPTS_ENABLE_TYPE;

   constant INIT_INTERRUPTS_ENABLE_TYPE : INTERRUPTS_ENABLE_TYPE := (
      value           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: INTERRUPTS_ENABLE_TYPE
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_ENABLE_TYPE_ARRAY is array (1 downto 0) of INTERRUPTS_ENABLE_TYPE;
   constant INIT_INTERRUPTS_ENABLE_TYPE_ARRAY : INTERRUPTS_ENABLE_TYPE_ARRAY := (others => INIT_INTERRUPTS_ENABLE_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPTS_ENABLE_TYPE) return std_logic_vector;
   function to_INTERRUPTS_ENABLE_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_ENABLE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: mask
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_MASK_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record INTERRUPTS_MASK_TYPE;

   constant INIT_INTERRUPTS_MASK_TYPE : INTERRUPTS_MASK_TYPE := (
      value           => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: INTERRUPTS_MASK_TYPE
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_MASK_TYPE_ARRAY is array (1 downto 0) of INTERRUPTS_MASK_TYPE;
   constant INIT_INTERRUPTS_MASK_TYPE_ARRAY : INTERRUPTS_MASK_TYPE_ARRAY := (others => INIT_INTERRUPTS_MASK_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPTS_MASK_TYPE) return std_logic_vector;
   function to_INTERRUPTS_MASK_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_MASK_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: control
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_CONTROL_TYPE is record
      nb_dw          : std_logic_vector(7 downto 0);
      enable         : std_logic;
   end record INTERRUPT_QUEUE_CONTROL_TYPE;

   constant INIT_INTERRUPT_QUEUE_CONTROL_TYPE : INTERRUPT_QUEUE_CONTROL_TYPE := (
      nb_dw           => (others=> 'Z'),
      enable          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONTROL_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_CONTROL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONTROL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: cons_idx
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_CONS_IDX_TYPE is record
      cons_idx       : std_logic_vector(9 downto 0);
   end record INTERRUPT_QUEUE_CONS_IDX_TYPE;

   constant INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE : INTERRUPT_QUEUE_CONS_IDX_TYPE := (
      cons_idx        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONS_IDX_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_CONS_IDX_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONS_IDX_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: addr_low
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_ADDR_LOW_TYPE is record
      addr           : std_logic_vector(31 downto 0);
   end record INTERRUPT_QUEUE_ADDR_LOW_TYPE;

   constant INIT_INTERRUPT_QUEUE_ADDR_LOW_TYPE : INTERRUPT_QUEUE_ADDR_LOW_TYPE := (
      addr            => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_LOW_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_ADDR_LOW_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_LOW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: addr_high
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_ADDR_HIGH_TYPE is record
      addr           : std_logic_vector(31 downto 0);
   end record INTERRUPT_QUEUE_ADDR_HIGH_TYPE;

   constant INIT_INTERRUPT_QUEUE_ADDR_HIGH_TYPE : INTERRUPT_QUEUE_ADDR_HIGH_TYPE := (
      addr            => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_HIGH_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: timeout
   ------------------------------------------------------------------------------------------
   type TLP_TIMEOUT_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record TLP_TIMEOUT_TYPE;

   constant INIT_TLP_TIMEOUT_TYPE : TLP_TIMEOUT_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TLP_TIMEOUT_TYPE) return std_logic_vector;
   function to_TLP_TIMEOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return TLP_TIMEOUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: transaction_abort_cntr
   ------------------------------------------------------------------------------------------
   type TLP_TRANSACTION_ABORT_CNTR_TYPE is record
      clr            : std_logic;
      value          : std_logic_vector(30 downto 0);
   end record TLP_TRANSACTION_ABORT_CNTR_TYPE;

   constant INIT_TLP_TRANSACTION_ABORT_CNTR_TYPE : TLP_TRANSACTION_ABORT_CNTR_TYPE := (
      clr             => 'Z',
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TLP_TRANSACTION_ABORT_CNTR_TYPE) return std_logic_vector;
   function to_TLP_TRANSACTION_ABORT_CNTR_TYPE(stdlv : std_logic_vector(31 downto 0)) return TLP_TRANSACTION_ABORT_CNTR_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SPIREGIN
   ------------------------------------------------------------------------------------------
   type SPI_SPIREGIN_TYPE is record
      SPI_OLD_ENABLE : std_logic;
      SPI_ENABLE     : std_logic;
      SPIRW          : std_logic;
      SPICMDDONE     : std_logic;
      SPISEL         : std_logic;
      SPITXST        : std_logic;
      SPIDATAW       : std_logic_vector(7 downto 0);
   end record SPI_SPIREGIN_TYPE;

   constant INIT_SPI_SPIREGIN_TYPE : SPI_SPIREGIN_TYPE := (
      SPI_OLD_ENABLE  => 'Z',
      SPI_ENABLE      => 'Z',
      SPIRW           => 'Z',
      SPICMDDONE      => 'Z',
      SPISEL          => 'Z',
      SPITXST         => 'Z',
      SPIDATAW        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SPI_SPIREGIN_TYPE) return std_logic_vector;
   function to_SPI_SPIREGIN_TYPE(stdlv : std_logic_vector(31 downto 0)) return SPI_SPIREGIN_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: SPIREGOUT
   ------------------------------------------------------------------------------------------
   type SPI_SPIREGOUT_TYPE is record
      SPI_WB_CAP     : std_logic;
      SPIWRTD        : std_logic;
      SPIDATARD      : std_logic_vector(7 downto 0);
   end record SPI_SPIREGOUT_TYPE;

   constant INIT_SPI_SPIREGOUT_TYPE : SPI_SPIREGOUT_TYPE := (
      SPI_WB_CAP      => 'Z',
      SPIWRTD         => 'Z',
      SPIDATARD       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : SPI_SPIREGOUT_TYPE) return std_logic_vector;
   function to_SPI_SPIREGOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return SPI_SPIREGOUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ARBITER_CAPABILITIES
   ------------------------------------------------------------------------------------------
   type ARBITER_ARBITER_CAPABILITIES_TYPE is record
      AGENT_NB       : std_logic_vector(1 downto 0);
      TAG            : std_logic_vector(11 downto 0);
   end record ARBITER_ARBITER_CAPABILITIES_TYPE;

   constant INIT_ARBITER_ARBITER_CAPABILITIES_TYPE : ARBITER_ARBITER_CAPABILITIES_TYPE := (
      AGENT_NB        => (others=> 'Z'),
      TAG             => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ARBITER_ARBITER_CAPABILITIES_TYPE) return std_logic_vector;
   function to_ARBITER_ARBITER_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ARBITER_ARBITER_CAPABILITIES_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: AGENT
   ------------------------------------------------------------------------------------------
   type ARBITER_AGENT_TYPE is record
      ACK            : std_logic;
      REC            : std_logic;
      DONE           : std_logic;
      REQ            : std_logic;
   end record ARBITER_AGENT_TYPE;

   constant INIT_ARBITER_AGENT_TYPE : ARBITER_AGENT_TYPE := (
      ACK             => 'Z',
      REC             => 'Z',
      DONE            => 'Z',
      REQ             => 'Z'
   );

   ------------------------------------------------------------------------------------------
   -- Array type: ARBITER_AGENT_TYPE
   ------------------------------------------------------------------------------------------
   type ARBITER_AGENT_TYPE_ARRAY is array (1 downto 0) of ARBITER_AGENT_TYPE;
   constant INIT_ARBITER_AGENT_TYPE_ARRAY : ARBITER_AGENT_TYPE_ARRAY := (others => INIT_ARBITER_AGENT_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : ARBITER_AGENT_TYPE) return std_logic_vector;
   function to_ARBITER_AGENT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ARBITER_AGENT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ctrl
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_CTRL_TYPE is record
      enable         : std_logic;
   end record AXI_WINDOW_CTRL_TYPE;

   constant INIT_AXI_WINDOW_CTRL_TYPE : AXI_WINDOW_CTRL_TYPE := (
      enable          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : AXI_WINDOW_CTRL_TYPE) return std_logic_vector;
   function to_AXI_WINDOW_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_CTRL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: pci_bar0_start
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_PCI_BAR0_START_TYPE is record
      value          : std_logic_vector(25 downto 0);
   end record AXI_WINDOW_PCI_BAR0_START_TYPE;

   constant INIT_AXI_WINDOW_PCI_BAR0_START_TYPE : AXI_WINDOW_PCI_BAR0_START_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : AXI_WINDOW_PCI_BAR0_START_TYPE) return std_logic_vector;
   function to_AXI_WINDOW_PCI_BAR0_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_START_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: pci_bar0_stop
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_PCI_BAR0_STOP_TYPE is record
      value          : std_logic_vector(25 downto 0);
   end record AXI_WINDOW_PCI_BAR0_STOP_TYPE;

   constant INIT_AXI_WINDOW_PCI_BAR0_STOP_TYPE : AXI_WINDOW_PCI_BAR0_STOP_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : AXI_WINDOW_PCI_BAR0_STOP_TYPE) return std_logic_vector;
   function to_AXI_WINDOW_PCI_BAR0_STOP_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_STOP_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: axi_translation
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_AXI_TRANSLATION_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record AXI_WINDOW_AXI_TRANSLATION_TYPE;

   constant INIT_AXI_WINDOW_AXI_TRANSLATION_TYPE : AXI_WINDOW_AXI_TRANSLATION_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : AXI_WINDOW_AXI_TRANSLATION_TYPE) return std_logic_vector;
   function to_AXI_WINDOW_AXI_TRANSLATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_AXI_TRANSLATION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: input
   ------------------------------------------------------------------------------------------
   type DEBUG_INPUT_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DEBUG_INPUT_TYPE;

   constant INIT_DEBUG_INPUT_TYPE : DEBUG_INPUT_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_INPUT_TYPE) return std_logic_vector;
   function to_DEBUG_INPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_INPUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: output
   ------------------------------------------------------------------------------------------
   type DEBUG_OUTPUT_TYPE is record
      value          : std_logic_vector(31 downto 0);
   end record DEBUG_OUTPUT_TYPE;

   constant INIT_DEBUG_OUTPUT_TYPE : DEBUG_OUTPUT_TYPE := (
      value           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_OUTPUT_TYPE) return std_logic_vector;
   function to_DEBUG_OUTPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_OUTPUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DMA_DEBUG1
   ------------------------------------------------------------------------------------------
   type DEBUG_DMA_DEBUG1_TYPE is record
      ADD_START      : std_logic_vector(31 downto 0);
   end record DEBUG_DMA_DEBUG1_TYPE;

   constant INIT_DEBUG_DMA_DEBUG1_TYPE : DEBUG_DMA_DEBUG1_TYPE := (
      ADD_START       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG1_TYPE) return std_logic_vector;
   function to_DEBUG_DMA_DEBUG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DMA_DEBUG2
   ------------------------------------------------------------------------------------------
   type DEBUG_DMA_DEBUG2_TYPE is record
      ADD_OVERRUN    : std_logic_vector(31 downto 0);
   end record DEBUG_DMA_DEBUG2_TYPE;

   constant INIT_DEBUG_DMA_DEBUG2_TYPE : DEBUG_DMA_DEBUG2_TYPE := (
      ADD_OVERRUN     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG2_TYPE) return std_logic_vector;
   function to_DEBUG_DMA_DEBUG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DMA_DEBUG3
   ------------------------------------------------------------------------------------------
   type DEBUG_DMA_DEBUG3_TYPE is record
      DMA_ADD_ERROR  : std_logic;
      DMA_OVERRUN    : std_logic;
   end record DEBUG_DMA_DEBUG3_TYPE;

   constant INIT_DEBUG_DMA_DEBUG3_TYPE : DEBUG_DMA_DEBUG3_TYPE := (
      DMA_ADD_ERROR   => 'Z',
      DMA_OVERRUN     => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG3_TYPE) return std_logic_vector;
   function to_DEBUG_DMA_DEBUG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG3_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: info
   ------------------------------------------------------------------------------------------
   type INFO_TYPE is record
      tag            : INFO_TAG_TYPE;
      fid            : INFO_FID_TYPE;
      version        : INFO_VERSION_TYPE;
      capability     : INFO_CAPABILITY_TYPE;
      scratchpad     : INFO_SCRATCHPAD_TYPE;
   end record INFO_TYPE;

   constant INIT_INFO_TYPE : INFO_TYPE := (
      tag             => INIT_INFO_TAG_TYPE,
      fid             => INIT_INFO_FID_TYPE,
      version         => INIT_INFO_VERSION_TYPE,
      capability      => INIT_INFO_CAPABILITY_TYPE,
      scratchpad      => INIT_INFO_SCRATCHPAD_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: fpga
   ------------------------------------------------------------------------------------------
   type FPGA_TYPE is record
      version        : FPGA_VERSION_TYPE;
      build_id       : FPGA_BUILD_ID_TYPE;
      device         : FPGA_DEVICE_TYPE;
      board_info     : FPGA_BOARD_INFO_TYPE;
   end record FPGA_TYPE;

   constant INIT_FPGA_TYPE : FPGA_TYPE := (
      version         => INIT_FPGA_VERSION_TYPE,
      build_id        => INIT_FPGA_BUILD_ID_TYPE,
      device          => INIT_FPGA_DEVICE_TYPE,
      board_info      => INIT_FPGA_BOARD_INFO_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: interrupts
   ------------------------------------------------------------------------------------------
   type INTERRUPTS_TYPE is record
      ctrl           : INTERRUPTS_CTRL_TYPE;
      status         : INTERRUPTS_STATUS_TYPE_ARRAY;
      enable         : INTERRUPTS_ENABLE_TYPE_ARRAY;
      mask           : INTERRUPTS_MASK_TYPE_ARRAY;
   end record INTERRUPTS_TYPE;

   constant INIT_INTERRUPTS_TYPE : INTERRUPTS_TYPE := (
      ctrl            => INIT_INTERRUPTS_CTRL_TYPE,
      status          => INIT_INTERRUPTS_STATUS_TYPE_ARRAY,
      enable          => INIT_INTERRUPTS_ENABLE_TYPE_ARRAY,
      mask            => INIT_INTERRUPTS_MASK_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: interrupt_queue
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_TYPE is record
      control        : INTERRUPT_QUEUE_CONTROL_TYPE;
      cons_idx       : INTERRUPT_QUEUE_CONS_IDX_TYPE;
      addr_low       : INTERRUPT_QUEUE_ADDR_LOW_TYPE;
      addr_high      : INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
   end record INTERRUPT_QUEUE_TYPE;

   constant INIT_INTERRUPT_QUEUE_TYPE : INTERRUPT_QUEUE_TYPE := (
      control         => INIT_INTERRUPT_QUEUE_CONTROL_TYPE,
      cons_idx        => INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE,
      addr_low        => INIT_INTERRUPT_QUEUE_ADDR_LOW_TYPE,
      addr_high       => INIT_INTERRUPT_QUEUE_ADDR_HIGH_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: tlp
   ------------------------------------------------------------------------------------------
   type TLP_TYPE is record
      timeout        : TLP_TIMEOUT_TYPE;
      transaction_abort_cntr: TLP_TRANSACTION_ABORT_CNTR_TYPE;
   end record TLP_TYPE;

   constant INIT_TLP_TYPE : TLP_TYPE := (
      timeout         => INIT_TLP_TIMEOUT_TYPE,
      transaction_abort_cntr => INIT_TLP_TRANSACTION_ABORT_CNTR_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: spi
   ------------------------------------------------------------------------------------------
   type SPI_TYPE is record
      SPIREGIN       : SPI_SPIREGIN_TYPE;
      SPIREGOUT      : SPI_SPIREGOUT_TYPE;
   end record SPI_TYPE;

   constant INIT_SPI_TYPE : SPI_TYPE := (
      SPIREGIN        => INIT_SPI_SPIREGIN_TYPE,
      SPIREGOUT       => INIT_SPI_SPIREGOUT_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: arbiter
   ------------------------------------------------------------------------------------------
   type ARBITER_TYPE is record
      ARBITER_CAPABILITIES: ARBITER_ARBITER_CAPABILITIES_TYPE;
      AGENT          : ARBITER_AGENT_TYPE_ARRAY;
   end record ARBITER_TYPE;

   constant INIT_ARBITER_TYPE : ARBITER_TYPE := (
      ARBITER_CAPABILITIES => INIT_ARBITER_ARBITER_CAPABILITIES_TYPE,
      AGENT           => INIT_ARBITER_AGENT_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: axi_window
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_TYPE is record
      ctrl           : AXI_WINDOW_CTRL_TYPE;
      pci_bar0_start : AXI_WINDOW_PCI_BAR0_START_TYPE;
      pci_bar0_stop  : AXI_WINDOW_PCI_BAR0_STOP_TYPE;
      axi_translation: AXI_WINDOW_AXI_TRANSLATION_TYPE;
   end record AXI_WINDOW_TYPE;

   constant INIT_AXI_WINDOW_TYPE : AXI_WINDOW_TYPE := (
      ctrl            => INIT_AXI_WINDOW_CTRL_TYPE,
      pci_bar0_start  => INIT_AXI_WINDOW_PCI_BAR0_START_TYPE,
      pci_bar0_stop   => INIT_AXI_WINDOW_PCI_BAR0_STOP_TYPE,
      axi_translation => INIT_AXI_WINDOW_AXI_TRANSLATION_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Array type: AXI_WINDOW_TYPE
   ------------------------------------------------------------------------------------------
   type AXI_WINDOW_TYPE_ARRAY is array (3 downto 0) of AXI_WINDOW_TYPE;
   constant INIT_AXI_WINDOW_TYPE_ARRAY : AXI_WINDOW_TYPE_ARRAY := (others => INIT_AXI_WINDOW_TYPE);
   ------------------------------------------------------------------------------------------
   -- Section Name: debug
   ------------------------------------------------------------------------------------------
   type DEBUG_TYPE is record
      input          : DEBUG_INPUT_TYPE;
      output         : DEBUG_OUTPUT_TYPE;
      DMA_DEBUG1     : DEBUG_DMA_DEBUG1_TYPE;
      DMA_DEBUG2     : DEBUG_DMA_DEBUG2_TYPE;
      DMA_DEBUG3     : DEBUG_DMA_DEBUG3_TYPE;
   end record DEBUG_TYPE;

   constant INIT_DEBUG_TYPE : DEBUG_TYPE := (
      input           => INIT_DEBUG_INPUT_TYPE,
      output          => INIT_DEBUG_OUTPUT_TYPE,
      DMA_DEBUG1      => INIT_DEBUG_DMA_DEBUG1_TYPE,
      DMA_DEBUG2      => INIT_DEBUG_DMA_DEBUG2_TYPE,
      DMA_DEBUG3      => INIT_DEBUG_DMA_DEBUG3_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_pcie2AxiMaster
   ------------------------------------------------------------------------------------------
   type REGFILE_PCIE2AXIMASTER_TYPE is record
      info           : INFO_TYPE;
      fpga           : FPGA_TYPE;
      interrupts     : INTERRUPTS_TYPE;
      interrupt_queue: INTERRUPT_QUEUE_TYPE;
      tlp            : TLP_TYPE;
      spi            : SPI_TYPE;
      arbiter        : ARBITER_TYPE;
      axi_window     : AXI_WINDOW_TYPE_array;
      debug          : DEBUG_TYPE;
   end record REGFILE_PCIE2AXIMASTER_TYPE;

   constant INIT_REGFILE_PCIE2AXIMASTER_TYPE : REGFILE_PCIE2AXIMASTER_TYPE := (
      info            => INIT_INFO_TYPE,
      fpga            => INIT_FPGA_TYPE,
      interrupts      => INIT_INTERRUPTS_TYPE,
      interrupt_queue => INIT_INTERRUPT_QUEUE_TYPE,
      tlp             => INIT_TLP_TYPE,
      spi             => INIT_SPI_TYPE,
      arbiter         => INIT_ARBITER_TYPE,
      axi_window      => INIT_AXI_WINDOW_TYPE_array,
      debug           => INIT_DEBUG_TYPE
   );

   
end regfile_pcie2AxiMaster_pack;

package body regfile_pcie2AxiMaster_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_TAG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_TAG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_TAG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_TAG_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_TAG_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_TAG_TYPE is
   variable output : INFO_TAG_TYPE;
   begin
      output.value := stdlv(23 downto 0);
      return output;
   end to_INFO_TAG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_FID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_FID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_FID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_FID_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_FID_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_FID_TYPE is
   variable output : INFO_FID_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_FID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_VERSION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_VERSION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.major;
      output(15 downto 8) := reg.minor;
      output(7 downto 0) := reg.sub_minor;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_VERSION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_VERSION_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_VERSION_TYPE is
   variable output : INFO_VERSION_TYPE;
   begin
      output.major := stdlv(23 downto 16);
      output.minor := stdlv(15 downto 8);
      output.sub_minor := stdlv(7 downto 0);
      return output;
   end to_INFO_VERSION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_CAPABILITY_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_CAPABILITY_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_CAPABILITY_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_CAPABILITY_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_CAPABILITY_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_CAPABILITY_TYPE is
   variable output : INFO_CAPABILITY_TYPE;
   begin
      output.value := stdlv(7 downto 0);
      return output;
   end to_INFO_CAPABILITY_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INFO_SCRATCHPAD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INFO_SCRATCHPAD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INFO_SCRATCHPAD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INFO_SCRATCHPAD_TYPE
   --------------------------------------------------------------------------------
   function to_INFO_SCRATCHPAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return INFO_SCRATCHPAD_TYPE is
   variable output : INFO_SCRATCHPAD_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INFO_SCRATCHPAD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from FPGA_VERSION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : FPGA_VERSION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.firmware_type;
      output(23 downto 16) := reg.major;
      output(15 downto 8) := reg.minor;
      output(7 downto 0) := reg.sub_minor;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_FPGA_VERSION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to FPGA_VERSION_TYPE
   --------------------------------------------------------------------------------
   function to_FPGA_VERSION_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_VERSION_TYPE is
   variable output : FPGA_VERSION_TYPE;
   begin
      output.firmware_type := stdlv(31 downto 24);
      output.major := stdlv(23 downto 16);
      output.minor := stdlv(15 downto 8);
      output.sub_minor := stdlv(7 downto 0);
      return output;
   end to_FPGA_VERSION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from FPGA_BUILD_ID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : FPGA_BUILD_ID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_FPGA_BUILD_ID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to FPGA_BUILD_ID_TYPE
   --------------------------------------------------------------------------------
   function to_FPGA_BUILD_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_BUILD_ID_TYPE is
   variable output : FPGA_BUILD_ID_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_FPGA_BUILD_ID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from FPGA_DEVICE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : FPGA_DEVICE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.id;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_FPGA_DEVICE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to FPGA_DEVICE_TYPE
   --------------------------------------------------------------------------------
   function to_FPGA_DEVICE_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_DEVICE_TYPE is
   variable output : FPGA_DEVICE_TYPE;
   begin
      output.id := stdlv(7 downto 0);
      return output;
   end to_FPGA_DEVICE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from FPGA_BOARD_INFO_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : FPGA_BOARD_INFO_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.capability;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_FPGA_BOARD_INFO_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to FPGA_BOARD_INFO_TYPE
   --------------------------------------------------------------------------------
   function to_FPGA_BOARD_INFO_TYPE(stdlv : std_logic_vector(31 downto 0)) return FPGA_BOARD_INFO_TYPE is
   variable output : FPGA_BOARD_INFO_TYPE;
   begin
      output.capability := stdlv(3 downto 0);
      return output;
   end to_FPGA_BOARD_INFO_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPTS_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPTS_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.sw_irq;
      output(7 downto 1) := reg.num_irq;
      output(0) := reg.global_mask;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPTS_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPTS_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPTS_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_CTRL_TYPE is
   variable output : INTERRUPTS_CTRL_TYPE;
   begin
      output.sw_irq := stdlv(31);
      output.num_irq := stdlv(7 downto 1);
      output.global_mask := stdlv(0);
      return output;
   end to_INTERRUPTS_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPTS_STATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPTS_STATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPTS_STATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPTS_STATUS_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPTS_STATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_STATUS_TYPE is
   variable output : INTERRUPTS_STATUS_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INTERRUPTS_STATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPTS_ENABLE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPTS_ENABLE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPTS_ENABLE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPTS_ENABLE_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPTS_ENABLE_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_ENABLE_TYPE is
   variable output : INTERRUPTS_ENABLE_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INTERRUPTS_ENABLE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPTS_MASK_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPTS_MASK_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPTS_MASK_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPTS_MASK_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPTS_MASK_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPTS_MASK_TYPE is
   variable output : INTERRUPTS_MASK_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_INTERRUPTS_MASK_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_CONTROL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONTROL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.nb_dw;
      output(0) := reg.enable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_CONTROL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_CONTROL_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_CONTROL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONTROL_TYPE is
   variable output : INTERRUPT_QUEUE_CONTROL_TYPE;
   begin
      output.nb_dw := stdlv(31 downto 24);
      output.enable := stdlv(0);
      return output;
   end to_INTERRUPT_QUEUE_CONTROL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_CONS_IDX_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONS_IDX_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(9 downto 0) := reg.cons_idx;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_CONS_IDX_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_CONS_IDX_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_CONS_IDX_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONS_IDX_TYPE is
   variable output : INTERRUPT_QUEUE_CONS_IDX_TYPE;
   begin
      output.cons_idx := stdlv(9 downto 0);
      return output;
   end to_INTERRUPT_QUEUE_CONS_IDX_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_ADDR_LOW_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_LOW_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.addr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_ADDR_LOW_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_ADDR_LOW_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_ADDR_LOW_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_LOW_TYPE is
   variable output : INTERRUPT_QUEUE_ADDR_LOW_TYPE;
   begin
      output.addr := stdlv(31 downto 0);
      return output;
   end to_INTERRUPT_QUEUE_ADDR_LOW_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_ADDR_HIGH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_HIGH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.addr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_ADDR_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_HIGH_TYPE is
   variable output : INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
   begin
      output.addr := stdlv(31 downto 0);
      return output;
   end to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TLP_TIMEOUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TLP_TIMEOUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TLP_TIMEOUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TLP_TIMEOUT_TYPE
   --------------------------------------------------------------------------------
   function to_TLP_TIMEOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return TLP_TIMEOUT_TYPE is
   variable output : TLP_TIMEOUT_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_TLP_TIMEOUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TLP_TRANSACTION_ABORT_CNTR_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TLP_TRANSACTION_ABORT_CNTR_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.clr;
      output(30 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TLP_TRANSACTION_ABORT_CNTR_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TLP_TRANSACTION_ABORT_CNTR_TYPE
   --------------------------------------------------------------------------------
   function to_TLP_TRANSACTION_ABORT_CNTR_TYPE(stdlv : std_logic_vector(31 downto 0)) return TLP_TRANSACTION_ABORT_CNTR_TYPE is
   variable output : TLP_TRANSACTION_ABORT_CNTR_TYPE;
   begin
      output.clr := stdlv(31);
      output.value := stdlv(30 downto 0);
      return output;
   end to_TLP_TRANSACTION_ABORT_CNTR_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SPI_SPIREGIN_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SPI_SPIREGIN_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25) := reg.SPI_OLD_ENABLE;
      output(24) := reg.SPI_ENABLE;
      output(22) := reg.SPIRW;
      output(21) := reg.SPICMDDONE;
      output(18) := reg.SPISEL;
      output(16) := reg.SPITXST;
      output(7 downto 0) := reg.SPIDATAW;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SPI_SPIREGIN_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SPI_SPIREGIN_TYPE
   --------------------------------------------------------------------------------
   function to_SPI_SPIREGIN_TYPE(stdlv : std_logic_vector(31 downto 0)) return SPI_SPIREGIN_TYPE is
   variable output : SPI_SPIREGIN_TYPE;
   begin
      output.SPI_OLD_ENABLE := stdlv(25);
      output.SPI_ENABLE := stdlv(24);
      output.SPIRW := stdlv(22);
      output.SPICMDDONE := stdlv(21);
      output.SPISEL := stdlv(18);
      output.SPITXST := stdlv(16);
      output.SPIDATAW := stdlv(7 downto 0);
      return output;
   end to_SPI_SPIREGIN_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from SPI_SPIREGOUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : SPI_SPIREGOUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(17) := reg.SPI_WB_CAP;
      output(16) := reg.SPIWRTD;
      output(7 downto 0) := reg.SPIDATARD;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_SPI_SPIREGOUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to SPI_SPIREGOUT_TYPE
   --------------------------------------------------------------------------------
   function to_SPI_SPIREGOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return SPI_SPIREGOUT_TYPE is
   variable output : SPI_SPIREGOUT_TYPE;
   begin
      output.SPI_WB_CAP := stdlv(17);
      output.SPIWRTD := stdlv(16);
      output.SPIDATARD := stdlv(7 downto 0);
      return output;
   end to_SPI_SPIREGOUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ARBITER_ARBITER_CAPABILITIES_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ARBITER_ARBITER_CAPABILITIES_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(17 downto 16) := reg.AGENT_NB;
      output(11 downto 0) := reg.TAG;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ARBITER_ARBITER_CAPABILITIES_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ARBITER_ARBITER_CAPABILITIES_TYPE
   --------------------------------------------------------------------------------
   function to_ARBITER_ARBITER_CAPABILITIES_TYPE(stdlv : std_logic_vector(31 downto 0)) return ARBITER_ARBITER_CAPABILITIES_TYPE is
   variable output : ARBITER_ARBITER_CAPABILITIES_TYPE;
   begin
      output.AGENT_NB := stdlv(17 downto 16);
      output.TAG := stdlv(11 downto 0);
      return output;
   end to_ARBITER_ARBITER_CAPABILITIES_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ARBITER_AGENT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ARBITER_AGENT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(9) := reg.ACK;
      output(8) := reg.REC;
      output(4) := reg.DONE;
      output(0) := reg.REQ;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ARBITER_AGENT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ARBITER_AGENT_TYPE
   --------------------------------------------------------------------------------
   function to_ARBITER_AGENT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ARBITER_AGENT_TYPE is
   variable output : ARBITER_AGENT_TYPE;
   begin
      output.ACK := stdlv(9);
      output.REC := stdlv(8);
      output.DONE := stdlv(4);
      output.REQ := stdlv(0);
      return output;
   end to_ARBITER_AGENT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from AXI_WINDOW_CTRL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : AXI_WINDOW_CTRL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.enable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_AXI_WINDOW_CTRL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to AXI_WINDOW_CTRL_TYPE
   --------------------------------------------------------------------------------
   function to_AXI_WINDOW_CTRL_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_CTRL_TYPE is
   variable output : AXI_WINDOW_CTRL_TYPE;
   begin
      output.enable := stdlv(0);
      return output;
   end to_AXI_WINDOW_CTRL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from AXI_WINDOW_PCI_BAR0_START_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : AXI_WINDOW_PCI_BAR0_START_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_AXI_WINDOW_PCI_BAR0_START_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to AXI_WINDOW_PCI_BAR0_START_TYPE
   --------------------------------------------------------------------------------
   function to_AXI_WINDOW_PCI_BAR0_START_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_START_TYPE is
   variable output : AXI_WINDOW_PCI_BAR0_START_TYPE;
   begin
      output.value := stdlv(25 downto 0);
      return output;
   end to_AXI_WINDOW_PCI_BAR0_START_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from AXI_WINDOW_PCI_BAR0_STOP_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : AXI_WINDOW_PCI_BAR0_STOP_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_AXI_WINDOW_PCI_BAR0_STOP_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to AXI_WINDOW_PCI_BAR0_STOP_TYPE
   --------------------------------------------------------------------------------
   function to_AXI_WINDOW_PCI_BAR0_STOP_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_PCI_BAR0_STOP_TYPE is
   variable output : AXI_WINDOW_PCI_BAR0_STOP_TYPE;
   begin
      output.value := stdlv(25 downto 0);
      return output;
   end to_AXI_WINDOW_PCI_BAR0_STOP_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from AXI_WINDOW_AXI_TRANSLATION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : AXI_WINDOW_AXI_TRANSLATION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_AXI_WINDOW_AXI_TRANSLATION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to AXI_WINDOW_AXI_TRANSLATION_TYPE
   --------------------------------------------------------------------------------
   function to_AXI_WINDOW_AXI_TRANSLATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return AXI_WINDOW_AXI_TRANSLATION_TYPE is
   variable output : AXI_WINDOW_AXI_TRANSLATION_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_AXI_WINDOW_AXI_TRANSLATION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_INPUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_INPUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_INPUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_INPUT_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_INPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_INPUT_TYPE is
   variable output : DEBUG_INPUT_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DEBUG_INPUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_OUTPUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_OUTPUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_OUTPUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_OUTPUT_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_OUTPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_OUTPUT_TYPE is
   variable output : DEBUG_OUTPUT_TYPE;
   begin
      output.value := stdlv(31 downto 0);
      return output;
   end to_DEBUG_OUTPUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_DMA_DEBUG1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.ADD_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_DMA_DEBUG1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_DMA_DEBUG1_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_DMA_DEBUG1_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG1_TYPE is
   variable output : DEBUG_DMA_DEBUG1_TYPE;
   begin
      output.ADD_START := stdlv(31 downto 0);
      return output;
   end to_DEBUG_DMA_DEBUG1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_DMA_DEBUG2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.ADD_OVERRUN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_DMA_DEBUG2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_DMA_DEBUG2_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_DMA_DEBUG2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG2_TYPE is
   variable output : DEBUG_DMA_DEBUG2_TYPE;
   begin
      output.ADD_OVERRUN := stdlv(31 downto 0);
      return output;
   end to_DEBUG_DMA_DEBUG2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEBUG_DMA_DEBUG3_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEBUG_DMA_DEBUG3_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(4) := reg.DMA_ADD_ERROR;
      output(0) := reg.DMA_OVERRUN;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEBUG_DMA_DEBUG3_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEBUG_DMA_DEBUG3_TYPE
   --------------------------------------------------------------------------------
   function to_DEBUG_DMA_DEBUG3_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEBUG_DMA_DEBUG3_TYPE is
   variable output : DEBUG_DMA_DEBUG3_TYPE;
   begin
      output.DMA_ADD_ERROR := stdlv(4);
      output.DMA_OVERRUN := stdlv(0);
      return output;
   end to_DEBUG_DMA_DEBUG3_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_pcie2AxiMaster.vhd
-- Project             : FDK
-- Module              : regfile_pcie2AxiMaster
-- Created on          : 2020/09/15 18:41:27
-- Created by          : amarchan
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xC43C8CD6
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_pcie2AxiMaster_pack.all;


entity regfile_pcie2AxiMaster is
   
   port (
      resetN        : in    std_logic;                                                       -- System reset
      sysclk        : in    std_logic;                                                       -- System clock
      regfile       : inout REGFILE_PCIE2AXIMASTER_TYPE := INIT_REGFILE_PCIE2AXIMASTER_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_read      : in    std_logic;                                                       -- Read
      reg_write     : in    std_logic;                                                       -- Write
      reg_addr      : in    std_logic_vector(9 downto 2);                                    -- Address
      reg_beN       : in    std_logic_vector(3 downto 0);                                    -- Byte enable
      reg_writedata : in    std_logic_vector(31 downto 0);                                   -- Write data
      reg_readdata  : out   std_logic_vector(31 downto 0)                                    -- Read data
   );
   
end regfile_pcie2AxiMaster;

architecture rtl of regfile_pcie2AxiMaster is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                   : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                           : std_logic_vector(47 downto 0);                   -- Address decode hit
signal wEn                                           : std_logic_vector(47 downto 0);                   -- Write Enable
signal fullAddr                                      : std_logic_vector(11 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                                 : integer;                                        
signal bitEnN                                        : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                        : std_logic;                                      
signal rb_info_tag                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_fid                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_version                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_capability                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_info_scratchpad                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_fpga_version                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_fpga_build_id                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_fpga_device                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_fpga_board_info                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_ctrl                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_status_0                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_status_1                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_enable_0                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_enable_1                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_mask_0                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupts_mask_1                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupt_queue_control                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupt_queue_cons_idx                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupt_queue_addr_low                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_interrupt_queue_addr_high                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_tlp_timeout                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_tlp_transaction_abort_cntr                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_spi_SPIREGIN                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_spi_SPIREGOUT                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_ARBITER_CAPABILITIES               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_AGENT_0                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_AGENT_1                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_ctrl                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_pci_bar0_start                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_pci_bar0_stop                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_axi_translation               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_ctrl                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_pci_bar0_start                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_pci_bar0_stop                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_axi_translation               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_ctrl                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_pci_bar0_start                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_pci_bar0_stop                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_axi_translation               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_ctrl                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_pci_bar0_start                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_pci_bar0_stop                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_axi_translation               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_input                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_output                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_DMA_DEBUG1                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_DMA_DEBUG2                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_debug_DMA_DEBUG3                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw_info_scratchpad_value                : std_logic_vector(31 downto 0);                   -- Field: value
signal field_wautoclr_interrupts_ctrl_sw_irq         : std_logic;                                       -- Field: sw_irq
signal field_rw_interrupts_ctrl_global_mask          : std_logic;                                       -- Field: global_mask
signal field_rw2c_interrupts_status_0_value          : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw2c_interrupts_status_1_value          : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_interrupts_enable_0_value            : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_interrupts_enable_1_value            : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_interrupts_mask_0_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_interrupts_mask_1_value              : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_interrupt_queue_control_enable       : std_logic;                                       -- Field: enable
signal field_rw_interrupt_queue_cons_idx_cons_idx    : std_logic_vector(9 downto 0);                    -- Field: cons_idx
signal field_rw_interrupt_queue_addr_low_addr        : std_logic_vector(19 downto 0);                   -- Field: addr
signal field_rw_interrupt_queue_addr_high_addr       : std_logic_vector(31 downto 0);                   -- Field: addr
signal field_rw_tlp_timeout_value                    : std_logic_vector(31 downto 0);                   -- Field: value
signal field_wautoclr_tlp_transaction_abort_cntr_clr : std_logic;                                       -- Field: clr
signal field_rw_spi_SPIREGIN_SPI_ENABLE              : std_logic;                                       -- Field: SPI_ENABLE
signal field_rw_spi_SPIREGIN_SPIRW                   : std_logic;                                       -- Field: SPIRW
signal field_rw_spi_SPIREGIN_SPICMDDONE              : std_logic;                                       -- Field: SPICMDDONE
signal field_rw_spi_SPIREGIN_SPISEL                  : std_logic;                                       -- Field: SPISEL
signal field_wautoclr_spi_SPIREGIN_SPITXST           : std_logic;                                       -- Field: SPITXST
signal field_rw_spi_SPIREGIN_SPIDATAW                : std_logic_vector(7 downto 0);                    -- Field: SPIDATAW
signal field_wautoclr_arbiter_AGENT_0_DONE           : std_logic;                                       -- Field: DONE
signal field_wautoclr_arbiter_AGENT_0_REQ            : std_logic;                                       -- Field: REQ
signal field_wautoclr_arbiter_AGENT_1_DONE           : std_logic;                                       -- Field: DONE
signal field_wautoclr_arbiter_AGENT_1_REQ            : std_logic;                                       -- Field: REQ
signal field_rw_axi_window_0_ctrl_enable             : std_logic;                                       -- Field: enable
signal field_rw_axi_window_0_pci_bar0_start_value    : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_0_pci_bar0_stop_value     : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_0_axi_translation_value   : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_1_ctrl_enable             : std_logic;                                       -- Field: enable
signal field_rw_axi_window_1_pci_bar0_start_value    : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_1_pci_bar0_stop_value     : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_1_axi_translation_value   : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_2_ctrl_enable             : std_logic;                                       -- Field: enable
signal field_rw_axi_window_2_pci_bar0_start_value    : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_2_pci_bar0_stop_value     : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_2_axi_translation_value   : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_3_ctrl_enable             : std_logic;                                       -- Field: enable
signal field_rw_axi_window_3_pci_bar0_start_value    : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_3_pci_bar0_stop_value     : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_3_axi_translation_value   : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_debug_output_value                   : std_logic_vector(31 downto 0);                   -- Field: value
signal field_rw_debug_DMA_DEBUG1_ADD_START           : std_logic_vector(31 downto 0);                   -- Field: ADD_START
signal field_rw_debug_DMA_DEBUG2_ADD_OVERRUN         : std_logic_vector(31 downto 0);                   -- Field: ADD_OVERRUN

begin -- rtl

------------------------------------------------------------------------------------------
-- Process: P_bitEnN
------------------------------------------------------------------------------------------
P_bitEnN : process(reg_beN)
begin
   for i in 3 downto 0 loop
      for j in 7 downto 0 loop
         bitEnN(i*8+j) <= reg_beN(i);
      end loop;
   end loop;
end process P_bitEnN;

--------------------------------------------------------------------------------
-- Address decoding logic
--------------------------------------------------------------------------------
fullAddr(9 downto 2)<= reg_addr;

hit(0)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,12)))	else '0'; -- Addr:  0x0000	tag
hit(1)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,12)))	else '0'; -- Addr:  0x0004	fid
hit(2)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,12)))	else '0'; -- Addr:  0x0008	version
hit(3)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#c#,12)))	else '0'; -- Addr:  0x000C	capability
hit(4)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10#,12)))	else '0'; -- Addr:  0x0010	scratchpad
hit(5)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20#,12)))	else '0'; -- Addr:  0x0020	version
hit(6)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#24#,12)))	else '0'; -- Addr:  0x0024	build_id
hit(7)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#28#,12)))	else '0'; -- Addr:  0x0028	device
hit(8)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#2c#,12)))	else '0'; -- Addr:  0x002C	board_info
hit(9)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,12)))	else '0'; -- Addr:  0x0040	ctrl
hit(10) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#44#,12)))	else '0'; -- Addr:  0x0044	status[0]
hit(11) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48#,12)))	else '0'; -- Addr:  0x0048	status[1]
hit(12) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c#,12)))	else '0'; -- Addr:  0x004C	enable[0]
hit(13) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#50#,12)))	else '0'; -- Addr:  0x0050	enable[1]
hit(14) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#54#,12)))	else '0'; -- Addr:  0x0054	mask[0]
hit(15) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#58#,12)))	else '0'; -- Addr:  0x0058	mask[1]
hit(16) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#60#,12)))	else '0'; -- Addr:  0x0060	control
hit(17) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#64#,12)))	else '0'; -- Addr:  0x0064	cons_idx
hit(18) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#68#,12)))	else '0'; -- Addr:  0x0068	addr_low
hit(19) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#6c#,12)))	else '0'; -- Addr:  0x006C	addr_high
hit(20) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,12)))	else '0'; -- Addr:  0x0070	timeout
hit(21) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#74#,12)))	else '0'; -- Addr:  0x0074	transaction_abort_cntr
hit(22) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#e0#,12)))	else '0'; -- Addr:  0x00E0	SPIREGIN
hit(23) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#e8#,12)))	else '0'; -- Addr:  0x00E8	SPIREGOUT
hit(24) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f0#,12)))	else '0'; -- Addr:  0x00F0	ARBITER_CAPABILITIES
hit(25) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f4#,12)))	else '0'; -- Addr:  0x00F4	AGENT[0]
hit(26) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f8#,12)))	else '0'; -- Addr:  0x00F8	AGENT[1]
hit(27) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#100#,12)))	else '0'; -- Addr:  0x0100	ctrl
hit(28) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#104#,12)))	else '0'; -- Addr:  0x0104	pci_bar0_start
hit(29) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#108#,12)))	else '0'; -- Addr:  0x0108	pci_bar0_stop
hit(30) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10c#,12)))	else '0'; -- Addr:  0x010C	axi_translation
hit(31) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#110#,12)))	else '0'; -- Addr:  0x0110	ctrl
hit(32) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#114#,12)))	else '0'; -- Addr:  0x0114	pci_bar0_start
hit(33) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#118#,12)))	else '0'; -- Addr:  0x0118	pci_bar0_stop
hit(34) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#11c#,12)))	else '0'; -- Addr:  0x011C	axi_translation
hit(35) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#120#,12)))	else '0'; -- Addr:  0x0120	ctrl
hit(36) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#124#,12)))	else '0'; -- Addr:  0x0124	pci_bar0_start
hit(37) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#128#,12)))	else '0'; -- Addr:  0x0128	pci_bar0_stop
hit(38) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#12c#,12)))	else '0'; -- Addr:  0x012C	axi_translation
hit(39) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#130#,12)))	else '0'; -- Addr:  0x0130	ctrl
hit(40) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#134#,12)))	else '0'; -- Addr:  0x0134	pci_bar0_start
hit(41) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#138#,12)))	else '0'; -- Addr:  0x0138	pci_bar0_stop
hit(42) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#13c#,12)))	else '0'; -- Addr:  0x013C	axi_translation
hit(43) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#200#,12)))	else '0'; -- Addr:  0x0200	input
hit(44) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#204#,12)))	else '0'; -- Addr:  0x0204	output
hit(45) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#208#,12)))	else '0'; -- Addr:  0x0208	DMA_DEBUG1
hit(46) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20c#,12)))	else '0'; -- Addr:  0x020C	DMA_DEBUG2
hit(47) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#210#,12)))	else '0'; -- Addr:  0x0210	DMA_DEBUG3



fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_info_tag,
                            rb_info_fid,
                            rb_info_version,
                            rb_info_capability,
                            rb_info_scratchpad,
                            rb_fpga_version,
                            rb_fpga_build_id,
                            rb_fpga_device,
                            rb_fpga_board_info,
                            rb_interrupts_ctrl,
                            rb_interrupts_status_0,
                            rb_interrupts_status_1,
                            rb_interrupts_enable_0,
                            rb_interrupts_enable_1,
                            rb_interrupts_mask_0,
                            rb_interrupts_mask_1,
                            rb_interrupt_queue_control,
                            rb_interrupt_queue_cons_idx,
                            rb_interrupt_queue_addr_low,
                            rb_interrupt_queue_addr_high,
                            rb_tlp_timeout,
                            rb_tlp_transaction_abort_cntr,
                            rb_spi_SPIREGIN,
                            rb_spi_SPIREGOUT,
                            rb_arbiter_ARBITER_CAPABILITIES,
                            rb_arbiter_AGENT_0,
                            rb_arbiter_AGENT_1,
                            rb_axi_window_0_ctrl,
                            rb_axi_window_0_pci_bar0_start,
                            rb_axi_window_0_pci_bar0_stop,
                            rb_axi_window_0_axi_translation,
                            rb_axi_window_1_ctrl,
                            rb_axi_window_1_pci_bar0_start,
                            rb_axi_window_1_pci_bar0_stop,
                            rb_axi_window_1_axi_translation,
                            rb_axi_window_2_ctrl,
                            rb_axi_window_2_pci_bar0_start,
                            rb_axi_window_2_pci_bar0_stop,
                            rb_axi_window_2_axi_translation,
                            rb_axi_window_3_ctrl,
                            rb_axi_window_3_pci_bar0_start,
                            rb_axi_window_3_pci_bar0_stop,
                            rb_axi_window_3_axi_translation,
                            rb_debug_input,
                            rb_debug_output,
                            rb_debug_DMA_DEBUG1,
                            rb_debug_DMA_DEBUG2,
                            rb_debug_DMA_DEBUG3
                           )
begin
   case fullAddrAsInt is
      -- [0x000]: /info/tag
      when 16#0# =>
         readBackMux <= rb_info_tag;

      -- [0x004]: /info/fid
      when 16#4# =>
         readBackMux <= rb_info_fid;

      -- [0x008]: /info/version
      when 16#8# =>
         readBackMux <= rb_info_version;

      -- [0x00c]: /info/capability
      when 16#C# =>
         readBackMux <= rb_info_capability;

      -- [0x010]: /info/scratchpad
      when 16#10# =>
         readBackMux <= rb_info_scratchpad;

      -- [0x020]: /fpga/version
      when 16#20# =>
         readBackMux <= rb_fpga_version;

      -- [0x024]: /fpga/build_id
      when 16#24# =>
         readBackMux <= rb_fpga_build_id;

      -- [0x028]: /fpga/device
      when 16#28# =>
         readBackMux <= rb_fpga_device;

      -- [0x02c]: /fpga/board_info
      when 16#2C# =>
         readBackMux <= rb_fpga_board_info;

      -- [0x040]: /interrupts/ctrl
      when 16#40# =>
         readBackMux <= rb_interrupts_ctrl;

      -- [0x044]: /interrupts/status_0
      when 16#44# =>
         readBackMux <= rb_interrupts_status_0;

      -- [0x048]: /interrupts/status_1
      when 16#48# =>
         readBackMux <= rb_interrupts_status_1;

      -- [0x04c]: /interrupts/enable_0
      when 16#4C# =>
         readBackMux <= rb_interrupts_enable_0;

      -- [0x050]: /interrupts/enable_1
      when 16#50# =>
         readBackMux <= rb_interrupts_enable_1;

      -- [0x054]: /interrupts/mask_0
      when 16#54# =>
         readBackMux <= rb_interrupts_mask_0;

      -- [0x058]: /interrupts/mask_1
      when 16#58# =>
         readBackMux <= rb_interrupts_mask_1;

      -- [0x060]: /interrupt_queue/control
      when 16#60# =>
         readBackMux <= rb_interrupt_queue_control;

      -- [0x064]: /interrupt_queue/cons_idx
      when 16#64# =>
         readBackMux <= rb_interrupt_queue_cons_idx;

      -- [0x068]: /interrupt_queue/addr_low
      when 16#68# =>
         readBackMux <= rb_interrupt_queue_addr_low;

      -- [0x06c]: /interrupt_queue/addr_high
      when 16#6C# =>
         readBackMux <= rb_interrupt_queue_addr_high;

      -- [0x070]: /tlp/timeout
      when 16#70# =>
         readBackMux <= rb_tlp_timeout;

      -- [0x074]: /tlp/transaction_abort_cntr
      when 16#74# =>
         readBackMux <= rb_tlp_transaction_abort_cntr;

      -- [0x0e0]: /spi/SPIREGIN
      when 16#E0# =>
         readBackMux <= rb_spi_SPIREGIN;

      -- [0x0e8]: /spi/SPIREGOUT
      when 16#E8# =>
         readBackMux <= rb_spi_SPIREGOUT;

      -- [0x0f0]: /arbiter/ARBITER_CAPABILITIES
      when 16#F0# =>
         readBackMux <= rb_arbiter_ARBITER_CAPABILITIES;

      -- [0x0f4]: /arbiter/AGENT_0
      when 16#F4# =>
         readBackMux <= rb_arbiter_AGENT_0;

      -- [0x0f8]: /arbiter/AGENT_1
      when 16#F8# =>
         readBackMux <= rb_arbiter_AGENT_1;

      -- [0x100]: /axi_window_0/ctrl
      when 16#100# =>
         readBackMux <= rb_axi_window_0_ctrl;

      -- [0x104]: /axi_window_0/pci_bar0_start
      when 16#104# =>
         readBackMux <= rb_axi_window_0_pci_bar0_start;

      -- [0x108]: /axi_window_0/pci_bar0_stop
      when 16#108# =>
         readBackMux <= rb_axi_window_0_pci_bar0_stop;

      -- [0x10c]: /axi_window_0/axi_translation
      when 16#10C# =>
         readBackMux <= rb_axi_window_0_axi_translation;

      -- [0x110]: /axi_window_1/ctrl
      when 16#110# =>
         readBackMux <= rb_axi_window_1_ctrl;

      -- [0x114]: /axi_window_1/pci_bar0_start
      when 16#114# =>
         readBackMux <= rb_axi_window_1_pci_bar0_start;

      -- [0x118]: /axi_window_1/pci_bar0_stop
      when 16#118# =>
         readBackMux <= rb_axi_window_1_pci_bar0_stop;

      -- [0x11c]: /axi_window_1/axi_translation
      when 16#11C# =>
         readBackMux <= rb_axi_window_1_axi_translation;

      -- [0x120]: /axi_window_2/ctrl
      when 16#120# =>
         readBackMux <= rb_axi_window_2_ctrl;

      -- [0x124]: /axi_window_2/pci_bar0_start
      when 16#124# =>
         readBackMux <= rb_axi_window_2_pci_bar0_start;

      -- [0x128]: /axi_window_2/pci_bar0_stop
      when 16#128# =>
         readBackMux <= rb_axi_window_2_pci_bar0_stop;

      -- [0x12c]: /axi_window_2/axi_translation
      when 16#12C# =>
         readBackMux <= rb_axi_window_2_axi_translation;

      -- [0x130]: /axi_window_3/ctrl
      when 16#130# =>
         readBackMux <= rb_axi_window_3_ctrl;

      -- [0x134]: /axi_window_3/pci_bar0_start
      when 16#134# =>
         readBackMux <= rb_axi_window_3_pci_bar0_start;

      -- [0x138]: /axi_window_3/pci_bar0_stop
      when 16#138# =>
         readBackMux <= rb_axi_window_3_pci_bar0_stop;

      -- [0x13c]: /axi_window_3/axi_translation
      when 16#13C# =>
         readBackMux <= rb_axi_window_3_axi_translation;

      -- [0x200]: /debug/input
      when 16#200# =>
         readBackMux <= rb_debug_input;

      -- [0x204]: /debug/output
      when 16#204# =>
         readBackMux <= rb_debug_output;

      -- [0x208]: /debug/DMA_DEBUG1
      when 16#208# =>
         readBackMux <= rb_debug_DMA_DEBUG1;

      -- [0x20c]: /debug/DMA_DEBUG2
      when 16#20C# =>
         readBackMux <= rb_debug_DMA_DEBUG2;

      -- [0x210]: /debug/DMA_DEBUG3
      when 16#210# =>
         readBackMux <= rb_debug_DMA_DEBUG3;

      -- Default value
      when others =>
         readBackMux <= (others => '0');

   end case;

end process P_readBackMux_Mux;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdata
------------------------------------------------------------------------------------------
P_reg_readdata : process(sysclk, resetN)
begin
   if (resetN = '0') then
      reg_readdata <= (others=>'0');
   elsif (rising_edge(sysclk)) then
      if (ldData = '1') then
         reg_readdata <= readBackMux;
      end if;
   end if;
end process P_reg_readdata;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_tag
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_tag(23 downto 0) <= std_logic_vector(to_unsigned(integer(5788749),24));
regfile.info.tag.value <= rb_info_tag(23 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_fid
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_fid(31 downto 0) <= X"00000000";
regfile.info.fid.value <= rb_info_fid(31 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_version
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: major
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(23 downto 16) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.info.version.major <= rb_info_version(23 downto 16);


------------------------------------------------------------------------------------------
-- Field name: minor
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(15 downto 8) <= std_logic_vector(to_unsigned(integer(9),8));
regfile.info.version.minor <= rb_info_version(15 downto 8);


------------------------------------------------------------------------------------------
-- Field name: sub_minor
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_version(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.info.version.sub_minor <= rb_info_version(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_capability
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_info_capability(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.info.capability.value <= rb_info_capability(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: info_scratchpad
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_info_scratchpad(31 downto 0) <= field_rw_info_scratchpad_value(31 downto 0);
regfile.info.scratchpad.value <= field_rw_info_scratchpad_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_info_scratchpad_value
------------------------------------------------------------------------------------------
P_info_scratchpad_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_info_scratchpad_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(4) = '1' and bitEnN(j) = '0') then
            field_rw_info_scratchpad_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_info_scratchpad_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: fpga_version
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: firmware_type(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_version(31 downto 24) <= regfile.fpga.version.firmware_type;


------------------------------------------------------------------------------------------
-- Field name: major(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_version(23 downto 16) <= regfile.fpga.version.major;


------------------------------------------------------------------------------------------
-- Field name: minor(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_version(15 downto 8) <= regfile.fpga.version.minor;


------------------------------------------------------------------------------------------
-- Field name: sub_minor(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_version(7 downto 0) <= regfile.fpga.version.sub_minor;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: fpga_build_id
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_build_id(31 downto 0) <= regfile.fpga.build_id.value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: fpga_device
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: id(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_device(7 downto 0) <= regfile.fpga.device.id;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: fpga_board_info
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: capability(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_fpga_board_info(3 downto 0) <= regfile.fpga.board_info.capability;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: sw_irq
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_interrupts_ctrl(31) <= '0';
regfile.interrupts.ctrl.sw_irq <= field_wautoclr_interrupts_ctrl_sw_irq;


------------------------------------------------------------------------------------------
-- Process: P_interrupts_ctrl_sw_irq
------------------------------------------------------------------------------------------
P_interrupts_ctrl_sw_irq : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_interrupts_ctrl_sw_irq <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(9) = '1' and bitEnN(31) = '0') then
         field_wautoclr_interrupts_ctrl_sw_irq <= reg_writedata(31);
      else
         field_wautoclr_interrupts_ctrl_sw_irq <= '0';
      end if;
   end if;
end process P_interrupts_ctrl_sw_irq;

------------------------------------------------------------------------------------------
-- Field name: num_irq(6 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_interrupts_ctrl(7 downto 1) <= regfile.interrupts.ctrl.num_irq;


------------------------------------------------------------------------------------------
-- Field name: global_mask
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupts_ctrl(0) <= field_rw_interrupts_ctrl_global_mask;
regfile.interrupts.ctrl.global_mask <= field_rw_interrupts_ctrl_global_mask;


------------------------------------------------------------------------------------------
-- Process: P_interrupts_ctrl_global_mask
------------------------------------------------------------------------------------------
P_interrupts_ctrl_global_mask : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupts_ctrl_global_mask <= '1';
   elsif (rising_edge(sysclk)) then
      if(wEn(9) = '1' and bitEnN(0) = '0') then
         field_rw_interrupts_ctrl_global_mask <= reg_writedata(0);
      end if;
   end if;
end process P_interrupts_ctrl_global_mask;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_status_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_interrupts_status_0(31 downto 0) <= field_rw2c_interrupts_status_0_value(31 downto 0);
regfile.interrupts.status(0).value <= field_rw2c_interrupts_status_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_status_0_value
------------------------------------------------------------------------------------------
P_interrupts_status_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw2c_interrupts_status_0_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(10) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
            -- Clear every field bit to '0'
            field_rw2c_interrupts_status_0_value(j-0) <= '0';
         else
            -- Set every field bit to '1'
            field_rw2c_interrupts_status_0_value(j-0) <= field_rw2c_interrupts_status_0_value(j-0) or regfile.interrupts.status(0).value_set(j-0);
         end if;
      end loop;
   end if;
end process P_interrupts_status_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_status_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_interrupts_status_1(31 downto 0) <= field_rw2c_interrupts_status_1_value(31 downto 0);
regfile.interrupts.status(1).value <= field_rw2c_interrupts_status_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_status_1_value
------------------------------------------------------------------------------------------
P_interrupts_status_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw2c_interrupts_status_1_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(11) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
            -- Clear every field bit to '0'
            field_rw2c_interrupts_status_1_value(j-0) <= '0';
         else
            -- Set every field bit to '1'
            field_rw2c_interrupts_status_1_value(j-0) <= field_rw2c_interrupts_status_1_value(j-0) or regfile.interrupts.status(1).value_set(j-0);
         end if;
      end loop;
   end if;
end process P_interrupts_status_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_enable_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupts_enable_0(31 downto 0) <= field_rw_interrupts_enable_0_value(31 downto 0);
regfile.interrupts.enable(0).value <= field_rw_interrupts_enable_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_enable_0_value
------------------------------------------------------------------------------------------
P_interrupts_enable_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupts_enable_0_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(12) = '1' and bitEnN(j) = '0') then
            field_rw_interrupts_enable_0_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupts_enable_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_enable_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupts_enable_1(31 downto 0) <= field_rw_interrupts_enable_1_value(31 downto 0);
regfile.interrupts.enable(1).value <= field_rw_interrupts_enable_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_enable_1_value
------------------------------------------------------------------------------------------
P_interrupts_enable_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupts_enable_1_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(13) = '1' and bitEnN(j) = '0') then
            field_rw_interrupts_enable_1_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupts_enable_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_mask_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupts_mask_0(31 downto 0) <= field_rw_interrupts_mask_0_value(31 downto 0);
regfile.interrupts.mask(0).value <= field_rw_interrupts_mask_0_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_mask_0_value
------------------------------------------------------------------------------------------
P_interrupts_mask_0_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupts_mask_0_value <= X"FFFFFFFF";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(14) = '1' and bitEnN(j) = '0') then
            field_rw_interrupts_mask_0_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupts_mask_0_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupts_mask_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupts_mask_1(31 downto 0) <= field_rw_interrupts_mask_1_value(31 downto 0);
regfile.interrupts.mask(1).value <= field_rw_interrupts_mask_1_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupts_mask_1_value
------------------------------------------------------------------------------------------
P_interrupts_mask_1_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupts_mask_1_value <= X"FFFFFFFF";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(15) = '1' and bitEnN(j) = '0') then
            field_rw_interrupts_mask_1_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupts_mask_1_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupt_queue_control
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(16) <= (hit(16)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: nb_dw
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_interrupt_queue_control(31 downto 24) <= std_logic_vector(to_unsigned(integer(2),8));
regfile.interrupt_queue.control.nb_dw <= rb_interrupt_queue_control(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupt_queue_control(0) <= field_rw_interrupt_queue_control_enable;
regfile.interrupt_queue.control.enable <= field_rw_interrupt_queue_control_enable;


------------------------------------------------------------------------------------------
-- Process: P_interrupt_queue_control_enable
------------------------------------------------------------------------------------------
P_interrupt_queue_control_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupt_queue_control_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(16) = '1' and bitEnN(0) = '0') then
         field_rw_interrupt_queue_control_enable <= reg_writedata(0);
      end if;
   end if;
end process P_interrupt_queue_control_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupt_queue_cons_idx
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(17) <= (hit(17)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: cons_idx(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupt_queue_cons_idx(9 downto 0) <= field_rw_interrupt_queue_cons_idx_cons_idx(9 downto 0);
regfile.interrupt_queue.cons_idx.cons_idx <= field_rw_interrupt_queue_cons_idx_cons_idx(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupt_queue_cons_idx_cons_idx
------------------------------------------------------------------------------------------
P_interrupt_queue_cons_idx_cons_idx : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupt_queue_cons_idx_cons_idx <= std_logic_vector(to_unsigned(integer(0),10));
   elsif (rising_edge(sysclk)) then
      for j in  9 downto 0  loop
         if(wEn(17) = '1' and bitEnN(j) = '0') then
            field_rw_interrupt_queue_cons_idx_cons_idx(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupt_queue_cons_idx_cons_idx;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupt_queue_addr_low
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(18) <= (hit(18)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: addr(31 downto 0)
-- Field type: addr(31 downto 12) = RW, addr(11 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_interrupt_queue_addr_low(31 downto 0) <= field_rw_interrupt_queue_addr_low_addr(19 downto 0) & std_logic_vector(to_unsigned(integer(0),12));
regfile.interrupt_queue.addr_low.addr <= field_rw_interrupt_queue_addr_low_addr(19 downto 0) & std_logic_vector(to_unsigned(integer(0),12));


------------------------------------------------------------------------------------------
-- Process: P_interrupt_queue_addr_low_addr
------------------------------------------------------------------------------------------
P_interrupt_queue_addr_low_addr : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupt_queue_addr_low_addr <= std_logic_vector(to_unsigned(integer(0),20));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 12  loop
         if(wEn(18) = '1' and bitEnN(j) = '0') then
            field_rw_interrupt_queue_addr_low_addr(j-12) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupt_queue_addr_low_addr;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: interrupt_queue_addr_high
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(19) <= (hit(19)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: addr(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_interrupt_queue_addr_high(31 downto 0) <= field_rw_interrupt_queue_addr_high_addr(31 downto 0);
regfile.interrupt_queue.addr_high.addr <= field_rw_interrupt_queue_addr_high_addr(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_interrupt_queue_addr_high_addr
------------------------------------------------------------------------------------------
P_interrupt_queue_addr_high_addr : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_interrupt_queue_addr_high_addr <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(19) = '1' and bitEnN(j) = '0') then
            field_rw_interrupt_queue_addr_high_addr(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_interrupt_queue_addr_high_addr;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: tlp_timeout
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(20) <= (hit(20)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_tlp_timeout(31 downto 0) <= field_rw_tlp_timeout_value(31 downto 0);
regfile.tlp.timeout.value <= field_rw_tlp_timeout_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_tlp_timeout_value
------------------------------------------------------------------------------------------
P_tlp_timeout_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_tlp_timeout_value <= X"01DCD650";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(20) = '1' and bitEnN(j) = '0') then
            field_rw_tlp_timeout_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_tlp_timeout_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: tlp_transaction_abort_cntr
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(21) <= (hit(21)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: clr
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_tlp_transaction_abort_cntr(31) <= '0';
regfile.tlp.transaction_abort_cntr.clr <= field_wautoclr_tlp_transaction_abort_cntr_clr;


------------------------------------------------------------------------------------------
-- Process: P_tlp_transaction_abort_cntr_clr
------------------------------------------------------------------------------------------
P_tlp_transaction_abort_cntr_clr : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_tlp_transaction_abort_cntr_clr <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(21) = '1' and bitEnN(31) = '0') then
         field_wautoclr_tlp_transaction_abort_cntr_clr <= reg_writedata(31);
      else
         field_wautoclr_tlp_transaction_abort_cntr_clr <= '0';
      end if;
   end if;
end process P_tlp_transaction_abort_cntr_clr;

------------------------------------------------------------------------------------------
-- Field name: value(30 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_tlp_transaction_abort_cntr(30 downto 0) <= regfile.tlp.transaction_abort_cntr.value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: spi_SPIREGIN
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(22) <= (hit(22)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SPI_OLD_ENABLE
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(25) <= '0';
regfile.spi.SPIREGIN.SPI_OLD_ENABLE <= rb_spi_SPIREGIN(25);


------------------------------------------------------------------------------------------
-- Field name: SPI_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(24) <= field_rw_spi_SPIREGIN_SPI_ENABLE;
regfile.spi.SPIREGIN.SPI_ENABLE <= field_rw_spi_SPIREGIN_SPI_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPI_ENABLE
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPI_ENABLE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_spi_SPIREGIN_SPI_ENABLE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(22) = '1' and bitEnN(24) = '0') then
         field_rw_spi_SPIREGIN_SPI_ENABLE <= reg_writedata(24);
      end if;
   end if;
end process P_spi_SPIREGIN_SPI_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: SPIRW
-- Field type: RW
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(22) <= field_rw_spi_SPIREGIN_SPIRW;
regfile.spi.SPIREGIN.SPIRW <= field_rw_spi_SPIREGIN_SPIRW;


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPIRW
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPIRW : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_spi_SPIREGIN_SPIRW <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(22) = '1' and bitEnN(22) = '0') then
         field_rw_spi_SPIREGIN_SPIRW <= reg_writedata(22);
      end if;
   end if;
end process P_spi_SPIREGIN_SPIRW;

------------------------------------------------------------------------------------------
-- Field name: SPICMDDONE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(21) <= field_rw_spi_SPIREGIN_SPICMDDONE;
regfile.spi.SPIREGIN.SPICMDDONE <= field_rw_spi_SPIREGIN_SPICMDDONE;


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPICMDDONE
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPICMDDONE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_spi_SPIREGIN_SPICMDDONE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(22) = '1' and bitEnN(21) = '0') then
         field_rw_spi_SPIREGIN_SPICMDDONE <= reg_writedata(21);
      end if;
   end if;
end process P_spi_SPIREGIN_SPICMDDONE;

------------------------------------------------------------------------------------------
-- Field name: SPISEL
-- Field type: RW
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(18) <= field_rw_spi_SPIREGIN_SPISEL;
regfile.spi.SPIREGIN.SPISEL <= field_rw_spi_SPIREGIN_SPISEL;


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPISEL
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPISEL : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_spi_SPIREGIN_SPISEL <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(22) = '1' and bitEnN(18) = '0') then
         field_rw_spi_SPIREGIN_SPISEL <= reg_writedata(18);
      end if;
   end if;
end process P_spi_SPIREGIN_SPISEL;

------------------------------------------------------------------------------------------
-- Field name: SPITXST
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(16) <= '0';
regfile.spi.SPIREGIN.SPITXST <= field_wautoclr_spi_SPIREGIN_SPITXST;


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPITXST
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPITXST : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_spi_SPIREGIN_SPITXST <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(22) = '1' and bitEnN(16) = '0') then
         field_wautoclr_spi_SPIREGIN_SPITXST <= reg_writedata(16);
      else
         field_wautoclr_spi_SPIREGIN_SPITXST <= '0';
      end if;
   end if;
end process P_spi_SPIREGIN_SPITXST;

------------------------------------------------------------------------------------------
-- Field name: SPIDATAW(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_spi_SPIREGIN(7 downto 0) <= field_rw_spi_SPIREGIN_SPIDATAW(7 downto 0);
regfile.spi.SPIREGIN.SPIDATAW <= field_rw_spi_SPIREGIN_SPIDATAW(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_spi_SPIREGIN_SPIDATAW
------------------------------------------------------------------------------------------
P_spi_SPIREGIN_SPIDATAW : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_spi_SPIREGIN_SPIDATAW <= std_logic_vector(to_unsigned(integer(0),8));
   elsif (rising_edge(sysclk)) then
      for j in  7 downto 0  loop
         if(wEn(22) = '1' and bitEnN(j) = '0') then
            field_rw_spi_SPIREGIN_SPIDATAW(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_spi_SPIREGIN_SPIDATAW;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: spi_SPIREGOUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(23) <= (hit(23)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SPI_WB_CAP
-- Field type: RO
------------------------------------------------------------------------------------------
rb_spi_SPIREGOUT(17) <= regfile.spi.SPIREGOUT.SPI_WB_CAP;


------------------------------------------------------------------------------------------
-- Field name: SPIWRTD
-- Field type: RO
------------------------------------------------------------------------------------------
rb_spi_SPIREGOUT(16) <= regfile.spi.SPIREGOUT.SPIWRTD;


------------------------------------------------------------------------------------------
-- Field name: SPIDATARD(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_spi_SPIREGOUT(7 downto 0) <= regfile.spi.SPIREGOUT.SPIDATARD;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: arbiter_ARBITER_CAPABILITIES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(24) <= (hit(24)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: AGENT_NB
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_arbiter_ARBITER_CAPABILITIES(17 downto 16) <= std_logic_vector(to_unsigned(integer(2),2));
regfile.arbiter.ARBITER_CAPABILITIES.AGENT_NB <= rb_arbiter_ARBITER_CAPABILITIES(17 downto 16);


------------------------------------------------------------------------------------------
-- Field name: TAG
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_arbiter_ARBITER_CAPABILITIES(11 downto 0) <= std_logic_vector(to_unsigned(integer(2731),12));
regfile.arbiter.ARBITER_CAPABILITIES.TAG <= rb_arbiter_ARBITER_CAPABILITIES(11 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: arbiter_AGENT_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(25) <= (hit(25)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ACK
-- Field type: RO
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_0(9) <= regfile.arbiter.AGENT(0).ACK;


------------------------------------------------------------------------------------------
-- Field name: REC
-- Field type: RO
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_0(8) <= regfile.arbiter.AGENT(0).REC;


------------------------------------------------------------------------------------------
-- Field name: DONE
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_0(4) <= '0';
regfile.arbiter.AGENT(0).DONE <= field_wautoclr_arbiter_AGENT_0_DONE;


------------------------------------------------------------------------------------------
-- Process: P_arbiter_AGENT_0_DONE
------------------------------------------------------------------------------------------
P_arbiter_AGENT_0_DONE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_arbiter_AGENT_0_DONE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(25) = '1' and bitEnN(4) = '0') then
         field_wautoclr_arbiter_AGENT_0_DONE <= reg_writedata(4);
      else
         field_wautoclr_arbiter_AGENT_0_DONE <= '0';
      end if;
   end if;
end process P_arbiter_AGENT_0_DONE;

------------------------------------------------------------------------------------------
-- Field name: REQ
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_0(0) <= '0';
regfile.arbiter.AGENT(0).REQ <= field_wautoclr_arbiter_AGENT_0_REQ;


------------------------------------------------------------------------------------------
-- Process: P_arbiter_AGENT_0_REQ
------------------------------------------------------------------------------------------
P_arbiter_AGENT_0_REQ : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_arbiter_AGENT_0_REQ <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(25) = '1' and bitEnN(0) = '0') then
         field_wautoclr_arbiter_AGENT_0_REQ <= reg_writedata(0);
      else
         field_wautoclr_arbiter_AGENT_0_REQ <= '0';
      end if;
   end if;
end process P_arbiter_AGENT_0_REQ;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: arbiter_AGENT_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(26) <= (hit(26)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ACK
-- Field type: RO
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_1(9) <= regfile.arbiter.AGENT(1).ACK;


------------------------------------------------------------------------------------------
-- Field name: REC
-- Field type: RO
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_1(8) <= regfile.arbiter.AGENT(1).REC;


------------------------------------------------------------------------------------------
-- Field name: DONE
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_1(4) <= '0';
regfile.arbiter.AGENT(1).DONE <= field_wautoclr_arbiter_AGENT_1_DONE;


------------------------------------------------------------------------------------------
-- Process: P_arbiter_AGENT_1_DONE
------------------------------------------------------------------------------------------
P_arbiter_AGENT_1_DONE : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_arbiter_AGENT_1_DONE <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(26) = '1' and bitEnN(4) = '0') then
         field_wautoclr_arbiter_AGENT_1_DONE <= reg_writedata(4);
      else
         field_wautoclr_arbiter_AGENT_1_DONE <= '0';
      end if;
   end if;
end process P_arbiter_AGENT_1_DONE;

------------------------------------------------------------------------------------------
-- Field name: REQ
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_arbiter_AGENT_1(0) <= '0';
regfile.arbiter.AGENT(1).REQ <= field_wautoclr_arbiter_AGENT_1_REQ;


------------------------------------------------------------------------------------------
-- Process: P_arbiter_AGENT_1_REQ
------------------------------------------------------------------------------------------
P_arbiter_AGENT_1_REQ : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_wautoclr_arbiter_AGENT_1_REQ <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(26) = '1' and bitEnN(0) = '0') then
         field_wautoclr_arbiter_AGENT_1_REQ <= reg_writedata(0);
      else
         field_wautoclr_arbiter_AGENT_1_REQ <= '0';
      end if;
   end if;
end process P_arbiter_AGENT_1_REQ;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(27) <= (hit(27)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_0_ctrl(0) <= field_rw_axi_window_0_ctrl_enable;
regfile.axi_window(0).ctrl.enable <= field_rw_axi_window_0_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_0_ctrl_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_0_ctrl_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(27) = '1' and bitEnN(0) = '0') then
         field_rw_axi_window_0_ctrl_enable <= reg_writedata(0);
      end if;
   end if;
end process P_axi_window_0_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(28) <= (hit(28)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_pci_bar0_start(25 downto 0) <= field_rw_axi_window_0_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).pci_bar0_start.value <= field_rw_axi_window_0_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_0_pci_bar0_start_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_0_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(28) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_0_pci_bar0_start_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_0_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(29) <= (hit(29)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_0_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).pci_bar0_stop.value <= field_rw_axi_window_0_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_0_pci_bar0_stop_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_0_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(29) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_0_pci_bar0_stop_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_0_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(30) <= (hit(30)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_axi_translation(31 downto 0) <= field_rw_axi_window_0_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).axi_translation.value <= field_rw_axi_window_0_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_0_axi_translation_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_0_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 2  loop
         if(wEn(30) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_0_axi_translation_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_0_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(31) <= (hit(31)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_1_ctrl(0) <= field_rw_axi_window_1_ctrl_enable;
regfile.axi_window(1).ctrl.enable <= field_rw_axi_window_1_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_1_ctrl_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_1_ctrl_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(31) = '1' and bitEnN(0) = '0') then
         field_rw_axi_window_1_ctrl_enable <= reg_writedata(0);
      end if;
   end if;
end process P_axi_window_1_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(32) <= (hit(32)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_pci_bar0_start(25 downto 0) <= field_rw_axi_window_1_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).pci_bar0_start.value <= field_rw_axi_window_1_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_1_pci_bar0_start_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_1_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(32) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_1_pci_bar0_start_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_1_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(33) <= (hit(33)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_1_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).pci_bar0_stop.value <= field_rw_axi_window_1_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_1_pci_bar0_stop_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_1_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(33) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_1_pci_bar0_stop_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_1_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(34) <= (hit(34)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_axi_translation(31 downto 0) <= field_rw_axi_window_1_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).axi_translation.value <= field_rw_axi_window_1_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_1_axi_translation_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_1_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 2  loop
         if(wEn(34) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_1_axi_translation_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_1_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(35) <= (hit(35)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_2_ctrl(0) <= field_rw_axi_window_2_ctrl_enable;
regfile.axi_window(2).ctrl.enable <= field_rw_axi_window_2_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_2_ctrl_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_2_ctrl_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(35) = '1' and bitEnN(0) = '0') then
         field_rw_axi_window_2_ctrl_enable <= reg_writedata(0);
      end if;
   end if;
end process P_axi_window_2_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(36) <= (hit(36)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_pci_bar0_start(25 downto 0) <= field_rw_axi_window_2_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).pci_bar0_start.value <= field_rw_axi_window_2_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_2_pci_bar0_start_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_2_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(36) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_2_pci_bar0_start_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_2_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(37) <= (hit(37)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_2_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).pci_bar0_stop.value <= field_rw_axi_window_2_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_2_pci_bar0_stop_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_2_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(37) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_2_pci_bar0_stop_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_2_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(38) <= (hit(38)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_axi_translation(31 downto 0) <= field_rw_axi_window_2_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).axi_translation.value <= field_rw_axi_window_2_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_2_axi_translation_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_2_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 2  loop
         if(wEn(38) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_2_axi_translation_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_2_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(39) <= (hit(39)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_3_ctrl(0) <= field_rw_axi_window_3_ctrl_enable;
regfile.axi_window(3).ctrl.enable <= field_rw_axi_window_3_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_3_ctrl_enable : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_3_ctrl_enable <= '0';
   elsif (rising_edge(sysclk)) then
      if(wEn(39) = '1' and bitEnN(0) = '0') then
         field_rw_axi_window_3_ctrl_enable <= reg_writedata(0);
      end if;
   end if;
end process P_axi_window_3_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(40) <= (hit(40)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_pci_bar0_start(25 downto 0) <= field_rw_axi_window_3_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).pci_bar0_start.value <= field_rw_axi_window_3_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_3_pci_bar0_start_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_3_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(40) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_3_pci_bar0_start_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_3_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(41) <= (hit(41)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_3_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).pci_bar0_stop.value <= field_rw_axi_window_3_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_3_pci_bar0_stop_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_3_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
   elsif (rising_edge(sysclk)) then
      for j in  25 downto 2  loop
         if(wEn(41) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_3_pci_bar0_stop_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_3_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(42) <= (hit(42)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_axi_translation(31 downto 0) <= field_rw_axi_window_3_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).axi_translation.value <= field_rw_axi_window_3_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_3_axi_translation_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_axi_window_3_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 2  loop
         if(wEn(42) = '1' and bitEnN(j) = '0') then
            field_rw_axi_window_3_axi_translation_value(j-2) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_axi_window_3_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_input
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(43) <= (hit(43)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_debug_input(31 downto 0) <= regfile.debug.input.value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_output
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(44) <= (hit(44)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_debug_output(31 downto 0) <= field_rw_debug_output_value(31 downto 0);
regfile.debug.output.value <= field_rw_debug_output_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_debug_output_value
------------------------------------------------------------------------------------------
P_debug_output_value : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_debug_output_value <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(44) = '1' and bitEnN(j) = '0') then
            field_rw_debug_output_value(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_debug_output_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_DMA_DEBUG1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(45) <= (hit(45)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ADD_START(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_debug_DMA_DEBUG1(31 downto 0) <= field_rw_debug_DMA_DEBUG1_ADD_START(31 downto 0);
regfile.debug.DMA_DEBUG1.ADD_START <= field_rw_debug_DMA_DEBUG1_ADD_START(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_debug_DMA_DEBUG1_ADD_START
------------------------------------------------------------------------------------------
P_debug_DMA_DEBUG1_ADD_START : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_debug_DMA_DEBUG1_ADD_START <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(45) = '1' and bitEnN(j) = '0') then
            field_rw_debug_DMA_DEBUG1_ADD_START(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_debug_DMA_DEBUG1_ADD_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_DMA_DEBUG2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(46) <= (hit(46)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ADD_OVERRUN(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_debug_DMA_DEBUG2(31 downto 0) <= field_rw_debug_DMA_DEBUG2_ADD_OVERRUN(31 downto 0);
regfile.debug.DMA_DEBUG2.ADD_OVERRUN <= field_rw_debug_DMA_DEBUG2_ADD_OVERRUN(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_debug_DMA_DEBUG2_ADD_OVERRUN
------------------------------------------------------------------------------------------
P_debug_DMA_DEBUG2_ADD_OVERRUN : process(sysclk, resetN)
begin
   if (resetN = '0') then
      field_rw_debug_DMA_DEBUG2_ADD_OVERRUN <= X"00000000";
   elsif (rising_edge(sysclk)) then
      for j in  31 downto 0  loop
         if(wEn(46) = '1' and bitEnN(j) = '0') then
            field_rw_debug_DMA_DEBUG2_ADD_OVERRUN(j-0) <= reg_writedata(j);
         end if;
      end loop;
   end if;
end process P_debug_DMA_DEBUG2_ADD_OVERRUN;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: debug_DMA_DEBUG3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(47) <= (hit(47)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DMA_ADD_ERROR
-- Field type: RO
------------------------------------------------------------------------------------------
rb_debug_DMA_DEBUG3(4) <= regfile.debug.DMA_DEBUG3.DMA_ADD_ERROR;


------------------------------------------------------------------------------------------
-- Field name: DMA_OVERRUN
-- Field type: RO
------------------------------------------------------------------------------------------
rb_debug_DMA_DEBUG3(0) <= regfile.debug.DMA_DEBUG3.DMA_OVERRUN;


ldData <= reg_read;

end rtl;

