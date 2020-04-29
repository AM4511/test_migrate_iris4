package com.matrox.models;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.models.FDKMemoryModel;

public class MVBSPIFlashMemory extends FDKMemoryModel {
	private int pageLength;
	private int sectorSize;


	public MVBSPIFlashMemory(String name, int sizeInBits, int pageLengthAsBytes, int sectorSizeAsBytes, FDKDirectory testDirectory, FDKDirectory resultDirectory)
	{
		super(name, 64, 0);
		double sizeInQWORDS = sizeInBits / 64;
		double addrSizeInBitsAsDouble = Math.ceil(Math.log(sizeInQWORDS) / Math.log(2.0));
		int addrSizeInBitsAsInteger = (int) addrSizeInBitsAsDouble;
		super.setAddrWidthInBits(addrSizeInBitsAsInteger);
		this.pageLength = pageLengthAsBytes;
		this.sectorSize = sectorSizeAsBytes;

		String initFileAbsoluteName = testDirectory.getAbsolutePath() + File.separator + "initM25P16.in";
		FDKFile initFile = new FDKFile(initFileAbsoluteName);
		super.setInitFile(initFile);

		String dumpFileAbsoluteName = resultDirectory.getAbsolutePath() + File.separator + "initM25P16.dmp";
		FDKFile dumpFile = new FDKFile(dumpFileAbsoluteName);
		super.setDumpFile(dumpFile);

		String predictionFileAbsoluteName = resultDirectory.getAbsolutePath() + File.separator + "initM25P16.pred";
		FDKFile predFile = new FDKFile(predictionFileAbsoluteName);
		super.setPredictionFile(predFile);
}


	/**
	 * @return the pageLength
	 */
	public int getPageLength()
	{
		return pageLength;
	}


	/**
	 * @param pageLength
	 *            the pageLength to set
	 */
	public void setPageLength(int pageLength)
	{
		this.pageLength = pageLength;
	}


	/**
	 * @return the sectorSize
	 */
	public int getSectorSize()
	{
		return sectorSize;
	}


	/**
	 * @param sectorSize
	 *            the sectorSize to set
	 */
	public void setSectorSize(int sectorSize)
	{
		this.sectorSize = sectorSize;
	}


	public void dump(FDKFile dumpFile)
	{
		ArrayList<String> fileContent = new ArrayList<String>();
		dumpFile.setContent(fileContent);

		ArrayList<Integer> addressKeys = getAddressList();

		Iterator<Integer> itr = addressKeys.iterator();

		int numberOfRows = (super.getSizeInBytes() / this.pageLength);

		String[][] memoryArray = new String[numberOfRows][this.pageLength];

		while (itr.hasNext())
		{
			HashMap<Integer, Long> memoryLongArray = super.getMemory();
			Integer longAddress = itr.next();
			Long data = memoryLongArray.get(longAddress);

			for (int i = 0; i < 8; i++)
			{
				long byteAddress = longAddress * 8 + i;
				int rowAddress = (int) (byteAddress / this.pageLength);
				int columnAddress = (int) (byteAddress % this.pageLength);
				long currentByte = data >> (8 * i) & 0xffL;
				String currentByteAsString = String.format("%02X", currentByte);
				memoryArray[rowAddress][columnAddress] = currentByteAsString;
			}

		}

		String memoryWord = "";
		for (int y = 0; y < numberOfRows; y++)
		{
			for (int x = 0; x < this.pageLength; x++)
			{
				memoryWord = String.format("%s%s", memoryWord, memoryArray[y][x]);
			}
			fileContent.add(memoryWord);
			memoryWord = "";
		}

		//String memoryWord = String.format("%08x " + DATAFORMAT, address, data);
		//fileContent.add(memoryWord);
		dumpFile.write();
	}


	public void createCmdFile()
	{
		// Create the memory init file for simulation. So take content of the 
		// prediction memory and dump it in the .in file. This file will the be 
		// loaded by the vhdl model at the beginning of the simulation.
		this.dump(super.getInitFile());

	}

}
