package com.fdk.validation.tests;

import java.util.ArrayList;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.images.FDKImage;
import com.fdk.validation.images.FDKPixel;
import com.fdk.validation.models.FDKAvalonMaster;
import com.fdk.validation.models.FDKDmaWr;
import com.fdk.validation.models.FDKSramModel;
import com.fdk.validation.models.FDKStrmOutModel;
import com.fdk.validation.models.FDKTestBenchDMAwr;

/**
 * This class defines test 1000. Test1000 is a simple test that stream an image to the dmawr_sub2 that write it in
 * memory. The stored image is compared with the original sent image. The simulation is stopped on the reception of an
 * EndOf Frame interrupt.
 * <p>
 * <b>Input image parameters:</b>
 * <ul>
 * <li>Number of lines: 8
 * <li>Number of pixels: 64
 * <li>Number of components: 1 (MONO)
 * <li>Number of bits per components: 8 bits
 * <li>Signed pixels: No
 * 
 * </ul>
 */
public class Test1000 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test1000(FDKContext context)
	{
		super(context, "test1000");
	}


	/**
	 * Start the test
	 */
	public void run()
	{
		//  Enable the debug mode in the test
		debugMode = true;

		/////////////////////////////////////////////////////////////////////
		// 1. Initialize the test (create directory structure, etc...)
		/////////////////////////////////////////////////////////////////////
		boolean success = init();
		if (!success)
			return;

		/////////////////////////////////////////////////////////////////////
		// 2. Create the test bench and retrieve model instances
		/////////////////////////////////////////////////////////////////////
		FDKTestBenchDMAwr testBenchModel = new FDKTestBenchDMAwr("testBench", super.getTestDir(), super.getResultsDir());
		FDKSramModel simulationSram = testBenchModel.getSramModel();
		FDKAvalonMaster masterModel = testBenchModel.getAvalonMasterModelList().get(0);
		FDKStrmOutModel streamOutModel = testBenchModel.getStrmOutModelList().get(0);

		// The design Under Test (DUT)
		FDKDmaWr dmawr = testBenchModel.getDmaWrSub2();

		/////////////////////////////////////////////////////////////////////
		// 3. Create image
		/////////////////////////////////////////////////////////////////////
		int NBCOMP = 1;
		int NBBITS = 8;
		int XSIZE = 64;
		int YSIZE = 8;

		// Create the source image (a ramp)
		FDKPixel pixel = new FDKPixel(0, 0, 0, 0, NBCOMP, NBBITS, false);
		FDKImage image = new FDKImage("SRCImage", pixel, YSIZE, XSIZE);
		//image.setRamp();
		image.setRandom(0, (short) 0, (short) 255);

		if (debugMode)
			image.printInfo();

		int NBBYTES = (NBBITS < 9) ? 1 : 2;
		int FSTART = 0x0;
		int LNSIZE = XSIZE * NBCOMP * NBBYTES;
		int LPITCH = 8 * LNSIZE;

		/////////////////////////////////////////////////////////////////////
		// 4. Load image in SRAM Model
		/////////////////////////////////////////////////////////////////////
		FDKSramModel predictionSram = new FDKSramModel("sram", 4, 32, 21);
		predictionSram.load(FSTART, LPITCH, image);
		predictionSram.dump(getResultsDir(), ".pred");

		/////////////////////////////////////////////////////////////////////
		// 5. Reset the testbench and load the image in the hardware
		/////////////////////////////////////////////////////////////////////
		masterModel.sendWaitCmd(50);
		masterModel.sendResetCmd(5);
		masterModel.sendWaitCmd(50);
		masterModel.sendInitCmd();
		masterModel.sendWaitCmd(200);

		// Reset the stream out model
		streamOutModel.sendWaitCmd(5);
		streamOutModel.sendResetCmd(5);

		/////////////////////////////////////////////////////////////////////
		// 6. Configure DMA write engine
		/////////////////////////////////////////////////////////////////////
		dmawr.setFstart(FSTART);
		dmawr.setLinePitch(LPITCH);
		dmawr.setLineSize(LNSIZE);
		dmawr.setNbLine(YSIZE);
		dmawr.setDte(0, 1);
		dmawr.setBitWidth(0);
		dmawr.setNbContx(1);
		dmawr.updateRegisters(masterModel);

		masterModel.sendWaitCmd(50);

		/////////////////////////////////////////////////////////////////////
		// 7. Start DMA read
		/////////////////////////////////////////////////////////////////////
		dmawr.setSnapshot();
		dmawr.updateRegisters(masterModel);

		/////////////////////////////////////////////////////////////////////
		// 8. Wait for the master trigger then start the stream 
		/////////////////////////////////////////////////////////////////////
		streamOutModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_MASTER_TRIGGER);
		streamOutModel.sendStream(FDKTestBenchDMAwr.DMAWR_SUB2_SIP_BASE_ADDR, image);
		masterModel.sendTrigger();

		/////////////////////////////////////////////////////////////////////
		// 9. Stop simulation on DMARD end of frame event
		/////////////////////////////////////////////////////////////////////
		masterModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_DMAWR_SUB2_EOF);
		masterModel.sendWaitCmd(50);
		testBenchModel.dumpSimulationFiles();
		masterModel.sendWaitCmd(50);
		masterModel.sendQuitCmd();

		// Create all model command files (*.in)
		testBenchModel.createCmdFiles();

		/////////////////////////////////////////////////////////////////////
		// 10. Start Modelsim simulator
		/////////////////////////////////////////////////////////////////////
		simulate();

		/////////////////////////////////////////////////////////////////////
		// 11. Post-processing
		/////////////////////////////////////////////////////////////////////
		// Create prediction file:
		FDKFile[] sramDumpFiles = testBenchModel.getSramDumpFiles();
		simulationSram.load(sramDumpFiles);
		ArrayList<FDKStatus> sramStatusList = new ArrayList<FDKStatus>();
		simulationSram.equals(predictionSram, sramStatusList);
		getStatusList().addAll(sramStatusList);

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
		FDKContext context = new FDKContext(System.getenv("FDK_DMAWR"));
		if (true)
		{
			context.getSimulator().setGuiMode();
			context.getSimulator().setInteractif();
		}

		run(new Test1000(context));
	}

}
