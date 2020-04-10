/**
 * This class defines test 1001. Test1001 is a simple test that sends two streamed images from the stream output models
 * to the stream input model with the input image.
 * 
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
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
 * This class defines test 1001. Test1001 is a simple test that sends two streamed images from the stream output models
 * to the stream input model with the input image.
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
public class Test1001 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test1001(FDKContext context)
	{
		super(context, "test1001");
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
		FDKImage image1 = new FDKImage("SRCImage1", pixel, YSIZE, XSIZE);
		FDKImage image2 = new FDKImage("SRCImage2", pixel, YSIZE, XSIZE);
		//image.setRamp();
		image1.setRandom(1, (short) 0, (short) 255);
		image2.setRandom(2, (short) 0, (short) 255);

		if (debugMode)
		{
			image1.printInfo();
			image2.printInfo();

		}
		int NBBYTES = (NBBITS < 9) ? 1 : 2;
		int FSTART1 = 0x0;
		int LNSIZE = XSIZE * NBCOMP * NBBYTES;
		int LPITCH = 8 * LNSIZE;
		int FSTART2 = 0x4000;

		/////////////////////////////////////////////////////////////////////
		// 4.Create the sram prediction
		/////////////////////////////////////////////////////////////////////
		FDKSramModel predictionSram = new FDKSramModel("sram", 4, 32, 21);
		predictionSram.load(FSTART1, LPITCH, image1);
		predictionSram.load(FSTART2, LPITCH, image2);
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
		dmawr.setFstart(FSTART1);
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
		streamOutModel.sendStream(FDKTestBenchDMAwr.DMAWR_SUB2_BASE_ADDR, image1);
		masterModel.sendTrigger();

		/////////////////////////////////////////////////////////////////////
		// 9. Stop simulation on DMARD end of frame event
		/////////////////////////////////////////////////////////////////////
		masterModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_DMAWR_SUB2_EOF);
		masterModel.sendWaitCmd(50);
		
		dmawr.setFstart(FSTART2);
		dmawr.updateRegisters(masterModel);

		/////////////////////////////////////////////////////////////////////
		// 7. Start DMA read
		/////////////////////////////////////////////////////////////////////
		dmawr.setSnapshot();
		dmawr.updateRegisters(masterModel);
		
		/////////////////////////////////////////////////////////////////////
		// 8. Wait for the master trigger then start the stream 
		/////////////////////////////////////////////////////////////////////
		streamOutModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_MASTER_TRIGGER);
		streamOutModel.sendStream(FDKTestBenchDMAwr.DMAWR_SUB2_SIP_BASE_ADDR, image2);
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

		run(new Test1001(context));
	}

}
