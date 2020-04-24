/**
 * This class defines test 4000. Test4000 is a simple test that DMA one streamed image from the SDRAM model to the
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
 * This class defines test 4000. Test4000 is a simple test that streams an image to the DMA write TU that stores it in
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
public class Test4000 extends FDKTest {

	/**
	 * @param context
	 *            The simulation context used for running this test.
	 */
	public Test4000(FDKContext context)
	{
		super(context, "test4000");
	}


	/**
	 * Start the test
	 */
	public void run()
	{
		//  Enable the debug mode in the test
		debugMode = true;
		int NUMBER_OF_CONTEXTES = 4;

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
		ArrayList<FDKStrmOutModel> streamOutModelList = testBenchModel.getStrmOutModelList();
		FDKDmaWr[] dmawr = testBenchModel.getDmaWrSub6();

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
		for (int i = 0; i < NUMBER_OF_CONTEXTES; i++)
		{
			streamOutModelList.get(i).sendWaitCmd(5);
			streamOutModelList.get(i).sendResetCmd(5);

			/////////////////////////////////////////////////////////////////////
			// 6. Create image
			/////////////////////////////////////////////////////////////////////
			int NBCOMP = 1;
			int NBBITS = 8;
			int XSIZE = 64;
			int YSIZE = 8;

			// Create the source image (a ramp)
			FDKPixel pixel = new FDKPixel(0, 0, 0, 0, NBCOMP, NBBITS, false);
			FDKImage image = new FDKImage("srcImage" + Integer.toString(i), pixel, YSIZE, XSIZE);
			//image.setRamp();
			image.setRandom(i, (short) 0x0, (short) 0xff);

			if (debugMode)
				image.printInfo();

			int NBBYTES = (NBBITS < 9) ? 1 : 2;
			int LNSIZE = XSIZE * NBCOMP * NBBYTES;
			int LPITCH = 8 * LNSIZE;
			int BUFFERSIZE = YSIZE * LPITCH;
			int FSTART = i * BUFFERSIZE;

			predictionSdram.load(FSTART, LPITCH, image);
			dmawr[i].setFstart(FSTART);
			dmawr[i].setDte(0, 1);
			dmawr[i].setLinePitch(LPITCH);
			dmawr[i].setLineSize(LNSIZE);
			dmawr[i].setNbLine(YSIZE);
			dmawr[i].setBitWidth(0);
			dmawr[i].setNbContx(1);
			dmawr[i].setSnapshot();
			dmawr[i].updateRegisters(masterModel);

			/////////////////////////////////////////////////////////////////////
			// 7. Wait for the master trigger then start the stream 
			/////////////////////////////////////////////////////////////////////
			streamOutModelList.get(i).sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_MASTER_TRIGGER);
			streamOutModelList.get(i).sendStream(FDKTestBenchDMAwr.DMAWR_SUB6_SIP_BASE_ADDR[i], image);
		}

		masterModel.sendWaitCmd(50);
		masterModel.sendTrigger();

		/////////////////////////////////////////////////////////////////////
		// 8. Next frame on DMAWR end of frame event
		/////////////////////////////////////////////////////////////////////
		masterModel.sendWaitEventCmd(FDKTestBenchDMAwr.EVENT_DMAWR_SUB6_EOF[0]);
		masterModel.sendWaitCmd(100);

		predictionSdram.dump(new FDKFile(resultDir + "sdramModel.pred"));
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
		// Create prediction file:
		sdramModel.load(new FDKFile(resultDir + "sdramModel.dmp"));
		ArrayList<FDKStatus> memoryStatusList = new ArrayList<FDKStatus>();
		sdramModel.equals(predictionSdram, memoryStatusList);
		getStatusList().addAll(memoryStatusList);

		/////////////////////////////////////////////////////////////////////
		// 11. Report the test status list
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

		run(new Test4000(context));
	}

}
