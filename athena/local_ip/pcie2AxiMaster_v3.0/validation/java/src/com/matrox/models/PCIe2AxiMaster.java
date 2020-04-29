package com.matrox.models;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;

public class PCIe2AxiMaster {

	private FDKDirectory testDirectory;
	private FDKDirectory simOutputDirectory;
	private FDKDirectory simInputDirectory;
	private FDKDirectory simPredictionDirectory;

	private CPcieXilinxRegFile pcieCfgRegFile;
	private Cpcie2AxiMaster regFile;

	private PCIeNSys pcieRoot;
	private FDKFile cmdFile;
	private int MaxPayloadSize; // Maximum Payload Size, supported : 128 or 256

	public PCIe2AxiMaster(FDKDirectory testDirectory, PCIeNSys pcieRoot) {
		this.testDirectory = testDirectory;
		this.pcieRoot = pcieRoot;
		this.cmdFile = this.pcieRoot.getCmdFile();
		this.MaxPayloadSize = 256;
		this.pcieCfgRegFile = new CPcieXilinxRegFile();
		this.regFile = new Cpcie2AxiMaster();

	}

	/**
	 * @return the cmdFile
	 */
	public FDKFile getCmdFile() {
		return cmdFile;
	}

	/**
	 * @param cmdFile
	 *            the cmdFile to set
	 */
	public void setCmdFile(FDKFile cmdFile) {
		this.cmdFile = cmdFile;
	}

	/**
	 * @return the maxPayloadSize
	 */
	public int getMaxPayloadSize() {
		return MaxPayloadSize;
	}

	/**
	 * @param maxPayloadSize
	 *            the maxPayloadSize to set
	 */
	public void setMaxPayloadSize(int maxPayloadSize) {
		MaxPayloadSize = maxPayloadSize;
	}


	/**
	 * @return the testDirectory
	 */
	public FDKDirectory getTestDirectory() {
		return testDirectory;
	}

	/**
	 * @return the simOutputDirectory
	 */
	public FDKDirectory getSimOutputDirectory() {
		return simOutputDirectory;
	}

	/**
	 * @return the simInputDirectory
	 */
	public FDKDirectory getSimInputDirectory() {
		return simInputDirectory;
	}

	/**
	 * @return the simPredictionDirectory
	 */
	public FDKDirectory getSimPredictionDirectory() {
		return simPredictionDirectory;
	}

	/**
	 * @return the PCIe Configuration registerFile
	 */
	public CPcieXilinxRegFile getPCIeCfgRegFile() {
		return pcieCfgRegFile;
	}

	/**
	 * @return the mvbRegFile
	 */
	public Cpcie2AxiMaster getRegFile() {
		return regFile;
	}

	/**
	 * @return the pcieRoot
	 */
	public PCIeNSys getPcieRoot() {
		return pcieRoot;
	}

	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: Reset
	// DESCRIPTION: Reset the value in the register. Just keep the same name,
	//////////////////////////////////////////////////////////////////////////////// the
	//////////////////////////////////////////////////////////////////////////////// base
	// address and the number of field.
	// PARAMETERS:
	// RETURN VALUE:
	////////////////////////////////////////////////////////////////////////////////
	public void Reset() {
		pcieCfgRegFile.reset();
	}

	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: init
	// DESCRIPTION:
	// PARAMETERS:
	// RETURN VALUE:
	////////////////////////////////////////////////////////////////////////////////
	public void init(long[] BaseAddrReg) {

		cmdFile.append("# ----------------------------");
		cmdFile.append("# Start PcieEndpoint Init");
		cmdFile.append("# ----------------------------");

		cmdFile.append("# Wait 10 clk cycle.");
		pcieRoot.Delay("WAIT_NB_CLK", 10); // 002 : Allows the simulation to
											// proceed for tb_wait_cycles clock
											// cycles.

		// Configuration write : Power Management Control/Status register
		pcieRoot.cfg_wr(pcieCfgRegFile.getRegister("CFG_POW_MNG"));

		// Configuration write to Command and Status register
		cmdFile.append("# ");
		cmdFile.append("# Set STATUS  = 0x0010 (enable capabilities list))");
		cmdFile.append("# Set COMMAND = 0x0007 (enable rd/wr from upstream).");
		pcieRoot.cfg_wr(pcieCfgRegFile.getRegister("CFG_COMMAND_STATUS"));

		///////////////////////////////////////////////////////////////////////
		// BAR0/1 [64Bits BAR]: AXI System
		///////////////////////////////////////////////////////////////////////
		// Configuration write to Base address register
		String message = String.format("# Set  BAR0: 0x%08x", BaseAddrReg[0]);
		cmdFile.append("# ------------------");
		cmdFile.append(message);
		cmdFile.append("# ------------------");

		CRegister barRegister = pcieCfgRegFile.getRegister("CFG_BASE_ADDR0");
		CField bar = barRegister.getField("base_addr");
		bar.setValue(BaseAddrReg[0]);
		pcieRoot.cfg_wr(barRegister);

		// Set the High part of the 64 bits BAR
		message = String.format("# Set  BAR1: 0x%08x", BaseAddrReg[1]);
		cmdFile.append("# ------------------");
		cmdFile.append(message);
		cmdFile.append("# ------------------");

		barRegister = pcieCfgRegFile.getRegister("CFG_BASE_ADDR1");
		bar = barRegister.getField("base_addr");
		bar.setValue(BaseAddrReg[1]);
		pcieRoot.cfg_wr(barRegister);
		

		///////////////////////////////////////////////////////////////////////
		// BAR2/3 [64Bits BAR]: PCIe2AxiMaster register file
		///////////////////////////////////////////////////////////////////////
		message = String.format("# Set  BAR2:0x%08x", BaseAddrReg[2]);
		cmdFile.append("# ------------------");
		cmdFile.append(message);
		cmdFile.append("# ------------------");
		barRegister = pcieCfgRegFile.getRegister("CFG_BASE_ADDR2");
		bar = barRegister.getField("base_addr");
		bar.setValue(BaseAddrReg[2]);
		pcieRoot.cfg_wr(barRegister);

	
		message = String.format("# Set  BAR3:0x%08x", BaseAddrReg[3]);
		cmdFile.append("# ------------------");
		cmdFile.append(message);
		cmdFile.append("# ------------------");
		barRegister = pcieCfgRegFile.getRegister("CFG_BASE_ADDR3");
		bar = barRegister.getField("base_addr");
		bar.setValue(BaseAddrReg[3]);
		pcieRoot.cfg_wr(barRegister);

		
		// Set the Pcie2AxiMaster register file base address in the java Model
		this.regFile.setBaseAddress(BaseAddrReg[2]);
		
		
		///////////////////////////////////////////////////////////////////////
		// BAR4: Interrupts
		///////////////////////////////////////////////////////////////////////
//		message = String.format("# Set  BAR4:0x%08x", BaseAddrReg[4]);
//		cmdFile.append("# ------------------");
//		cmdFile.append(message);
//		cmdFile.append("# ------------------");
//		barRegister = pcieCfgRegFile.getRegister("CFG_BASE_ADDR4");
//		bar = barRegister.getField("base_addr");
//		bar.setValue(BaseAddrReg[4]);
//		pcieRoot.cfg_wr(barRegister);
//
//		// CFG_BASE_ADDR2.WriteField("base_addr", BaseAddrReg2);
//		// PcieNsys.cfg_wr(registerFile.getRegister("CFG_BASE_ADDR2);
//
//		if (MaxPayloadSize == 128) {
//			pcieCfgRegFile.getRegister("CFG_DEV_CTRL").getField("MaxPayloadSize").setValue(0x0L);
//		} else if (MaxPayloadSize == 256) { // 256 bytes
//			pcieCfgRegFile.getRegister("CFG_DEV_CTRL").getField("MaxPayloadSize").setValue(0x1);
//		} else {
//			message = String.format("PcieXlilinx Init : MaxPayloadSize = %d is not supported.", MaxPayloadSize);
//			FDKConsole.addErrorMessage(message);
//
//		}
//
//		pcieRoot.cfg_wr(pcieCfgRegFile.getRegister("CFG_DEV_CTRL"));
//
//		pcieRoot.Delay("WAIT_NB_CLK", 150); // 002 : Allows the simulation to
//											// proceed for tb_wait_cycles clock
//											// cycles.

		cmdFile.append("# ----------------------------");
		cmdFile.append("# End CPcieXilinx Init");
		cmdFile.append("# ----------------------------");

	}

	////////////////////////////////////////////////////////////////////////////////
	// FUNCTION NAME: GetMaxPayloadSize
	// DESCRIPTION: Return the maximum payload size
	// PARAMETERS:
	// RETURN VALUE: MaxPayloadSize
	////////////////////////////////////////////////////////////////////////////////
	public int GetMaxPayloadSize() {
		return MaxPayloadSize;
	}

}
