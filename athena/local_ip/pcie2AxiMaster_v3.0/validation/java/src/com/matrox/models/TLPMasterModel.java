package com.matrox.models;

import java.util.ArrayList;

import com.fdk.validation.core.FDKFile;
import com.fdk.validation.core.FDKStatus;
import com.fdk.validation.models.registerfile.CRegister;

/**
 * AvalonMasterModel class. This class is a model of the Avalon master VHDL model. It is used to create the command file
 * loaded by the VHDL model.
 * 
 * 
 * @author amarchan@matrox.com
 * @version $Revision: 95 $
 * @since 1.6
 */
public class TLPMasterModel implements IUbusMaster {
	protected String name;
	protected int id;
	protected boolean verbose;
	protected int addressBusWidth;
	protected int dataBusWidth;
	protected FDKFile cmdFile;
	private int pcieRequesterID;

	public static char COMMENT_PREFIX = '#';
	public static char COMMENT_FLAG = 'c';
	public static char RESET_FLAG = 'j';
	public static char QUIT_FLAG = 'q';
	public static char READ_FLAG = 'r';
	public static char TRIGGER_FLAG = 't';
	public static char WAIT_FLAG = 's';
	public static char WAITEVENT_FLAG = 'e';

	private static char SENDREQ_FLAG = 'h';
	private static char PAYLOAD_FLAG = 'p';
	private static char EOP_FLAG = 'z';

	//public static char WRITE_FLAG = 'w';
	public static char INIT_FLAG = 'i';
	public static char DUMP_FLAG = 'd';
	public static char UBUSWRITE_FLAG = 'u';
	public static char UBUSREAD_FLAG = 'v';
	public static char UBUSPOLL_FLAG = 'p';


	public TLPMasterModel()
	{
		name = "unknown";
		id = 0;
		verbose = true;
		addressBusWidth = 32;
		dataBusWidth = 64;
		cmdFile = new FDKFile("cmd.in");
		this.pcieRequesterID = 0x0;
	}


	public TLPMasterModel(int modelId, String name, int addressBusWidth, int dataBusWidth, FDKFile commandFile)
	{
		this.name = name;
		this.id = modelId;
		this.verbose = true;
		this.addressBusWidth = addressBusWidth;
		this.dataBusWidth = dataBusWidth;
		this.cmdFile = commandFile;
	}


	public String getName()
	{
		return name;
	}


	public void setName(String name)
	{
		this.name = name;
	}


	public int getId()
	{
		return id;
	}


	public void setId(int id)
	{
		this.id = id;
	}


	public boolean isVerbose()
	{
		return verbose;
	}


	public void setVerbose(boolean verbose)
	{
		this.verbose = verbose;
	}


	public long getDataBusWidth()
	{
		return dataBusWidth;
	}


	public void setDataBusWidth(int dataBusWidth)
	{
		this.dataBusWidth = dataBusWidth;
	}


	public long getAddressBusWidth()
	{
		return addressBusWidth;
	}


	public void setAddressBusWidth(int addressBusWidth)
	{
		this.addressBusWidth = addressBusWidth;
	}


	public FDKFile getCommandFile()
	{
		return cmdFile;
	}


	public void setCommandFile(FDKFile commandFile)
	{
		this.cmdFile = commandFile;
	}


	public void comment(String comment)
	{
		String command = String.format("%c %s", COMMENT_PREFIX, comment);
		cmdFile.append(command);
	}


	public void sendCommentCmd(String comment)
	{
		String command = String.format("%c %s", COMMENT_FLAG, comment);
		cmdFile.append(command);
	}


	public void sendPacket(TlpPacket tlpPacket)
	{

		ArrayList<String[]> tlpHeaderFieldList = new ArrayList<String[]>();

		TlpHeader h = tlpPacket.getHeader();

		String formatValue = Integer.toString(h.getFormat());
		String typeValue = Integer.toString(h.getType());
		String trafficClassValue = Integer.toString(h.getTrafficClass());
		String tlpDigestPresentValue = Boolean.toString(h.isTlpDigestPresent());
		String tlpPoisonnedValue = Boolean.toString(h.isTlpPoisonned());
		String attributesValue = Integer.toString(h.getAttributes());
		String addressTypeValue = Integer.toString(h.getAddressType());
		String lengthValue = Integer.toString(tlpPacket.getlength());
		String requesterIDValue = Integer.toString(h.getRequesterID());
		String tagValue = Integer.toString(h.getTag());
		String lastDWBEValue = getHexFormat(4, h.getLastDWBE());
		String firstDWBEValue = getHexFormat(4, h.getFirstDWBE());
		String addressValue = getHexFormat(64, h.getAddress());

		tlpHeaderFieldList.add(new String[] { "format", formatValue });
		tlpHeaderFieldList.add(new String[] { "type", typeValue });
		tlpHeaderFieldList.add(new String[] { "trafficClass", trafficClassValue });
		tlpHeaderFieldList.add(new String[] { "tlpDigestPresent", tlpDigestPresentValue });
		tlpHeaderFieldList.add(new String[] { "tlpPoisonned", tlpPoisonnedValue });
		tlpHeaderFieldList.add(new String[] { "attributes", attributesValue });
		tlpHeaderFieldList.add(new String[] { "addressType", addressTypeValue });
		tlpHeaderFieldList.add(new String[] { "length", lengthValue });
		tlpHeaderFieldList.add(new String[] { "requesterID", requesterIDValue });
		tlpHeaderFieldList.add(new String[] { "tag", tagValue });
		tlpHeaderFieldList.add(new String[] { "lastDWBE", lastDWBEValue });
		tlpHeaderFieldList.add(new String[] { "firstDWBE", firstDWBEValue });
		tlpHeaderFieldList.add(new String[] { "address", addressValue });

		String comment = String.format("Send packet command");
		if (verbose)
			comment(comment);

		String command = "";

		// Write the header in the command file
		for (String[] stringArray : tlpHeaderFieldList)
		{
			command = String.format("%s %s=%s;", command, stringArray[0], stringArray[1]);
		}

		// Add the command flag
		command = String.format("%c%s", SENDREQ_FLAG, command);
		cmdFile.append(command);

		// Write the payload in the command file
		for (Integer dw : tlpPacket.getPayload())
		{
			command = String.format("%c %s", PAYLOAD_FLAG, getHexFormat(32, dw));
			cmdFile.append(command);
		}

		// Add the end of packet flag
		command = String.format("%c", EOP_FLAG);
		cmdFile.append(command);

	}


	public void sendTrigger()
	{
		if (verbose)
			comment("Sending trigger");

		String command = String.format("%c", TRIGGER_FLAG);
		cmdFile.append(command);
	}


	public void sendQuitCmd()
	{
		if (verbose)
			comment("Ending the simulation");

		String command = String.format("%c", QUIT_FLAG);
		cmdFile.append(command);
	}


	public void sendInitCmd()
	{
		if (verbose)
			comment("Initializing the simulation");

		String command = String.format("%c", INIT_FLAG);
		cmdFile.append(command);
	}


	public void sendDumpCmd()
	{
		if (verbose)
			comment("Dumping model data");

		String command = String.format("%c", DUMP_FLAG);
		cmdFile.append(command);
	}


	public void sendReadCmd(int address)
	{
		sendReadCmd(address, 0x0, 0xffffffff);

	}


	public void sendReadCmd(int address, long expectedData, long mask)
	{
		String addressAsHex = getHexFormat(addressBusWidth, address);
		String expectedDataAsHex = getHexFormat(dataBusWidth, expectedData);
		String maskAsHex = getHexFormat(dataBusWidth, mask);

		String comment = String.format("Read command:  Addr: 0x%s, Expected data: 0x%s, mask: 0x%s", addressAsHex, expectedDataAsHex, maskAsHex);
		String command = String.format("%c %s %s %s", READ_FLAG, addressAsHex, expectedDataAsHex, maskAsHex);
		if (verbose)
			comment(comment);

		cmdFile.append(command);
	}


	public void sendReadCmd(CRegister register)
	{
		long resetValue = register.getValue();
		long readMask = register.getReadmask();

		String comment = String.format("Reading register: %s: %s", register.getRootNode().getName().toUpperCase(), register.getPath().toLowerCase());
		sendCommentCmd(comment);
		sendReadCmd((int) register.getAddress(), resetValue, readMask);
	}


	public void sendWaitCmd(int cyclesCount)
	{
		String comment = String.format("Wait state command:  Number of wait cycles: %d", cyclesCount);
		String command = String.format("%c %d", WAIT_FLAG, cyclesCount);
		if (verbose)
			comment(comment);

		cmdFile.append(command);
	}


	public void sendWaitEventCmd(int interruptNumber)
	{
		//		if (interruptNumber > 7)
		//			FDKConsole.addErrorMessage("Error interrupt number > 7");

		String message = String.format("EVENT: Waiting for event on intevent(%d)", interruptNumber);
		sendCommentCmd(message);

		String comment;
		String command;
		comment = String.format("Wait on event command: interrupt number: %d", interruptNumber);
		command = String.format("%c %d", WAITEVENT_FLAG, interruptNumber);
		if (true)
			comment(comment);

		cmdFile.append(command);
	}


	public void sendResetCmd(int cyclesCount)
	{
		String comment = String.format("Reset command:  Number of reset cycles: %d", cyclesCount);
		String command = String.format("%c %d", RESET_FLAG, cyclesCount);
		if (verbose)
			comment(comment);

		cmdFile.append(command);
	}


	public void createCmdFile()
	{
		cmdFile.write();
	}


	/**
	 * @return the pcieRequesterID
	 */
	public int getPcieRequesterID()
	{
		return pcieRequesterID;
	}


	/**
	 * @param pcieRequesterID
	 *            the pcieRequesterID to set
	 */
	public void setPcieRequesterID(int pcieRequesterID)
	{
		this.pcieRequesterID = pcieRequesterID;
	}


	private String getHexFormat(int nbBits, int inputData)
	{
		int nbDigit = nbBits / 4;
		if (nbBits % 4 > 0)
			nbDigit++;

		int mask = ((int) Math.pow(2, nbBits)) - 1;
		String format = String.format("%%0%dx", nbDigit);
		String hexFormat = String.format(format, inputData & mask);
		return hexFormat;
	}


	private String getHexFormat(int nbBits, long inputData)
	{
		int nbDigit = nbBits / 4;
		if (nbBits % 4 > 0)
			nbDigit++;

		String format = String.format("%%0%dx", nbDigit);
		String hexFormat = String.format(format, inputData);
		return hexFormat;
	}


	public void UbusWrite(CRegister register)
	{
		//Variable declaration
		long BaseAddress = register.getAddress();
		long Value = (int) register.getValue();
		UbusWrite(BaseAddress, Value);

	}


	public void UbusWrite(long address, long value)
	{
		//Build line to write
		String command = String.format("%c %d %d", UBUSWRITE_FLAG, address, value);

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
		String command = String.format("%c %03X", UBUSREAD_FLAG, BaseAddress);

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
		String command = String.format("%c %03X %08X", UBUSREAD_FLAG, BaseAddress, ValueToVerify);

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
		String command = String.format("%c %03X %08X", UBUSPOLL_FLAG, BaseAddress, PollingValue);

		//Send line to the .in file.
		cmdFile.append(command);

	}


	@Override
	public void UbusComment(String message)
	{
		// TODO
	}


	public void MemWrite(CRegister register)
	{
		int dataBusWidth = register.getRootNode().getDataBusWidth();
		int address = (int) register.getAddress();
		int value = (int) register.getValue();

		switch (dataBusWidth)
		{
		case 64:
			int valueLow = (int) register.getValue();
			this.MemWrite(address, valueLow, 0xf);

			int valueHigh = (int) (register.getValue() >> 32);
			this.MemWrite(address + 4, valueHigh, 0xf);
			break;

		case 32:
			this.MemWrite(address, value, 0xf);
			break;

		case 16:
			this.MemWrite(address, value, 0x3);
			break;

		case 8:
			this.MemWrite(address, value, 0x3);
			break;

		default:
			break;
		}

	}


	public void MemWrite(int address, int value, int byteEnable)
	{
		int[] values = { value };
		MemWrite(address, values, (byteEnable & 0xf), 0xf);
	}


	public void MemWrite(int address, int values[], int FirstDWBE, int LastDWBE)
	{
		String packetName = String.format("TLP Memory write");
		TlpPacket tlpPacket = new TlpPacket(packetName);
		TlpHeader ph = tlpPacket.getHeader();

		int format = 0x2; // TLP 3DW header with data
		int type = 0; // PCIe Memory write request
		int addressType = 0x0; // Default/ untranslated
		int attributes = 0x0;

		int tag = 0;
		int trafficClass = 0;

		ph.setType(format, type);
		ph.setAddress(address);
		ph.setAddressType(addressType);
		ph.setFirstDWBE(FirstDWBE);
		ph.setLastDWBE(LastDWBE);

		ph.setAttributes(attributes);
		ph.setRequesterID(this.pcieRequesterID);
		ph.setTag(tag);
		ph.setTlpDigestPresent(false);
		ph.setTlpPoisonned(false);
		ph.setTrafficClass(trafficClass);

		this.sendPacket(tlpPacket);

	}


	public void Poll(long address, int value, int mask)
	{
	}


	public ArrayList<LegacyInterruptMessage> getLegacyInterrupts(FDKFile transcript)
	{
		return null;
	}


	public void MemRead(CRegister register)
	{
		int dataBusWidth = register.getRootNode().getDataBusWidth();
		int address = (int) register.getAddress();
		int value = (int) register.getValue();

		switch (dataBusWidth)
		{
		case 64:
			int valueLow = (int) register.getValue();
			this.MemRead(address, valueLow, 0xf);

			int valueHigh = (int) (register.getValue() >> 32);
			this.MemRead(address + 4, valueHigh, 0xf);
			break;

		case 32:
			this.MemRead(address, value, 0xf);
			break;

		case 16:
			this.MemRead(address, value, 0x3);
			break;

		case 8:
			this.MemRead(address, value, 0x3);
			break;

		default:
			break;
		}

	}


	public void MemRead(int address, int value, int fDWBE)
	{
		int expectedValues[] = { value };
		this.MemRead(address, expectedValues, fDWBE, 0xf);
	}


	//public void MemRead(int vmeBaseAddress24, int value, int fDWBE)
	public void MemRead(int address, int expectedValues[], int FirstDWBE, int LastDWBE)
	{
		String packetName = String.format("TLP Memory read @ 0x%x", address);
		TlpPacket tlpPacket = new TlpPacket(packetName);
		TlpHeader ph = tlpPacket.getHeader();

		int format = 0x0; // TLP 3DW header without data
		int type = 0; // PCIe Memory write request
		int addressType = 0x0; // Default/ untranslated
		int attributes = 0x0;

		int tag = 0;
		int trafficClass = 0;

		ph.setType(format, type);
		ph.setAddress(address);
		ph.setAddressType(addressType);
		ph.setFirstDWBE(FirstDWBE);
		ph.setLastDWBE(LastDWBE);

		ph.setAttributes(attributes);
		ph.setRequesterID(this.pcieRequesterID);
		ph.setTag(tag);
		ph.setTlpDigestPresent(false);
		ph.setTlpPoisonned(false);
		ph.setTrafficClass(trafficClass);

		this.sendPacket(tlpPacket);

	}


	public FDKStatus parseTranscript(FDKFile transcriptFile)
	{
		FDKStatus status = new FDKStatus();
		// Parse the transcript and calculate errors
		int errorCount = 0;
		int warningCount = 0;

		String message = String.format("%s status", this.name);
		status.setName(message);
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
						message = String.format("Line: %d: %s", line + 1, transcriptLine);
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

}
