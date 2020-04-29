package com.matrox.models;

import java.io.File;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.FDKMemoryModel;

public class VMESlaveModel {
	public static final int UBUSADDR_LOAD = 0x0;
	public static final int UBUSADDR_DUMP = 0x1;
	public static final int UBUSADDR_RESET_WIDTH = 0x2;
	public static final int UBUSADDR_RESET = 0x3;
	public static final int UBUSADDR_SETIRQ = 4;
	public static final int UBUSADDR_CLRIRQ = 5;
	public static final int UBUSADDR_STATUSID_IRQ3 = 6;
	public static final int UBUSADDR_STATUSID_IRQ6 = 7;

	private String name;
	private FDKDirectory testRootDirectory;
	private FDKDirectory resultsDirectory;
	private FDKDirectory testDirectory;
	private IUbusMaster ubusMaster;
	private FDKMemoryModel memory;
	private int defaultResetWidth;
	private int ubusBaseAddress;


	public VMESlaveModel(String name, FDKDirectory testRootDirectory, int ubusBaseAddress, IUbusMaster ubusMaster)
	{
		this.name = name;
		this.testRootDirectory = testRootDirectory;
		this.defaultResetWidth = 1;
		this.resultsDirectory = new FDKDirectory(testRootDirectory.getAbsolutePath() + "/test/simoutput");
		this.testDirectory = new FDKDirectory(testRootDirectory.getAbsolutePath() + "/test/siminput");
		this.ubusBaseAddress = ubusBaseAddress;
		this.ubusMaster =  ubusMaster;

		this.memory = new FDKMemoryModel("vmeMemory", 32, 24);

		String initFileAbsoluteName = testDirectory.getAbsolutePath() + File.separator + name + ".in";
		FDKFile initFile = new FDKFile(initFileAbsoluteName);
		this.memory.setInitFile(initFile);

		String dumpFileAbsoluteName = resultsDirectory.getAbsolutePath() + File.separator + name + ".dmp";
		FDKFile dumpFile = new FDKFile(dumpFileAbsoluteName);
		this.memory.setDumpFile(dumpFile);

		String predictionFileAbsoluteName = resultsDirectory.getAbsolutePath() + File.separator + name + ".pred";
		FDKFile predFile = new FDKFile(predictionFileAbsoluteName);
		this.memory.setPredictionFile(predFile);
	}


	public String getName()
	{
		return name;
	}


	public void setName(String name)
	{
		this.name = name;
	}


	public FDKDirectory getTestRootDirectory()
	{
		return testRootDirectory;
	}


	public void setTestRootDirectory(FDKDirectory testRootDirectory)
	{
		this.testRootDirectory = testRootDirectory;
	}


	public FDKDirectory getResultsDirectory()
	{
		return resultsDirectory;
	}


	/**
	 * @return the memory dumpFile
	 */
	public FDKFile getDumpFile()
	{
		return this.memory.getDumpFile();
	}


	/**
	 * @param dumpFile
	 *            the dumpFile to set
	 */
	public void setDumpFile(FDKFile dumpFile)
	{
		this.memory.setDumpFile(dumpFile);
	}


	/**
	 * @return the memory predictionFile
	 */
	public FDKFile getPredictionFile()
	{
		return this.memory.getPredictionFile();
	}


	/**
	 * @param predFile
	 *            the prediction file to set
	 */
	public void setPredictionFile(FDKFile predFile)
	{
		this.memory.setPredictionFile(predFile);
	}


	/**
	 * @return the memory initFile
	 */
	public FDKFile getInitFile()
	{
		return this.memory.getInitFile();
	}


	/**
	 * @param initFile
	 *            the model initialization file (.in)
	 */
	public void setInitFile(FDKFile initFile)
	{
		this.memory.setInitFile(initFile);
	}


	public int getDefaultResetWidth()
	{
		return defaultResetWidth;
	}


	public void setDefaultResetWidth(int resetWidth)
	{
		this.defaultResetWidth = resetWidth;
	}


	public void init()
	{
		// load the memory file
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_LOAD;
		ubusMaster.UbusWrite(loadUBusAddress, 0x1);
	}


	public void setIRQVector(int value)
	{
		// load the memory file
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_SETIRQ;
		ubusMaster.UbusWrite(loadUBusAddress, value);
	}


	public void clrIRQVector(int value)
	{
		// load the memory file
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_CLRIRQ;
		ubusMaster.UbusWrite(loadUBusAddress, value);
	}


	public void setIRQ3()
	{
		setIRQVector(0x1 << 3);
	}


	public void clrIRQ3()
	{
		clrIRQVector(0x1 << 3);
	}


	public void setIRQ6()
	{
		setIRQVector(0x1 << 6);
	}


	public void clrIRQ6()
	{
		clrIRQVector(0x1 << 6);
	}
 

	public void setIRQ3StatusVector(int value)
	{
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_STATUSID_IRQ3;
		ubusMaster.UbusWrite(loadUBusAddress, value);
	}


	public void setIRQ6StatusVector(int value)
	{
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_STATUSID_IRQ6;
		ubusMaster.UbusWrite(loadUBusAddress, value);
	}


	/**
	 * @return the ubusBaseAddress
	 */
	public int getUbusBaseAddress()
	{
		return ubusBaseAddress;
	}


	/**
	 * @param ubusBaseAddress
	 *            the ubusBaseAddress to set
	 */
	public void setUbusBaseAddress(int ubusBaseAddress)
	{
		this.ubusBaseAddress = ubusBaseAddress;
	}


	public void sendReset()
	{
		sendReset(this.defaultResetWidth);
	}


	public void sendReset(int resetWidth)
	{
		String message = String.format("%s: Sending reset on VME bus. Reset width: %d VME clock cycles", this.name.toUpperCase(), resetWidth);
		ubusMaster.UbusComment(message);
		long address = this.ubusBaseAddress + UBUSADDR_RESET_WIDTH;
		ubusMaster.UbusWrite(address, resetWidth);

	}


	public void dumpSimulationFile()
	{
		String message = String.format("%s: Sending dump memory to file command", this.name.toUpperCase());
		ubusMaster.UbusComment(message);
		long address = this.ubusBaseAddress + UBUSADDR_DUMP;
		ubusMaster.UbusWrite(address, 0x1);
	}


	public void dumpPrediction()
	{
		this.memory.dumpPrediction();
	}


	public void createCmdFile()
	{
		// Create the memory init file for simulation. So take content of the 
		// prediction memory and dump it in the .in file. This file will the be 
		// loaded by the vhdl model at the beginning of the simulation.
		this.memory.dump(this.memory.getInitFile());
	}


	/**
	 * @return the memory
	 */
	public FDKMemoryModel getMemory()
	{
		return memory;
	}


	/**
	 * @param memory
	 *            the memory to set
	 */
	public void setMemory(FDKMemoryModel memory)
	{
		this.memory = memory;
	}

}
