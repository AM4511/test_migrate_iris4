package com.matrox.models;

import java.io.File;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.FDKMemoryModel;

public class MVBRamModel {
	public static final int UBUSADDR_LOAD = 0x0;
	public static final int UBUSADDR_DUMP = 0x1;

	private String name;
	private FDKDirectory resultsDirectory;
	private FDKDirectory testDirectory;
	private PCIeNSys pcieRoot;
	private FDKMemoryModel memory;
	private int ubusBaseAddress;


	public MVBRamModel(String name, int dataWidth, int addrWidth, FDKDirectory testDirectory,  FDKDirectory resultDirectory, int ubusBaseAddress, PCIeNSys pcieRoot)
	{
		this.name = name;
		this.resultsDirectory = resultDirectory;
		this.testDirectory = testDirectory;
		this.ubusBaseAddress = ubusBaseAddress;
		this.pcieRoot = pcieRoot;

		this.memory = new FDKMemoryModel("nvramMemory", dataWidth, addrWidth);

		String initFileAbsoluteName = this.testDirectory.getAbsolutePath() + File.separator + name + ".in";
		FDKFile initFile = new FDKFile(initFileAbsoluteName);
		this.memory.setInitFile(initFile);

		String dumpFileAbsoluteName = this.resultsDirectory.getAbsolutePath() + File.separator + name + ".dmp";
		FDKFile dumpFile = new FDKFile(dumpFileAbsoluteName);
		this.memory.setDumpFile(dumpFile);

		String predictionFileAbsoluteName = this.resultsDirectory.getAbsolutePath() + File.separator + name + ".pred";
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


	public FDKDirectory getTestDirectory()
	{
		return testDirectory;
	}


	public void setTestDirectory(FDKDirectory testRootDirectory)
	{
		this.testDirectory = testRootDirectory;
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
	 * @return the memory prediction file
	 */
	public FDKFile getPredictionFile()
	{
		return this.memory.getPredictionFile();
	}


	/**
	 * @param predFile
	 *            the predictionFile to set
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


	public void init()
	{
		// load the memory file
		int loadUBusAddress = ubusBaseAddress + UBUSADDR_LOAD;
		pcieRoot.UbusWrite(loadUBusAddress, 0x1);
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


	public void dumpSimulationFile()
	{
		String message = String.format("%s: Sending dump memory to file command", this.name.toUpperCase());
		pcieRoot.UbusComment(message);
		long address = this.ubusBaseAddress + UBUSADDR_DUMP;
		pcieRoot.UbusWrite(address, 0x1);
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
