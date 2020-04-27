package com.matrox.models;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;

public class TlpVMEAgent {

	private FDKDirectory testDirectory;
	private FDKDirectory simOutputDirectory;
	private FDKDirectory simInputDirectory;
	private FDKDirectory simPredictionDirectory;

	private Cplx9052 mvbRegFile;

	private TLPMasterModel tlpMaster;
	private FDKFile cmdFile;
	private int MaxPayloadSize; // Maximum Payload Size,  supported : 128 or 256 


	public TlpVMEAgent(FDKDirectory testDirectory, TLPMasterModel tlpMaster)
	{
		this.testDirectory = testDirectory;
		this.tlpMaster = tlpMaster;
		this.cmdFile = this.tlpMaster.getCommandFile();
		this.MaxPayloadSize = 256;
		this.mvbRegFile = new Cplx9052();
	}


	/**
	 * @return the cmdFile
	 */
	public FDKFile getCmdFile()
	{
		return cmdFile;
	}


	/**
	 * @param cmdFile
	 *            the cmdFile to set
	 */
	public void setCmdFile(FDKFile cmdFile)
	{
		this.cmdFile = cmdFile;
	}


	/**
	 * @return the maxPayloadSize
	 */
	public int getMaxPayloadSize()
	{
		return MaxPayloadSize;
	}


	/**
	 * @param maxPayloadSize
	 *            the maxPayloadSize to set
	 */
	public void setMaxPayloadSize(int maxPayloadSize)
	{
		MaxPayloadSize = maxPayloadSize;
	}


	/**
	 *
	 */
	public void setVMETimeoutMax(int valueAsClockCycle)
	{
		CRegister vme_timeoutRegister = (CRegister) mvbRegFile.getNode("/mvb/vme_timeout");
		CField vme_timeoutField = (CField) vme_timeoutRegister.getNode("value");

		vme_timeoutField.setValue(valueAsClockCycle);
		tlpMaster.getCommandFile().append("# Set VME MAX TIME OUT Value:");
		tlpMaster.MemWrite(vme_timeoutRegister);
	}


	/**
	 * @return the testDirectory
	 */
	public FDKDirectory getTestDirectory()
	{
		return testDirectory;
	}


	/**
	 * @return the simOutputDirectory
	 */
	public FDKDirectory getSimOutputDirectory()
	{
		return simOutputDirectory;
	}


	/**
	 * @return the simInputDirectory
	 */
	public FDKDirectory getSimInputDirectory()
	{
		return simInputDirectory;
	}


	/**
	 * @return the simPredictionDirectory
	 */
	public FDKDirectory getSimPredictionDirectory()
	{
		return simPredictionDirectory;
	}


	/**
	 * @return the mvbRegFile
	 */
	public Cplx9052 getMvbRegFile()
	{
		return mvbRegFile;
	}


	/**
	 * @return the pcieRoot
	 */
	public TLPMasterModel getTlpMaster()
	{
		return tlpMaster;
	}

}
