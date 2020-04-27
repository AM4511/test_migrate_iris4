/**
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.matrox.tests.system;

import java.util.ArrayList;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.models.registerfile.CRegister;
import com.matrox.models.Cpcie2AxiMaster;
import com.matrox.models.ModelPCIe;
import com.matrox.models.PCIe2AxiMaster;
import com.matrox.models.UbusRootModel;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0104.
 * <p>
 * <b>Test Family:</b> PCIExpress BAR2 read/write (registerfile) accesses
 * <p>
 * <b>Description:</b> PCIExpress read the full BAR2 no register
 * <p>
 */
public class Test0104 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0104(FDKContext context) {
		super(context, "Test0104");
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

		ModelPCIe modelPCIe = testbench.getModelPCIe();
		PCIe2AxiMaster pci2AxiMaster = testbench.getPCIe2AxiMaster();
		Cpcie2AxiMaster registerfile = pci2AxiMaster.getRegFile();

		/////////////////////////////////////////////////////////////////////
		// 3. Configure the testbench
		/////////////////////////////////////////////////////////////////////
		testbench.init();
		modelPCIe.Delay("WAIT_NANO_SEC", 5000);

		/////////////////////////////////////////////////////////////////////
		// 4. Read back all registers
		/////////////////////////////////////////////////////////////////////
		ArrayList<CRegister> registerList = registerfile.getRegisters();
		for (CRegister register : registerList) {
			String message = String.format("Reading register: @0x%x : %s", register.getAddress(), register.getPath());
			modelPCIe.UbusComment(message);
			modelPCIe.MemRead(register);
		}

		/////////////////////////////////////////////////////////////////////
		// 6. Wait 50 clock cycles
		/////////////////////////////////////////////////////////////////////
		modelPCIe.Delay(UbusRootModel.WAIT_NB_CLK, 50);

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
	public static void main(String[] args) {
		String iniFilePath = System.getenv("IPCORES") + "/pcie2AxiMaster/validation2/java/validation.ini";
		FDKContext context = new FDKContext(iniFilePath);

		debugMode = true;
		if (debugMode) {
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		run(new Test0104(context));
	}

}
