/**
 * 
 */
package com.matrox.models;

import java.io.File;
import java.util.ArrayList;

import com.fdk.validation.core.FDKConsole;
import com.fdk.validation.core.FDKDirectory;
import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.models.registerfile.CRegister;

/**
 * @author amarchan
 *
 */
public class PCIeNSys extends UbusRootModel {
	// B00 register option.... do_cmd
	public static int EX_MRD = 0; // memory read request
	public static int EX_MWR = 0x1; // memory write request
	public static int EX_MRDLK = 0x2; // memory read request - locked
	public static int EX_MWRLK = 0x3; // memory write request - locked
	public static int EX_IORD = 0x4; // IO read request
	public static int EX_IOWR = 0x5; // IO write request
	public static int EX_CFGRD0 = 0x8; // Type 0 configuration read
	public static int EX_CFGWR0 = 0x9; // Type 0 configuration write
	public static int EX_CFGRD1 = 0x1a; // Type 1 configuration read
	public static int EX_CFGWR1 = 0x1b; // Type 1 configuration write
	public static int EX_MSG = 0x30; // message request
	public static int EX_MSGD = 0x70; // message request with data payload
	public static int EX_CPL = 0xa; // PCI Express completion transaction without data
	public static int EX_CPLD = 0x4a; // PCI Express completion transaction with data
	public static int EX_CPL_LK = 0xc; // PCI Express completion for locked memory read without data
	public static int EX_CPLD_LK = 0xd; // PCI Express completion for locked memory read with data
	public static int EX_DLLP_PKT = 0x1e; // Send a DLLP packet
	public static int EX_PL_PKT = 0xe; // Send a Physical layer ordered sets in L0 state
	public static int EX_PLL_IDLE = 0xf;
	public static int EX_RESET = 0x10; // reset
	public static int EX_IDLE = 0x11; // Insert clocks between commands.
	public static int EX_POLL = 0x7f; // Executes a polling command.

	// EX_TLP_MSG_CODE option
	public static int EX_ASSERT_INTA = 0x20; // Assert INTA
	public static int EX_ASSERT_INTB = 0x21; // Assert INTB
	public static int EX_ASSERT_INTC = 0x22; // Assert INTC
	public static int EX_ASSERT_INTD = 0x23; // Assert INTD
	public static int EX_DEASSERT_INTA = 0x24; // Deassert INTA
	public static int EX_DEASSERT_INTB = 0x25; // Deassert INTB
	public static int EX_DEASSERT_INTC = 0x26; // Deassert INTC
	public static int EX_DEASSERT_INTD = 0x27; // Deassert INTD
	public static int EX_PM_ACTIVE_STATE_NAK = 0x14; // PM_ACtive_state_Nak
	public static int EX_PM_PME = 0x18; // PM_PME
	public static int EM_PME_TURN_OFF = 0x19; // PME_turn_off
	public static int EX_PME_TO_ACK = 0x1B; // PME_TO_ACK
	public static int EX_ERR_COR = 0x30; // ERR_COR
	public static int EX_ERR_NONFATAL = 0x31; // ERR_NONFATAL
	public static int EX_ERR_FATAL = 0x20; // ERR_FATAL
	public static int EX_UNLOCK = 0x21; // Unlock
	public static int EX_SET_SLOT_POWER_LIMIT = 0x22; // Set slot power limit
	public static int EX_VENDOR_DEFINED_0 = 0x7E; // Vendor defined type 0
	public static int EX_VENDOR_DEFINED_1 = 0x7F; // Vendor defined type 1
	public static int EX_ATTN_INDICATOR_ON = 0x25; // Attention indicator on
	public static int EX_ATTN_INDICATOR_BLINK = 0x26; // Attention indicator blink
	public static int EX_ATTN_INDICATOR_OFF = 0x27; // Attention indicator off
	public static int EX_POWER_INDICATOR_ON = 0x14; // Power indicator on
	public static int EX_POWER_INDICATOR_BLINK = 0x18; // Power indicator blink
	public static int EX_POWER_INDICATOR_OFF = 0x19; // Power indicator off
	public static int EX_ATTN_BUTTON_PRESSED = 0x1B; // Attention button pressed

	// UBUS address
	public static int CFG_CPL_TIMEOUT_COUNT_UBUS = 0xB98;

	protected FDKDirectory simOutputDirectory;
	protected FDKDirectory simInputDirectory;
	protected FDKDirectory simPredictionDirectory;

	private CPcieNsysRegFile pcieNsysModelRegFile;

	private int Mem32BaseAddr; // Base address for 32 bits
	private long Mem64BaseAddr; // Base address for 64 bits   
	private int Mem32DepthDW; // memory 32 bits : Depth   
	private int Mem64DepthDW; // memory 64 bits : Depth  
	private byte Mem32[]; // memory array 32 bits 
	private byte Mem64[]; // memory array 64 bits 
	private FDKFile MemoryFile;

	// MemRead Tag
	private int MemRead_Tag;

	//Number of byte
	private int NumberOfByte;


	public PCIeNSys(FDKDirectory testDirectory)
	{
		super(testDirectory);
		String testPath = testDirectory.getAbsolutePath() + File.separator;

		this.simOutputDirectory = new FDKDirectory(testPath + "simoutput");
		if (simOutputDirectory.exists())
		{
			simOutputDirectory.delete();
		}

		this.simInputDirectory = new FDKDirectory(testPath + "siminput");
		if (simInputDirectory.exists())
		{
			simInputDirectory.delete();
		}

		this.simPredictionDirectory = new FDKDirectory(testPath + "prediction");
		if (simInputDirectory.exists())
		{
			simInputDirectory.delete();
		}

		// Create the required directory for this model
		simOutputDirectory.create();
		simInputDirectory.create();
		FDKFile cmdFile = new FDKFile(new File(simInputDirectory.getAbsolutePath() + File.separator + "simul.in"));
		super.setCmdFile(cmdFile);
		this.MemoryFile = new FDKFile(new File(simPredictionDirectory.getAbsolutePath() + File.separator + "nsys_mem.exp"));

		//private FDKFile simulIn;
		this.pcieNsysModelRegFile = new CPcieNsysRegFile();

		// Util bus
		//private MVBUbusModel ubus;
		//Memory
		Mem32BaseAddr = 0x0; // Base address for 32 bits
		Mem64BaseAddr = 0x0; // Base address for 64 bits   
		Mem32DepthDW = 0x0; // memory 32 bits : Depth   
		Mem64DepthDW = 0x0; // memory 64 bits : Depth  
		//		Mem32[]; // memory array 32 bits 
		//		Mem64[]; // memory array 64 bits 

	}


	/**
	 * @return the simOutputDirectory
	 */
	public FDKDirectory getSimOutputDirectory()
	{
		return simOutputDirectory;
	}


	/**
	 * @param simOutputDirectory
	 *            the simOutputDirectory to set
	 */
	public void setSimOutputDirectory(FDKDirectory simOutputDirectory)
	{
		this.simOutputDirectory = simOutputDirectory;
	}


	/**
	 * @return the simInputDirectory
	 */
	public FDKDirectory getSimInputDirectory()
	{
		return simInputDirectory;
	}


	/**
	 * @param simInputDirectory
	 *            the simInputDirectory to set
	 */
	public void setSimInputDirectory(FDKDirectory simInputDirectory)
	{
		this.simInputDirectory = simInputDirectory;
	}


	/**
	 * @return The simul.in file of this model
	 */
	public FDKFile getSimulIn()
	{
		return cmdFile;
	}


	/**
	 * @param simulIn
	 *            the simul.in FDK file to set
	 */
	public void setSimulIn(FDKFile simulIn)
	{
		this.cmdFile = simulIn;
	}


	/**
	 * @return true if the file creation was successful
	 */
	public boolean createCmdFile()
	{
		return this.cmdFile.write();

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: init
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void init(boolean TrainPCIe_5Gbs)
	{
		// Set test number
		//TestNumber = Number;

		// START INIT
		FDKConsole.addMessage("Pcie nsys initialization!!");
		// Start to write command in the .in file.
		super.UbusComment("START CONFIGURATION PROCESS");
		cmdFile.append("# --------------");
		cmdFile.append("# Pcie nsys Init");
		cmdFile.append("# --------------");

		super.UbusComment("RESET");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("TB_RESET_UBUS"), 0x32); // does a reset of 0x32 nsec in the design 
		super.UbusComment("REMOVE RESET");

		// Adding this delay to align NSYS - Xilinx training.  Value tuned to remove "Bad trailing TS characters (note)" that was appearing in transcript.txt.
		// Put back PCIX_SKEW to false with codec clock at 250 MHz
		super.Delay("WAIT_NB_CLK", 725);

		pcieNsysModelRegFile.getRegister("CL_BUS_CONTROL_UBUS").getField("cl_bus_resetN").setValue(0x1); // 0 = reset clock on bus
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CL_BUS_CONTROL_UBUS"));

		super.Delay("WAIT_NB_CLK", 100);

		cmdFile.append("# Interleaving");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_STP_SDP_SAME_SYM_TIME_UBUS"), 0x1); // Specific packet interleaving 1 : Enables packet interleaving

		cmdFile.append("# Default Init Flow Control Values");
		cmdFile.append("# Multiple do_cfg");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PH_UBUS")); // Specify the header credit for INIT_FC_P dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PD_UBUS")); // Specify the data credit for INIT_FC_P dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPH_UBUS")); // Specify the header credit for INIT_FC_NP dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPD_UBUS")); // Specify the data credit for INIT_FC_NP dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_CPLH_UBUS")); // Specify the header credit for INIT_FC_CPL dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_CPLD_UBUS")); // Specify the data credit for INIT_FC_CPL dllp packet

		//super.UbusWrite(registerFile.getRegister("CFG_TLP_FC_ENABLED_UBUS);   // Want to disable flow control

		cmdFile.append("# Static Chipset Parameters");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_DATA_UBUS"), 0x0); // Specifies the mode of filling the data in the packet. 
		// EX_INC: (0) Specifies incremental data starting from 0.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_PKT_SZ_UBUS"), 0x1); // (0) byte-wide data (default) EX_DWORD: (1) dword-wide data
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_CFG_CONTINUE_UBUS"), 0x1); // Specifies the mode of using the do_cfg commands.
		// (0) values specified by a do_cfg commands will not be used
		// for the successive packets. (default) EX_TRUE: (1)
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_DATA_CHECKING_RD_UBUS"), 0x1); // Specifies the mode of data checking for read transactions. 
		// EX_FALSE: (0) Specifies that data checking be disabled.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_TD_UBUS"), 0x0); // Specifies the TD field value of the packet. 
		// 0: TLP Digest not present 1: TLP Digest present (default) 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_PL_SKIP_FREQUENCY_UBUS"), 0x49C); // Time interval (in Symbol clocks) between sending Skip ordered-sets.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_CPL_TD_UBUS"), 0x0); // Specifies the TD field value of the packet. 
		// 0: TLP Digest not present 1: TLP Digest present (default)

		super.UbusComment("SET LATENCY SETTINGS FOR THE BFM");
		cmdFile.append("# BFM Latency Settings");
		cmdFile.append("# do_cfg");
		cmdFile.append("# ACK_FROM_REQ : 48");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_ACK_FROM_REQ_UBUS"), 0x30); // minimum number of clocks on the phy between receiving a request 
		// and sending an ACK for that TLP. (default = as per the specs)
		cmdFile.append("# REQ_2CPL : 82");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_REQ_2CPL_UBUS"), 0x52); // minimum number of clocks on the phy between receiving a request 
		// and transmitting a Cpl for that request. (default = 0)

		if (TrainPCIe_5Gbs)
		{
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_PL_SETSPEED_UBUS"), 0x1); // set link speed to 5Gb/s (Gen.2)
			super.Delay("WAIT_NB_CLK", 10);
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_PL_GO2RECOVERY_UBUS"), 0x1); // need to go through Recovery state to change data rate (PCIe 2.0 spec, 4.2.4.8)
			super.Delay("WAIT_NB_CLK", 10);
		}

		cmdFile.append("# ------------------");
		cmdFile.append("# End Pcie nsys Init");
		cmdFile.append("# ------------------");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Reset
	//DESCRIPTION:   Reset the value in the registerd. Juste keep the same name, the base
	//address and the number of field. 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void Reset()
	{
		pcieNsysModelRegFile.reset();
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: pcie_nsys::Msg
	//DESCRIPTION: Message 
	//PARAMETERS:    
	//RETURN VALUE: nothing
	////////////////////////////////////////////////////////////////////////////////
	public void Msg(int Code, int Routing, int VendorDef, int ByteCount, int Value[])
	{
		cmdFile.append("############ MESSAGE REQUEST ############");
		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

		CRegister PKT_DATA_UBUS = pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS");
		for (int i = 0; i <= ByteCount / 4; i++)
		{
			if (ByteCount % 4 != 0 || i != ByteCount / 4)
			{
				super.UbusWrite(PKT_DATA_UBUS, Value[i]); //B06 : The data to be stored in the pkt_index.
			}
		}

		cmdFile.append("# 2) Execute a do_cmd(EX_MSG or EX_MSGD). Byte_count (B03)");
		cmdFile.append("# Message code (B38), Message routing (B39), Vendor defined message(B3A)");

		// 0xB38 : Specifies the message code
		CRegister CFG_TLP_MSG_CODE_UBUS = pcieNsysModelRegFile.getRegister("CFG_TLP_MSG_CODE_UBUS");
		super.UbusWrite(CFG_TLP_MSG_CODE_UBUS, Code);

		// 0xB39 :  Specifies the message routing  
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_MSG_ROUTING_UBUS"), Routing);

		if (Code == EX_VENDOR_DEFINED_0)
		{
			// 0xB3A : Specifies byte 12 through 15 of a vendor defined message
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_MSG_VENDOR_DEF_UBUS"), VendorDef);
		}

		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), ByteCount);

		if (ByteCount == 0)
		{
			// message without data
			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS, EX_MSG"), EX_MSG); //B00 : the type of command to perform.
		}
		else
		{
			// message with data
			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS, EX_MSGD"), EX_MSGD); //B00 : the type of command to perform.
		}

		cmdFile.append("############ END OF NSYS MESSAGE REQUEST #############");
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : pcie_nsys::UnsupportedRequest
	//DESCRIPTION : Send an unsupported request 
	//PARAMETERS:
	//tx_type (type of the transaction) : 
	//completion (when no transaction were initiated EX_CPL)
	//completion with data (when no transaction were initiated, EX_CPLD)
	//completion locked (EX_CPL_LK),
	//completion locked with data (EX_CPLD_LK)
	//RETURN VALUE: nothing
	////////////////////////////////////////////////////////////////////////////////
	public void UnexpectedCompletion(int tx_type, int Tag, int ByteCount, int Value[])
	{
		cmdFile.append("############ UNEXPECTED COMPLETION ############");
		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

		// data to be send
		if (tx_type == EX_CPLD_LK || tx_type == EX_CPLD)
		{

			if (Value == null)
			{
				// defautl value
				for (int i = 0; i <= ByteCount / 4; i++)
				{
					if (ByteCount % 4 != 0 || i != ByteCount / 4)
					{
						super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), 0x12345678); //B06 : The data to be stored in the pkt_index.
					}
				}
			}
			else
			{
				for (int i = 0; i <= ByteCount / 4; i++)
				{
					if (ByteCount % 4 != 0 || i != ByteCount / 4)
					{
						super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value[i]); //B06 : The data to be stored in the pkt_index.
					}
				}
			}
		}

		cmdFile.append("# See VlibCommonVars.cpp for transaction type");
		cmdFile.append("# 2) Execute a do_cmd (B00). Byte_count (B03). Tag (B50)");

		if (tx_type == EX_CPLD_LK || tx_type == EX_CPLD)
		{
			//B03 : The length as an integral number of bytes or ordered sets/symbols. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), ByteCount);
		}
		else
		{
			//B03 : The length as an integral number of bytes or ordered sets/symbols. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 0x4);
		}

		// B50 : Set the tag of the completion
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_CPL_RIDTAG_UBUS"), Tag);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), tx_type); //B00 : the type of command to perform.

		cmdFile.append("# Wait 10 clk cycles.");
		super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		cmdFile.append("############ END OF NSYS UNEXPECTED COMPLETION #############");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : UnsupportedRequest
	//DESCRIPTION : Send an unsupported request 
	//PARAMETERS:
	//tx_type (type of the transaction) : IO Read (EX_IORD),
	//IO Write (EX_IOWR),
	//memory read locked (EX_MRDLK),
	//memory write locked (EX_MWRLK),
	//configuration type 1 read (EX_CFGRD1),
	//configuration type 1 write (EX_CFGWR1),
	//RETURN VALUE: nothing
	////////////////////////////////////////////////////////////////////////////////
	public void UnsupportedRequest(long address, int tx_type, int ByteCount, int Value[])
	{
		cmdFile.append("############ UNSUPPORTED REQUEST ############");
		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

		if (Value == null)
		{
			// defautl value
			for (int i = 0; i <= ByteCount / 4; i++)
			{
				if (ByteCount % 4 != 0 || i != ByteCount / 4)
				{
					super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), 0x12345678); //B06 : The data to be stored in the pkt_index.
				}
			}
		}
		else
		{
			for (int i = 0; i <= ByteCount / 4; i++)
			{
				if (ByteCount % 4 != 0 || i != ByteCount / 4)
				{
					super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value[i]); //B06 : The data to be stored in the pkt_index.
				}
			}
		}

		cmdFile.append("# See VlibCommonVars.cpp for transaction type");
		cmdFile.append("# 2) Execute a do_cmd(B00). Address(B01 & B02), Byte_count (B03)");
		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBS"), (int) (address >> 32) & 0xffffffff);
		//B02 : The low address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xffffffff));
		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), ByteCount);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), tx_type); //B00 : the type of command to perform.

		cmdFile.append("# Wait 10 clk cycles.");
		super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		cmdFile.append("############ END OF NSYS UNSUPPORTED REQUEST #############");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: cfg_rd(CRegister *RegisterName)
	//DESCRIPTION:   configuration write 
	//PARAMETERS:    RegisterName : Name of the register
	//
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void cfg_rd(CRegister register)
	{

		String message = String.format("############ CONFIGURATION READ : %s REGISTER ############", register.getName());
		cmdFile.append(message);

		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");
		cmdFile.append("# do_pkt(INDEX(byte location), data,  ID)");

		//B06 : The data to be stored in the pkt_index.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), (int) (register.getValue() & register.getReadmask() & 0xffffffff));

		cmdFile.append("# 2) Execute a do_cmd. (B00 0x00000008)");
		cmdFile.append("# do_cmd  (EX_CFGRD0,  address(B01 & B02),  byte_count (B03),  ID)");

		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (register.getAddress() >> 32) & 0xffffffff);
		//B02 : The low address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (register.getAddress() & 0xffffffff));
		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 0x4);

		//B37 : The First DW byte enable
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), 0xf);
		//B36 : The Last DW byte enable
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), 0);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_CFGRD0); //B00 : the type of command to perform.

		cmdFile.append("# Wait 10 clk cycle.");
		super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		// 64 bits register
		if (register.getRootNode().getDataBusWidth() == 64)
		{
			cmdFile.append("# 64 bits register");
			//B06 : The data to be stored in the pkt_index.
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), (int) ((register.getValue() & register.getReadmask() >> 32) & 0xffffffff));

			//B01 : The high address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) ((register.getAddress() + 0x4) >> 32) & 0xffffffff);
			//B02 : The low address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) ((register.getAddress() + 0x4) & 0xffffffff));
			//B03 : The length as an integral number of bytes or ordered sets/symbols. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 0x4);

			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_CFGRD0); //B00 : the type of command to perform.

			cmdFile.append("# Wait 10 clk cycle.");
			super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		}

		cmdFile.append("################# END OF CONFIGURATION READ #####################");
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: cfg_wr(CRegister *RegisterName)
	//DESCRIPTION:   configuration write 
	//PARAMETERS:    RegisterName : Name of the register
	//
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void cfg_wr(CRegister register)
	{
		//char line[200];

		String message = String.format("############ CONFIGURATION WRITE : %s REGISTER ############", register.getName());
		cmdFile.append(message);

		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");
		cmdFile.append("# do_pkt(INDEX(byte location), data,  ID)");

		//B06 : The data to be stored in the pkt_index.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), (int) (register.getValue() & 0xffffffff));

		cmdFile.append("# 2) Execute a do_cmd. (B00 0x00000009)");
		cmdFile.append("# do_cmd  (EX_CFGWR0,  address(B01 & B02),  byte_count (B03),  ID)");

		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (register.getAddress() >> 32) & 0xffffffff);
		//B02 : The low address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (register.getAddress() & 0xffffffff));
		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 0x4);

		//B37 : The First DW byte enable
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), 0xf);
		//B36 : The Last DW byte enable
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), 0);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_CFGWR0); //B00 : the type of command to perform.

		cmdFile.append("# Wait 10 clk cycle.");
		super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		// 64 bits register
		if (register.getRootNode().getDataBusWidth() == 64)
		{
			cmdFile.append("# 64 bits register");
			//B06 : The data to be stored in the pkt_index.
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), (int) ((register.getValue()) >> 32) & 0xffffffff);

			//B01 : The high address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) ((register.getAddress() + 0x4) >> 32) & 0xffffffff);
			//B02 : The low address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) ((register.getAddress() + 0x4) & 0xffffffff));
			//B03 : The length as an integral number of bytes or ordered sets/symbols. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 0x4);

			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_CFGWR0); //B00 : the type of command to perform.

			cmdFile.append("# Wait 10 clk cycle.");
			super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

		}

		cmdFile.append("################# END OF CONFIGURATION WRITE #####################");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: MemWrite
	//DESCRIPTION:  Memory Write command to specific location. 
	//PARAMETERS:   Register 
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void MemWrite(CRegister register)
	{
		// Variables
		if (register.getRootNode().getDataBusWidth()>32)
		{
			int valueArray[] = new int[2];

			valueArray[0] = (int) register.getValue() & 0xffffffff;
			valueArray[1] = (int) (register.getValue() >> 32) & 0xffffffff;

			// Call the function to do a memory write
			MemWrite(32, register.getAddress(), 0x4, valueArray);
		}
		else
		{
			int intValue = (int) register.getValue();
			// Call the function to do a memory write
			MemWrite(32, register.getAddress(), 0x4, intValue);
		}

	}


//	public void MemWrite(CRegister Register, int ByteCount)
//	{
//		// Variables
//		int Value[] = new int[2];
//
//		Value[0] = (int) Register.getValue() & 0xffffffff;
//		Value[1] = (int) (Register.getValue() >> 32) & 0xffffffff;
//
//		// Call the function to do a memory write
//		// Par la spec PCIe, on doit faire un acces 32 bits si l'adresse est <4 gig, sinon 64 bits
//		long address = Register.getAddress();
//		int addrsize = (address < 0x100000000L ? 32 : 64);
//		MemWrite(addrsize, address, ByteCount, Value);
//
//	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: MemWrite
	//DESCRIPTION:   Memory Write command to specific location. 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void MemWrite(int AddressSize, long address, int ByteCount, int Value)
	{
		int[] valueArray = new int[1];
		valueArray[0] = Value;
		MemWrite(AddressSize, address, ByteCount, valueArray);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: MemWrite
	//DESCRIPTION:   Memory Write command to specific location. 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void MemWrite(int AddressSize, long address, int ByteCount, int Value[])
	{

		int FirstDWBE = getFirstDWBE(address, ByteCount);
		int LastDWBE = getLastDWBE(address, ByteCount);

		NumberOfByte = ByteCount;

		cmdFile.append("############ NSYS MEMORY WRITE (EX_WRITE) ############");
		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

		if (Value.length == 1)
		{
			// See PCIe section 2.2.5 LastDW rules
			int dwBen = LastDWBE & FirstDWBE;
			FirstDWBE = dwBen;
			LastDWBE = 0x0;
		}
		// Write all DWORDs
		for (int ii = 0; ii < Value.length; ii++)
		{
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value[ii]); //B06 : The data to be stored in the pkt_index.
		}

		address = AddressSize == 32 ? (address & 0x00000000FFFFFFFF) : address;
		cmdFile.append("# 2) Execute a do_cmd(EX_MWR). Address(B01 & B02), Byte_count (B03)");
		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (address >> 32) & 0xffffffff);
		//B02 : The low address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xfffffffc));
		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), NumberOfByte);

		// the First DW must be specified when byte count < 4
		cmdFile.append("# do_cfg  FDWBE (B37) LDWBE(B36)");
		//B37 : The First DW byte enable
		//cout << "FirstDWBE: "<< hex << FirstDWBE << endl;
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), FirstDWBE);
		//B36 : The Last DW byte enable
		//cout << "LastDWBE : "<< hex << LastDWBE << endl;
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), LastDWBE);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_MWR); //B00 : the type of command to perform.

		cmdFile.append("############ END OF NSYS MEMORY WRITE #############");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: MemWriteOverMaxPayload
	//DESCRIPTION:  Memory Write command to specific location. 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void MemWriteOverMaxPayload(int AddressSize, long address, int ByteCount, int Value[], int MaxPayload)
	{
		address = AddressSize == 32 ? (address & 0x00000000FFFFFFFF) : address;
		////////////////////////////////////////////////////////////////////////////
		// 1) Count the number of MemWrite transactions and the specific size.
		////////////////////////////////////////////////////////////////////////////
		// Calulate again the Byte count because FDWBE is different of 0xF.
		if (address % 4 > 0)
			ByteCount = ByteCount + (int) (address % 4);
		//                                Nbr of DW            +     verify if the last DW is complete 
		int LastTransactionSize = (ByteCount % MaxPayload) / 4 + (((ByteCount % MaxPayload) % 4) > 0 ? 1 : 0);
		int TransactionSize = ByteCount / 4 + (ByteCount % 4 > 0 ? 1 : 0);
		int NbrMemWriteTransaction = ByteCount / MaxPayload + (LastTransactionSize > 0 ? 1 : 0);

		////////////////////////////////////////////////////////////////////////////
		// 2)Convert Value array in multiple arrays
		////////////////////////////////////////////////////////////////////////////
		int ArrayOfValue[][];
		//int i; // c'était utilisé a plusieurs place plus bas de manière pas trop légitime et pas trop compatible entre VS2003 et VS2010. Déclaré une fois, c'est clean
		//Memory allocation
		ArrayOfValue = new int[NbrMemWriteTransaction][];
		for (int i = 0; i < NbrMemWriteTransaction; i++)
			ArrayOfValue[i] = new int[(MaxPayload / 4)];
		//Initialization
		for (int j = 0; j < NbrMemWriteTransaction; j++)
		{
			for (int i = 0; i < (MaxPayload / 4); i++)
			{
				ArrayOfValue[j][i] = 0;
			}
		}
		// Convert in multiple array
		for (int i = 0; i < TransactionSize; i++)
			ArrayOfValue[i / (MaxPayload / 4)][i % (MaxPayload / 4)] = Value[i];

		////////////////////////////////////////////////////////////////////////////
		// 3)Send multiple transactions
		////////////////////////////////////////////////////////////////////////////
		//address = address/4*4;
		//cout << "ADDRESS: " << address << endl;

		for (int i = 0; i < (NbrMemWriteTransaction - (LastTransactionSize > 0 ? 1 : 0)); i++)
		{
			if (i == 0)
				MemWrite(64, address, (MaxPayload - ((int) address % 4)), ArrayOfValue[i]);
			else
				MemWrite(64, address - (address % 4) + (MaxPayload * i), MaxPayload, ArrayOfValue[i]);
		}

		// Last transaction
		//ici le compilateur se plaint (avec raison) que i est indefini. En fonction du code plus haut cut-and-paste plus bas, je comprends que i doit etre la valeur suivante a la sor
		int i = (NbrMemWriteTransaction - (LastTransactionSize > 0 ? 1 : 0));
		if (LastTransactionSize == 1)
		{
			//int Fdwbe = ~(0xf << (ByteCount % (MaxPayload / 4))) & 0xf;
			MemWrite(64, address - (address % 4) + (MaxPayload * i), ByteCount % MaxPayload, ArrayOfValue[NbrMemWriteTransaction - 1]);
		}
		else if (LastTransactionSize > 1)
			MemWrite(64, address - (address % 4) + (MaxPayload * i), ByteCount % MaxPayload, ArrayOfValue[NbrMemWriteTransaction - 1]);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : MemRead
	//DESCRIPTION   : Memory Read command to specific location.
	//PARAMETERS    : address, byte count, Value 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void MemRead(CRegister register)
	{
		int dataWidth = register.getRootNode().getDataBusWidth();
		if (dataWidth == 64)
		{
			// Variables
			int expectedValue[] = new int[2];

			expectedValue[0] = (int) register.getValue() & 0xffffffff;
			expectedValue[1] = (int) (register.getValue() >> 32) & 0xffffffff;

			// Call the function to do a memory read
			MemRead(32, register.getAddress(), 0x8, expectedValue);
		}
		else
		{
			// Variables
			int expectedValue = (int) register.getValue() & 0xffffffff;

			// Call the function to do a memory read
			MemRead(32, register.getAddress(), 0x4, expectedValue);
		}

	}



	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : MemRead
	//DESCRIPTION   : Memory Read command to specific location.
	//PARAMETERS    : address, byte count, Value 
	//Note: lorsqu'on appele cette fonction avec un ByteCount de 0, ca faisait un 
	//stack overflow, ce qui est mauvais en tant que telle. On capture maintenant
	//cette condition et on s'en sert pour faire une zero-length read, legal
	//en pcie pour flusher les writes posted.
	////////////////////////////////////////////////////////////////////////////////
	public void MemRead(int AddressSize, long address, int ByteCount, int Value)
	{
		int[] expectedValue = new int[1];
		expectedValue[0] = Value;
		MemRead(AddressSize, address, ByteCount, expectedValue);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : MemRead
	//DESCRIPTION   : Memory Read command to specific location.
	//PARAMETERS    : address, byte count, Value 
	//Note: lorsqu'on appele cette fonction avec un ByteCount de 0, ca faisait un 
	//stack overflow, ce qui est mauvais en tant que telle. On capture maintenant
	//cette condition et on s'en sert pour faire une zero-length read, legal
	//en pcie pour flusher les writes posted.
	////////////////////////////////////////////////////////////////////////////////
	public void MemRead(int AddressSize, long address, int ByteCount, int expectedValue[])
	{
		int FirstDWBE = getFirstDWBE(address, ByteCount);
		int LastDWBE = getLastDWBE(address, ByteCount);

		cmdFile.append("############ NSYS MEMORY READ (EX_MRD) ############");
		cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

		if (expectedValue.length == 1)
		{
			// See PCIe section 2.2.5 LastDW rules
			int dwBen = LastDWBE & FirstDWBE;
			FirstDWBE = dwBen;
			LastDWBE = 0x0;
		}

		for (int ii = 0; ii < expectedValue.length; ii++)
		{
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), expectedValue[ii]); //B06 : The data to be stored in the pkt_index.
		}

		address = AddressSize == 32 ? (address & 0x00000000FFFFFFFF) : address;
		cmdFile.append("# 2) Execute a do_cmd(EX_MRD). Address(B01 & B02), Byte_count (B03)");
		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (address >> 32) & 0xffffffff);
		//B02 : The low address for the command. bits 1 downto 0 are read only
		//super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xfffffffc));
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xfffffffc));

		//B03 : The length as an integral number of bytes or ordered sets/symbols.
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), ByteCount);

		// the First DW must be specified when byte count < 4
		cmdFile.append("# do_cfg  FDWBE (B37) LDWBE(B36)");
		//B37 : The First DW byte enable
		//cout << "FirstDWBE: "<< hex << FirstDWBE << endl;
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), FirstDWBE);
		//B36 : The Last DW byte enable
		//cout << "LastDWBE : "<< hex << LastDWBE << endl;
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), LastDWBE);

		super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_MRD); //B00 : the type of command to perform.

		//simulIn.append("# Wait 10 clk cycles.";
		//super.Delay("WAIT_NB_CLK", 10);             //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.
		cmdFile.append("############ END OF NSYS MEMORY READ #############");
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetMemReadTag()
	////////////////////////////////////////////////////////////////////////////////
	public int GetMemReadTag()
	{
		return (MemRead_Tag);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: SetMemReadTag()
	////////////////////////////////////////////////////////////////////////////////
	public void SetMemReadTag(int MemReadTag)
	{
		MemRead_Tag = MemReadTag;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetNumberOfByte()
	////////////////////////////////////////////////////////////////////////////////
	public int GetNumberOfByte()
	{
		return (NumberOfByte);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Poll
	//DESCRIPTION:  polling command. Execute a memory read request with byte count 4 
	//and data checking enabled. The read request is retried till the 
	//received data matches the expected data. 
	//
	//PARAMETERS:  address, Value, Mask  
	//
	////////////////////////////////////////////////////////////////////////////////
	public void Poll(long address, int Value, int Mask)
	{

		cmdFile.append("############ NSYS POLLING (EX_POLL) ############");
		cmdFile.append("# Execute a do_pkt before a do_cmd.");

		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value); //B06 : The data to be poll ????
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_POLLING_DATA_UBUS"), Value); //B27 : The data to be poll ????

		cmdFile.append("# Execute a do_cmd(EX_MRD). Address(B01 & B02), Byte_count (B03))");
		//B01 : The high address for the command. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (address >> 32) & 0xffffffff);
		//B02 : The low address for the command. bits 1 downto 0 are read only
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xfffffffc));
		//B03 : The length as an integral number of bytes or ordered sets/symbols. 
		super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), 4);

		cmdFile.append("# Execute a do_cfg(EX_POLLING_MASK) (B26).");
		pcieNsysModelRegFile.getRegister("CFG_POLLING_MASK_UBUS").setValue(Mask);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_POLLING_MASK_UBUS"));

		super.ProtocolPoll(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_POLL); //B00 : the type of command to perform.

		cmdFile.append("# Wait 10 clk cycles.");
		super.Delay("WAIT_NB_CLK", 10); //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.
		cmdFile.append("############ END OF NSYS POLLING #############");

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : SetMem32DepthDW
	//DESCRIPTION   : Set the host memory depth in DW (32 bits memory)
	//PARAMETERS    : Number of DW 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void SetMem32DepthDW(int NbrDW)
	{
		if (NbrDW == 0)
		{
			FDKConsole.addErrorMessage("SetMem32DepthDW : The memory depth can't be zero");

		}

		Mem32DepthDW = NbrDW;

		////Prediction    
		//if (Mem32 != null){
		//delete [] Mem32;
		//cerr << "delete Mem32"<< endl;
		//}

		//Memory allocation
		Mem32 = new byte[(Mem32DepthDW * 4) + 1];

		//Memory affectation
		for (int i = 0; i < (Mem32DepthDW * 4); i++)
		{
			Mem32[i] = 0;
		}

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetMem32DepthDW()
	////////////////////////////////////////////////////////////////////////////////
	public int GetMem32DepthDW()
	{
		return (Mem32DepthDW);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : SetMem64DepthDW
	//DESCRIPTION   : Set the host memory depth in DW (64 bits memory)
	//PARAMETERS    : Number of DW 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void SetMem64DepthDW(int NbrDW)
	{
		if (NbrDW == 0)
		{
			FDKConsole.addErrorMessage("SetMem64DepthDW : The memory depth can't be zero");

		}

		Mem64DepthDW = NbrDW;

		//Memory allocation
		Mem64 = new byte[(Mem64DepthDW * 4) + 1];

		//Memory affectation
		for (int i = 0; i < (Mem64DepthDW * 4); i++)
		{
			Mem64[i] = 0;
		}

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: GetMem64DepthDW()
	////////////////////////////////////////////////////////////////////////////////
	public int GetMem64DepthDW()
	{
		return (Mem64DepthDW);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : SetMem32BaseAddr
	//DESCRIPTION   : Set the host memory base address (32 bits memory).
	//PARAMETERS    : base address on 32 bits 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void SetMem32BaseAddr(int BaseAddr)
	{
		Mem32BaseAddr = BaseAddr;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : SetMem64BaseAddr
	//DESCRIPTION   : Set the host memory base address (64 bits memory).
	//PARAMETERS    : base address on 64 bits 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void SetMem64BaseAddr(long BaseAddr)
	{
		Mem64BaseAddr = BaseAddr;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : GetMem32BaseAddr
	//DESCRIPTION   : Get the host memory base address. (32 bits memory)
	//PARAMETERS    : base address on 32 bits 
	//
	////////////////////////////////////////////////////////////////////////////////
	public int GetMem32BaseAddr()
	{
		return Mem32BaseAddr;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : GetMem64BaseAddr
	//DESCRIPTION   : Get the host memory base address(64 bits memory)
	//PARAMETERS    : base address on 64 bits 
	//
	////////////////////////////////////////////////////////////////////////////////
	public long GetMem64BaseAddr()
	{
		return Mem64BaseAddr;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : LoadMem32WithRamp
	//DESCRIPTION   : This function take the base address and the number of DW and
	//create the corresponding commands in the .in file to 
	//initialize the memory.
	//e BBD <base address>
	//e BC0 <data #1>
	//. . .
	//e BC0 <data #Memory depth>
	//PARAMETERS    : StartData:: The first data to write a the base address
	//RampJump :: Number of data to skip between each address 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void LoadMem32WithRamp(int StartData, int RampJump)
	{
		//Variables declaration
		int Data = StartData;
		//Prediction
		byte Byte[];

		cmdFile.append("############     LOAD NSYS 32 BITS MEMORY     ############");
		cmdFile.append("#              HIGH  LOW");
		cmdFile.append("# Base Address (BBC)(BBD)");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_PKT_SZ_UBUS"), 0x1); // (0) byte-wide data (default) EX_DWORD: (1) dword-wide data
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_ADDRESS_HIGH_UBUS"), (int) 0);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_ADDRESS_LOW_UBUS"), (int) (Mem32BaseAddr & 0xffffffff));

		//Build the memory ramp
		cmdFile.append("# Data to write (BC0)");
		for (int i = 0; i < Mem32DepthDW; i++)
		{
			//Specific to the prediction
			Byte = ConvertDW2Byte(Data);
			for (int j = 0; j < 4; j++)
			{
				Mem32[i * 4 + j] = Byte[j];
			}

			//Specific for simulation
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_DATA_UBUS"), (int) Data);
			Data = Data + RampJump;
		}
		cmdFile.append("############ END OF NSYS 32 BITS MEMORY LOAD  ############");

		//delete [] Byte;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : LoadMem64WithRamp
	//DESCRIPTION   : This function take the base address and the number of DW and
	//create the corresponding commands in the .in file to 
	//initialize the memory.
	//e BBD <base address>
	//e BC0 <data #1>
	//. . .
	//e BC0 <data #Memory depth>
	//PARAMETERS    : StartData:: The first data to write a the base address
	//RampJump :: Number of data to skip between each address 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void LoadMem64WithRamp(int StartData, int RampJump)
	{
		//Variables declaration
		int Data = StartData;
		//Prediction
		byte Byte[];

		cmdFile.append("############     LOAD NSYS 64 BITS MEMORY     ############");
		cmdFile.append("#              HIGH  LOW");
		cmdFile.append("# Base Address (BBC)(BBD)");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MODE_PKT_SZ_UBUS"), 0x1); // (0) byte-wide data (default) EX_DWORD: (1) dword-wide data
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_ADDRESS_HIGH_UBUS"), (int) (Mem64BaseAddr >> 32) & 0xffffffff);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_ADDRESS_LOW_UBUS"), (int) (Mem64BaseAddr & 0xffffffff));

		//Build the memory ramp
		cmdFile.append("# Data to write (BC0)");
		for (int i = 0; i < Mem64DepthDW; i++)
		{
			//Specific to the prediction
			Byte = ConvertDW2Byte(Data);
			for (int j = 0; j < 4; j++)
				Mem64[i * 4 + j] = Byte[j];

			//Specific for simulation
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_SPACE_DATA_UBUS"), (int) Data);
			Data = Data + RampJump;
		}
		cmdFile.append("############ END OF NSYS 64 BITS MEMORY LOAD  ############");

		//delete [] Byte;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : LoadMem32WithZero
	//DESCRIPTION   : This function take the base address and the number of DW and
	//create the corresponding commands in the .in file to 
	//initialize the memory.
	//e BBD <base address>
	//e BC0 <data #1>
	//. . .
	//e BC0 <data #Memory depth>
	//PARAMETERS    : -
	//
	////////////////////////////////////////////////////////////////////////////////
	public void LoadMem32WithZero()
	{
		LoadMem32WithRamp(0, 0);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : LoadMem64WithZero
	//DESCRIPTION   : This function take the base address and the number of DW and
	//create the corresponding commands in the .in file to 
	//initialize the memory.
	//e BBD <base address>
	//e BC0 <data #1>
	//. . .
	//e BC0 <data #Memory depth>
	//PARAMETERS    : -
	//
	////////////////////////////////////////////////////////////////////////////////
	public void LoadMem64WithZero()
	{
		LoadMem64WithRamp(0, 0);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : DumpMem
	//DESCRIPTION   : This function dump all the contain of the host memory.
	//PARAMETERS    : -
	//
	////////////////////////////////////////////////////////////////////////////////
	public void DumpMem()
	{
		// *****Simulation*****
		cmdFile.append("############     DUMP THE HOST MEMORY    ############");

		cmdFile.append("# Wait 50 clk cycles before dumping the memory.");
		super.Delay("WAIT_NB_CLK", 50);
		cmdFile.append("# CFG_MEM_DUMP_UBUS (BD9)");
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_MEM_DUMP_UBUS"), (int) 1);

		cmdFile.append("############ END DUMP OF THE HOST MEMORY  ###########");

		// *****Prediction*****
		FDKConsole.addMessage("Prediction : PCIe Dump memory");

		//Build memory file name.

		// Reformat the data.
		int BytesPerLine = 8; //1 char= 1 byte
		int ArrayIndex = BytesPerLine;
		long Address = 0;
		//		String data;
		//		String ByteChar;

		// Initialize the data array with don't care char
		//memset(data,'-',BytesPerLine);

		// si le constructeur initialize l'array a NULL, alors les autres methode de l'objet DOIVENT tolerer qu'il soit a NULL!
		if (Mem32 != null)
		{
			//Mem32--> format first array that correspond to the memory 32 bits.(31 downto 0)
			Address = Mem32BaseAddr;
			for (int i = 0; i < Mem32DepthDW * 4; i++)
			{
				if (ArrayIndex == 0)
				{
					//memset(data, '-', BytesPerLine);
					ArrayIndex = BytesPerLine - 2;
					Address = Address + (BytesPerLine / 2);
				}
				else
					ArrayIndex = ArrayIndex - 2;
			}

			// si le constructeur initialize l'array a NULL, alors les autres methode de l'objet DOIVENT tolerer qu'il soit a NULL!
			if (Mem64 != null)
			{
				//Mem64--> format second array that correspond to the memory 64 bits.(63 downto 32)
				Address = Mem64BaseAddr;
				ArrayIndex = BytesPerLine;
				for (int i = 0; i < Mem64DepthDW * 4; i++)
				{
					if (ArrayIndex == 0)
					{
						//memset(data, '-', BytesPerLine);
						ArrayIndex = BytesPerLine - 2;
						Address = Address + (BytesPerLine / 2);
						//cout << Mem64BaseAddr <<endl;
						//getchar();
					}
					else
						ArrayIndex = ArrayIndex - 2;

					// Output in file.
					if (ArrayIndex == 0 || (i + 1) == Mem64DepthDW * 4)
					{
						//data[sizeof(data) - 1] = '\0';
						//MemoryFile << hex << uppercase << std::setw(16) << setfill('0') << Address << " " << std::setw(BytesPerLine) << setfill('0') << data << endl;
					}
				}
			}
		}

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: ConvertDW2Byte
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public byte[] ConvertDW2Byte(int Data)
	{
		// Variables declaration
		byte ByteArray[];

		//Memory allocation
		ByteArray = new byte[4];

		for (int i = 0; i < 4; i++)
			ByteArray[i] = (byte) ((Data >> i * 8) & 0x000000FF);

		return (ByteArray);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Mem32Write
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public void Mem32Write(int ByteNumber, byte Byte2Write)
	{
		Mem32[ByteNumber] = Byte2Write;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Mem64Write
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public void Mem64Write(int ByteNumber, byte Byte2Write)
	{
		Mem64[ByteNumber] = Byte2Write;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Mem32Read
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public byte Mem32Read(int ByteNumber)
	{
		return (Mem32[ByteNumber]);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: Mem64Read
	//DESCRIPTION:   
	//PARAMETERS:    
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public byte Mem64Read(int ByteNumber)
	{
		return (Mem64[ByteNumber]);
	}


	/**
	 * @return the memoryFile
	 */
	public FDKFile getMemoryFile()
	{
		return MemoryFile;
	}


	/**
	 * @param memoryFile
	 *            the memoryFile to set
	 */
	public void setMemoryFile(FDKFile memoryFile)
	{
		MemoryFile = memoryFile;
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: IOWrite
	//DESCRIPTION:  IO Write command to specific location. 
	//PARAMETERS:   Register 
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void IOWrite(CRegister Register)
	{
		// Variables
		int Value[] = new int[2];

		Value[0] = (int) Register.getValue() & 0xffffffff;
		Value[1] = (int) (Register.getValue() >> 32) & 0xffffffff;

		// Call the function to do an IO write
		IOWrite(32, Register.getAddress(), 0x4, Value, 0, false);
	}


	public void IOWrite(CRegister Register, int ByteCount)
	{
		// Variables
		int Value[] = new int[2];

		Value[0] = (int) Register.getValue() & 0xffffffff;
		Value[1] = (int) (Register.getValue() >> 32) & 0xffffffff;

		// Call the function to do an IO write
		IOWrite(32, Register.getAddress(), ByteCount, Value, 0, false);
	}


	public void IOWriteFDWBE(CRegister Register, int ByteCount, int FDWBE)
	{
		// Variables
		int Value[] = new int[2];

		Value[0] = (int) Register.getValue() & 0xffffffff;
		Value[1] = (int) (Register.getValue() >> 32) & 0xffffffff;

		// Call the function to do an IO write
		IOWrite(32, Register.getAddress(), ByteCount, Value, FDWBE, false);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: IOWrite
	//DESCRIPTION:   IO Write command to specific location. 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void IOWrite(int AddressSize, long address, int ByteCount, int Value[], int FDWBE, boolean DontWriteInSimulFile)
	{
		int LastDWBE = 0, FirstDWBE = 0, numByte = 0;
		int i = 0;
		// Specific when recurence is on.
		boolean skip = false;

		if (ByteCount <= 4 && FDWBE != 0)
		{
			FirstDWBE = FDWBE;
			LastDWBE = 0;
			numByte = ByteCount;
		}
		else
		{
			if (FDWBE != 0)
			{
				FDKConsole.addErrorMessage("CPcieNsys IOWrite_function : The FDWBE must not be specified when ByteCount > 4. The FDWBE is automatically set with the address and byte_count values");
			}
			FirstDWBE = (0xf << address % 4) & 0xf;

			// Specific to LDWBE
			if (ByteCount <= (4 - (address % 4)))
			{
				IOWrite(AddressSize, address, ByteCount, Value, (FirstDWBE & (((0xF >> (4 - ByteCount)) & 0xF) << (address % 4))), false);
				skip = true;
			}
			else
				LastDWBE = 0xf >> ((4 - ByteCount % 4 - address % 4) % 4);

			numByte = 0;
			for (i = 3; i >= 0; i--)
			{
				if (((FirstDWBE >> i) & 1) == 1)
				{
					numByte = i;
				}
			}
			numByte += ByteCount;
			String.format("numByte in IOWr transaction : %d", numByte);
			String.format("FirstDWBE in IOWr transaction : 0x%x", FirstDWBE);
			String.format("ByteCount in IOWr transaction : %d", ByteCount);
			String.format("address in IOWr transaction : 0x%x", address);
		}

		NumberOfByte = numByte;

		//Special case when we don't want to write in simul.in file.
		if (!skip)
			skip = DontWriteInSimulFile ? true : false;

		if (!(skip))
		{
			cmdFile.append("############ NSYS IO WRITE (EX_IOWR) ############");
			cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

			for (int ii = 0; ii <= numByte / 4; ii++)
			{
				if (numByte % 4 != 0 || ii != numByte / 4)
				{
					super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value[ii]); //B06 : The data to be stored in the pkt_index.
				}
			}

			address = AddressSize == 32 ? (address & 0x00000000FFFFFFFF) : address;
			cmdFile.append("# 2) Execute a do_cmd(EX_IOWR). Address(B01 & B02), Byte_count (B03)");
			//B01 : The high address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), (int) (address >> 32) & 0xffffffff);
			//B02 : The low address for the command. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), (int) (address & 0xfffffffc));
			//B03 : The length as an integral number of bytes or ordered sets/symbols. 
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), NumberOfByte);

			// the First DW must be specified when byte count < 4
			cmdFile.append("# do_cfg  FDWBE (B37) LDWBE(B36)");
			//B37 : The First DW byte enable
			//cout << "FirstDWBE: "<< hex << FirstDWBE << endl;
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), FirstDWBE);
			//B36 : The Last DW byte enable
			//cout << "LastDWBE : "<< hex << LastDWBE << endl;
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), LastDWBE);

			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_IOWR); //B00 : the type of command to perform.

			// why ???????
			//simulIn.append("# Wait 10 clk cycles.";
			//super.Delay("WAIT_NB_CLK", 10);  //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.

			cmdFile.append("############ END OF NSYS IO WRITE #############");
		}

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : IORead
	//DESCRIPTION   : IO Read command to specific location.
	//PARAMETERS    : address, byte count, Value 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void IORead(CRegister Register)
	{
		// Variables
		int Value[] = new int[2];

		Value[0] = (int) Register.getValue() & 0xffffffff;
		Value[1] = (int) (Register.getValue() >> 32) & 0xffffffff;

		// Call the function to do a memory write
		IORead(32, Register.getAddress(), 0x4, Value, 0);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : IOReadFDWBE
	//DESCRIPTION   : IO Read command to specific location, with value given and
	//byte enabled (UART byte access)
	//PARAMETERS    : address, byte count, Value, FDWBE 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void IOReadFDWBE(CRegister Register, int ByteCount, int Value[], int FDWBE)
	{
		// Variables
		//int Value[2];

		//Value[0] = (int)Register->GetDataWithoutMask() & 0xffffffff;
		//Value[1] = (int)(Register->GetDataWithoutMask() >> 32) & 0xffffffff;

		// Call the function to do an IO write
		IORead(32, Register.getAddress(), ByteCount, Value, FDWBE);
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME : IORead
	//DESCRIPTION   : IO Read command to specific location.
	//PARAMETERS    : address, byte count, Value 
	//
	////////////////////////////////////////////////////////////////////////////////
	public void IORead(int AddressSize, long address, int ByteCount, int Value[], int FDWBE)
	{
		int LastDWBE = 0, FirstDWBE = 0, numByte = 0;
		// Specific when recurence is on.
		boolean skip = false;

		if (ByteCount <= 4 && FDWBE != 0)
		{
			FirstDWBE = FDWBE;
			LastDWBE = 0;
			numByte = ByteCount;
		}
		else
		{
			if (FDWBE != 0)
			{
				FDKConsole.addErrorMessage("CPcieNsys IORead_function : The FDWBE must not be specified when ByteCount > 4The FDWBE is automatically set with the address and byte_count values");
			}
			FirstDWBE = (0xf << address % 4) & 0xf;

			// Specifcic to LDWBE
			if (ByteCount <= (4 - (address % 4)))
			{
				IORead(AddressSize, address, ByteCount, Value, (FirstDWBE & (((0xF >> (4 - ByteCount)) & 0xF) << (address % 4))));
				skip = true;
			}
			else
				LastDWBE = 0xf >> ((4 - ByteCount % 4 - address % 4) % 4);

			numByte = 0;
			for (int i = 3; i >= 0; i--)
			{
				if (((FirstDWBE >> i) & 1) == 1)
				{
					numByte = i;
				}
			}
			numByte += ByteCount;
			//cout << "Number of byte in the transaction" << numByte << endl;
		}

		NumberOfByte = numByte;

		if (!(skip))
		{
			cmdFile.append("############ NSYS IO READ (EX_IORD) ############");
			cmdFile.append("# 1) Execute a do_pkt before a do_cmd.");

			// Adjust numByte and ByteCount if the Fdwbe is not alligned.
			if (FirstDWBE != 0xf && numByte > 4 && ByteCount > 4)
			{
				numByte = numByte + 4;
				ByteCount = ByteCount + 4;
			}

			for (int ii = 0; ii <= numByte / 4; ii++)
			{
				if (numByte % 4 != 0 || ii != numByte / 4)
				{
					super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_DATA_UBUS"), Value[ii]); //B06 : The data to be stored in the pkt_index.
				}
			}

			address = AddressSize == 32 ? (address & 0x00000000FFFFFFFF) : address;
			cmdFile.append("# 2) Execute a do_cmd(EX_IORD). Address(B01 & B02), Byte_count (B03)");
			//B01 : The high address for the command. 
			int value = (int) (address >> 32) & 0xffffffff;
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_HIGH_UBUS"), value);

			//B02 : The low address for the command. bit 0 is read only

			long lsbMask = 0x0;
			if (NumberOfByte < 2)
			{
				lsbMask = 0xffffffff;
			}
			else if (NumberOfByte < 3)
			{
				lsbMask = 0xfffffffe;

			}
			else
			{
				lsbMask = 0xfffffffc;
			}

			value = (int) (address & lsbMask);
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_ADDR_LOW_UBUS"), value);
			//B03 : The length as an integral number of bytes or ordered sets/symbols.
			super.UbusWrite(pcieNsysModelRegFile.getRegister("PKT_BYTE_COUNT_UBUS"), NumberOfByte);

			// the First DW must be specified when byte count < 4
			cmdFile.append("# do_cfg  FDWBE (B37) LDWBE(B36)");
			//B37 : The First DW byte enable
			//cout << "FirstDWBE: "<< hex << FirstDWBE << endl;
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_FDW_BE_UBUS"), FirstDWBE);
			//B36 : The Last DW byte enable
			//cout << "LastDWBE : "<< hex << LastDWBE << endl;
			super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_LDW_BE_UBUS"), LastDWBE);

			super.ProtocolWrite(pcieNsysModelRegFile.getRegister("PKT_CMD_UBUS"), EX_IORD); //B00 : the type of command to perform.

			//simulIn.append("# Wait 10 clk cycles.";
			//super.Delay("WAIT_NB_CLK", 10);             //002 : Allows the simulation to proceed for tb_wait_cycles clock cycles.
			cmdFile.append("############ END OF NSYS IO READ #############");
		}

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: SetBCM
	//DESCRIPTION:   Set the BCM field of the completion packet
	//PARAMETERS:    Value : 0 or 1
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public void SetBCM(int Value)
	{

		cmdFile.append("############    Set BCM Register    ############");
		pcieNsysModelRegFile.getRegister("CFG_TLP_CPL_BCM_UBUS").setValue(Value);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_CPL_BCM_UBUS"));

	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: setEP
	//DESCRIPTION:  specifies that the TLP be poisoned 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void SetEP(int EP)
	{
		cmdFile.append("############  Set EP (erroneous packet)  ############");
		pcieNsysModelRegFile.getRegister("CFG_TLP_EP_UBUS.SetData").setValue(EP);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_EP_UBUS")); // Specifies that the TLP be poisoned. 
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: SetCPLStatus
	//DESCRIPTION:  specifies the status for a completion 
	//PARAMETERS:    
	//RETURN VALUE:  
	////////////////////////////////////////////////////////////////////////////////
	public void SetCPLStatus(int CPL_Status)
	{
		cmdFile.append("############  Set CPL status ############");
		pcieNsysModelRegFile.getRegister("CFG_TLP_CPL_STATUS_UBUS").setValue(CPL_Status);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_TLP_CPL_STATUS_UBUS")); // Sspecifies the status for a completion. 
	}


	////////////////////////////////////////////////////////////////////////////////
	//FUNCTION NAME: SetCredit
	//DESCRIPTION:   Set the credit in the host
	//PARAMETERS:  Specifies the header credit and the data credit for posted and non-posted request  
	//RETURN VALUE:  nothing 
	////////////////////////////////////////////////////////////////////////////////
	public void SetCredit(int PostedHeader, int PostedData, int NonPostedHeader, int NonPostedData)
	{

		cmdFile.append("############    Set NSYS Credit   ############");

		if (PostedHeader != 0)
		{
			pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PH_UBUS").setValue(PostedHeader); // header credit for posted transaction      
		}
		if (PostedData != 0)
		{
			pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PD_UBUS").setValue(PostedData); // data credit for posted transaction    
		}
		if (NonPostedHeader != 0)
		{
			pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPH_UBUS").setValue(NonPostedHeader); // header credit for non posted packet
		}
		if (NonPostedData != 0)
		{
			pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPD_UBUS").setValue(NonPostedData); // data credit for no posted packet
		}

		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PH_UBUS")); // Specify the header credit for INIT_FC_P dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_PD_UBUS")); // Specify the data credit for INIT_FC_P dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPH_UBUS")); // Specify the header credit for INIT_FC_NP dllp packet
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_DLLP_INIT_FC_NPD_UBUS")); // Specify the data credit for INIT_FC_NP dllp packet

	}


	public FDKStatus parseTranscript(FDKFile transcriptFile)
	{
		FDKStatus status = new FDKStatus();
		// Parse the transcript and calculate errors
		int errorCount = 0;
		int warningCount = 0;

		status.setName("PCINsys status");
		status.setStatus("No error found.");
		status.setErrorCnt(errorCount);
		status.setWarningCnt(warningCount);

		// We assume to be in the right directory
		//File file = new File(workingDirectory.getAbsolutePath() + File.separator + transcriptFileName);
		//transcriptFile = new FDKFile(file);
		if (!transcriptFile.exists())
		{
			status.setStatus("Transcript file does not exist");
			errorCount++;

		}
		else if (transcriptFile.read())
		{

			for (int line = 0; line < transcriptFile.getContent().size(); line++)
			{
				String transcriptLine = transcriptFile.getContent().get(line);

				//				#       40773.8 ns bfm0     ERROR   data mismatch at address    0000000000000010
				//				#       40773.8 ns bfm0     ERROR   expected data    01
				//				#       40773.8 ns bfm0     ERROR   actual data    00
				//				#       40773.8 ns bfm0     ERROR   polling mask byte   FF

				if (transcriptLine.matches("#.* ERROR .*$"))
				{
					if (errorCount == 0)
					{
						String message = String.format("Line: %d: %s", line + 1, transcriptLine);
						status.setStatus(message);
					}
					errorCount++;
				}

			}
		}
		else
		{
			status.setStatus("Can't read simulation transcript file");
			errorCount++;
		}

		// Store the final count
		status.setErrorCnt(errorCount);
		status.setWarningCnt(warningCount);

		return status;

	}


	public ArrayList<LegacyInterruptMessage> getLegacyInterrupts(FDKFile transcriptFile)
	{

		ArrayList<LegacyInterruptMessage> legacyInterruptMessageList = new ArrayList<LegacyInterruptMessage>();
		// We assume to be in the right directory
		//File file = new File(workingDirectory.getAbsolutePath() + File.separator + transcriptFileName);
		//transcriptFile = new FDKFile(file);
		if (!transcriptFile.exists())
		{
			FDKConsole.addErrorMessage("Simulation transcript does not exist");
		}
		else if (transcriptFile.read())
		{

			for (int line = 0; line < transcriptFile.getContent().size(); line++)
			{
				String transcriptLine = transcriptFile.getContent().get(line);

				if (transcriptLine.matches("^# *\\d+\\.\\d+ .*"))
				{
					String[] tokenList = transcriptLine.split("\\s+");

					//					# ----------------------------------------------------------------------------------------------------------------------------
					//					#                  D     T   SYMBOL  F CNT BYTE CNT                            F L      CID   MSG   VC              A         
					//					#                  I SEQ A     /     M  /    / HI      LO         PACKET       B B       /     /    /  HD DT  T T E T         
					//					#   TIME (100 ps)  R  #  G   PACKET  T LEN ADDRESS  ADDRESS    HI        LO    E E RID  VID  STATUS RT FC FC  C D P R   ECRC  
					//					# ----------------------------------------------------------------------------------------------------------------------------
					//					#       48423.8 ns U --- -- IDLE     - 414 -------- -------- -------- -------- - - ---- ---- ------ -- -- --- - - - - --------
					//					#       48515.8 ns U 007 -- MSG      1 000 -------- -------- 00000020 34000000 - - 0000 ---- ASRT_A 4  01 000 0 0 0 0 --------
					//					#                                                            00000000 00000000
					//					#       48615.8 ns D --- -- IDLE     - 606 -------- -------- -------- -------- - - ---- ---- ------ -- -- --- - - - - --------
					//					#       48639.8 ns D 007 -- ACK      - --- -------- -------- -------- -------- - - ---- ---- ------ -- -- --- - - - - --------

					if (tokenList[6].trim().equalsIgnoreCase("MSG"))
					{
						if (tokenList[17].trim().equalsIgnoreCase("ASRT_A"))
						{
							LegacyInterruptMessage legacyInterruptMessage = new LegacyInterruptMessage();
							double time = Double.parseDouble(tokenList[1].trim());
							String units = tokenList[1].trim().toLowerCase();
							legacyInterruptMessage.setTime(time, units);
							legacyInterruptMessageList.add(legacyInterruptMessage);

						}
					}
				}

			}
		}
		else
		{
			FDKConsole.addErrorMessage("Can't read simulation transcript file");
		}

		return legacyInterruptMessageList;

	}


	public void setMaxCompletionTimeout(int maxCompletionTimeout)
	{
		//UbusWrite(CFG_CPL_TIMEOUT_COUNT_UBUS, maxCompletionTimeout);
		String message = String.format("Setting Max Completion Timeout to: 0x%x", maxCompletionTimeout);
		super.UbusComment(message);
		super.UbusWrite(pcieNsysModelRegFile.getRegister("CFG_CPL_TIMEOUT_COUNT_UBUS"), maxCompletionTimeout); // Specify the header credit for INIT_FC_P dllp packet
	}


	private int getFirstDWBE(long address, int ByteCount)
	{

		int shiftValue = (int) (address % 4);

		int FirstDWBE = (0xf << shiftValue) & 0xf;

		return FirstDWBE;

	}


	private int getLastDWBE(long address, int ByteCount)
	{
		long lastAddress = address + ByteCount - 1;
		int LastDWBE = 0xf >> (0x3 - (lastAddress % 4));

		return LastDWBE;

	}


//	private int switchEndian(int input)
//	{
//		int output = 0;
//		for (int i = 0; i < 4; i++)
//		{
//			int b = (input >> (8 * (3 - i))) & 0xff;
//			output = output | b << (8 * i);
//		}
//		return output;
//	}
}
