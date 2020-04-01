/**
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.matrox.tests.system;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.models.registerfile.CRegister;
import com.matrox.models.CPcieXilinxRegFile;
import com.matrox.models.UbusRootModel;
import com.matrox.models.PCIe2AxiMaster;
import com.matrox.models.PCIeNSys;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0000.
 * <p>
 * <b>Test Family:</b> PCIExpress
 * <p>
 * <b>Description:</b> Simple test that verify PCIe configuration read access to the Base Address Register (BAR) of the
 * Xilinx end point. In the actual testbench  4 Bars of the Xilinx endpoint are mapped this way:
 * <p>
 * <p> 
 * BAR0: 0x0000000010000004L (Memory space, 64 Bits / Non prefetchable);
 * <p>
 * BAR1: 0x0000000000000000L 
 * <p>
 * BAR2: 0x0000000020000004L (Memory space, 64 Bits / Non prefetchable);
 * <p>
 * BAR3: 0x0000000000000000L 
 * <p>
 * 
 */
public class Test0000 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0000(FDKContext context)
	{
		super(context, "test0000");
	}


	/**
	 * Start the test
	 */
	public void run()
	{

		/////////////////////////////////////////////////////////////////////
		// 1. Initialize the test (create directory structure, etc...)
		/////////////////////////////////////////////////////////////////////
		boolean success = init();
		if (!success)
			return;

		/////////////////////////////////////////////////////////////////////
		// 2. Create the test bench and retrieve model instances
		/////////////////////////////////////////////////////////////////////
		TestBench testbench = new TestBench(super.getTestDir(), super.getResultsDir());

		PCIeNSys pcieNsys = testbench.getModelPCIe();
		PCIe2AxiMaster pcie2AxiMaster = testbench.getPCIe2AxiMaster();
		CPcieXilinxRegFile pcieReg = pcie2AxiMaster.getPCIeCfgRegFile();

		/////////////////////////////////////////////////////////////////////
		// 3. Configure the testbench
		/////////////////////////////////////////////////////////////////////
		testbench.init();

		// Wait 50 clock cycles
		pcieNsys.Delay(UbusRootModel.WAIT_NB_CLK, 50);

		/////////////////////////////////////////////////////////////////////
		// 4. Retrieve expected BAR0, BAR2, BAR3, BAR4 values 
		/////////////////////////////////////////////////////////////////////
		long[] barExpectedValue = testbench.getPcieBARs();

		//CFG_BASE_ADDR4
		/////////////////////////////////////////////////////////////////////
		// 4. Read: BAR0, 
		//    Expected value: 0x0000000010000004L;
		/////////////////////////////////////////////////////////////////////
		CRegister cfg_base_addr0 = pcieReg.getRegister("CFG_BASE_ADDR0");
		cfg_base_addr0.getField("base_addr").setValue(barExpectedValue[0] + 0xc);
		pcieNsys.cfg_rd(cfg_base_addr0);

		/////////////////////////////////////////////////////////////////////
		// 4. Read: BAR1, 
		//    Expected value: 0x0000000000001000L;
		/////////////////////////////////////////////////////////////////////
		CRegister cfg_base_addr1 = pcieReg.getRegister("CFG_BASE_ADDR1");
		cfg_base_addr0.getField("base_addr").setValue(barExpectedValue[1]);
		pcieNsys.cfg_rd(cfg_base_addr1);

		/////////////////////////////////////////////////////////////////////
		// 5. Read: BAR2, 
		//    Expected value: 0x0000000200000000L;
		/////////////////////////////////////////////////////////////////////
		CRegister cfg_base_addr2 = pcieReg.getRegister("CFG_BASE_ADDR2");
		cfg_base_addr2.getField("base_addr").setValue(barExpectedValue[2] +  + 0xc);
		pcieNsys.cfg_rd(cfg_base_addr2);

		/////////////////////////////////////////////////////////////////////
		// 6. Read: BAR3, 
		//    Expected value: 0x0000000300000000L;
		/////////////////////////////////////////////////////////////////////
		CRegister cfg_base_addr_3 = pcieReg.getRegister("CFG_BASE_ADDR3");
		cfg_base_addr_3.getField("base_addr").setValue(barExpectedValue[3]);
		pcieNsys.cfg_rd(cfg_base_addr_3);

		pcieNsys.Delay(UbusRootModel.WAIT_NB_CLK, 1000);

		// Create all model command files (*.in)
		testbench.createCmdFiles();

		/////////////////////////////////////////////////////////////////////
		// 8. Start simulation
		/////////////////////////////////////////////////////////////////////
		simulate();

		/////////////////////////////////////////////////////////////////////
		// 9. Post-processing
		/////////////////////////////////////////////////////////////////////
		// Parse the PCIe transaction error status in the transcript
		FDKStatus pciTransactionStatus = pcieNsys.parseTranscript(getTranscript());
		addStatus(pciTransactionStatus);

		/////////////////////////////////////////////////////////////////////
		// Report the test status list
		/////////////////////////////////////////////////////////////////////
		reportStatus();

	}


	/**
	 * Entry point function in order to run this test as a stand alone test
	 * 
	 * @param args
	 */
	public static void main(String[] args)
	{
		String iniFilePath = System.getenv("IPCORES") + "/pcie2AxiMaster/validation/java/validation2.ini";
		FDKContext context = new FDKContext(iniFilePath);

		debugMode = true;
		if (debugMode)
		{
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		run(new Test0000(context));
	}

}
