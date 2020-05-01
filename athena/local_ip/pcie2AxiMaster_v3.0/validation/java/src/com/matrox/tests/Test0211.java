/**
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.matrox.tests;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.matrox.models.ModelPCIe;
import com.matrox.models.UbusRootModel;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0211.
 * <p>
 * <b>Test Family:</b> PCIExpress BAR0
 * <p>
 * <b>Description:</b> Send 1 Mem write transaction of 4 Bytes and read it back using 4 byte accesses
 * <p>
 */
public class Test0211 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0211(FDKContext context)
	{
		super(context, "Test0211");
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

		ModelPCIe modelPCIe = testbench.getModelPCIe();

		/////////////////////////////////////////////////////////////////////
		// 3. Configure the testbench
		/////////////////////////////////////////////////////////////////////
		testbench.init();
		modelPCIe.Delay("WAIT_NANO_SEC", 5000);

		/////////////////////////////////////////////////////////////////////
		// 4. Write at BAR0
		/////////////////////////////////////////////////////////////////////
		long BAR0 = testbench.getPcieBAR(0);
		modelPCIe.MemWrite(32, BAR0, 4, 0xdeadbeef);
		modelPCIe.Delay("WAIT_NANO_SEC", 500);

		/////////////////////////////////////////////////////////////////////
		// 5. Read at BAR0
		/////////////////////////////////////////////////////////////////////
		for (int i = 0; i < 4; i++)
		{
			long address = BAR0 + i;
			int expectedData = 0xdeadbeef & (0xff << i * 8);
			modelPCIe.MemRead(32, address, 1, expectedData);
		}

		/////////////////////////////////////////////////////////////////////
		// 6. Wait 500 clock cycles
		/////////////////////////////////////////////////////////////////////
		modelPCIe.Delay(UbusRootModel.WAIT_NB_CLK, 500);

		/////////////////////////////////////////////////////////////////////
		// 7. Create all model command files (*.in)
		/////////////////////////////////////////////////////////////////////
		testbench.createCmdFiles();

		/////////////////////////////////////////////////////////////////////
		// 8. Start simulation
		/////////////////////////////////////////////////////////////////////
		simulate();

		/////////////////////////////////////////////////////////////////////
		// 9. Post-processing
		/////////////////////////////////////////////////////////////////////
		// Parse the PCIe transaction error status in the transcript
		FDKStatus pciTransactionStatus = modelPCIe.parseTranscript(getTranscript());
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
		String iniFilePath = System.getenv("IPCORES") + "/pcie2AxiMaster/validation/java/validation.ini";
		FDKContext context = new FDKContext(iniFilePath);

		debugMode = true;
		if (debugMode)
		{
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		run(new Test0211(context));
	}

}