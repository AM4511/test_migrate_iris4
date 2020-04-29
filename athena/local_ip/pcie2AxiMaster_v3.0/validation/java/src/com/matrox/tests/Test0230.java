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
 * This class defines Test0230.
 * <p>
 * <b>Test Family:</b> PCIExpress BAR0
 * <p>
 * <b>Description:</b> Send 2 Mem write transactions of 16 bits and read it back with 1 DW access
 * <p>
 */
public class Test0230 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0230(FDKContext context)
	{
		super(context, "Test0230");
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
		int data[] = { 0x11223344, 0x55667788};
		long address = BAR0 + 8;

		modelPCIe.MemWrite(32, address, 8, data);
		modelPCIe.Delay("WAIT_NANO_SEC", 500);

		/////////////////////////////////////////////////////////////////////
		// 5. Read at BAR0
		/////////////////////////////////////////////////////////////////////
		modelPCIe.MemRead(32, address, 8, data);

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

		run(new Test0230(context));
	}

}
