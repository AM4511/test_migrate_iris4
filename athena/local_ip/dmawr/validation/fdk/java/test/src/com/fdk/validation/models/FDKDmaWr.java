package com.fdk.validation.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CSection;

public class FDKDmaWr extends FDKComponent {
	private static final int fid = 0xc010;
	private static final int majorVersion = 2;
	private static final int minorVersion = 1;
	private static final int hardwareVersion = 0;
	public static final int REGISTERFILESIZE = 512; //Bytes

	private CSection headerSection;
	private CSection userSection;


	public FDKDmaWr(String name, int subfid, int baseAddress)
	{
		super(name, fid, subfid, majorVersion, minorVersion, hardwareVersion);
		super.setRegisterFile(new Cdmawr());
		super.setShadowRegisterFile(new Cdmawr());

		super.getRegisterFile().setDataBusWidth(32);
		super.getShadowRegisterFile().setDataBusWidth(32);

		super.setRegisterFileBaseAddress(baseAddress);
		this.headerSection = super.registerFile.getSection("HEADER");
		this.userSection = super.registerFile.getSection("USER");
	}


	public Cdmawr getRegisterFile()
	{
		return (Cdmawr) super.registerFile;
	}


	public int getSnapshot()
	{
		long value = headerSection.getField("fctrl/snpsht").getValue();
		return (int) value;
	}


	public void setSnapshot()
	{
		CField field = headerSection.getField("fctrl/snpsht");
		field.setValue(0x1);
	}


	public long getFstart()
	{
		long value = userSection.getField("dstfstart/fstart").getValue();
		return value;
	}


	public long getFstart(int index)
	{
		long value = -1;
		switch (index)
		{
		case 0:
			value = userSection.getField("dstfstart/fstart").getValue();
			break;

		case 1:
			value = userSection.getField("DSTFSTART1/FSTART").getValue();
			break;

		case 2:
			value = userSection.getField("DSTFSTART2/FSTART").getValue();
			break;

		case 3:
			value = userSection.getField("DSTFSTART3/FSTART").getValue();
			break;

		default:
			break;
		}

		return value;
	}


	public void setFstart(long fstart)
	{
		userSection.getField("dstfstart/fstart").setValue(fstart);
	}


	public void setFstart(int index, long value)
	{
		switch (index)
		{
		case 0:
			userSection.getField("dstfstart/fstart").setValue(value);
			break;

		case 1:
			userSection.getField("DSTFSTART1/FSTART").setValue(value);
			break;

		case 2:
			userSection.getField("DSTFSTART2/FSTART").setValue(value);
			break;

		case 3:
			userSection.getField("DSTFSTART3/FSTART").setValue(value);
			break;

		default:
			break;
		}

	}


	public int getLinePitch()
	{
		long value = userSection.getField("dstlnpitch/lnpitch").getValue();
		return (int) value;
	}


	public void setLinePitch(int linePitch)
	{
		userSection.getField("dstlnpitch/lnpitch").setValue(linePitch);
	}


	public int getLineSize()
	{
		long value = userSection.getField("dstlnsize/lnsize").getValue();
		return (int) value;
	}


	public void setLineSize(int lineSize)
	{
		userSection.getField("dstlnsize/lnsize").setValue(lineSize);

	}


	public int getNbLine()
	{
		long value = userSection.getField("dstnbline/nbline").getValue();
		return (int) value;
	}


	public void setNbLine(int lineNbLine)
	{
		userSection.getField("dstnbline/nbline").setValue(lineNbLine);
	}


	public int getDte(int index)
	{
		long value = -1;
		switch (index)
		{
		case 0:
			value = userSection.getField("DSTCTRL/DTE0").getValue();
			break;
		case 1:
			value = userSection.getField("DSTCTRL/DTE1").getValue();
			break;
		case 2:
			value = userSection.getField("DSTCTRL/DTE2").getValue();
			break;
		case 3:
			value = userSection.getField("DSTCTRL/DTE3").getValue();
			break;

		default:
			break;
		}
		return (int) value;
	}


	public void setDte(int index, int dte)
	{
		switch (index)
		{
		case 0:
			userSection.getField("DSTCTRL/DTE0").setValue(dte);
			break;
		case 1:
			userSection.getField("DSTCTRL/DTE1").setValue(dte);
			break;
		case 2:
			userSection.getField("DSTCTRL/DTE2").setValue(dte);
			break;
		case 3:
			userSection.getField("DSTCTRL/DTE3").setValue(dte);
			break;

		default:
			break;
		}
	}


	public int getBitWidth()
	{
		long value = userSection.getField("DSTCTRL/BITWDTH").getValue();
		return (int) value;
	}


	public void setBitWidth(int bitWidth)
	{
		userSection.getField("DSTCTRL/BITWDTH").setValue(bitWidth);
	}


	public int getNbContx()
	{
		long value = userSection.getField("DSTCTRL/NBCONTX").getValue();
		return (int) value;
	}


	public void setNbContx(int nbContx)
	{
		userSection.getField("DSTCTRL/NBCONTX").setValue(nbContx - 1);
	}

	public int getBufferClear()
	{
		long value = userSection.getField("DSTCTRL/BUFCLR").getValue();
		return (int) value;
	}


	public void setBufferClear(int nbContx)
	{
		userSection.getField("DSTCTRL/BUFCLR").setValue(nbContx - 1);
	}

}
