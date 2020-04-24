/**
 * This class defines test 2001. Test2001 is a simple test that DMA one streamed image from the SDRAM model to the
 * stream input model.
 * 
 * @author amarchan@matrox.com
 * @version $Revision: 141 $
 * @since 1.6
 */
package com.fdk.validation.tests;

import java.io.File;
import java.util.ArrayList;

import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.images.FDKImage;
import com.fdk.validation.images.FDKPixel;
import com.fdk.validation.models.FDKAvalonMaster;
import com.fdk.validation.models.FDKDmaWr;
import com.fdk.validation.models.FDKMemoryModel;
import com.fdk.validation.models.FDKStrmOutModel;
import com.fdk.validation.models.FDKTestBenchDMAwr;

/**
 * This class defines test 2001. Test2001 is a simple test that streams an image to the DMA write TU that stores it in
 * SDRAM memory. The SDRAM contents image is compared with the input image. The simulation is stopped on the reception
 * of an End Of Frame interrupt.
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
public class Test2001 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test2001(FDKContext context)
	{
		super(context, "test2001");
	}


	/**
	 * Start the test
	 */
	public void run()
	{
		//  Enable the debug mode in the test
		debugMode = true;
		int NUMBER_OF_FRAMES = 16;

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
		FDKAvalonMaster masterModel = testBenchModel.getAvalonMasterModelList().get(0);
		FDKMemoryModel sdramModel = testBenchModel.getSdramModel();
		FDKStrmOutModel streamOutModel = testBenchModel.getStrmOutModelList().get(0);
		FDKDmaWr dmawr = testBenchModel.getDmaWrSub4();


		/////////////////////////////////////////////////////////////////////
		// 4. Load image in SRAM Model
		/////////////////////////////////////////////////////////////////////
		String resultDir = getResultsDir().getAbsolutePath() + File.separator;
		FDKMemoryModel predictionSdram = new FDKMemoryModel("sdramModel", 512, 26);

		
		/////////////////////////////////////////////////////////////////////
		// 5. Reset the testbench and load the image in the hardware
		/////////////////////////////////////////////////////////////////////
		testBenchModel.sendResetCmd(50, 5);
		testBenchModel.sendWaitCmd(50);
		masterModel.sendInitCmd();
		masterModel.sendWaitCmd(200);

		// Reset the stream out model
		streamOutModel.sendWaitCmd(5);
		streamOutModel.sendResetCmd(5);

		for (int i = 0; i < NUMBER_OF_FRAMES; i++)
		{
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
			int LNSIZE = XSIZE * NBCOMP * NBBYTES;
			int LPITCH = 8 * LNSIZE;
			int BUFFERSIZE = YSIZE * LPITCH;
			int FSTART = i * BUFFERSIZE * 2;

			predictionSdram.load(FSTART, LPITCH, image);

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
			streamOutModel.sendStream(FDKTestBenchDMAwr.DMAWR_SUB4_SIP_BASE_ADDR, image);
			masterModel.sendTrigger();

			/////////////////////////////////////////////////////////////////////
			// 9. Next frame on DMAWR end of frame event
			/////////////////////////////////////////////////////////////////////
			masterModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_DMAWR_SUB4_EOF);
			masterModel.sendWaitCmd(50);
		}

		predictionSdram.dump(new FDKFile(resultDir + "sdramModel.pred"));
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
		// 6. Post-processing
		/////////////////////////////////////////////////////////////////////
		// Create prediction file:
		sdramModel.load(new FDKFile(resultDir + "sdramModel.dmp"));
		ArrayList<FDKStatus> memoryStatusList = new ArrayList<FDKStatus>();
		sdramModel.equals(predictionSdram, memoryStatusList);
		getStatusList().addAll(memoryStatusList);

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

		run(new Test2001(context));
	}

}
