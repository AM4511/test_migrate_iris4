package com.matrox.models;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;

public abstract class ValidationModel {
	protected FDKDirectory testDirectory;
	protected FDKFile cmdFile;

	
	
	public ValidationModel(FDKDirectory testDirectory)
	{
		this.testDirectory = testDirectory;
		this.cmdFile = new FDKFile("./mvbModel.in");
	}

	public FDKDirectory getTestDirectory()
	{
		return testDirectory;
	}

	public void setTestDirectory(FDKDirectory testDirectory)
	{
		this.testDirectory = testDirectory;
	}
	
	//abstract public boolean createCmdFile();

	/**
	 * @return the cmdFile
	 */
	public FDKFile getCmdFile()
	{
		return cmdFile;
	}

	/**
	 * @param cmdFile the cmdFile to set
	 */
	public void setCmdFile(FDKFile cmdFile)
	{
		this.cmdFile = cmdFile;
	}
	
}