package com.fdk.validation.models;

import java.io.File;
import java.util.ArrayList;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKGeneric;

public class FDKTestBenchDMAwr {

	public static final int NUMBERMODELMASTER = 1;
	public static final int NUMBERSIP = 0;
	public static final int NUMBERSOP = 4;
	public static final int NUMBERSRAM = 4;

	//Test bench port mapping
	public static final int DMAWR_SUB2_BASE_ADDR = 0x0;
	public static final int DMAWR_SUB4_BASE_ADDR = 0x200;
	public static final int DMAWR_SUB5_BASE_ADDR = 0x400;
	public static final int DMAWR_SUB6_BASE_ADDR = 0x800;
	public static final int DMAWR_SUB7_BASE_ADDR = 0x1000;

	public static final int DMAWR_SUB2_SIP_BASE_ADDR = 0x0;
	public static final int DMAWR_SUB4_SIP_BASE_ADDR = 0x4000;
	public static final int DMAWR_SUB5_SIP_BASE_ADDR = 0x8000;
	public static final int DMAWR_SUB6_SIP_BASE_ADDR[] = { 0x10000, 0x14000, 0x18000, 0x1c000 };
	public static final int DMAWR_SUB7_SIP_BASE_ADDR[] = { 0x20000, 0x24000 };

	//Test bench events
	public static final int EVENT_MASTER_TRIGGER = 0;
	public static final int EVENT_DMAWR_SUB2_EOF = 0;
	public static final int EVENT_DMAWR_SUB4_EOF = 1;
	public static final int EVENT_DMAWR_SUB5_EOF = 2;
	public static final int[] EVENT_DMAWR_SUB6_EOF = { 3, 4, 5, 6 };
	public static final int[] EVENT_DMAWR_SUB7_EOF = { 7, 7 }; // Both interrupt are ORed in intevent(7)

	private String name;
	private FDKDirectory testDirectory;
	private FDKDirectory resultsDirectory;
	private FDKClockGeneratorModel clockGeneratorModel;
	private ArrayList<FDKAvalonMaster> avalonMasterModelList;

	private ArrayList<FDKStreamInModel> strmInModelList;
	private ArrayList<FDKStrmOutModel> strmOutModelList;
	private ArrayList<AvalonSinkModel> avstSinkModelList;
	private ArrayList<AvalonSourceModel> avstSourceModelList;
	private FDKSramModel sramModel;

	private FDKFile sdramInitFile;
	private FDKMemoryModel sdramModel;

	private FDKDmaWr dmawr_sub2;
	private FDKDmaWr dmawr_sub4;
	private FDKDmaWr dmawr_sub5;
	private FDKDmaWr[] dmawr_sub6;
	private FDKDmaWr[] dmawr_sub7;


	public FDKTestBenchDMAwr(String name, FDKDirectory testDirectory, FDKDirectory resultsDirectory)
	{
		this.name = name;
		this.testDirectory = testDirectory;
		this.resultsDirectory = resultsDirectory;
		this.avalonMasterModelList = new ArrayList<FDKAvalonMaster>();
		this.strmInModelList = new ArrayList<FDKStreamInModel>();
		this.strmOutModelList = new ArrayList<FDKStrmOutModel>();

		this.avstSinkModelList = new ArrayList<AvalonSinkModel>();
		this.avstSourceModelList = new ArrayList<AvalonSourceModel>();
		int componentID = 0;

		// Instantiate the clock generator model
		this.clockGeneratorModel = new FDKClockGeneratorModel();

		//////////////////////////////////////////////////////
		// Instantiate SRAM models
		//////////////////////////////////////////////////////
		this.sramModel = new FDKSramModel("sramModel", NUMBERSRAM, 32, 21);

		//////////////////////////////////////////////////////
		// Instantiate SDRAM models
		//////////////////////////////////////////////////////
		String sdramModelName = "sdramModel";
		this.sdramModel = new FDKMemoryModel(sdramModelName, 512, 26);
		this.sdramInitFile = new FDKFile(new File(testDirectory.getAbsolutePath() + File.separator + sdramModelName + ".init"));
		this.sdramModel.dump(sdramInitFile);

		//////////////////////////////////////////////////////
		// Instantiate stream input port models
		//////////////////////////////////////////////////////
		for (int i = 0; i < NUMBERMODELMASTER; i++)
		{
			String index = "";
			index = Integer.toString(i);
			FDKFile commandFile = new FDKFile(testDirectory.getAbsolutePath() + File.separator + "modelmaster" + index + ".in");
			String modelName = "xAvalonModelMaster" + index;

			// Create the model instance
			int addressBusWidth = 32;
			int dataBusWidth = 64;
			FDKAvalonMaster avalonMasterModel = new FDKAvalonMaster(componentID, modelName, addressBusWidth, dataBusWidth, commandFile);
			avalonMasterModelList.add(avalonMasterModel);

			// Increment the component ID
			componentID++;
		}

		//////////////////////////////////////////////////////
		// Instantiate stream input port models
		//////////////////////////////////////////////////////
		for (int i = 0; i < NUMBERSIP; i++)
		{
			String index = "";
			index = Integer.toString(i);
			FDKFile dumpFile = new FDKFile(this.resultsDirectory.getAbsolutePath() + File.separator + "sipmodel" + index + ".dmp");
			String modelName = "xModelStreamInputPort" + index;

			// Create the model instance
			FDKStreamInModel streamInModel = new FDKStreamInModel(componentID, modelName, testDirectory, this.resultsDirectory);
			strmInModelList.add(streamInModel);

			streamInModel.setDumpFile(dumpFile);

			// Increment the component ID
			componentID++;
		}

		//////////////////////////////////////////////////////
		// Instantiate stream output port models
		//////////////////////////////////////////////////////
		for (int i = 0; i < NUMBERSOP; i++)
		{
			// Create the command file
			String index = "";
			index = Integer.toString(i);
			FDKFile commandFile = new FDKFile(testDirectory.getAbsolutePath() + File.separator + "sopmodel" + index + ".in");
			String modelName = "xModelStreamOutputPortMaster" + index;

			// Create the model instance
			FDKStrmOutModel streamOutModel = new FDKStrmOutModel(componentID, modelName, testDirectory, resultsDirectory);
			strmOutModelList.add(streamOutModel);

			streamOutModel.setCommandFile(commandFile);

			// Increment the component ID
			componentID++;
		}

		//////////////////////////////////////////////////////
		// Instantiate DMAWR_SUB2
		//////////////////////////////////////////////////////
		this.dmawr_sub2 = new FDKDmaWr("dmawr_sub2_0", 2, DMAWR_SUB2_BASE_ADDR);

		//////////////////////////////////////////////////////
		// Instantiate DMAWR_SUB4
		//////////////////////////////////////////////////////
		this.dmawr_sub4 = new FDKDmaWr("dmawr_sub4_0", 4, DMAWR_SUB4_BASE_ADDR);

		//////////////////////////////////////////////////////
		// Instantiate DMAWR_SUB5
		//////////////////////////////////////////////////////
		this.dmawr_sub5 = new FDKDmaWr("dmawr_sub5_0", 5, DMAWR_SUB5_BASE_ADDR);

		//////////////////////////////////////////////////////
		// Instantiate DMAWR_SUB6
		//////////////////////////////////////////////////////
		this.dmawr_sub6 = new FDKDmaWr[4];
		for (int i = 0; i < 4; i++)
		{
			this.dmawr_sub6[i] = new FDKDmaWr("dmawr_sub6_" + Integer.toString(i), 6, DMAWR_SUB6_BASE_ADDR + i * FDKDmaWr.REGISTERFILESIZE);
		}

		//////////////////////////////////////////////////////
		// Instantiate DMAWR_SUB7
		//////////////////////////////////////////////////////
		this.dmawr_sub7 = new FDKDmaWr[4];
		for (int i = 0; i < 2; i++)
		{
			this.dmawr_sub7[i] = new FDKDmaWr("dmawr_sub7_" + Integer.toString(i), 7, DMAWR_SUB7_BASE_ADDR + i * FDKDmaWr.REGISTERFILESIZE);
		}
	}


	public String getName()
	{
		return name;
	}


	public FDKDirectory getTestDirectory()
	{
		return testDirectory;
	}


	public FDKClockGeneratorModel getClockGeneratorModel()
	{
		return clockGeneratorModel;
	}


	public ArrayList<FDKAvalonMaster> getAvalonMasterModelList()
	{
		return avalonMasterModelList;
	}


	public void setAvalonMasterModelList(ArrayList<FDKAvalonMaster> avalonMasterModelList)
	{
		this.avalonMasterModelList = avalonMasterModelList;
	}


	public ArrayList<AvalonSinkModel> getAvalonSinkModelList()
	{
		return avstSinkModelList;
	}


	public ArrayList<AvalonSourceModel> getAvalonSourceModelList()
	{
		return avstSourceModelList;
	}


	public ArrayList<FDKStrmOutModel> getStrmOutModelList()
	{
		return strmOutModelList;
	}


	public ArrayList<FDKStreamInModel> getStrmInModelList()
	{
		return strmInModelList;
	}


	public FDKMemoryModel getSdramModel()
	{
		return sdramModel;
	}


	public FDKSramModel getSramModel()
	{
		return sramModel;
	}


	public FDKDmaWr getDmaWrSub2()
	{
		return dmawr_sub2;
	}


	public FDKDmaWr getDmaWrSub4()
	{
		return dmawr_sub4;
	}


	public FDKDmaWr getDmaWrSub5()
	{
		return dmawr_sub5;
	}


	public FDKDmaWr[] getDmaWrSub6()
	{
		return dmawr_sub6;
	}


	public FDKDmaWr[] getDmaWrSub7()
	{
		return dmawr_sub7;
	}


	public ArrayList<FDKGeneric> getGenericList()
	{
		ArrayList<FDKGeneric> genericList = new ArrayList<FDKGeneric>();

		// Add the clock model generic
		FDKGeneric generic = new FDKGeneric("CLKPERIOD", clockGeneratorModel.getClockPeriodAsString());
		genericList.add(generic);

		// Add the Avalon stream sink model generic
		for (AvalonSinkModel sinkModel : avstSinkModelList)
		{
			generic = new FDKGeneric("AVSTSINK_DMPFILENAME", sinkModel.getDumpFile().getFilename());
			genericList.add(generic);
		}

		// Add the Avalon stream source model generic
		for (AvalonSourceModel sourceModel : avstSourceModelList)
		{
			generic = new FDKGeneric("AVSTSOURCE_CMDFILENAME", sourceModel.getCommandFile().getFilename());
			genericList.add(generic);
		}

		// Add the stream output model generic
		for (FDKStreamInModel streamInModel : strmInModelList)
		{
			generic = new FDKGeneric("SIP_DMPFILENAME", streamInModel.getDumpFile().getFilename());
			genericList.add(generic);

			generic = new FDKGeneric("SIP_MODELNAME", streamInModel.getName());
			genericList.add(generic);
		}

		// Add the stream output model generic
		for (FDKStrmOutModel streamOutModel : strmOutModelList)
		{
			generic = new FDKGeneric("SOP_CMDFILENAME", streamOutModel.getCommandFile().getFilename());
			genericList.add(generic);

			generic = new FDKGeneric("SOP_MODELNAME", streamOutModel.getName());
			genericList.add(generic);
		}

		return genericList;
	}


	public void sendResetCmd(int waitDelay, int resetswidth)
	{
		sendWaitCmd(waitDelay);
		for (FDKAvalonMaster avalonMasterModel : avalonMasterModelList)
		{
			avalonMasterModel.sendResetCmd(resetswidth);
		}

		for (FDKStrmOutModel strmOutModel : strmOutModelList)
		{
			strmOutModel.sendResetCmd(resetswidth);
		}
	}


	public void sendWaitCmd(int waitDelay)
	{
		for (FDKAvalonMaster avalonMasterModel : avalonMasterModelList)
		{
			avalonMasterModel.sendWaitCmd(waitDelay);
		}

		for (FDKStrmOutModel strmOutModel : strmOutModelList)
		{
			strmOutModel.sendWaitCmd(waitDelay);
		}
		
	}


	public void createCmdFiles()
	{

		// Create the Avalon Master model command files
		for (FDKAvalonMaster avalonMasterModel : avalonMasterModelList)
		{
			avalonMasterModel.createCmdFile();
		}

		// Create the Avalon stream source models command file
		for (AvalonSourceModel sourceModel : avstSourceModelList)
		{
			sourceModel.createCmdFile();
		}

		// Create the stream output models command file
		for (FDKStrmOutModel streamOutModel : strmOutModelList)
		{
			streamOutModel.createCmdFile();
		}

		sramModel.dump(testDirectory, ".init");
		sdramModel.dump(this.sdramInitFile);
	}


	public FDKFile[] getSramDumpFiles()
	{
		FDKFile[] dumpFiles = new FDKFile[NUMBERSRAM];

		for (int i = 0; i < dumpFiles.length; i++)
		{
			File sramDumpFile = new File(this.resultsDirectory.getAbsolutePath() + File.separator + "sramModel" + Integer.toString(i) + ".dmp");
			if (sramDumpFile.exists())
			{
				dumpFiles[i] = new FDKFile(sramDumpFile);
			}
			else
			{
				dumpFiles[i] = null;
			}
		}

		return dumpFiles;
	}


	public void dumpSimulationFiles()
	{
		avalonMasterModelList.get(0).sendDumpCmd();
	}

}
