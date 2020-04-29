/**
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.matrox.tests.system;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.matrox.models.Cpcie2AxiMaster;
import com.matrox.models.PCIe2AxiMaster;
import com.matrox.models.PCIeNSys;
import com.matrox.models.UbusRootModel;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0103.
 * <p>
 * <b>Test Family:</b> PCIExpress BAR2 read/write (registerfile) accesses
 * <p>
 * <b>Description:</b> PCIExpress read data at the limit of BAR2 where there are
 * no register
 * <p>
 */
public class Test0103 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0103(FDKContext context) {
		super(context, "Test0103");
	}

	/**
	 * Start the test
	 */
	public void run() {

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
		PCIe2AxiMaster pci2AxiMaster = testbench.getPCIe2AxiMaster();
		Cpcie2AxiMaster registerfile = pci2AxiMaster.getRegFile();

		/////////////////////////////////////////////////////////////////////
		// 3. Configure the testbench
		/////////////////////////////////////////////////////////////////////
		testbench.init();
		pcieNsys.Delay("WAIT_NANO_SEC", 5000);

		/////////////////////////////////////////////////////////////////////
		// 4. Read at the TOP of BAR2 (BAR 2+ @0xFC) where there is no
		// register. The expected returned value should be 0x0
		/////////////////////////////////////////////////////////////////////
		int expectedValue = 0x0;
		long address = registerfile.getBaseAddress() + 0xFC;
		// Call the function to do a memory read
		pcieNsys.MemRead(32, address, 0x4, expectedValue);

		/////////////////////////////////////////////////////////////////////
		// 5. Read just above BAR2 (BAR 2+ @0x100) where there is no
		// register. The expected returned value should be 0x0
		/////////////////////////////////////////////////////////////////////
		expectedValue = 0x0;
		address = registerfile.getBaseAddress() + 0x100;
		// Call the function to do a memory read
		pcieNsys.MemRead(32, address, 0x4, expectedValue);

		/////////////////////////////////////////////////////////////////////
		// 6. Wait 50 clock cycles
		/////////////////////////////////////////////////////////////////////
		pcieNsys.Delay(UbusRootModel.WAIT_NB_CLK, 50);

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
	public static void main(String[] args) {
		String iniFilePath = System.getenv("IPCORES") + "/pcie2AxiMaster/validation2/java/validation.ini";
		FDKContext context = new FDKContext(iniFilePath);

		debugMode = true;
		if (debugMode) {
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		run(new Test0103(context));
	}

}
