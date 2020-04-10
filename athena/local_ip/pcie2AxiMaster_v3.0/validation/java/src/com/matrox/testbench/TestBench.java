package com.matrox.testbench;

import java.util.ArrayList;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKGeneric;
import com.fdk.validation.models.FDKClockGeneratorModel;
import com.matrox.models.ModelPCIe;
import com.matrox.models.PCIe2AxiMaster;

public class TestBench {
	private String name;
	private FDKDirectory testDirectory;
	private FDKDirectory resultsDirectory;
	private FDKClockGeneratorModel clockGeneratorModel;
	private ModelPCIe modelPCIe;
	private PCIe2AxiMaster pcie2AxiMaster;

	private long pcieBAR[];
	private int barAxiSlaveModel[];


	public TestBench(FDKDirectory testDirectory, FDKDirectory resultsDirectory) {
		super();

		this.name = "Top level Testbench";
		this.testDirectory = testDirectory;
		this.resultsDirectory = resultsDirectory;

		// Instantiate the clock generator model
		clockGeneratorModel = new FDKClockGeneratorModel();
		modelPCIe = new ModelPCIe(testDirectory, 1, 64);
		pcie2AxiMaster = new PCIe2AxiMaster(testDirectory, modelPCIe);

		this.pcieBAR = new long[4]; // Base address 0 value = 4kB

		// BAR0/1: Memory Space,64 bit, not prefetchable
		this.pcieBAR[0] = 0x0000000010000000L;

		// BAR0/1: 64 bits upper address
		this.pcieBAR[1] = 0x0000000000000000L; 

		// BAR2/3: Memory Space,64 bit, not prefetchable
		this.pcieBAR[2] = 0x0000000020000000L;

		// BAR2/3: Memory Space
		this.pcieBAR[3] = 0x0000000000000000L;


		// Map the pcie2AxiMaster register file base address in the model
		pcie2AxiMaster.getRegFile().setBaseAddress(this.pcieBAR[2]);

		// Map the AXI Slave models
		this.barAxiSlaveModel = new int[2];
		this.barAxiSlaveModel[0] = 0x00000000; 
		this.barAxiSlaveModel[1] = 0x00001000;
	}

	public String getName() {
		return name;
	}

	public FDKDirectory getTestDirectory() {
		return testDirectory;
	}

	/**
	 * @return the resultsDirectory
	 */
	public FDKDirectory getResultsDirectory() {
		return resultsDirectory;
	}

	public FDKClockGeneratorModel getClockGeneratorModel() {
		return clockGeneratorModel;
	}


	public ArrayList<FDKGeneric> getGenericList() {
		ArrayList<FDKGeneric> genericList = new ArrayList<FDKGeneric>();

		// Add the clock model generic
		FDKGeneric generic = new FDKGeneric("CLKPERIOD", clockGeneratorModel.getClockPeriodAsString());
		genericList.add(generic);

		return genericList;
	}

	public void sendResetCmd(int waitDelay, int resetswidth) {
		this.modelPCIe.Reset();
	}

	public void createCmdFiles() {
		modelPCIe.createCmdFile();
	}

	public void dumpPredictionFiles() {

	}

	public void dumpSimulationFiles() {

	}

	public ModelPCIe getModelPCIe() {
		return modelPCIe;
	}

	public PCIe2AxiMaster getPCIe2AxiMaster() {
		return pcie2AxiMaster;
	}

	public void init() {
		modelPCIe.init(false);
		pcie2AxiMaster.init(pcieBAR);
		modelPCIe.Delay("WAIT_NANO_SEC", 100);
		// The training start here.
		modelPCIe.UbusComment("#INITIALISATION DELAY: 2  us");
		modelPCIe.Delay("WAIT_NANO_SEC", 2000);
	}

	/**
	 * @return the base 4 Address Registers
	 */
	public long[] getPcieBARs() {
		return pcieBAR;
	}

	/**
	 * @return the baseAddrReg
	 */
	public long getPcieBAR(int index) {
		if (index < 0 || index > 4 || index == 1) {
			String message = String.format("%d; illegal BAR number");
			FDKConsole.addErrorMessage(message);
			return -1;
		}
		return pcieBAR[index];
	}

	public int getBarAxiSlaveModel(int index) {
		return barAxiSlaveModel[index];
	}

	public void setBarAxiSlaveModel(int index, int barAxiSlaveModel) {
		this.barAxiSlaveModel[index] = barAxiSlaveModel;
	}

}
