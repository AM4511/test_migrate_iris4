package com.matrox.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;

/*****************************************************************************
 ** $HeadURL:$ $Revision:$ $Date:$
 **
 ** MODULE: CPcieXilinxRegFile
 **
 ** DESCRIPTION: Class Register file of the PcieXilinxRegFile module
 **
 **
 ** THIS FILE WAS MANUALLY CREATED!!!.
 **
 ** COPYRIGHT (c) 2015 Matrox Electronic Systems Ltd. All Rights Reserved
 **
 *****************************************************************************/
public class CPcieXilinxRegFile extends CRegisterFile {

	public CPcieXilinxRegFile()
	{
		super("PcieXilinxRegFile", 12, 32, true);
		CRegister CFG_DEVID = new CRegister(this, "CFG_DEVID", "null", 0x00);
		super.getChildrenList().add(CFG_DEVID);

		CRegister CFG_COMMAND_STATUS = new CRegister(this, "CFG_COMMAND_STATUS", "null", 0x04);
		super.getChildrenList().add(CFG_COMMAND_STATUS);
		

		CRegister CFG_BASE_ADDR0 = new CRegister(this, "CFG_BASE_ADDR0", "null", 0x10);
		super.getChildrenList().add(CFG_BASE_ADDR0);

		CRegister CFG_BASE_ADDR1 = new CRegister(this, "CFG_BASE_ADDR1", "null", 0x14);
		super.getChildrenList().add(CFG_BASE_ADDR1);

		CRegister CFG_BASE_ADDR2 = new CRegister(this, "CFG_BASE_ADDR2", "null", 0x18);
		super.getChildrenList().add(CFG_BASE_ADDR2);

		CRegister CFG_BASE_ADDR3 = new CRegister(this, "CFG_BASE_ADDR3", "null", 0x1c);
		super.getChildrenList().add(CFG_BASE_ADDR3);

		CRegister CFG_BASE_ADDR4 = new CRegister(this, "CFG_BASE_ADDR4", "null", 0x20);
		super.getChildrenList().add(CFG_BASE_ADDR4);

		CRegister CFG_BASE_ADDR5 = new CRegister(this, "CFG_BASE_ADDR5", "null", 0x24);
		super.getChildrenList().add(CFG_BASE_ADDR5);

		CRegister CFG_SUBSYSTEM = new CRegister(this, "CFG_SUBSYSTEM", "null", 0x2c);
		super.getChildrenList().add(CFG_SUBSYSTEM);

		CRegister CFG_BASE_ADDR_ROM = new CRegister(this, "CFG_BASE_ADDR_ROM", "null", 0x30);
		super.getChildrenList().add(CFG_BASE_ADDR_ROM);

		CRegister CFG_POW_MNG = new CRegister(this, "CFG_POW_MNG", "null", 0x44);
		super.getChildrenList().add(CFG_POW_MNG);

		CRegister CFG_MSI_CTRL = new CRegister(this, "CFG_MSI_CTRL", "null", 0x48);
		super.getChildrenList().add(CFG_MSI_CTRL);

		CRegister CFG_MSI_MSGADDR = new CRegister(this, "CFG_MSI_MSGADDR", "null", 0x4c);
		super.getChildrenList().add(CFG_MSI_MSGADDR);

		CRegister CFG_MSI_MSGUPADDR = new CRegister(this, "CFG_MSI_MSGUPADDR", "null", 0x50);
		super.getChildrenList().add(CFG_MSI_MSGUPADDR);

		CRegister CFG_MSI_DATA = new CRegister(this, "CFG_MSI_DATA", "null", 0x54);
		super.getChildrenList().add(CFG_MSI_DATA);

		CRegister CFG_MSI_MASK = new CRegister(this, "CFG_MSI_MASK", "null", 0x58);
		super.getChildrenList().add(CFG_MSI_MASK);

		CRegister CFG_MSI_PENDING = new CRegister(this, "CFG_MSI_PENDING", "null", 0x5C);
		super.getChildrenList().add(CFG_MSI_PENDING);

		CRegister CFG_DEV_CTRL = new CRegister(this, "CFG_DEV_CTRL", "null", 0x68);
		super.getChildrenList().add(CFG_DEV_CTRL);

		CRegister CFG_MSIX_CTRL = new CRegister(this, "CFG_MSIX_CTRL", "null", 0x9C);
		super.getChildrenList().add(CFG_MSIX_CTRL);

		CRegister CFG_MSIX_TABLEOFFSET = new CRegister(this, "CFG_MSI_MSGADDR", "null", 0xA0);
		super.getChildrenList().add(CFG_MSIX_TABLEOFFSET);

		CRegister CFG_MSIX_PBAOFFSET = new CRegister(this, "CFG_MSI_MSGUPADDR", "null", 0xA4);
		super.getChildrenList().add(CFG_MSIX_PBAOFFSET);

		CFG_POW_MNG.addField(new CField(CFG_POW_MNG, "PMCSR", "null", CField.FieldType.RW, 0, 16, 0));
		CFG_POW_MNG.addField(new CField(CFG_POW_MNG, "BSE", "null", CField.FieldType.RW, 16, 8, 0));
		CFG_POW_MNG.addField(new CField(CFG_POW_MNG, "data", "null", CField.FieldType.RW, 24, 8, 0));
		
		CFG_DEVID.addField(new CField(CFG_DEVID, "vendorid", "null", CField.FieldType.RW, 0, 16, 0x10b5));
		CFG_DEVID.addField(new CField(CFG_DEVID, "devid", "null", CField.FieldType.RW, 16, 16, 0x5201));

		CFG_COMMAND_STATUS.addField(new CField(CFG_COMMAND_STATUS, "command", "null", CField.FieldType.RW, 0, 16, 0x7));
		CFG_COMMAND_STATUS.addField(new CField(CFG_COMMAND_STATUS, "status", "null", CField.FieldType.RW, 16, 16, 0x10));

		CFG_BASE_ADDR0.addField(new CField(CFG_BASE_ADDR0, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_BASE_ADDR1.addField(new CField(CFG_BASE_ADDR1, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_BASE_ADDR2.addField(new CField(CFG_BASE_ADDR2, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_BASE_ADDR3.addField(new CField(CFG_BASE_ADDR3, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_BASE_ADDR4.addField(new CField(CFG_BASE_ADDR4, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));
		CFG_BASE_ADDR5.addField(new CField(CFG_BASE_ADDR5, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));

		CFG_SUBSYSTEM.addField(new CField(CFG_SUBSYSTEM, "subsystem vendor id", "null", CField.FieldType.RW, 0, 16, 0x102b));

		CFG_SUBSYSTEM.addField(new CField(CFG_SUBSYSTEM, "subsystem id", "null", CField.FieldType.RW, 16, 16, 0x2197));

		CFG_BASE_ADDR_ROM.addField(new CField(CFG_BASE_ADDR_ROM, "base_addr", "null", CField.FieldType.RW, 0, 32, 0x0));

		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "NxtPtr", "null", CField.FieldType.RW, 8, 8, 0x60));
		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "MSIEn", "null", CField.FieldType.RW, 16, 1, 0));
		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "MultMsgCap", "null", CField.FieldType.RW, 17, 3, 3));
		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "MultMsgEn", "null", CField.FieldType.RW, 20, 3, 0));
		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "Addr64Cap", "null", CField.FieldType.RW, 23, 1, 1));
		CFG_MSI_CTRL.addField(new CField(CFG_MSI_CTRL, "PerVectorMaskCap", "null", CField.FieldType.RW, 24, 1, 1));

		CFG_MSI_MSGADDR.addField(new CField(CFG_MSI_MSGADDR, "MsgAddr", "null", CField.FieldType.RW, 0, 32, 0));
		CFG_MSI_MSGUPADDR.addField(new CField(CFG_MSI_MSGUPADDR, "MsgUpperAddr", "null", CField.FieldType.RW, 0, 32, 0));
		CFG_MSI_DATA.addField(new CField(CFG_MSI_DATA, "MsgData", "null", CField.FieldType.RW, 0, 16, 0));
		CFG_MSI_MASK.addField(new CField(CFG_MSI_MASK, "Mask", "null", CField.FieldType.RW, 0, 32, 0));
		CFG_MSI_PENDING.addField(new CField(CFG_MSI_PENDING, "Pending", "null", CField.FieldType.RW, 0, 32, 0));

		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "CorrErrRepEn", "null", CField.FieldType.RW, 0, 1, 0));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "NFErrRepEn", "null", CField.FieldType.RW, 1, 1, 1));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "FatalErrRepEn", "null", CField.FieldType.RW, 2, 1, 0));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "URReqEn", "null", CField.FieldType.RW, 3, 1, 1));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "EnRelOrd", "null", CField.FieldType.RW, 4, 1, 1));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "MaxPayloadSize", "null", CField.FieldType.RW, 5, 3, 1));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "ExtTagEn", "null", CField.FieldType.RW, 8, 1, 0));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "PhanFuncEn", "null", CField.FieldType.RW, 9, 1, 0));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "AuxPowPMEn", "null", CField.FieldType.RW, 10, 1, 0));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "EnNoSnoop", "null", CField.FieldType.RW, 11, 1, 1));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "MaxReadReqSize", "null", CField.FieldType.RW, 12, 3, 2));
		CFG_DEV_CTRL.addField(new CField(CFG_DEV_CTRL, "InitFuncLevReset", "null", CField.FieldType.RW, 15, 1, 0));

		CFG_MSIX_CTRL.addField(new CField(CFG_MSIX_CTRL, "CapID", "null", CField.FieldType.RW, 0, 8, 0x11));
		CFG_MSIX_CTRL.addField(new CField(CFG_MSIX_CTRL, "NxtPtr", "null", CField.FieldType.RW, 8, 8, 0x00));
		CFG_MSIX_CTRL.addField(new CField(CFG_MSIX_CTRL, "TableSize", "null", CField.FieldType.RW, 16, 11, 7));
		CFG_MSIX_CTRL.addField(new CField(CFG_MSIX_CTRL, "FctMask", "null", CField.FieldType.RW, 30, 1, 0));
		CFG_MSIX_CTRL.addField(new CField(CFG_MSIX_CTRL, "MsiXEnable", "null", CField.FieldType.RW, 31, 1, 0));

		CFG_MSIX_TABLEOFFSET.addField(new CField(CFG_MSIX_TABLEOFFSET, "BIR", "null", CField.FieldType.RW, 0, 3, 2));
		CFG_MSIX_TABLEOFFSET.addField(new CField(CFG_MSIX_TABLEOFFSET, "Offset", "null", CField.FieldType.RW, 3, 29, 0));

		CFG_MSIX_PBAOFFSET.addField(new CField(CFG_MSIX_PBAOFFSET, "BIR", "null", CField.FieldType.RW, 0, 3, 2));
		CFG_MSIX_PBAOFFSET.addField(new CField(CFG_MSIX_PBAOFFSET, "Offset", "null", CField.FieldType.RW, 3, 29, 0));
	}

}
