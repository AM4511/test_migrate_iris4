/**
 * This class defines test 1002. Test1002 is a simple test that sends n streamed images from the stream output models to
 * the stream input model with the input image.
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
 * This class defines test 1002. Test1002 is a simple test that reads an image in memory and streams it. The output
 * image is compared with the input image. The simulation is stopped on the reception of an EndOf Frame interrupt.
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
public class Test1002 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test1002(FDKContext context)
	{
		super(context, "test1002");
	}


	/**
	 * Start the test
	 */
	public void run()
	{
		int NUMBER_OF_FRAMES = 16;

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
		// 3. Create the prediction stream
		/////////////////////////////////////////////////////////////////////
		FDKSramModel predictionSram = new FDKSramModel("sram", 4, 32, 21);

		/////////////////////////////////////////////////////////////////////
		// 3. Create image
		/////////////////////////////////////////////////////////////////////
		int NBCOMP = 1;
		int NBBITS = 8;
		int XSIZE = 64;
		int YSIZE = 8;

		/////////////////////////////////////////////////////////////////////
		// 4. Reset the testbench
		/////////////////////////////////////////////////////////////////////
		testBenchModel.sendResetCmd(50, 5);
		testBenchModel.sendWaitCmd(50);
		
		masterModel.sendInitCmd();
		masterModel.sendWaitCmd(200);

		
		
		/////////////////////////////////////////////////////////////////////
		// 4. Load the image in the hardware and do the DMA
		/////////////////////////////////////////////////////////////////////
		for (int i = 0; i < NUMBER_OF_FRAMES; i++)
		{

			// Create the source image (a ramp)
			FDKPixel pixel = new FDKPixel(0, 0, 0, 0, NBCOMP, NBBITS, false);
			FDKImage image = new FDKImage("SRCImage", pixel, YSIZE, XSIZE);
			//image.setRamp();
			image.setRandom(i, (short) 0, (short) 255);
			//			if (i == 0)
			//			{
			//				image.setConstant(0x55);
			//
			//			}
			//			else
			//			{
			//				image.setConstant(0xaa);
			//
			//			}
			//image.setConstant(i);
			if (debugMode)
				image.printInfo();


			/////////////////////////////////////////////////////////////////////
			// 4. Load image in SRAM Model
			/////////////////////////////////////////////////////////////////////
			int NBBYTES = (NBBITS < 9) ? 1 : 2;
			int LNSIZE = XSIZE * NBCOMP * NBBYTES;
			int LPITCH = 8 * LNSIZE;
			int BUFFERSIZE = YSIZE * LPITCH;
			int FSTART = i * BUFFERSIZE * 2;

			/////////////////////////////////////////////////////////////////////
			// 4. Load image in SRAM Model
			/////////////////////////////////////////////////////////////////////
			predictionSram.load(FSTART, LPITCH, image);
			predictionSram.dump(getResultsDir(), ".pred");


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
			masterModel.sendWaitCmd(10);

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
		}

		/////////////////////////////////////////////////////////////////////
		// 8. Stop simulation on DMARD end of frame event
		/////////////////////////////////////////////////////////////////////
		masterModel.sendWaitCmd(5);
		testBenchModel.dumpSimulationFiles();
		masterModel.sendWaitCmd(50);
		masterModel.sendQuitCmd();

		// Create all model command files (*.in)
		testBenchModel.createCmdFiles();

		/////////////////////////////////////////////////////////////////////
		// 9. Start Modelsim simulator
		/////////////////////////////////////////////////////////////////////
		simulate();

		/////////////////////////////////////////////////////////////////////
		// 10. Post-processing
		/////////////////////////////////////////////////////////////////////
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

		run(new Test1002(context));
	}

}
