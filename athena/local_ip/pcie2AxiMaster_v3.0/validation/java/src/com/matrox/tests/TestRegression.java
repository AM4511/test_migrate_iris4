package com.matrox.tests;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKContext;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.core.FDKTest;
import com.fdk.validation.simulators.IFDKSimultor;

/**
 * <b>Test name: TestMCoreRegression</b>
 * <p>
 * <b>Purpose:</b> Regression test suite for the PCIe2AxiMaster IP-Core.
 * <p>
 * This test run all defined test consecutively on one CPU.
 * <p>
 * 
 * @author amarchan
 * 
 */
public class TestRegression {

	public static FDKContext createContext()
	{
		String iniFilePath = System.getenv("IPCORES") + "/pcie2AxiMaster/validation/java/validation.ini";
		FDKContext context = new FDKContext(iniFilePath);
		IFDKSimultor modelsim = context.getSimulator();

		// Enable the coverage
		modelsim.setCoverageEn(false);
		context.setDebugMode(false);

		return context;
	}


	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		boolean do_serie0000 = true;
		boolean do_serie0100 = true;
		boolean do_serie0200 = true;
		boolean do_serie0300 = true;

		FDKContext defaultContext = createContext();

		ArrayList<FDKTest> fullTestList = new ArrayList<FDKTest>();
		ArrayList<File> coverageFileList = new ArrayList<File>();
		ArrayList<FDKStatus> statusList = new ArrayList<FDKStatus>();

		FDKConsole.addMessage("** Running Matrox PCIe2AXIMaster regression test suite\n");

		/////////////////////////////////////////////////////////////////////////////////////
		// Create the simulation context. Retrieve information from the ini file
		/////////////////////////////////////////////////////////////////////////////////////
		String logFileName = String.format("%s/results/Report_%s", defaultContext.getWorkingDirectory().getAbsolutePath(), defaultContext.getSimulator().getName());
		FDKFile reportDumpFile = new FDKFile(logFileName);

		/////////////////////////////////////////////////////////////////////////////////////
		// Section 0000: Test PCIe endpoint section configuration access
		/////////////////////////////////////////////////////////////////////////////////////
		ArrayList<FDKTest> serie000_testList = new ArrayList<FDKTest>();

		serie000_testList.add(new Test0000(defaultContext));
		//		serie000_testList.add(new Test0001(defaultContext));

		//Add the 000 testlist serie in the global list
		if (do_serie0000)
		{
			fullTestList.addAll(serie000_testList);

		}

		/////////////////////////////////////////////////////////////////////////////////////
		// Section 0100: Test PCIe Bar2 PCIE2AXIMaster registerfile accesses
		/////////////////////////////////////////////////////////////////////////////////////
		ArrayList<FDKTest> serie100_testList = new ArrayList<FDKTest>();

		serie100_testList.add(new Test0100(defaultContext));
		serie100_testList.add(new Test0101(defaultContext));
		serie100_testList.add(new Test0102(defaultContext));
		serie100_testList.add(new Test0103(defaultContext));
		serie100_testList.add(new Test0104(defaultContext));

		//Add the 100 testlist serie in the global list
		if (do_serie0100)
			fullTestList.addAll(serie100_testList);

		/////////////////////////////////////////////////////////////////////////////////////
		// Section 0200: Test PCIe-to-AXI Master
		/////////////////////////////////////////////////////////////////////////////////////
		ArrayList<FDKTest> serie200_testList = new ArrayList<FDKTest>();

		// Acquisition start messages
		serie200_testList.add(new Test0200(defaultContext));
		serie200_testList.add(new Test0201(defaultContext));
		serie200_testList.add(new Test0202(defaultContext));
		serie200_testList.add(new Test0210(defaultContext));
		serie200_testList.add(new Test0211(defaultContext));
		serie200_testList.add(new Test0220(defaultContext));
		serie200_testList.add(new Test0230(defaultContext));

		//Add the 200 testlist serie in the global list
		if (do_serie0200)
			fullTestList.addAll(serie200_testList);

		/////////////////////////////////////////////////////////////////////////////////////
		// Section 0300: Test PCIe-to-AXI Master bridge windowing
		/////////////////////////////////////////////////////////////////////////////////////
		ArrayList<FDKTest> serie300_testList = new ArrayList<FDKTest>();

		// Acquisition start messages
		serie300_testList.add(new Test0300(defaultContext));

		//Add the 300 testlist serie in the global list
		if (do_serie0300)
			fullTestList.addAll(serie300_testList);

		/////////////////////////////////////////////////////////////////////////////////////
		// Run the full regression test list.
		/////////////////////////////////////////////////////////////////////////////////////
		boolean RUN_ALL = true;
		Iterator<FDKTest> iterator;

		if (RUN_ALL)
		{
			iterator = fullTestList.iterator();
		}
		else
		{
			iterator = serie200_testList.iterator();
		}

		// Run all tests
		for (Iterator<FDKTest> itr = iterator; itr.hasNext();)
		{
			FDKTest testxxxx = itr.next();
			String testName = testxxxx.getName();
			IFDKSimultor simulator = testxxxx.getContext().getSimulator();
			simulator.setCoverageFileName(testName + ".ucdb");

			testxxxx.run();
			long simulationDuration = testxxxx.getClockWallDuration();
			// Save test status
			FDKStatus testStatus = new FDKStatus(testxxxx.getStatus());
			testStatus.setDuration(simulationDuration);
			statusList.add(testStatus);

			// Store coverage files (.ucdb) in a file list
			String coverageFilePath = testxxxx.getTestDir().getAbsolutePath() + File.separator + testName + ".ucdb";
			File ucdbFile = new File(coverageFilePath);
			if (ucdbFile.exists())
			{
				coverageFileList.add(ucdbFile);
			}

			printReport(statusList, reportDumpFile, false, true);

			// Remove executed test from the list (Make sure the Garbage Collector free the memory)
			testxxxx.done();
			itr.remove();
		}

		// Merge coverage if coverage enabled
		if (defaultContext.getSimulator().isCoverageEn())
		{
			File mergedUCDBFile = new File(defaultContext.getWorkingDirectory().getAbsolutePath() + File.separator + "mcore_coverage.ucdb");
			defaultContext.getSimulator().mergeCoverageFiles(coverageFileList, mergedUCDBFile, "-verbose");
		}

		printReport(statusList, reportDumpFile, true, true);

		// Exit
		FDKConsole.addMessage("\n\n** Done. **\n");
		System.exit(0);
	}


	public static void printReport(ArrayList<FDKStatus> statusList, FDKFile dumpFile, boolean dumpInConsole, boolean dumpInFile)
	{

		// Print the test summary
		int totalErrors = 0;
		int totalWarnings = 0;
		long totalDuration = 0;

		ArrayList<String> mArr = new ArrayList<String>();

		mArr.add("======================================================================");
		mArr.add("=                                                                    =");
		mArr.add("=                        - GLOBAL REPORT -                           =");
		mArr.add("=                                                                    =");
		mArr.add("======================================================================");
		mArr.add("= Test name                Errors Warnings  Status                   =");
		mArr.add("======================================================================");
		//FDKConsole.addMessage(mArr);

		// Print every test status
		for (FDKStatus s : statusList)
		{
			String statusLine = String.format("%-25s %7d %8d  %s\t(%.1fs)", s.getName(), s.getErrorCnt(), s.getWarningCnt(), s.getStatus(), (long) s.getDuration() / 1000.0);
			mArr.add(statusLine);

			totalErrors += s.getErrorCnt();
			totalWarnings += s.getWarningCnt();
			totalDuration += s.getDuration();
		}

		// Print the total
		mArr.add("======================================================================");
		String summary = String.format("%-25s %7d %8d", "Total", totalErrors, totalWarnings);
		mArr.add(summary);

		summary = String.format("\nTotal duration: %.2f sec.", (long) totalDuration / 1000.0);
		mArr.add(summary);

		// Calculate the date when the testlist completed
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss zzzz");
		Calendar cal = Calendar.getInstance();
		String date = dateFormat.format(cal.getTime());
		summary = String.format("\n\n** Done. %s**\n", date);
		mArr.add(summary);
		if (dumpInFile)
		{
			dumpFile.setContent(mArr);
			dumpFile.write();
		}

		if (dumpInConsole)
		{
			FDKConsole.addMessage("\n\n\n");
			FDKConsole.addMessage(mArr);
		}
	}

}
