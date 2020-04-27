package com.matrox.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;

/*****************************************************************************
 ** $HeadURL:$ $Revision:$ $Date:$
 **
 ** MODULE: PcieModelRegFile
 **
 ** DESCRIPTION: Register file of the PcieModelRegFile module
 **
 **
 ** THIS FILE WAS MANUALLY CREATED!!!.
 **
 ** FDK IDE Version: 4.4.0_beta4 Build ID: I20150507-1404
 **
 ** COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd. All Rights Reserved
 **
 *****************************************************************************/
public class CPcieModelRegFile extends CRegisterFile {

	public CPcieModelRegFile()
	{
		super("PcieModelRegFile", 12, 32, true);
		CRegister STRAP_VALUES_UBUS = new CRegister(this, "STRAP_VALUES_UBUS", "null", 0x026);
		CRegister LTSSM_RXELECIDLE_UBUS = new CRegister(this, "LTSSM_RXELECIDLE_UBUS", "null", 0x322);
		CRegister CFG_MODE_DATA_UBUS = new CRegister(this, "CFG_MODE_DATA_UBUS", "null", 0xB20);
		CRegister CFG_MODE_PKT_SZ_UBUS = new CRegister(this, "CFG_MODE_PKT_SZ_UBUS", "null", 0xB21);
		CRegister CFG_MODE_CFG_CONTINUE_UBUS = new CRegister(this, "CFG_MODE_CFG_CONTINUE_UBUS", "null", 0xB22);
		CRegister CFG_MODE_DATA_CHECKING_RD_UBUS = new CRegister(this, "CFG_MODE_DATA_CHECKING_RD_UBUS", "null", 0xB24);
		CRegister CFG_POLLING_MASK_UBUS = new CRegister(this, "CFG_POLLING_MASK_UBUS", "null", 0xB26);
		CRegister CFG_POLLING_DATA_UBUS = new CRegister(this, "CFG_POLLING_DATA_UBUS", "null", 0xB27);
		CRegister CFG_TLP_TD_UBUS = new CRegister(this, "CFG_TLP_TD_UBUS", "null", 0xB31);
		CRegister CFG_STP_SDP_SAME_SYM_TIME_UBUS = new CRegister(this, "CFG_STP_SDP_SAME_SYM_TIME_UBUS", "null", 0xB40);
		CRegister CFG_DLLP_INIT_FC_PH_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_PH_UBUS", "null", 0xB68);
		CRegister CFG_DLLP_INIT_FC_PD_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_PD_UBUS", "null", 0xB69);
		CRegister CFG_DLLP_INIT_FC_NPH_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_NPH_UBUS", "null", 0xB6A);
		CRegister CFG_DLLP_INIT_FC_NPD_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_NPD_UBUS", "null", 0xB6B);
		CRegister CFG_DLLP_INIT_FC_CPLH_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_CPLH_UBUS", "null", 0xB6C);
		CRegister CFG_DLLP_INIT_FC_CPLD_UBUS = new CRegister(this, "CFG_DLLP_INIT_FC_CPLD_UBUS", "null", 0xB6D);
		CRegister CFG_PL_SKIP_FREQUENCY_UBUS = new CRegister(this, "CFG_PL_SKIP_FREQUENCY_UBUS", "null", 0xB87);
		CRegister CFG_PL_PIPE_DECODE_ERROR_UBUS = new CRegister(this, "CFG_PL_PIPE_DECODE_ERROR_UBUS", "null", 0xB89);
		CRegister CFG_PL_PIPE_BUFFER_OVERFLOW_UBUS = new CRegister(this, "CFG_PL_PIPE_BUFFER_OVERFLOW_UBUS", "null", 0xB8A);
		CRegister CFG_PL_PIPE_BUFFER_UNDERFLOW_UBUS = new CRegister(this, "CFG_PL_PIPE_BUFFER_UNDERFLOW_UBUS", "null", 0xB8B);
		CRegister CFG_PL_PIPE_DISPARITY_ERROR_UBUS = new CRegister(this, "CFG_PL_PIPE_DISPARITY_ERROR_UBUS", "null", 0xB8C);
		CRegister CFG_PL_PIPE_ADD_SKP_UBUS = new CRegister(this, "CFG_PL_PIPE_ADD_SKP_UBUS", "null", 0xB8D);
		CRegister CFG_PL_PIPE_DEL_SKP_UBUS = new CRegister(this, "CFG_PL_PIPE_DEL_SKP_UBUS", "null", 0xB8E);
		CRegister CFG_CPL_ORDER_UBUS = new CRegister(this, "CFG_CPL_ORDER_UBUS", "null", 0xB93);
		CRegister CFG_CPL_TD_UBUS = new CRegister(this, "CFG_CPL_TD_UBUS", "null", 0xB95);
		CRegister CFG_ACK_FROM_REQ_UBUS = new CRegister(this, "CFG_ACK_FROM_REQ_UBUS", "null", 0xBA1);
		CRegister CFG_REQ_2CPL_UBUS = new CRegister(this, "CFG_REQ_2CPL_UBUS", "null", 0xBA2);
		CRegister CFG_MEM_SPACE_ADDRESS_HIGH_UBUS = new CRegister(this, "CFG_MEM_SPACE_ADDRESS_HIGH_UBUS", "null", 0xBBC);
		CRegister CFG_MEM_SPACE_ADDRESS_LOW_UBUS = new CRegister(this, "CFG_MEM_SPACE_ADDRESS_LOW_UBUS", "null", 0xBBD);
		CRegister CFG_MEM_SPACE_DATA_UBUS = new CRegister(this, "CFG_MEM_SPACE_DATA_UBUS", "null", 0xBC0);
		CRegister CFG_PL_GO2RECOVERY_UBUS = new CRegister(this, "CFG_PL_GO2RECOVERY_UBUS", "null", 0xBCA);
		CRegister CFG_PL_SETSPEED_UBUS = new CRegister(this, "CFG_PL_SETSPEED_UBUS", "null", 0xBCB);
		CRegister CFG_MEM_DUMP_UBUS = new CRegister(this, "CFG_MEM_DUMP_UBUS", "null", 0xBD9);
		CRegister CFG_READ_MEM_SPACE_ADDRESS_HIGH_UBUS = new CRegister(this, "CFG_READ_MEM_SPACE_ADDRESS_HIGH_UBUS", "null", 0xBDB);
		CRegister CFG_READ_MEM_SPACE_ADDRESS_LOW_UBUS = new CRegister(this, "CFG_READ_MEM_SPACE_ADDRESS_LOW_UBUS", "null", 0xBDC);
		CRegister CFG_READ_MEM_SPACE_DATA_UBUS = new CRegister(this, "CFG_READ_MEM_SPACE_DATA_UBUS", "null", 0xBDD);
		CRegister RUL_PL_END_WITHOUT_PACKET_UBUS = new CRegister(this, "RUL_PL_END_WITHOUT_PACKET_UBUS ", "null", 0xDC1);
		CRegister CFG_TLP_MSG_CODE_UBUS = new CRegister(this, "CFG_TLP_MSG_CODE_UBUS", "null", 0xB38);
		CRegister CFG_TLP_MSG_ROUTING_UBUS = new CRegister(this, "CFG_TLP_MSG_ROUTING_UBUS", "null", 0xB39);
		CRegister CFG_TLP_MSG_VENDOR_DEF_UBUS = new CRegister(this, "CFG_TLP_MSG_VENDOR_DEF_UBUS", "null", 0xB3A);
		CRegister CFG_TLP_LDW_BE_UBUS = new CRegister(this, "CFG_TLP_LDW_BE_UBUS", "null", 0xB36);
		CRegister CFG_TLP_FDW_BE_UBUS = new CRegister(this, "CFG_TLP_FDW_BE_UBUS", "null", 0xB37);
		CRegister CFG_TLP_EP_UBUS = new CRegister(this, "CFG_TLP_EP_UBUS", "null", 0xB32);
		CRegister CFG_TLP_CPL_STATUS_UBUS = new CRegister(this, "CFG_TLP_CPL_STATUS_UBUS", "null", 0xB51);
		CRegister CFG_TLP_CPL_BCM_UBUS = new CRegister(this, "CFG_TLP_CPL_BCM_UBUS", "null", 0xB52);
		CRegister CFG_TLP_CPL_LEN_UBUS = new CRegister(this, "CFG_TLP_CPL_LEN_UBUS", "null", 0xB53);
		CRegister CFG_TLP_CPL_RIDTAG_UBUS = new CRegister(this, "CFG_TLP_CPL_RIDTAG_UBUS", "null", 0xB50);
		CRegister CFG_CPL_TIMEOUT_COUNT_UBUS = new CRegister(this, "CFG_CPL_TIMEOUT_COUNT_UBUS", "null", 0xB98);

		// UBUS REGISTERS NSYS
		// NameIn BaseAddressIn NbrFieldIn WriteMaskIn ReadMaskIn
		CRegister CL_BUS_CONTROL_UBUS = new CRegister(this, "CL_BUS_CONTROL_UBUS", "null", 0x084);
		CRegister TB_RESET_UBUS = new CRegister(this, "TB_RESET_UBUS", "null", 0x000);
		CRegister TB_POLL_MASK_UBUS = new CRegister(this, "TB_POLL_MASK_UBUS", "null", 0x006);
		CRegister TB_READ_MASK_UBUS = new CRegister(this, "TB_READ_MASK_UBUS", "null", 0x007);
		CRegister TB_POLL_TIMER_LIMIT_UBUS = new CRegister(this, "TB_POLL_TIMER_LIMIT_UBUS", "null", 0x00A);
		CRegister PKT_CMD_UBUS = new CRegister(this, "PKT_CMD_UBUS", "null", 0xB00);
		CRegister PKT_ADDR_HIGH_UBUS = new CRegister(this, "PKT_ADDR_HIGH_UBUS", "null", 0xB01);
		CRegister PKT_ADDR_LOW_UBUS = new CRegister(this, "PKT_ADDR_LOW_UBUS", "null", 0xB02);
		CRegister PKT_BYTE_COUNT_UBUS = new CRegister(this, "PKT_BYTE_COUNT_UBUS", "null", 0xB03);
		CRegister PKT_DATA_UBUS = new CRegister(this, "PKT_DATA_UBUS", "null", 0xB06);

		//Add register instances in the register file
		super.getChildrenList().add(STRAP_VALUES_UBUS);
		super.getChildrenList().add(LTSSM_RXELECIDLE_UBUS);
		super.getChildrenList().add(CFG_MODE_DATA_UBUS);
		super.getChildrenList().add(CFG_MODE_PKT_SZ_UBUS);
		super.getChildrenList().add(CFG_MODE_CFG_CONTINUE_UBUS);
		super.getChildrenList().add(CFG_MODE_DATA_CHECKING_RD_UBUS);
		super.getChildrenList().add(CFG_POLLING_MASK_UBUS);
		super.getChildrenList().add(CFG_POLLING_DATA_UBUS);
		super.getChildrenList().add(CFG_TLP_TD_UBUS);
		super.getChildrenList().add(CFG_STP_SDP_SAME_SYM_TIME_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_PH_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_PD_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_NPH_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_NPD_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_CPLH_UBUS);
		super.getChildrenList().add(CFG_DLLP_INIT_FC_CPLD_UBUS);
		super.getChildrenList().add(CFG_PL_SKIP_FREQUENCY_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_DECODE_ERROR_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_BUFFER_OVERFLOW_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_BUFFER_UNDERFLOW_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_DISPARITY_ERROR_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_ADD_SKP_UBUS);
		super.getChildrenList().add(CFG_PL_PIPE_DEL_SKP_UBUS);
		super.getChildrenList().add(CFG_CPL_ORDER_UBUS);
		super.getChildrenList().add(CFG_CPL_TD_UBUS);
		super.getChildrenList().add(CFG_ACK_FROM_REQ_UBUS);
		super.getChildrenList().add(CFG_REQ_2CPL_UBUS);
		super.getChildrenList().add(CFG_MEM_SPACE_ADDRESS_HIGH_UBUS);
		super.getChildrenList().add(CFG_MEM_SPACE_ADDRESS_LOW_UBUS);
		super.getChildrenList().add(CFG_MEM_SPACE_DATA_UBUS);
		super.getChildrenList().add(CFG_PL_GO2RECOVERY_UBUS);
		super.getChildrenList().add(CFG_PL_SETSPEED_UBUS);
		super.getChildrenList().add(CFG_MEM_DUMP_UBUS);
		super.getChildrenList().add(CFG_READ_MEM_SPACE_ADDRESS_HIGH_UBUS);
		super.getChildrenList().add(CFG_READ_MEM_SPACE_ADDRESS_LOW_UBUS);
		super.getChildrenList().add(CFG_READ_MEM_SPACE_DATA_UBUS);
		super.getChildrenList().add(RUL_PL_END_WITHOUT_PACKET_UBUS);
		super.getChildrenList().add(CFG_TLP_MSG_CODE_UBUS);
		super.getChildrenList().add(CFG_TLP_MSG_ROUTING_UBUS);
		super.getChildrenList().add(CFG_TLP_MSG_VENDOR_DEF_UBUS);
		super.getChildrenList().add(CFG_TLP_LDW_BE_UBUS);
		super.getChildrenList().add(CFG_TLP_FDW_BE_UBUS);
		super.getChildrenList().add(CFG_TLP_EP_UBUS);
		super.getChildrenList().add(CFG_TLP_CPL_STATUS_UBUS);
		super.getChildrenList().add(CFG_TLP_CPL_BCM_UBUS);
		super.getChildrenList().add(CFG_TLP_CPL_LEN_UBUS);
		super.getChildrenList().add(CFG_TLP_CPL_RIDTAG_UBUS);
		super.getChildrenList().add(CFG_CPL_TIMEOUT_COUNT_UBUS);
		super.getChildrenList().add(CL_BUS_CONTROL_UBUS);
		super.getChildrenList().add(TB_RESET_UBUS);
		super.getChildrenList().add(TB_POLL_MASK_UBUS);
		super.getChildrenList().add(TB_READ_MASK_UBUS);
		super.getChildrenList().add(TB_POLL_TIMER_LIMIT_UBUS);
		super.getChildrenList().add(PKT_CMD_UBUS);
		super.getChildrenList().add(PKT_ADDR_HIGH_UBUS);
		super.getChildrenList().add(PKT_ADDR_LOW_UBUS);
		super.getChildrenList().add(PKT_BYTE_COUNT_UBUS);
		super.getChildrenList().add(PKT_DATA_UBUS);

		// Declare field of each register
		STRAP_VALUES_UBUS.addField(new CField(STRAP_VALUES_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		LTSSM_RXELECIDLE_UBUS.addField(new CField(LTSSM_RXELECIDLE_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MODE_DATA_UBUS.addField(new CField(CFG_MODE_DATA_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MODE_PKT_SZ_UBUS.addField(new CField(CFG_MODE_PKT_SZ_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MODE_CFG_CONTINUE_UBUS.addField(new CField(CFG_MODE_CFG_CONTINUE_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MODE_DATA_CHECKING_RD_UBUS.addField(new CField(CFG_MODE_DATA_CHECKING_RD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_POLLING_MASK_UBUS.addField(new CField(CFG_POLLING_MASK_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_POLLING_DATA_UBUS.addField(new CField(CFG_POLLING_DATA_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_TD_UBUS.addField(new CField(CFG_TLP_TD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_STP_SDP_SAME_SYM_TIME_UBUS.addField(new CField(CFG_STP_SDP_SAME_SYM_TIME_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_PH_UBUS.addField(new CField(CFG_DLLP_INIT_FC_PH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_PD_UBUS.addField(new CField(CFG_DLLP_INIT_FC_PD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_NPH_UBUS.addField(new CField(CFG_DLLP_INIT_FC_NPH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_NPD_UBUS.addField(new CField(CFG_DLLP_INIT_FC_NPD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_CPLH_UBUS.addField(new CField(CFG_DLLP_INIT_FC_CPLH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_DLLP_INIT_FC_CPLD_UBUS.addField(new CField(CFG_DLLP_INIT_FC_CPLD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_SKIP_FREQUENCY_UBUS.addField(new CField(CFG_PL_SKIP_FREQUENCY_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_DECODE_ERROR_UBUS.addField(new CField(CFG_PL_PIPE_DECODE_ERROR_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_BUFFER_OVERFLOW_UBUS.addField(new CField(CFG_PL_PIPE_BUFFER_OVERFLOW_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_BUFFER_UNDERFLOW_UBUS.addField(new CField(CFG_PL_PIPE_BUFFER_UNDERFLOW_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_DISPARITY_ERROR_UBUS.addField(new CField(CFG_PL_PIPE_DISPARITY_ERROR_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_ADD_SKP_UBUS.addField(new CField(CFG_PL_PIPE_ADD_SKP_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_PIPE_DEL_SKP_UBUS.addField(new CField(CFG_PL_PIPE_DEL_SKP_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_CPL_ORDER_UBUS.addField(new CField(CFG_CPL_ORDER_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_CPL_TD_UBUS.addField(new CField(CFG_CPL_TD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_ACK_FROM_REQ_UBUS.addField(new CField(CFG_ACK_FROM_REQ_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_REQ_2CPL_UBUS.addField(new CField(CFG_REQ_2CPL_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MEM_SPACE_ADDRESS_HIGH_UBUS.addField(new CField(CFG_MEM_SPACE_ADDRESS_HIGH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MEM_SPACE_ADDRESS_LOW_UBUS.addField(new CField(CFG_MEM_SPACE_ADDRESS_LOW_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MEM_SPACE_DATA_UBUS.addField(new CField(CFG_MEM_SPACE_DATA_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_GO2RECOVERY_UBUS.addField(new CField(CFG_PL_GO2RECOVERY_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_PL_SETSPEED_UBUS.addField(new CField(CFG_PL_SETSPEED_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_MEM_DUMP_UBUS.addField(new CField(CFG_MEM_DUMP_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_READ_MEM_SPACE_ADDRESS_HIGH_UBUS.addField(new CField(CFG_READ_MEM_SPACE_ADDRESS_HIGH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_READ_MEM_SPACE_ADDRESS_LOW_UBUS.addField(new CField(CFG_READ_MEM_SPACE_ADDRESS_LOW_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_READ_MEM_SPACE_DATA_UBUS.addField(new CField(CFG_READ_MEM_SPACE_DATA_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		RUL_PL_END_WITHOUT_PACKET_UBUS.addField(new CField(RUL_PL_END_WITHOUT_PACKET_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_MSG_CODE_UBUS.addField(new CField(CFG_TLP_MSG_CODE_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_MSG_ROUTING_UBUS.addField(new CField(CFG_TLP_MSG_ROUTING_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_MSG_VENDOR_DEF_UBUS.addField(new CField(CFG_TLP_MSG_VENDOR_DEF_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_LDW_BE_UBUS.addField(new CField(CFG_TLP_LDW_BE_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_FDW_BE_UBUS.addField(new CField(CFG_TLP_FDW_BE_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_EP_UBUS.addField(new CField(CFG_TLP_EP_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_CPL_STATUS_UBUS.addField(new CField(CFG_TLP_CPL_STATUS_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_CPL_BCM_UBUS.addField(new CField(CFG_TLP_CPL_BCM_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_CPL_LEN_UBUS.addField(new CField(CFG_TLP_CPL_LEN_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_TLP_CPL_RIDTAG_UBUS.addField(new CField(CFG_TLP_CPL_RIDTAG_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_CPL_TIMEOUT_COUNT_UBUS.addField(new CField(CFG_CPL_TIMEOUT_COUNT_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

		CL_BUS_CONTROL_UBUS.addField(new CField(CL_BUS_CONTROL_UBUS, "cl_clk_resetN", "null", CField.FieldType.RW, 0, 1, 0x0));
		CL_BUS_CONTROL_UBUS.addField(new CField(CL_BUS_CONTROL_UBUS, "cl_bus_resetN", "null", CField.FieldType.RW, 28, 1, 0x0));

		TB_RESET_UBUS.addField(new CField(TB_RESET_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		TB_POLL_MASK_UBUS.addField(new CField(TB_POLL_MASK_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		TB_READ_MASK_UBUS.addField(new CField(TB_READ_MASK_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		TB_POLL_TIMER_LIMIT_UBUS.addField(new CField(TB_POLL_TIMER_LIMIT_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		PKT_CMD_UBUS.addField(new CField(PKT_CMD_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		PKT_ADDR_HIGH_UBUS.addField(new CField(PKT_ADDR_HIGH_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		PKT_ADDR_LOW_UBUS.addField(new CField(PKT_ADDR_LOW_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		PKT_BYTE_COUNT_UBUS.addField(new CField(PKT_BYTE_COUNT_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));
		PKT_DATA_UBUS.addField(new CField(PKT_DATA_UBUS, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

	}

}
