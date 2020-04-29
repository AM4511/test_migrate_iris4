package com.matrox.models;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;

public class MVBPCIeXilinx {

	private FDKDirectory testDirectory;
	private FDKDirectory simOutputDirectory;
	private FDKDirectory simInputDirectory;
	private FDKDirectory simPredictionDirectory;

	private CPcieXilinxRegFile registerFile;

	private PCIeNSys pcieRoot;
	private FDKFile cmdFile;
	private int MaxPayloadSize; // Maximum Payload Size,  supported : 128 or 256 


	public MVBPCIeXilinx(FDKDirectory testDirectory, PCIeNSys pcieRoot)
	{
		this.testDirectory = testDirectory;
		this.pcieRoot = pcieRoot;
		this.cmdFile = this.pcieRoot.getCmdFile();
		this.MaxPayloadSize = 256;
		this.registerFile = new CPcieXilinxRegFile();
	}


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


	/**
	 * @return the maxPayloadSize
	 */
	public int getMaxPayloadSize()
	{
		return MaxPayloadSize;
	}


	/**
	 * @param maxPayloadSize the maxPayloadSize to set
	 */
	public void setMaxPayloadSize(int maxPayloadSize)
	{
		MaxPayloadSize = maxPayloadSize;
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
	 * @return the registerFile
	 */
	public CPcieXilinxRegFile getRegisterFile()
	{
		return registerFile;
	}


	/**
	 * @return the pcieRoot
	 */
	public PCIeNSys getPcieRoot()
	{
		return pcieRoot;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Reset
	//DESCRIPTION: Reset the value in the register. Just keep the same name, the base
	//address and the number of field.   
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void Reset()
	{
		registerFile.reset();
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: init
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void init(long BaseAddrReg0, long BaseAddrReg1)
	{

		cmdFile.append("# ------------------");
		cmdFile.append("# Start CPcieXilinx Init");
		cmdFile.append("# ------------------");

		cmdFile.append("# Wait 10 clk cycle.");
		pcieRoot.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		// Configuration write : Power Management Control/Status register
		pcieRoot.cfg_wr(registerFile.getRegister("CFG_POW_MNG"));

		// Configuration write to Command and Status register
		cmdFile.append("# ");
		cmdFile.append("# Set STATUS  = 0x0010 (enable capabilities list))");
		cmdFile.append("# Set COMMAND = 0x0007 (enable rd/wr from upstream).");
		pcieRoot.cfg_wr(registerFile.getRegister("CFG_COMMAND_STATUS"));

		// Configuration write to Base address register
		CRegister register = registerFile.getRegister("CFG_BASE_ADDR0");
		CField field = register.getField("base_addr");
		field.setValue(BaseAddrReg0);
		pcieRoot.cfg_wr(registerFile.getRegister("CFG_BASE_ADDR0"));

		registerFile.getRegister("CFG_BASE_ADDR1").getField("base_addr").setValue(BaseAddrReg1);
		pcieRoot.cfg_wr(registerFile.getRegister("CFG_BASE_ADDR1"));

		//CFG_BASE_ADDR2.WriteField("base_addr", BaseAddrReg2);
		//PcieNsys.cfg_wr(registerFile.getRegister("CFG_BASE_ADDR2);  

		if (MaxPayloadSize == 128)
		{
			registerFile.getRegister("CFG_DEV_CTRL").getField("MaxPayloadSize").setValue(0x0L);
		}
		else if (MaxPayloadSize == 256)
		{ // 256 bytes
			registerFile.getRegister("CFG_DEV_CTRL").getField("MaxPayloadSize").setValue(0x1);
		}
		else
		{
			String message = String.format("PcieXlilinx Init : MaxPayloadSize = %d is not supported.", MaxPayloadSize);
			FDKConsole.addErrorMessage(message);

		}

		pcieRoot.cfg_wr(registerFile.getRegister("CFG_DEV_CTRL"));

		pcieRoot.Delay("WAIT_NB_CLK", 150); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		cmdFile.append("# ------------------");
		cmdFile.append("# End CPcieXilinx Init");
		cmdFile.append("# ------------------");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetMaxPayloadSize
	//DESCRIPTION:  Return the maximum payload size
	//PARAMETERS:    
	//RETURN VALUE: MaxPayloadSize
	////////////////////////////////////////////////////////////////////////////////
	public int GetMaxPayloadSize()
	{
		return MaxPayloadSize;
	}

	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetRegister
	//DESCRIPTION:   Find the Register specify by Name
	//PARAMETERS:    Name : Name of the register 
	//
	//RETURN VALUE:  The pointer to the register
	////////////////////////////////////////////////////////////////////////////////
	//CRegister GetRegister(String Name)
	//{
	//for (int i = 0; i< NbRegister; i++){
	//if (strcmp (RegisterPtr[i].GetName(), Name) == 0){       
	//return RegisterPtr[i] ;   
	//}
	//}
	//
	//cerr<< "CRegister GetRegisterFullAddr : Register " << Name << " not found" << endl;
	//cout<< "\nPress enter to quit!" << endl ;
	//getchar();
	//exit(1);
	//return NULL;
}
