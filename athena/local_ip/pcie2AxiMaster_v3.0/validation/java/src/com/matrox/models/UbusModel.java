package com.matrox.models;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.models.registerfile.CRegister;

public class UbusModel extends ValidationModel {
	CMVBUbus ubusRegFile;


	//	   // Global register
	//	   CRegister   CL_BUS_CONTROL_UBUS; // 0 = reset the bus clock, 1 = start the bus clock
	//	   CRegister   TB_RESET_UBUS;       // Resets the testbench for tb_reset_time nanoseconds.
	//	   CRegister   TB_WAIT1_UBUS;       // Allows the simulation to proceed for tb_wait_time nanoseconds.
	//	   CRegister   TB_WAIT2_UBUS;       // Allows the simulation to proceed for tb_wait_cycles clock cycles.
	//	   CRegister   TB_WAIT3_UBUS;       // Allows the simulation to wait until tb_wait_until nanoseconds.
	//	   CRegister   TB_POLL_MASK_UBUS;   // mask to ubus poll operations
	//	   CRegister   TB_READ_MASK_UBUS;   // mask to ubus read operations
	//	   CRegister   TB_POLL_TIMER_LIMIT_UBUS; // Ubus Poll Limit in picoseconds. 0 = disabled.
	//	   CRegister   PKT_CMD_UBUS;             // Specifies the type of command to perform.
	//	   CRegister   PKT_ADDR_HIGH_UBUS;       // Specifies the high address for the command. 
	//	   CRegister   PKT_ADDR_LOW_UBUS;        // Specifies the low address for the command. 
	//	   CRegister   PKT_BYTE_COUNT_UBUS;      // Specifies the length. 
	//	   CRegister   PKT_DATA_UBUS;            // Specifies the data to be stored in the pkt_index.

	public UbusModel(FDKDirectory testDirectory)
	{
		super(testDirectory);
		this.ubusRegFile = new CMVBUbus();

		//		//UBUS REGISTERS NSYS
		//		//NameIn           BaseAddressIn   NbrFieldIn      WriteMaskIn   ReadMaskIn
		//		CL_BUS_CONTROL_UBUS      ("CL_BUS_CONTROL_UBUS",      0x084,          2 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_RESET_UBUS            ("TB_RESET_UBUS",            0x000,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_WAIT1_UBUS            ("TB_WAIT1_UBUS",            0x001,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_WAIT2_UBUS            ("TB_WAIT2_UBUS",            0x002,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_WAIT3_UBUS            ("TB_WAIT3_UBUS",            0x003,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_POLL_MASK_UBUS        ("TB_POLL_MASK_UBUS",        0x006,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_READ_MASK_UBUS        ("TB_READ_MASK_UBUS",        0x007,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		TB_POLL_TIMER_LIMIT_UBUS ("TB_POLL_TIMER_LIMIT_UBUS", 0x00A,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		PKT_CMD_UBUS             ("PKT_CMD_UBUS",             0xB00,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		PKT_ADDR_HIGH_UBUS       ("PKT_ADDR_HIGH_UBUS",       0xB01,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		PKT_ADDR_LOW_UBUS        ("PKT_ADDR_LOW_UBUS",        0xB02,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		PKT_BYTE_COUNT_UBUS      ("PKT_BYTE_COUNT_UBUS",      0xB03,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  ),
		//		PKT_DATA_UBUS            ("PKT_DATA_UBUS",            0xB06,          1 ,        0xFFFFFFFF,   0xFFFFFFFF  )
		//		{
		//		// Set the default value for each register.
		//		SetRegister();
		//		}
		//		

	}


//	@Override
//	public boolean createCmdFile()
//	{
//		// TODO Auto-generated method stub
//		return false;
//	}


	/**
	 * @return the ubusRegFile
	 */
	public CMVBUbus getUbusRegFile()
	{
		return ubusRegFile;
	}


	/**
	 * @param ubusRegFile the ubusRegFile to set
	 */
	public void setUbusRegFile(CMVBUbus ubusRegFile)
	{
		this.ubusRegFile = ubusRegFile;
	}


	////////////////////////////////////////////////////////////////////////////////
	//
	//UBUS COMMAND (e,l,k,b)
	//
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::UbusWrite(CRegister RegisterName,  int Value); 
	//DESCRIPTION:  Write the ubus command(e) in the .in file. 
	//1) CRegister RegisterName: Specific class of the register. 
	//2) int Value: Register value
	//**The .in file have the following format for a UbusWrite:
	//UBUS COMMAND | UBUS ADDRESS(3 hex digits) | UBUS VALUE(8 hex digits)
	//e               XXX                         XXXXXXXX  
	//RETURN VALUE:  void
	////////////////////////////////////////////////////////////////////////////////
	public void UbusWrite(CRegister register, int Value)
	{

		// Set data in the register
		register.setValue(Value);
		long addr = register.getAddress();
		//Build line to write
		String command = String.format("e %04X %08X", addr , Value);

		cmdFile.append(command);

	}


	public void UbusWrite(CRegister register)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();
		long Value = (int) register.getValue();

		//Build line to write
		String command = String.format("e %03X %08X", BaseAddress, Value);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//**TO VERIFY: cbaribea
	//FUNCTION NAME: CUbus::UbusRead(CRegister RegisterName); 
	//DESCRIPTION:  Read the ubus value corresponding to the address. 
	//1) CRegister RegisterName: Specific class of the register. 
	//**The .in file have the following format for a UbusRead:
	//UBUS COMMAND | UBUS ADDRESS(3 hex digits) | UBUS VALUE(8 hex digits)
	//l               XXX                         DON'T CARE 
	//RETURN VALUE: void 
	////////////////////////////////////////////////////////////////////////////////
	public void UbusRead(CRegister register)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();

		//Build line to write
		String command = String.format("l %03X", BaseAddress);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//**TO VERIFY: cbaribea
	//FUNCTION NAME:CUbus::UbusVerify(CRegister RegisterName,int ValueToVerify); 
	//DESCRIPTION:  Verify the ubus value corresponding to the address. 
	//1) CRegister RegisterName: Specific class of the register. 
	//2) ValueToVerify: Specific value to verify.
	//**The .in file have the following format for a UbusVerify:
	//UBUS COMMAND | UBUS ADDRESS(3 hex digits) | UBUS TO VERIFY(8 hex digits)
	//k               XXX                         XXXXXXXX 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void UbusVerify(CRegister register, int ValueToVerify)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();

		//Build line to write
		String command = String.format("l %03X %08X", BaseAddress, ValueToVerify);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::UbusPoll(CRegister RegisterName,int PollingValue); 
	//DESCRIPTION:  Polling on a ubus command.  
	//1) CRegister RegisterName: Specific class of the register. 
	//2) PollingValue: Polling value
	//**The .in file have the following format for a UbusPoll:
	//UBUS COMMAND | UBUS ADDRESS(3 hex digits) | POLLING VALUE(8 hex digits)
	//b               XXX                         XXXXXXXX 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void UbusPoll(CRegister register, int PollingValue)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();

		//Build line to write
		String command = String.format("b %03X %08X", BaseAddress, PollingValue);

		//Send line to the .in file.
		cmdFile.append(command);

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::ProtocolWrite(CRegister RegisterName,int ValueToWrite); 
	//DESCRIPTION:  Write value at the specific address. 
	//1) CRegister RegisterName: Specific class of the register. 
	//2) ValueToWrite: Specific value to write at the corresponding address 
	//of the register.
	//**The .in file have the following format for a ProtocolWrite:
	//UBUS COMMAND | ADDRESS(3 hex digits) | WRITE VALUE(8 hex digits)
	//w                 XXX                         XXXXXXXX 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void ProtocolWrite(CRegister register, int ValueToWrite)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();

		//Build line to write
		String command = String.format("w %03X %08X", BaseAddress, ValueToWrite);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::ProtocolPoll(CRegister RegisterName,int PollingValue); 
	//DESCRIPTION:  Polling on a specific register. 
	//1) CRegister RegisterName: Specific class of the register. 
	//2) PollingValue: Polling value.
	//**The .in file have the following format for a ProtocolPoll:
	//UBUS COMMAND | ADDRESS(3 hex digits) | POLLING VALUE(8 hex digits)
	//p                 XXX                         XXXXXXXX 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void ProtocolPoll(CRegister register, int PollingValue)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();

		//Build line to write
		String command = String.format("p %03X %08X", BaseAddress, PollingValue);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::Delay(CRegister RegisterName,int DelayValue); 
	//DESCRIPTION:  Add delay. Register name give the form of the delay(cycles,ps,fs) 
	//1) Type : Specify the type of delay.
	//WAIT_NANO_SEC       : for tb_wait_time nanoseconds
	//WAIT_NB_CLK         : for tb_wait_cycles clock cycles
	//WAIT_UNTIL_NANO_SEC : until tb_wait_until nanoseconds
	//2) DelayValue: Value of the delay.
	//**The .in file have the following format for a Delay:
	//UBUS COMMAND | ADDRESS(3 hex digits) | DELAY VALUE(8 hex digits)
	//d                 XXX                         XXXXXXXX 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void Delay(String delayType, int DelayValue)
	{
		long BaseAddress = 0;

		if (delayType.equalsIgnoreCase("WAIT_NANO_SEC"))
		{
			BaseAddress = ubusRegFile.getRegister("TB_WAIT1_UBUS").getAddress();
		}
		else if (delayType.equalsIgnoreCase("WAIT_NB_CLK"))
		{
			BaseAddress = ubusRegFile.getRegister("TB_WAIT2_UBUS").getAddress();
		}
		else if (delayType.equalsIgnoreCase("WAIT_UNTIL_NANO_SEC"))
		{
			BaseAddress = ubusRegFile.getRegister("TB_WAIT3_UBUS").getAddress();
		}
		else
		{

			String message = String.format("Invalid delay type: %s", delayType);

			FDKConsole.addErrorMessage(message);

		}

		//Build line to write
		String command = String.format("d %03X %08X", BaseAddress, DelayValue);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME:CUbus::Comment(char *CommentToAdd); 
	//DESCRIPTION:  Add comment in the .in file. 
	//**The .in file have the following format for a Comment:
	//UBUS COMMAND | COMMENT
	//c         xxxxxxxxxxxxxxxxxxxxxxxx
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void UbusComment(String CommentToAdd)
	{

		//Build line to write
		String command = String.format("c %s", CommentToAdd);

		//Send line to the .in file.
		cmdFile.append(command);
	}


	////////////////////////////////////////////////////////////////////////////////
	//**TO VERIFY: cbaribea
	//FUNCTION NAME:CUbus::Reset(); 
	//DESCRIPTION:  Reset. 
	//**The .in file have the following format for a Reset:
	//UBUS COMMAND 
	//z                 
	//RETURN VALUE: void  
	////////////////////////////////////////////////////////////////////////////////
	public void Reset()
	{
		//Send line to the .in file.
		cmdFile.append("z");
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: CUbus::set_register()
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
//	void SetRegister()
//	{
//		//CL_BUS_CONTROL_UBUS(084) --> 2 field to set
//		//
//		// 0 = reset the bus clock, 1 = start the bus clock
//		CL_BUS_CONTROL_UBUS.InitField(0, "cl_clk_resetN", 0, 1, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//		// 0 = reset the bus, 1 = de-assert the bus reset
//		CL_BUS_CONTROL_UBUS.InitField(1, "cl_bus_resetN", 28, 1, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_RESET_UBUS(000) --> 1 field to set
//		//
//		// Resets the testbench for tb_reset_time nanoseconds.
//		TB_RESET_UBUS.InitField(0, "tb_reset_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_WAIT1_UBUS(001) --> 1 field to set
//		//
//		// Allows the simulation to proceed for tb_wait_time nanoseconds.
//		TB_WAIT1_UBUS.InitField(0, "tb_wait1_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_WAIT2_UBUS(002) --> 1 field to set
//		//
//		// Allows the simulation to proceed for tb_wait_cycles clock cycles.
//		TB_WAIT2_UBUS.InitField(0, "tb_wait2_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_WAIT3_UBUS(003) --> 1 field to set
//		//
//		// Allows the simulation to wait until tb_wait_until nanoseconds.
//		TB_WAIT3_UBUS.InitField(0, "tb_wait3_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_POLL_MASK_UBUS(006) --> 1 field to set
//		//
//		// The testbench will apply this mask to ubus poll operations, so that specific bits in a register can be polled. 
//		// Applies only to the next poll. By default all bits are enabled (i.e. not masked)"
//		TB_POLL_MASK_UBUS.InitField(0, "tb_poll_mask_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_READ_MASK_UBUS(007) --> 1 field to set
//		//
//		//"The testbench will apply this mask to ubus read operations, so that specific bits in a register can be read.
//		//Applies only to the next read. By default all bits are enabled (i.e. not masked)"
//		TB_READ_MASK_UBUS.InitField(0, "tb_read_mask_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//TB_POLL_TIMER_LIMIT_UBUS(00A) --> 1 field to set
//		//
//		//Ubus Poll Limit in picoseconds. 0 = disabled.
//		TB_POLL_TIMER_LIMIT_UBUS.InitField(0, "tb_poll_timer_limit_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//PKT_CMD_UBUS(B00) --> 1 field to set
//		//
//		//Specifies the type of command to perform.
//		PKT_CMD_UBUS.InitField(0, "pkt_cmd_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//PKT_ADDR_HIGH_UBUS(B01) --> 1 field to set
//		//
//		//Specifies the high address for the command. 
//		PKT_ADDR_HIGH_UBUS.InitField(0, "pkt_addr_high_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//PKT_ADDR_LOW_UBUS(B02) --> 1 field to set
//		//
//		//Specifies the low address for the command. 
//		PKT_ADDR_LOW_UBUS.InitField(0, "pkt_addr_low_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//PKT_BYTE_COUNT_UBUS(B03) --> 1 field to set
//		//
//		//Specifies the length as an integral number of bytes. A maximum of 4096 bytes can be specified. 
//		//Specifies the number of ordered sets/symbols in case of Physical Layer.
//		PKT_BYTE_COUNT_UBUS.InitField(0, "pkt_byte_count_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//		//PKT_DATA_UBUS(B06) --> 1 field to set
//		//
//		//Specifies the data to be stored in the pkt_index.
//		PKT_DATA_UBUS.InitField(0, "pkt_data_ubus", 0, 32, 0, 0xFFFFFFFF, 0xFFFFFFFF);
//
//	}

}
