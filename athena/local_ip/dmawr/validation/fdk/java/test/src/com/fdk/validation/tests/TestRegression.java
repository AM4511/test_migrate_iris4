package com.fdk.validation.tests;

import java.util.ArrayList;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKContext;

/**
 * This class defines TestRegression. TestRegression run consecutively the following tests:
 * <p>
 * <b>Test list:</b>
 * <ul>
 * <li>{@link Test1000}
 * <li>{@link Test1001}
 * <li>{@link Test1002}
 * <li>{@link Test2000}
 * <li>{@link Test2001}
 * <li>{@link Test2002}
 * <li>{@link Test3000}
 * <li>{@link Test4000}
 * </ul>
 * <p>
 */
public class TestRegression {

	/**
	 * @param args
	 */
	public static void main(String[] args)
	{
		FDKConsole.addMessage("** Running FDK DMAWR regression test suite\n");

		// Create the simulation context. Retrieve information from the ini file
		FDKContext context = new FDKContext(System.getenv("FDK_DMAWR"));

		// For debug (GUI and interactive)
		//FDKSimulator Modelsim = context.getSimulator();
		//modelsim.setGuiMode();
		////modelsim.setInteractif();

		context.print();

		/*******************************************************************************
		 * Test Series 1000: SRAM DMARead sub2
		 *******************************************************************************/
		Test1000 test1000 = new Test1000(context);
		Test1001 test1001 = new Test1001(context);
		Test1002 test1002 = new Test1002(context);

		/*******************************************************************************
		 * Test Series 2000: SDRAM DMARead sub4
		 *******************************************************************************/
		Test2000 test2000 = new Test2000(context);
		Test2001 test2001 = new Test2001(context);

		/*******************************************************************************
		 * Test Series 3000: SDRAM DMARead sub5
		 *******************************************************************************/
		Test3000 test3000 = new Test3000(context);

		/*******************************************************************************
		 * Test Series 4000: SDRAM DMARead sub6
		 *******************************************************************************/
		Test4000 test4000 = new Test4000(context);

		/*******************************************************************************
		 * Test Series 5000: SDRAM DMARead sub7
		 *******************************************************************************/

		
		// Running the regression test suite
		test1000.run();
		test1001.run();
		test1002.run();

		test2000.run();
		test2001.run();
		
		test3000.run();

		test4000.run();

		// Print the final report
		ArrayList<String> mArr = new ArrayList<String>();

		mArr.add("======================================================================");
		mArr.add("======================================================================");
		mArr.add("=                                                                    =");
		mArr.add("=   Global Report          Errors Warnings   Status                  =");
		mArr.add("=                                                                    =");
		mArr.add("======================================================================");
		mArr.add("======================================================================");
		FDKConsole.addMessage(mArr);
		test1000.getStatus().print();
		test1001.getStatus().print();
		test1002.getStatus().print();

		test2000.getStatus().print();
		test2001.getStatus().print();

		test3000.getStatus().print();

		test4000.getStatus().print();

		// Exit
		FDKConsole.addMessage("\n\n** Done. **\n");
		System.exit(0);
	}
}
