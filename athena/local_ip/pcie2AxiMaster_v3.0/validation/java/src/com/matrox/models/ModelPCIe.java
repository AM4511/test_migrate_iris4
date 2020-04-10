package com.matrox.models;

import com.fdk.validation.core.FDKDirectory;

public class ModelPCIe extends PCIeNSys {

	// Mapping
	public static final long ubusGPIOBaseAddr = 0x1000;
	long FULL_GPIO_WRITE_UOFFSET = ubusGPIOBaseAddr;
	
	int numGPIO_In;
	int numGPIO_Out;

	public int getNumGPIO_In() {
		return numGPIO_In;
	}

	public void setNumGPIO_In(int numGPIO_In) {
		this.numGPIO_In = numGPIO_In;
	}

	public int getNumGPIO_Out() {
		return numGPIO_Out;
	}

	public void setNumGPIO_Out(int numGPIO_Out) {
		this.numGPIO_Out = numGPIO_Out;
	}

	public ModelPCIe(FDKDirectory testDirectory, int numGPIO_In, int numGPIO_Out) {
		super(testDirectory);
		this.numGPIO_In = numGPIO_In;
		this.numGPIO_Out = numGPIO_Out;
	}

	public void setGPIOBus(long busValue) {
		super.UbusWrite(FULL_GPIO_WRITE_UOFFSET, busValue);
	}
	
	public void setGPIO(int index) {
		super.UbusWrite(ubusGPIOBaseAddr + 1 + index, 0x1);
	}

	public void clrGPIO(int index) {
		super.UbusWrite(ubusGPIOBaseAddr + 1 + index, 0x0);
	}

	public void pulseGPIO(int index) {
		this.setGPIO(index);
		this.clrGPIO(index);
	}

	public void clrAllGPIO(long value) {
		super.UbusWrite(FULL_GPIO_WRITE_UOFFSET, 0);
	}

}
