/**
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.matrox.tests;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.models.registerfile.CRegister;
import com.matrox.models.CPcieXilinxRegFile;
import com.matrox.models.PCIe2AxiMaster;
import com.matrox.models.PCIeNSys;
import com.matrox.models.UbusRootModel;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0001.
 * <p>
 * <b>Test Family:</b> PCIExpress
 * <p>
 * <b>Description:</b> Simple test that verify PCIe configuration registers of the
 * Xilinx end point. It verifies the DeviceID and the VendorID. The expected values are:
 * <p>
 * VendorID =  0x10B5 (PLX Technology)
 * DeviceID =  ()
 * <p>
 */
public class Test0001 extends FDKTest {

	private static final long EXPECTED_VENDOR_ID = 0x10B5;
	private static final long EXPECTED_DEVICE_ID = 0x5201;


	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0001(FDKContext context)
	{
		super(context, "test0001");
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
		PCIe2AxiMaster pcieXilinx = testbench.getPCIe2AxiMaster();
		CPcieXilinxRegFile pcieReg = pcieXilinx.getPCIeCfgRegFile();

		/////////////////////////////////////////////////////////////////////
		// 3. Configure the testbench
		/////////////////////////////////////////////////////////////////////
		testbench.init();

		// Wait 50 clock cycles
		pcieNsys.Delay(UbusRootModel.WAIT_NB_CLK, 50);


		/////////////////////////////////////////////////////////////////////
		// 4. Read: CFG_DEVID, 
		//    CFG Addr: 0x0
		//    Expected value: 0x0000000000001000L;
		/////////////////////////////////////////////////////////////////////
		CRegister reg_0x0 = pcieReg.getRegister("CFG_DEVID");
		reg_0x0.getField("vendorid").setValue(EXPECTED_VENDOR_ID);
		reg_0x0.getField("devid").setValue(EXPECTED_DEVICE_ID);
		pcieNsys.cfg_rd(reg_0x0);
	
		
		/////////////////////////////////////////////////////////////////////
		// 4. Retrieve expected BAR0, BAR2, BAR3, BAR4 values 
		/////////////////////////////////////////////////////////////////////
		long[] expectedValue = testbench.getPcieBARs();

		/////////////////////////////////////////////////////////////////////
		// 4. Read: BAR0, 
		//    Expected value: 0x0000000000001000L;
		/////////////////////////////////////////////////////////////////////
		CRegister BAR0 = pcieReg.getRegister("CFG_BASE_ADDR0");
		BAR0.getField("base_addr").setValue(expectedValue[0]);
		pcieNsys.cfg_rd(BAR0);

		/////////////////////////////////////////////////////////////////////
		// 5. Read: BAR2, 
		//    Expected value: 0x0000000200000000L;
		/////////////////////////////////////////////////////////////////////
		CRegister BAR2 = pcieReg.getRegister("CFG_BASE_ADDR2");
		BAR0.getField("base_addr").setValue(expectedValue[2]);
		pcieNsys.cfg_rd(BAR2);

		/////////////////////////////////////////////////////////////////////
		// 6. Read: BAR3, 
		//    Expected value: 0x0000000300000000L;
		/////////////////////////////////////////////////////////////////////
		CRegister BAR3 = pcieReg.getRegister("CFG_BASE_ADDR3");
		BAR0.getField("base_addr").setValue(expectedValue[3]);
		pcieNsys.cfg_rd(BAR3);

		/////////////////////////////////////////////////////////////////////
		// 7. Read: BAR4, 
		//    Expected value: 0x0000000400000000L;
		/////////////////////////////////////////////////////////////////////
		CRegister BAR4 = pcieReg.getRegister("CFG_BASE_ADDR4");
		BAR0.getField("base_addr").setValue(expectedValue[4]);
		pcieNsys.cfg_rd(BAR4);

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
		FDKContext context = new FDKContext(System.getenv("MVB_INI_FILE"));

		debugMode = false;
		if (debugMode)
		{
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		context.getSimulator().setCmdLineOptions("glbl");
		run(new Test0001(context));
	}

}
