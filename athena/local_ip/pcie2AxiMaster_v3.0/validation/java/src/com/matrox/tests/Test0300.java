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
import com.fdk.validation.models.registerfile.CSection;
import com.matrox.models.Cpcie2AxiMaster;
import com.matrox.models.ModelPCIe;
import com.matrox.models.PCIe2AxiMaster;
import com.matrox.models.UbusRootModel;
import com.matrox.testbench.TestBench;

/**
 * This class defines Test0300.
 * <p>
 * <b>Test Family:</b> PCIExpress BAR0 read/write accesses
 * <p>
 * <b>Description:</b> Activate the 4 windows on BAR0, then write one DWORD in each window and read it back.
 * <p>
 */
public class Test0300 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test0300(FDKContext context)
	{
		super(context, "Test0300");
	}


	/**
	 * Start the test
	 */
	public void run()
	{

		long WINDOW_SIZE = 0x1000;

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
		// 4. Configure the windows
		/////////////////////////////////////////////////////////////////////
		PCIe2AxiMaster pcie2AxiMaster = testbench.getPCIe2AxiMaster();
		Cpcie2AxiMaster regfile = pcie2AxiMaster.getRegFile();

		for (int i = 0; i < 4; i++)
		{
			long regAddr;
			// Retrieve the window registers
			CSection window = regfile.getSection("axi_window");
			window.setOffset(0x100 + (i * 0x10));
			// Calculate window[i] boundaries
			long windowStartAddr = i * WINDOW_SIZE;
			long windowStopAddr = windowStartAddr + WINDOW_SIZE - 1;
			long axi_translation_value = (i + 1) * 0x30000;
			
			// Set the start boundary
			CRegister pcie_bar0_start = window.getRegister("pci_bar0_start");
			pcie_bar0_start.getField("value").setValue(windowStartAddr);
			modelPCIe.MemWrite(pcie_bar0_start);
			regAddr = pcie_bar0_start.getAddress();
			modelPCIe.Delay("WAIT_NANO_SEC", 100);

			// Set the stop boundary
			CRegister pcie_bar0_stop = window.getRegister("pci_bar0_stop");
			pcie_bar0_stop.getField("value").setValue(windowStopAddr);
			modelPCIe.MemWrite(pcie_bar0_stop);
			regAddr = pcie_bar0_stop.getAddress();
			modelPCIe.Delay("WAIT_NANO_SEC", 100);

			// Set axi_translation window offset
			CRegister axi_translation = window.getRegister("axi_translation");
			axi_translation.getField("value").setValue(axi_translation_value);
			modelPCIe.MemWrite(axi_translation);
			regAddr = axi_translation.getAddress();
			modelPCIe.Delay("WAIT_NANO_SEC", 100);

			// Enable the window
			CRegister ctrlReg = window.getRegister("ctrl");
			ctrlReg.getField("enable").setValue(0x1);
			modelPCIe.MemWrite(ctrlReg);
			regAddr = ctrlReg.getAddress();
			modelPCIe.Delay("WAIT_NANO_SEC", 100);
		}

		modelPCIe.Delay("WAIT_NANO_SEC", 500);

		/////////////////////////////////////////////////////////////////////
		// 4. Write/readback in the windows
		/////////////////////////////////////////////////////////////////////
		long BAR0 = testbench.getPcieBAR(0);
		for (int i = 0; i < 4; i++)
		{
			int data = 0xdeadbeef << i*8;
			long windowStart = i * WINDOW_SIZE;
			long address = BAR0 + (windowStart + 0x100);
			modelPCIe.MemWrite(32, address, 3, data);
			modelPCIe.Delay("WAIT_NANO_SEC", 500);
			modelPCIe.MemRead(32, address, 3, data);

		}

		// 5. Wait 500 clock cycles
		/////////////////////////////////////////////////////////////////////
		modelPCIe.Delay(UbusRootModel.WAIT_NB_CLK, 5000);

		/////////////////////////////////////////////////////////////////////
		// 6. Create all model command files (*.in)
		/////////////////////////////////////////////////////////////////////
		testbench.createCmdFiles();

		/////////////////////////////////////////////////////////////////////
		// 7. Start simulation
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

		run(new Test0300(context));
	}

}
