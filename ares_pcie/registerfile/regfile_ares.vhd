-------------------------------------------------------------------------------
-- File                : regfile_ares.vhd
-- Project             : FDK
-- Module              : regfile_ares_pack
-- Created on          : 2021/02/08 15:55:29
-- Created by          : amarchan
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xA7167277
-------------------------------------------------------------------------------
library ieee;        -- The standard IEEE library
   use ieee.std_logic_1164.all  ;
   use ieee.numeric_std.all     ;
   use ieee.std_logic_unsigned.all;


package regfile_ares_pack is
   --------------------------------------------------------------------------------
   -- Address constants
   --------------------------------------------------------------------------------
   constant K_Device_specific_INTSTAT_ADDR                : natural := 16#0#;
   constant K_Device_specific_INTMASKn_ADDR               : natural := 16#4#;
   constant K_Device_specific_INTSTAT2_ADDR               : natural := 16#8#;
   constant K_Device_specific_BUILDID_ADDR                : natural := 16#1c#;
   constant K_Device_specific_FPGA_ID_ADDR                : natural := 16#20#;
   constant K_Device_specific_LED_OVERRIDE_ADDR           : natural := 16#24#;
   constant K_INTERRUPT_QUEUE_CONTROL_ADDR                : natural := 16#40#;
   constant K_INTERRUPT_QUEUE_CONS_IDX_ADDR               : natural := 16#44#;
   constant K_INTERRUPT_QUEUE_ADDR_LOW_ADDR               : natural := 16#48#;
   constant K_INTERRUPT_QUEUE_ADDR_HIGH_ADDR              : natural := 16#4c#;
   constant K_INTERRUPT_QUEUE_MAPPING_ADDR                : natural := 16#50#;
   constant K_tlp_timeout_ADDR                            : natural := 16#70#;
   constant K_tlp_transaction_abort_cntr_ADDR             : natural := 16#74#;
   constant K_SPI_SPIREGIN_ADDR                           : natural := 16#e0#;
   constant K_SPI_SPIREGOUT_ADDR                          : natural := 16#e8#;
   constant K_arbiter_ARBITER_CAPABILITIES_ADDR           : natural := 16#f0#;
   constant K_arbiter_AGENT_0_ADDR                        : natural := 16#f4#;
   constant K_arbiter_AGENT_1_ADDR                        : natural := 16#f8#;
   constant K_axi_window_0_ctrl_ADDR                      : natural := 16#100#;
   constant K_axi_window_0_pci_bar0_start_ADDR            : natural := 16#104#;
   constant K_axi_window_0_pci_bar0_stop_ADDR             : natural := 16#108#;
   constant K_axi_window_0_axi_translation_ADDR           : natural := 16#10c#;
   constant K_axi_window_1_ctrl_ADDR                      : natural := 16#110#;
   constant K_axi_window_1_pci_bar0_start_ADDR            : natural := 16#114#;
   constant K_axi_window_1_pci_bar0_stop_ADDR             : natural := 16#118#;
   constant K_axi_window_1_axi_translation_ADDR           : natural := 16#11c#;
   constant K_axi_window_2_ctrl_ADDR                      : natural := 16#120#;
   constant K_axi_window_2_pci_bar0_start_ADDR            : natural := 16#124#;
   constant K_axi_window_2_pci_bar0_stop_ADDR             : natural := 16#128#;
   constant K_axi_window_2_axi_translation_ADDR           : natural := 16#12c#;
   constant K_axi_window_3_ctrl_ADDR                      : natural := 16#130#;
   constant K_axi_window_3_pci_bar0_start_ADDR            : natural := 16#134#;
   constant K_axi_window_3_pci_bar0_stop_ADDR             : natural := 16#138#;
   constant K_axi_window_3_axi_translation_ADDR           : natural := 16#13c#;
   constant K_IO_0_CAPABILITIES_IO_ADDR                   : natural := 16#200#;
   constant K_IO_0_IO_PIN_ADDR                            : natural := 16#204#;
   constant K_IO_0_IO_OUT_ADDR                            : natural := 16#208#;
   constant K_IO_0_IO_DIR_ADDR                            : natural := 16#20c#;
   constant K_IO_0_IO_POL_ADDR                            : natural := 16#210#;
   constant K_IO_0_IO_INTSTAT_ADDR                        : natural := 16#214#;
   constant K_IO_0_IO_INTMASKn_ADDR                       : natural := 16#218#;
   constant K_IO_0_IO_ANYEDGE_ADDR                        : natural := 16#21c#;
   constant K_IO_1_CAPABILITIES_IO_ADDR                   : natural := 16#280#;
   constant K_IO_1_IO_PIN_ADDR                            : natural := 16#284#;
   constant K_IO_1_IO_OUT_ADDR                            : natural := 16#288#;
   constant K_IO_1_IO_DIR_ADDR                            : natural := 16#28c#;
   constant K_IO_1_IO_POL_ADDR                            : natural := 16#290#;
   constant K_IO_1_IO_INTSTAT_ADDR                        : natural := 16#294#;
   constant K_IO_1_IO_INTMASKn_ADDR                       : natural := 16#298#;
   constant K_IO_1_IO_ANYEDGE_ADDR                        : natural := 16#29c#;
   constant K_Quadrature_0_CAPABILITIES_QUAD_ADDR         : natural := 16#300#;
   constant K_Quadrature_0_PositionReset_ADDR             : natural := 16#304#;
   constant K_Quadrature_0_DecoderInput_ADDR              : natural := 16#308#;
   constant K_Quadrature_0_DecoderCfg_ADDR                : natural := 16#30c#;
   constant K_Quadrature_0_DecoderPosTrigger_ADDR         : natural := 16#310#;
   constant K_Quadrature_0_DecoderCntrLatch_Cfg_ADDR      : natural := 16#314#;
   constant K_Quadrature_0_DecoderCntrLatched_SW_ADDR     : natural := 16#334#;
   constant K_Quadrature_0_DecoderCntrLatched_ADDR        : natural := 16#338#;
   constant K_TickTable_0_CAPABILITIES_TICKTBL_ADDR       : natural := 16#380#;
   constant K_TickTable_0_CAPABILITIES_EXT1_ADDR          : natural := 16#384#;
   constant K_TickTable_0_TickTableClockPeriod_ADDR       : natural := 16#388#;
   constant K_TickTable_0_TickConfig_ADDR                 : natural := 16#38c#;
   constant K_TickTable_0_CurrentStampLatched_ADDR        : natural := 16#390#;
   constant K_TickTable_0_WriteTime_ADDR                  : natural := 16#394#;
   constant K_TickTable_0_WriteCommand_ADDR               : natural := 16#398#;
   constant K_TickTable_0_LatchIntStat_ADDR               : natural := 16#39c#;
   constant K_TickTable_0_InputStamp_0_ADDR               : natural := 16#3a0#;
   constant K_TickTable_0_InputStamp_1_ADDR               : natural := 16#3a4#;
   constant K_TickTable_0_reserved_for_extra_latch_0_ADDR : natural := 16#3a8#;
   constant K_TickTable_0_reserved_for_extra_latch_1_ADDR : natural := 16#3ac#;
   constant K_TickTable_0_reserved_for_extra_latch_2_ADDR : natural := 16#3b0#;
   constant K_TickTable_0_reserved_for_extra_latch_3_ADDR : natural := 16#3b4#;
   constant K_TickTable_0_reserved_for_extra_latch_4_ADDR : natural := 16#3b8#;
   constant K_TickTable_0_reserved_for_extra_latch_5_ADDR : natural := 16#3bc#;
   constant K_TickTable_0_reserved_for_extra_latch_6_ADDR : natural := 16#3c0#;
   constant K_TickTable_0_reserved_for_extra_latch_7_ADDR : natural := 16#3c4#;
   constant K_TickTable_0_reserved_for_extra_latch_8_ADDR : natural := 16#3c8#;
   constant K_TickTable_0_reserved_for_extra_latch_9_ADDR : natural := 16#3cc#;
   constant K_TickTable_0_InputStampLatched_0_ADDR        : natural := 16#3d0#;
   constant K_TickTable_0_InputStampLatched_1_ADDR        : natural := 16#3d4#;
   constant K_InputConditioning_CAPABILITIES_INCOND_ADDR  : natural := 16#400#;
   constant K_InputConditioning_InputConditioning_0_ADDR  : natural := 16#404#;
   constant K_InputConditioning_InputConditioning_1_ADDR  : natural := 16#408#;
   constant K_InputConditioning_InputConditioning_2_ADDR  : natural := 16#40c#;
   constant K_InputConditioning_InputConditioning_3_ADDR  : natural := 16#410#;
   constant K_OutputConditioning_CAPABILITIES_OUTCOND_ADDR : natural := 16#480#;
   constant K_OutputConditioning_OutputCond_0_ADDR        : natural := 16#484#;
   constant K_OutputConditioning_OutputCond_1_ADDR        : natural := 16#488#;
   constant K_OutputConditioning_OutputCond_2_ADDR        : natural := 16#48c#;
   constant K_OutputConditioning_OutputCond_3_ADDR        : natural := 16#490#;
   constant K_OutputConditioning_Reserved_ADDR            : natural := 16#494#;
   constant K_OutputConditioning_Output_Debounce_ADDR     : natural := 16#4ac#;
   constant K_InternalInput_CAPABILITIES_INT_INP_ADDR     : natural := 16#500#;
   constant K_InternalOutput_CAPABILITIES_INTOUT_ADDR     : natural := 16#580#;
   constant K_InternalOutput_OutputCond_0_ADDR            : natural := 16#584#;
   constant K_Timer_0_CAPABILITIES_TIMER_ADDR             : natural := 16#600#;
   constant K_Timer_0_TimerClockPeriod_ADDR               : natural := 16#604#;
   constant K_Timer_0_TimerTriggerArm_ADDR                : natural := 16#608#;
   constant K_Timer_0_TimerClockSource_ADDR               : natural := 16#60c#;
   constant K_Timer_0_TimerDelayValue_ADDR                : natural := 16#610#;
   constant K_Timer_0_TimerDuration_ADDR                  : natural := 16#614#;
   constant K_Timer_0_TimerLatchedValue_ADDR              : natural := 16#618#;
   constant K_Timer_0_TimerStatus_ADDR                    : natural := 16#61c#;
   constant K_Timer_1_CAPABILITIES_TIMER_ADDR             : natural := 16#680#;
   constant K_Timer_1_TimerClockPeriod_ADDR               : natural := 16#684#;
   constant K_Timer_1_TimerTriggerArm_ADDR                : natural := 16#688#;
   constant K_Timer_1_TimerClockSource_ADDR               : natural := 16#68c#;
   constant K_Timer_1_TimerDelayValue_ADDR                : natural := 16#690#;
   constant K_Timer_1_TimerDuration_ADDR                  : natural := 16#694#;
   constant K_Timer_1_TimerLatchedValue_ADDR              : natural := 16#698#;
   constant K_Timer_1_TimerStatus_ADDR                    : natural := 16#69c#;
   constant K_Timer_2_CAPABILITIES_TIMER_ADDR             : natural := 16#700#;
   constant K_Timer_2_TimerClockPeriod_ADDR               : natural := 16#704#;
   constant K_Timer_2_TimerTriggerArm_ADDR                : natural := 16#708#;
   constant K_Timer_2_TimerClockSource_ADDR               : natural := 16#70c#;
   constant K_Timer_2_TimerDelayValue_ADDR                : natural := 16#710#;
   constant K_Timer_2_TimerDuration_ADDR                  : natural := 16#714#;
   constant K_Timer_2_TimerLatchedValue_ADDR              : natural := 16#718#;
   constant K_Timer_2_TimerStatus_ADDR                    : natural := 16#71c#;
   constant K_Timer_3_CAPABILITIES_TIMER_ADDR             : natural := 16#780#;
   constant K_Timer_3_TimerClockPeriod_ADDR               : natural := 16#784#;
   constant K_Timer_3_TimerTriggerArm_ADDR                : natural := 16#788#;
   constant K_Timer_3_TimerClockSource_ADDR               : natural := 16#78c#;
   constant K_Timer_3_TimerDelayValue_ADDR                : natural := 16#790#;
   constant K_Timer_3_TimerDuration_ADDR                  : natural := 16#794#;
   constant K_Timer_3_TimerLatchedValue_ADDR              : natural := 16#798#;
   constant K_Timer_3_TimerStatus_ADDR                    : natural := 16#79c#;
   constant K_Timer_4_CAPABILITIES_TIMER_ADDR             : natural := 16#800#;
   constant K_Timer_4_TimerClockPeriod_ADDR               : natural := 16#804#;
   constant K_Timer_4_TimerTriggerArm_ADDR                : natural := 16#808#;
   constant K_Timer_4_TimerClockSource_ADDR               : natural := 16#80c#;
   constant K_Timer_4_TimerDelayValue_ADDR                : natural := 16#810#;
   constant K_Timer_4_TimerDuration_ADDR                  : natural := 16#814#;
   constant K_Timer_4_TimerLatchedValue_ADDR              : natural := 16#818#;
   constant K_Timer_4_TimerStatus_ADDR                    : natural := 16#81c#;
   constant K_Timer_5_CAPABILITIES_TIMER_ADDR             : natural := 16#880#;
   constant K_Timer_5_TimerClockPeriod_ADDR               : natural := 16#884#;
   constant K_Timer_5_TimerTriggerArm_ADDR                : natural := 16#888#;
   constant K_Timer_5_TimerClockSource_ADDR               : natural := 16#88c#;
   constant K_Timer_5_TimerDelayValue_ADDR                : natural := 16#890#;
   constant K_Timer_5_TimerDuration_ADDR                  : natural := 16#894#;
   constant K_Timer_5_TimerLatchedValue_ADDR              : natural := 16#898#;
   constant K_Timer_5_TimerStatus_ADDR                    : natural := 16#89c#;
   constant K_Timer_6_CAPABILITIES_TIMER_ADDR             : natural := 16#900#;
   constant K_Timer_6_TimerClockPeriod_ADDR               : natural := 16#904#;
   constant K_Timer_6_TimerTriggerArm_ADDR                : natural := 16#908#;
   constant K_Timer_6_TimerClockSource_ADDR               : natural := 16#90c#;
   constant K_Timer_6_TimerDelayValue_ADDR                : natural := 16#910#;
   constant K_Timer_6_TimerDuration_ADDR                  : natural := 16#914#;
   constant K_Timer_6_TimerLatchedValue_ADDR              : natural := 16#918#;
   constant K_Timer_6_TimerStatus_ADDR                    : natural := 16#91c#;
   constant K_Timer_7_CAPABILITIES_TIMER_ADDR             : natural := 16#980#;
   constant K_Timer_7_TimerClockPeriod_ADDR               : natural := 16#984#;
   constant K_Timer_7_TimerTriggerArm_ADDR                : natural := 16#988#;
   constant K_Timer_7_TimerClockSource_ADDR               : natural := 16#98c#;
   constant K_Timer_7_TimerDelayValue_ADDR                : natural := 16#990#;
   constant K_Timer_7_TimerDuration_ADDR                  : natural := 16#994#;
   constant K_Timer_7_TimerLatchedValue_ADDR              : natural := 16#998#;
   constant K_Timer_7_TimerStatus_ADDR                    : natural := 16#99c#;
   constant K_Microblaze_CAPABILITIES_MICRO_ADDR          : natural := 16#a00#;
   constant K_Microblaze_ProdCons_0_ADDR                  : natural := 16#a04#;
   constant K_Microblaze_ProdCons_1_ADDR                  : natural := 16#a08#;
   constant K_AnalogOutput_CAPABILITIES_ANA_OUT_ADDR      : natural := 16#a80#;
   constant K_AnalogOutput_OutputValue_ADDR               : natural := 16#a84#;
   constant K_EOFM_EOFM_ADDR                              : natural := 16#b00#;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: INTSTAT
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_INTSTAT_TYPE is record
      IRQ_TICK_LATCH : std_logic;
      IRQ_TICK_LATCH_set: std_logic;
      IRQ_MICROBLAZE : std_logic;
      IRQ_MICROBLAZE_set: std_logic;
      IRQ_TICK_WA    : std_logic;
      IRQ_TICK_WA_set: std_logic;
      IRQ_TIMER      : std_logic;
      IRQ_TICK       : std_logic;
      IRQ_TICK_set   : std_logic;
      IRQ_IO         : std_logic;
      IRQ_IO_set     : std_logic;
   end record DEVICE_SPECIFIC_INTSTAT_TYPE;

   constant INIT_DEVICE_SPECIFIC_INTSTAT_TYPE : DEVICE_SPECIFIC_INTSTAT_TYPE := (
      IRQ_TICK_LATCH  => 'Z',
      IRQ_TICK_LATCH_set => 'Z',
      IRQ_MICROBLAZE  => 'Z',
      IRQ_MICROBLAZE_set => 'Z',
      IRQ_TICK_WA     => 'Z',
      IRQ_TICK_WA_set => 'Z',
      IRQ_TIMER       => 'Z',
      IRQ_TICK        => 'Z',
      IRQ_TICK_set    => 'Z',
      IRQ_IO          => 'Z',
      IRQ_IO_set      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTSTAT_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_INTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTSTAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: INTMASKn
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_INTMASKN_TYPE is record
      IRQ_TICK_LATCH : std_logic;
      IRQ_MICROBLAZE : std_logic;
      IRQ_TICK_WA    : std_logic;
      IRQ_TIMER      : std_logic;
      IRQ_TICK       : std_logic;
      IRQ_IO         : std_logic;
   end record DEVICE_SPECIFIC_INTMASKN_TYPE;

   constant INIT_DEVICE_SPECIFIC_INTMASKN_TYPE : DEVICE_SPECIFIC_INTMASKN_TYPE := (
      IRQ_TICK_LATCH  => 'Z',
      IRQ_MICROBLAZE  => 'Z',
      IRQ_TICK_WA     => 'Z',
      IRQ_TIMER       => 'Z',
      IRQ_TICK        => 'Z',
      IRQ_IO          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTMASKN_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_INTMASKN_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTMASKN_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: INTSTAT2
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_INTSTAT2_TYPE is record
      IRQ_TIMER_END  : std_logic_vector(7 downto 0);
      IRQ_TIMER_END_set: std_logic_vector(7 downto 0);
      IRQ_TIMER_START: std_logic_vector(7 downto 0);
      IRQ_TIMER_START_set: std_logic_vector(7 downto 0);
   end record DEVICE_SPECIFIC_INTSTAT2_TYPE;

   constant INIT_DEVICE_SPECIFIC_INTSTAT2_TYPE : DEVICE_SPECIFIC_INTSTAT2_TYPE := (
      IRQ_TIMER_END   => (others=> 'Z'),
      IRQ_TIMER_END_set => (others=> 'Z'),
      IRQ_TIMER_START => (others=> 'Z'),
      IRQ_TIMER_START_set => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTSTAT2_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_INTSTAT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTSTAT2_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: BUILDID
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_BUILDID_TYPE is record
      VALUE          : std_logic_vector(31 downto 0);
   end record DEVICE_SPECIFIC_BUILDID_TYPE;

   constant INIT_DEVICE_SPECIFIC_BUILDID_TYPE : DEVICE_SPECIFIC_BUILDID_TYPE := (
      VALUE           => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_BUILDID_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_BUILDID_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_BUILDID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: FPGA_ID
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_FPGA_ID_TYPE is record
      FPGA_STRAPS    : std_logic_vector(3 downto 0);
      USER_RED_LED   : std_logic;
      USER_GREEN_LED : std_logic;
      PROFINET_LED   : std_logic;
      PB_DEBUG_COM   : std_logic;
      FPGA_ID        : std_logic_vector(4 downto 0);
   end record DEVICE_SPECIFIC_FPGA_ID_TYPE;

   constant INIT_DEVICE_SPECIFIC_FPGA_ID_TYPE : DEVICE_SPECIFIC_FPGA_ID_TYPE := (
      FPGA_STRAPS     => (others=> 'Z'),
      USER_RED_LED    => 'Z',
      USER_GREEN_LED  => 'Z',
      PROFINET_LED    => 'Z',
      PB_DEBUG_COM    => 'Z',
      FPGA_ID         => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_FPGA_ID_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_FPGA_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_FPGA_ID_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LED_OVERRIDE
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_LED_OVERRIDE_TYPE is record
      RED_ORANGE_FLASH: std_logic;
      ORANGE_OFF_FLASH: std_logic;
   end record DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;

   constant INIT_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE : DEVICE_SPECIFIC_LED_OVERRIDE_TYPE := (
      RED_ORANGE_FLASH => 'Z',
      ORANGE_OFF_FLASH => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_LED_OVERRIDE_TYPE) return std_logic_vector;
   function to_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CONTROL
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_CONTROL_TYPE is record
      NB_DW          : std_logic_vector(7 downto 0);
      ENABLE         : std_logic;
   end record INTERRUPT_QUEUE_CONTROL_TYPE;

   constant INIT_INTERRUPT_QUEUE_CONTROL_TYPE : INTERRUPT_QUEUE_CONTROL_TYPE := (
      NB_DW           => (others=> 'Z'),
      ENABLE          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONTROL_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_CONTROL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONTROL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CONS_IDX
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_CONS_IDX_TYPE is record
      CONS_IDX       : std_logic_vector(9 downto 0);
   end record INTERRUPT_QUEUE_CONS_IDX_TYPE;

   constant INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE : INTERRUPT_QUEUE_CONS_IDX_TYPE := (
      CONS_IDX        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONS_IDX_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_CONS_IDX_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONS_IDX_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ADDR_LOW
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_ADDR_LOW_TYPE is record
      ADDR           : std_logic_vector(31 downto 0);
   end record INTERRUPT_QUEUE_ADDR_LOW_TYPE;

   constant INIT_INTERRUPT_QUEUE_ADDR_LOW_TYPE : INTERRUPT_QUEUE_ADDR_LOW_TYPE := (
      ADDR            => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_LOW_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_ADDR_LOW_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_LOW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ADDR_HIGH
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_ADDR_HIGH_TYPE is record
      ADDR           : std_logic_vector(31 downto 0);
   end record INTERRUPT_QUEUE_ADDR_HIGH_TYPE;

   constant INIT_INTERRUPT_QUEUE_ADDR_HIGH_TYPE : INTERRUPT_QUEUE_ADDR_HIGH_TYPE := (
      ADDR            => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_ADDR_HIGH_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: MAPPING
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_MAPPING_TYPE is record
      IRQ_TIMER_END  : std_logic_vector(7 downto 0);
      IRQ_TIMER_START: std_logic_vector(7 downto 0);
      IO_INTSTAT     : std_logic_vector(3 downto 0);
      IRQ_TICK_LATCH : std_logic;
      IRQ_MICROBLAZE : std_logic;
      IRQ_TIMER      : std_logic;
      IRQ_TICK_WA    : std_logic;
      IRQ_TICK       : std_logic;
      IRQ_IO         : std_logic;
   end record INTERRUPT_QUEUE_MAPPING_TYPE;

   constant INIT_INTERRUPT_QUEUE_MAPPING_TYPE : INTERRUPT_QUEUE_MAPPING_TYPE := (
      IRQ_TIMER_END   => (others=> 'Z'),
      IRQ_TIMER_START => (others=> 'Z'),
      IO_INTSTAT      => (others=> 'Z'),
      IRQ_TICK_LATCH  => 'Z',
      IRQ_MICROBLAZE  => 'Z',
      IRQ_TIMER       => 'Z',
      IRQ_TICK_WA     => 'Z',
      IRQ_TICK        => 'Z',
      IRQ_IO          => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_MAPPING_TYPE) return std_logic_vector;
   function to_INTERRUPT_QUEUE_MAPPING_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_MAPPING_TYPE;
   
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
      SPI_ENABLE     : std_logic;
      SPIRW          : std_logic;
      SPICMDDONE     : std_logic;
      SPISEL         : std_logic;
      SPITXST        : std_logic;
      SPIDATAW       : std_logic_vector(7 downto 0);
   end record SPI_SPIREGIN_TYPE;

   constant INIT_SPI_SPIREGIN_TYPE : SPI_SPIREGIN_TYPE := (
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
   -- Register Name: CAPABILITIES_IO
   ------------------------------------------------------------------------------------------
   type IO_CAPABILITIES_IO_TYPE is record
      IO_ID          : std_logic_vector(7 downto 0);
      N_port         : std_logic_vector(4 downto 0);
      Input          : std_logic;
      Output         : std_logic;
      Intnum         : std_logic_vector(4 downto 0);
   end record IO_CAPABILITIES_IO_TYPE;

   constant INIT_IO_CAPABILITIES_IO_TYPE : IO_CAPABILITIES_IO_TYPE := (
      IO_ID           => (others=> 'Z'),
      N_port          => (others=> 'Z'),
      Input           => 'Z',
      Output          => 'Z',
      Intnum          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_CAPABILITIES_IO_TYPE) return std_logic_vector;
   function to_IO_CAPABILITIES_IO_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_CAPABILITIES_IO_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_PIN
   ------------------------------------------------------------------------------------------
   type IO_IO_PIN_TYPE is record
      Pin_value      : std_logic_vector(3 downto 0);
   end record IO_IO_PIN_TYPE;

   constant INIT_IO_IO_PIN_TYPE : IO_IO_PIN_TYPE := (
      Pin_value       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_PIN_TYPE) return std_logic_vector;
   function to_IO_IO_PIN_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_PIN_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_OUT
   ------------------------------------------------------------------------------------------
   type IO_IO_OUT_TYPE is record
      Out_value      : std_logic_vector(3 downto 0);
   end record IO_IO_OUT_TYPE;

   constant INIT_IO_IO_OUT_TYPE : IO_IO_OUT_TYPE := (
      Out_value       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_OUT_TYPE) return std_logic_vector;
   function to_IO_IO_OUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_OUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_DIR
   ------------------------------------------------------------------------------------------
   type IO_IO_DIR_TYPE is record
      Dir            : std_logic_vector(3 downto 0);
   end record IO_IO_DIR_TYPE;

   constant INIT_IO_IO_DIR_TYPE : IO_IO_DIR_TYPE := (
      Dir             => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_DIR_TYPE) return std_logic_vector;
   function to_IO_IO_DIR_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_DIR_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_POL
   ------------------------------------------------------------------------------------------
   type IO_IO_POL_TYPE is record
      In_pol         : std_logic_vector(3 downto 0);
   end record IO_IO_POL_TYPE;

   constant INIT_IO_IO_POL_TYPE : IO_IO_POL_TYPE := (
      In_pol          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_POL_TYPE) return std_logic_vector;
   function to_IO_IO_POL_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_POL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_INTSTAT
   ------------------------------------------------------------------------------------------
   type IO_IO_INTSTAT_TYPE is record
      Intstat        : std_logic_vector(3 downto 0);
      Intstat_set    : std_logic_vector(3 downto 0);
   end record IO_IO_INTSTAT_TYPE;

   constant INIT_IO_IO_INTSTAT_TYPE : IO_IO_INTSTAT_TYPE := (
      Intstat         => (others=> 'Z'),
      Intstat_set     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_INTSTAT_TYPE) return std_logic_vector;
   function to_IO_IO_INTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_INTSTAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_INTMASKn
   ------------------------------------------------------------------------------------------
   type IO_IO_INTMASKN_TYPE is record
      Intmaskn       : std_logic_vector(3 downto 0);
   end record IO_IO_INTMASKN_TYPE;

   constant INIT_IO_IO_INTMASKN_TYPE : IO_IO_INTMASKN_TYPE := (
      Intmaskn        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_INTMASKN_TYPE) return std_logic_vector;
   function to_IO_IO_INTMASKN_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_INTMASKN_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: IO_ANYEDGE
   ------------------------------------------------------------------------------------------
   type IO_IO_ANYEDGE_TYPE is record
      In_AnyEdge     : std_logic_vector(3 downto 0);
   end record IO_IO_ANYEDGE_TYPE;

   constant INIT_IO_IO_ANYEDGE_TYPE : IO_IO_ANYEDGE_TYPE := (
      In_AnyEdge      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : IO_IO_ANYEDGE_TYPE) return std_logic_vector;
   function to_IO_IO_ANYEDGE_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_ANYEDGE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_QUAD
   ------------------------------------------------------------------------------------------
   type QUADRATURE_CAPABILITIES_QUAD_TYPE is record
      QUADRATURE_ID  : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
   end record QUADRATURE_CAPABILITIES_QUAD_TYPE;

   constant INIT_QUADRATURE_CAPABILITIES_QUAD_TYPE : QUADRATURE_CAPABILITIES_QUAD_TYPE := (
      QUADRATURE_ID   => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_CAPABILITIES_QUAD_TYPE) return std_logic_vector;
   function to_QUADRATURE_CAPABILITIES_QUAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_CAPABILITIES_QUAD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: PositionReset
   ------------------------------------------------------------------------------------------
   type QUADRATURE_POSITIONRESET_TYPE is record
      PositionResetSource: std_logic_vector(3 downto 0);
      PositionResetActivation: std_logic;
      soft_PositionReset: std_logic;
   end record QUADRATURE_POSITIONRESET_TYPE;

   constant INIT_QUADRATURE_POSITIONRESET_TYPE : QUADRATURE_POSITIONRESET_TYPE := (
      PositionResetSource => (others=> 'Z'),
      PositionResetActivation => 'Z',
      soft_PositionReset => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_POSITIONRESET_TYPE) return std_logic_vector;
   function to_QUADRATURE_POSITIONRESET_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_POSITIONRESET_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderInput
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERINPUT_TYPE is record
      BSelector      : std_logic_vector(2 downto 0);
      ASelector      : std_logic_vector(2 downto 0);
   end record QUADRATURE_DECODERINPUT_TYPE;

   constant INIT_QUADRATURE_DECODERINPUT_TYPE : QUADRATURE_DECODERINPUT_TYPE := (
      BSelector       => (others=> 'Z'),
      ASelector       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERINPUT_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERINPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERINPUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderCfg
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERCFG_TYPE is record
      DecOutSource0  : std_logic_vector(2 downto 0);
      QuadEnable     : std_logic;
   end record QUADRATURE_DECODERCFG_TYPE;

   constant INIT_QUADRATURE_DECODERCFG_TYPE : QUADRATURE_DECODERCFG_TYPE := (
      DecOutSource0   => (others=> 'Z'),
      QuadEnable      => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERCFG_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERCFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCFG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderPosTrigger
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERPOSTRIGGER_TYPE is record
      PositionTrigger: std_logic_vector(31 downto 0);
   end record QUADRATURE_DECODERPOSTRIGGER_TYPE;

   constant INIT_QUADRATURE_DECODERPOSTRIGGER_TYPE : QUADRATURE_DECODERPOSTRIGGER_TYPE := (
      PositionTrigger => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERPOSTRIGGER_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERPOSTRIGGER_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERPOSTRIGGER_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderCntrLatch_Cfg
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERCNTRLATCH_CFG_TYPE is record
      DecoderCntrLatch_SW: std_logic;
      DecoderCntrLatch_Src: std_logic_vector(4 downto 0);
      DecoderCntrLatch_En: std_logic;
      DecoderCntrLatch_Act: std_logic_vector(1 downto 0);
   end record QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;

   constant INIT_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE : QUADRATURE_DECODERCNTRLATCH_CFG_TYPE := (
      DecoderCntrLatch_SW => 'Z',
      DecoderCntrLatch_Src => (others=> 'Z'),
      DecoderCntrLatch_En => 'Z',
      DecoderCntrLatch_Act => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCH_CFG_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderCntrLatched_SW
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERCNTRLATCHED_SW_TYPE is record
      DecoderCntr    : std_logic_vector(31 downto 0);
   end record QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;

   constant INIT_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE : QUADRATURE_DECODERCNTRLATCHED_SW_TYPE := (
      DecoderCntr     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCHED_SW_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: DecoderCntrLatched
   ------------------------------------------------------------------------------------------
   type QUADRATURE_DECODERCNTRLATCHED_TYPE is record
      DecoderCntr    : std_logic_vector(31 downto 0);
   end record QUADRATURE_DECODERCNTRLATCHED_TYPE;

   constant INIT_QUADRATURE_DECODERCNTRLATCHED_TYPE : QUADRATURE_DECODERCNTRLATCHED_TYPE := (
      DecoderCntr     => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCHED_TYPE) return std_logic_vector;
   function to_QUADRATURE_DECODERCNTRLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCHED_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_TICKTBL
   ------------------------------------------------------------------------------------------
   type TICKTABLE_CAPABILITIES_TICKTBL_TYPE is record
      TICKTABLE_ID   : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_ELEMENTS    : std_logic_vector(4 downto 0);
      INTNUM         : std_logic_vector(4 downto 0);
   end record TICKTABLE_CAPABILITIES_TICKTBL_TYPE;

   constant INIT_TICKTABLE_CAPABILITIES_TICKTBL_TYPE : TICKTABLE_CAPABILITIES_TICKTBL_TYPE := (
      TICKTABLE_ID    => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_ELEMENTS     => (others=> 'Z'),
      INTNUM          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_CAPABILITIES_TICKTBL_TYPE) return std_logic_vector;
   function to_TICKTABLE_CAPABILITIES_TICKTBL_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CAPABILITIES_TICKTBL_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_EXT1
   ------------------------------------------------------------------------------------------
   type TICKTABLE_CAPABILITIES_EXT1_TYPE is record
      TABLE_WIDTH    : std_logic_vector(7 downto 0);
      NB_LATCH       : std_logic_vector(3 downto 0);
   end record TICKTABLE_CAPABILITIES_EXT1_TYPE;

   constant INIT_TICKTABLE_CAPABILITIES_EXT1_TYPE : TICKTABLE_CAPABILITIES_EXT1_TYPE := (
      TABLE_WIDTH     => (others=> 'Z'),
      NB_LATCH        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_CAPABILITIES_EXT1_TYPE) return std_logic_vector;
   function to_TICKTABLE_CAPABILITIES_EXT1_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CAPABILITIES_EXT1_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TickTableClockPeriod
   ------------------------------------------------------------------------------------------
   type TICKTABLE_TICKTABLECLOCKPERIOD_TYPE is record
      Period_ns      : std_logic_vector(7 downto 0);
   end record TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;

   constant INIT_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE : TICKTABLE_TICKTABLECLOCKPERIOD_TYPE := (
      Period_ns       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_TICKTABLECLOCKPERIOD_TYPE) return std_logic_vector;
   function to_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TickConfig
   ------------------------------------------------------------------------------------------
   type TICKTABLE_TICKCONFIG_TYPE is record
      ClearTickTable : std_logic;
      ClearMask      : std_logic_vector(7 downto 0);
      TickClock      : std_logic_vector(3 downto 0);
      IntClock_sel   : std_logic_vector(1 downto 0);
      TickClockActivation: std_logic_vector(1 downto 0);
      EnableHalftableInt: std_logic;
      IntClock_en    : std_logic;
      LatchCurrentStamp: std_logic;
      ResetTimestamp : std_logic;
   end record TICKTABLE_TICKCONFIG_TYPE;

   constant INIT_TICKTABLE_TICKCONFIG_TYPE : TICKTABLE_TICKCONFIG_TYPE := (
      ClearTickTable  => 'Z',
      ClearMask       => (others=> 'Z'),
      TickClock       => (others=> 'Z'),
      IntClock_sel    => (others=> 'Z'),
      TickClockActivation => (others=> 'Z'),
      EnableHalftableInt => 'Z',
      IntClock_en     => 'Z',
      LatchCurrentStamp => 'Z',
      ResetTimestamp  => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_TICKCONFIG_TYPE) return std_logic_vector;
   function to_TICKTABLE_TICKCONFIG_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_TICKCONFIG_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CurrentStampLatched
   ------------------------------------------------------------------------------------------
   type TICKTABLE_CURRENTSTAMPLATCHED_TYPE is record
      CurrentStamp   : std_logic_vector(31 downto 0);
   end record TICKTABLE_CURRENTSTAMPLATCHED_TYPE;

   constant INIT_TICKTABLE_CURRENTSTAMPLATCHED_TYPE : TICKTABLE_CURRENTSTAMPLATCHED_TYPE := (
      CurrentStamp    => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_CURRENTSTAMPLATCHED_TYPE) return std_logic_vector;
   function to_TICKTABLE_CURRENTSTAMPLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CURRENTSTAMPLATCHED_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WriteTime
   ------------------------------------------------------------------------------------------
   type TICKTABLE_WRITETIME_TYPE is record
      WriteTime      : std_logic_vector(31 downto 0);
   end record TICKTABLE_WRITETIME_TYPE;

   constant INIT_TICKTABLE_WRITETIME_TYPE : TICKTABLE_WRITETIME_TYPE := (
      WriteTime       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_WRITETIME_TYPE) return std_logic_vector;
   function to_TICKTABLE_WRITETIME_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_WRITETIME_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: WriteCommand
   ------------------------------------------------------------------------------------------
   type TICKTABLE_WRITECOMMAND_TYPE is record
      WriteDone      : std_logic;
      WriteStatus    : std_logic;
      ExecuteFutureWrite: std_logic;
      ExecuteImmWrite: std_logic;
      BitCmd         : std_logic_vector(1 downto 0);
      BitNum         : std_logic_vector(1 downto 0);
   end record TICKTABLE_WRITECOMMAND_TYPE;

   constant INIT_TICKTABLE_WRITECOMMAND_TYPE : TICKTABLE_WRITECOMMAND_TYPE := (
      WriteDone       => 'Z',
      WriteStatus     => 'Z',
      ExecuteFutureWrite => 'Z',
      ExecuteImmWrite => 'Z',
      BitCmd          => (others=> 'Z'),
      BitNum          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_WRITECOMMAND_TYPE) return std_logic_vector;
   function to_TICKTABLE_WRITECOMMAND_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_WRITECOMMAND_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: LatchIntStat
   ------------------------------------------------------------------------------------------
   type TICKTABLE_LATCHINTSTAT_TYPE is record
      LatchIntStat   : std_logic_vector(1 downto 0);
      LatchIntStat_set: std_logic_vector(1 downto 0);
   end record TICKTABLE_LATCHINTSTAT_TYPE;

   constant INIT_TICKTABLE_LATCHINTSTAT_TYPE : TICKTABLE_LATCHINTSTAT_TYPE := (
      LatchIntStat    => (others=> 'Z'),
      LatchIntStat_set => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_LATCHINTSTAT_TYPE) return std_logic_vector;
   function to_TICKTABLE_LATCHINTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_LATCHINTSTAT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: InputStamp
   ------------------------------------------------------------------------------------------
   type TICKTABLE_INPUTSTAMP_TYPE is record
      InputStampSource: std_logic_vector(3 downto 0);
      LatchInputIntEnable: std_logic;
      LatchInputStamp_En: std_logic;
      InputStampActivation: std_logic_vector(1 downto 0);
   end record TICKTABLE_INPUTSTAMP_TYPE;

   constant INIT_TICKTABLE_INPUTSTAMP_TYPE : TICKTABLE_INPUTSTAMP_TYPE := (
      InputStampSource => (others=> 'Z'),
      LatchInputIntEnable => 'Z',
      LatchInputStamp_En => 'Z',
      InputStampActivation => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: TICKTABLE_INPUTSTAMP_TYPE
   ------------------------------------------------------------------------------------------
   type TICKTABLE_INPUTSTAMP_TYPE_ARRAY is array (1 downto 0) of TICKTABLE_INPUTSTAMP_TYPE;
   constant INIT_TICKTABLE_INPUTSTAMP_TYPE_ARRAY : TICKTABLE_INPUTSTAMP_TYPE_ARRAY := (others => INIT_TICKTABLE_INPUTSTAMP_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_INPUTSTAMP_TYPE) return std_logic_vector;
   function to_TICKTABLE_INPUTSTAMP_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_INPUTSTAMP_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: reserved_for_extra_latch
   ------------------------------------------------------------------------------------------
   type TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE is record
      reserved_for_extra_latch: std_logic;
   end record TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;

   constant INIT_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE : TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE := (
      reserved_for_extra_latch => 'Z'
   );

   ------------------------------------------------------------------------------------------
   -- Array type: TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE
   ------------------------------------------------------------------------------------------
   type TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE_ARRAY is array (9 downto 0) of TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;
   constant INIT_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE_ARRAY : TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE_ARRAY := (others => INIT_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE) return std_logic_vector;
   function to_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: InputStampLatched
   ------------------------------------------------------------------------------------------
   type TICKTABLE_INPUTSTAMPLATCHED_TYPE is record
      InputStamp     : std_logic_vector(31 downto 0);
   end record TICKTABLE_INPUTSTAMPLATCHED_TYPE;

   constant INIT_TICKTABLE_INPUTSTAMPLATCHED_TYPE : TICKTABLE_INPUTSTAMPLATCHED_TYPE := (
      InputStamp      => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: TICKTABLE_INPUTSTAMPLATCHED_TYPE
   ------------------------------------------------------------------------------------------
   type TICKTABLE_INPUTSTAMPLATCHED_TYPE_ARRAY is array (1 downto 0) of TICKTABLE_INPUTSTAMPLATCHED_TYPE;
   constant INIT_TICKTABLE_INPUTSTAMPLATCHED_TYPE_ARRAY : TICKTABLE_INPUTSTAMPLATCHED_TYPE_ARRAY := (others => INIT_TICKTABLE_INPUTSTAMPLATCHED_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : TICKTABLE_INPUTSTAMPLATCHED_TYPE) return std_logic_vector;
   function to_TICKTABLE_INPUTSTAMPLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_INPUTSTAMPLATCHED_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_INCOND
   ------------------------------------------------------------------------------------------
   type INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE is record
      INPUTCOND_ID   : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_INPUTS      : std_logic_vector(4 downto 0);
      Period_ns      : std_logic_vector(7 downto 0);
   end record INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;

   constant INIT_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE : INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE := (
      INPUTCOND_ID    => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_INPUTS       => (others=> 'Z'),
      Period_ns       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE) return std_logic_vector;
   function to_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: InputConditioning
   ------------------------------------------------------------------------------------------
   type INPUTCONDITIONING_INPUTCONDITIONING_TYPE is record
      DebounceHoldOff: std_logic_vector(23 downto 0);
      InputFiltering : std_logic;
      InputPol       : std_logic;
   end record INPUTCONDITIONING_INPUTCONDITIONING_TYPE;

   constant INIT_INPUTCONDITIONING_INPUTCONDITIONING_TYPE : INPUTCONDITIONING_INPUTCONDITIONING_TYPE := (
      DebounceHoldOff => (others=> 'Z'),
      InputFiltering  => 'Z',
      InputPol        => 'Z'
   );

   ------------------------------------------------------------------------------------------
   -- Array type: INPUTCONDITIONING_INPUTCONDITIONING_TYPE
   ------------------------------------------------------------------------------------------
   type INPUTCONDITIONING_INPUTCONDITIONING_TYPE_ARRAY is array (3 downto 0) of INPUTCONDITIONING_INPUTCONDITIONING_TYPE;
   constant INIT_INPUTCONDITIONING_INPUTCONDITIONING_TYPE_ARRAY : INPUTCONDITIONING_INPUTCONDITIONING_TYPE_ARRAY := (others => INIT_INPUTCONDITIONING_INPUTCONDITIONING_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : INPUTCONDITIONING_INPUTCONDITIONING_TYPE) return std_logic_vector;
   function to_INPUTCONDITIONING_INPUTCONDITIONING_TYPE(stdlv : std_logic_vector(31 downto 0)) return INPUTCONDITIONING_INPUTCONDITIONING_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_OUTCOND
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE is record
      OUTPUTCOND_ID  : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_OUTPUTS     : std_logic_vector(4 downto 0);
   end record OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;

   constant INIT_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE : OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE := (
      OUTPUTCOND_ID   => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_OUTPUTS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE) return std_logic_vector;
   function to_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: OutputCond
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_OUTPUTCOND_TYPE is record
      OutputVal      : std_logic;
      OutputPol      : std_logic;
      Outsel         : std_logic_vector(5 downto 0);
   end record OUTPUTCONDITIONING_OUTPUTCOND_TYPE;

   constant INIT_OUTPUTCONDITIONING_OUTPUTCOND_TYPE : OUTPUTCONDITIONING_OUTPUTCOND_TYPE := (
      OutputVal       => 'Z',
      OutputPol       => 'Z',
      Outsel          => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: OUTPUTCONDITIONING_OUTPUTCOND_TYPE
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_OUTPUTCOND_TYPE_ARRAY is array (3 downto 0) of OUTPUTCONDITIONING_OUTPUTCOND_TYPE;
   constant INIT_OUTPUTCONDITIONING_OUTPUTCOND_TYPE_ARRAY : OUTPUTCONDITIONING_OUTPUTCOND_TYPE_ARRAY := (others => INIT_OUTPUTCONDITIONING_OUTPUTCOND_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_OUTPUTCOND_TYPE) return std_logic_vector;
   function to_OUTPUTCONDITIONING_OUTPUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_OUTPUTCOND_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: Reserved
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_RESERVED_TYPE is record
      Reserved       : std_logic_vector(7 downto 0);
   end record OUTPUTCONDITIONING_RESERVED_TYPE;

   constant INIT_OUTPUTCONDITIONING_RESERVED_TYPE : OUTPUTCONDITIONING_RESERVED_TYPE := (
      Reserved        => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_RESERVED_TYPE) return std_logic_vector;
   function to_OUTPUTCONDITIONING_RESERVED_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_RESERVED_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: Output_Debounce
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE is record
      Output_HoldOFF_reg_EN: std_logic;
      Output_HoldOFF_reg_CNTR: std_logic_vector(9 downto 0);
   end record OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;

   constant INIT_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE : OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE := (
      Output_HoldOFF_reg_EN => 'Z',
      Output_HoldOFF_reg_CNTR => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE) return std_logic_vector;
   function to_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_INT_INP
   ------------------------------------------------------------------------------------------
   type INTERNALINPUT_CAPABILITIES_INT_INP_TYPE is record
      INT_INPUT_ID   : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_INPUTS      : std_logic_vector(4 downto 0);
   end record INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;

   constant INIT_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE : INTERNALINPUT_CAPABILITIES_INT_INP_TYPE := (
      INT_INPUT_ID    => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_INPUTS       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERNALINPUT_CAPABILITIES_INT_INP_TYPE) return std_logic_vector;
   function to_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_INTOUT
   ------------------------------------------------------------------------------------------
   type INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE is record
      INT_OUTPUT_ID  : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_OUTPUTS     : std_logic_vector(4 downto 0);
   end record INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;

   constant INIT_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE : INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE := (
      INT_OUTPUT_ID   => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_OUTPUTS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE) return std_logic_vector;
   function to_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: OutputCond
   ------------------------------------------------------------------------------------------
   type INTERNALOUTPUT_OUTPUTCOND_TYPE is record
      OutputVal      : std_logic;
      Outsel         : std_logic_vector(5 downto 0);
   end record INTERNALOUTPUT_OUTPUTCOND_TYPE;

   constant INIT_INTERNALOUTPUT_OUTPUTCOND_TYPE : INTERNALOUTPUT_OUTPUTCOND_TYPE := (
      OutputVal       => 'Z',
      Outsel          => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: INTERNALOUTPUT_OUTPUTCOND_TYPE
   ------------------------------------------------------------------------------------------
   type INTERNALOUTPUT_OUTPUTCOND_TYPE_ARRAY is array (0 downto 0) of INTERNALOUTPUT_OUTPUTCOND_TYPE;
   constant INIT_INTERNALOUTPUT_OUTPUTCOND_TYPE_ARRAY : INTERNALOUTPUT_OUTPUTCOND_TYPE_ARRAY := (others => INIT_INTERNALOUTPUT_OUTPUTCOND_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : INTERNALOUTPUT_OUTPUTCOND_TYPE) return std_logic_vector;
   function to_INTERNALOUTPUT_OUTPUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALOUTPUT_OUTPUTCOND_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_TIMER
   ------------------------------------------------------------------------------------------
   type TIMER_CAPABILITIES_TIMER_TYPE is record
      TIMER_ID       : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      INTNUM         : std_logic_vector(4 downto 0);
   end record TIMER_CAPABILITIES_TIMER_TYPE;

   constant INIT_TIMER_CAPABILITIES_TIMER_TYPE : TIMER_CAPABILITIES_TIMER_TYPE := (
      TIMER_ID        => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      INTNUM          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_CAPABILITIES_TIMER_TYPE) return std_logic_vector;
   function to_TIMER_CAPABILITIES_TIMER_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_CAPABILITIES_TIMER_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerClockPeriod
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERCLOCKPERIOD_TYPE is record
      Period_ns      : std_logic_vector(15 downto 0);
   end record TIMER_TIMERCLOCKPERIOD_TYPE;

   constant INIT_TIMER_TIMERCLOCKPERIOD_TYPE : TIMER_TIMERCLOCKPERIOD_TYPE := (
      Period_ns       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERCLOCKPERIOD_TYPE) return std_logic_vector;
   function to_TIMER_TIMERCLOCKPERIOD_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERCLOCKPERIOD_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerTriggerArm
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERTRIGGERARM_TYPE is record
      Soft_TimerArm  : std_logic;
      TimerTriggerOverlap: std_logic_vector(1 downto 0);
      TimerArmEnable : std_logic;
      TimerArmSource : std_logic_vector(4 downto 0);
      TimerArmActivation: std_logic_vector(2 downto 0);
      Soft_TimerTrigger: std_logic;
      TimerMesurement: std_logic;
      TimerTriggerLogicESel: std_logic_vector(1 downto 0);
      TimerTriggerLogicDSel: std_logic_vector(1 downto 0);
      TimerTriggerSource: std_logic_vector(5 downto 0);
      TimerTriggerActivation: std_logic_vector(2 downto 0);
   end record TIMER_TIMERTRIGGERARM_TYPE;

   constant INIT_TIMER_TIMERTRIGGERARM_TYPE : TIMER_TIMERTRIGGERARM_TYPE := (
      Soft_TimerArm   => 'Z',
      TimerTriggerOverlap => (others=> 'Z'),
      TimerArmEnable  => 'Z',
      TimerArmSource  => (others=> 'Z'),
      TimerArmActivation => (others=> 'Z'),
      Soft_TimerTrigger => 'Z',
      TimerMesurement => 'Z',
      TimerTriggerLogicESel => (others=> 'Z'),
      TimerTriggerLogicDSel => (others=> 'Z'),
      TimerTriggerSource => (others=> 'Z'),
      TimerTriggerActivation => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERTRIGGERARM_TYPE) return std_logic_vector;
   function to_TIMER_TIMERTRIGGERARM_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERTRIGGERARM_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerClockSource
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERCLOCKSOURCE_TYPE is record
      IntClock_sel   : std_logic_vector(1 downto 0);
      DelayClockActivation: std_logic_vector(1 downto 0);
      DelayClockSource: std_logic_vector(3 downto 0);
      TimerClockActivation: std_logic_vector(1 downto 0);
      TimerClockSource: std_logic_vector(3 downto 0);
   end record TIMER_TIMERCLOCKSOURCE_TYPE;

   constant INIT_TIMER_TIMERCLOCKSOURCE_TYPE : TIMER_TIMERCLOCKSOURCE_TYPE := (
      IntClock_sel    => (others=> 'Z'),
      DelayClockActivation => (others=> 'Z'),
      DelayClockSource => (others=> 'Z'),
      TimerClockActivation => (others=> 'Z'),
      TimerClockSource => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERCLOCKSOURCE_TYPE) return std_logic_vector;
   function to_TIMER_TIMERCLOCKSOURCE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERCLOCKSOURCE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerDelayValue
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERDELAYVALUE_TYPE is record
      TimerDelayValue: std_logic_vector(31 downto 0);
   end record TIMER_TIMERDELAYVALUE_TYPE;

   constant INIT_TIMER_TIMERDELAYVALUE_TYPE : TIMER_TIMERDELAYVALUE_TYPE := (
      TimerDelayValue => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERDELAYVALUE_TYPE) return std_logic_vector;
   function to_TIMER_TIMERDELAYVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERDELAYVALUE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerDuration
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERDURATION_TYPE is record
      TimerDuration  : std_logic_vector(31 downto 0);
   end record TIMER_TIMERDURATION_TYPE;

   constant INIT_TIMER_TIMERDURATION_TYPE : TIMER_TIMERDURATION_TYPE := (
      TimerDuration   => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERDURATION_TYPE) return std_logic_vector;
   function to_TIMER_TIMERDURATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERDURATION_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerLatchedValue
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERLATCHEDVALUE_TYPE is record
      TimerLatchedValue: std_logic_vector(31 downto 0);
   end record TIMER_TIMERLATCHEDVALUE_TYPE;

   constant INIT_TIMER_TIMERLATCHEDVALUE_TYPE : TIMER_TIMERLATCHEDVALUE_TYPE := (
      TimerLatchedValue => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERLATCHEDVALUE_TYPE) return std_logic_vector;
   function to_TIMER_TIMERLATCHEDVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERLATCHEDVALUE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: TimerStatus
   ------------------------------------------------------------------------------------------
   type TIMER_TIMERSTATUS_TYPE is record
      TimerStatus    : std_logic_vector(2 downto 0);
      TimerStatus_Latched: std_logic_vector(2 downto 0);
      TimerEndIntmaskn: std_logic;
      TimerStartIntmaskn: std_logic;
      TimerLatchAndReset: std_logic;
      TimerLatchValue: std_logic;
      TimerCntrReset : std_logic;
      TimerInversion : std_logic;
      TimerEnable    : std_logic;
   end record TIMER_TIMERSTATUS_TYPE;

   constant INIT_TIMER_TIMERSTATUS_TYPE : TIMER_TIMERSTATUS_TYPE := (
      TimerStatus     => (others=> 'Z'),
      TimerStatus_Latched => (others=> 'Z'),
      TimerEndIntmaskn => 'Z',
      TimerStartIntmaskn => 'Z',
      TimerLatchAndReset => 'Z',
      TimerLatchValue => 'Z',
      TimerCntrReset  => 'Z',
      TimerInversion  => 'Z',
      TimerEnable     => 'Z'
   );

   -- Casting functions:
   function to_std_logic_vector(reg : TIMER_TIMERSTATUS_TYPE) return std_logic_vector;
   function to_TIMER_TIMERSTATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERSTATUS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_MICRO
   ------------------------------------------------------------------------------------------
   type MICROBLAZE_CAPABILITIES_MICRO_TYPE is record
      MICRO_ID       : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      Intnum         : std_logic_vector(4 downto 0);
   end record MICROBLAZE_CAPABILITIES_MICRO_TYPE;

   constant INIT_MICROBLAZE_CAPABILITIES_MICRO_TYPE : MICROBLAZE_CAPABILITIES_MICRO_TYPE := (
      MICRO_ID        => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      Intnum          => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : MICROBLAZE_CAPABILITIES_MICRO_TYPE) return std_logic_vector;
   function to_MICROBLAZE_CAPABILITIES_MICRO_TYPE(stdlv : std_logic_vector(31 downto 0)) return MICROBLAZE_CAPABILITIES_MICRO_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: ProdCons
   ------------------------------------------------------------------------------------------
   type MICROBLAZE_PRODCONS_TYPE is record
      MemorySize     : std_logic_vector(4 downto 0);
      Offset         : std_logic_vector(19 downto 0);
   end record MICROBLAZE_PRODCONS_TYPE;

   constant INIT_MICROBLAZE_PRODCONS_TYPE : MICROBLAZE_PRODCONS_TYPE := (
      MemorySize      => (others=> 'Z'),
      Offset          => (others=> 'Z')
   );

   ------------------------------------------------------------------------------------------
   -- Array type: MICROBLAZE_PRODCONS_TYPE
   ------------------------------------------------------------------------------------------
   type MICROBLAZE_PRODCONS_TYPE_ARRAY is array (1 downto 0) of MICROBLAZE_PRODCONS_TYPE;
   constant INIT_MICROBLAZE_PRODCONS_TYPE_ARRAY : MICROBLAZE_PRODCONS_TYPE_ARRAY := (others => INIT_MICROBLAZE_PRODCONS_TYPE);
   -- Casting functions:
   function to_std_logic_vector(reg : MICROBLAZE_PRODCONS_TYPE) return std_logic_vector;
   function to_MICROBLAZE_PRODCONS_TYPE(stdlv : std_logic_vector(31 downto 0)) return MICROBLAZE_PRODCONS_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: CAPABILITIES_ANA_OUT
   ------------------------------------------------------------------------------------------
   type ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE is record
      ANA_OUT_ID     : std_logic_vector(7 downto 0);
      FEATURE_REV    : std_logic_vector(3 downto 0);
      NB_OUTPUTS     : std_logic_vector(3 downto 0);
   end record ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;

   constant INIT_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE : ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE := (
      ANA_OUT_ID      => (others=> 'Z'),
      FEATURE_REV     => (others=> 'Z'),
      NB_OUTPUTS      => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE) return std_logic_vector;
   function to_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: OutputValue
   ------------------------------------------------------------------------------------------
   type ANALOGOUTPUT_OUTPUTVALUE_TYPE is record
      OutputVal      : std_logic_vector(7 downto 0);
   end record ANALOGOUTPUT_OUTPUTVALUE_TYPE;

   constant INIT_ANALOGOUTPUT_OUTPUTVALUE_TYPE : ANALOGOUTPUT_OUTPUTVALUE_TYPE := (
      OutputVal       => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : ANALOGOUTPUT_OUTPUTVALUE_TYPE) return std_logic_vector;
   function to_ANALOGOUTPUT_OUTPUTVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ANALOGOUTPUT_OUTPUTVALUE_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Register Name: EOFM
   ------------------------------------------------------------------------------------------
   type EOFM_EOFM_TYPE is record
      EOFM           : std_logic_vector(7 downto 0);
   end record EOFM_EOFM_TYPE;

   constant INIT_EOFM_EOFM_TYPE : EOFM_EOFM_TYPE := (
      EOFM            => (others=> 'Z')
   );

   -- Casting functions:
   function to_std_logic_vector(reg : EOFM_EOFM_TYPE) return std_logic_vector;
   function to_EOFM_EOFM_TYPE(stdlv : std_logic_vector(31 downto 0)) return EOFM_EOFM_TYPE;
   
   ------------------------------------------------------------------------------------------
   -- Section Name: Device_specific
   ------------------------------------------------------------------------------------------
   type DEVICE_SPECIFIC_TYPE is record
      INTSTAT        : DEVICE_SPECIFIC_INTSTAT_TYPE;
      INTMASKn       : DEVICE_SPECIFIC_INTMASKN_TYPE;
      INTSTAT2       : DEVICE_SPECIFIC_INTSTAT2_TYPE;
      BUILDID        : DEVICE_SPECIFIC_BUILDID_TYPE;
      FPGA_ID        : DEVICE_SPECIFIC_FPGA_ID_TYPE;
      LED_OVERRIDE   : DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;
   end record DEVICE_SPECIFIC_TYPE;

   constant INIT_DEVICE_SPECIFIC_TYPE : DEVICE_SPECIFIC_TYPE := (
      INTSTAT         => INIT_DEVICE_SPECIFIC_INTSTAT_TYPE,
      INTMASKn        => INIT_DEVICE_SPECIFIC_INTMASKN_TYPE,
      INTSTAT2        => INIT_DEVICE_SPECIFIC_INTSTAT2_TYPE,
      BUILDID         => INIT_DEVICE_SPECIFIC_BUILDID_TYPE,
      FPGA_ID         => INIT_DEVICE_SPECIFIC_FPGA_ID_TYPE,
      LED_OVERRIDE    => INIT_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: INTERRUPT_QUEUE
   ------------------------------------------------------------------------------------------
   type INTERRUPT_QUEUE_TYPE is record
      CONTROL        : INTERRUPT_QUEUE_CONTROL_TYPE;
      CONS_IDX       : INTERRUPT_QUEUE_CONS_IDX_TYPE;
      ADDR_LOW       : INTERRUPT_QUEUE_ADDR_LOW_TYPE;
      ADDR_HIGH      : INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
      MAPPING        : INTERRUPT_QUEUE_MAPPING_TYPE;
   end record INTERRUPT_QUEUE_TYPE;

   constant INIT_INTERRUPT_QUEUE_TYPE : INTERRUPT_QUEUE_TYPE := (
      CONTROL         => INIT_INTERRUPT_QUEUE_CONTROL_TYPE,
      CONS_IDX        => INIT_INTERRUPT_QUEUE_CONS_IDX_TYPE,
      ADDR_LOW        => INIT_INTERRUPT_QUEUE_ADDR_LOW_TYPE,
      ADDR_HIGH       => INIT_INTERRUPT_QUEUE_ADDR_HIGH_TYPE,
      MAPPING         => INIT_INTERRUPT_QUEUE_MAPPING_TYPE
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
   -- Section Name: SPI
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
   -- Section Name: IO
   ------------------------------------------------------------------------------------------
   type IO_TYPE is record
      CAPABILITIES_IO: IO_CAPABILITIES_IO_TYPE;
      IO_PIN         : IO_IO_PIN_TYPE;
      IO_OUT         : IO_IO_OUT_TYPE;
      IO_DIR         : IO_IO_DIR_TYPE;
      IO_POL         : IO_IO_POL_TYPE;
      IO_INTSTAT     : IO_IO_INTSTAT_TYPE;
      IO_INTMASKn    : IO_IO_INTMASKN_TYPE;
      IO_ANYEDGE     : IO_IO_ANYEDGE_TYPE;
   end record IO_TYPE;

   constant INIT_IO_TYPE : IO_TYPE := (
      CAPABILITIES_IO => INIT_IO_CAPABILITIES_IO_TYPE,
      IO_PIN          => INIT_IO_IO_PIN_TYPE,
      IO_OUT          => INIT_IO_IO_OUT_TYPE,
      IO_DIR          => INIT_IO_IO_DIR_TYPE,
      IO_POL          => INIT_IO_IO_POL_TYPE,
      IO_INTSTAT      => INIT_IO_IO_INTSTAT_TYPE,
      IO_INTMASKn     => INIT_IO_IO_INTMASKN_TYPE,
      IO_ANYEDGE      => INIT_IO_IO_ANYEDGE_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Array type: IO_TYPE
   ------------------------------------------------------------------------------------------
   type IO_TYPE_ARRAY is array (1 downto 0) of IO_TYPE;
   constant INIT_IO_TYPE_ARRAY : IO_TYPE_ARRAY := (others => INIT_IO_TYPE);
   ------------------------------------------------------------------------------------------
   -- Section Name: Quadrature
   ------------------------------------------------------------------------------------------
   type QUADRATURE_TYPE is record
      CAPABILITIES_QUAD: QUADRATURE_CAPABILITIES_QUAD_TYPE;
      PositionReset  : QUADRATURE_POSITIONRESET_TYPE;
      DecoderInput   : QUADRATURE_DECODERINPUT_TYPE;
      DecoderCfg     : QUADRATURE_DECODERCFG_TYPE;
      DecoderPosTrigger: QUADRATURE_DECODERPOSTRIGGER_TYPE;
      DecoderCntrLatch_Cfg: QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;
      DecoderCntrLatched_SW: QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;
      DecoderCntrLatched: QUADRATURE_DECODERCNTRLATCHED_TYPE;
   end record QUADRATURE_TYPE;

   constant INIT_QUADRATURE_TYPE : QUADRATURE_TYPE := (
      CAPABILITIES_QUAD => INIT_QUADRATURE_CAPABILITIES_QUAD_TYPE,
      PositionReset   => INIT_QUADRATURE_POSITIONRESET_TYPE,
      DecoderInput    => INIT_QUADRATURE_DECODERINPUT_TYPE,
      DecoderCfg      => INIT_QUADRATURE_DECODERCFG_TYPE,
      DecoderPosTrigger => INIT_QUADRATURE_DECODERPOSTRIGGER_TYPE,
      DecoderCntrLatch_Cfg => INIT_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE,
      DecoderCntrLatched_SW => INIT_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE,
      DecoderCntrLatched => INIT_QUADRATURE_DECODERCNTRLATCHED_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Array type: QUADRATURE_TYPE
   ------------------------------------------------------------------------------------------
   type QUADRATURE_TYPE_ARRAY is array (0 downto 0) of QUADRATURE_TYPE;
   constant INIT_QUADRATURE_TYPE_ARRAY : QUADRATURE_TYPE_ARRAY := (others => INIT_QUADRATURE_TYPE);
   ------------------------------------------------------------------------------------------
   -- Section Name: TickTable
   ------------------------------------------------------------------------------------------
   type TICKTABLE_TYPE is record
      CAPABILITIES_TICKTBL: TICKTABLE_CAPABILITIES_TICKTBL_TYPE;
      CAPABILITIES_EXT1: TICKTABLE_CAPABILITIES_EXT1_TYPE;
      TickTableClockPeriod: TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;
      TickConfig     : TICKTABLE_TICKCONFIG_TYPE;
      CurrentStampLatched: TICKTABLE_CURRENTSTAMPLATCHED_TYPE;
      WriteTime      : TICKTABLE_WRITETIME_TYPE;
      WriteCommand   : TICKTABLE_WRITECOMMAND_TYPE;
      LatchIntStat   : TICKTABLE_LATCHINTSTAT_TYPE;
      InputStamp     : TICKTABLE_INPUTSTAMP_TYPE_ARRAY;
      reserved_for_extra_latch: TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE_ARRAY;
      InputStampLatched: TICKTABLE_INPUTSTAMPLATCHED_TYPE_ARRAY;
   end record TICKTABLE_TYPE;

   constant INIT_TICKTABLE_TYPE : TICKTABLE_TYPE := (
      CAPABILITIES_TICKTBL => INIT_TICKTABLE_CAPABILITIES_TICKTBL_TYPE,
      CAPABILITIES_EXT1 => INIT_TICKTABLE_CAPABILITIES_EXT1_TYPE,
      TickTableClockPeriod => INIT_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE,
      TickConfig      => INIT_TICKTABLE_TICKCONFIG_TYPE,
      CurrentStampLatched => INIT_TICKTABLE_CURRENTSTAMPLATCHED_TYPE,
      WriteTime       => INIT_TICKTABLE_WRITETIME_TYPE,
      WriteCommand    => INIT_TICKTABLE_WRITECOMMAND_TYPE,
      LatchIntStat    => INIT_TICKTABLE_LATCHINTSTAT_TYPE,
      InputStamp      => INIT_TICKTABLE_INPUTSTAMP_TYPE_ARRAY,
      reserved_for_extra_latch => INIT_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE_ARRAY,
      InputStampLatched => INIT_TICKTABLE_INPUTSTAMPLATCHED_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Array type: TICKTABLE_TYPE
   ------------------------------------------------------------------------------------------
   type TICKTABLE_TYPE_ARRAY is array (0 downto 0) of TICKTABLE_TYPE;
   constant INIT_TICKTABLE_TYPE_ARRAY : TICKTABLE_TYPE_ARRAY := (others => INIT_TICKTABLE_TYPE);
   ------------------------------------------------------------------------------------------
   -- Section Name: InputConditioning
   ------------------------------------------------------------------------------------------
   type INPUTCONDITIONING_TYPE is record
      CAPABILITIES_INCOND: INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;
      InputConditioning: INPUTCONDITIONING_INPUTCONDITIONING_TYPE_ARRAY;
   end record INPUTCONDITIONING_TYPE;

   constant INIT_INPUTCONDITIONING_TYPE : INPUTCONDITIONING_TYPE := (
      CAPABILITIES_INCOND => INIT_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE,
      InputConditioning => INIT_INPUTCONDITIONING_INPUTCONDITIONING_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: OutputConditioning
   ------------------------------------------------------------------------------------------
   type OUTPUTCONDITIONING_TYPE is record
      CAPABILITIES_OUTCOND: OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;
      OutputCond     : OUTPUTCONDITIONING_OUTPUTCOND_TYPE_ARRAY;
      Reserved       : OUTPUTCONDITIONING_RESERVED_TYPE;
      Output_Debounce: OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;
   end record OUTPUTCONDITIONING_TYPE;

   constant INIT_OUTPUTCONDITIONING_TYPE : OUTPUTCONDITIONING_TYPE := (
      CAPABILITIES_OUTCOND => INIT_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE,
      OutputCond      => INIT_OUTPUTCONDITIONING_OUTPUTCOND_TYPE_ARRAY,
      Reserved        => INIT_OUTPUTCONDITIONING_RESERVED_TYPE,
      Output_Debounce => INIT_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: InternalInput
   ------------------------------------------------------------------------------------------
   type INTERNALINPUT_TYPE is record
      CAPABILITIES_INT_INP: INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;
   end record INTERNALINPUT_TYPE;

   constant INIT_INTERNALINPUT_TYPE : INTERNALINPUT_TYPE := (
      CAPABILITIES_INT_INP => INIT_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: InternalOutput
   ------------------------------------------------------------------------------------------
   type INTERNALOUTPUT_TYPE is record
      CAPABILITIES_INTOUT: INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;
      OutputCond     : INTERNALOUTPUT_OUTPUTCOND_TYPE_ARRAY;
   end record INTERNALOUTPUT_TYPE;

   constant INIT_INTERNALOUTPUT_TYPE : INTERNALOUTPUT_TYPE := (
      CAPABILITIES_INTOUT => INIT_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE,
      OutputCond      => INIT_INTERNALOUTPUT_OUTPUTCOND_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: Timer
   ------------------------------------------------------------------------------------------
   type TIMER_TYPE is record
      CAPABILITIES_TIMER: TIMER_CAPABILITIES_TIMER_TYPE;
      TimerClockPeriod: TIMER_TIMERCLOCKPERIOD_TYPE;
      TimerTriggerArm: TIMER_TIMERTRIGGERARM_TYPE;
      TimerClockSource: TIMER_TIMERCLOCKSOURCE_TYPE;
      TimerDelayValue: TIMER_TIMERDELAYVALUE_TYPE;
      TimerDuration  : TIMER_TIMERDURATION_TYPE;
      TimerLatchedValue: TIMER_TIMERLATCHEDVALUE_TYPE;
      TimerStatus    : TIMER_TIMERSTATUS_TYPE;
   end record TIMER_TYPE;

   constant INIT_TIMER_TYPE : TIMER_TYPE := (
      CAPABILITIES_TIMER => INIT_TIMER_CAPABILITIES_TIMER_TYPE,
      TimerClockPeriod => INIT_TIMER_TIMERCLOCKPERIOD_TYPE,
      TimerTriggerArm => INIT_TIMER_TIMERTRIGGERARM_TYPE,
      TimerClockSource => INIT_TIMER_TIMERCLOCKSOURCE_TYPE,
      TimerDelayValue => INIT_TIMER_TIMERDELAYVALUE_TYPE,
      TimerDuration   => INIT_TIMER_TIMERDURATION_TYPE,
      TimerLatchedValue => INIT_TIMER_TIMERLATCHEDVALUE_TYPE,
      TimerStatus     => INIT_TIMER_TIMERSTATUS_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Array type: TIMER_TYPE
   ------------------------------------------------------------------------------------------
   type TIMER_TYPE_ARRAY is array (7 downto 0) of TIMER_TYPE;
   constant INIT_TIMER_TYPE_ARRAY : TIMER_TYPE_ARRAY := (others => INIT_TIMER_TYPE);
   ------------------------------------------------------------------------------------------
   -- Section Name: Microblaze
   ------------------------------------------------------------------------------------------
   type MICROBLAZE_TYPE is record
      CAPABILITIES_MICRO: MICROBLAZE_CAPABILITIES_MICRO_TYPE;
      ProdCons       : MICROBLAZE_PRODCONS_TYPE_ARRAY;
   end record MICROBLAZE_TYPE;

   constant INIT_MICROBLAZE_TYPE : MICROBLAZE_TYPE := (
      CAPABILITIES_MICRO => INIT_MICROBLAZE_CAPABILITIES_MICRO_TYPE,
      ProdCons        => INIT_MICROBLAZE_PRODCONS_TYPE_ARRAY
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: AnalogOutput
   ------------------------------------------------------------------------------------------
   type ANALOGOUTPUT_TYPE is record
      CAPABILITIES_ANA_OUT: ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;
      OutputValue    : ANALOGOUTPUT_OUTPUTVALUE_TYPE;
   end record ANALOGOUTPUT_TYPE;

   constant INIT_ANALOGOUTPUT_TYPE : ANALOGOUTPUT_TYPE := (
      CAPABILITIES_ANA_OUT => INIT_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE,
      OutputValue     => INIT_ANALOGOUTPUT_OUTPUTVALUE_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Section Name: EOFM
   ------------------------------------------------------------------------------------------
   type EOFM_TYPE is record
      EOFM           : EOFM_EOFM_TYPE;
   end record EOFM_TYPE;

   constant INIT_EOFM_TYPE : EOFM_TYPE := (
      EOFM            => INIT_EOFM_EOFM_TYPE
   );

   ------------------------------------------------------------------------------------------
   -- Register file name: regfile_ares
   ------------------------------------------------------------------------------------------
   type REGFILE_ARES_TYPE is record
      Device_specific: DEVICE_SPECIFIC_TYPE;
      INTERRUPT_QUEUE: INTERRUPT_QUEUE_TYPE;
      tlp            : TLP_TYPE;
      SPI            : SPI_TYPE;
      arbiter        : ARBITER_TYPE;
      axi_window     : AXI_WINDOW_TYPE_array;
      IO             : IO_TYPE_array;
      Quadrature     : QUADRATURE_TYPE_array;
      TickTable      : TICKTABLE_TYPE_array;
      InputConditioning: INPUTCONDITIONING_TYPE;
      OutputConditioning: OUTPUTCONDITIONING_TYPE;
      InternalInput  : INTERNALINPUT_TYPE;
      InternalOutput : INTERNALOUTPUT_TYPE;
      Timer          : TIMER_TYPE_array;
      Microblaze     : MICROBLAZE_TYPE;
      AnalogOutput   : ANALOGOUTPUT_TYPE;
      EOFM           : EOFM_TYPE;
   end record REGFILE_ARES_TYPE;

   constant INIT_REGFILE_ARES_TYPE : REGFILE_ARES_TYPE := (
      Device_specific => INIT_DEVICE_SPECIFIC_TYPE,
      INTERRUPT_QUEUE => INIT_INTERRUPT_QUEUE_TYPE,
      tlp             => INIT_TLP_TYPE,
      SPI             => INIT_SPI_TYPE,
      arbiter         => INIT_ARBITER_TYPE,
      axi_window      => INIT_AXI_WINDOW_TYPE_array,
      IO              => INIT_IO_TYPE_array,
      Quadrature      => INIT_QUADRATURE_TYPE_array,
      TickTable       => INIT_TICKTABLE_TYPE_array,
      InputConditioning => INIT_INPUTCONDITIONING_TYPE,
      OutputConditioning => INIT_OUTPUTCONDITIONING_TYPE,
      InternalInput   => INIT_INTERNALINPUT_TYPE,
      InternalOutput  => INIT_INTERNALOUTPUT_TYPE,
      Timer           => INIT_TIMER_TYPE_array,
      Microblaze      => INIT_MICROBLAZE_TYPE,
      AnalogOutput    => INIT_ANALOGOUTPUT_TYPE,
      EOFM            => INIT_EOFM_TYPE
   );

   
end regfile_ares_pack;

package body regfile_ares_pack is
   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_INTSTAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTSTAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7) := reg.IRQ_TICK_LATCH;
      output(6) := reg.IRQ_MICROBLAZE;
      output(4) := reg.IRQ_TICK_WA;
      output(3) := reg.IRQ_TIMER;
      output(1) := reg.IRQ_TICK;
      output(0) := reg.IRQ_IO;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_INTSTAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_INTSTAT_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_INTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTSTAT_TYPE is
   variable output : DEVICE_SPECIFIC_INTSTAT_TYPE;
   begin
      output.IRQ_TICK_LATCH := stdlv(7);
      output.IRQ_MICROBLAZE := stdlv(6);
      output.IRQ_TICK_WA := stdlv(4);
      output.IRQ_TIMER := stdlv(3);
      output.IRQ_TICK := stdlv(1);
      output.IRQ_IO := stdlv(0);
      return output;
   end to_DEVICE_SPECIFIC_INTSTAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_INTMASKN_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTMASKN_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7) := reg.IRQ_TICK_LATCH;
      output(6) := reg.IRQ_MICROBLAZE;
      output(4) := reg.IRQ_TICK_WA;
      output(3) := reg.IRQ_TIMER;
      output(1) := reg.IRQ_TICK;
      output(0) := reg.IRQ_IO;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_INTMASKN_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_INTMASKN_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_INTMASKN_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTMASKN_TYPE is
   variable output : DEVICE_SPECIFIC_INTMASKN_TYPE;
   begin
      output.IRQ_TICK_LATCH := stdlv(7);
      output.IRQ_MICROBLAZE := stdlv(6);
      output.IRQ_TICK_WA := stdlv(4);
      output.IRQ_TIMER := stdlv(3);
      output.IRQ_TICK := stdlv(1);
      output.IRQ_IO := stdlv(0);
      return output;
   end to_DEVICE_SPECIFIC_INTMASKN_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_INTSTAT2_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_INTSTAT2_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(23 downto 16) := reg.IRQ_TIMER_END;
      output(7 downto 0) := reg.IRQ_TIMER_START;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_INTSTAT2_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_INTSTAT2_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_INTSTAT2_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_INTSTAT2_TYPE is
   variable output : DEVICE_SPECIFIC_INTSTAT2_TYPE;
   begin
      output.IRQ_TIMER_END := stdlv(23 downto 16);
      output.IRQ_TIMER_START := stdlv(7 downto 0);
      return output;
   end to_DEVICE_SPECIFIC_INTSTAT2_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_BUILDID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_BUILDID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.VALUE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_BUILDID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_BUILDID_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_BUILDID_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_BUILDID_TYPE is
   variable output : DEVICE_SPECIFIC_BUILDID_TYPE;
   begin
      output.VALUE := stdlv(31 downto 0);
      return output;
   end to_DEVICE_SPECIFIC_BUILDID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_FPGA_ID_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_FPGA_ID_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 28) := reg.FPGA_STRAPS;
      output(14) := reg.USER_RED_LED;
      output(13) := reg.USER_GREEN_LED;
      output(12) := reg.PROFINET_LED;
      output(10) := reg.PB_DEBUG_COM;
      output(4 downto 0) := reg.FPGA_ID;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_FPGA_ID_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_FPGA_ID_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_FPGA_ID_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_FPGA_ID_TYPE is
   variable output : DEVICE_SPECIFIC_FPGA_ID_TYPE;
   begin
      output.FPGA_STRAPS := stdlv(31 downto 28);
      output.USER_RED_LED := stdlv(14);
      output.USER_GREEN_LED := stdlv(13);
      output.PROFINET_LED := stdlv(12);
      output.PB_DEBUG_COM := stdlv(10);
      output.FPGA_ID := stdlv(4 downto 0);
      return output;
   end to_DEVICE_SPECIFIC_FPGA_ID_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from DEVICE_SPECIFIC_LED_OVERRIDE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : DEVICE_SPECIFIC_LED_OVERRIDE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(25) := reg.RED_ORANGE_FLASH;
      output(24) := reg.ORANGE_OFF_FLASH;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to DEVICE_SPECIFIC_LED_OVERRIDE_TYPE
   --------------------------------------------------------------------------------
   function to_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE(stdlv : std_logic_vector(31 downto 0)) return DEVICE_SPECIFIC_LED_OVERRIDE_TYPE is
   variable output : DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;
   begin
      output.RED_ORANGE_FLASH := stdlv(25);
      output.ORANGE_OFF_FLASH := stdlv(24);
      return output;
   end to_DEVICE_SPECIFIC_LED_OVERRIDE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_CONTROL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_CONTROL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.NB_DW;
      output(0) := reg.ENABLE;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_CONTROL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_CONTROL_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_CONTROL_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONTROL_TYPE is
   variable output : INTERRUPT_QUEUE_CONTROL_TYPE;
   begin
      output.NB_DW := stdlv(31 downto 24);
      output.ENABLE := stdlv(0);
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
      output(9 downto 0) := reg.CONS_IDX;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_CONS_IDX_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_CONS_IDX_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_CONS_IDX_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_CONS_IDX_TYPE is
   variable output : INTERRUPT_QUEUE_CONS_IDX_TYPE;
   begin
      output.CONS_IDX := stdlv(9 downto 0);
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
      output(31 downto 0) := reg.ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_ADDR_LOW_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_ADDR_LOW_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_ADDR_LOW_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_LOW_TYPE is
   variable output : INTERRUPT_QUEUE_ADDR_LOW_TYPE;
   begin
      output.ADDR := stdlv(31 downto 0);
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
      output(31 downto 0) := reg.ADDR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_ADDR_HIGH_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_ADDR_HIGH_TYPE is
   variable output : INTERRUPT_QUEUE_ADDR_HIGH_TYPE;
   begin
      output.ADDR := stdlv(31 downto 0);
      return output;
   end to_INTERRUPT_QUEUE_ADDR_HIGH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERRUPT_QUEUE_MAPPING_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERRUPT_QUEUE_MAPPING_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.IRQ_TIMER_END;
      output(23 downto 16) := reg.IRQ_TIMER_START;
      output(11 downto 8) := reg.IO_INTSTAT;
      output(5) := reg.IRQ_TICK_LATCH;
      output(4) := reg.IRQ_MICROBLAZE;
      output(3) := reg.IRQ_TIMER;
      output(2) := reg.IRQ_TICK_WA;
      output(1) := reg.IRQ_TICK;
      output(0) := reg.IRQ_IO;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERRUPT_QUEUE_MAPPING_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERRUPT_QUEUE_MAPPING_TYPE
   --------------------------------------------------------------------------------
   function to_INTERRUPT_QUEUE_MAPPING_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERRUPT_QUEUE_MAPPING_TYPE is
   variable output : INTERRUPT_QUEUE_MAPPING_TYPE;
   begin
      output.IRQ_TIMER_END := stdlv(31 downto 24);
      output.IRQ_TIMER_START := stdlv(23 downto 16);
      output.IO_INTSTAT := stdlv(11 downto 8);
      output.IRQ_TICK_LATCH := stdlv(5);
      output.IRQ_MICROBLAZE := stdlv(4);
      output.IRQ_TIMER := stdlv(3);
      output.IRQ_TICK_WA := stdlv(2);
      output.IRQ_TICK := stdlv(1);
      output.IRQ_IO := stdlv(0);
      return output;
   end to_INTERRUPT_QUEUE_MAPPING_TYPE;

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
   -- Description: Cast from IO_CAPABILITIES_IO_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_CAPABILITIES_IO_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.IO_ID;
      output(23 downto 19) := reg.N_port;
      output(18) := reg.Input;
      output(17) := reg.Output;
      output(16 downto 12) := reg.Intnum;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_CAPABILITIES_IO_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_CAPABILITIES_IO_TYPE
   --------------------------------------------------------------------------------
   function to_IO_CAPABILITIES_IO_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_CAPABILITIES_IO_TYPE is
   variable output : IO_CAPABILITIES_IO_TYPE;
   begin
      output.IO_ID := stdlv(31 downto 24);
      output.N_port := stdlv(23 downto 19);
      output.Input := stdlv(18);
      output.Output := stdlv(17);
      output.Intnum := stdlv(16 downto 12);
      return output;
   end to_IO_CAPABILITIES_IO_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_PIN_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_PIN_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.Pin_value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_PIN_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_PIN_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_PIN_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_PIN_TYPE is
   variable output : IO_IO_PIN_TYPE;
   begin
      output.Pin_value := stdlv(3 downto 0);
      return output;
   end to_IO_IO_PIN_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_OUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_OUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.Out_value;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_OUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_OUT_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_OUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_OUT_TYPE is
   variable output : IO_IO_OUT_TYPE;
   begin
      output.Out_value := stdlv(3 downto 0);
      return output;
   end to_IO_IO_OUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_DIR_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_DIR_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.Dir;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_DIR_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_DIR_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_DIR_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_DIR_TYPE is
   variable output : IO_IO_DIR_TYPE;
   begin
      output.Dir := stdlv(3 downto 0);
      return output;
   end to_IO_IO_DIR_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_POL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_POL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.In_pol;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_POL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_POL_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_POL_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_POL_TYPE is
   variable output : IO_IO_POL_TYPE;
   begin
      output.In_pol := stdlv(3 downto 0);
      return output;
   end to_IO_IO_POL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_INTSTAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_INTSTAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.Intstat;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_INTSTAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_INTSTAT_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_INTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_INTSTAT_TYPE is
   variable output : IO_IO_INTSTAT_TYPE;
   begin
      output.Intstat := stdlv(3 downto 0);
      return output;
   end to_IO_IO_INTSTAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_INTMASKN_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_INTMASKN_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.Intmaskn;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_INTMASKN_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_INTMASKN_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_INTMASKN_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_INTMASKN_TYPE is
   variable output : IO_IO_INTMASKN_TYPE;
   begin
      output.Intmaskn := stdlv(3 downto 0);
      return output;
   end to_IO_IO_INTMASKN_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from IO_IO_ANYEDGE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : IO_IO_ANYEDGE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(3 downto 0) := reg.In_AnyEdge;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_IO_IO_ANYEDGE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to IO_IO_ANYEDGE_TYPE
   --------------------------------------------------------------------------------
   function to_IO_IO_ANYEDGE_TYPE(stdlv : std_logic_vector(31 downto 0)) return IO_IO_ANYEDGE_TYPE is
   variable output : IO_IO_ANYEDGE_TYPE;
   begin
      output.In_AnyEdge := stdlv(3 downto 0);
      return output;
   end to_IO_IO_ANYEDGE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_CAPABILITIES_QUAD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_CAPABILITIES_QUAD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.QUADRATURE_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_CAPABILITIES_QUAD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_CAPABILITIES_QUAD_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_CAPABILITIES_QUAD_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_CAPABILITIES_QUAD_TYPE is
   variable output : QUADRATURE_CAPABILITIES_QUAD_TYPE;
   begin
      output.QUADRATURE_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      return output;
   end to_QUADRATURE_CAPABILITIES_QUAD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_POSITIONRESET_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_POSITIONRESET_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(5 downto 2) := reg.PositionResetSource;
      output(1) := reg.PositionResetActivation;
      output(0) := reg.soft_PositionReset;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_POSITIONRESET_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_POSITIONRESET_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_POSITIONRESET_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_POSITIONRESET_TYPE is
   variable output : QUADRATURE_POSITIONRESET_TYPE;
   begin
      output.PositionResetSource := stdlv(5 downto 2);
      output.PositionResetActivation := stdlv(1);
      output.soft_PositionReset := stdlv(0);
      return output;
   end to_QUADRATURE_POSITIONRESET_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERINPUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERINPUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 29) := reg.BSelector;
      output(15 downto 13) := reg.ASelector;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERINPUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERINPUT_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERINPUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERINPUT_TYPE is
   variable output : QUADRATURE_DECODERINPUT_TYPE;
   begin
      output.BSelector := stdlv(31 downto 29);
      output.ASelector := stdlv(15 downto 13);
      return output;
   end to_QUADRATURE_DECODERINPUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERCFG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERCFG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(4 downto 2) := reg.DecOutSource0;
      output(0) := reg.QuadEnable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERCFG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERCFG_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERCFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCFG_TYPE is
   variable output : QUADRATURE_DECODERCFG_TYPE;
   begin
      output.DecOutSource0 := stdlv(4 downto 2);
      output.QuadEnable := stdlv(0);
      return output;
   end to_QUADRATURE_DECODERCFG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERPOSTRIGGER_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERPOSTRIGGER_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.PositionTrigger;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERPOSTRIGGER_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERPOSTRIGGER_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERPOSTRIGGER_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERPOSTRIGGER_TYPE is
   variable output : QUADRATURE_DECODERPOSTRIGGER_TYPE;
   begin
      output.PositionTrigger := stdlv(31 downto 0);
      return output;
   end to_QUADRATURE_DECODERPOSTRIGGER_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERCNTRLATCH_CFG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCH_CFG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24) := reg.DecoderCntrLatch_SW;
      output(20 downto 16) := reg.DecoderCntrLatch_Src;
      output(8) := reg.DecoderCntrLatch_En;
      output(5 downto 4) := reg.DecoderCntrLatch_Act;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERCNTRLATCH_CFG_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCH_CFG_TYPE is
   variable output : QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;
   begin
      output.DecoderCntrLatch_SW := stdlv(24);
      output.DecoderCntrLatch_Src := stdlv(20 downto 16);
      output.DecoderCntrLatch_En := stdlv(8);
      output.DecoderCntrLatch_Act := stdlv(5 downto 4);
      return output;
   end to_QUADRATURE_DECODERCNTRLATCH_CFG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERCNTRLATCHED_SW_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCHED_SW_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.DecoderCntr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERCNTRLATCHED_SW_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCHED_SW_TYPE is
   variable output : QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;
   begin
      output.DecoderCntr := stdlv(31 downto 0);
      return output;
   end to_QUADRATURE_DECODERCNTRLATCHED_SW_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from QUADRATURE_DECODERCNTRLATCHED_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : QUADRATURE_DECODERCNTRLATCHED_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.DecoderCntr;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_QUADRATURE_DECODERCNTRLATCHED_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to QUADRATURE_DECODERCNTRLATCHED_TYPE
   --------------------------------------------------------------------------------
   function to_QUADRATURE_DECODERCNTRLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return QUADRATURE_DECODERCNTRLATCHED_TYPE is
   variable output : QUADRATURE_DECODERCNTRLATCHED_TYPE;
   begin
      output.DecoderCntr := stdlv(31 downto 0);
      return output;
   end to_QUADRATURE_DECODERCNTRLATCHED_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_CAPABILITIES_TICKTBL_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_CAPABILITIES_TICKTBL_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.TICKTABLE_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(16 downto 12) := reg.NB_ELEMENTS;
      output(11 downto 7) := reg.INTNUM;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_CAPABILITIES_TICKTBL_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_CAPABILITIES_TICKTBL_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_CAPABILITIES_TICKTBL_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CAPABILITIES_TICKTBL_TYPE is
   variable output : TICKTABLE_CAPABILITIES_TICKTBL_TYPE;
   begin
      output.TICKTABLE_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_ELEMENTS := stdlv(16 downto 12);
      output.INTNUM := stdlv(11 downto 7);
      return output;
   end to_TICKTABLE_CAPABILITIES_TICKTBL_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_CAPABILITIES_EXT1_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_CAPABILITIES_EXT1_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.TABLE_WIDTH;
      output(11 downto 8) := reg.NB_LATCH;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_CAPABILITIES_EXT1_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_CAPABILITIES_EXT1_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_CAPABILITIES_EXT1_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CAPABILITIES_EXT1_TYPE is
   variable output : TICKTABLE_CAPABILITIES_EXT1_TYPE;
   begin
      output.TABLE_WIDTH := stdlv(7 downto 0);
      output.NB_LATCH := stdlv(11 downto 8);
      return output;
   end to_TICKTABLE_CAPABILITIES_EXT1_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_TICKTABLECLOCKPERIOD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_TICKTABLECLOCKPERIOD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.Period_ns;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_TICKTABLECLOCKPERIOD_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_TICKTABLECLOCKPERIOD_TYPE is
   variable output : TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;
   begin
      output.Period_ns := stdlv(7 downto 0);
      return output;
   end to_TICKTABLE_TICKTABLECLOCKPERIOD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_TICKCONFIG_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_TICKCONFIG_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(28) := reg.ClearTickTable;
      output(23 downto 16) := reg.ClearMask;
      output(11 downto 8) := reg.TickClock;
      output(7 downto 6) := reg.IntClock_sel;
      output(5 downto 4) := reg.TickClockActivation;
      output(3) := reg.EnableHalftableInt;
      output(2) := reg.IntClock_en;
      output(1) := reg.LatchCurrentStamp;
      output(0) := reg.ResetTimestamp;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_TICKCONFIG_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_TICKCONFIG_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_TICKCONFIG_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_TICKCONFIG_TYPE is
   variable output : TICKTABLE_TICKCONFIG_TYPE;
   begin
      output.ClearTickTable := stdlv(28);
      output.ClearMask := stdlv(23 downto 16);
      output.TickClock := stdlv(11 downto 8);
      output.IntClock_sel := stdlv(7 downto 6);
      output.TickClockActivation := stdlv(5 downto 4);
      output.EnableHalftableInt := stdlv(3);
      output.IntClock_en := stdlv(2);
      output.LatchCurrentStamp := stdlv(1);
      output.ResetTimestamp := stdlv(0);
      return output;
   end to_TICKTABLE_TICKCONFIG_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_CURRENTSTAMPLATCHED_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_CURRENTSTAMPLATCHED_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.CurrentStamp;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_CURRENTSTAMPLATCHED_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_CURRENTSTAMPLATCHED_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_CURRENTSTAMPLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_CURRENTSTAMPLATCHED_TYPE is
   variable output : TICKTABLE_CURRENTSTAMPLATCHED_TYPE;
   begin
      output.CurrentStamp := stdlv(31 downto 0);
      return output;
   end to_TICKTABLE_CURRENTSTAMPLATCHED_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_WRITETIME_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_WRITETIME_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.WriteTime;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_WRITETIME_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_WRITETIME_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_WRITETIME_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_WRITETIME_TYPE is
   variable output : TICKTABLE_WRITETIME_TYPE;
   begin
      output.WriteTime := stdlv(31 downto 0);
      return output;
   end to_TICKTABLE_WRITETIME_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_WRITECOMMAND_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_WRITECOMMAND_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(13) := reg.WriteDone;
      output(12) := reg.WriteStatus;
      output(9) := reg.ExecuteFutureWrite;
      output(8) := reg.ExecuteImmWrite;
      output(6 downto 5) := reg.BitCmd;
      output(1 downto 0) := reg.BitNum;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_WRITECOMMAND_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_WRITECOMMAND_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_WRITECOMMAND_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_WRITECOMMAND_TYPE is
   variable output : TICKTABLE_WRITECOMMAND_TYPE;
   begin
      output.WriteDone := stdlv(13);
      output.WriteStatus := stdlv(12);
      output.ExecuteFutureWrite := stdlv(9);
      output.ExecuteImmWrite := stdlv(8);
      output.BitCmd := stdlv(6 downto 5);
      output.BitNum := stdlv(1 downto 0);
      return output;
   end to_TICKTABLE_WRITECOMMAND_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_LATCHINTSTAT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_LATCHINTSTAT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(1 downto 0) := reg.LatchIntStat;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_LATCHINTSTAT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_LATCHINTSTAT_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_LATCHINTSTAT_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_LATCHINTSTAT_TYPE is
   variable output : TICKTABLE_LATCHINTSTAT_TYPE;
   begin
      output.LatchIntStat := stdlv(1 downto 0);
      return output;
   end to_TICKTABLE_LATCHINTSTAT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_INPUTSTAMP_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_INPUTSTAMP_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(19 downto 16) := reg.InputStampSource;
      output(9) := reg.LatchInputIntEnable;
      output(8) := reg.LatchInputStamp_En;
      output(5 downto 4) := reg.InputStampActivation;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_INPUTSTAMP_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_INPUTSTAMP_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_INPUTSTAMP_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_INPUTSTAMP_TYPE is
   variable output : TICKTABLE_INPUTSTAMP_TYPE;
   begin
      output.InputStampSource := stdlv(19 downto 16);
      output.LatchInputIntEnable := stdlv(9);
      output.LatchInputStamp_En := stdlv(8);
      output.InputStampActivation := stdlv(5 downto 4);
      return output;
   end to_TICKTABLE_INPUTSTAMP_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(0) := reg.reserved_for_extra_latch;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE is
   variable output : TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;
   begin
      output.reserved_for_extra_latch := stdlv(0);
      return output;
   end to_TICKTABLE_RESERVED_FOR_EXTRA_LATCH_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TICKTABLE_INPUTSTAMPLATCHED_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TICKTABLE_INPUTSTAMPLATCHED_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.InputStamp;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TICKTABLE_INPUTSTAMPLATCHED_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TICKTABLE_INPUTSTAMPLATCHED_TYPE
   --------------------------------------------------------------------------------
   function to_TICKTABLE_INPUTSTAMPLATCHED_TYPE(stdlv : std_logic_vector(31 downto 0)) return TICKTABLE_INPUTSTAMPLATCHED_TYPE is
   variable output : TICKTABLE_INPUTSTAMPLATCHED_TYPE;
   begin
      output.InputStamp := stdlv(31 downto 0);
      return output;
   end to_TICKTABLE_INPUTSTAMPLATCHED_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.INPUTCOND_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(16 downto 12) := reg.NB_INPUTS;
      output(7 downto 0) := reg.Period_ns;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE
   --------------------------------------------------------------------------------
   function to_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE is
   variable output : INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;
   begin
      output.INPUTCOND_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_INPUTS := stdlv(16 downto 12);
      output.Period_ns := stdlv(7 downto 0);
      return output;
   end to_INPUTCONDITIONING_CAPABILITIES_INCOND_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INPUTCONDITIONING_INPUTCONDITIONING_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INPUTCONDITIONING_INPUTCONDITIONING_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 8) := reg.DebounceHoldOff;
      output(1) := reg.InputFiltering;
      output(0) := reg.InputPol;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INPUTCONDITIONING_INPUTCONDITIONING_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INPUTCONDITIONING_INPUTCONDITIONING_TYPE
   --------------------------------------------------------------------------------
   function to_INPUTCONDITIONING_INPUTCONDITIONING_TYPE(stdlv : std_logic_vector(31 downto 0)) return INPUTCONDITIONING_INPUTCONDITIONING_TYPE is
   variable output : INPUTCONDITIONING_INPUTCONDITIONING_TYPE;
   begin
      output.DebounceHoldOff := stdlv(31 downto 8);
      output.InputFiltering := stdlv(1);
      output.InputPol := stdlv(0);
      return output;
   end to_INPUTCONDITIONING_INPUTCONDITIONING_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.OUTPUTCOND_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(16 downto 12) := reg.NB_OUTPUTS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE
   --------------------------------------------------------------------------------
   function to_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE is
   variable output : OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;
   begin
      output.OUTPUTCOND_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_OUTPUTS := stdlv(16 downto 12);
      return output;
   end to_OUTPUTCONDITIONING_CAPABILITIES_OUTCOND_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from OUTPUTCONDITIONING_OUTPUTCOND_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_OUTPUTCOND_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.OutputVal;
      output(7) := reg.OutputPol;
      output(5 downto 0) := reg.Outsel;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_OUTPUTCONDITIONING_OUTPUTCOND_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to OUTPUTCONDITIONING_OUTPUTCOND_TYPE
   --------------------------------------------------------------------------------
   function to_OUTPUTCONDITIONING_OUTPUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_OUTPUTCOND_TYPE is
   variable output : OUTPUTCONDITIONING_OUTPUTCOND_TYPE;
   begin
      output.OutputVal := stdlv(16);
      output.OutputPol := stdlv(7);
      output.Outsel := stdlv(5 downto 0);
      return output;
   end to_OUTPUTCONDITIONING_OUTPUTCOND_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from OUTPUTCONDITIONING_RESERVED_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_RESERVED_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.Reserved;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_OUTPUTCONDITIONING_RESERVED_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to OUTPUTCONDITIONING_RESERVED_TYPE
   --------------------------------------------------------------------------------
   function to_OUTPUTCONDITIONING_RESERVED_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_RESERVED_TYPE is
   variable output : OUTPUTCONDITIONING_RESERVED_TYPE;
   begin
      output.Reserved := stdlv(7 downto 0);
      return output;
   end to_OUTPUTCONDITIONING_RESERVED_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.Output_HoldOFF_reg_EN;
      output(9 downto 0) := reg.Output_HoldOFF_reg_CNTR;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE
   --------------------------------------------------------------------------------
   function to_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE(stdlv : std_logic_vector(31 downto 0)) return OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE is
   variable output : OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;
   begin
      output.Output_HoldOFF_reg_EN := stdlv(16);
      output.Output_HoldOFF_reg_CNTR := stdlv(9 downto 0);
      return output;
   end to_OUTPUTCONDITIONING_OUTPUT_DEBOUNCE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERNALINPUT_CAPABILITIES_INT_INP_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERNALINPUT_CAPABILITIES_INT_INP_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.INT_INPUT_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(16 downto 12) := reg.NB_INPUTS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERNALINPUT_CAPABILITIES_INT_INP_TYPE
   --------------------------------------------------------------------------------
   function to_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALINPUT_CAPABILITIES_INT_INP_TYPE is
   variable output : INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;
   begin
      output.INT_INPUT_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_INPUTS := stdlv(16 downto 12);
      return output;
   end to_INTERNALINPUT_CAPABILITIES_INT_INP_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.INT_OUTPUT_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(16 downto 12) := reg.NB_OUTPUTS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE
   --------------------------------------------------------------------------------
   function to_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE is
   variable output : INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;
   begin
      output.INT_OUTPUT_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_OUTPUTS := stdlv(16 downto 12);
      return output;
   end to_INTERNALOUTPUT_CAPABILITIES_INTOUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from INTERNALOUTPUT_OUTPUTCOND_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : INTERNALOUTPUT_OUTPUTCOND_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(16) := reg.OutputVal;
      output(5 downto 0) := reg.Outsel;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_INTERNALOUTPUT_OUTPUTCOND_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to INTERNALOUTPUT_OUTPUTCOND_TYPE
   --------------------------------------------------------------------------------
   function to_INTERNALOUTPUT_OUTPUTCOND_TYPE(stdlv : std_logic_vector(31 downto 0)) return INTERNALOUTPUT_OUTPUTCOND_TYPE is
   variable output : INTERNALOUTPUT_OUTPUTCOND_TYPE;
   begin
      output.OutputVal := stdlv(16);
      output.Outsel := stdlv(5 downto 0);
      return output;
   end to_INTERNALOUTPUT_OUTPUTCOND_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_CAPABILITIES_TIMER_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_CAPABILITIES_TIMER_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.TIMER_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(11 downto 7) := reg.INTNUM;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_CAPABILITIES_TIMER_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_CAPABILITIES_TIMER_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_CAPABILITIES_TIMER_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_CAPABILITIES_TIMER_TYPE is
   variable output : TIMER_CAPABILITIES_TIMER_TYPE;
   begin
      output.TIMER_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.INTNUM := stdlv(11 downto 7);
      return output;
   end to_TIMER_CAPABILITIES_TIMER_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERCLOCKPERIOD_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERCLOCKPERIOD_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(15 downto 0) := reg.Period_ns;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERCLOCKPERIOD_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERCLOCKPERIOD_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERCLOCKPERIOD_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERCLOCKPERIOD_TYPE is
   variable output : TIMER_TIMERCLOCKPERIOD_TYPE;
   begin
      output.Period_ns := stdlv(15 downto 0);
      return output;
   end to_TIMER_TIMERCLOCKPERIOD_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERTRIGGERARM_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERTRIGGERARM_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31) := reg.Soft_TimerArm;
      output(26 downto 25) := reg.TimerTriggerOverlap;
      output(24) := reg.TimerArmEnable;
      output(23 downto 19) := reg.TimerArmSource;
      output(18 downto 16) := reg.TimerArmActivation;
      output(15) := reg.Soft_TimerTrigger;
      output(14) := reg.TimerMesurement;
      output(12 downto 11) := reg.TimerTriggerLogicESel;
      output(10 downto 9) := reg.TimerTriggerLogicDSel;
      output(8 downto 3) := reg.TimerTriggerSource;
      output(2 downto 0) := reg.TimerTriggerActivation;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERTRIGGERARM_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERTRIGGERARM_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERTRIGGERARM_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERTRIGGERARM_TYPE is
   variable output : TIMER_TIMERTRIGGERARM_TYPE;
   begin
      output.Soft_TimerArm := stdlv(31);
      output.TimerTriggerOverlap := stdlv(26 downto 25);
      output.TimerArmEnable := stdlv(24);
      output.TimerArmSource := stdlv(23 downto 19);
      output.TimerArmActivation := stdlv(18 downto 16);
      output.Soft_TimerTrigger := stdlv(15);
      output.TimerMesurement := stdlv(14);
      output.TimerTriggerLogicESel := stdlv(12 downto 11);
      output.TimerTriggerLogicDSel := stdlv(10 downto 9);
      output.TimerTriggerSource := stdlv(8 downto 3);
      output.TimerTriggerActivation := stdlv(2 downto 0);
      return output;
   end to_TIMER_TIMERTRIGGERARM_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERCLOCKSOURCE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERCLOCKSOURCE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(17 downto 16) := reg.IntClock_sel;
      output(13 downto 12) := reg.DelayClockActivation;
      output(11 downto 8) := reg.DelayClockSource;
      output(5 downto 4) := reg.TimerClockActivation;
      output(3 downto 0) := reg.TimerClockSource;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERCLOCKSOURCE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERCLOCKSOURCE_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERCLOCKSOURCE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERCLOCKSOURCE_TYPE is
   variable output : TIMER_TIMERCLOCKSOURCE_TYPE;
   begin
      output.IntClock_sel := stdlv(17 downto 16);
      output.DelayClockActivation := stdlv(13 downto 12);
      output.DelayClockSource := stdlv(11 downto 8);
      output.TimerClockActivation := stdlv(5 downto 4);
      output.TimerClockSource := stdlv(3 downto 0);
      return output;
   end to_TIMER_TIMERCLOCKSOURCE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERDELAYVALUE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERDELAYVALUE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.TimerDelayValue;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERDELAYVALUE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERDELAYVALUE_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERDELAYVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERDELAYVALUE_TYPE is
   variable output : TIMER_TIMERDELAYVALUE_TYPE;
   begin
      output.TimerDelayValue := stdlv(31 downto 0);
      return output;
   end to_TIMER_TIMERDELAYVALUE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERDURATION_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERDURATION_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.TimerDuration;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERDURATION_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERDURATION_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERDURATION_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERDURATION_TYPE is
   variable output : TIMER_TIMERDURATION_TYPE;
   begin
      output.TimerDuration := stdlv(31 downto 0);
      return output;
   end to_TIMER_TIMERDURATION_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERLATCHEDVALUE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERLATCHEDVALUE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 0) := reg.TimerLatchedValue;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERLATCHEDVALUE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERLATCHEDVALUE_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERLATCHEDVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERLATCHEDVALUE_TYPE is
   variable output : TIMER_TIMERLATCHEDVALUE_TYPE;
   begin
      output.TimerLatchedValue := stdlv(31 downto 0);
      return output;
   end to_TIMER_TIMERLATCHEDVALUE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from TIMER_TIMERSTATUS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : TIMER_TIMERSTATUS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 29) := reg.TimerStatus;
      output(28 downto 26) := reg.TimerStatus_Latched;
      output(17) := reg.TimerEndIntmaskn;
      output(16) := reg.TimerStartIntmaskn;
      output(10) := reg.TimerLatchAndReset;
      output(9) := reg.TimerLatchValue;
      output(8) := reg.TimerCntrReset;
      output(1) := reg.TimerInversion;
      output(0) := reg.TimerEnable;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_TIMER_TIMERSTATUS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to TIMER_TIMERSTATUS_TYPE
   --------------------------------------------------------------------------------
   function to_TIMER_TIMERSTATUS_TYPE(stdlv : std_logic_vector(31 downto 0)) return TIMER_TIMERSTATUS_TYPE is
   variable output : TIMER_TIMERSTATUS_TYPE;
   begin
      output.TimerStatus := stdlv(31 downto 29);
      output.TimerStatus_Latched := stdlv(28 downto 26);
      output.TimerEndIntmaskn := stdlv(17);
      output.TimerStartIntmaskn := stdlv(16);
      output.TimerLatchAndReset := stdlv(10);
      output.TimerLatchValue := stdlv(9);
      output.TimerCntrReset := stdlv(8);
      output.TimerInversion := stdlv(1);
      output.TimerEnable := stdlv(0);
      return output;
   end to_TIMER_TIMERSTATUS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from MICROBLAZE_CAPABILITIES_MICRO_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : MICROBLAZE_CAPABILITIES_MICRO_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.MICRO_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(19 downto 15) := reg.Intnum;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_MICROBLAZE_CAPABILITIES_MICRO_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to MICROBLAZE_CAPABILITIES_MICRO_TYPE
   --------------------------------------------------------------------------------
   function to_MICROBLAZE_CAPABILITIES_MICRO_TYPE(stdlv : std_logic_vector(31 downto 0)) return MICROBLAZE_CAPABILITIES_MICRO_TYPE is
   variable output : MICROBLAZE_CAPABILITIES_MICRO_TYPE;
   begin
      output.MICRO_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.Intnum := stdlv(19 downto 15);
      return output;
   end to_MICROBLAZE_CAPABILITIES_MICRO_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from MICROBLAZE_PRODCONS_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : MICROBLAZE_PRODCONS_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(24 downto 20) := reg.MemorySize;
      output(19 downto 0) := reg.Offset;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_MICROBLAZE_PRODCONS_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to MICROBLAZE_PRODCONS_TYPE
   --------------------------------------------------------------------------------
   function to_MICROBLAZE_PRODCONS_TYPE(stdlv : std_logic_vector(31 downto 0)) return MICROBLAZE_PRODCONS_TYPE is
   variable output : MICROBLAZE_PRODCONS_TYPE;
   begin
      output.MemorySize := stdlv(24 downto 20);
      output.Offset := stdlv(19 downto 0);
      return output;
   end to_MICROBLAZE_PRODCONS_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.ANA_OUT_ID;
      output(23 downto 20) := reg.FEATURE_REV;
      output(15 downto 12) := reg.NB_OUTPUTS;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE
   --------------------------------------------------------------------------------
   function to_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE(stdlv : std_logic_vector(31 downto 0)) return ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE is
   variable output : ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;
   begin
      output.ANA_OUT_ID := stdlv(31 downto 24);
      output.FEATURE_REV := stdlv(23 downto 20);
      output.NB_OUTPUTS := stdlv(15 downto 12);
      return output;
   end to_ANALOGOUTPUT_CAPABILITIES_ANA_OUT_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from ANALOGOUTPUT_OUTPUTVALUE_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : ANALOGOUTPUT_OUTPUTVALUE_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(7 downto 0) := reg.OutputVal;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_ANALOGOUTPUT_OUTPUTVALUE_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to ANALOGOUTPUT_OUTPUTVALUE_TYPE
   --------------------------------------------------------------------------------
   function to_ANALOGOUTPUT_OUTPUTVALUE_TYPE(stdlv : std_logic_vector(31 downto 0)) return ANALOGOUTPUT_OUTPUTVALUE_TYPE is
   variable output : ANALOGOUTPUT_OUTPUTVALUE_TYPE;
   begin
      output.OutputVal := stdlv(7 downto 0);
      return output;
   end to_ANALOGOUTPUT_OUTPUTVALUE_TYPE;

   --------------------------------------------------------------------------------
   -- Function Name: to_std_logic_vector
   -- Description: Cast from EOFM_EOFM_TYPE to std_logic_vector
   --------------------------------------------------------------------------------
   function to_std_logic_vector(reg : EOFM_EOFM_TYPE) return std_logic_vector is
   variable output : std_logic_vector(31 downto 0);
   begin
      output := (others=>'0'); -- Unassigned bits set to low
      output(31 downto 24) := reg.EOFM;
      return output;
   end to_std_logic_vector;

   --------------------------------------------------------------------------------
   -- Function Name: to_EOFM_EOFM_TYPE
   -- Description: Cast from std_logic_vector(31 downto 0) to EOFM_EOFM_TYPE
   --------------------------------------------------------------------------------
   function to_EOFM_EOFM_TYPE(stdlv : std_logic_vector(31 downto 0)) return EOFM_EOFM_TYPE is
   variable output : EOFM_EOFM_TYPE;
   begin
      output.EOFM := stdlv(31 downto 24);
      return output;
   end to_EOFM_EOFM_TYPE;

   
end package body;


-------------------------------------------------------------------------------
-- File                : regfile_ares.vhd
-- Project             : FDK
-- Module              : regfile_ares
-- Created on          : 2021/02/08 15:55:29
-- Created by          : amarchan
-- FDK IDE Version     : 4.7.0_beta4
-- Build ID            : I20191220-1537
-- Register file CRC32 : 0xA7167277
-------------------------------------------------------------------------------
-- The standard IEEE library
library ieee;
   use ieee.std_logic_1164.all; 
   use ieee.numeric_std.all;    
   use ieee.std_logic_unsigned.all;

-- Work library
library work;
   use work.regfile_ares_pack.all;


entity regfile_ares is
   
   port (
      resetN                       : in    std_logic;                                   -- System reset
      sysclk                       : in    std_logic;                                   -- System clock
      regfile                      : inout REGFILE_ARES_TYPE := INIT_REGFILE_ARES_TYPE; -- Register file
      ------------------------------------------------------------------------------------
      -- Interface name: registerFileIF
      -- Description: 
      ------------------------------------------------------------------------------------
      reg_wait                     : out   std_logic;                                   -- Wait
      reg_read                     : in    std_logic;                                   -- Read
      reg_write                    : in    std_logic;                                   -- Write
      reg_addr                     : in    std_logic_vector(14 downto 2);               -- Address
      reg_beN                      : in    std_logic_vector(3 downto 0);                -- Byte enable
      reg_writedata                : in    std_logic_vector(31 downto 0);               -- Write data
      reg_readdatavalid            : out   std_logic;                                   -- Read data valid
      reg_readdata                 : out   std_logic_vector(31 downto 0);               -- Read data
      ------------------------------------------------------------------------------------
      -- Interface name: External interface
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_writeBeN                 : out   std_logic_vector(3 downto 0);                -- Write Byte Enable Bus for all external sections
      ext_writeData                : out   std_logic_vector(31 downto 0);               -- Write Data Bus for all external sections
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[0]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_0          : out   std_logic_vector(10 downto 0);               -- Address Bus for ProdCons[0] external section
      ext_ProdCons_writeEn_0       : out   std_logic;                                   -- Write enable for ProdCons[0] external section
      ext_ProdCons_readEn_0        : out   std_logic;                                   -- Read enable for ProdCons[0] external section
      ext_ProdCons_readDataValid_0 : in    std_logic;                                   -- Read Data Valid for ProdCons[0] external section
      ext_ProdCons_readData_0      : in    std_logic_vector(31 downto 0);               -- Read Data for the ProdCons[0] external section
      ------------------------------------------------------------------------------------
      -- Interface name: ProdCons[1]
      -- Description: 
      ------------------------------------------------------------------------------------
      ext_ProdCons_addr_1          : out   std_logic_vector(10 downto 0);               -- Address Bus for ProdCons[1] external section
      ext_ProdCons_writeEn_1       : out   std_logic;                                   -- Write enable for ProdCons[1] external section
      ext_ProdCons_readEn_1        : out   std_logic;                                   -- Read enable for ProdCons[1] external section
      ext_ProdCons_readDataValid_1 : in    std_logic;                                   -- Read Data Valid for ProdCons[1] external section
      ext_ProdCons_readData_1      : in    std_logic_vector(31 downto 0)                -- Read Data for the ProdCons[1] external section
   );
   
end regfile_ares;

architecture rtl of regfile_ares is
------------------------------------------------------------------------------------------
-- Signals declaration
------------------------------------------------------------------------------------------
signal readBackMux                                                          : std_logic_vector(31 downto 0);                   -- Data readback multiplexer
signal hit                                                                  : std_logic_vector(166 downto 0);                  -- Address decode hit
signal wEn                                                                  : std_logic_vector(164 downto 0);                  -- Write Enable
signal fullAddr                                                             : std_logic_vector(15 downto 0):= (others => '0'); -- Full Address
signal fullAddrAsInt                                                        : integer;                                        
signal bitEnN                                                               : std_logic_vector(31 downto 0);                   -- Bits enable
signal ldData                                                               : std_logic;                                      
signal rb_Device_specific_INTSTAT                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Device_specific_INTMASKn                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Device_specific_INTSTAT2                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Device_specific_BUILDID                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Device_specific_FPGA_ID                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Device_specific_LED_OVERRIDE                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_INTERRUPT_QUEUE_CONTROL                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_INTERRUPT_QUEUE_CONS_IDX                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_INTERRUPT_QUEUE_ADDR_LOW                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_INTERRUPT_QUEUE_ADDR_HIGH                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_tlp_timeout                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_tlp_transaction_abort_cntr                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_SPI_SPIREGOUT                                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_ARBITER_CAPABILITIES                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_AGENT_0                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_arbiter_AGENT_1                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_ctrl                                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_pci_bar0_start                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_pci_bar0_stop                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_0_axi_translation                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_ctrl                                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_pci_bar0_start                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_pci_bar0_stop                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_1_axi_translation                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_ctrl                                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_pci_bar0_start                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_pci_bar0_stop                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_2_axi_translation                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_ctrl                                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_pci_bar0_start                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_pci_bar0_stop                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_axi_window_3_axi_translation                                      : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_CAPABILITIES_IO                                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_PIN                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_OUT                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_DIR                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_POL                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_INTSTAT                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_INTMASKn                                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_0_IO_ANYEDGE                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_CAPABILITIES_IO                                              : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_PIN                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_OUT                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_DIR                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_POL                                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_INTSTAT                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_INTMASKn                                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_IO_1_IO_ANYEDGE                                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_CAPABILITIES_QUAD                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_PositionReset                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderInput                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderCfg                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderPosTrigger                                    : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderCntrLatch_Cfg                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderCntrLatched_SW                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Quadrature_0_DecoderCntrLatched                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_CAPABILITIES_TICKTBL                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_CAPABILITIES_EXT1                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_TickTableClockPeriod                                  : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_TickConfig                                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_CurrentStampLatched                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_WriteTime                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_WriteCommand                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_LatchIntStat                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_InputStamp_0                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_InputStamp_1                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_0                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_1                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_2                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_3                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_4                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_5                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_6                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_7                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_8                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_reserved_for_extra_latch_9                            : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_InputStampLatched_0                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_TickTable_0_InputStampLatched_1                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InputConditioning_CAPABILITIES_INCOND                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InputConditioning_InputConditioning_0                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InputConditioning_InputConditioning_1                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InputConditioning_InputConditioning_2                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InputConditioning_InputConditioning_3                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_CAPABILITIES_OUTCOND                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_OutputCond_0                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_OutputCond_1                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_OutputCond_2                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_OutputCond_3                                   : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_Reserved                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_OutputConditioning_Output_Debounce                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InternalInput_CAPABILITIES_INT_INP                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InternalOutput_CAPABILITIES_INTOUT                                : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_InternalOutput_OutputCond_0                                       : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_0_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_1_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_2_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_3_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_4_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_5_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_6_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_CAPABILITIES_TIMER                                        : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerClockPeriod                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerTriggerArm                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerClockSource                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerDelayValue                                           : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerDuration                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerLatchedValue                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Timer_7_TimerStatus                                               : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Microblaze_CAPABILITIES_MICRO                                     : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Microblaze_ProdCons_0                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_Microblaze_ProdCons_1                                             : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_AnalogOutput_CAPABILITIES_ANA_OUT                                 : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_AnalogOutput_OutputValue                                          : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal rb_EOFM_EOFM                                                         : std_logic_vector(31 downto 0):= (others => '0'); -- Readback Register
signal field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH                    : std_logic;                                       -- Field: IRQ_TICK_LATCH
signal field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE                    : std_logic;                                       -- Field: IRQ_MICROBLAZE
signal field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA                       : std_logic;                                       -- Field: IRQ_TICK_WA
signal field_rw2c_Device_specific_INTSTAT_IRQ_TICK                          : std_logic;                                       -- Field: IRQ_TICK
signal field_rw2c_Device_specific_INTSTAT_IRQ_IO                            : std_logic;                                       -- Field: IRQ_IO
signal field_rw_Device_specific_INTMASKn_IRQ_MICROBLAZE                     : std_logic;                                       -- Field: IRQ_MICROBLAZE
signal field_rw_Device_specific_INTMASKn_IRQ_TICK_WA                        : std_logic;                                       -- Field: IRQ_TICK_WA
signal field_rw_Device_specific_INTMASKn_IRQ_TIMER                          : std_logic;                                       -- Field: IRQ_TIMER
signal field_rw_Device_specific_INTMASKn_IRQ_TICK                           : std_logic;                                       -- Field: IRQ_TICK
signal field_rw_Device_specific_INTMASKn_IRQ_IO                             : std_logic;                                       -- Field: IRQ_IO
signal field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END                    : std_logic_vector(7 downto 0);                    -- Field: IRQ_TIMER_END
signal field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START                  : std_logic_vector(7 downto 0);                    -- Field: IRQ_TIMER_START
signal field_rw_Device_specific_FPGA_ID_USER_RED_LED                        : std_logic;                                       -- Field: USER_RED_LED
signal field_rw_Device_specific_FPGA_ID_USER_GREEN_LED                      : std_logic;                                       -- Field: USER_GREEN_LED
signal field_rw_Device_specific_FPGA_ID_PROFINET_LED                        : std_logic;                                       -- Field: PROFINET_LED
signal field_rw_Device_specific_FPGA_ID_PB_DEBUG_COM                        : std_logic;                                       -- Field: PB_DEBUG_COM
signal field_rw_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH               : std_logic;                                       -- Field: RED_ORANGE_FLASH
signal field_rw_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH               : std_logic;                                       -- Field: ORANGE_OFF_FLASH
signal field_rw_INTERRUPT_QUEUE_CONTROL_ENABLE                              : std_logic;                                       -- Field: ENABLE
signal field_rw_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX                           : std_logic_vector(9 downto 0);                    -- Field: CONS_IDX
signal field_rw_INTERRUPT_QUEUE_ADDR_LOW_ADDR                               : std_logic_vector(18 downto 0);                   -- Field: ADDR
signal field_rw_INTERRUPT_QUEUE_ADDR_HIGH_ADDR                              : std_logic_vector(31 downto 0);                   -- Field: ADDR
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END                 : std_logic_vector(7 downto 0);                    -- Field: IRQ_TIMER_END
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START               : std_logic_vector(7 downto 0);                    -- Field: IRQ_TIMER_START
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT                    : std_logic_vector(3 downto 0);                    -- Field: IO_INTSTAT
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH                : std_logic;                                       -- Field: IRQ_TICK_LATCH
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE                : std_logic;                                       -- Field: IRQ_MICROBLAZE
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER                     : std_logic;                                       -- Field: IRQ_TIMER
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA                   : std_logic;                                       -- Field: IRQ_TICK_WA
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK                      : std_logic;                                       -- Field: IRQ_TICK
signal field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_IO                        : std_logic;                                       -- Field: IRQ_IO
signal field_rw_tlp_timeout_value                                           : std_logic_vector(31 downto 0);                   -- Field: value
signal field_wautoclr_tlp_transaction_abort_cntr_clr                        : std_logic;                                       -- Field: clr
signal field_rw_SPI_SPIREGIN_SPI_ENABLE                                     : std_logic;                                       -- Field: SPI_ENABLE
signal field_rw_SPI_SPIREGIN_SPIRW                                          : std_logic;                                       -- Field: SPIRW
signal field_rw_SPI_SPIREGIN_SPICMDDONE                                     : std_logic;                                       -- Field: SPICMDDONE
signal field_rw_SPI_SPIREGIN_SPISEL                                         : std_logic;                                       -- Field: SPISEL
signal field_wautoclr_SPI_SPIREGIN_SPITXST                                  : std_logic;                                       -- Field: SPITXST
signal field_rw_SPI_SPIREGIN_SPIDATAW                                       : std_logic_vector(7 downto 0);                    -- Field: SPIDATAW
signal field_wautoclr_arbiter_AGENT_0_DONE                                  : std_logic;                                       -- Field: DONE
signal field_wautoclr_arbiter_AGENT_0_REQ                                   : std_logic;                                       -- Field: REQ
signal field_wautoclr_arbiter_AGENT_1_DONE                                  : std_logic;                                       -- Field: DONE
signal field_wautoclr_arbiter_AGENT_1_REQ                                   : std_logic;                                       -- Field: REQ
signal field_rw_axi_window_0_ctrl_enable                                    : std_logic;                                       -- Field: enable
signal field_rw_axi_window_0_pci_bar0_start_value                           : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_0_pci_bar0_stop_value                            : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_0_axi_translation_value                          : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_1_ctrl_enable                                    : std_logic;                                       -- Field: enable
signal field_rw_axi_window_1_pci_bar0_start_value                           : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_1_pci_bar0_stop_value                            : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_1_axi_translation_value                          : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_2_ctrl_enable                                    : std_logic;                                       -- Field: enable
signal field_rw_axi_window_2_pci_bar0_start_value                           : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_2_pci_bar0_stop_value                            : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_2_axi_translation_value                          : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_axi_window_3_ctrl_enable                                    : std_logic;                                       -- Field: enable
signal field_rw_axi_window_3_pci_bar0_start_value                           : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_3_pci_bar0_stop_value                            : std_logic_vector(23 downto 0);                   -- Field: value
signal field_rw_axi_window_3_axi_translation_value                          : std_logic_vector(29 downto 0);                   -- Field: value
signal field_rw_IO_0_IO_OUT_Out_value                                       : std_logic_vector(3 downto 0);                    -- Field: Out_value
signal field_rw_IO_0_IO_DIR_Dir                                             : std_logic_vector(3 downto 0);                    -- Field: Dir
signal field_rw_IO_0_IO_POL_In_pol                                          : std_logic_vector(3 downto 0);                    -- Field: In_pol
signal field_rw2c_IO_0_IO_INTSTAT_Intstat                                   : std_logic_vector(3 downto 0);                    -- Field: Intstat
signal field_rw_IO_0_IO_INTMASKn_Intmaskn                                   : std_logic_vector(3 downto 0);                    -- Field: Intmaskn
signal field_rw_IO_0_IO_ANYEDGE_In_AnyEdge                                  : std_logic_vector(3 downto 0);                    -- Field: In_AnyEdge
signal field_rw_IO_1_IO_OUT_Out_value                                       : std_logic_vector(3 downto 0);                    -- Field: Out_value
signal field_rw_IO_1_IO_DIR_Dir                                             : std_logic_vector(3 downto 0);                    -- Field: Dir
signal field_rw_IO_1_IO_POL_In_pol                                          : std_logic_vector(3 downto 0);                    -- Field: In_pol
signal field_rw2c_IO_1_IO_INTSTAT_Intstat                                   : std_logic_vector(3 downto 0);                    -- Field: Intstat
signal field_rw_IO_1_IO_INTMASKn_Intmaskn                                   : std_logic_vector(3 downto 0);                    -- Field: Intmaskn
signal field_rw_IO_1_IO_ANYEDGE_In_AnyEdge                                  : std_logic_vector(3 downto 0);                    -- Field: In_AnyEdge
signal field_rw_Quadrature_0_PositionReset_PositionResetSource              : std_logic_vector(3 downto 0);                    -- Field: PositionResetSource
signal field_rw_Quadrature_0_PositionReset_PositionResetActivation          : std_logic;                                       -- Field: PositionResetActivation
signal field_wautoclr_Quadrature_0_PositionReset_soft_PositionReset         : std_logic;                                       -- Field: soft_PositionReset
signal field_rw_Quadrature_0_DecoderInput_BSelector                         : std_logic_vector(2 downto 0);                    -- Field: BSelector
signal field_rw_Quadrature_0_DecoderInput_ASelector                         : std_logic_vector(2 downto 0);                    -- Field: ASelector
signal field_rw_Quadrature_0_DecoderCfg_DecOutSource0                       : std_logic_vector(2 downto 0);                    -- Field: DecOutSource0
signal field_rw_Quadrature_0_DecoderCfg_QuadEnable                          : std_logic;                                       -- Field: QuadEnable
signal field_rw_Quadrature_0_DecoderPosTrigger_PositionTrigger              : std_logic_vector(31 downto 0);                   -- Field: PositionTrigger
signal field_wautoclr_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW : std_logic;                                       -- Field: DecoderCntrLatch_SW
signal field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src      : std_logic_vector(4 downto 0);                    -- Field: DecoderCntrLatch_Src
signal field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En       : std_logic;                                       -- Field: DecoderCntrLatch_En
signal field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act      : std_logic_vector(1 downto 0);                    -- Field: DecoderCntrLatch_Act
signal field_wautoclr_TickTable_0_TickConfig_ClearTickTable                 : std_logic;                                       -- Field: ClearTickTable
signal field_rw_TickTable_0_TickConfig_ClearMask                            : std_logic_vector(7 downto 0);                    -- Field: ClearMask
signal field_rw_TickTable_0_TickConfig_TickClock                            : std_logic_vector(3 downto 0);                    -- Field: TickClock
signal field_rw_TickTable_0_TickConfig_IntClock_sel                         : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_TickTable_0_TickConfig_TickClockActivation                  : std_logic_vector(1 downto 0);                    -- Field: TickClockActivation
signal field_rw_TickTable_0_TickConfig_EnableHalftableInt                   : std_logic;                                       -- Field: EnableHalftableInt
signal field_rw_TickTable_0_TickConfig_IntClock_en                          : std_logic;                                       -- Field: IntClock_en
signal field_wautoclr_TickTable_0_TickConfig_LatchCurrentStamp              : std_logic;                                       -- Field: LatchCurrentStamp
signal field_wautoclr_TickTable_0_TickConfig_ResetTimestamp                 : std_logic;                                       -- Field: ResetTimestamp
signal field_rw_TickTable_0_WriteTime_WriteTime                             : std_logic_vector(31 downto 0);                   -- Field: WriteTime
signal field_wautoclr_TickTable_0_WriteCommand_ExecuteFutureWrite           : std_logic;                                       -- Field: ExecuteFutureWrite
signal field_wautoclr_TickTable_0_WriteCommand_ExecuteImmWrite              : std_logic;                                       -- Field: ExecuteImmWrite
signal field_rw_TickTable_0_WriteCommand_BitCmd                             : std_logic_vector(1 downto 0);                    -- Field: BitCmd
signal field_rw_TickTable_0_WriteCommand_BitNum                             : std_logic_vector(1 downto 0);                    -- Field: BitNum
signal field_rw2c_TickTable_0_LatchIntStat_LatchIntStat                     : std_logic_vector(1 downto 0);                    -- Field: LatchIntStat
signal field_rw_TickTable_0_InputStamp_0_InputStampSource                   : std_logic_vector(3 downto 0);                    -- Field: InputStampSource
signal field_rw_TickTable_0_InputStamp_0_LatchInputIntEnable                : std_logic;                                       -- Field: LatchInputIntEnable
signal field_rw_TickTable_0_InputStamp_0_LatchInputStamp_En                 : std_logic;                                       -- Field: LatchInputStamp_En
signal field_rw_TickTable_0_InputStamp_0_InputStampActivation               : std_logic_vector(1 downto 0);                    -- Field: InputStampActivation
signal field_rw_TickTable_0_InputStamp_1_InputStampSource                   : std_logic_vector(3 downto 0);                    -- Field: InputStampSource
signal field_rw_TickTable_0_InputStamp_1_LatchInputIntEnable                : std_logic;                                       -- Field: LatchInputIntEnable
signal field_rw_TickTable_0_InputStamp_1_LatchInputStamp_En                 : std_logic;                                       -- Field: LatchInputStamp_En
signal field_rw_TickTable_0_InputStamp_1_InputStampActivation               : std_logic_vector(1 downto 0);                    -- Field: InputStampActivation
signal field_rw_InputConditioning_InputConditioning_0_DebounceHoldOff       : std_logic_vector(23 downto 0);                   -- Field: DebounceHoldOff
signal field_rw_InputConditioning_InputConditioning_0_InputFiltering        : std_logic;                                       -- Field: InputFiltering
signal field_rw_InputConditioning_InputConditioning_0_InputPol              : std_logic;                                       -- Field: InputPol
signal field_rw_InputConditioning_InputConditioning_1_DebounceHoldOff       : std_logic_vector(23 downto 0);                   -- Field: DebounceHoldOff
signal field_rw_InputConditioning_InputConditioning_1_InputFiltering        : std_logic;                                       -- Field: InputFiltering
signal field_rw_InputConditioning_InputConditioning_1_InputPol              : std_logic;                                       -- Field: InputPol
signal field_rw_InputConditioning_InputConditioning_2_DebounceHoldOff       : std_logic_vector(23 downto 0);                   -- Field: DebounceHoldOff
signal field_rw_InputConditioning_InputConditioning_2_InputFiltering        : std_logic;                                       -- Field: InputFiltering
signal field_rw_InputConditioning_InputConditioning_2_InputPol              : std_logic;                                       -- Field: InputPol
signal field_rw_InputConditioning_InputConditioning_3_DebounceHoldOff       : std_logic_vector(23 downto 0);                   -- Field: DebounceHoldOff
signal field_rw_InputConditioning_InputConditioning_3_InputFiltering        : std_logic;                                       -- Field: InputFiltering
signal field_rw_InputConditioning_InputConditioning_3_InputPol              : std_logic;                                       -- Field: InputPol
signal field_rw_OutputConditioning_OutputCond_0_OutputPol                   : std_logic;                                       -- Field: OutputPol
signal field_rw_OutputConditioning_OutputCond_0_Outsel                      : std_logic_vector(5 downto 0);                    -- Field: Outsel
signal field_rw_OutputConditioning_OutputCond_1_OutputPol                   : std_logic;                                       -- Field: OutputPol
signal field_rw_OutputConditioning_OutputCond_1_Outsel                      : std_logic_vector(5 downto 0);                    -- Field: Outsel
signal field_rw_OutputConditioning_OutputCond_2_OutputPol                   : std_logic;                                       -- Field: OutputPol
signal field_rw_OutputConditioning_OutputCond_2_Outsel                      : std_logic_vector(5 downto 0);                    -- Field: Outsel
signal field_rw_OutputConditioning_OutputCond_3_OutputPol                   : std_logic;                                       -- Field: OutputPol
signal field_rw_OutputConditioning_OutputCond_3_Outsel                      : std_logic_vector(5 downto 0);                    -- Field: Outsel
signal field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN    : std_logic;                                       -- Field: Output_HoldOFF_reg_EN
signal field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR  : std_logic_vector(9 downto 0);                    -- Field: Output_HoldOFF_reg_CNTR
signal field_rw_InternalOutput_OutputCond_0_Outsel                          : std_logic_vector(5 downto 0);                    -- Field: Outsel
signal field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_0_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_0_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_0_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_0_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_0_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_0_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_0_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_0_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_0_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_0_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_0_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_0_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_0_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_0_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_0_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_0_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_0_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_0_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_0_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_0_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_0_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_1_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_1_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_1_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_1_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_1_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_1_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_1_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_1_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_1_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_1_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_1_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_1_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_1_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_1_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_1_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_1_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_1_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_1_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_1_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_1_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_1_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_2_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_2_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_2_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_2_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_2_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_2_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_2_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_2_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_2_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_2_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_2_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_2_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_2_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_2_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_2_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_2_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_2_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_2_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_2_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_2_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_2_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_3_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_3_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_3_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_3_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_3_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_3_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_3_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_3_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_3_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_3_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_3_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_3_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_3_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_3_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_3_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_3_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_3_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_3_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_3_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_3_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_3_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_4_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_4_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_4_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_4_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_4_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_4_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_4_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_4_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_4_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_4_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_4_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_4_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_4_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_4_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_4_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_4_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_4_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_4_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_4_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_4_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_4_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_5_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_5_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_5_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_5_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_5_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_5_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_5_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_5_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_5_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_5_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_5_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_5_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_5_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_5_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_5_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_5_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_5_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_5_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_5_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_5_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_5_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_6_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_6_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_6_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_6_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_6_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_6_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_6_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_6_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_6_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_6_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_6_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_6_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_6_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_6_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_6_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_6_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_6_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_6_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_6_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_6_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_6_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerArm                 : std_logic;                                       -- Field: Soft_TimerArm
signal field_rw_Timer_7_TimerTriggerArm_TimerTriggerOverlap                 : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerOverlap
signal field_rw_Timer_7_TimerTriggerArm_TimerArmEnable                      : std_logic;                                       -- Field: TimerArmEnable
signal field_rw_Timer_7_TimerTriggerArm_TimerArmSource                      : std_logic_vector(4 downto 0);                    -- Field: TimerArmSource
signal field_rw_Timer_7_TimerTriggerArm_TimerArmActivation                  : std_logic_vector(2 downto 0);                    -- Field: TimerArmActivation
signal field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerTrigger             : std_logic;                                       -- Field: Soft_TimerTrigger
signal field_rw_Timer_7_TimerTriggerArm_TimerMesurement                     : std_logic;                                       -- Field: TimerMesurement
signal field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicESel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicESel
signal field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel               : std_logic_vector(1 downto 0);                    -- Field: TimerTriggerLogicDSel
signal field_rw_Timer_7_TimerTriggerArm_TimerTriggerSource                  : std_logic_vector(5 downto 0);                    -- Field: TimerTriggerSource
signal field_rw_Timer_7_TimerTriggerArm_TimerTriggerActivation              : std_logic_vector(2 downto 0);                    -- Field: TimerTriggerActivation
signal field_rw_Timer_7_TimerClockSource_IntClock_sel                       : std_logic_vector(1 downto 0);                    -- Field: IntClock_sel
signal field_rw_Timer_7_TimerClockSource_DelayClockActivation               : std_logic_vector(1 downto 0);                    -- Field: DelayClockActivation
signal field_rw_Timer_7_TimerClockSource_DelayClockSource                   : std_logic_vector(3 downto 0);                    -- Field: DelayClockSource
signal field_rw_Timer_7_TimerClockSource_TimerClockActivation               : std_logic_vector(1 downto 0);                    -- Field: TimerClockActivation
signal field_rw_Timer_7_TimerClockSource_TimerClockSource                   : std_logic_vector(3 downto 0);                    -- Field: TimerClockSource
signal field_rw_Timer_7_TimerDelayValue_TimerDelayValue                     : std_logic_vector(31 downto 0);                   -- Field: TimerDelayValue
signal field_rw_Timer_7_TimerDuration_TimerDuration                         : std_logic_vector(31 downto 0);                   -- Field: TimerDuration
signal field_rw_Timer_7_TimerStatus_TimerEndIntmaskn                        : std_logic;                                       -- Field: TimerEndIntmaskn
signal field_rw_Timer_7_TimerStatus_TimerStartIntmaskn                      : std_logic;                                       -- Field: TimerStartIntmaskn
signal field_rw_Timer_7_TimerStatus_TimerLatchAndReset                      : std_logic;                                       -- Field: TimerLatchAndReset
signal field_wautoclr_Timer_7_TimerStatus_TimerLatchValue                   : std_logic;                                       -- Field: TimerLatchValue
signal field_wautoclr_Timer_7_TimerStatus_TimerCntrReset                    : std_logic;                                       -- Field: TimerCntrReset
signal field_rw_Timer_7_TimerStatus_TimerInversion                          : std_logic;                                       -- Field: TimerInversion
signal field_rw_Timer_7_TimerStatus_TimerEnable                             : std_logic;                                       -- Field: TimerEnable
signal field_rw_AnalogOutput_OutputValue_OutputVal                          : std_logic_vector(7 downto 0);                    -- Field: OutputVal
signal ext_ProdCons_readDataValid_0_FF                                      : std_logic;                                       -- Pipelined version of ext_ProdCons_readDataValid_0
signal ext_ProdCons_readData_0_FF                                           : std_logic_vector(31 downto 0);                   -- Pipelined version of ext_ProdCons_readData_0
signal ext_ProdCons_readPending_0                                           : std_logic;                                       -- Read pending for the ProdCons external section
signal ext_ProdCons_readDataValid_1_FF                                      : std_logic;                                       -- Pipelined version of ext_ProdCons_readDataValid_1
signal ext_ProdCons_readData_1_FF                                           : std_logic_vector(31 downto 0);                   -- Pipelined version of ext_ProdCons_readData_1
signal ext_ProdCons_readPending_1                                           : std_logic;                                       -- Read pending for the ProdCons external section

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
fullAddr(14 downto 2)<= reg_addr;

hit(0)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#0#,16)))	else '0'; -- Addr:  0x0000	INTSTAT
hit(1)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4#,16)))	else '0'; -- Addr:  0x0004	INTMASKn
hit(2)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#8#,16)))	else '0'; -- Addr:  0x0008	INTSTAT2
hit(3)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#1c#,16)))	else '0'; -- Addr:  0x001C	BUILDID
hit(4)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20#,16)))	else '0'; -- Addr:  0x0020	FPGA_ID
hit(5)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#24#,16)))	else '0'; -- Addr:  0x0024	LED_OVERRIDE
hit(6)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40#,16)))	else '0'; -- Addr:  0x0040	CONTROL
hit(7)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#44#,16)))	else '0'; -- Addr:  0x0044	CONS_IDX
hit(8)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48#,16)))	else '0'; -- Addr:  0x0048	ADDR_LOW
hit(9)   <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4c#,16)))	else '0'; -- Addr:  0x004C	ADDR_HIGH
hit(10)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#50#,16)))	else '0'; -- Addr:  0x0050	MAPPING
hit(11)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70#,16)))	else '0'; -- Addr:  0x0070	timeout
hit(12)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#74#,16)))	else '0'; -- Addr:  0x0074	transaction_abort_cntr
hit(13)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#e0#,16)))	else '0'; -- Addr:  0x00E0	SPIREGIN
hit(14)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#e8#,16)))	else '0'; -- Addr:  0x00E8	SPIREGOUT
hit(15)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f0#,16)))	else '0'; -- Addr:  0x00F0	ARBITER_CAPABILITIES
hit(16)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f4#,16)))	else '0'; -- Addr:  0x00F4	AGENT[0]
hit(17)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#f8#,16)))	else '0'; -- Addr:  0x00F8	AGENT[1]
hit(18)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#100#,16)))	else '0'; -- Addr:  0x0100	ctrl
hit(19)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#104#,16)))	else '0'; -- Addr:  0x0104	pci_bar0_start
hit(20)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#108#,16)))	else '0'; -- Addr:  0x0108	pci_bar0_stop
hit(21)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#10c#,16)))	else '0'; -- Addr:  0x010C	axi_translation
hit(22)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#110#,16)))	else '0'; -- Addr:  0x0110	ctrl
hit(23)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#114#,16)))	else '0'; -- Addr:  0x0114	pci_bar0_start
hit(24)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#118#,16)))	else '0'; -- Addr:  0x0118	pci_bar0_stop
hit(25)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#11c#,16)))	else '0'; -- Addr:  0x011C	axi_translation
hit(26)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#120#,16)))	else '0'; -- Addr:  0x0120	ctrl
hit(27)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#124#,16)))	else '0'; -- Addr:  0x0124	pci_bar0_start
hit(28)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#128#,16)))	else '0'; -- Addr:  0x0128	pci_bar0_stop
hit(29)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#12c#,16)))	else '0'; -- Addr:  0x012C	axi_translation
hit(30)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#130#,16)))	else '0'; -- Addr:  0x0130	ctrl
hit(31)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#134#,16)))	else '0'; -- Addr:  0x0134	pci_bar0_start
hit(32)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#138#,16)))	else '0'; -- Addr:  0x0138	pci_bar0_stop
hit(33)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#13c#,16)))	else '0'; -- Addr:  0x013C	axi_translation
hit(34)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#200#,16)))	else '0'; -- Addr:  0x0200	CAPABILITIES_IO
hit(35)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#204#,16)))	else '0'; -- Addr:  0x0204	IO_PIN
hit(36)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#208#,16)))	else '0'; -- Addr:  0x0208	IO_OUT
hit(37)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#20c#,16)))	else '0'; -- Addr:  0x020C	IO_DIR
hit(38)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#210#,16)))	else '0'; -- Addr:  0x0210	IO_POL
hit(39)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#214#,16)))	else '0'; -- Addr:  0x0214	IO_INTSTAT
hit(40)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#218#,16)))	else '0'; -- Addr:  0x0218	IO_INTMASKn
hit(41)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#21c#,16)))	else '0'; -- Addr:  0x021C	IO_ANYEDGE
hit(42)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#280#,16)))	else '0'; -- Addr:  0x0280	CAPABILITIES_IO
hit(43)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#284#,16)))	else '0'; -- Addr:  0x0284	IO_PIN
hit(44)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#288#,16)))	else '0'; -- Addr:  0x0288	IO_OUT
hit(45)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#28c#,16)))	else '0'; -- Addr:  0x028C	IO_DIR
hit(46)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#290#,16)))	else '0'; -- Addr:  0x0290	IO_POL
hit(47)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#294#,16)))	else '0'; -- Addr:  0x0294	IO_INTSTAT
hit(48)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#298#,16)))	else '0'; -- Addr:  0x0298	IO_INTMASKn
hit(49)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#29c#,16)))	else '0'; -- Addr:  0x029C	IO_ANYEDGE
hit(50)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#300#,16)))	else '0'; -- Addr:  0x0300	CAPABILITIES_QUAD
hit(51)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#304#,16)))	else '0'; -- Addr:  0x0304	PositionReset
hit(52)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#308#,16)))	else '0'; -- Addr:  0x0308	DecoderInput
hit(53)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#30c#,16)))	else '0'; -- Addr:  0x030C	DecoderCfg
hit(54)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#310#,16)))	else '0'; -- Addr:  0x0310	DecoderPosTrigger
hit(55)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#314#,16)))	else '0'; -- Addr:  0x0314	DecoderCntrLatch_Cfg
hit(56)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#334#,16)))	else '0'; -- Addr:  0x0334	DecoderCntrLatched_SW
hit(57)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#338#,16)))	else '0'; -- Addr:  0x0338	DecoderCntrLatched
hit(58)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#380#,16)))	else '0'; -- Addr:  0x0380	CAPABILITIES_TICKTBL
hit(59)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#384#,16)))	else '0'; -- Addr:  0x0384	CAPABILITIES_EXT1
hit(60)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#388#,16)))	else '0'; -- Addr:  0x0388	TickTableClockPeriod
hit(61)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#38c#,16)))	else '0'; -- Addr:  0x038C	TickConfig
hit(62)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#390#,16)))	else '0'; -- Addr:  0x0390	CurrentStampLatched
hit(63)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#394#,16)))	else '0'; -- Addr:  0x0394	WriteTime
hit(64)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#398#,16)))	else '0'; -- Addr:  0x0398	WriteCommand
hit(65)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#39c#,16)))	else '0'; -- Addr:  0x039C	LatchIntStat
hit(66)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3a0#,16)))	else '0'; -- Addr:  0x03A0	InputStamp[0]
hit(67)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3a4#,16)))	else '0'; -- Addr:  0x03A4	InputStamp[1]
hit(68)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3a8#,16)))	else '0'; -- Addr:  0x03A8	reserved_for_extra_latch[0]
hit(69)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3ac#,16)))	else '0'; -- Addr:  0x03AC	reserved_for_extra_latch[1]
hit(70)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3b0#,16)))	else '0'; -- Addr:  0x03B0	reserved_for_extra_latch[2]
hit(71)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3b4#,16)))	else '0'; -- Addr:  0x03B4	reserved_for_extra_latch[3]
hit(72)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3b8#,16)))	else '0'; -- Addr:  0x03B8	reserved_for_extra_latch[4]
hit(73)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3bc#,16)))	else '0'; -- Addr:  0x03BC	reserved_for_extra_latch[5]
hit(74)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3c0#,16)))	else '0'; -- Addr:  0x03C0	reserved_for_extra_latch[6]
hit(75)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3c4#,16)))	else '0'; -- Addr:  0x03C4	reserved_for_extra_latch[7]
hit(76)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3c8#,16)))	else '0'; -- Addr:  0x03C8	reserved_for_extra_latch[8]
hit(77)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3cc#,16)))	else '0'; -- Addr:  0x03CC	reserved_for_extra_latch[9]
hit(78)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3d0#,16)))	else '0'; -- Addr:  0x03D0	InputStampLatched[0]
hit(79)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#3d4#,16)))	else '0'; -- Addr:  0x03D4	InputStampLatched[1]
hit(80)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#400#,16)))	else '0'; -- Addr:  0x0400	CAPABILITIES_INCOND
hit(81)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#404#,16)))	else '0'; -- Addr:  0x0404	InputConditioning[0]
hit(82)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#408#,16)))	else '0'; -- Addr:  0x0408	InputConditioning[1]
hit(83)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#40c#,16)))	else '0'; -- Addr:  0x040C	InputConditioning[2]
hit(84)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#410#,16)))	else '0'; -- Addr:  0x0410	InputConditioning[3]
hit(85)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#480#,16)))	else '0'; -- Addr:  0x0480	CAPABILITIES_OUTCOND
hit(86)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#484#,16)))	else '0'; -- Addr:  0x0484	OutputCond[0]
hit(87)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#488#,16)))	else '0'; -- Addr:  0x0488	OutputCond[1]
hit(88)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#48c#,16)))	else '0'; -- Addr:  0x048C	OutputCond[2]
hit(89)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#490#,16)))	else '0'; -- Addr:  0x0490	OutputCond[3]
hit(90)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#494#,16)))	else '0'; -- Addr:  0x0494	Reserved
hit(91)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#4ac#,16)))	else '0'; -- Addr:  0x04AC	Output_Debounce
hit(92)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#500#,16)))	else '0'; -- Addr:  0x0500	CAPABILITIES_INT_INP
hit(93)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#580#,16)))	else '0'; -- Addr:  0x0580	CAPABILITIES_INTOUT
hit(94)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#584#,16)))	else '0'; -- Addr:  0x0584	OutputCond[0]
hit(95)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#600#,16)))	else '0'; -- Addr:  0x0600	CAPABILITIES_TIMER
hit(96)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#604#,16)))	else '0'; -- Addr:  0x0604	TimerClockPeriod
hit(97)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#608#,16)))	else '0'; -- Addr:  0x0608	TimerTriggerArm
hit(98)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#60c#,16)))	else '0'; -- Addr:  0x060C	TimerClockSource
hit(99)  <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#610#,16)))	else '0'; -- Addr:  0x0610	TimerDelayValue
hit(100) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#614#,16)))	else '0'; -- Addr:  0x0614	TimerDuration
hit(101) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#618#,16)))	else '0'; -- Addr:  0x0618	TimerLatchedValue
hit(102) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#61c#,16)))	else '0'; -- Addr:  0x061C	TimerStatus
hit(103) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#680#,16)))	else '0'; -- Addr:  0x0680	CAPABILITIES_TIMER
hit(104) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#684#,16)))	else '0'; -- Addr:  0x0684	TimerClockPeriod
hit(105) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#688#,16)))	else '0'; -- Addr:  0x0688	TimerTriggerArm
hit(106) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#68c#,16)))	else '0'; -- Addr:  0x068C	TimerClockSource
hit(107) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#690#,16)))	else '0'; -- Addr:  0x0690	TimerDelayValue
hit(108) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#694#,16)))	else '0'; -- Addr:  0x0694	TimerDuration
hit(109) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#698#,16)))	else '0'; -- Addr:  0x0698	TimerLatchedValue
hit(110) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#69c#,16)))	else '0'; -- Addr:  0x069C	TimerStatus
hit(111) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#700#,16)))	else '0'; -- Addr:  0x0700	CAPABILITIES_TIMER
hit(112) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#704#,16)))	else '0'; -- Addr:  0x0704	TimerClockPeriod
hit(113) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#708#,16)))	else '0'; -- Addr:  0x0708	TimerTriggerArm
hit(114) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#70c#,16)))	else '0'; -- Addr:  0x070C	TimerClockSource
hit(115) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#710#,16)))	else '0'; -- Addr:  0x0710	TimerDelayValue
hit(116) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#714#,16)))	else '0'; -- Addr:  0x0714	TimerDuration
hit(117) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#718#,16)))	else '0'; -- Addr:  0x0718	TimerLatchedValue
hit(118) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#71c#,16)))	else '0'; -- Addr:  0x071C	TimerStatus
hit(119) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#780#,16)))	else '0'; -- Addr:  0x0780	CAPABILITIES_TIMER
hit(120) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#784#,16)))	else '0'; -- Addr:  0x0784	TimerClockPeriod
hit(121) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#788#,16)))	else '0'; -- Addr:  0x0788	TimerTriggerArm
hit(122) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#78c#,16)))	else '0'; -- Addr:  0x078C	TimerClockSource
hit(123) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#790#,16)))	else '0'; -- Addr:  0x0790	TimerDelayValue
hit(124) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#794#,16)))	else '0'; -- Addr:  0x0794	TimerDuration
hit(125) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#798#,16)))	else '0'; -- Addr:  0x0798	TimerLatchedValue
hit(126) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#79c#,16)))	else '0'; -- Addr:  0x079C	TimerStatus
hit(127) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#800#,16)))	else '0'; -- Addr:  0x0800	CAPABILITIES_TIMER
hit(128) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#804#,16)))	else '0'; -- Addr:  0x0804	TimerClockPeriod
hit(129) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#808#,16)))	else '0'; -- Addr:  0x0808	TimerTriggerArm
hit(130) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#80c#,16)))	else '0'; -- Addr:  0x080C	TimerClockSource
hit(131) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#810#,16)))	else '0'; -- Addr:  0x0810	TimerDelayValue
hit(132) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#814#,16)))	else '0'; -- Addr:  0x0814	TimerDuration
hit(133) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#818#,16)))	else '0'; -- Addr:  0x0818	TimerLatchedValue
hit(134) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#81c#,16)))	else '0'; -- Addr:  0x081C	TimerStatus
hit(135) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#880#,16)))	else '0'; -- Addr:  0x0880	CAPABILITIES_TIMER
hit(136) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#884#,16)))	else '0'; -- Addr:  0x0884	TimerClockPeriod
hit(137) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#888#,16)))	else '0'; -- Addr:  0x0888	TimerTriggerArm
hit(138) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#88c#,16)))	else '0'; -- Addr:  0x088C	TimerClockSource
hit(139) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#890#,16)))	else '0'; -- Addr:  0x0890	TimerDelayValue
hit(140) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#894#,16)))	else '0'; -- Addr:  0x0894	TimerDuration
hit(141) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#898#,16)))	else '0'; -- Addr:  0x0898	TimerLatchedValue
hit(142) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#89c#,16)))	else '0'; -- Addr:  0x089C	TimerStatus
hit(143) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#900#,16)))	else '0'; -- Addr:  0x0900	CAPABILITIES_TIMER
hit(144) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#904#,16)))	else '0'; -- Addr:  0x0904	TimerClockPeriod
hit(145) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#908#,16)))	else '0'; -- Addr:  0x0908	TimerTriggerArm
hit(146) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#90c#,16)))	else '0'; -- Addr:  0x090C	TimerClockSource
hit(147) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#910#,16)))	else '0'; -- Addr:  0x0910	TimerDelayValue
hit(148) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#914#,16)))	else '0'; -- Addr:  0x0914	TimerDuration
hit(149) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#918#,16)))	else '0'; -- Addr:  0x0918	TimerLatchedValue
hit(150) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#91c#,16)))	else '0'; -- Addr:  0x091C	TimerStatus
hit(151) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#980#,16)))	else '0'; -- Addr:  0x0980	CAPABILITIES_TIMER
hit(152) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#984#,16)))	else '0'; -- Addr:  0x0984	TimerClockPeriod
hit(153) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#988#,16)))	else '0'; -- Addr:  0x0988	TimerTriggerArm
hit(154) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#98c#,16)))	else '0'; -- Addr:  0x098C	TimerClockSource
hit(155) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#990#,16)))	else '0'; -- Addr:  0x0990	TimerDelayValue
hit(156) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#994#,16)))	else '0'; -- Addr:  0x0994	TimerDuration
hit(157) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#998#,16)))	else '0'; -- Addr:  0x0998	TimerLatchedValue
hit(158) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#99c#,16)))	else '0'; -- Addr:  0x099C	TimerStatus
hit(159) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a00#,16)))	else '0'; -- Addr:  0x0A00	CAPABILITIES_MICRO
hit(160) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a04#,16)))	else '0'; -- Addr:  0x0A04	ProdCons[0]
hit(161) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a08#,16)))	else '0'; -- Addr:  0x0A08	ProdCons[1]
hit(162) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a80#,16)))	else '0'; -- Addr:  0x0A80	CAPABILITIES_ANA_OUT
hit(163) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#a84#,16)))	else '0'; -- Addr:  0x0A84	OutputValue
hit(164) <= '1' when (fullAddr = std_logic_vector(to_unsigned(16#b00#,16)))	else '0'; -- Addr:  0x0B00	EOFM

hit(165) <= '1' when (fullAddr >= std_logic_vector(to_unsigned(16#2000#,16)) and fullAddr <= std_logic_vector(to_unsigned(16#3ffc#,16)))	else '0'; -- Addr:  0x2000 to 0x3FFC	ProdCons[0]
hit(166) <= '1' when (fullAddr >= std_logic_vector(to_unsigned(16#4000#,16)) and fullAddr <= std_logic_vector(to_unsigned(16#5ffc#,16)))	else '0'; -- Addr:  0x4000 to 0x5FFC	ProdCons[1]


fullAddrAsInt <= CONV_integer(fullAddr);


------------------------------------------------------------------------------------------
-- Process: P_readBackMux_Mux
------------------------------------------------------------------------------------------
P_readBackMux_Mux : process(fullAddrAsInt,
                            rb_Device_specific_INTSTAT,
                            rb_Device_specific_INTMASKn,
                            rb_Device_specific_INTSTAT2,
                            rb_Device_specific_BUILDID,
                            rb_Device_specific_FPGA_ID,
                            rb_Device_specific_LED_OVERRIDE,
                            rb_INTERRUPT_QUEUE_CONTROL,
                            rb_INTERRUPT_QUEUE_CONS_IDX,
                            rb_INTERRUPT_QUEUE_ADDR_LOW,
                            rb_INTERRUPT_QUEUE_ADDR_HIGH,
                            rb_tlp_timeout,
                            rb_tlp_transaction_abort_cntr,
                            rb_SPI_SPIREGOUT,
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
                            rb_IO_0_CAPABILITIES_IO,
                            rb_IO_0_IO_PIN,
                            rb_IO_0_IO_OUT,
                            rb_IO_0_IO_DIR,
                            rb_IO_0_IO_POL,
                            rb_IO_0_IO_INTSTAT,
                            rb_IO_0_IO_INTMASKn,
                            rb_IO_0_IO_ANYEDGE,
                            rb_IO_1_CAPABILITIES_IO,
                            rb_IO_1_IO_PIN,
                            rb_IO_1_IO_OUT,
                            rb_IO_1_IO_DIR,
                            rb_IO_1_IO_POL,
                            rb_IO_1_IO_INTSTAT,
                            rb_IO_1_IO_INTMASKn,
                            rb_IO_1_IO_ANYEDGE,
                            rb_Quadrature_0_CAPABILITIES_QUAD,
                            rb_Quadrature_0_PositionReset,
                            rb_Quadrature_0_DecoderInput,
                            rb_Quadrature_0_DecoderCfg,
                            rb_Quadrature_0_DecoderPosTrigger,
                            rb_Quadrature_0_DecoderCntrLatch_Cfg,
                            rb_Quadrature_0_DecoderCntrLatched_SW,
                            rb_Quadrature_0_DecoderCntrLatched,
                            rb_TickTable_0_CAPABILITIES_TICKTBL,
                            rb_TickTable_0_CAPABILITIES_EXT1,
                            rb_TickTable_0_TickTableClockPeriod,
                            rb_TickTable_0_TickConfig,
                            rb_TickTable_0_CurrentStampLatched,
                            rb_TickTable_0_WriteTime,
                            rb_TickTable_0_WriteCommand,
                            rb_TickTable_0_LatchIntStat,
                            rb_TickTable_0_InputStamp_0,
                            rb_TickTable_0_InputStamp_1,
                            rb_TickTable_0_reserved_for_extra_latch_0,
                            rb_TickTable_0_reserved_for_extra_latch_1,
                            rb_TickTable_0_reserved_for_extra_latch_2,
                            rb_TickTable_0_reserved_for_extra_latch_3,
                            rb_TickTable_0_reserved_for_extra_latch_4,
                            rb_TickTable_0_reserved_for_extra_latch_5,
                            rb_TickTable_0_reserved_for_extra_latch_6,
                            rb_TickTable_0_reserved_for_extra_latch_7,
                            rb_TickTable_0_reserved_for_extra_latch_8,
                            rb_TickTable_0_reserved_for_extra_latch_9,
                            rb_TickTable_0_InputStampLatched_0,
                            rb_TickTable_0_InputStampLatched_1,
                            rb_InputConditioning_CAPABILITIES_INCOND,
                            rb_InputConditioning_InputConditioning_0,
                            rb_InputConditioning_InputConditioning_1,
                            rb_InputConditioning_InputConditioning_2,
                            rb_InputConditioning_InputConditioning_3,
                            rb_OutputConditioning_CAPABILITIES_OUTCOND,
                            rb_OutputConditioning_OutputCond_0,
                            rb_OutputConditioning_OutputCond_1,
                            rb_OutputConditioning_OutputCond_2,
                            rb_OutputConditioning_OutputCond_3,
                            rb_OutputConditioning_Reserved,
                            rb_OutputConditioning_Output_Debounce,
                            rb_InternalInput_CAPABILITIES_INT_INP,
                            rb_InternalOutput_CAPABILITIES_INTOUT,
                            rb_InternalOutput_OutputCond_0,
                            rb_Timer_0_CAPABILITIES_TIMER,
                            rb_Timer_0_TimerClockPeriod,
                            rb_Timer_0_TimerTriggerArm,
                            rb_Timer_0_TimerClockSource,
                            rb_Timer_0_TimerDelayValue,
                            rb_Timer_0_TimerDuration,
                            rb_Timer_0_TimerLatchedValue,
                            rb_Timer_0_TimerStatus,
                            rb_Timer_1_CAPABILITIES_TIMER,
                            rb_Timer_1_TimerClockPeriod,
                            rb_Timer_1_TimerTriggerArm,
                            rb_Timer_1_TimerClockSource,
                            rb_Timer_1_TimerDelayValue,
                            rb_Timer_1_TimerDuration,
                            rb_Timer_1_TimerLatchedValue,
                            rb_Timer_1_TimerStatus,
                            rb_Timer_2_CAPABILITIES_TIMER,
                            rb_Timer_2_TimerClockPeriod,
                            rb_Timer_2_TimerTriggerArm,
                            rb_Timer_2_TimerClockSource,
                            rb_Timer_2_TimerDelayValue,
                            rb_Timer_2_TimerDuration,
                            rb_Timer_2_TimerLatchedValue,
                            rb_Timer_2_TimerStatus,
                            rb_Timer_3_CAPABILITIES_TIMER,
                            rb_Timer_3_TimerClockPeriod,
                            rb_Timer_3_TimerTriggerArm,
                            rb_Timer_3_TimerClockSource,
                            rb_Timer_3_TimerDelayValue,
                            rb_Timer_3_TimerDuration,
                            rb_Timer_3_TimerLatchedValue,
                            rb_Timer_3_TimerStatus,
                            rb_Timer_4_CAPABILITIES_TIMER,
                            rb_Timer_4_TimerClockPeriod,
                            rb_Timer_4_TimerTriggerArm,
                            rb_Timer_4_TimerClockSource,
                            rb_Timer_4_TimerDelayValue,
                            rb_Timer_4_TimerDuration,
                            rb_Timer_4_TimerLatchedValue,
                            rb_Timer_4_TimerStatus,
                            rb_Timer_5_CAPABILITIES_TIMER,
                            rb_Timer_5_TimerClockPeriod,
                            rb_Timer_5_TimerTriggerArm,
                            rb_Timer_5_TimerClockSource,
                            rb_Timer_5_TimerDelayValue,
                            rb_Timer_5_TimerDuration,
                            rb_Timer_5_TimerLatchedValue,
                            rb_Timer_5_TimerStatus,
                            rb_Timer_6_CAPABILITIES_TIMER,
                            rb_Timer_6_TimerClockPeriod,
                            rb_Timer_6_TimerTriggerArm,
                            rb_Timer_6_TimerClockSource,
                            rb_Timer_6_TimerDelayValue,
                            rb_Timer_6_TimerDuration,
                            rb_Timer_6_TimerLatchedValue,
                            rb_Timer_6_TimerStatus,
                            rb_Timer_7_CAPABILITIES_TIMER,
                            rb_Timer_7_TimerClockPeriod,
                            rb_Timer_7_TimerTriggerArm,
                            rb_Timer_7_TimerClockSource,
                            rb_Timer_7_TimerDelayValue,
                            rb_Timer_7_TimerDuration,
                            rb_Timer_7_TimerLatchedValue,
                            rb_Timer_7_TimerStatus,
                            rb_Microblaze_CAPABILITIES_MICRO,
                            rb_Microblaze_ProdCons_0,
                            rb_Microblaze_ProdCons_1,
                            rb_AnalogOutput_CAPABILITIES_ANA_OUT,
                            rb_AnalogOutput_OutputValue,
                            rb_EOFM_EOFM,
                            ext_ProdCons_readData_0_FF,
                            ext_ProdCons_readData_1_FF
                           )
begin
   case fullAddrAsInt is
      -- [0x0000]: /Device_specific/INTSTAT
      when 16#0# =>
         readBackMux <= rb_Device_specific_INTSTAT;

      -- [0x0004]: /Device_specific/INTMASKn
      when 16#4# =>
         readBackMux <= rb_Device_specific_INTMASKn;

      -- [0x0008]: /Device_specific/INTSTAT2
      when 16#8# =>
         readBackMux <= rb_Device_specific_INTSTAT2;

      -- [0x001c]: /Device_specific/BUILDID
      when 16#1C# =>
         readBackMux <= rb_Device_specific_BUILDID;

      -- [0x0020]: /Device_specific/FPGA_ID
      when 16#20# =>
         readBackMux <= rb_Device_specific_FPGA_ID;

      -- [0x0024]: /Device_specific/LED_OVERRIDE
      when 16#24# =>
         readBackMux <= rb_Device_specific_LED_OVERRIDE;

      -- [0x0040]: /INTERRUPT_QUEUE/CONTROL
      when 16#40# =>
         readBackMux <= rb_INTERRUPT_QUEUE_CONTROL;

      -- [0x0044]: /INTERRUPT_QUEUE/CONS_IDX
      when 16#44# =>
         readBackMux <= rb_INTERRUPT_QUEUE_CONS_IDX;

      -- [0x0048]: /INTERRUPT_QUEUE/ADDR_LOW
      when 16#48# =>
         readBackMux <= rb_INTERRUPT_QUEUE_ADDR_LOW;

      -- [0x004c]: /INTERRUPT_QUEUE/ADDR_HIGH
      when 16#4C# =>
         readBackMux <= rb_INTERRUPT_QUEUE_ADDR_HIGH;

      -- [0x0050]: /INTERRUPT_QUEUE/MAPPING -> Readback disable
      -- [0x0070]: /tlp/timeout
      when 16#70# =>
         readBackMux <= rb_tlp_timeout;

      -- [0x0074]: /tlp/transaction_abort_cntr
      when 16#74# =>
         readBackMux <= rb_tlp_transaction_abort_cntr;

      -- [0x00e0]: /SPI/SPIREGIN    -> Readback disable
      -- [0x00e8]: /SPI/SPIREGOUT
      when 16#E8# =>
         readBackMux <= rb_SPI_SPIREGOUT;

      -- [0x00f0]: /arbiter/ARBITER_CAPABILITIES
      when 16#F0# =>
         readBackMux <= rb_arbiter_ARBITER_CAPABILITIES;

      -- [0x00f4]: /arbiter/AGENT_0
      when 16#F4# =>
         readBackMux <= rb_arbiter_AGENT_0;

      -- [0x00f8]: /arbiter/AGENT_1
      when 16#F8# =>
         readBackMux <= rb_arbiter_AGENT_1;

      -- [0x0100]: /axi_window_0/ctrl
      when 16#100# =>
         readBackMux <= rb_axi_window_0_ctrl;

      -- [0x0104]: /axi_window_0/pci_bar0_start
      when 16#104# =>
         readBackMux <= rb_axi_window_0_pci_bar0_start;

      -- [0x0108]: /axi_window_0/pci_bar0_stop
      when 16#108# =>
         readBackMux <= rb_axi_window_0_pci_bar0_stop;

      -- [0x010c]: /axi_window_0/axi_translation
      when 16#10C# =>
         readBackMux <= rb_axi_window_0_axi_translation;

      -- [0x0110]: /axi_window_1/ctrl
      when 16#110# =>
         readBackMux <= rb_axi_window_1_ctrl;

      -- [0x0114]: /axi_window_1/pci_bar0_start
      when 16#114# =>
         readBackMux <= rb_axi_window_1_pci_bar0_start;

      -- [0x0118]: /axi_window_1/pci_bar0_stop
      when 16#118# =>
         readBackMux <= rb_axi_window_1_pci_bar0_stop;

      -- [0x011c]: /axi_window_1/axi_translation
      when 16#11C# =>
         readBackMux <= rb_axi_window_1_axi_translation;

      -- [0x0120]: /axi_window_2/ctrl
      when 16#120# =>
         readBackMux <= rb_axi_window_2_ctrl;

      -- [0x0124]: /axi_window_2/pci_bar0_start
      when 16#124# =>
         readBackMux <= rb_axi_window_2_pci_bar0_start;

      -- [0x0128]: /axi_window_2/pci_bar0_stop
      when 16#128# =>
         readBackMux <= rb_axi_window_2_pci_bar0_stop;

      -- [0x012c]: /axi_window_2/axi_translation
      when 16#12C# =>
         readBackMux <= rb_axi_window_2_axi_translation;

      -- [0x0130]: /axi_window_3/ctrl
      when 16#130# =>
         readBackMux <= rb_axi_window_3_ctrl;

      -- [0x0134]: /axi_window_3/pci_bar0_start
      when 16#134# =>
         readBackMux <= rb_axi_window_3_pci_bar0_start;

      -- [0x0138]: /axi_window_3/pci_bar0_stop
      when 16#138# =>
         readBackMux <= rb_axi_window_3_pci_bar0_stop;

      -- [0x013c]: /axi_window_3/axi_translation
      when 16#13C# =>
         readBackMux <= rb_axi_window_3_axi_translation;

      -- [0x0200]: /IO_0/CAPABILITIES_IO
      when 16#200# =>
         readBackMux <= rb_IO_0_CAPABILITIES_IO;

      -- [0x0204]: /IO_0/IO_PIN
      when 16#204# =>
         readBackMux <= rb_IO_0_IO_PIN;

      -- [0x0208]: /IO_0/IO_OUT
      when 16#208# =>
         readBackMux <= rb_IO_0_IO_OUT;

      -- [0x020c]: /IO_0/IO_DIR
      when 16#20C# =>
         readBackMux <= rb_IO_0_IO_DIR;

      -- [0x0210]: /IO_0/IO_POL
      when 16#210# =>
         readBackMux <= rb_IO_0_IO_POL;

      -- [0x0214]: /IO_0/IO_INTSTAT
      when 16#214# =>
         readBackMux <= rb_IO_0_IO_INTSTAT;

      -- [0x0218]: /IO_0/IO_INTMASKn
      when 16#218# =>
         readBackMux <= rb_IO_0_IO_INTMASKn;

      -- [0x021c]: /IO_0/IO_ANYEDGE
      when 16#21C# =>
         readBackMux <= rb_IO_0_IO_ANYEDGE;

      -- [0x0280]: /IO_1/CAPABILITIES_IO
      when 16#280# =>
         readBackMux <= rb_IO_1_CAPABILITIES_IO;

      -- [0x0284]: /IO_1/IO_PIN
      when 16#284# =>
         readBackMux <= rb_IO_1_IO_PIN;

      -- [0x0288]: /IO_1/IO_OUT
      when 16#288# =>
         readBackMux <= rb_IO_1_IO_OUT;

      -- [0x028c]: /IO_1/IO_DIR
      when 16#28C# =>
         readBackMux <= rb_IO_1_IO_DIR;

      -- [0x0290]: /IO_1/IO_POL
      when 16#290# =>
         readBackMux <= rb_IO_1_IO_POL;

      -- [0x0294]: /IO_1/IO_INTSTAT
      when 16#294# =>
         readBackMux <= rb_IO_1_IO_INTSTAT;

      -- [0x0298]: /IO_1/IO_INTMASKn
      when 16#298# =>
         readBackMux <= rb_IO_1_IO_INTMASKn;

      -- [0x029c]: /IO_1/IO_ANYEDGE
      when 16#29C# =>
         readBackMux <= rb_IO_1_IO_ANYEDGE;

      -- [0x0300]: /Quadrature_0/CAPABILITIES_QUAD
      when 16#300# =>
         readBackMux <= rb_Quadrature_0_CAPABILITIES_QUAD;

      -- [0x0304]: /Quadrature_0/PositionReset
      when 16#304# =>
         readBackMux <= rb_Quadrature_0_PositionReset;

      -- [0x0308]: /Quadrature_0/DecoderInput
      when 16#308# =>
         readBackMux <= rb_Quadrature_0_DecoderInput;

      -- [0x030c]: /Quadrature_0/DecoderCfg
      when 16#30C# =>
         readBackMux <= rb_Quadrature_0_DecoderCfg;

      -- [0x0310]: /Quadrature_0/DecoderPosTrigger
      when 16#310# =>
         readBackMux <= rb_Quadrature_0_DecoderPosTrigger;

      -- [0x0314]: /Quadrature_0/DecoderCntrLatch_Cfg
      when 16#314# =>
         readBackMux <= rb_Quadrature_0_DecoderCntrLatch_Cfg;

      -- [0x0334]: /Quadrature_0/DecoderCntrLatched_SW
      when 16#334# =>
         readBackMux <= rb_Quadrature_0_DecoderCntrLatched_SW;

      -- [0x0338]: /Quadrature_0/DecoderCntrLatched
      when 16#338# =>
         readBackMux <= rb_Quadrature_0_DecoderCntrLatched;

      -- [0x0380]: /TickTable_0/CAPABILITIES_TICKTBL
      when 16#380# =>
         readBackMux <= rb_TickTable_0_CAPABILITIES_TICKTBL;

      -- [0x0384]: /TickTable_0/CAPABILITIES_EXT1
      when 16#384# =>
         readBackMux <= rb_TickTable_0_CAPABILITIES_EXT1;

      -- [0x0388]: /TickTable_0/TickTableClockPeriod
      when 16#388# =>
         readBackMux <= rb_TickTable_0_TickTableClockPeriod;

      -- [0x038c]: /TickTable_0/TickConfig
      when 16#38C# =>
         readBackMux <= rb_TickTable_0_TickConfig;

      -- [0x0390]: /TickTable_0/CurrentStampLatched
      when 16#390# =>
         readBackMux <= rb_TickTable_0_CurrentStampLatched;

      -- [0x0394]: /TickTable_0/WriteTime
      when 16#394# =>
         readBackMux <= rb_TickTable_0_WriteTime;

      -- [0x0398]: /TickTable_0/WriteCommand
      when 16#398# =>
         readBackMux <= rb_TickTable_0_WriteCommand;

      -- [0x039c]: /TickTable_0/LatchIntStat
      when 16#39C# =>
         readBackMux <= rb_TickTable_0_LatchIntStat;

      -- [0x03a0]: /TickTable_0/InputStamp_0
      when 16#3A0# =>
         readBackMux <= rb_TickTable_0_InputStamp_0;

      -- [0x03a4]: /TickTable_0/InputStamp_1
      when 16#3A4# =>
         readBackMux <= rb_TickTable_0_InputStamp_1;

      -- [0x03a8]: /TickTable_0/reserved_for_extra_latch_0
      when 16#3A8# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_0;

      -- [0x03ac]: /TickTable_0/reserved_for_extra_latch_1
      when 16#3AC# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_1;

      -- [0x03b0]: /TickTable_0/reserved_for_extra_latch_2
      when 16#3B0# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_2;

      -- [0x03b4]: /TickTable_0/reserved_for_extra_latch_3
      when 16#3B4# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_3;

      -- [0x03b8]: /TickTable_0/reserved_for_extra_latch_4
      when 16#3B8# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_4;

      -- [0x03bc]: /TickTable_0/reserved_for_extra_latch_5
      when 16#3BC# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_5;

      -- [0x03c0]: /TickTable_0/reserved_for_extra_latch_6
      when 16#3C0# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_6;

      -- [0x03c4]: /TickTable_0/reserved_for_extra_latch_7
      when 16#3C4# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_7;

      -- [0x03c8]: /TickTable_0/reserved_for_extra_latch_8
      when 16#3C8# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_8;

      -- [0x03cc]: /TickTable_0/reserved_for_extra_latch_9
      when 16#3CC# =>
         readBackMux <= rb_TickTable_0_reserved_for_extra_latch_9;

      -- [0x03d0]: /TickTable_0/InputStampLatched_0
      when 16#3D0# =>
         readBackMux <= rb_TickTable_0_InputStampLatched_0;

      -- [0x03d4]: /TickTable_0/InputStampLatched_1
      when 16#3D4# =>
         readBackMux <= rb_TickTable_0_InputStampLatched_1;

      -- [0x0400]: /InputConditioning/CAPABILITIES_INCOND
      when 16#400# =>
         readBackMux <= rb_InputConditioning_CAPABILITIES_INCOND;

      -- [0x0404]: /InputConditioning/InputConditioning_0
      when 16#404# =>
         readBackMux <= rb_InputConditioning_InputConditioning_0;

      -- [0x0408]: /InputConditioning/InputConditioning_1
      when 16#408# =>
         readBackMux <= rb_InputConditioning_InputConditioning_1;

      -- [0x040c]: /InputConditioning/InputConditioning_2
      when 16#40C# =>
         readBackMux <= rb_InputConditioning_InputConditioning_2;

      -- [0x0410]: /InputConditioning/InputConditioning_3
      when 16#410# =>
         readBackMux <= rb_InputConditioning_InputConditioning_3;

      -- [0x0480]: /OutputConditioning/CAPABILITIES_OUTCOND
      when 16#480# =>
         readBackMux <= rb_OutputConditioning_CAPABILITIES_OUTCOND;

      -- [0x0484]: /OutputConditioning/OutputCond_0
      when 16#484# =>
         readBackMux <= rb_OutputConditioning_OutputCond_0;

      -- [0x0488]: /OutputConditioning/OutputCond_1
      when 16#488# =>
         readBackMux <= rb_OutputConditioning_OutputCond_1;

      -- [0x048c]: /OutputConditioning/OutputCond_2
      when 16#48C# =>
         readBackMux <= rb_OutputConditioning_OutputCond_2;

      -- [0x0490]: /OutputConditioning/OutputCond_3
      when 16#490# =>
         readBackMux <= rb_OutputConditioning_OutputCond_3;

      -- [0x0494]: /OutputConditioning/Reserved
      when 16#494# =>
         readBackMux <= rb_OutputConditioning_Reserved;

      -- [0x04ac]: /OutputConditioning/Output_Debounce
      when 16#4AC# =>
         readBackMux <= rb_OutputConditioning_Output_Debounce;

      -- [0x0500]: /InternalInput/CAPABILITIES_INT_INP
      when 16#500# =>
         readBackMux <= rb_InternalInput_CAPABILITIES_INT_INP;

      -- [0x0580]: /InternalOutput/CAPABILITIES_INTOUT
      when 16#580# =>
         readBackMux <= rb_InternalOutput_CAPABILITIES_INTOUT;

      -- [0x0584]: /InternalOutput/OutputCond_0
      when 16#584# =>
         readBackMux <= rb_InternalOutput_OutputCond_0;

      -- [0x0600]: /Timer_0/CAPABILITIES_TIMER
      when 16#600# =>
         readBackMux <= rb_Timer_0_CAPABILITIES_TIMER;

      -- [0x0604]: /Timer_0/TimerClockPeriod
      when 16#604# =>
         readBackMux <= rb_Timer_0_TimerClockPeriod;

      -- [0x0608]: /Timer_0/TimerTriggerArm
      when 16#608# =>
         readBackMux <= rb_Timer_0_TimerTriggerArm;

      -- [0x060c]: /Timer_0/TimerClockSource
      when 16#60C# =>
         readBackMux <= rb_Timer_0_TimerClockSource;

      -- [0x0610]: /Timer_0/TimerDelayValue
      when 16#610# =>
         readBackMux <= rb_Timer_0_TimerDelayValue;

      -- [0x0614]: /Timer_0/TimerDuration
      when 16#614# =>
         readBackMux <= rb_Timer_0_TimerDuration;

      -- [0x0618]: /Timer_0/TimerLatchedValue
      when 16#618# =>
         readBackMux <= rb_Timer_0_TimerLatchedValue;

      -- [0x061c]: /Timer_0/TimerStatus
      when 16#61C# =>
         readBackMux <= rb_Timer_0_TimerStatus;

      -- [0x0680]: /Timer_1/CAPABILITIES_TIMER
      when 16#680# =>
         readBackMux <= rb_Timer_1_CAPABILITIES_TIMER;

      -- [0x0684]: /Timer_1/TimerClockPeriod
      when 16#684# =>
         readBackMux <= rb_Timer_1_TimerClockPeriod;

      -- [0x0688]: /Timer_1/TimerTriggerArm
      when 16#688# =>
         readBackMux <= rb_Timer_1_TimerTriggerArm;

      -- [0x068c]: /Timer_1/TimerClockSource
      when 16#68C# =>
         readBackMux <= rb_Timer_1_TimerClockSource;

      -- [0x0690]: /Timer_1/TimerDelayValue
      when 16#690# =>
         readBackMux <= rb_Timer_1_TimerDelayValue;

      -- [0x0694]: /Timer_1/TimerDuration
      when 16#694# =>
         readBackMux <= rb_Timer_1_TimerDuration;

      -- [0x0698]: /Timer_1/TimerLatchedValue
      when 16#698# =>
         readBackMux <= rb_Timer_1_TimerLatchedValue;

      -- [0x069c]: /Timer_1/TimerStatus
      when 16#69C# =>
         readBackMux <= rb_Timer_1_TimerStatus;

      -- [0x0700]: /Timer_2/CAPABILITIES_TIMER
      when 16#700# =>
         readBackMux <= rb_Timer_2_CAPABILITIES_TIMER;

      -- [0x0704]: /Timer_2/TimerClockPeriod
      when 16#704# =>
         readBackMux <= rb_Timer_2_TimerClockPeriod;

      -- [0x0708]: /Timer_2/TimerTriggerArm
      when 16#708# =>
         readBackMux <= rb_Timer_2_TimerTriggerArm;

      -- [0x070c]: /Timer_2/TimerClockSource
      when 16#70C# =>
         readBackMux <= rb_Timer_2_TimerClockSource;

      -- [0x0710]: /Timer_2/TimerDelayValue
      when 16#710# =>
         readBackMux <= rb_Timer_2_TimerDelayValue;

      -- [0x0714]: /Timer_2/TimerDuration
      when 16#714# =>
         readBackMux <= rb_Timer_2_TimerDuration;

      -- [0x0718]: /Timer_2/TimerLatchedValue
      when 16#718# =>
         readBackMux <= rb_Timer_2_TimerLatchedValue;

      -- [0x071c]: /Timer_2/TimerStatus
      when 16#71C# =>
         readBackMux <= rb_Timer_2_TimerStatus;

      -- [0x0780]: /Timer_3/CAPABILITIES_TIMER
      when 16#780# =>
         readBackMux <= rb_Timer_3_CAPABILITIES_TIMER;

      -- [0x0784]: /Timer_3/TimerClockPeriod
      when 16#784# =>
         readBackMux <= rb_Timer_3_TimerClockPeriod;

      -- [0x0788]: /Timer_3/TimerTriggerArm
      when 16#788# =>
         readBackMux <= rb_Timer_3_TimerTriggerArm;

      -- [0x078c]: /Timer_3/TimerClockSource
      when 16#78C# =>
         readBackMux <= rb_Timer_3_TimerClockSource;

      -- [0x0790]: /Timer_3/TimerDelayValue
      when 16#790# =>
         readBackMux <= rb_Timer_3_TimerDelayValue;

      -- [0x0794]: /Timer_3/TimerDuration
      when 16#794# =>
         readBackMux <= rb_Timer_3_TimerDuration;

      -- [0x0798]: /Timer_3/TimerLatchedValue
      when 16#798# =>
         readBackMux <= rb_Timer_3_TimerLatchedValue;

      -- [0x079c]: /Timer_3/TimerStatus
      when 16#79C# =>
         readBackMux <= rb_Timer_3_TimerStatus;

      -- [0x0800]: /Timer_4/CAPABILITIES_TIMER
      when 16#800# =>
         readBackMux <= rb_Timer_4_CAPABILITIES_TIMER;

      -- [0x0804]: /Timer_4/TimerClockPeriod
      when 16#804# =>
         readBackMux <= rb_Timer_4_TimerClockPeriod;

      -- [0x0808]: /Timer_4/TimerTriggerArm
      when 16#808# =>
         readBackMux <= rb_Timer_4_TimerTriggerArm;

      -- [0x080c]: /Timer_4/TimerClockSource
      when 16#80C# =>
         readBackMux <= rb_Timer_4_TimerClockSource;

      -- [0x0810]: /Timer_4/TimerDelayValue
      when 16#810# =>
         readBackMux <= rb_Timer_4_TimerDelayValue;

      -- [0x0814]: /Timer_4/TimerDuration
      when 16#814# =>
         readBackMux <= rb_Timer_4_TimerDuration;

      -- [0x0818]: /Timer_4/TimerLatchedValue
      when 16#818# =>
         readBackMux <= rb_Timer_4_TimerLatchedValue;

      -- [0x081c]: /Timer_4/TimerStatus
      when 16#81C# =>
         readBackMux <= rb_Timer_4_TimerStatus;

      -- [0x0880]: /Timer_5/CAPABILITIES_TIMER
      when 16#880# =>
         readBackMux <= rb_Timer_5_CAPABILITIES_TIMER;

      -- [0x0884]: /Timer_5/TimerClockPeriod
      when 16#884# =>
         readBackMux <= rb_Timer_5_TimerClockPeriod;

      -- [0x0888]: /Timer_5/TimerTriggerArm
      when 16#888# =>
         readBackMux <= rb_Timer_5_TimerTriggerArm;

      -- [0x088c]: /Timer_5/TimerClockSource
      when 16#88C# =>
         readBackMux <= rb_Timer_5_TimerClockSource;

      -- [0x0890]: /Timer_5/TimerDelayValue
      when 16#890# =>
         readBackMux <= rb_Timer_5_TimerDelayValue;

      -- [0x0894]: /Timer_5/TimerDuration
      when 16#894# =>
         readBackMux <= rb_Timer_5_TimerDuration;

      -- [0x0898]: /Timer_5/TimerLatchedValue
      when 16#898# =>
         readBackMux <= rb_Timer_5_TimerLatchedValue;

      -- [0x089c]: /Timer_5/TimerStatus
      when 16#89C# =>
         readBackMux <= rb_Timer_5_TimerStatus;

      -- [0x0900]: /Timer_6/CAPABILITIES_TIMER
      when 16#900# =>
         readBackMux <= rb_Timer_6_CAPABILITIES_TIMER;

      -- [0x0904]: /Timer_6/TimerClockPeriod
      when 16#904# =>
         readBackMux <= rb_Timer_6_TimerClockPeriod;

      -- [0x0908]: /Timer_6/TimerTriggerArm
      when 16#908# =>
         readBackMux <= rb_Timer_6_TimerTriggerArm;

      -- [0x090c]: /Timer_6/TimerClockSource
      when 16#90C# =>
         readBackMux <= rb_Timer_6_TimerClockSource;

      -- [0x0910]: /Timer_6/TimerDelayValue
      when 16#910# =>
         readBackMux <= rb_Timer_6_TimerDelayValue;

      -- [0x0914]: /Timer_6/TimerDuration
      when 16#914# =>
         readBackMux <= rb_Timer_6_TimerDuration;

      -- [0x0918]: /Timer_6/TimerLatchedValue
      when 16#918# =>
         readBackMux <= rb_Timer_6_TimerLatchedValue;

      -- [0x091c]: /Timer_6/TimerStatus
      when 16#91C# =>
         readBackMux <= rb_Timer_6_TimerStatus;

      -- [0x0980]: /Timer_7/CAPABILITIES_TIMER
      when 16#980# =>
         readBackMux <= rb_Timer_7_CAPABILITIES_TIMER;

      -- [0x0984]: /Timer_7/TimerClockPeriod
      when 16#984# =>
         readBackMux <= rb_Timer_7_TimerClockPeriod;

      -- [0x0988]: /Timer_7/TimerTriggerArm
      when 16#988# =>
         readBackMux <= rb_Timer_7_TimerTriggerArm;

      -- [0x098c]: /Timer_7/TimerClockSource
      when 16#98C# =>
         readBackMux <= rb_Timer_7_TimerClockSource;

      -- [0x0990]: /Timer_7/TimerDelayValue
      when 16#990# =>
         readBackMux <= rb_Timer_7_TimerDelayValue;

      -- [0x0994]: /Timer_7/TimerDuration
      when 16#994# =>
         readBackMux <= rb_Timer_7_TimerDuration;

      -- [0x0998]: /Timer_7/TimerLatchedValue
      when 16#998# =>
         readBackMux <= rb_Timer_7_TimerLatchedValue;

      -- [0x099c]: /Timer_7/TimerStatus
      when 16#99C# =>
         readBackMux <= rb_Timer_7_TimerStatus;

      -- [0x0a00]: /Microblaze/CAPABILITIES_MICRO
      when 16#A00# =>
         readBackMux <= rb_Microblaze_CAPABILITIES_MICRO;

      -- [0x0a04]: /Microblaze/ProdCons_0
      when 16#A04# =>
         readBackMux <= rb_Microblaze_ProdCons_0;

      -- [0x0a08]: /Microblaze/ProdCons_1
      when 16#A08# =>
         readBackMux <= rb_Microblaze_ProdCons_1;

      -- [0x0a80]: /AnalogOutput/CAPABILITIES_ANA_OUT
      when 16#A80# =>
         readBackMux <= rb_AnalogOutput_CAPABILITIES_ANA_OUT;

      -- [0x0a84]: /AnalogOutput/OutputValue
      when 16#A84# =>
         readBackMux <= rb_AnalogOutput_OutputValue;

      -- [0x0b00]: /EOFM/EOFM
      when 16#B00# =>
         readBackMux <= rb_EOFM_EOFM;

      -- [0x2000:0x3ffc] ProdCons[0] external section
      when 16#2000# to 16#3FFC# =>
         readBackMux <= ext_ProdCons_readData_0_FF;

      -- [0x4000:0x5ffc] ProdCons[1] external section
      when 16#4000# to 16#5FFC# =>
         readBackMux <= ext_ProdCons_readData_1_FF;

      -- Default value
      when others =>
         readBackMux <= (others => '0');

   end case;

end process P_readBackMux_Mux;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdata
------------------------------------------------------------------------------------------
P_reg_readdata : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_readdata <= (others=>'0');
      else
         if (ldData = '1') then
            reg_readdata <= readBackMux;
         end if;
      end if;
   end if;
end process P_reg_readdata;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_INTSTAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(0) <= (hit(0)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_LATCH
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(7) <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH;
regfile.Device_specific.INTSTAT.IRQ_TICK_LATCH <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT_IRQ_TICK_LATCH
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT_IRQ_TICK_LATCH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH <= '0';
      else
         if(wEn(0) = '1' and reg_writedata(7) = '1' and bitEnN(7) = '0') then
            -- Clear the field to '0'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH <= '0';
         else
            -- Set the field to '1'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_LATCH or regfile.Device_specific.INTSTAT.IRQ_TICK_LATCH_set;
         end if;
      end if;
   end if;
end process P_Device_specific_INTSTAT_IRQ_TICK_LATCH;

------------------------------------------------------------------------------------------
-- Field name: IRQ_MICROBLAZE
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(6) <= field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE;
regfile.Device_specific.INTSTAT.IRQ_MICROBLAZE <= field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT_IRQ_MICROBLAZE
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT_IRQ_MICROBLAZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE <= '0';
      else
         if(wEn(0) = '1' and reg_writedata(6) = '1' and bitEnN(6) = '0') then
            -- Clear the field to '0'
            field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE <= '0';
         else
            -- Set the field to '1'
            field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE <= field_rw2c_Device_specific_INTSTAT_IRQ_MICROBLAZE or regfile.Device_specific.INTSTAT.IRQ_MICROBLAZE_set;
         end if;
      end if;
   end if;
end process P_Device_specific_INTSTAT_IRQ_MICROBLAZE;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_WA
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(4) <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA;
regfile.Device_specific.INTSTAT.IRQ_TICK_WA <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT_IRQ_TICK_WA
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT_IRQ_TICK_WA : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA <= '0';
      else
         if(wEn(0) = '1' and reg_writedata(4) = '1' and bitEnN(4) = '0') then
            -- Clear the field to '0'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA <= '0';
         else
            -- Set the field to '1'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK_WA or regfile.Device_specific.INTSTAT.IRQ_TICK_WA_set;
         end if;
      end if;
   end if;
end process P_Device_specific_INTSTAT_IRQ_TICK_WA;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(3) <= regfile.Device_specific.INTSTAT.IRQ_TIMER;


------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(1) <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK;
regfile.Device_specific.INTSTAT.IRQ_TICK <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT_IRQ_TICK
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT_IRQ_TICK : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT_IRQ_TICK <= '0';
      else
         if(wEn(0) = '1' and reg_writedata(1) = '1' and bitEnN(1) = '0') then
            -- Clear the field to '0'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK <= '0';
         else
            -- Set the field to '1'
            field_rw2c_Device_specific_INTSTAT_IRQ_TICK <= field_rw2c_Device_specific_INTSTAT_IRQ_TICK or regfile.Device_specific.INTSTAT.IRQ_TICK_set;
         end if;
      end if;
   end if;
end process P_Device_specific_INTSTAT_IRQ_TICK;

------------------------------------------------------------------------------------------
-- Field name: IRQ_IO
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT(0) <= field_rw2c_Device_specific_INTSTAT_IRQ_IO;
regfile.Device_specific.INTSTAT.IRQ_IO <= field_rw2c_Device_specific_INTSTAT_IRQ_IO;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT_IRQ_IO
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT_IRQ_IO : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT_IRQ_IO <= '0';
      else
         if(wEn(0) = '1' and reg_writedata(0) = '1' and bitEnN(0) = '0') then
            -- Clear the field to '0'
            field_rw2c_Device_specific_INTSTAT_IRQ_IO <= '0';
         else
            -- Set the field to '1'
            field_rw2c_Device_specific_INTSTAT_IRQ_IO <= field_rw2c_Device_specific_INTSTAT_IRQ_IO or regfile.Device_specific.INTSTAT.IRQ_IO_set;
         end if;
      end if;
   end if;
end process P_Device_specific_INTSTAT_IRQ_IO;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_INTMASKn
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(1) <= (hit(1)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_LATCH
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(7) <= '1';
regfile.Device_specific.INTMASKn.IRQ_TICK_LATCH <= rb_Device_specific_INTMASKn(7);


------------------------------------------------------------------------------------------
-- Field name: IRQ_MICROBLAZE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(6) <= field_rw_Device_specific_INTMASKn_IRQ_MICROBLAZE;
regfile.Device_specific.INTMASKn.IRQ_MICROBLAZE <= field_rw_Device_specific_INTMASKn_IRQ_MICROBLAZE;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTMASKn_IRQ_MICROBLAZE
------------------------------------------------------------------------------------------
P_Device_specific_INTMASKn_IRQ_MICROBLAZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_INTMASKn_IRQ_MICROBLAZE <= '0';
      else
         if(wEn(1) = '1' and bitEnN(6) = '0') then
            field_rw_Device_specific_INTMASKn_IRQ_MICROBLAZE <= reg_writedata(6);
         end if;
      end if;
   end if;
end process P_Device_specific_INTMASKn_IRQ_MICROBLAZE;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_WA
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(4) <= field_rw_Device_specific_INTMASKn_IRQ_TICK_WA;
regfile.Device_specific.INTMASKn.IRQ_TICK_WA <= field_rw_Device_specific_INTMASKn_IRQ_TICK_WA;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTMASKn_IRQ_TICK_WA
------------------------------------------------------------------------------------------
P_Device_specific_INTMASKn_IRQ_TICK_WA : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_INTMASKn_IRQ_TICK_WA <= '0';
      else
         if(wEn(1) = '1' and bitEnN(4) = '0') then
            field_rw_Device_specific_INTMASKn_IRQ_TICK_WA <= reg_writedata(4);
         end if;
      end if;
   end if;
end process P_Device_specific_INTMASKn_IRQ_TICK_WA;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(3) <= field_rw_Device_specific_INTMASKn_IRQ_TIMER;
regfile.Device_specific.INTMASKn.IRQ_TIMER <= field_rw_Device_specific_INTMASKn_IRQ_TIMER;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTMASKn_IRQ_TIMER
------------------------------------------------------------------------------------------
P_Device_specific_INTMASKn_IRQ_TIMER : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_INTMASKn_IRQ_TIMER <= '0';
      else
         if(wEn(1) = '1' and bitEnN(3) = '0') then
            field_rw_Device_specific_INTMASKn_IRQ_TIMER <= reg_writedata(3);
         end if;
      end if;
   end if;
end process P_Device_specific_INTMASKn_IRQ_TIMER;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(1) <= field_rw_Device_specific_INTMASKn_IRQ_TICK;
regfile.Device_specific.INTMASKn.IRQ_TICK <= field_rw_Device_specific_INTMASKn_IRQ_TICK;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTMASKn_IRQ_TICK
------------------------------------------------------------------------------------------
P_Device_specific_INTMASKn_IRQ_TICK : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_INTMASKn_IRQ_TICK <= '0';
      else
         if(wEn(1) = '1' and bitEnN(1) = '0') then
            field_rw_Device_specific_INTMASKn_IRQ_TICK <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Device_specific_INTMASKn_IRQ_TICK;

------------------------------------------------------------------------------------------
-- Field name: IRQ_IO
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_INTMASKn(0) <= field_rw_Device_specific_INTMASKn_IRQ_IO;
regfile.Device_specific.INTMASKn.IRQ_IO <= field_rw_Device_specific_INTMASKn_IRQ_IO;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTMASKn_IRQ_IO
------------------------------------------------------------------------------------------
P_Device_specific_INTMASKn_IRQ_IO : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_INTMASKn_IRQ_IO <= '0';
      else
         if(wEn(1) = '1' and bitEnN(0) = '0') then
            field_rw_Device_specific_INTMASKn_IRQ_IO <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Device_specific_INTMASKn_IRQ_IO;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_INTSTAT2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(2) <= (hit(2)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER_END(7 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT2(23 downto 16) <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END(7 downto 0);
regfile.Device_specific.INTSTAT2.IRQ_TIMER_END <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT2_IRQ_TIMER_END
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT2_IRQ_TIMER_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  23 downto 16  loop
            if(wEn(2) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
               -- Clear every field bit to '0'
               field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END(j-16) <= '0';
            else
               -- Set every field bit to '1'
               field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END(j-16) <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_END(j-16) or regfile.Device_specific.INTSTAT2.IRQ_TIMER_END_set(j-16);
            end if;
         end loop;
      end if;
   end if;
end process P_Device_specific_INTSTAT2_IRQ_TIMER_END;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER_START(7 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_Device_specific_INTSTAT2(7 downto 0) <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START(7 downto 0);
regfile.Device_specific.INTSTAT2.IRQ_TIMER_START <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_INTSTAT2_IRQ_TIMER_START
------------------------------------------------------------------------------------------
P_Device_specific_INTSTAT2_IRQ_TIMER_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(2) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
               -- Clear every field bit to '0'
               field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START(j-0) <= '0';
            else
               -- Set every field bit to '1'
               field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START(j-0) <= field_rw2c_Device_specific_INTSTAT2_IRQ_TIMER_START(j-0) or regfile.Device_specific.INTSTAT2.IRQ_TIMER_START_set(j-0);
            end if;
         end loop;
      end if;
   end if;
end process P_Device_specific_INTSTAT2_IRQ_TIMER_START;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_BUILDID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(3) <= (hit(3)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: VALUE(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Device_specific_BUILDID(31 downto 0) <= regfile.Device_specific.BUILDID.VALUE;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_FPGA_ID
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(4) <= (hit(4)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: FPGA_STRAPS(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(31 downto 28) <= regfile.Device_specific.FPGA_ID.FPGA_STRAPS;


------------------------------------------------------------------------------------------
-- Field name: USER_RED_LED
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(14) <= field_rw_Device_specific_FPGA_ID_USER_RED_LED;
regfile.Device_specific.FPGA_ID.USER_RED_LED <= field_rw_Device_specific_FPGA_ID_USER_RED_LED;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_FPGA_ID_USER_RED_LED
------------------------------------------------------------------------------------------
P_Device_specific_FPGA_ID_USER_RED_LED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_FPGA_ID_USER_RED_LED <= '0';
      else
         if(wEn(4) = '1' and bitEnN(14) = '0') then
            field_rw_Device_specific_FPGA_ID_USER_RED_LED <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Device_specific_FPGA_ID_USER_RED_LED;

------------------------------------------------------------------------------------------
-- Field name: USER_GREEN_LED
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(13) <= field_rw_Device_specific_FPGA_ID_USER_GREEN_LED;
regfile.Device_specific.FPGA_ID.USER_GREEN_LED <= field_rw_Device_specific_FPGA_ID_USER_GREEN_LED;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_FPGA_ID_USER_GREEN_LED
------------------------------------------------------------------------------------------
P_Device_specific_FPGA_ID_USER_GREEN_LED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_FPGA_ID_USER_GREEN_LED <= '0';
      else
         if(wEn(4) = '1' and bitEnN(13) = '0') then
            field_rw_Device_specific_FPGA_ID_USER_GREEN_LED <= reg_writedata(13);
         end if;
      end if;
   end if;
end process P_Device_specific_FPGA_ID_USER_GREEN_LED;

------------------------------------------------------------------------------------------
-- Field name: PROFINET_LED
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(12) <= field_rw_Device_specific_FPGA_ID_PROFINET_LED;
regfile.Device_specific.FPGA_ID.PROFINET_LED <= field_rw_Device_specific_FPGA_ID_PROFINET_LED;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_FPGA_ID_PROFINET_LED
------------------------------------------------------------------------------------------
P_Device_specific_FPGA_ID_PROFINET_LED : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_FPGA_ID_PROFINET_LED <= '0';
      else
         if(wEn(4) = '1' and bitEnN(12) = '0') then
            field_rw_Device_specific_FPGA_ID_PROFINET_LED <= reg_writedata(12);
         end if;
      end if;
   end if;
end process P_Device_specific_FPGA_ID_PROFINET_LED;

------------------------------------------------------------------------------------------
-- Field name: PB_DEBUG_COM
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(10) <= field_rw_Device_specific_FPGA_ID_PB_DEBUG_COM;
regfile.Device_specific.FPGA_ID.PB_DEBUG_COM <= field_rw_Device_specific_FPGA_ID_PB_DEBUG_COM;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_FPGA_ID_PB_DEBUG_COM
------------------------------------------------------------------------------------------
P_Device_specific_FPGA_ID_PB_DEBUG_COM : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_FPGA_ID_PB_DEBUG_COM <= '0';
      else
         if(wEn(4) = '1' and bitEnN(10) = '0') then
            field_rw_Device_specific_FPGA_ID_PB_DEBUG_COM <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Device_specific_FPGA_ID_PB_DEBUG_COM;

------------------------------------------------------------------------------------------
-- Field name: FPGA_ID(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Device_specific_FPGA_ID(4 downto 0) <= regfile.Device_specific.FPGA_ID.FPGA_ID;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Device_specific_LED_OVERRIDE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(5) <= (hit(5)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: RED_ORANGE_FLASH
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_LED_OVERRIDE(25) <= field_rw_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH;
regfile.Device_specific.LED_OVERRIDE.RED_ORANGE_FLASH <= field_rw_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH
------------------------------------------------------------------------------------------
P_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH <= '0';
      else
         if(wEn(5) = '1' and bitEnN(25) = '0') then
            field_rw_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH <= reg_writedata(25);
         end if;
      end if;
   end if;
end process P_Device_specific_LED_OVERRIDE_RED_ORANGE_FLASH;

------------------------------------------------------------------------------------------
-- Field name: ORANGE_OFF_FLASH
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Device_specific_LED_OVERRIDE(24) <= field_rw_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH;
regfile.Device_specific.LED_OVERRIDE.ORANGE_OFF_FLASH <= field_rw_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH;


------------------------------------------------------------------------------------------
-- Process: P_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH
------------------------------------------------------------------------------------------
P_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH <= '0';
      else
         if(wEn(5) = '1' and bitEnN(24) = '0') then
            field_rw_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Device_specific_LED_OVERRIDE_ORANGE_OFF_FLASH;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: INTERRUPT_QUEUE_CONTROL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(6) <= (hit(6)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: NB_DW
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_INTERRUPT_QUEUE_CONTROL(31 downto 24) <= std_logic_vector(to_unsigned(integer(1),8));
regfile.INTERRUPT_QUEUE.CONTROL.NB_DW <= rb_INTERRUPT_QUEUE_CONTROL(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
rb_INTERRUPT_QUEUE_CONTROL(0) <= field_rw_INTERRUPT_QUEUE_CONTROL_ENABLE;
regfile.INTERRUPT_QUEUE.CONTROL.ENABLE <= field_rw_INTERRUPT_QUEUE_CONTROL_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_CONTROL_ENABLE
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_CONTROL_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_INTERRUPT_QUEUE_CONTROL_ENABLE <= '0';
      else
         if(wEn(6) = '1' and bitEnN(0) = '0') then
            field_rw_INTERRUPT_QUEUE_CONTROL_ENABLE <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_CONTROL_ENABLE;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: INTERRUPT_QUEUE_CONS_IDX
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(7) <= (hit(7)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CONS_IDX(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_INTERRUPT_QUEUE_CONS_IDX(9 downto 0) <= field_rw_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX(9 downto 0);
regfile.INTERRUPT_QUEUE.CONS_IDX.CONS_IDX <= field_rw_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX <= std_logic_vector(to_unsigned(integer(0),10));
      else
         for j in  9 downto 0  loop
            if(wEn(7) = '1' and bitEnN(j) = '0') then
               field_rw_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_CONS_IDX_CONS_IDX;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: INTERRUPT_QUEUE_ADDR_LOW
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(8) <= (hit(8)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ADDR(31 downto 0)
-- Field type: ADDR(31 downto 13) = RW, ADDR(12 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_INTERRUPT_QUEUE_ADDR_LOW(31 downto 0) <= field_rw_INTERRUPT_QUEUE_ADDR_LOW_ADDR(18 downto 0) & std_logic_vector(to_unsigned(integer(0),13));
regfile.INTERRUPT_QUEUE.ADDR_LOW.ADDR <= field_rw_INTERRUPT_QUEUE_ADDR_LOW_ADDR(18 downto 0) & std_logic_vector(to_unsigned(integer(0),13));


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_ADDR_LOW_ADDR
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_ADDR_LOW_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_INTERRUPT_QUEUE_ADDR_LOW_ADDR <= std_logic_vector(to_unsigned(integer(0),19));
      else
         for j in  31 downto 13  loop
            if(wEn(8) = '1' and bitEnN(j) = '0') then
               field_rw_INTERRUPT_QUEUE_ADDR_LOW_ADDR(j-13) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_ADDR_LOW_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: INTERRUPT_QUEUE_ADDR_HIGH
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(9) <= (hit(9)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ADDR(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_INTERRUPT_QUEUE_ADDR_HIGH(31 downto 0) <= field_rw_INTERRUPT_QUEUE_ADDR_HIGH_ADDR(31 downto 0);
regfile.INTERRUPT_QUEUE.ADDR_HIGH.ADDR <= field_rw_INTERRUPT_QUEUE_ADDR_HIGH_ADDR(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_ADDR_HIGH_ADDR
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_ADDR_HIGH_ADDR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_INTERRUPT_QUEUE_ADDR_HIGH_ADDR <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(9) = '1' and bitEnN(j) = '0') then
               field_rw_INTERRUPT_QUEUE_ADDR_HIGH_ADDR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_ADDR_HIGH_ADDR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: INTERRUPT_QUEUE_MAPPING
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(10) <= (hit(10)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER_END(7 downto 0)
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TIMER_END <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  31 downto 24  loop
            if(wEn(10) = '1' and bitEnN(j) = '0') then
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END(j-24) <= reg_writedata(j);
            else
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END(j-24) <= '0';
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_END;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER_START(7 downto 0)
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TIMER_START <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  23 downto 16  loop
            if(wEn(10) = '1' and bitEnN(j) = '0') then
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START(j-16) <= reg_writedata(j);
            else
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START(j-16) <= '0';
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER_START;

------------------------------------------------------------------------------------------
-- Field name: IO_INTSTAT(3 downto 0)
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IO_INTSTAT <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(10) = '1' and bitEnN(j) = '0') then
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT(j-8) <= reg_writedata(j);
            else
               field_wautoclr_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT(j-8) <= '0';
            end if;
         end loop;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IO_INTSTAT;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_LATCH
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TICK_LATCH <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH <= '0';
      else
         if(wEn(10) = '1' and bitEnN(5) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH <= reg_writedata(5);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_LATCH;

------------------------------------------------------------------------------------------
-- Field name: IRQ_MICROBLAZE
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_MICROBLAZE <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE <= '0';
      else
         if(wEn(10) = '1' and bitEnN(4) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE <= reg_writedata(4);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_MICROBLAZE;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TIMER
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TIMER <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER <= '0';
      else
         if(wEn(10) = '1' and bitEnN(3) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER <= reg_writedata(3);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TIMER;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK_WA
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TICK_WA <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA <= '0';
      else
         if(wEn(10) = '1' and bitEnN(2) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA <= reg_writedata(2);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK_WA;

------------------------------------------------------------------------------------------
-- Field name: IRQ_TICK
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_TICK <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK <= '0';
      else
         if(wEn(10) = '1' and bitEnN(1) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK <= reg_writedata(1);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_TICK <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_TICK;

------------------------------------------------------------------------------------------
-- Field name: IRQ_IO
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.INTERRUPT_QUEUE.MAPPING.IRQ_IO <= field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_IO;


------------------------------------------------------------------------------------------
-- Process: P_INTERRUPT_QUEUE_MAPPING_IRQ_IO
------------------------------------------------------------------------------------------
P_INTERRUPT_QUEUE_MAPPING_IRQ_IO : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_IO <= '0';
      else
         if(wEn(10) = '1' and bitEnN(0) = '0') then
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_IO <= reg_writedata(0);
         else
            field_wautoclr_INTERRUPT_QUEUE_MAPPING_IRQ_IO <= '0';
         end if;
      end if;
   end if;
end process P_INTERRUPT_QUEUE_MAPPING_IRQ_IO;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: tlp_timeout
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(11) <= (hit(11)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_tlp_timeout(31 downto 0) <= field_rw_tlp_timeout_value(31 downto 0);
regfile.tlp.timeout.value <= field_rw_tlp_timeout_value(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_tlp_timeout_value
------------------------------------------------------------------------------------------
P_tlp_timeout_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_tlp_timeout_value <= X"01DCD650";
      else
         for j in  31 downto 0  loop
            if(wEn(11) = '1' and bitEnN(j) = '0') then
               field_rw_tlp_timeout_value(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_tlp_timeout_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: tlp_transaction_abort_cntr
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(12) <= (hit(12)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: clr
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_tlp_transaction_abort_cntr(31) <= '0';
regfile.tlp.transaction_abort_cntr.clr <= field_wautoclr_tlp_transaction_abort_cntr_clr;


------------------------------------------------------------------------------------------
-- Process: P_tlp_transaction_abort_cntr_clr
------------------------------------------------------------------------------------------
P_tlp_transaction_abort_cntr_clr : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_tlp_transaction_abort_cntr_clr <= '0';
      else
         if(wEn(12) = '1' and bitEnN(31) = '0') then
            field_wautoclr_tlp_transaction_abort_cntr_clr <= reg_writedata(31);
         else
            field_wautoclr_tlp_transaction_abort_cntr_clr <= '0';
         end if;
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
-- Register name: SPI_SPIREGIN
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(13) <= (hit(13)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SPI_ENABLE
-- Field type: RW
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPI_ENABLE <= field_rw_SPI_SPIREGIN_SPI_ENABLE;


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPI_ENABLE
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPI_ENABLE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SPI_SPIREGIN_SPI_ENABLE <= '0';
      else
         if(wEn(13) = '1' and bitEnN(24) = '0') then
            field_rw_SPI_SPIREGIN_SPI_ENABLE <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPI_ENABLE;

------------------------------------------------------------------------------------------
-- Field name: SPIRW
-- Field type: RW
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPIRW <= field_rw_SPI_SPIREGIN_SPIRW;


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPIRW
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPIRW : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SPI_SPIREGIN_SPIRW <= '0';
      else
         if(wEn(13) = '1' and bitEnN(22) = '0') then
            field_rw_SPI_SPIREGIN_SPIRW <= reg_writedata(22);
         end if;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPIRW;

------------------------------------------------------------------------------------------
-- Field name: SPICMDDONE
-- Field type: RW
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPICMDDONE <= field_rw_SPI_SPIREGIN_SPICMDDONE;


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPICMDDONE
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPICMDDONE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SPI_SPIREGIN_SPICMDDONE <= '0';
      else
         if(wEn(13) = '1' and bitEnN(21) = '0') then
            field_rw_SPI_SPIREGIN_SPICMDDONE <= reg_writedata(21);
         end if;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPICMDDONE;

------------------------------------------------------------------------------------------
-- Field name: SPISEL
-- Field type: RW
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPISEL <= field_rw_SPI_SPIREGIN_SPISEL;


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPISEL
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPISEL : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SPI_SPIREGIN_SPISEL <= '0';
      else
         if(wEn(13) = '1' and bitEnN(18) = '0') then
            field_rw_SPI_SPIREGIN_SPISEL <= reg_writedata(18);
         end if;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPISEL;

------------------------------------------------------------------------------------------
-- Field name: SPITXST
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPITXST <= field_wautoclr_SPI_SPIREGIN_SPITXST;


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPITXST
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPITXST : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_SPI_SPIREGIN_SPITXST <= '0';
      else
         if(wEn(13) = '1' and bitEnN(16) = '0') then
            field_wautoclr_SPI_SPIREGIN_SPITXST <= reg_writedata(16);
         else
            field_wautoclr_SPI_SPIREGIN_SPITXST <= '0';
         end if;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPITXST;

------------------------------------------------------------------------------------------
-- Field name: SPIDATAW(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
-- Read back on this register is disable
regfile.SPI.SPIREGIN.SPIDATAW <= field_rw_SPI_SPIREGIN_SPIDATAW(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_SPI_SPIREGIN_SPIDATAW
------------------------------------------------------------------------------------------
P_SPI_SPIREGIN_SPIDATAW : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_SPI_SPIREGIN_SPIDATAW <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(13) = '1' and bitEnN(j) = '0') then
               field_rw_SPI_SPIREGIN_SPIDATAW(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_SPI_SPIREGIN_SPIDATAW;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: SPI_SPIREGOUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(14) <= (hit(14)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: SPI_WB_CAP
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SPI_SPIREGOUT(17) <= '0';
regfile.SPI.SPIREGOUT.SPI_WB_CAP <= rb_SPI_SPIREGOUT(17);


------------------------------------------------------------------------------------------
-- Field name: SPIWRTD
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SPI_SPIREGOUT(16) <= '0';
regfile.SPI.SPIREGOUT.SPIWRTD <= rb_SPI_SPIREGOUT(16);


------------------------------------------------------------------------------------------
-- Field name: SPIDATARD
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_SPI_SPIREGOUT(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.SPI.SPIREGOUT.SPIDATARD <= rb_SPI_SPIREGOUT(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: arbiter_ARBITER_CAPABILITIES
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(15) <= (hit(15)) and (reg_write);

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
wEn(16) <= (hit(16)) and (reg_write);

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
P_arbiter_AGENT_0_DONE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_arbiter_AGENT_0_DONE <= '0';
      else
         if(wEn(16) = '1' and bitEnN(4) = '0') then
            field_wautoclr_arbiter_AGENT_0_DONE <= reg_writedata(4);
         else
            field_wautoclr_arbiter_AGENT_0_DONE <= '0';
         end if;
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
P_arbiter_AGENT_0_REQ : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_arbiter_AGENT_0_REQ <= '0';
      else
         if(wEn(16) = '1' and bitEnN(0) = '0') then
            field_wautoclr_arbiter_AGENT_0_REQ <= reg_writedata(0);
         else
            field_wautoclr_arbiter_AGENT_0_REQ <= '0';
         end if;
      end if;
   end if;
end process P_arbiter_AGENT_0_REQ;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: arbiter_AGENT_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(17) <= (hit(17)) and (reg_write);

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
P_arbiter_AGENT_1_DONE : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_arbiter_AGENT_1_DONE <= '0';
      else
         if(wEn(17) = '1' and bitEnN(4) = '0') then
            field_wautoclr_arbiter_AGENT_1_DONE <= reg_writedata(4);
         else
            field_wautoclr_arbiter_AGENT_1_DONE <= '0';
         end if;
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
P_arbiter_AGENT_1_REQ : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_arbiter_AGENT_1_REQ <= '0';
      else
         if(wEn(17) = '1' and bitEnN(0) = '0') then
            field_wautoclr_arbiter_AGENT_1_REQ <= reg_writedata(0);
         else
            field_wautoclr_arbiter_AGENT_1_REQ <= '0';
         end if;
      end if;
   end if;
end process P_arbiter_AGENT_1_REQ;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(18) <= (hit(18)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_0_ctrl(0) <= field_rw_axi_window_0_ctrl_enable;
regfile.axi_window(0).ctrl.enable <= field_rw_axi_window_0_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_0_ctrl_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_0_ctrl_enable <= '0';
      else
         if(wEn(18) = '1' and bitEnN(0) = '0') then
            field_rw_axi_window_0_ctrl_enable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_axi_window_0_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(19) <= (hit(19)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_pci_bar0_start(25 downto 0) <= field_rw_axi_window_0_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).pci_bar0_start.value <= field_rw_axi_window_0_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_0_pci_bar0_start_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_0_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(19) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_0_pci_bar0_start_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_0_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(20) <= (hit(20)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_0_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).pci_bar0_stop.value <= field_rw_axi_window_0_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_0_pci_bar0_stop_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_0_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(20) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_0_pci_bar0_stop_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_0_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_0_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(21) <= (hit(21)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_0_axi_translation(31 downto 0) <= field_rw_axi_window_0_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(0).axi_translation.value <= field_rw_axi_window_0_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_0_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_0_axi_translation_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_0_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
      else
         for j in  31 downto 2  loop
            if(wEn(21) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_0_axi_translation_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_0_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(22) <= (hit(22)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_1_ctrl(0) <= field_rw_axi_window_1_ctrl_enable;
regfile.axi_window(1).ctrl.enable <= field_rw_axi_window_1_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_1_ctrl_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_1_ctrl_enable <= '0';
      else
         if(wEn(22) = '1' and bitEnN(0) = '0') then
            field_rw_axi_window_1_ctrl_enable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_axi_window_1_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(23) <= (hit(23)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_pci_bar0_start(25 downto 0) <= field_rw_axi_window_1_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).pci_bar0_start.value <= field_rw_axi_window_1_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_1_pci_bar0_start_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_1_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(23) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_1_pci_bar0_start_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_1_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(24) <= (hit(24)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_1_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).pci_bar0_stop.value <= field_rw_axi_window_1_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_1_pci_bar0_stop_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_1_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(24) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_1_pci_bar0_stop_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_1_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_1_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(25) <= (hit(25)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_1_axi_translation(31 downto 0) <= field_rw_axi_window_1_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(1).axi_translation.value <= field_rw_axi_window_1_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_1_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_1_axi_translation_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_1_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
      else
         for j in  31 downto 2  loop
            if(wEn(25) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_1_axi_translation_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_1_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(26) <= (hit(26)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_2_ctrl(0) <= field_rw_axi_window_2_ctrl_enable;
regfile.axi_window(2).ctrl.enable <= field_rw_axi_window_2_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_2_ctrl_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_2_ctrl_enable <= '0';
      else
         if(wEn(26) = '1' and bitEnN(0) = '0') then
            field_rw_axi_window_2_ctrl_enable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_axi_window_2_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(27) <= (hit(27)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_pci_bar0_start(25 downto 0) <= field_rw_axi_window_2_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).pci_bar0_start.value <= field_rw_axi_window_2_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_2_pci_bar0_start_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_2_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(27) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_2_pci_bar0_start_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_2_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(28) <= (hit(28)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_2_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).pci_bar0_stop.value <= field_rw_axi_window_2_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_2_pci_bar0_stop_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_2_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(28) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_2_pci_bar0_stop_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_2_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_2_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(29) <= (hit(29)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_2_axi_translation(31 downto 0) <= field_rw_axi_window_2_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(2).axi_translation.value <= field_rw_axi_window_2_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_2_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_2_axi_translation_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_2_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
      else
         for j in  31 downto 2  loop
            if(wEn(29) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_2_axi_translation_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_2_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_ctrl
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(30) <= (hit(30)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: enable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_axi_window_3_ctrl(0) <= field_rw_axi_window_3_ctrl_enable;
regfile.axi_window(3).ctrl.enable <= field_rw_axi_window_3_ctrl_enable;


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_ctrl_enable
------------------------------------------------------------------------------------------
P_axi_window_3_ctrl_enable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_3_ctrl_enable <= '0';
      else
         if(wEn(30) = '1' and bitEnN(0) = '0') then
            field_rw_axi_window_3_ctrl_enable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_axi_window_3_ctrl_enable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_pci_bar0_start
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(31) <= (hit(31)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_pci_bar0_start(25 downto 0) <= field_rw_axi_window_3_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).pci_bar0_start.value <= field_rw_axi_window_3_pci_bar0_start_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_pci_bar0_start_value
------------------------------------------------------------------------------------------
P_axi_window_3_pci_bar0_start_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_3_pci_bar0_start_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(31) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_3_pci_bar0_start_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_3_pci_bar0_start_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_pci_bar0_stop
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(32) <= (hit(32)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(25 downto 0)
-- Field type: value(25 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_pci_bar0_stop(25 downto 0) <= field_rw_axi_window_3_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).pci_bar0_stop.value <= field_rw_axi_window_3_pci_bar0_stop_value(23 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_pci_bar0_stop_value
------------------------------------------------------------------------------------------
P_axi_window_3_pci_bar0_stop_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_3_pci_bar0_stop_value <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  25 downto 2  loop
            if(wEn(32) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_3_pci_bar0_stop_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_3_pci_bar0_stop_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: axi_window_3_axi_translation
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(33) <= (hit(33)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: value(31 downto 0)
-- Field type: value(31 downto 2) = RW, value(1 downto 0) = RO;
------------------------------------------------------------------------------------------
rb_axi_window_3_axi_translation(31 downto 0) <= field_rw_axi_window_3_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));
regfile.axi_window(3).axi_translation.value <= field_rw_axi_window_3_axi_translation_value(29 downto 0) & std_logic_vector(to_unsigned(integer(0),2));


------------------------------------------------------------------------------------------
-- Process: P_axi_window_3_axi_translation_value
------------------------------------------------------------------------------------------
P_axi_window_3_axi_translation_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_axi_window_3_axi_translation_value <= std_logic_vector(to_unsigned(integer(0),30));
      else
         for j in  31 downto 2  loop
            if(wEn(33) = '1' and bitEnN(j) = '0') then
               field_rw_axi_window_3_axi_translation_value(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_axi_window_3_axi_translation_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_CAPABILITIES_IO
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(34) <= (hit(34)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IO_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_IO_0_CAPABILITIES_IO(31 downto 24) <= std_logic_vector(to_unsigned(integer(16),8));
regfile.IO(0).CAPABILITIES_IO.IO_ID <= rb_IO_0_CAPABILITIES_IO(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: N_port(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_0_CAPABILITIES_IO(23 downto 19) <= regfile.IO(0).CAPABILITIES_IO.N_port;


------------------------------------------------------------------------------------------
-- Field name: Input
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_0_CAPABILITIES_IO(18) <= regfile.IO(0).CAPABILITIES_IO.Input;


------------------------------------------------------------------------------------------
-- Field name: Output
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_0_CAPABILITIES_IO(17) <= regfile.IO(0).CAPABILITIES_IO.Output;


------------------------------------------------------------------------------------------
-- Field name: Intnum(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_0_CAPABILITIES_IO(16 downto 12) <= regfile.IO(0).CAPABILITIES_IO.Intnum;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_PIN
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(35) <= (hit(35)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Pin_value(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_0_IO_PIN(3 downto 0) <= regfile.IO(0).IO_PIN.Pin_value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_OUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(36) <= (hit(36)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Out_value(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_0_IO_OUT(3 downto 0) <= field_rw_IO_0_IO_OUT_Out_value(3 downto 0);
regfile.IO(0).IO_OUT.Out_value <= field_rw_IO_0_IO_OUT_Out_value(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_OUT_Out_value
------------------------------------------------------------------------------------------
P_IO_0_IO_OUT_Out_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_0_IO_OUT_Out_value <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(36) = '1' and bitEnN(j) = '0') then
               field_rw_IO_0_IO_OUT_Out_value(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_OUT_Out_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_DIR
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(37) <= (hit(37)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Dir(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_0_IO_DIR(3 downto 0) <= field_rw_IO_0_IO_DIR_Dir(3 downto 0);
regfile.IO(0).IO_DIR.Dir <= field_rw_IO_0_IO_DIR_Dir(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_DIR_Dir
------------------------------------------------------------------------------------------
P_IO_0_IO_DIR_Dir : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_0_IO_DIR_Dir <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(37) = '1' and bitEnN(j) = '0') then
               field_rw_IO_0_IO_DIR_Dir(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_DIR_Dir;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_POL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(38) <= (hit(38)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: In_pol(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_0_IO_POL(3 downto 0) <= field_rw_IO_0_IO_POL_In_pol(3 downto 0);
regfile.IO(0).IO_POL.In_pol <= field_rw_IO_0_IO_POL_In_pol(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_POL_In_pol
------------------------------------------------------------------------------------------
P_IO_0_IO_POL_In_pol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_0_IO_POL_In_pol <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(38) = '1' and bitEnN(j) = '0') then
               field_rw_IO_0_IO_POL_In_pol(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_POL_In_pol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_INTSTAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(39) <= (hit(39)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Intstat(3 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_IO_0_IO_INTSTAT(3 downto 0) <= field_rw2c_IO_0_IO_INTSTAT_Intstat(3 downto 0);
regfile.IO(0).IO_INTSTAT.Intstat <= field_rw2c_IO_0_IO_INTSTAT_Intstat(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_INTSTAT_Intstat
------------------------------------------------------------------------------------------
P_IO_0_IO_INTSTAT_Intstat : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_IO_0_IO_INTSTAT_Intstat <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(39) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
               -- Clear every field bit to '0'
               field_rw2c_IO_0_IO_INTSTAT_Intstat(j-0) <= '0';
            else
               -- Set every field bit to '1'
               field_rw2c_IO_0_IO_INTSTAT_Intstat(j-0) <= field_rw2c_IO_0_IO_INTSTAT_Intstat(j-0) or regfile.IO(0).IO_INTSTAT.Intstat_set(j-0);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_INTSTAT_Intstat;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_INTMASKn
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(40) <= (hit(40)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Intmaskn(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_0_IO_INTMASKn(3 downto 0) <= field_rw_IO_0_IO_INTMASKn_Intmaskn(3 downto 0);
regfile.IO(0).IO_INTMASKn.Intmaskn <= field_rw_IO_0_IO_INTMASKn_Intmaskn(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_INTMASKn_Intmaskn
------------------------------------------------------------------------------------------
P_IO_0_IO_INTMASKn_Intmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_0_IO_INTMASKn_Intmaskn <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(40) = '1' and bitEnN(j) = '0') then
               field_rw_IO_0_IO_INTMASKn_Intmaskn(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_INTMASKn_Intmaskn;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_0_IO_ANYEDGE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(41) <= (hit(41)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: In_AnyEdge(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_0_IO_ANYEDGE(3 downto 0) <= field_rw_IO_0_IO_ANYEDGE_In_AnyEdge(3 downto 0);
regfile.IO(0).IO_ANYEDGE.In_AnyEdge <= field_rw_IO_0_IO_ANYEDGE_In_AnyEdge(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_0_IO_ANYEDGE_In_AnyEdge
------------------------------------------------------------------------------------------
P_IO_0_IO_ANYEDGE_In_AnyEdge : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_0_IO_ANYEDGE_In_AnyEdge <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(41) = '1' and bitEnN(j) = '0') then
               field_rw_IO_0_IO_ANYEDGE_In_AnyEdge(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_0_IO_ANYEDGE_In_AnyEdge;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_CAPABILITIES_IO
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(42) <= (hit(42)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IO_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_IO_1_CAPABILITIES_IO(31 downto 24) <= std_logic_vector(to_unsigned(integer(16),8));
regfile.IO(1).CAPABILITIES_IO.IO_ID <= rb_IO_1_CAPABILITIES_IO(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: N_port(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_1_CAPABILITIES_IO(23 downto 19) <= regfile.IO(1).CAPABILITIES_IO.N_port;


------------------------------------------------------------------------------------------
-- Field name: Input
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_1_CAPABILITIES_IO(18) <= regfile.IO(1).CAPABILITIES_IO.Input;


------------------------------------------------------------------------------------------
-- Field name: Output
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_1_CAPABILITIES_IO(17) <= regfile.IO(1).CAPABILITIES_IO.Output;


------------------------------------------------------------------------------------------
-- Field name: Intnum(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_1_CAPABILITIES_IO(16 downto 12) <= regfile.IO(1).CAPABILITIES_IO.Intnum;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_PIN
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(43) <= (hit(43)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Pin_value(3 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_IO_1_IO_PIN(3 downto 0) <= regfile.IO(1).IO_PIN.Pin_value;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_OUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(44) <= (hit(44)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Out_value(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_1_IO_OUT(3 downto 0) <= field_rw_IO_1_IO_OUT_Out_value(3 downto 0);
regfile.IO(1).IO_OUT.Out_value <= field_rw_IO_1_IO_OUT_Out_value(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_OUT_Out_value
------------------------------------------------------------------------------------------
P_IO_1_IO_OUT_Out_value : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_1_IO_OUT_Out_value <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(44) = '1' and bitEnN(j) = '0') then
               field_rw_IO_1_IO_OUT_Out_value(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_OUT_Out_value;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_DIR
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(45) <= (hit(45)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Dir(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_1_IO_DIR(3 downto 0) <= field_rw_IO_1_IO_DIR_Dir(3 downto 0);
regfile.IO(1).IO_DIR.Dir <= field_rw_IO_1_IO_DIR_Dir(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_DIR_Dir
------------------------------------------------------------------------------------------
P_IO_1_IO_DIR_Dir : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_1_IO_DIR_Dir <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(45) = '1' and bitEnN(j) = '0') then
               field_rw_IO_1_IO_DIR_Dir(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_DIR_Dir;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_POL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(46) <= (hit(46)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: In_pol(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_1_IO_POL(3 downto 0) <= field_rw_IO_1_IO_POL_In_pol(3 downto 0);
regfile.IO(1).IO_POL.In_pol <= field_rw_IO_1_IO_POL_In_pol(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_POL_In_pol
------------------------------------------------------------------------------------------
P_IO_1_IO_POL_In_pol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_1_IO_POL_In_pol <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(46) = '1' and bitEnN(j) = '0') then
               field_rw_IO_1_IO_POL_In_pol(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_POL_In_pol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_INTSTAT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(47) <= (hit(47)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Intstat(3 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_IO_1_IO_INTSTAT(3 downto 0) <= field_rw2c_IO_1_IO_INTSTAT_Intstat(3 downto 0);
regfile.IO(1).IO_INTSTAT.Intstat <= field_rw2c_IO_1_IO_INTSTAT_Intstat(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_INTSTAT_Intstat
------------------------------------------------------------------------------------------
P_IO_1_IO_INTSTAT_Intstat : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_IO_1_IO_INTSTAT_Intstat <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(47) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
               -- Clear every field bit to '0'
               field_rw2c_IO_1_IO_INTSTAT_Intstat(j-0) <= '0';
            else
               -- Set every field bit to '1'
               field_rw2c_IO_1_IO_INTSTAT_Intstat(j-0) <= field_rw2c_IO_1_IO_INTSTAT_Intstat(j-0) or regfile.IO(1).IO_INTSTAT.Intstat_set(j-0);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_INTSTAT_Intstat;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_INTMASKn
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(48) <= (hit(48)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Intmaskn(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_1_IO_INTMASKn(3 downto 0) <= field_rw_IO_1_IO_INTMASKn_Intmaskn(3 downto 0);
regfile.IO(1).IO_INTMASKn.Intmaskn <= field_rw_IO_1_IO_INTMASKn_Intmaskn(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_INTMASKn_Intmaskn
------------------------------------------------------------------------------------------
P_IO_1_IO_INTMASKn_Intmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_1_IO_INTMASKn_Intmaskn <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(48) = '1' and bitEnN(j) = '0') then
               field_rw_IO_1_IO_INTMASKn_Intmaskn(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_INTMASKn_Intmaskn;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: IO_1_IO_ANYEDGE
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(49) <= (hit(49)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: In_AnyEdge(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_IO_1_IO_ANYEDGE(3 downto 0) <= field_rw_IO_1_IO_ANYEDGE_In_AnyEdge(3 downto 0);
regfile.IO(1).IO_ANYEDGE.In_AnyEdge <= field_rw_IO_1_IO_ANYEDGE_In_AnyEdge(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_IO_1_IO_ANYEDGE_In_AnyEdge
------------------------------------------------------------------------------------------
P_IO_1_IO_ANYEDGE_In_AnyEdge : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_IO_1_IO_ANYEDGE_In_AnyEdge <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(49) = '1' and bitEnN(j) = '0') then
               field_rw_IO_1_IO_ANYEDGE_In_AnyEdge(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_IO_1_IO_ANYEDGE_In_AnyEdge;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_CAPABILITIES_QUAD
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(50) <= (hit(50)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: QUADRATURE_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Quadrature_0_CAPABILITIES_QUAD(31 downto 24) <= std_logic_vector(to_unsigned(integer(100),8));
regfile.Quadrature(0).CAPABILITIES_QUAD.QUADRATURE_ID <= rb_Quadrature_0_CAPABILITIES_QUAD(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Quadrature_0_CAPABILITIES_QUAD(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Quadrature(0).CAPABILITIES_QUAD.FEATURE_REV <= rb_Quadrature_0_CAPABILITIES_QUAD(23 downto 20);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_PositionReset
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(51) <= (hit(51)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: PositionResetSource(5 downto 2)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_PositionReset(5 downto 2) <= field_rw_Quadrature_0_PositionReset_PositionResetSource(3 downto 0);
regfile.Quadrature(0).PositionReset.PositionResetSource <= field_rw_Quadrature_0_PositionReset_PositionResetSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_PositionReset_PositionResetSource
------------------------------------------------------------------------------------------
P_Quadrature_0_PositionReset_PositionResetSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_PositionReset_PositionResetSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  5 downto 2  loop
            if(wEn(51) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_PositionReset_PositionResetSource(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_PositionReset_PositionResetSource;

------------------------------------------------------------------------------------------
-- Field name: PositionResetActivation
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_PositionReset(1) <= field_rw_Quadrature_0_PositionReset_PositionResetActivation;
regfile.Quadrature(0).PositionReset.PositionResetActivation <= field_rw_Quadrature_0_PositionReset_PositionResetActivation;


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_PositionReset_PositionResetActivation
------------------------------------------------------------------------------------------
P_Quadrature_0_PositionReset_PositionResetActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_PositionReset_PositionResetActivation <= '0';
      else
         if(wEn(51) = '1' and bitEnN(1) = '0') then
            field_rw_Quadrature_0_PositionReset_PositionResetActivation <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Quadrature_0_PositionReset_PositionResetActivation;

------------------------------------------------------------------------------------------
-- Field name: soft_PositionReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Quadrature_0_PositionReset(0) <= '0';
regfile.Quadrature(0).PositionReset.soft_PositionReset <= field_wautoclr_Quadrature_0_PositionReset_soft_PositionReset;


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_PositionReset_soft_PositionReset
------------------------------------------------------------------------------------------
P_Quadrature_0_PositionReset_soft_PositionReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Quadrature_0_PositionReset_soft_PositionReset <= '0';
      else
         if(wEn(51) = '1' and bitEnN(0) = '0') then
            field_wautoclr_Quadrature_0_PositionReset_soft_PositionReset <= reg_writedata(0);
         else
            field_wautoclr_Quadrature_0_PositionReset_soft_PositionReset <= '0';
         end if;
      end if;
   end if;
end process P_Quadrature_0_PositionReset_soft_PositionReset;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderInput
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(52) <= (hit(52)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: BSelector(31 downto 29)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderInput(31 downto 29) <= field_rw_Quadrature_0_DecoderInput_BSelector(2 downto 0);
regfile.Quadrature(0).DecoderInput.BSelector <= field_rw_Quadrature_0_DecoderInput_BSelector(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderInput_BSelector
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderInput_BSelector : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderInput_BSelector <= std_logic_vector(to_unsigned(integer(2),3));
      else
         for j in  31 downto 29  loop
            if(wEn(52) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderInput_BSelector(j-29) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderInput_BSelector;

------------------------------------------------------------------------------------------
-- Field name: ASelector(15 downto 13)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderInput(15 downto 13) <= field_rw_Quadrature_0_DecoderInput_ASelector(2 downto 0);
regfile.Quadrature(0).DecoderInput.ASelector <= field_rw_Quadrature_0_DecoderInput_ASelector(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderInput_ASelector
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderInput_ASelector : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderInput_ASelector <= std_logic_vector(to_unsigned(integer(1),3));
      else
         for j in  15 downto 13  loop
            if(wEn(52) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderInput_ASelector(j-13) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderInput_ASelector;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderCfg
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(53) <= (hit(53)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DecOutSource0(4 downto 2)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCfg(4 downto 2) <= field_rw_Quadrature_0_DecoderCfg_DecOutSource0(2 downto 0);
regfile.Quadrature(0).DecoderCfg.DecOutSource0 <= field_rw_Quadrature_0_DecoderCfg_DecOutSource0(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCfg_DecOutSource0
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCfg_DecOutSource0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderCfg_DecOutSource0 <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  4 downto 2  loop
            if(wEn(53) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderCfg_DecOutSource0(j-2) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderCfg_DecOutSource0;

------------------------------------------------------------------------------------------
-- Field name: QuadEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCfg(0) <= field_rw_Quadrature_0_DecoderCfg_QuadEnable;
regfile.Quadrature(0).DecoderCfg.QuadEnable <= field_rw_Quadrature_0_DecoderCfg_QuadEnable;


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCfg_QuadEnable
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCfg_QuadEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderCfg_QuadEnable <= '0';
      else
         if(wEn(53) = '1' and bitEnN(0) = '0') then
            field_rw_Quadrature_0_DecoderCfg_QuadEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Quadrature_0_DecoderCfg_QuadEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderPosTrigger
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(54) <= (hit(54)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: PositionTrigger(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderPosTrigger(31 downto 0) <= field_rw_Quadrature_0_DecoderPosTrigger_PositionTrigger(31 downto 0);
regfile.Quadrature(0).DecoderPosTrigger.PositionTrigger <= field_rw_Quadrature_0_DecoderPosTrigger_PositionTrigger(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderPosTrigger_PositionTrigger
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderPosTrigger_PositionTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderPosTrigger_PositionTrigger <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(54) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderPosTrigger_PositionTrigger(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderPosTrigger_PositionTrigger;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderCntrLatch_Cfg
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(55) <= (hit(55)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DecoderCntrLatch_SW
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatch_Cfg(24) <= '0';
regfile.Quadrature(0).DecoderCntrLatch_Cfg.DecoderCntrLatch_SW <= field_wautoclr_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW;


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW <= '0';
      else
         if(wEn(55) = '1' and bitEnN(24) = '0') then
            field_wautoclr_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW <= reg_writedata(24);
         else
            field_wautoclr_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW <= '0';
         end if;
      end if;
   end if;
end process P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_SW;

------------------------------------------------------------------------------------------
-- Field name: DecoderCntrLatch_Src(20 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatch_Cfg(20 downto 16) <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src(4 downto 0);
regfile.Quadrature(0).DecoderCntrLatch_Cfg.DecoderCntrLatch_Src <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  20 downto 16  loop
            if(wEn(55) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Src;

------------------------------------------------------------------------------------------
-- Field name: DecoderCntrLatch_En
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatch_Cfg(8) <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En;
regfile.Quadrature(0).DecoderCntrLatch_Cfg.DecoderCntrLatch_En <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En;


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En <= '0';
      else
         if(wEn(55) = '1' and bitEnN(8) = '0') then
            field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_En;

------------------------------------------------------------------------------------------
-- Field name: DecoderCntrLatch_Act(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatch_Cfg(5 downto 4) <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act(1 downto 0);
regfile.Quadrature(0).DecoderCntrLatch_Cfg.DecoderCntrLatch_Act <= field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act
------------------------------------------------------------------------------------------
P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(55) = '1' and bitEnN(j) = '0') then
               field_rw_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Quadrature_0_DecoderCntrLatch_Cfg_DecoderCntrLatch_Act;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderCntrLatched_SW
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(56) <= (hit(56)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DecoderCntr(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatched_SW(31 downto 0) <= regfile.Quadrature(0).DecoderCntrLatched_SW.DecoderCntr;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Quadrature_0_DecoderCntrLatched
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(57) <= (hit(57)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DecoderCntr(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Quadrature_0_DecoderCntrLatched(31 downto 0) <= regfile.Quadrature(0).DecoderCntrLatched.DecoderCntr;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_CAPABILITIES_TICKTBL
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(58) <= (hit(58)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TICKTABLE_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_TICKTBL(31 downto 24) <= std_logic_vector(to_unsigned(integer(97),8));
regfile.TickTable(0).CAPABILITIES_TICKTBL.TICKTABLE_ID <= rb_TickTable_0_CAPABILITIES_TICKTBL(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_TICKTBL(23 downto 20) <= std_logic_vector(to_unsigned(integer(1),4));
regfile.TickTable(0).CAPABILITIES_TICKTBL.FEATURE_REV <= rb_TickTable_0_CAPABILITIES_TICKTBL(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_ELEMENTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_TICKTBL(16 downto 12) <= std_logic_vector(to_unsigned(integer(13),5));
regfile.TickTable(0).CAPABILITIES_TICKTBL.NB_ELEMENTS <= rb_TickTable_0_CAPABILITIES_TICKTBL(16 downto 12);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_TICKTBL(11 downto 7) <= regfile.TickTable(0).CAPABILITIES_TICKTBL.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_CAPABILITIES_EXT1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(59) <= (hit(59)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TABLE_WIDTH
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_EXT1(7 downto 0) <= std_logic_vector(to_unsigned(integer(4),8));
regfile.TickTable(0).CAPABILITIES_EXT1.TABLE_WIDTH <= rb_TickTable_0_CAPABILITIES_EXT1(7 downto 0);


------------------------------------------------------------------------------------------
-- Field name: NB_LATCH
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_CAPABILITIES_EXT1(11 downto 8) <= std_logic_vector(to_unsigned(integer(2),4));
regfile.TickTable(0).CAPABILITIES_EXT1.NB_LATCH <= rb_TickTable_0_CAPABILITIES_EXT1(11 downto 8);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_TickTableClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(60) <= (hit(60)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_TickTableClockPeriod(7 downto 0) <= regfile.TickTable(0).TickTableClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_TickConfig
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(61) <= (hit(61)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ClearTickTable
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(28) <= '0';
regfile.TickTable(0).TickConfig.ClearTickTable <= field_wautoclr_TickTable_0_TickConfig_ClearTickTable;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_ClearTickTable
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_ClearTickTable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_TickTable_0_TickConfig_ClearTickTable <= '0';
      else
         if(wEn(61) = '1' and bitEnN(28) = '0') then
            field_wautoclr_TickTable_0_TickConfig_ClearTickTable <= reg_writedata(28);
         else
            field_wautoclr_TickTable_0_TickConfig_ClearTickTable <= '0';
         end if;
      end if;
   end if;
end process P_TickTable_0_TickConfig_ClearTickTable;

------------------------------------------------------------------------------------------
-- Field name: ClearMask(23 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(23 downto 16) <= field_rw_TickTable_0_TickConfig_ClearMask(7 downto 0);
regfile.TickTable(0).TickConfig.ClearMask <= field_rw_TickTable_0_TickConfig_ClearMask(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_ClearMask
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_ClearMask : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_ClearMask <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  23 downto 16  loop
            if(wEn(61) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_TickConfig_ClearMask(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_TickConfig_ClearMask;

------------------------------------------------------------------------------------------
-- Field name: TickClock(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(11 downto 8) <= field_rw_TickTable_0_TickConfig_TickClock(3 downto 0);
regfile.TickTable(0).TickConfig.TickClock <= field_rw_TickTable_0_TickConfig_TickClock(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_TickClock
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_TickClock : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_TickClock <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(61) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_TickConfig_TickClock(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_TickConfig_TickClock;

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(7 downto 6)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(7 downto 6) <= field_rw_TickTable_0_TickConfig_IntClock_sel(1 downto 0);
regfile.TickTable(0).TickConfig.IntClock_sel <= field_rw_TickTable_0_TickConfig_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_IntClock_sel
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  7 downto 6  loop
            if(wEn(61) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_TickConfig_IntClock_sel(j-6) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_TickConfig_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: TickClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(5 downto 4) <= field_rw_TickTable_0_TickConfig_TickClockActivation(1 downto 0);
regfile.TickTable(0).TickConfig.TickClockActivation <= field_rw_TickTable_0_TickConfig_TickClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_TickClockActivation
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_TickClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_TickClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(61) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_TickConfig_TickClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_TickConfig_TickClockActivation;

------------------------------------------------------------------------------------------
-- Field name: EnableHalftableInt
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(3) <= field_rw_TickTable_0_TickConfig_EnableHalftableInt;
regfile.TickTable(0).TickConfig.EnableHalftableInt <= field_rw_TickTable_0_TickConfig_EnableHalftableInt;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_EnableHalftableInt
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_EnableHalftableInt : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_EnableHalftableInt <= '0';
      else
         if(wEn(61) = '1' and bitEnN(3) = '0') then
            field_rw_TickTable_0_TickConfig_EnableHalftableInt <= reg_writedata(3);
         end if;
      end if;
   end if;
end process P_TickTable_0_TickConfig_EnableHalftableInt;

------------------------------------------------------------------------------------------
-- Field name: IntClock_en
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(2) <= field_rw_TickTable_0_TickConfig_IntClock_en;
regfile.TickTable(0).TickConfig.IntClock_en <= field_rw_TickTable_0_TickConfig_IntClock_en;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_IntClock_en
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_IntClock_en : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_TickConfig_IntClock_en <= '0';
      else
         if(wEn(61) = '1' and bitEnN(2) = '0') then
            field_rw_TickTable_0_TickConfig_IntClock_en <= reg_writedata(2);
         end if;
      end if;
   end if;
end process P_TickTable_0_TickConfig_IntClock_en;

------------------------------------------------------------------------------------------
-- Field name: LatchCurrentStamp
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(1) <= '0';
regfile.TickTable(0).TickConfig.LatchCurrentStamp <= field_wautoclr_TickTable_0_TickConfig_LatchCurrentStamp;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_LatchCurrentStamp
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_LatchCurrentStamp : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_TickTable_0_TickConfig_LatchCurrentStamp <= '0';
      else
         if(wEn(61) = '1' and bitEnN(1) = '0') then
            field_wautoclr_TickTable_0_TickConfig_LatchCurrentStamp <= reg_writedata(1);
         else
            field_wautoclr_TickTable_0_TickConfig_LatchCurrentStamp <= '0';
         end if;
      end if;
   end if;
end process P_TickTable_0_TickConfig_LatchCurrentStamp;

------------------------------------------------------------------------------------------
-- Field name: ResetTimestamp
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_TickTable_0_TickConfig(0) <= '0';
regfile.TickTable(0).TickConfig.ResetTimestamp <= field_wautoclr_TickTable_0_TickConfig_ResetTimestamp;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_TickConfig_ResetTimestamp
------------------------------------------------------------------------------------------
P_TickTable_0_TickConfig_ResetTimestamp : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_TickTable_0_TickConfig_ResetTimestamp <= '0';
      else
         if(wEn(61) = '1' and bitEnN(0) = '0') then
            field_wautoclr_TickTable_0_TickConfig_ResetTimestamp <= reg_writedata(0);
         else
            field_wautoclr_TickTable_0_TickConfig_ResetTimestamp <= '0';
         end if;
      end if;
   end if;
end process P_TickTable_0_TickConfig_ResetTimestamp;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_CurrentStampLatched
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(62) <= (hit(62)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: CurrentStamp(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_CurrentStampLatched(31 downto 0) <= regfile.TickTable(0).CurrentStampLatched.CurrentStamp;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_WriteTime
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(63) <= (hit(63)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WriteTime(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteTime(31 downto 0) <= field_rw_TickTable_0_WriteTime_WriteTime(31 downto 0);
regfile.TickTable(0).WriteTime.WriteTime <= field_rw_TickTable_0_WriteTime_WriteTime(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_WriteTime_WriteTime
------------------------------------------------------------------------------------------
P_TickTable_0_WriteTime_WriteTime : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_WriteTime_WriteTime <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(63) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_WriteTime_WriteTime(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_WriteTime_WriteTime;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_WriteCommand
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(64) <= (hit(64)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: WriteDone
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(13) <= regfile.TickTable(0).WriteCommand.WriteDone;


------------------------------------------------------------------------------------------
-- Field name: WriteStatus
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(12) <= regfile.TickTable(0).WriteCommand.WriteStatus;


------------------------------------------------------------------------------------------
-- Field name: ExecuteFutureWrite
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(9) <= '0';
regfile.TickTable(0).WriteCommand.ExecuteFutureWrite <= field_wautoclr_TickTable_0_WriteCommand_ExecuteFutureWrite;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_WriteCommand_ExecuteFutureWrite
------------------------------------------------------------------------------------------
P_TickTable_0_WriteCommand_ExecuteFutureWrite : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_TickTable_0_WriteCommand_ExecuteFutureWrite <= '0';
      else
         if(wEn(64) = '1' and bitEnN(9) = '0') then
            field_wautoclr_TickTable_0_WriteCommand_ExecuteFutureWrite <= reg_writedata(9);
         else
            field_wautoclr_TickTable_0_WriteCommand_ExecuteFutureWrite <= '0';
         end if;
      end if;
   end if;
end process P_TickTable_0_WriteCommand_ExecuteFutureWrite;

------------------------------------------------------------------------------------------
-- Field name: ExecuteImmWrite
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(8) <= '0';
regfile.TickTable(0).WriteCommand.ExecuteImmWrite <= field_wautoclr_TickTable_0_WriteCommand_ExecuteImmWrite;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_WriteCommand_ExecuteImmWrite
------------------------------------------------------------------------------------------
P_TickTable_0_WriteCommand_ExecuteImmWrite : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_TickTable_0_WriteCommand_ExecuteImmWrite <= '0';
      else
         if(wEn(64) = '1' and bitEnN(8) = '0') then
            field_wautoclr_TickTable_0_WriteCommand_ExecuteImmWrite <= reg_writedata(8);
         else
            field_wautoclr_TickTable_0_WriteCommand_ExecuteImmWrite <= '0';
         end if;
      end if;
   end if;
end process P_TickTable_0_WriteCommand_ExecuteImmWrite;

------------------------------------------------------------------------------------------
-- Field name: BitCmd(6 downto 5)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(6 downto 5) <= field_rw_TickTable_0_WriteCommand_BitCmd(1 downto 0);
regfile.TickTable(0).WriteCommand.BitCmd <= field_rw_TickTable_0_WriteCommand_BitCmd(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_WriteCommand_BitCmd
------------------------------------------------------------------------------------------
P_TickTable_0_WriteCommand_BitCmd : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_WriteCommand_BitCmd <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  6 downto 5  loop
            if(wEn(64) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_WriteCommand_BitCmd(j-5) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_WriteCommand_BitCmd;

------------------------------------------------------------------------------------------
-- Field name: BitNum(1 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_WriteCommand(1 downto 0) <= field_rw_TickTable_0_WriteCommand_BitNum(1 downto 0);
regfile.TickTable(0).WriteCommand.BitNum <= field_rw_TickTable_0_WriteCommand_BitNum(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_WriteCommand_BitNum
------------------------------------------------------------------------------------------
P_TickTable_0_WriteCommand_BitNum : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_WriteCommand_BitNum <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  1 downto 0  loop
            if(wEn(64) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_WriteCommand_BitNum(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_WriteCommand_BitNum;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_LatchIntStat
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(65) <= (hit(65)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: LatchIntStat(1 downto 0)
-- Field type: RW2C
------------------------------------------------------------------------------------------
rb_TickTable_0_LatchIntStat(1 downto 0) <= field_rw2c_TickTable_0_LatchIntStat_LatchIntStat(1 downto 0);
regfile.TickTable(0).LatchIntStat.LatchIntStat <= field_rw2c_TickTable_0_LatchIntStat_LatchIntStat(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_LatchIntStat_LatchIntStat
------------------------------------------------------------------------------------------
P_TickTable_0_LatchIntStat_LatchIntStat : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw2c_TickTable_0_LatchIntStat_LatchIntStat <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  1 downto 0  loop
            if(wEn(65) = '1' and reg_writedata(j) = '1' and bitEnN(j) = '0') then
               -- Clear every field bit to '0'
               field_rw2c_TickTable_0_LatchIntStat_LatchIntStat(j-0) <= '0';
            else
               -- Set every field bit to '1'
               field_rw2c_TickTable_0_LatchIntStat_LatchIntStat(j-0) <= field_rw2c_TickTable_0_LatchIntStat_LatchIntStat(j-0) or regfile.TickTable(0).LatchIntStat.LatchIntStat_set(j-0);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_LatchIntStat_LatchIntStat;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_InputStamp_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(66) <= (hit(66)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: InputStampSource(19 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_0(19 downto 16) <= field_rw_TickTable_0_InputStamp_0_InputStampSource(3 downto 0);
regfile.TickTable(0).InputStamp(0).InputStampSource <= field_rw_TickTable_0_InputStamp_0_InputStampSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_0_InputStampSource
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_0_InputStampSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_0_InputStampSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  19 downto 16  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_InputStamp_0_InputStampSource(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_InputStamp_0_InputStampSource;

------------------------------------------------------------------------------------------
-- Field name: LatchInputIntEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_0(9) <= field_rw_TickTable_0_InputStamp_0_LatchInputIntEnable;
regfile.TickTable(0).InputStamp(0).LatchInputIntEnable <= field_rw_TickTable_0_InputStamp_0_LatchInputIntEnable;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_0_LatchInputIntEnable
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_0_LatchInputIntEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_0_LatchInputIntEnable <= '0';
      else
         if(wEn(66) = '1' and bitEnN(9) = '0') then
            field_rw_TickTable_0_InputStamp_0_LatchInputIntEnable <= reg_writedata(9);
         end if;
      end if;
   end if;
end process P_TickTable_0_InputStamp_0_LatchInputIntEnable;

------------------------------------------------------------------------------------------
-- Field name: LatchInputStamp_En
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_0(8) <= field_rw_TickTable_0_InputStamp_0_LatchInputStamp_En;
regfile.TickTable(0).InputStamp(0).LatchInputStamp_En <= field_rw_TickTable_0_InputStamp_0_LatchInputStamp_En;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_0_LatchInputStamp_En
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_0_LatchInputStamp_En : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_0_LatchInputStamp_En <= '0';
      else
         if(wEn(66) = '1' and bitEnN(8) = '0') then
            field_rw_TickTable_0_InputStamp_0_LatchInputStamp_En <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_TickTable_0_InputStamp_0_LatchInputStamp_En;

------------------------------------------------------------------------------------------
-- Field name: InputStampActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_0(5 downto 4) <= field_rw_TickTable_0_InputStamp_0_InputStampActivation(1 downto 0);
regfile.TickTable(0).InputStamp(0).InputStampActivation <= field_rw_TickTable_0_InputStamp_0_InputStampActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_0_InputStampActivation
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_0_InputStampActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_0_InputStampActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(66) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_InputStamp_0_InputStampActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_InputStamp_0_InputStampActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_InputStamp_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(67) <= (hit(67)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: InputStampSource(19 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_1(19 downto 16) <= field_rw_TickTable_0_InputStamp_1_InputStampSource(3 downto 0);
regfile.TickTable(0).InputStamp(1).InputStampSource <= field_rw_TickTable_0_InputStamp_1_InputStampSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_1_InputStampSource
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_1_InputStampSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_1_InputStampSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  19 downto 16  loop
            if(wEn(67) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_InputStamp_1_InputStampSource(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_InputStamp_1_InputStampSource;

------------------------------------------------------------------------------------------
-- Field name: LatchInputIntEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_1(9) <= field_rw_TickTable_0_InputStamp_1_LatchInputIntEnable;
regfile.TickTable(0).InputStamp(1).LatchInputIntEnable <= field_rw_TickTable_0_InputStamp_1_LatchInputIntEnable;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_1_LatchInputIntEnable
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_1_LatchInputIntEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_1_LatchInputIntEnable <= '0';
      else
         if(wEn(67) = '1' and bitEnN(9) = '0') then
            field_rw_TickTable_0_InputStamp_1_LatchInputIntEnable <= reg_writedata(9);
         end if;
      end if;
   end if;
end process P_TickTable_0_InputStamp_1_LatchInputIntEnable;

------------------------------------------------------------------------------------------
-- Field name: LatchInputStamp_En
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_1(8) <= field_rw_TickTable_0_InputStamp_1_LatchInputStamp_En;
regfile.TickTable(0).InputStamp(1).LatchInputStamp_En <= field_rw_TickTable_0_InputStamp_1_LatchInputStamp_En;


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_1_LatchInputStamp_En
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_1_LatchInputStamp_En : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_1_LatchInputStamp_En <= '0';
      else
         if(wEn(67) = '1' and bitEnN(8) = '0') then
            field_rw_TickTable_0_InputStamp_1_LatchInputStamp_En <= reg_writedata(8);
         end if;
      end if;
   end if;
end process P_TickTable_0_InputStamp_1_LatchInputStamp_En;

------------------------------------------------------------------------------------------
-- Field name: InputStampActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStamp_1(5 downto 4) <= field_rw_TickTable_0_InputStamp_1_InputStampActivation(1 downto 0);
regfile.TickTable(0).InputStamp(1).InputStampActivation <= field_rw_TickTable_0_InputStamp_1_InputStampActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_TickTable_0_InputStamp_1_InputStampActivation
------------------------------------------------------------------------------------------
P_TickTable_0_InputStamp_1_InputStampActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_TickTable_0_InputStamp_1_InputStampActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(67) = '1' and bitEnN(j) = '0') then
               field_rw_TickTable_0_InputStamp_1_InputStampActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_TickTable_0_InputStamp_1_InputStampActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(68) <= (hit(68)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_0(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(0).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_0(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(69) <= (hit(69)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_1(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(1).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_1(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(70) <= (hit(70)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_2(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(2).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_2(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(71) <= (hit(71)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_3(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(3).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_3(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_4
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(72) <= (hit(72)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_4(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(4).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_4(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_5
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(73) <= (hit(73)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_5(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(5).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_5(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_6
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(74) <= (hit(74)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_6(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(6).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_6(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_7
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(75) <= (hit(75)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_7(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(7).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_7(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_8
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(76) <= (hit(76)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_8(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(8).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_8(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_reserved_for_extra_latch_9
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(77) <= (hit(77)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: reserved_for_extra_latch
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_TickTable_0_reserved_for_extra_latch_9(0) <= '0';
regfile.TickTable(0).reserved_for_extra_latch(9).reserved_for_extra_latch <= rb_TickTable_0_reserved_for_extra_latch_9(0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_InputStampLatched_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(78) <= (hit(78)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: InputStamp(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStampLatched_0(31 downto 0) <= regfile.TickTable(0).InputStampLatched(0).InputStamp;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: TickTable_0_InputStampLatched_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(79) <= (hit(79)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: InputStamp(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_TickTable_0_InputStampLatched_1(31 downto 0) <= regfile.TickTable(0).InputStampLatched(1).InputStamp;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InputConditioning_CAPABILITIES_INCOND
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(80) <= (hit(80)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: INPUTCOND_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InputConditioning_CAPABILITIES_INCOND(31 downto 24) <= std_logic_vector(to_unsigned(integer(98),8));
regfile.InputConditioning.CAPABILITIES_INCOND.INPUTCOND_ID <= rb_InputConditioning_CAPABILITIES_INCOND(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InputConditioning_CAPABILITIES_INCOND(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.InputConditioning.CAPABILITIES_INCOND.FEATURE_REV <= rb_InputConditioning_CAPABILITIES_INCOND(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_INPUTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InputConditioning_CAPABILITIES_INCOND(16 downto 12) <= std_logic_vector(to_unsigned(integer(4),5));
regfile.InputConditioning.CAPABILITIES_INCOND.NB_INPUTS <= rb_InputConditioning_CAPABILITIES_INCOND(16 downto 12);


------------------------------------------------------------------------------------------
-- Field name: Period_ns(7 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_InputConditioning_CAPABILITIES_INCOND(7 downto 0) <= regfile.InputConditioning.CAPABILITIES_INCOND.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InputConditioning_InputConditioning_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(81) <= (hit(81)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DebounceHoldOff(31 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_0(31 downto 8) <= field_rw_InputConditioning_InputConditioning_0_DebounceHoldOff(23 downto 0);
regfile.InputConditioning.InputConditioning(0).DebounceHoldOff <= field_rw_InputConditioning_InputConditioning_0_DebounceHoldOff(23 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_0_DebounceHoldOff
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_0_DebounceHoldOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_0_DebounceHoldOff <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  31 downto 8  loop
            if(wEn(81) = '1' and bitEnN(j) = '0') then
               field_rw_InputConditioning_InputConditioning_0_DebounceHoldOff(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_0_DebounceHoldOff;

------------------------------------------------------------------------------------------
-- Field name: InputFiltering
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_0(1) <= field_rw_InputConditioning_InputConditioning_0_InputFiltering;
regfile.InputConditioning.InputConditioning(0).InputFiltering <= field_rw_InputConditioning_InputConditioning_0_InputFiltering;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_0_InputFiltering
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_0_InputFiltering : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_0_InputFiltering <= '0';
      else
         if(wEn(81) = '1' and bitEnN(1) = '0') then
            field_rw_InputConditioning_InputConditioning_0_InputFiltering <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_0_InputFiltering;

------------------------------------------------------------------------------------------
-- Field name: InputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_0(0) <= field_rw_InputConditioning_InputConditioning_0_InputPol;
regfile.InputConditioning.InputConditioning(0).InputPol <= field_rw_InputConditioning_InputConditioning_0_InputPol;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_0_InputPol
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_0_InputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_0_InputPol <= '0';
      else
         if(wEn(81) = '1' and bitEnN(0) = '0') then
            field_rw_InputConditioning_InputConditioning_0_InputPol <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_0_InputPol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InputConditioning_InputConditioning_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(82) <= (hit(82)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DebounceHoldOff(31 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_1(31 downto 8) <= field_rw_InputConditioning_InputConditioning_1_DebounceHoldOff(23 downto 0);
regfile.InputConditioning.InputConditioning(1).DebounceHoldOff <= field_rw_InputConditioning_InputConditioning_1_DebounceHoldOff(23 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_1_DebounceHoldOff
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_1_DebounceHoldOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_1_DebounceHoldOff <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  31 downto 8  loop
            if(wEn(82) = '1' and bitEnN(j) = '0') then
               field_rw_InputConditioning_InputConditioning_1_DebounceHoldOff(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_1_DebounceHoldOff;

------------------------------------------------------------------------------------------
-- Field name: InputFiltering
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_1(1) <= field_rw_InputConditioning_InputConditioning_1_InputFiltering;
regfile.InputConditioning.InputConditioning(1).InputFiltering <= field_rw_InputConditioning_InputConditioning_1_InputFiltering;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_1_InputFiltering
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_1_InputFiltering : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_1_InputFiltering <= '0';
      else
         if(wEn(82) = '1' and bitEnN(1) = '0') then
            field_rw_InputConditioning_InputConditioning_1_InputFiltering <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_1_InputFiltering;

------------------------------------------------------------------------------------------
-- Field name: InputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_1(0) <= field_rw_InputConditioning_InputConditioning_1_InputPol;
regfile.InputConditioning.InputConditioning(1).InputPol <= field_rw_InputConditioning_InputConditioning_1_InputPol;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_1_InputPol
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_1_InputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_1_InputPol <= '0';
      else
         if(wEn(82) = '1' and bitEnN(0) = '0') then
            field_rw_InputConditioning_InputConditioning_1_InputPol <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_1_InputPol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InputConditioning_InputConditioning_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(83) <= (hit(83)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DebounceHoldOff(31 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_2(31 downto 8) <= field_rw_InputConditioning_InputConditioning_2_DebounceHoldOff(23 downto 0);
regfile.InputConditioning.InputConditioning(2).DebounceHoldOff <= field_rw_InputConditioning_InputConditioning_2_DebounceHoldOff(23 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_2_DebounceHoldOff
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_2_DebounceHoldOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_2_DebounceHoldOff <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  31 downto 8  loop
            if(wEn(83) = '1' and bitEnN(j) = '0') then
               field_rw_InputConditioning_InputConditioning_2_DebounceHoldOff(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_2_DebounceHoldOff;

------------------------------------------------------------------------------------------
-- Field name: InputFiltering
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_2(1) <= field_rw_InputConditioning_InputConditioning_2_InputFiltering;
regfile.InputConditioning.InputConditioning(2).InputFiltering <= field_rw_InputConditioning_InputConditioning_2_InputFiltering;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_2_InputFiltering
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_2_InputFiltering : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_2_InputFiltering <= '0';
      else
         if(wEn(83) = '1' and bitEnN(1) = '0') then
            field_rw_InputConditioning_InputConditioning_2_InputFiltering <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_2_InputFiltering;

------------------------------------------------------------------------------------------
-- Field name: InputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_2(0) <= field_rw_InputConditioning_InputConditioning_2_InputPol;
regfile.InputConditioning.InputConditioning(2).InputPol <= field_rw_InputConditioning_InputConditioning_2_InputPol;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_2_InputPol
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_2_InputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_2_InputPol <= '0';
      else
         if(wEn(83) = '1' and bitEnN(0) = '0') then
            field_rw_InputConditioning_InputConditioning_2_InputPol <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_2_InputPol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InputConditioning_InputConditioning_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(84) <= (hit(84)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: DebounceHoldOff(31 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_3(31 downto 8) <= field_rw_InputConditioning_InputConditioning_3_DebounceHoldOff(23 downto 0);
regfile.InputConditioning.InputConditioning(3).DebounceHoldOff <= field_rw_InputConditioning_InputConditioning_3_DebounceHoldOff(23 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_3_DebounceHoldOff
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_3_DebounceHoldOff : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_3_DebounceHoldOff <= std_logic_vector(to_unsigned(integer(0),24));
      else
         for j in  31 downto 8  loop
            if(wEn(84) = '1' and bitEnN(j) = '0') then
               field_rw_InputConditioning_InputConditioning_3_DebounceHoldOff(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_3_DebounceHoldOff;

------------------------------------------------------------------------------------------
-- Field name: InputFiltering
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_3(1) <= field_rw_InputConditioning_InputConditioning_3_InputFiltering;
regfile.InputConditioning.InputConditioning(3).InputFiltering <= field_rw_InputConditioning_InputConditioning_3_InputFiltering;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_3_InputFiltering
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_3_InputFiltering : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_3_InputFiltering <= '0';
      else
         if(wEn(84) = '1' and bitEnN(1) = '0') then
            field_rw_InputConditioning_InputConditioning_3_InputFiltering <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_3_InputFiltering;

------------------------------------------------------------------------------------------
-- Field name: InputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InputConditioning_InputConditioning_3(0) <= field_rw_InputConditioning_InputConditioning_3_InputPol;
regfile.InputConditioning.InputConditioning(3).InputPol <= field_rw_InputConditioning_InputConditioning_3_InputPol;


------------------------------------------------------------------------------------------
-- Process: P_InputConditioning_InputConditioning_3_InputPol
------------------------------------------------------------------------------------------
P_InputConditioning_InputConditioning_3_InputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InputConditioning_InputConditioning_3_InputPol <= '0';
      else
         if(wEn(84) = '1' and bitEnN(0) = '0') then
            field_rw_InputConditioning_InputConditioning_3_InputPol <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_InputConditioning_InputConditioning_3_InputPol;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_CAPABILITIES_OUTCOND
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(85) <= (hit(85)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OUTPUTCOND_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_OutputConditioning_CAPABILITIES_OUTCOND(31 downto 24) <= std_logic_vector(to_unsigned(integer(99),8));
regfile.OutputConditioning.CAPABILITIES_OUTCOND.OUTPUTCOND_ID <= rb_OutputConditioning_CAPABILITIES_OUTCOND(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_OutputConditioning_CAPABILITIES_OUTCOND(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.OutputConditioning.CAPABILITIES_OUTCOND.FEATURE_REV <= rb_OutputConditioning_CAPABILITIES_OUTCOND(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_OUTPUTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_OutputConditioning_CAPABILITIES_OUTCOND(16 downto 12) <= std_logic_vector(to_unsigned(integer(4),5));
regfile.OutputConditioning.CAPABILITIES_OUTCOND.NB_OUTPUTS <= rb_OutputConditioning_CAPABILITIES_OUTCOND(16 downto 12);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_OutputCond_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(86) <= (hit(86)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal
-- Field type: RO
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_0(16) <= regfile.OutputConditioning.OutputCond(0).OutputVal;


------------------------------------------------------------------------------------------
-- Field name: OutputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_0(7) <= field_rw_OutputConditioning_OutputCond_0_OutputPol;
regfile.OutputConditioning.OutputCond(0).OutputPol <= field_rw_OutputConditioning_OutputCond_0_OutputPol;


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_0_OutputPol
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_0_OutputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_0_OutputPol <= '0';
      else
         if(wEn(86) = '1' and bitEnN(7) = '0') then
            field_rw_OutputConditioning_OutputCond_0_OutputPol <= reg_writedata(7);
         end if;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_0_OutputPol;

------------------------------------------------------------------------------------------
-- Field name: Outsel(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_0(5 downto 0) <= field_rw_OutputConditioning_OutputCond_0_Outsel(5 downto 0);
regfile.OutputConditioning.OutputCond(0).Outsel <= field_rw_OutputConditioning_OutputCond_0_Outsel(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_0_Outsel
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_0_Outsel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_0_Outsel <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(86) = '1' and bitEnN(j) = '0') then
               field_rw_OutputConditioning_OutputCond_0_Outsel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_0_Outsel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_OutputCond_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(87) <= (hit(87)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal
-- Field type: RO
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_1(16) <= regfile.OutputConditioning.OutputCond(1).OutputVal;


------------------------------------------------------------------------------------------
-- Field name: OutputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_1(7) <= field_rw_OutputConditioning_OutputCond_1_OutputPol;
regfile.OutputConditioning.OutputCond(1).OutputPol <= field_rw_OutputConditioning_OutputCond_1_OutputPol;


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_1_OutputPol
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_1_OutputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_1_OutputPol <= '0';
      else
         if(wEn(87) = '1' and bitEnN(7) = '0') then
            field_rw_OutputConditioning_OutputCond_1_OutputPol <= reg_writedata(7);
         end if;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_1_OutputPol;

------------------------------------------------------------------------------------------
-- Field name: Outsel(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_1(5 downto 0) <= field_rw_OutputConditioning_OutputCond_1_Outsel(5 downto 0);
regfile.OutputConditioning.OutputCond(1).Outsel <= field_rw_OutputConditioning_OutputCond_1_Outsel(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_1_Outsel
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_1_Outsel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_1_Outsel <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(87) = '1' and bitEnN(j) = '0') then
               field_rw_OutputConditioning_OutputCond_1_Outsel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_1_Outsel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_OutputCond_2
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(88) <= (hit(88)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal
-- Field type: RO
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_2(16) <= regfile.OutputConditioning.OutputCond(2).OutputVal;


------------------------------------------------------------------------------------------
-- Field name: OutputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_2(7) <= field_rw_OutputConditioning_OutputCond_2_OutputPol;
regfile.OutputConditioning.OutputCond(2).OutputPol <= field_rw_OutputConditioning_OutputCond_2_OutputPol;


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_2_OutputPol
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_2_OutputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_2_OutputPol <= '0';
      else
         if(wEn(88) = '1' and bitEnN(7) = '0') then
            field_rw_OutputConditioning_OutputCond_2_OutputPol <= reg_writedata(7);
         end if;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_2_OutputPol;

------------------------------------------------------------------------------------------
-- Field name: Outsel(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_2(5 downto 0) <= field_rw_OutputConditioning_OutputCond_2_Outsel(5 downto 0);
regfile.OutputConditioning.OutputCond(2).Outsel <= field_rw_OutputConditioning_OutputCond_2_Outsel(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_2_Outsel
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_2_Outsel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_2_Outsel <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(88) = '1' and bitEnN(j) = '0') then
               field_rw_OutputConditioning_OutputCond_2_Outsel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_2_Outsel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_OutputCond_3
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(89) <= (hit(89)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal
-- Field type: RO
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_3(16) <= regfile.OutputConditioning.OutputCond(3).OutputVal;


------------------------------------------------------------------------------------------
-- Field name: OutputPol
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_3(7) <= field_rw_OutputConditioning_OutputCond_3_OutputPol;
regfile.OutputConditioning.OutputCond(3).OutputPol <= field_rw_OutputConditioning_OutputCond_3_OutputPol;


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_3_OutputPol
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_3_OutputPol : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_3_OutputPol <= '0';
      else
         if(wEn(89) = '1' and bitEnN(7) = '0') then
            field_rw_OutputConditioning_OutputCond_3_OutputPol <= reg_writedata(7);
         end if;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_3_OutputPol;

------------------------------------------------------------------------------------------
-- Field name: Outsel(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_OutputCond_3(5 downto 0) <= field_rw_OutputConditioning_OutputCond_3_Outsel(5 downto 0);
regfile.OutputConditioning.OutputCond(3).Outsel <= field_rw_OutputConditioning_OutputCond_3_Outsel(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_OutputCond_3_Outsel
------------------------------------------------------------------------------------------
P_OutputConditioning_OutputCond_3_Outsel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_OutputCond_3_Outsel <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(89) = '1' and bitEnN(j) = '0') then
               field_rw_OutputConditioning_OutputCond_3_Outsel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_OutputConditioning_OutputCond_3_Outsel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_Reserved
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(90) <= (hit(90)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Reserved
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_OutputConditioning_Reserved(7 downto 0) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.OutputConditioning.Reserved.Reserved <= rb_OutputConditioning_Reserved(7 downto 0);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: OutputConditioning_Output_Debounce
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(91) <= (hit(91)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Output_HoldOFF_reg_EN
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_Output_Debounce(16) <= field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN;
regfile.OutputConditioning.Output_Debounce.Output_HoldOFF_reg_EN <= field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN;


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN
------------------------------------------------------------------------------------------
P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN <= '0';
      else
         if(wEn(91) = '1' and bitEnN(16) = '0') then
            field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_EN;

------------------------------------------------------------------------------------------
-- Field name: Output_HoldOFF_reg_CNTR(9 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_OutputConditioning_Output_Debounce(9 downto 0) <= field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR(9 downto 0);
regfile.OutputConditioning.Output_Debounce.Output_HoldOFF_reg_CNTR <= field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR(9 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR
------------------------------------------------------------------------------------------
P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR <= std_logic_vector(to_unsigned(integer(511),10));
      else
         for j in  9 downto 0  loop
            if(wEn(91) = '1' and bitEnN(j) = '0') then
               field_rw_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_OutputConditioning_Output_Debounce_Output_HoldOFF_reg_CNTR;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InternalInput_CAPABILITIES_INT_INP
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(92) <= (hit(92)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: INT_INPUT_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalInput_CAPABILITIES_INT_INP(31 downto 24) <= std_logic_vector(to_unsigned(integer(102),8));
regfile.InternalInput.CAPABILITIES_INT_INP.INT_INPUT_ID <= rb_InternalInput_CAPABILITIES_INT_INP(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalInput_CAPABILITIES_INT_INP(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.InternalInput.CAPABILITIES_INT_INP.FEATURE_REV <= rb_InternalInput_CAPABILITIES_INT_INP(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_INPUTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalInput_CAPABILITIES_INT_INP(16 downto 12) <= std_logic_vector(to_unsigned(integer(3),5));
regfile.InternalInput.CAPABILITIES_INT_INP.NB_INPUTS <= rb_InternalInput_CAPABILITIES_INT_INP(16 downto 12);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InternalOutput_CAPABILITIES_INTOUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(93) <= (hit(93)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: INT_OUTPUT_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalOutput_CAPABILITIES_INTOUT(31 downto 24) <= std_logic_vector(to_unsigned(integer(101),8));
regfile.InternalOutput.CAPABILITIES_INTOUT.INT_OUTPUT_ID <= rb_InternalOutput_CAPABILITIES_INTOUT(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalOutput_CAPABILITIES_INTOUT(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.InternalOutput.CAPABILITIES_INTOUT.FEATURE_REV <= rb_InternalOutput_CAPABILITIES_INTOUT(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_OUTPUTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_InternalOutput_CAPABILITIES_INTOUT(16 downto 12) <= std_logic_vector(to_unsigned(integer(1),5));
regfile.InternalOutput.CAPABILITIES_INTOUT.NB_OUTPUTS <= rb_InternalOutput_CAPABILITIES_INTOUT(16 downto 12);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: InternalOutput_OutputCond_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(94) <= (hit(94)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal
-- Field type: RO
------------------------------------------------------------------------------------------
rb_InternalOutput_OutputCond_0(16) <= regfile.InternalOutput.OutputCond(0).OutputVal;


------------------------------------------------------------------------------------------
-- Field name: Outsel(5 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_InternalOutput_OutputCond_0(5 downto 0) <= field_rw_InternalOutput_OutputCond_0_Outsel(5 downto 0);
regfile.InternalOutput.OutputCond(0).Outsel <= field_rw_InternalOutput_OutputCond_0_Outsel(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_InternalOutput_OutputCond_0_Outsel
------------------------------------------------------------------------------------------
P_InternalOutput_OutputCond_0_Outsel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_InternalOutput_OutputCond_0_Outsel <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  5 downto 0  loop
            if(wEn(94) = '1' and bitEnN(j) = '0') then
               field_rw_InternalOutput_OutputCond_0_Outsel(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_InternalOutput_OutputCond_0_Outsel;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(95) <= (hit(95)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_0_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(0).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_0_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_0_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(0).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_0_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_0_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(0).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(96) <= (hit(96)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockPeriod(15 downto 0) <= regfile.Timer(0).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(97) <= (hit(97)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(31) <= '0';
regfile.Timer(0).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(97) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(26 downto 25) <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(24) <= field_rw_Timer_0_TimerTriggerArm_TimerArmEnable;
regfile.Timer(0).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_0_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(97) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_0_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(23 downto 19) <= field_rw_Timer_0_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerArmSource <= field_rw_Timer_0_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(18 downto 16) <= field_rw_Timer_0_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_0_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(15) <= '0';
regfile.Timer(0).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(97) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_0_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(14) <= field_rw_Timer_0_TimerTriggerArm_TimerMesurement;
regfile.Timer(0).TimerTriggerArm.TimerMesurement <= field_rw_Timer_0_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(97) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_0_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(12 downto 11) <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(10 downto 9) <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(8 downto 3) <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerTriggerArm(2 downto 0) <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(0).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_0_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_0_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(97) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(98) <= (hit(98)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockSource(17 downto 16) <= field_rw_Timer_0_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(0).TimerClockSource.IntClock_sel <= field_rw_Timer_0_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_0_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockSource(13 downto 12) <= field_rw_Timer_0_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(0).TimerClockSource.DelayClockActivation <= field_rw_Timer_0_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_0_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockSource(11 downto 8) <= field_rw_Timer_0_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(0).TimerClockSource.DelayClockSource <= field_rw_Timer_0_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_0_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockSource(5 downto 4) <= field_rw_Timer_0_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(0).TimerClockSource.TimerClockActivation <= field_rw_Timer_0_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_0_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerClockSource(3 downto 0) <= field_rw_Timer_0_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(0).TimerClockSource.TimerClockSource <= field_rw_Timer_0_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_0_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(98) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(99) <= (hit(99)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerDelayValue(31 downto 0) <= field_rw_Timer_0_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(0).TimerDelayValue.TimerDelayValue <= field_rw_Timer_0_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_0_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(99) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(100) <= (hit(100)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerDuration(31 downto 0) <= field_rw_Timer_0_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(0).TimerDuration.TimerDuration <= field_rw_Timer_0_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_0_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(100) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_0_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_0_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(101) <= (hit(101)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_0_TimerLatchedValue(31 downto 0) <= regfile.Timer(0).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_0_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(102) <= (hit(102)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(31 downto 29) <= regfile.Timer(0).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(28 downto 26) <= regfile.Timer(0).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(17) <= field_rw_Timer_0_TimerStatus_TimerEndIntmaskn;
regfile.Timer(0).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_0_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(102) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_0_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(16) <= field_rw_Timer_0_TimerStatus_TimerStartIntmaskn;
regfile.Timer(0).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_0_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(102) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_0_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(10) <= field_rw_Timer_0_TimerStatus_TimerLatchAndReset;
regfile.Timer(0).TimerStatus.TimerLatchAndReset <= field_rw_Timer_0_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(102) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_0_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(9) <= '0';
regfile.Timer(0).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_0_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_0_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(102) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_0_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_0_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(8) <= '0';
regfile.Timer(0).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_0_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_0_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(102) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_0_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_0_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(1) <= field_rw_Timer_0_TimerStatus_TimerInversion;
regfile.Timer(0).TimerStatus.TimerInversion <= field_rw_Timer_0_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(102) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_0_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_0_TimerStatus(0) <= field_rw_Timer_0_TimerStatus_TimerEnable;
regfile.Timer(0).TimerStatus.TimerEnable <= field_rw_Timer_0_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_0_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_0_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_0_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(102) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_0_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_0_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(103) <= (hit(103)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_1_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(1).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_1_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_1_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(1).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_1_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_1_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(1).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(104) <= (hit(104)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockPeriod(15 downto 0) <= regfile.Timer(1).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(105) <= (hit(105)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(31) <= '0';
regfile.Timer(1).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(105) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(26 downto 25) <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(24) <= field_rw_Timer_1_TimerTriggerArm_TimerArmEnable;
regfile.Timer(1).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_1_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(105) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_1_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(23 downto 19) <= field_rw_Timer_1_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerArmSource <= field_rw_Timer_1_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(18 downto 16) <= field_rw_Timer_1_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_1_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(15) <= '0';
regfile.Timer(1).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(105) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_1_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(14) <= field_rw_Timer_1_TimerTriggerArm_TimerMesurement;
regfile.Timer(1).TimerTriggerArm.TimerMesurement <= field_rw_Timer_1_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(105) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_1_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(12 downto 11) <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(10 downto 9) <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(8 downto 3) <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerTriggerArm(2 downto 0) <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(1).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_1_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_1_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(105) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(106) <= (hit(106)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockSource(17 downto 16) <= field_rw_Timer_1_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(1).TimerClockSource.IntClock_sel <= field_rw_Timer_1_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_1_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(106) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockSource(13 downto 12) <= field_rw_Timer_1_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(1).TimerClockSource.DelayClockActivation <= field_rw_Timer_1_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_1_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(106) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockSource(11 downto 8) <= field_rw_Timer_1_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(1).TimerClockSource.DelayClockSource <= field_rw_Timer_1_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_1_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(106) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockSource(5 downto 4) <= field_rw_Timer_1_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(1).TimerClockSource.TimerClockActivation <= field_rw_Timer_1_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_1_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(106) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerClockSource(3 downto 0) <= field_rw_Timer_1_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(1).TimerClockSource.TimerClockSource <= field_rw_Timer_1_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_1_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(106) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(107) <= (hit(107)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerDelayValue(31 downto 0) <= field_rw_Timer_1_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(1).TimerDelayValue.TimerDelayValue <= field_rw_Timer_1_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_1_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(107) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(108) <= (hit(108)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerDuration(31 downto 0) <= field_rw_Timer_1_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(1).TimerDuration.TimerDuration <= field_rw_Timer_1_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_1_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(108) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_1_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_1_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(109) <= (hit(109)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_1_TimerLatchedValue(31 downto 0) <= regfile.Timer(1).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_1_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(110) <= (hit(110)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(31 downto 29) <= regfile.Timer(1).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(28 downto 26) <= regfile.Timer(1).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(17) <= field_rw_Timer_1_TimerStatus_TimerEndIntmaskn;
regfile.Timer(1).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_1_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(110) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_1_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(16) <= field_rw_Timer_1_TimerStatus_TimerStartIntmaskn;
regfile.Timer(1).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_1_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(110) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_1_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(10) <= field_rw_Timer_1_TimerStatus_TimerLatchAndReset;
regfile.Timer(1).TimerStatus.TimerLatchAndReset <= field_rw_Timer_1_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(110) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_1_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(9) <= '0';
regfile.Timer(1).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_1_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_1_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(110) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_1_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_1_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(8) <= '0';
regfile.Timer(1).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_1_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_1_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(110) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_1_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_1_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(1) <= field_rw_Timer_1_TimerStatus_TimerInversion;
regfile.Timer(1).TimerStatus.TimerInversion <= field_rw_Timer_1_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(110) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_1_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_1_TimerStatus(0) <= field_rw_Timer_1_TimerStatus_TimerEnable;
regfile.Timer(1).TimerStatus.TimerEnable <= field_rw_Timer_1_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_1_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_1_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_1_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(110) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_1_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_1_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(111) <= (hit(111)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_2_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(2).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_2_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_2_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(2).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_2_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_2_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(2).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(112) <= (hit(112)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockPeriod(15 downto 0) <= regfile.Timer(2).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(113) <= (hit(113)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(31) <= '0';
regfile.Timer(2).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(113) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(26 downto 25) <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(24) <= field_rw_Timer_2_TimerTriggerArm_TimerArmEnable;
regfile.Timer(2).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_2_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(113) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_2_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(23 downto 19) <= field_rw_Timer_2_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerArmSource <= field_rw_Timer_2_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(18 downto 16) <= field_rw_Timer_2_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_2_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(15) <= '0';
regfile.Timer(2).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(113) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_2_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(14) <= field_rw_Timer_2_TimerTriggerArm_TimerMesurement;
regfile.Timer(2).TimerTriggerArm.TimerMesurement <= field_rw_Timer_2_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(113) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_2_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(12 downto 11) <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(10 downto 9) <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(8 downto 3) <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerTriggerArm(2 downto 0) <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(2).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_2_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_2_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(113) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(114) <= (hit(114)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockSource(17 downto 16) <= field_rw_Timer_2_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(2).TimerClockSource.IntClock_sel <= field_rw_Timer_2_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_2_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(114) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockSource(13 downto 12) <= field_rw_Timer_2_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(2).TimerClockSource.DelayClockActivation <= field_rw_Timer_2_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_2_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(114) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockSource(11 downto 8) <= field_rw_Timer_2_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(2).TimerClockSource.DelayClockSource <= field_rw_Timer_2_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_2_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(114) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockSource(5 downto 4) <= field_rw_Timer_2_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(2).TimerClockSource.TimerClockActivation <= field_rw_Timer_2_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_2_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(114) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerClockSource(3 downto 0) <= field_rw_Timer_2_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(2).TimerClockSource.TimerClockSource <= field_rw_Timer_2_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_2_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(114) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(115) <= (hit(115)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerDelayValue(31 downto 0) <= field_rw_Timer_2_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(2).TimerDelayValue.TimerDelayValue <= field_rw_Timer_2_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_2_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(115) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(116) <= (hit(116)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerDuration(31 downto 0) <= field_rw_Timer_2_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(2).TimerDuration.TimerDuration <= field_rw_Timer_2_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_2_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(116) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_2_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_2_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(117) <= (hit(117)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_2_TimerLatchedValue(31 downto 0) <= regfile.Timer(2).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_2_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(118) <= (hit(118)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(31 downto 29) <= regfile.Timer(2).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(28 downto 26) <= regfile.Timer(2).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(17) <= field_rw_Timer_2_TimerStatus_TimerEndIntmaskn;
regfile.Timer(2).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_2_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(118) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_2_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(16) <= field_rw_Timer_2_TimerStatus_TimerStartIntmaskn;
regfile.Timer(2).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_2_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(118) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_2_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(10) <= field_rw_Timer_2_TimerStatus_TimerLatchAndReset;
regfile.Timer(2).TimerStatus.TimerLatchAndReset <= field_rw_Timer_2_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(118) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_2_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(9) <= '0';
regfile.Timer(2).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_2_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_2_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(118) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_2_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_2_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(8) <= '0';
regfile.Timer(2).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_2_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_2_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(118) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_2_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_2_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(1) <= field_rw_Timer_2_TimerStatus_TimerInversion;
regfile.Timer(2).TimerStatus.TimerInversion <= field_rw_Timer_2_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(118) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_2_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_2_TimerStatus(0) <= field_rw_Timer_2_TimerStatus_TimerEnable;
regfile.Timer(2).TimerStatus.TimerEnable <= field_rw_Timer_2_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_2_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_2_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_2_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(118) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_2_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_2_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(119) <= (hit(119)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_3_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(3).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_3_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_3_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(3).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_3_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_3_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(3).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(120) <= (hit(120)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockPeriod(15 downto 0) <= regfile.Timer(3).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(121) <= (hit(121)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(31) <= '0';
regfile.Timer(3).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(121) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(26 downto 25) <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(24) <= field_rw_Timer_3_TimerTriggerArm_TimerArmEnable;
regfile.Timer(3).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_3_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(121) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_3_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(23 downto 19) <= field_rw_Timer_3_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerArmSource <= field_rw_Timer_3_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(18 downto 16) <= field_rw_Timer_3_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_3_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(15) <= '0';
regfile.Timer(3).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(121) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_3_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(14) <= field_rw_Timer_3_TimerTriggerArm_TimerMesurement;
regfile.Timer(3).TimerTriggerArm.TimerMesurement <= field_rw_Timer_3_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(121) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_3_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(12 downto 11) <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(10 downto 9) <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(8 downto 3) <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerTriggerArm(2 downto 0) <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(3).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_3_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_3_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(121) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(122) <= (hit(122)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockSource(17 downto 16) <= field_rw_Timer_3_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(3).TimerClockSource.IntClock_sel <= field_rw_Timer_3_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_3_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(122) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockSource(13 downto 12) <= field_rw_Timer_3_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(3).TimerClockSource.DelayClockActivation <= field_rw_Timer_3_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_3_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(122) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockSource(11 downto 8) <= field_rw_Timer_3_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(3).TimerClockSource.DelayClockSource <= field_rw_Timer_3_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_3_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(122) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockSource(5 downto 4) <= field_rw_Timer_3_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(3).TimerClockSource.TimerClockActivation <= field_rw_Timer_3_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_3_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(122) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerClockSource(3 downto 0) <= field_rw_Timer_3_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(3).TimerClockSource.TimerClockSource <= field_rw_Timer_3_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_3_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(122) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(123) <= (hit(123)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerDelayValue(31 downto 0) <= field_rw_Timer_3_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(3).TimerDelayValue.TimerDelayValue <= field_rw_Timer_3_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_3_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(123) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(124) <= (hit(124)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerDuration(31 downto 0) <= field_rw_Timer_3_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(3).TimerDuration.TimerDuration <= field_rw_Timer_3_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_3_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(124) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_3_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_3_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(125) <= (hit(125)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_3_TimerLatchedValue(31 downto 0) <= regfile.Timer(3).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_3_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(126) <= (hit(126)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(31 downto 29) <= regfile.Timer(3).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(28 downto 26) <= regfile.Timer(3).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(17) <= field_rw_Timer_3_TimerStatus_TimerEndIntmaskn;
regfile.Timer(3).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_3_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(126) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_3_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(16) <= field_rw_Timer_3_TimerStatus_TimerStartIntmaskn;
regfile.Timer(3).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_3_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(126) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_3_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(10) <= field_rw_Timer_3_TimerStatus_TimerLatchAndReset;
regfile.Timer(3).TimerStatus.TimerLatchAndReset <= field_rw_Timer_3_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(126) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_3_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(9) <= '0';
regfile.Timer(3).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_3_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_3_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(126) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_3_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_3_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(8) <= '0';
regfile.Timer(3).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_3_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_3_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(126) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_3_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_3_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(1) <= field_rw_Timer_3_TimerStatus_TimerInversion;
regfile.Timer(3).TimerStatus.TimerInversion <= field_rw_Timer_3_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(126) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_3_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_3_TimerStatus(0) <= field_rw_Timer_3_TimerStatus_TimerEnable;
regfile.Timer(3).TimerStatus.TimerEnable <= field_rw_Timer_3_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_3_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_3_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_3_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(126) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_3_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_3_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(127) <= (hit(127)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_4_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(4).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_4_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_4_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(4).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_4_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_4_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(4).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(128) <= (hit(128)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockPeriod(15 downto 0) <= regfile.Timer(4).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(129) <= (hit(129)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(31) <= '0';
regfile.Timer(4).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(129) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(26 downto 25) <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(24) <= field_rw_Timer_4_TimerTriggerArm_TimerArmEnable;
regfile.Timer(4).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_4_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(129) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_4_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(23 downto 19) <= field_rw_Timer_4_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerArmSource <= field_rw_Timer_4_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(18 downto 16) <= field_rw_Timer_4_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_4_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(15) <= '0';
regfile.Timer(4).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(129) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_4_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(14) <= field_rw_Timer_4_TimerTriggerArm_TimerMesurement;
regfile.Timer(4).TimerTriggerArm.TimerMesurement <= field_rw_Timer_4_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(129) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_4_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(12 downto 11) <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(10 downto 9) <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(8 downto 3) <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerTriggerArm(2 downto 0) <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(4).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_4_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_4_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(129) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(130) <= (hit(130)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockSource(17 downto 16) <= field_rw_Timer_4_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(4).TimerClockSource.IntClock_sel <= field_rw_Timer_4_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_4_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(130) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockSource(13 downto 12) <= field_rw_Timer_4_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(4).TimerClockSource.DelayClockActivation <= field_rw_Timer_4_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_4_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(130) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockSource(11 downto 8) <= field_rw_Timer_4_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(4).TimerClockSource.DelayClockSource <= field_rw_Timer_4_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_4_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(130) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockSource(5 downto 4) <= field_rw_Timer_4_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(4).TimerClockSource.TimerClockActivation <= field_rw_Timer_4_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_4_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(130) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerClockSource(3 downto 0) <= field_rw_Timer_4_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(4).TimerClockSource.TimerClockSource <= field_rw_Timer_4_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_4_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(130) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(131) <= (hit(131)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerDelayValue(31 downto 0) <= field_rw_Timer_4_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(4).TimerDelayValue.TimerDelayValue <= field_rw_Timer_4_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_4_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(131) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(132) <= (hit(132)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerDuration(31 downto 0) <= field_rw_Timer_4_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(4).TimerDuration.TimerDuration <= field_rw_Timer_4_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_4_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(132) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_4_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_4_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(133) <= (hit(133)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_4_TimerLatchedValue(31 downto 0) <= regfile.Timer(4).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_4_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(134) <= (hit(134)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(31 downto 29) <= regfile.Timer(4).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(28 downto 26) <= regfile.Timer(4).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(17) <= field_rw_Timer_4_TimerStatus_TimerEndIntmaskn;
regfile.Timer(4).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_4_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(134) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_4_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(16) <= field_rw_Timer_4_TimerStatus_TimerStartIntmaskn;
regfile.Timer(4).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_4_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(134) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_4_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(10) <= field_rw_Timer_4_TimerStatus_TimerLatchAndReset;
regfile.Timer(4).TimerStatus.TimerLatchAndReset <= field_rw_Timer_4_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(134) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_4_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(9) <= '0';
regfile.Timer(4).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_4_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_4_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(134) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_4_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_4_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(8) <= '0';
regfile.Timer(4).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_4_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_4_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(134) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_4_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_4_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(1) <= field_rw_Timer_4_TimerStatus_TimerInversion;
regfile.Timer(4).TimerStatus.TimerInversion <= field_rw_Timer_4_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(134) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_4_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_4_TimerStatus(0) <= field_rw_Timer_4_TimerStatus_TimerEnable;
regfile.Timer(4).TimerStatus.TimerEnable <= field_rw_Timer_4_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_4_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_4_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_4_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(134) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_4_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_4_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(135) <= (hit(135)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_5_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(5).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_5_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_5_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(5).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_5_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_5_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(5).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(136) <= (hit(136)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockPeriod(15 downto 0) <= regfile.Timer(5).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(137) <= (hit(137)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(31) <= '0';
regfile.Timer(5).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(137) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(26 downto 25) <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(24) <= field_rw_Timer_5_TimerTriggerArm_TimerArmEnable;
regfile.Timer(5).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_5_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(137) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_5_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(23 downto 19) <= field_rw_Timer_5_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerArmSource <= field_rw_Timer_5_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(18 downto 16) <= field_rw_Timer_5_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_5_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(15) <= '0';
regfile.Timer(5).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(137) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_5_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(14) <= field_rw_Timer_5_TimerTriggerArm_TimerMesurement;
regfile.Timer(5).TimerTriggerArm.TimerMesurement <= field_rw_Timer_5_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(137) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_5_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(12 downto 11) <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(10 downto 9) <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(8 downto 3) <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerTriggerArm(2 downto 0) <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(5).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_5_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_5_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(137) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(138) <= (hit(138)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockSource(17 downto 16) <= field_rw_Timer_5_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(5).TimerClockSource.IntClock_sel <= field_rw_Timer_5_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_5_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(138) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockSource(13 downto 12) <= field_rw_Timer_5_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(5).TimerClockSource.DelayClockActivation <= field_rw_Timer_5_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_5_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(138) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockSource(11 downto 8) <= field_rw_Timer_5_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(5).TimerClockSource.DelayClockSource <= field_rw_Timer_5_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_5_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(138) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockSource(5 downto 4) <= field_rw_Timer_5_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(5).TimerClockSource.TimerClockActivation <= field_rw_Timer_5_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_5_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(138) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerClockSource(3 downto 0) <= field_rw_Timer_5_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(5).TimerClockSource.TimerClockSource <= field_rw_Timer_5_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_5_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(138) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(139) <= (hit(139)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerDelayValue(31 downto 0) <= field_rw_Timer_5_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(5).TimerDelayValue.TimerDelayValue <= field_rw_Timer_5_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_5_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(139) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(140) <= (hit(140)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerDuration(31 downto 0) <= field_rw_Timer_5_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(5).TimerDuration.TimerDuration <= field_rw_Timer_5_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_5_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(140) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_5_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_5_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(141) <= (hit(141)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_5_TimerLatchedValue(31 downto 0) <= regfile.Timer(5).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_5_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(142) <= (hit(142)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(31 downto 29) <= regfile.Timer(5).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(28 downto 26) <= regfile.Timer(5).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(17) <= field_rw_Timer_5_TimerStatus_TimerEndIntmaskn;
regfile.Timer(5).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_5_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(142) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_5_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(16) <= field_rw_Timer_5_TimerStatus_TimerStartIntmaskn;
regfile.Timer(5).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_5_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(142) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_5_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(10) <= field_rw_Timer_5_TimerStatus_TimerLatchAndReset;
regfile.Timer(5).TimerStatus.TimerLatchAndReset <= field_rw_Timer_5_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(142) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_5_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(9) <= '0';
regfile.Timer(5).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_5_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_5_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(142) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_5_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_5_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(8) <= '0';
regfile.Timer(5).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_5_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_5_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(142) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_5_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_5_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(1) <= field_rw_Timer_5_TimerStatus_TimerInversion;
regfile.Timer(5).TimerStatus.TimerInversion <= field_rw_Timer_5_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(142) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_5_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_5_TimerStatus(0) <= field_rw_Timer_5_TimerStatus_TimerEnable;
regfile.Timer(5).TimerStatus.TimerEnable <= field_rw_Timer_5_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_5_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_5_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_5_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(142) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_5_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_5_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(143) <= (hit(143)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_6_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(6).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_6_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_6_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(6).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_6_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_6_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(6).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(144) <= (hit(144)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockPeriod(15 downto 0) <= regfile.Timer(6).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(145) <= (hit(145)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(31) <= '0';
regfile.Timer(6).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(145) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(26 downto 25) <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(24) <= field_rw_Timer_6_TimerTriggerArm_TimerArmEnable;
regfile.Timer(6).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_6_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(145) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_6_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(23 downto 19) <= field_rw_Timer_6_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerArmSource <= field_rw_Timer_6_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(18 downto 16) <= field_rw_Timer_6_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_6_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(15) <= '0';
regfile.Timer(6).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(145) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_6_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(14) <= field_rw_Timer_6_TimerTriggerArm_TimerMesurement;
regfile.Timer(6).TimerTriggerArm.TimerMesurement <= field_rw_Timer_6_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(145) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_6_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(12 downto 11) <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(10 downto 9) <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(8 downto 3) <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerTriggerArm(2 downto 0) <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(6).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_6_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_6_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(145) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(146) <= (hit(146)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockSource(17 downto 16) <= field_rw_Timer_6_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(6).TimerClockSource.IntClock_sel <= field_rw_Timer_6_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_6_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(146) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockSource(13 downto 12) <= field_rw_Timer_6_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(6).TimerClockSource.DelayClockActivation <= field_rw_Timer_6_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_6_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(146) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockSource(11 downto 8) <= field_rw_Timer_6_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(6).TimerClockSource.DelayClockSource <= field_rw_Timer_6_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_6_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(146) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockSource(5 downto 4) <= field_rw_Timer_6_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(6).TimerClockSource.TimerClockActivation <= field_rw_Timer_6_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_6_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(146) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerClockSource(3 downto 0) <= field_rw_Timer_6_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(6).TimerClockSource.TimerClockSource <= field_rw_Timer_6_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_6_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(146) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(147) <= (hit(147)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerDelayValue(31 downto 0) <= field_rw_Timer_6_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(6).TimerDelayValue.TimerDelayValue <= field_rw_Timer_6_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_6_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(147) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(148) <= (hit(148)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerDuration(31 downto 0) <= field_rw_Timer_6_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(6).TimerDuration.TimerDuration <= field_rw_Timer_6_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_6_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(148) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_6_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_6_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(149) <= (hit(149)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_6_TimerLatchedValue(31 downto 0) <= regfile.Timer(6).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_6_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(150) <= (hit(150)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(31 downto 29) <= regfile.Timer(6).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(28 downto 26) <= regfile.Timer(6).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(17) <= field_rw_Timer_6_TimerStatus_TimerEndIntmaskn;
regfile.Timer(6).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_6_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(150) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_6_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(16) <= field_rw_Timer_6_TimerStatus_TimerStartIntmaskn;
regfile.Timer(6).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_6_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(150) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_6_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(10) <= field_rw_Timer_6_TimerStatus_TimerLatchAndReset;
regfile.Timer(6).TimerStatus.TimerLatchAndReset <= field_rw_Timer_6_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(150) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_6_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(9) <= '0';
regfile.Timer(6).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_6_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_6_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(150) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_6_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_6_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(8) <= '0';
regfile.Timer(6).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_6_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_6_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(150) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_6_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_6_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(1) <= field_rw_Timer_6_TimerStatus_TimerInversion;
regfile.Timer(6).TimerStatus.TimerInversion <= field_rw_Timer_6_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(150) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_6_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_6_TimerStatus(0) <= field_rw_Timer_6_TimerStatus_TimerEnable;
regfile.Timer(6).TimerStatus.TimerEnable <= field_rw_Timer_6_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_6_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_6_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_6_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(150) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_6_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_6_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_CAPABILITIES_TIMER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(151) <= (hit(151)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TIMER_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_7_CAPABILITIES_TIMER(31 downto 24) <= std_logic_vector(to_unsigned(integer(96),8));
regfile.Timer(7).CAPABILITIES_TIMER.TIMER_ID <= rb_Timer_7_CAPABILITIES_TIMER(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Timer_7_CAPABILITIES_TIMER(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Timer(7).CAPABILITIES_TIMER.FEATURE_REV <= rb_Timer_7_CAPABILITIES_TIMER(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: INTNUM(4 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_7_CAPABILITIES_TIMER(11 downto 7) <= regfile.Timer(7).CAPABILITIES_TIMER.INTNUM;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerClockPeriod
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(152) <= (hit(152)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Period_ns(15 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockPeriod(15 downto 0) <= regfile.Timer(7).TimerClockPeriod.Period_ns;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerTriggerArm
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(153) <= (hit(153)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerArm
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(31) <= '0';
regfile.Timer(7).TimerTriggerArm.Soft_TimerArm <= field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerArm;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_Soft_TimerArm
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_Soft_TimerArm : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerArm <= '0';
      else
         if(wEn(153) = '1' and bitEnN(31) = '0') then
            field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerArm <= reg_writedata(31);
         else
            field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerArm <= '0';
         end if;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_Soft_TimerArm;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerOverlap(26 downto 25)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(26 downto 25) <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerTriggerOverlap <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerOverlap(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerTriggerOverlap
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerTriggerOverlap : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerTriggerOverlap <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  26 downto 25  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerTriggerOverlap(j-25) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerTriggerOverlap;

------------------------------------------------------------------------------------------
-- Field name: TimerArmEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(24) <= field_rw_Timer_7_TimerTriggerArm_TimerArmEnable;
regfile.Timer(7).TimerTriggerArm.TimerArmEnable <= field_rw_Timer_7_TimerTriggerArm_TimerArmEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerArmEnable
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerArmEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerArmEnable <= '0';
      else
         if(wEn(153) = '1' and bitEnN(24) = '0') then
            field_rw_Timer_7_TimerTriggerArm_TimerArmEnable <= reg_writedata(24);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerArmEnable;

------------------------------------------------------------------------------------------
-- Field name: TimerArmSource(23 downto 19)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(23 downto 19) <= field_rw_Timer_7_TimerTriggerArm_TimerArmSource(4 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerArmSource <= field_rw_Timer_7_TimerTriggerArm_TimerArmSource(4 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerArmSource
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerArmSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerArmSource <= std_logic_vector(to_unsigned(integer(0),5));
      else
         for j in  23 downto 19  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerArmSource(j-19) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerArmSource;

------------------------------------------------------------------------------------------
-- Field name: TimerArmActivation(18 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(18 downto 16) <= field_rw_Timer_7_TimerTriggerArm_TimerArmActivation(2 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerArmActivation <= field_rw_Timer_7_TimerTriggerArm_TimerArmActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerArmActivation
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerArmActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerArmActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  18 downto 16  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerArmActivation(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerArmActivation;

------------------------------------------------------------------------------------------
-- Field name: Soft_TimerTrigger
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(15) <= '0';
regfile.Timer(7).TimerTriggerArm.Soft_TimerTrigger <= field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerTrigger;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_Soft_TimerTrigger
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_Soft_TimerTrigger : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerTrigger <= '0';
      else
         if(wEn(153) = '1' and bitEnN(15) = '0') then
            field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerTrigger <= reg_writedata(15);
         else
            field_wautoclr_Timer_7_TimerTriggerArm_Soft_TimerTrigger <= '0';
         end if;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_Soft_TimerTrigger;

------------------------------------------------------------------------------------------
-- Field name: TimerMesurement
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(14) <= field_rw_Timer_7_TimerTriggerArm_TimerMesurement;
regfile.Timer(7).TimerTriggerArm.TimerMesurement <= field_rw_Timer_7_TimerTriggerArm_TimerMesurement;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerMesurement
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerMesurement : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerMesurement <= '0';
      else
         if(wEn(153) = '1' and bitEnN(14) = '0') then
            field_rw_Timer_7_TimerTriggerArm_TimerMesurement <= reg_writedata(14);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerMesurement;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicESel(12 downto 11)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(12 downto 11) <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerTriggerLogicESel <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicESel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerTriggerLogicESel
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerTriggerLogicESel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicESel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  12 downto 11  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicESel(j-11) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerTriggerLogicESel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerLogicDSel(10 downto 9)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(10 downto 9) <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerTriggerLogicDSel <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  10 downto 9  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel(j-9) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerTriggerLogicDSel;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerSource(8 downto 3)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(8 downto 3) <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerSource(5 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerTriggerSource <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerSource(5 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerTriggerSource
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerTriggerSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerTriggerSource <= std_logic_vector(to_unsigned(integer(0),6));
      else
         for j in  8 downto 3  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerTriggerSource(j-3) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerTriggerSource;

------------------------------------------------------------------------------------------
-- Field name: TimerTriggerActivation(2 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerTriggerArm(2 downto 0) <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerActivation(2 downto 0);
regfile.Timer(7).TimerTriggerArm.TimerTriggerActivation <= field_rw_Timer_7_TimerTriggerArm_TimerTriggerActivation(2 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerTriggerArm_TimerTriggerActivation
------------------------------------------------------------------------------------------
P_Timer_7_TimerTriggerArm_TimerTriggerActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerTriggerArm_TimerTriggerActivation <= std_logic_vector(to_unsigned(integer(0),3));
      else
         for j in  2 downto 0  loop
            if(wEn(153) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerTriggerArm_TimerTriggerActivation(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerTriggerArm_TimerTriggerActivation;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerClockSource
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(154) <= (hit(154)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: IntClock_sel(17 downto 16)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockSource(17 downto 16) <= field_rw_Timer_7_TimerClockSource_IntClock_sel(1 downto 0);
regfile.Timer(7).TimerClockSource.IntClock_sel <= field_rw_Timer_7_TimerClockSource_IntClock_sel(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerClockSource_IntClock_sel
------------------------------------------------------------------------------------------
P_Timer_7_TimerClockSource_IntClock_sel : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerClockSource_IntClock_sel <= std_logic_vector(to_unsigned(integer(1),2));
      else
         for j in  17 downto 16  loop
            if(wEn(154) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerClockSource_IntClock_sel(j-16) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerClockSource_IntClock_sel;

------------------------------------------------------------------------------------------
-- Field name: DelayClockActivation(13 downto 12)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockSource(13 downto 12) <= field_rw_Timer_7_TimerClockSource_DelayClockActivation(1 downto 0);
regfile.Timer(7).TimerClockSource.DelayClockActivation <= field_rw_Timer_7_TimerClockSource_DelayClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerClockSource_DelayClockActivation
------------------------------------------------------------------------------------------
P_Timer_7_TimerClockSource_DelayClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerClockSource_DelayClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  13 downto 12  loop
            if(wEn(154) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerClockSource_DelayClockActivation(j-12) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerClockSource_DelayClockActivation;

------------------------------------------------------------------------------------------
-- Field name: DelayClockSource(11 downto 8)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockSource(11 downto 8) <= field_rw_Timer_7_TimerClockSource_DelayClockSource(3 downto 0);
regfile.Timer(7).TimerClockSource.DelayClockSource <= field_rw_Timer_7_TimerClockSource_DelayClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerClockSource_DelayClockSource
------------------------------------------------------------------------------------------
P_Timer_7_TimerClockSource_DelayClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerClockSource_DelayClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  11 downto 8  loop
            if(wEn(154) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerClockSource_DelayClockSource(j-8) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerClockSource_DelayClockSource;

------------------------------------------------------------------------------------------
-- Field name: TimerClockActivation(5 downto 4)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockSource(5 downto 4) <= field_rw_Timer_7_TimerClockSource_TimerClockActivation(1 downto 0);
regfile.Timer(7).TimerClockSource.TimerClockActivation <= field_rw_Timer_7_TimerClockSource_TimerClockActivation(1 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerClockSource_TimerClockActivation
------------------------------------------------------------------------------------------
P_Timer_7_TimerClockSource_TimerClockActivation : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerClockSource_TimerClockActivation <= std_logic_vector(to_unsigned(integer(0),2));
      else
         for j in  5 downto 4  loop
            if(wEn(154) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerClockSource_TimerClockActivation(j-4) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerClockSource_TimerClockActivation;

------------------------------------------------------------------------------------------
-- Field name: TimerClockSource(3 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerClockSource(3 downto 0) <= field_rw_Timer_7_TimerClockSource_TimerClockSource(3 downto 0);
regfile.Timer(7).TimerClockSource.TimerClockSource <= field_rw_Timer_7_TimerClockSource_TimerClockSource(3 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerClockSource_TimerClockSource
------------------------------------------------------------------------------------------
P_Timer_7_TimerClockSource_TimerClockSource : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerClockSource_TimerClockSource <= std_logic_vector(to_unsigned(integer(0),4));
      else
         for j in  3 downto 0  loop
            if(wEn(154) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerClockSource_TimerClockSource(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerClockSource_TimerClockSource;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerDelayValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(155) <= (hit(155)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDelayValue(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerDelayValue(31 downto 0) <= field_rw_Timer_7_TimerDelayValue_TimerDelayValue(31 downto 0);
regfile.Timer(7).TimerDelayValue.TimerDelayValue <= field_rw_Timer_7_TimerDelayValue_TimerDelayValue(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerDelayValue_TimerDelayValue
------------------------------------------------------------------------------------------
P_Timer_7_TimerDelayValue_TimerDelayValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerDelayValue_TimerDelayValue <= X"00000000";
      else
         for j in  31 downto 0  loop
            if(wEn(155) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerDelayValue_TimerDelayValue(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerDelayValue_TimerDelayValue;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerDuration
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(156) <= (hit(156)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerDuration(31 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerDuration(31 downto 0) <= field_rw_Timer_7_TimerDuration_TimerDuration(31 downto 0);
regfile.Timer(7).TimerDuration.TimerDuration <= field_rw_Timer_7_TimerDuration_TimerDuration(31 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerDuration_TimerDuration
------------------------------------------------------------------------------------------
P_Timer_7_TimerDuration_TimerDuration : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerDuration_TimerDuration <= X"00000001";
      else
         for j in  31 downto 0  loop
            if(wEn(156) = '1' and bitEnN(j) = '0') then
               field_rw_Timer_7_TimerDuration_TimerDuration(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_Timer_7_TimerDuration_TimerDuration;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerLatchedValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(157) <= (hit(157)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerLatchedValue(31 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_7_TimerLatchedValue(31 downto 0) <= regfile.Timer(7).TimerLatchedValue.TimerLatchedValue;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Timer_7_TimerStatus
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(158) <= (hit(158)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: TimerStatus(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(31 downto 29) <= regfile.Timer(7).TimerStatus.TimerStatus;


------------------------------------------------------------------------------------------
-- Field name: TimerStatus_Latched(2 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(28 downto 26) <= regfile.Timer(7).TimerStatus.TimerStatus_Latched;


------------------------------------------------------------------------------------------
-- Field name: TimerEndIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(17) <= field_rw_Timer_7_TimerStatus_TimerEndIntmaskn;
regfile.Timer(7).TimerStatus.TimerEndIntmaskn <= field_rw_Timer_7_TimerStatus_TimerEndIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerEndIntmaskn
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerEndIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerStatus_TimerEndIntmaskn <= '0';
      else
         if(wEn(158) = '1' and bitEnN(17) = '0') then
            field_rw_Timer_7_TimerStatus_TimerEndIntmaskn <= reg_writedata(17);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerEndIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerStartIntmaskn
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(16) <= field_rw_Timer_7_TimerStatus_TimerStartIntmaskn;
regfile.Timer(7).TimerStatus.TimerStartIntmaskn <= field_rw_Timer_7_TimerStatus_TimerStartIntmaskn;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerStartIntmaskn
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerStartIntmaskn : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerStatus_TimerStartIntmaskn <= '0';
      else
         if(wEn(158) = '1' and bitEnN(16) = '0') then
            field_rw_Timer_7_TimerStatus_TimerStartIntmaskn <= reg_writedata(16);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerStartIntmaskn;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchAndReset
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(10) <= field_rw_Timer_7_TimerStatus_TimerLatchAndReset;
regfile.Timer(7).TimerStatus.TimerLatchAndReset <= field_rw_Timer_7_TimerStatus_TimerLatchAndReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerLatchAndReset
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerLatchAndReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerStatus_TimerLatchAndReset <= '0';
      else
         if(wEn(158) = '1' and bitEnN(10) = '0') then
            field_rw_Timer_7_TimerStatus_TimerLatchAndReset <= reg_writedata(10);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerLatchAndReset;

------------------------------------------------------------------------------------------
-- Field name: TimerLatchValue
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(9) <= '0';
regfile.Timer(7).TimerStatus.TimerLatchValue <= field_wautoclr_Timer_7_TimerStatus_TimerLatchValue;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerLatchValue
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerLatchValue : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_7_TimerStatus_TimerLatchValue <= '0';
      else
         if(wEn(158) = '1' and bitEnN(9) = '0') then
            field_wautoclr_Timer_7_TimerStatus_TimerLatchValue <= reg_writedata(9);
         else
            field_wautoclr_Timer_7_TimerStatus_TimerLatchValue <= '0';
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerLatchValue;

------------------------------------------------------------------------------------------
-- Field name: TimerCntrReset
-- Field type: WAUTOCLR
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(8) <= '0';
regfile.Timer(7).TimerStatus.TimerCntrReset <= field_wautoclr_Timer_7_TimerStatus_TimerCntrReset;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerCntrReset
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerCntrReset : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_wautoclr_Timer_7_TimerStatus_TimerCntrReset <= '0';
      else
         if(wEn(158) = '1' and bitEnN(8) = '0') then
            field_wautoclr_Timer_7_TimerStatus_TimerCntrReset <= reg_writedata(8);
         else
            field_wautoclr_Timer_7_TimerStatus_TimerCntrReset <= '0';
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerCntrReset;

------------------------------------------------------------------------------------------
-- Field name: TimerInversion
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(1) <= field_rw_Timer_7_TimerStatus_TimerInversion;
regfile.Timer(7).TimerStatus.TimerInversion <= field_rw_Timer_7_TimerStatus_TimerInversion;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerInversion
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerInversion : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerStatus_TimerInversion <= '0';
      else
         if(wEn(158) = '1' and bitEnN(1) = '0') then
            field_rw_Timer_7_TimerStatus_TimerInversion <= reg_writedata(1);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerInversion;

------------------------------------------------------------------------------------------
-- Field name: TimerEnable
-- Field type: RW
------------------------------------------------------------------------------------------
rb_Timer_7_TimerStatus(0) <= field_rw_Timer_7_TimerStatus_TimerEnable;
regfile.Timer(7).TimerStatus.TimerEnable <= field_rw_Timer_7_TimerStatus_TimerEnable;


------------------------------------------------------------------------------------------
-- Process: P_Timer_7_TimerStatus_TimerEnable
------------------------------------------------------------------------------------------
P_Timer_7_TimerStatus_TimerEnable : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_Timer_7_TimerStatus_TimerEnable <= '0';
      else
         if(wEn(158) = '1' and bitEnN(0) = '0') then
            field_rw_Timer_7_TimerStatus_TimerEnable <= reg_writedata(0);
         end if;
      end if;
   end if;
end process P_Timer_7_TimerStatus_TimerEnable;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Microblaze_CAPABILITIES_MICRO
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(159) <= (hit(159)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MICRO_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Microblaze_CAPABILITIES_MICRO(31 downto 24) <= std_logic_vector(to_unsigned(integer(112),8));
regfile.Microblaze.CAPABILITIES_MICRO.MICRO_ID <= rb_Microblaze_CAPABILITIES_MICRO(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Microblaze_CAPABILITIES_MICRO(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.Microblaze.CAPABILITIES_MICRO.FEATURE_REV <= rb_Microblaze_CAPABILITIES_MICRO(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: Intnum
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Microblaze_CAPABILITIES_MICRO(19 downto 15) <= std_logic_vector(to_unsigned(integer(6),5));
regfile.Microblaze.CAPABILITIES_MICRO.Intnum <= rb_Microblaze_CAPABILITIES_MICRO(19 downto 15);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Microblaze_ProdCons_0
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(160) <= (hit(160)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MemorySize
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Microblaze_ProdCons_0(24 downto 20) <= std_logic_vector(to_unsigned(integer(12),5));
regfile.Microblaze.ProdCons(0).MemorySize <= rb_Microblaze_ProdCons_0(24 downto 20);


------------------------------------------------------------------------------------------
-- Field name: Offset(19 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Microblaze_ProdCons_0(19 downto 0) <= regfile.Microblaze.ProdCons(0).Offset;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: Microblaze_ProdCons_1
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(161) <= (hit(161)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: MemorySize
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_Microblaze_ProdCons_1(24 downto 20) <= std_logic_vector(to_unsigned(integer(12),5));
regfile.Microblaze.ProdCons(1).MemorySize <= rb_Microblaze_ProdCons_1(24 downto 20);


------------------------------------------------------------------------------------------
-- Field name: Offset(19 downto 0)
-- Field type: RO
------------------------------------------------------------------------------------------
rb_Microblaze_ProdCons_1(19 downto 0) <= regfile.Microblaze.ProdCons(1).Offset;




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: AnalogOutput_CAPABILITIES_ANA_OUT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(162) <= (hit(162)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: ANA_OUT_ID
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_AnalogOutput_CAPABILITIES_ANA_OUT(31 downto 24) <= std_logic_vector(to_unsigned(integer(103),8));
regfile.AnalogOutput.CAPABILITIES_ANA_OUT.ANA_OUT_ID <= rb_AnalogOutput_CAPABILITIES_ANA_OUT(31 downto 24);


------------------------------------------------------------------------------------------
-- Field name: FEATURE_REV
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_AnalogOutput_CAPABILITIES_ANA_OUT(23 downto 20) <= std_logic_vector(to_unsigned(integer(0),4));
regfile.AnalogOutput.CAPABILITIES_ANA_OUT.FEATURE_REV <= rb_AnalogOutput_CAPABILITIES_ANA_OUT(23 downto 20);


------------------------------------------------------------------------------------------
-- Field name: NB_OUTPUTS
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_AnalogOutput_CAPABILITIES_ANA_OUT(15 downto 12) <= std_logic_vector(to_unsigned(integer(1),4));
regfile.AnalogOutput.CAPABILITIES_ANA_OUT.NB_OUTPUTS <= rb_AnalogOutput_CAPABILITIES_ANA_OUT(15 downto 12);




------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: AnalogOutput_OutputValue
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(163) <= (hit(163)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: OutputVal(7 downto 0)
-- Field type: RW
------------------------------------------------------------------------------------------
rb_AnalogOutput_OutputValue(7 downto 0) <= field_rw_AnalogOutput_OutputValue_OutputVal(7 downto 0);
regfile.AnalogOutput.OutputValue.OutputVal <= field_rw_AnalogOutput_OutputValue_OutputVal(7 downto 0);


------------------------------------------------------------------------------------------
-- Process: P_AnalogOutput_OutputValue_OutputVal
------------------------------------------------------------------------------------------
P_AnalogOutput_OutputValue_OutputVal : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         field_rw_AnalogOutput_OutputValue_OutputVal <= std_logic_vector(to_unsigned(integer(0),8));
      else
         for j in  7 downto 0  loop
            if(wEn(163) = '1' and bitEnN(j) = '0') then
               field_rw_AnalogOutput_OutputValue_OutputVal(j-0) <= reg_writedata(j);
            end if;
         end loop;
      end if;
   end if;
end process P_AnalogOutput_OutputValue_OutputVal;



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Register name: EOFM_EOFM
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
wEn(164) <= (hit(164)) and (reg_write);

------------------------------------------------------------------------------------------
-- Field name: EOFM
-- Field type: STATIC
------------------------------------------------------------------------------------------
rb_EOFM_EOFM(31 downto 24) <= std_logic_vector(to_unsigned(integer(0),8));
regfile.EOFM.EOFM.EOFM <= rb_EOFM_EOFM(31 downto 24);


------------------------------------------------------------------------------------------
-- External section: ProdCons
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_addr_0
------------------------------------------------------------------------------------------
P_ext_ProdCons_addr_0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_addr_0 <= (others=>'0');
      else
         if (reg_write = '1' or reg_read = '1') then
            ext_ProdCons_addr_0 <= reg_addr(12 downto 2);
         end if;
      end if;
   end if;
end process P_ext_ProdCons_addr_0;


------------------------------------------------------------------------------------------
-- Process: P_ext_writeBeN
------------------------------------------------------------------------------------------
P_ext_writeBeN : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_writeBeN <= (others=>'0');
      else
         if (reg_write = '1') then
            ext_writeBeN <= reg_beN;
         end if;
      end if;
   end if;
end process P_ext_writeBeN;


------------------------------------------------------------------------------------------
-- Process: P_ext_writeData
------------------------------------------------------------------------------------------
P_ext_writeData : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_writeData <= (others=>'0');
      else
         if (reg_write = '1') then
            ext_writeData <= reg_writedata;
         end if;
      end if;
   end if;
end process P_ext_writeData;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_writeEn_0
------------------------------------------------------------------------------------------
P_ext_ProdCons_writeEn_0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_writeEn_0 <= '0';
      else
         ext_ProdCons_writeEn_0 <= hit(165) and reg_write;
      end if;
   end if;
end process P_ext_ProdCons_writeEn_0;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readEn_0
------------------------------------------------------------------------------------------
P_ext_ProdCons_readEn_0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readEn_0 <= '0';
      else
         ext_ProdCons_readEn_0 <= hit(165) and reg_read;
      end if;
   end if;
end process P_ext_ProdCons_readEn_0;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readDataValid_0_pipeline
------------------------------------------------------------------------------------------
P_ext_ProdCons_readDataValid_0_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readDataValid_0_FF <= '0';
      else
         ext_ProdCons_readDataValid_0_FF <= ext_ProdCons_readDataValid_0;
      end if;
   end if;
end process P_ext_ProdCons_readDataValid_0_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readData_0_pipeline
------------------------------------------------------------------------------------------
P_ext_ProdCons_readData_0_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readData_0_FF <= (others=>'0');
      else
         ext_ProdCons_readData_0_FF <= ext_ProdCons_readData_0;
      end if;
   end if;
end process P_ext_ProdCons_readData_0_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readPending_0
------------------------------------------------------------------------------------------
P_ext_ProdCons_readPending_0 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readPending_0 <= '0';
      else
         if (reg_read = '1' and hit(165) = '1') then
            ext_ProdCons_readPending_0 <= '1';

         elsif (ext_ProdCons_readDataValid_0_FF = '1') then
            ext_ProdCons_readPending_0 <= '0';

         end if;
      end if;
   end if;
end process P_ext_ProdCons_readPending_0;


------------------------------------------------------------------------------------------
-- External section: ProdCons
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_addr_1
------------------------------------------------------------------------------------------
P_ext_ProdCons_addr_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_addr_1 <= (others=>'0');
      else
         if (reg_write = '1' or reg_read = '1') then
            ext_ProdCons_addr_1 <= reg_addr(12 downto 2);
         end if;
      end if;
   end if;
end process P_ext_ProdCons_addr_1;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_writeEn_1
------------------------------------------------------------------------------------------
P_ext_ProdCons_writeEn_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_writeEn_1 <= '0';
      else
         ext_ProdCons_writeEn_1 <= hit(166) and reg_write;
      end if;
   end if;
end process P_ext_ProdCons_writeEn_1;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readEn_1
------------------------------------------------------------------------------------------
P_ext_ProdCons_readEn_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readEn_1 <= '0';
      else
         ext_ProdCons_readEn_1 <= hit(166) and reg_read;
      end if;
   end if;
end process P_ext_ProdCons_readEn_1;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readDataValid_1_pipeline
------------------------------------------------------------------------------------------
P_ext_ProdCons_readDataValid_1_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readDataValid_1_FF <= '0';
      else
         ext_ProdCons_readDataValid_1_FF <= ext_ProdCons_readDataValid_1;
      end if;
   end if;
end process P_ext_ProdCons_readDataValid_1_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readData_1_pipeline
------------------------------------------------------------------------------------------
P_ext_ProdCons_readData_1_pipeline : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readData_1_FF <= (others=>'0');
      else
         ext_ProdCons_readData_1_FF <= ext_ProdCons_readData_1;
      end if;
   end if;
end process P_ext_ProdCons_readData_1_pipeline;


------------------------------------------------------------------------------------------
-- Process: P_ext_ProdCons_readPending_1
------------------------------------------------------------------------------------------
P_ext_ProdCons_readPending_1 : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         ext_ProdCons_readPending_1 <= '0';
      else
         if (reg_read = '1' and hit(166) = '1') then
            ext_ProdCons_readPending_1 <= '1';

         elsif (ext_ProdCons_readDataValid_1_FF = '1') then
            ext_ProdCons_readPending_1 <= '0';

         end if;
      end if;
   end if;
end process P_ext_ProdCons_readPending_1;


------------------------------------------------------------------------------------------
-- Process: P_reg_wait
------------------------------------------------------------------------------------------
P_reg_wait : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_wait <= '0';
      else
         -- Wait signal is asserted
         if(reg_read = '1' and ldData = '0') then
            reg_wait <= '1';
         -- Wait signal is deasserted
         elsif(ldData = '1') then
            reg_wait <= '0';
         end if;
      end if;
   end if;
end process P_reg_wait;


------------------------------------------------------------------------------------------
-- Process: P_reg_readdatavalid
------------------------------------------------------------------------------------------
P_reg_readdatavalid : process(sysclk)
begin
   if (rising_edge(sysclk)) then
      if (resetN = '0') then
         reg_readdatavalid <= '0';
      else
         reg_readdatavalid <= ldData;
      end if;
   end if;
end process P_reg_readdatavalid;


ldData <= (reg_read and not(hit(165) or hit(166)))  or (ext_ProdCons_readPending_0 and ext_ProdCons_readDataValid_0_FF) or (ext_ProdCons_readPending_1 and ext_ProdCons_readDataValid_1_FF);

end rtl;

