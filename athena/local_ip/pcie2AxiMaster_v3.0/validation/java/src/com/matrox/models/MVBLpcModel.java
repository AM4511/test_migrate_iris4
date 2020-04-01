package com.matrox.models;

public class MVBLpcModel {
	public static final int UBUSOFFSET_WRITEREG = 0x0;
	public static final int UBUSOFFSET_READREG = 0x1;
	public static final int UBUSOFFSET_CMDREG = 0x2;
	public static final int UBUSOFFSET_ADD32REG = 0x3;
	public static final int UBUSOFFSET_DATA8REG = 0x4;
	public static final int UBUSOFFSET_AUXREG = 0x5;

	private PCIeNSys pcieRoot;

	//UBUS REGISTERS
	private int ubusBAR;
	private int offsetRegWrite;
	private int offsetRegRead;
	private int offsetRegCmd;
	private int offsetRegAdd32;
	private int offsetRegData8;
	private int offsetRegAux;


	public MVBLpcModel(PCIeNSys pcieRoot, int ubusBAR)
	{
		this.pcieRoot = pcieRoot;

		this.ubusBAR = ubusBAR;

		this.offsetRegWrite = this.ubusBAR + UBUSOFFSET_WRITEREG;
		this.offsetRegRead = this.ubusBAR + UBUSOFFSET_READREG;
		this.offsetRegCmd = this.ubusBAR + UBUSOFFSET_CMDREG;
		this.offsetRegAdd32 = this.ubusBAR + UBUSOFFSET_ADD32REG;
		this.offsetRegData8 = this.ubusBAR + UBUSOFFSET_DATA8REG;
		this.offsetRegAux = this.ubusBAR + UBUSOFFSET_AUXREG;

	}


	public void IOWrite(long address, long data)
	{
		this.LPCSetTx(0x1, 0x0, 0x1, address, data, 0x0);
	}


	public void IORead(long address, long expectedData)
	{
		this.LPCSetTx(0x0, 0x1, 0x1, address, expectedData, 0x0);
	}


	public void LPCSetTx(int RWrite, int RRead, int RCmd, long RAdd32, long RData8, long RAux)
	{
		pcieRoot.UbusComment("###############ECRITURES AU REGISTRES DU LPC MODEL ########################## ");

		pcieRoot.UbusWrite(offsetRegCmd, RCmd);
		pcieRoot.UbusWrite(offsetRegAdd32, RAdd32);
		pcieRoot.UbusWrite(offsetRegData8, RData8);
		pcieRoot.UbusWrite(offsetRegAux, RAux);

		pcieRoot.UbusWrite(offsetRegWrite, RWrite);
		pcieRoot.UbusWrite(offsetRegWrite, 0);

		pcieRoot.UbusWrite(offsetRegRead, RRead);
		pcieRoot.UbusWrite(offsetRegRead, 0);

	}


	public void comment(String comment)
	{
		pcieRoot.UbusComment(comment);
	}

}