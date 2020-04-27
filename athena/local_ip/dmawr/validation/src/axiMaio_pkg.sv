/****************************************************************************
 * maiopack.sv
 ****************************************************************************/

/**
 * Package: maiopack
 *
 * TODO: Add package documentation
 */

package axiMaio_pkg;
	parameter TOE_MAX_LIST_DEPTH = 1024;

	import core_pkg::*;
	import network_pkg::*;
	import gev_pkg::*;
	import driver_pkg::*;
	import scoreboard_pkg::*;
	import registerfile_pkg::*;

//
//	static int K_Info_tag_ADDR                               = 'h0;
//	static int K_Info_fid_ADDR                               = 'h4;
//	static int K_Info_version_ADDR                           = 'h8;
//	static int K_Info_capability_ADDR                        = 'hc;
//	static int K_Info_scratchpad_ADDR                        = 'h10;
//	static int K_Runtime_Ctrl_ADDR                           = 'h40;
//	static int K_Runtime_Soft_ADDR                           = 'h44;
//	static int K_IO_0_CAPABILITIES_IO_ADDR                   = 'h100;
//	static int K_IO_0_IO_PIN_ADDR                            = 'h104;
//	static int K_IO_0_IO_OUT_ADDR                            = 'h108;
//	static int K_IO_0_IO_DIR_ADDR                            = 'h10c;
//	static int K_IO_0_IO_EDGE_DETECT_ADDR                    = 'h110;
//	static int K_IO_1_CAPABILITIES_IO_ADDR                   = 'h180;
//	static int K_IO_1_IO_PIN_ADDR                            = 'h184;
//	static int K_IO_1_IO_OUT_ADDR                            = 'h188;
//	static int K_IO_1_IO_DIR_ADDR                            = 'h18c;
//	static int K_IO_1_IO_EDGE_DETECT_ADDR                    = 'h190;
//	static int K_Quadrature_0_CAPABILITIES_QUAD_ADDR         = 'h200;
//	static int K_Quadrature_0_PositionReset_ADDR             = 'h204;
//	static int K_Quadrature_0_DecoderInput_ADDR              = 'h208;
//	static int K_Quadrature_0_DecoderCfg_ADDR                = 'h20c;
//	static int K_Quadrature_0_DecoderPosTrigger_ADDR         = 'h210;
//	static int K_Quadrature_1_CAPABILITIES_QUAD_ADDR         = 'h280;
//	static int K_Quadrature_1_PositionReset_ADDR             = 'h284;
//	static int K_Quadrature_1_DecoderInput_ADDR              = 'h288;
//	static int K_Quadrature_1_DecoderCfg_ADDR                = 'h28c;
//	static int K_Quadrature_1_DecoderPosTrigger_ADDR         = 'h290;
//	static int K_TickTable_0_CAPABILITIES_TICKTBL_ADDR       = 'h300;
//	static int K_TickTable_0_CAPABILITIES_EXT1_ADDR          = 'h304;
//	static int K_TickTable_0_TickTableClockPeriod_ADDR       = 'h308;
//	static int K_TickTable_0_TickConfig_ADDR                 = 'h30c;
//	static int K_TickTable_0_CurrentStampLatched_ADDR        = 'h310;
//	static int K_TickTable_0_WriteTime_ADDR                  = 'h314;
//	static int K_TickTable_0_WriteCommand_ADDR               = 'h318;
//	static int K_TickTable_0_LatchIntStat_ADDR               = 'h31c;
//	static int K_TickTable_0_InputStamp_0_ADDR               = 'h320;
//	static int K_TickTable_0_InputStamp_1_ADDR               = 'h324;
//	static int K_TickTable_0_InputStamp_2_ADDR               = 'h328;
//	static int K_TickTable_0_InputStamp_3_ADDR               = 'h32c;
//	static int K_TickTable_0_reserved_for_extra_latch_0_ADDR = 'h330;
//	static int K_TickTable_0_reserved_for_extra_latch_1_ADDR = 'h334;
//	static int K_TickTable_0_reserved_for_extra_latch_2_ADDR = 'h338;
//	static int K_TickTable_0_reserved_for_extra_latch_3_ADDR = 'h33c;
//	static int K_TickTable_0_reserved_for_extra_latch_4_ADDR = 'h340;
//	static int K_TickTable_0_reserved_for_extra_latch_5_ADDR = 'h344;
//	static int K_TickTable_0_reserved_for_extra_latch_6_ADDR = 'h348;
//	static int K_TickTable_0_reserved_for_extra_latch_7_ADDR = 'h34c;
//	static int K_TickTable_0_InputStampLatched_0_ADDR        = 'h350;
//	static int K_TickTable_0_InputStampLatched_1_ADDR        = 'h354;
//	static int K_TickTable_0_InputStampLatched_2_ADDR        = 'h358;
//	static int K_TickTable_0_InputStampLatched_3_ADDR        = 'h35c;
//	static int K_TickTable_1_CAPABILITIES_TICKTBL_ADDR       = 'h380;
//	static int K_TickTable_1_CAPABILITIES_EXT1_ADDR          = 'h384;
//	static int K_TickTable_1_TickTableClockPeriod_ADDR       = 'h388;
//	static int K_TickTable_1_TickConfig_ADDR                 = 'h38c;
//	static int K_TickTable_1_CurrentStampLatched_ADDR        = 'h390;
//	static int K_TickTable_1_WriteTime_ADDR                  = 'h394;
//	static int K_TickTable_1_WriteCommand_ADDR               = 'h398;
//	static int K_TickTable_1_LatchIntStat_ADDR               = 'h39c;
//	static int K_TickTable_1_InputStamp_0_ADDR               = 'h3a0;
//	static int K_TickTable_1_InputStamp_1_ADDR               = 'h3a4;
//	static int K_TickTable_1_InputStamp_2_ADDR               = 'h3a8;
//	static int K_TickTable_1_InputStamp_3_ADDR               = 'h3ac;
//	static int K_TickTable_1_reserved_for_extra_latch_0_ADDR = 'h3b0;
//	static int K_TickTable_1_reserved_for_extra_latch_1_ADDR = 'h3b4;
//	static int K_TickTable_1_reserved_for_extra_latch_2_ADDR = 'h3b8;
//	static int K_TickTable_1_reserved_for_extra_latch_3_ADDR = 'h3bc;
//	static int K_TickTable_1_reserved_for_extra_latch_4_ADDR = 'h3c0;
//	static int K_TickTable_1_reserved_for_extra_latch_5_ADDR = 'h3c4;
//	static int K_TickTable_1_reserved_for_extra_latch_6_ADDR = 'h3c8;
//	static int K_TickTable_1_reserved_for_extra_latch_7_ADDR = 'h3cc;
//	static int K_TickTable_1_InputStampLatched_0_ADDR        = 'h3d0;
//	static int K_TickTable_1_InputStampLatched_1_ADDR        = 'h3d4;
//	static int K_TickTable_1_InputStampLatched_2_ADDR        = 'h3d8;
//	static int K_TickTable_1_InputStampLatched_3_ADDR        = 'h3dc;
//	static int K_InputConditioning_CAPABILITIES_INCOND_ADDR  = 'h400;
//	static int K_InputConditioning_InputConditioning_0_ADDR  = 'h404;
//	static int K_InputConditioning_InputConditioning_1_ADDR  = 'h408;
//	static int K_InputConditioning_InputConditioning_2_ADDR  = 'h40c;
//	static int K_InputConditioning_InputConditioning_3_ADDR  = 'h410;
//	static int K_InputConditioning_InputConditioning_4_ADDR  = 'h414;
//	static int K_InputConditioning_InputConditioning_5_ADDR  = 'h418;
//	static int K_InputConditioning_InputConditioning_6_ADDR  = 'h41c;
//	static int K_InputConditioning_InputConditioning_7_ADDR  = 'h420;
//	static int K_OutputConditioning_CAPABILITIES_OUTCOND_ADDR = 'h480;
//	static int K_OutputConditioning_OutputCond_0_ADDR        = 'h484;
//	static int K_OutputConditioning_OutputCond_1_ADDR        = 'h488;
//	static int K_OutputConditioning_OutputCond_2_ADDR        = 'h48c;
//	static int K_OutputConditioning_OutputCond_3_ADDR        = 'h490;
//	static int K_OutputConditioning_OutputCond_4_ADDR        = 'h494;
//	static int K_OutputConditioning_OutputCond_5_ADDR        = 'h498;
//	static int K_OutputConditioning_OutputCond_6_ADDR        = 'h49c;
//	static int K_OutputConditioning_OutputCond_7_ADDR        = 'h4a0;
//	static int K_OutputConditioning_Reserved_ADDR            = 'h4a4;
//	static int K_OutputConditioning_Output_Debounce_ADDR     = 'h4ac;
//	static int K_Timer_0_CAPABILITIES_TIMER_ADDR             = 'h500;
//	static int K_Timer_0_TimerClockPeriod_ADDR               = 'h504;
//	static int K_Timer_0_TimerTriggerArm_ADDR                = 'h508;
//	static int K_Timer_0_TimerClockSource_ADDR               = 'h50c;
//	static int K_Timer_0_TimerDelayValue_ADDR                = 'h510;
//	static int K_Timer_0_TimerDuration_ADDR                  = 'h514;
//	static int K_Timer_0_TimerLatchedValue_ADDR              = 'h518;
//	static int K_Timer_0_TimerStatus_ADDR                    = 'h51c;
//	static int K_Timer_1_CAPABILITIES_TIMER_ADDR             = 'h580;
//	static int K_Timer_1_TimerClockPeriod_ADDR               = 'h584;
//	static int K_Timer_1_TimerTriggerArm_ADDR                = 'h588;
//	static int K_Timer_1_TimerClockSource_ADDR               = 'h58c;
//	static int K_Timer_1_TimerDelayValue_ADDR                = 'h590;
//	static int K_Timer_1_TimerDuration_ADDR                  = 'h594;
//	static int K_Timer_1_TimerLatchedValue_ADDR              = 'h598;
//	static int K_Timer_1_TimerStatus_ADDR                    = 'h59c;
//	static int K_Timer_2_CAPABILITIES_TIMER_ADDR             = 'h600;
//	static int K_Timer_2_TimerClockPeriod_ADDR               = 'h604;
//	static int K_Timer_2_TimerTriggerArm_ADDR                = 'h608;
//	static int K_Timer_2_TimerClockSource_ADDR               = 'h60c;
//	static int K_Timer_2_TimerDelayValue_ADDR                = 'h610;
//	static int K_Timer_2_TimerDuration_ADDR                  = 'h614;
//	static int K_Timer_2_TimerLatchedValue_ADDR              = 'h618;
//	static int K_Timer_2_TimerStatus_ADDR                    = 'h61c;
//	static int K_Timer_3_CAPABILITIES_TIMER_ADDR             = 'h680;
//	static int K_Timer_3_TimerClockPeriod_ADDR               = 'h684;
//	static int K_Timer_3_TimerTriggerArm_ADDR                = 'h688;
//	static int K_Timer_3_TimerClockSource_ADDR               = 'h68c;
//	static int K_Timer_3_TimerDelayValue_ADDR                = 'h690;
//	static int K_Timer_3_TimerDuration_ADDR                  = 'h694;
//	static int K_Timer_3_TimerLatchedValue_ADDR              = 'h698;
//	static int K_Timer_3_TimerStatus_ADDR                    = 'h69c;
//	static int K_Timer_4_CAPABILITIES_TIMER_ADDR             = 'h700;
//	static int K_Timer_4_TimerClockPeriod_ADDR               = 'h704;
//	static int K_Timer_4_TimerTriggerArm_ADDR                = 'h708;
//	static int K_Timer_4_TimerClockSource_ADDR               = 'h70c;
//	static int K_Timer_4_TimerDelayValue_ADDR                = 'h710;
//	static int K_Timer_4_TimerDuration_ADDR                  = 'h714;
//	static int K_Timer_4_TimerLatchedValue_ADDR              = 'h718;
//	static int K_Timer_4_TimerStatus_ADDR                    = 'h71c;
//	static int K_Timer_5_CAPABILITIES_TIMER_ADDR             = 'h780;
//	static int K_Timer_5_TimerClockPeriod_ADDR               = 'h784;
//	static int K_Timer_5_TimerTriggerArm_ADDR                = 'h788;
//	static int K_Timer_5_TimerClockSource_ADDR               = 'h78c;
//	static int K_Timer_5_TimerDelayValue_ADDR                = 'h790;
//	static int K_Timer_5_TimerDuration_ADDR                  = 'h794;
//	static int K_Timer_5_TimerLatchedValue_ADDR              = 'h798;
//	static int K_Timer_5_TimerStatus_ADDR                    = 'h79c;
//	static int K_Timer_6_CAPABILITIES_TIMER_ADDR             = 'h800;
//	static int K_Timer_6_TimerClockPeriod_ADDR               = 'h804;
//	static int K_Timer_6_TimerTriggerArm_ADDR                = 'h808;
//	static int K_Timer_6_TimerClockSource_ADDR               = 'h80c;
//	static int K_Timer_6_TimerDelayValue_ADDR                = 'h810;
//	static int K_Timer_6_TimerDuration_ADDR                  = 'h814;
//	static int K_Timer_6_TimerLatchedValue_ADDR              = 'h818;
//	static int K_Timer_6_TimerStatus_ADDR                    = 'h81c;
//	static int K_Timer_7_CAPABILITIES_TIMER_ADDR             = 'h880;
//	static int K_Timer_7_TimerClockPeriod_ADDR               = 'h884;
//	static int K_Timer_7_TimerTriggerArm_ADDR                = 'h888;
//	static int K_Timer_7_TimerClockSource_ADDR               = 'h88c;
//	static int K_Timer_7_TimerDelayValue_ADDR                = 'h890;
//	static int K_Timer_7_TimerDuration_ADDR                  = 'h894;
//	static int K_Timer_7_TimerLatchedValue_ADDR              = 'h898;
//	static int K_Timer_7_TimerStatus_ADDR                    = 'h89c;
//	static int K_Timer_8_CAPABILITIES_TIMER_ADDR             = 'h900;
//	static int K_Timer_8_TimerClockPeriod_ADDR               = 'h904;
//	static int K_Timer_8_TimerTriggerArm_ADDR                = 'h908;
//	static int K_Timer_8_TimerClockSource_ADDR               = 'h90c;
//	static int K_Timer_8_TimerDelayValue_ADDR                = 'h910;
//	static int K_Timer_8_TimerDuration_ADDR                  = 'h914;
//	static int K_Timer_8_TimerLatchedValue_ADDR              = 'h918;
//	static int K_Timer_8_TimerStatus_ADDR                    = 'h91c;
//	static int K_Timer_9_CAPABILITIES_TIMER_ADDR             = 'h980;
//	static int K_Timer_9_TimerClockPeriod_ADDR               = 'h984;
//	static int K_Timer_9_TimerTriggerArm_ADDR                = 'h988;
//	static int K_Timer_9_TimerClockSource_ADDR               = 'h98c;
//	static int K_Timer_9_TimerDelayValue_ADDR                = 'h990;
//	static int K_Timer_9_TimerDuration_ADDR                  = 'h994;
//	static int K_Timer_9_TimerLatchedValue_ADDR              = 'h998;
//	static int K_Timer_9_TimerStatus_ADDR                    = 'h99c;
//	static int K_Timer_10_CAPABILITIES_TIMER_ADDR            = 'ha00;
//	static int K_Timer_10_TimerClockPeriod_ADDR              = 'ha04;
//	static int K_Timer_10_TimerTriggerArm_ADDR               = 'ha08;
//	static int K_Timer_10_TimerClockSource_ADDR              = 'ha0c;
//	static int K_Timer_10_TimerDelayValue_ADDR               = 'ha10;
//	static int K_Timer_10_TimerDuration_ADDR                 = 'ha14;
//	static int K_Timer_10_TimerLatchedValue_ADDR             = 'ha18;
//	static int K_Timer_10_TimerStatus_ADDR                   = 'ha1c;
//	static int K_Timer_11_CAPABILITIES_TIMER_ADDR            = 'ha80;
//	static int K_Timer_11_TimerClockPeriod_ADDR              = 'ha84;
//	static int K_Timer_11_TimerTriggerArm_ADDR               = 'ha88;
//	static int K_Timer_11_TimerClockSource_ADDR              = 'ha8c;
//	static int K_Timer_11_TimerDelayValue_ADDR               = 'ha90;
//	static int K_Timer_11_TimerDuration_ADDR                 = 'ha94;
//	static int K_Timer_11_TimerLatchedValue_ADDR             = 'ha98;
//	static int K_Timer_11_TimerStatus_ADDR                   = 'ha9c;
//	static int K_Timer_12_CAPABILITIES_TIMER_ADDR            = 'hb00;
//	static int K_Timer_12_TimerClockPeriod_ADDR              = 'hb04;
//	static int K_Timer_12_TimerTriggerArm_ADDR               = 'hb08;
//	static int K_Timer_12_TimerClockSource_ADDR              = 'hb0c;
//	static int K_Timer_12_TimerDelayValue_ADDR               = 'hb10;
//	static int K_Timer_12_TimerDuration_ADDR                 = 'hb14;
//	static int K_Timer_12_TimerLatchedValue_ADDR             = 'hb18;
//	static int K_Timer_12_TimerStatus_ADDR                   = 'hb1c;
//	static int K_Timer_13_CAPABILITIES_TIMER_ADDR            = 'hb80;
//	static int K_Timer_13_TimerClockPeriod_ADDR              = 'hb84;
//	static int K_Timer_13_TimerTriggerArm_ADDR               = 'hb88;
//	static int K_Timer_13_TimerClockSource_ADDR              = 'hb8c;
//	static int K_Timer_13_TimerDelayValue_ADDR               = 'hb90;
//	static int K_Timer_13_TimerDuration_ADDR                 = 'hb94;
//	static int K_Timer_13_TimerLatchedValue_ADDR             = 'hb98;
//	static int K_Timer_13_TimerStatus_ADDR                   = 'hb9c;
//	static int K_Timer_14_CAPABILITIES_TIMER_ADDR            = 'hc00;
//	static int K_Timer_14_TimerClockPeriod_ADDR              = 'hc04;
//	static int K_Timer_14_TimerTriggerArm_ADDR               = 'hc08;
//	static int K_Timer_14_TimerClockSource_ADDR              = 'hc0c;
//	static int K_Timer_14_TimerDelayValue_ADDR               = 'hc10;
//	static int K_Timer_14_TimerDuration_ADDR                 = 'hc14;
//	static int K_Timer_14_TimerLatchedValue_ADDR             = 'hc18;
//	static int K_Timer_14_TimerStatus_ADDR                   = 'hc1c;
//	static int K_Timer_15_CAPABILITIES_TIMER_ADDR            = 'hc80;
//	static int K_Timer_15_TimerClockPeriod_ADDR              = 'hc84;
//	static int K_Timer_15_TimerTriggerArm_ADDR               = 'hc88;
//	static int K_Timer_15_TimerClockSource_ADDR              = 'hc8c;
//	static int K_Timer_15_TimerDelayValue_ADDR               = 'hc90;
//	static int K_Timer_15_TimerDuration_ADDR                 = 'hc94;
//	static int K_Timer_15_TimerLatchedValue_ADDR             = 'hc98;
//	static int K_Timer_15_TimerStatus_ADDR                   = 'hc9c;
//	static int K_ToE_0_CAPABILITIES_ADDR                     = 'hd00;
//	static int K_ToE_0_Ctrl_ADDR                             = 'hd04;
//	static int K_ToE_0_EventEnable_0_ADDR                    = 'hd08;
//	static int K_ToE_0_EventEnable_1_ADDR                    = 'hd0c;
//	static int K_ToE_0_RequestIDRange_ADDR                   = 'hd10;
//	static int K_ToE_0_RequestID_ADDR                        = 'hd14;
//	static int K_ToE_0_EventCounter_ADDR                     = 'hd18;
//	static int K_ToE_0_EventOverrunCounter_ADDR              = 'hd1c;
//	static int K_ToE_0_Debug_ADDR                            = 'hd20;
//	static int K_ToE_1_CAPABILITIES_ADDR                     = 'hd80;
//	static int K_ToE_1_Ctrl_ADDR                             = 'hd84;
//	static int K_ToE_1_EventEnable_0_ADDR                    = 'hd88;
//	static int K_ToE_1_EventEnable_1_ADDR                    = 'hd8c;
//	static int K_ToE_1_RequestIDRange_ADDR                   = 'hd90;
//	static int K_ToE_1_RequestID_ADDR                        = 'hd94;
//	static int K_ToE_1_EventCounter_ADDR                     = 'hd98;
//	static int K_ToE_1_EventOverrunCounter_ADDR              = 'hd9c;
//	static int K_ToE_1_Debug_ADDR                            = 'hda0;
//	static int K_ToE_2_CAPABILITIES_ADDR                     = 'he00;
//	static int K_ToE_2_Ctrl_ADDR                             = 'he04;
//	static int K_ToE_2_EventEnable_0_ADDR                    = 'he08;
//	static int K_ToE_2_EventEnable_1_ADDR                    = 'he0c;
//	static int K_ToE_2_RequestIDRange_ADDR                   = 'he10;
//	static int K_ToE_2_RequestID_ADDR                        = 'he14;
//	static int K_ToE_2_EventCounter_ADDR                     = 'he18;
//	static int K_ToE_2_EventOverrunCounter_ADDR              = 'he1c;
//	static int K_ToE_2_Debug_ADDR                            = 'he20;
//	static int K_ToE_3_CAPABILITIES_ADDR                     = 'he80;
//	static int K_ToE_3_Ctrl_ADDR                             = 'he84;
//	static int K_ToE_3_EventEnable_0_ADDR                    = 'he88;
//	static int K_ToE_3_EventEnable_1_ADDR                    = 'he8c;
//	static int K_ToE_3_RequestIDRange_ADDR                   = 'he90;
//	static int K_ToE_3_RequestID_ADDR                        = 'he94;
//	static int K_ToE_3_EventCounter_ADDR                     = 'he98;
//	static int K_ToE_3_EventOverrunCounter_ADDR              = 'he9c;
//	static int K_ToE_3_Debug_ADDR                            = 'hea0;
//	static int K_LogBuffer_Ctrl_ADDR                         = 'hf00;
//	static int K_LogBuffer_Data_ADDR                         = 'hf04;
//	static int K_LogBuffer_IrqEn_ADDR                        = 'hf08;
//	static int K_LogBuffer_IrqStatus_ADDR                    = 'hf0c;
//




	typedef class Ctoe_list;
	typedef class Ctoe_buffer;
	typedef class Cdriver_axiMaio;
	typedef class CaxiMaio;
	typedef class CtoeController;
	typedef class Cmaio_registerfile;
	typedef class SEC_ToE;

	`include "Cdriver_axiMaio.svh"
	`include "Ctoe_list.svh"
	`include "Ctoe_buffer.svh"
	`include "CtoeController.svh"
	`include "CaxiMaio.svh"
	`include "../../misc/Cmaio_registerfile.sv"

endpackage : axiMaio_pkg








