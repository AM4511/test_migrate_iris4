package com.matrox.models;

import java.util.ArrayList;

import com.fdk.validation.core.FDKConsole;

public class TlpHeader {

	private int format;
	private int type;
	private int trafficClass;
	private boolean tlpDigestPresent;
	private boolean tlpPoisonned;
	private int attributes;
	private int addressType;
	//private int length;
	private int requesterID;
	private int tag;
	private int lastDWBE;
	private int firstDWBE;
	private long address;

	// Extra info
	String transactionType;


	public TlpHeader()
	{
		this.format = 0x0;
		this.type = 0x0;
		this.trafficClass = 0x0;
		this.tlpDigestPresent = false;
		this.tlpPoisonned = false;
		this.attributes = 0x0;
		this.addressType = 0;
		//this.length = -1;
		this.requesterID = 0;
		this.tag = 0;
		this.lastDWBE = 0x0;
		this.firstDWBE = 0x0;
		this.address = 0x0;
		this.transactionType = "Unknown";

	}


	/**
	 * @return The format of the tlp header: Fmt[1:0] <BR>
	 *         <BR>
	 *         <table>
	 *         <tr>
	 *         <td><b>Fmt[1:0]</b></td>
	 *         <td><b>TLP Format</b></td>
	 *         </tr>
	 *         <tr>
	 *         <td>00b</td>
	 *         <td>3 DW header, no data</td>
	 *         </tr>
	 *         <tr>
	 *         <td>01b</td>
	 *         <td>4 DW header, no data</td>
	 *         </tr>
	 *         <tr>
	 *         <td>10b</td>
	 *         <td>3 DW header, with data</td>
	 *         </tr>
	 *         </tr>
	 *         <tr>
	 *         <td>11b</td>
	 *         <td>4 DW header, with data</td>
	 *         </tr>
	 *         </table>
	 * 
	 */
	public int getFormat()
	{
		return format;
	}


	/**
	 * @return the type
	 */
	public int getType()
	{
		return type;
	}


	/**
	 * @param format
	 *            The header format (3DW or 4 DW)
	 * @param type
	 *            The transaction type (Mem,IO,Cfg, read, write, etc) type the TLP type
	 * 
	 *            <BR>
	 *            <BR>
	 *            <b>Table 2-2: Fmt[1:0] Field Values</b>
	 *            <table border="1">
	 *            <tr>
	 *            <td><b>Fmt[1:0]</b></td>
	 *            <td><b>TLP Format</b></td>
	 *            </tr>
	 *            <tr>
	 *            <td>00b</td>
	 *            <td>3 DW header, no data</td>
	 *            </tr>
	 *            <tr>
	 *            <td>01b</td>
	 *            <td>4 DW header, no data</td>
	 *            </tr>
	 *            <tr>
	 *            <td>10b</td>
	 *            <td>3 DW header, with data</td>
	 *            </tr>
	 *            </tr>
	 *            <tr>
	 *            <td>11b</td>
	 *            <td>4 DW header, with data</td>
	 *            </tr>
	 *            </table>
	 * 
	 *            <BR>
	 *            <BR>
	 *            <b>Table 2-3: Fmt[1:0] and Type[4:0] Field Encodings</b>
	 *            <table border="1">
	 *            <tr>
	 *            <td><b>TLP Type</b></td>
	 *            <td><b>Fmt [1:0]</b></td>
	 *            <td><b>Type [4:0]</td>
	 *            <td><b>Description </b></td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>MRd</td>
	 *            <td>00/01</td>
	 *            <td>0 0000</td>
	 *            <td>Memory Read Request</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>MRdLk</td>
	 *            <td>00/01</td>
	 *            <td>0 0001</td>
	 *            <td>Memory Read Request-Locked</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>MWr</td>
	 *            <td>10/11</td>
	 *            <td>0 0000</td>
	 *            <td>Memory Write Request</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>IORd</td>
	 *            <td>00</td>
	 *            <td>0 0010</td>
	 *            <td>I/O Read Request</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>IOWr</td>
	 *            <td>10</td>
	 *            <td>0 0010</td>
	 *            <td>I/O Write Request</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CfgRd0</td>
	 *            <td>00</td>
	 *            <td>0 0100</td>
	 *            <td>Configuration Read Type 0</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CfgWr0</td>
	 *            <td>10</td>
	 *            <td>0 0100</td>
	 *            <td>Configuration Write Type 0</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CfgRd1</td>
	 *            <td>00</td>
	 *            <td>0 0101</td>
	 *            <td>Configuration Read Type 1</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CfgWr1</td>
	 *            <td>10</td>
	 *            <td>0 0101</td>
	 *            <td>Configuration Write Type 1</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>TCfgRd</td>
	 *            <td>00</td>
	 *            <td>1 1011</td>
	 *            <td>Deprecated TLP Type3</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>TCfgWr</td>
	 *            <td>10</td>
	 *            <td>1 1011</td>
	 *            <td>Deprecated TLP Type3</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>Msg</td>
	 *            <td>01</td>
	 *            <td>1 0r2r1r0</td>
	 *            <td>Message Request – The sub-field r[2:0] specifies the Message routing mechanism (see Table 2-12).
	 *            </td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>MsgD</td>
	 *            <td>11</td>
	 *            <td>1 0r2r1r0</td>
	 *            <td>Message Request with data payload – The sub-field r[2:0] specifies the Message routing mechanism
	 *            (see Table 2-12).</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>Cpl</td>
	 *            <td>00</td>
	 *            <td>0 1010</td>
	 *            <td>Completion without Data – Used for I/O and Configuration Write Completions and Read Completions
	 *            (I/O, Configuration, or Memory) with Completion Status other than Successful Completion.</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CplD</td>
	 *            <td>10</td>
	 *            <td>0 1010</td>
	 *            <td>Completion with Data – Used for Memory, I/O, and Configuration Read Completions.</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CplLk</td>
	 *            <td>00</td>
	 *            <td>0 1011</td>
	 *            <td>Completion for Locked Memory Read without Data – Used only in error case.</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>CplDLk</td>
	 *            <td>10</td>
	 *            <td>0 1011</td>
	 *            <td>Completion for Locked Memory Read – otherwise like CplD.</td>
	 *            </tr>
	 *            </table>
	 * 
	 */
	public void setType(int format, int type)
	{
		if (!isValid(format, 0, 3, "TLP Header format (Fmt[1:0])"))
			return;

		if (!isValid(format, 0, 32, "TLP Header type (Type[4:0])"))
			return;

		// Concatenation of Fmt[1:0] & Type[4:0]
		int tlpType = ((format << 5) & type) & 0x7f;

		switch (tlpType)
		{

		//////////////////////////////////////////////
		// Memory Read Request
		//////////////////////////////////////////////
		case 0x00:
			transactionType = "Memory Read Request (32 bits address)";
			break;
		case 0x20:
			transactionType = "Memory Read Request (64 bits address)";
			break;

		//////////////////////////////////////////////
		// Memory Read Request-Locked
		//////////////////////////////////////////////
		case 0x01:
			transactionType = "Memory Read Request (32 bits address)";
			break;
		case 0x21:
			transactionType = "Memory Read Request (32 bits address)";
			break;

		//////////////////////////////////////////////
		// Memory write Request
		//////////////////////////////////////////////
		case 0x40:
			transactionType = "Memory write Request (32 bits address)";
			break;
		case 0x60:
			transactionType = "Memory write Request (64 bits address)";
			break;

		//////////////////////////////////////////////
		// I/O Read Request
		//////////////////////////////////////////////
		case 0x02:
			transactionType = "I/O Read Request (32 bits address)";
			break;

		//////////////////////////////////////////////
		// I/O Write Request
		//////////////////////////////////////////////
		case 0x42:
			transactionType = "I/O write Request (32 bits address)";
			break;

		//////////////////////////////////////////////
		// Configuration Read Type 0 Request
		//////////////////////////////////////////////
		case 0x04:
			transactionType = "Configuration Read Type 0 Request";
			break;

		//////////////////////////////////////////////
		// Configuration Write Type 0 Request
		//////////////////////////////////////////////
		case 0x44:
			transactionType = "Configuration write Type 0 Request";
			break;

		//////////////////////////////////////////////
		// Configuration Read Type 1 Request
		//////////////////////////////////////////////
		case 0x05:
			transactionType = "Configuration Read Type 1 Request";
			break;

		//////////////////////////////////////////////
		// Configuration Write Type 1 Request
		//////////////////////////////////////////////
		case 0x45:
			transactionType = "Configuration write Type 1 Request";
			break;

		//////////////////////////////////////////////
		// Message Request: Routed to Root Complex
		//////////////////////////////////////////////
		case 0x30:
			transactionType = "Message Request: Routed to Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request: Routed by address
		//////////////////////////////////////////////
		case 0x31:
			transactionType = "Message Request: Routed by address";
			break;

		//////////////////////////////////////////////
		// Message Request: Routed by ID
		//////////////////////////////////////////////
		case 0x32:
			transactionType = "Message Request: Routed by ID";
			break;

		//////////////////////////////////////////////
		// Message Request: Broadcast from Root Complex
		//////////////////////////////////////////////
		case 0x33:
			transactionType = "Message Request: Broadcast from Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request: Local - terminate at Receiver
		//////////////////////////////////////////////
		case 0x34:
			transactionType = "Message Request: Local - terminate at Receiver";
			break;

		//////////////////////////////////////////////
		// Message Request: Gathered and routed to Root Complex
		//////////////////////////////////////////////
		case 0x35:
			transactionType = "Message Request: Gathered and routed to Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request: Reserved - Terminate at Receiver
		//////////////////////////////////////////////
		case 0x36 | 0x37:
			transactionType = "Message Request: Reserved - Terminate at Receiver";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Routed to Root Complex
		//////////////////////////////////////////////
		case 0x70:
			transactionType = "Message Request with Payload : Routed to Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Routed by address
		//////////////////////////////////////////////
		case 0x71:
			transactionType = "Message Request with Payload : Routed by address";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Routed by ID
		//////////////////////////////////////////////
		case 0x72:
			transactionType = "Message Request with Payload : Routed by ID";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Broadcast from Root Complex
		//////////////////////////////////////////////
		case 0x73:
			transactionType = "Message Request with Payload : Broadcast from Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Local - terminate at Receiver
		//////////////////////////////////////////////
		case 0x74:
			transactionType = "Message Request with Payload : Local - terminate at Receiver";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Gathered and routed to Root Complex
		//////////////////////////////////////////////
		case 0x75:
			transactionType = "Message Request with Payload : Gathered and routed to Root Complex";
			break;

		//////////////////////////////////////////////
		// Message Request with Payload : Reserved - Terminate at Receiver
		//////////////////////////////////////////////
		case 0x76 | 0x77:
			transactionType = "Message Request with Payload : Reserved - Terminate at Receiver";
			break;

		//////////////////////////////////////////////
		// Completion without data
		//////////////////////////////////////////////
		case 0x0a:
			transactionType = "Completion without data";
			break;

		//////////////////////////////////////////////
		// Completion with data
		//////////////////////////////////////////////
		case 0x4a:
			transactionType = "Completion with data";
			break;

		//////////////////////////////////////////////
		// Completion for locked Memory Read without data
		//////////////////////////////////////////////
		case 0x0b:
			transactionType = "Completion for locked Memory Read without data";
			break;

		//////////////////////////////////////////////
		// Completion for locked Memory Read with data
		//////////////////////////////////////////////
		case 0x4b:
			transactionType = "Completion for locked Memory Read with data";
			break;

		//////////////////////////////////////////////
		// Unknown TLP Request Type
		//////////////////////////////////////////////
		default:

			return;
		}

		this.format = format;
		this.type = type;

	}


	/**
	 * @return the transactionType
	 */
	public String getTlpType()
	{
		return this.transactionType;
	}


	/**
	 * @return the trafficClass
	 */
	public int getTrafficClass()
	{
		return trafficClass;
	}


	/**
	 * @param trafficClass
	 *            the trafficClass to set
	 */
	public void setTrafficClass(int trafficClass)
	{
		if (!isValid(trafficClass, 0, 7, "TLP Header traffic class (TC[2:0])"))
			return;

		this.trafficClass = trafficClass;
	}


	/**
	 * @return the tlpDigestPresent
	 */
	public boolean isTlpDigestPresent()
	{
		return tlpDigestPresent;
	}


	/**
	 * @param tlpDigestPresent
	 *            the tlpDigestPresent to set
	 */
	public void setTlpDigestPresent()
	{
		this.setTlpDigestPresent(true);
	}


	public void setTlpDigestPresent(boolean isPresent)
	{
		this.tlpDigestPresent = isPresent;
	}


	/**
	 * @return the tlpPoisonned
	 */
	public boolean isTlpPoisonned()
	{
		return tlpPoisonned;
	}


	/**
	 * @param tlpPoisonned
	 *            the tlpPoisonned to set
	 */
	public void setTlpPoisonned()
	{
		this.setTlpPoisonned(true);
	}


	/**
	 * @param tlpPoisonned
	 *            the tlpPoisonned to set
	 */
	public void setTlpPoisonned(boolean isPoisonned)
	{
		this.tlpPoisonned = isPoisonned;
	}


	/**
	 * @return the attributes
	 */
	public int getAttributes()
	{
		return attributes;
	}


	/**
	 * @param attributes
	 *            the attributes to set
	 */
	public void setAttributes(int attributes)
	{
		if (!isValid(attributes, 0, 3, "TLP Header attributes (Attr[1:0])"))
			return;
		this.attributes = attributes;
	}


	/**
	 * @return the addressType
	 */
	public int getAddressType()
	{
		return addressType;
	}


	/**
	 * @param addressType
	 *            the addressType to set <BR>
	 *            <BR>
	 *            <p>
	 *            <b>Table 2-5: Address Type (AT) Field Encodings</b>
	 *            </p>
	 * 
	 *            <table border = 1>
	 *            <tr>
	 *            <td><b>AT Coding</b></td>
	 *            <td><b>Description</b></td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>00b</td>
	 *            <td>Default/Untranslated</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>01b</td>
	 *            <td>Translation Request</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>10b</td>
	 *            <td>Translated</td>
	 *            </tr>
	 * 
	 *            <tr>
	 *            <td>11b</td>
	 *            <td>Reserved</td>
	 *            </tr>
	 *            </table>
	 */
	public void setAddressType(int addressType)
	{
		if (!isValid(attributes, 0, 2, "TLP Header address type (AT[1:0])"))
			return;
		this.addressType = addressType;
	}


	/**
	 * @param
	 */
	public boolean is64BitsAddress()
	{
		return (this.format % 2 == 0) ? false : true;

	}


	/**
	 * @param
	 */
	public boolean is32BitsAddress()
	{
		return (this.format % 2 == 0) ? true : false;

	}


	/**
	 * @return the requesterID
	 */
	public int getRequesterID()
	{
		return requesterID;
	}


	/**
	 * @return the requester bus number
	 */
	public int getRequesterBusNumber()
	{
		//Bus number[7:0] = RequesterID[15:8]
		return (this.requesterID >> 8) & 0xFF;
	}


	/**
	 * @return the requester device number
	 */
	public int getRequesterDeviceNumber()
	{
		//Device number[4:0] = RequesterID[7:3]
		return (this.requesterID >> 3) & 0x1F;
	}


	/**
	 * @return the requester function number
	 */
	public int getRequesterFunctionNumber()
	{
		//Function number[2:0] = RequesterID[2:0]
		return this.requesterID & 0x7;
	}


	/**
	 * @param requesterID
	 *            the requesterID to set
	 */
	public void setRequesterID(int requesterID)
	{

		if (!isValid(requesterID, 0, 65535, "TLP Header requesterID (Length[15:0])"))
			return;
		this.requesterID = requesterID;
	}


	/**
	 * @param busNumber
	 *            The PCIe bus number of the requester
	 * @param deviceNumber
	 *            The PCIe device number of the requester
	 * @param functionNumber
	 *            The PCIe function number of the requester
	 */
	public void setRequesterID(int busNumber, int deviceNumber, int functionNumber)
	{
		// Validate the bus number
		if (!isValid(busNumber, 0, 255, "TLP Header bus number (BusNumber[7:0])"))
			return;
		// Validate the device number
		if (!isValid(deviceNumber, 0, 31, "TLP Header device number (DeviceNumber[4:0])"))
			return;
		// Validate the function number
		if (!isValid(functionNumber, 0, 7, "TLP Header function number (DeviceNumber[2:0])"))
			return;

		this.requesterID = ((busNumber << 8) | (deviceNumber << 3) | (functionNumber)) & 0xffff;
	}


	/**
	 * @return the tag
	 */
	public int getTag()
	{
		return tag;
	}


	/**
	 * @param tag
	 *            the tag to set
	 */
	public void setTag(int tag)
	{
		// Validate the Tag
		if (!isValid(tag, 0, 31, "TLP Header tag (Tag[4:0])"))
			return;
		this.tag = tag;
	}


	/**
	 * @return the transaction ID (requesterID[15:0] & Tag[7:0])
	 */
	public int getTransactionID()
	{
		return ((this.requesterID << 8) | tag) & 0xffffff;
	}


	/**
	 * @return the lastDWBE
	 */
	public int getLastDWBE()
	{
		return lastDWBE;
	}


	/**
	 * @param lastDWBE
	 *            the lastDWBE to set
	 */
	public void setLastDWBE(int lastDWBE)
	{
		// Validate the lastDWBE
		if (!isValid(lastDWBE, 0, 15, "TLP Header Last DWord Byte Enable (LastDWBE[3:0])"))
			return;
		this.lastDWBE = lastDWBE;
	}


	/**
	 * @return the firstDWBE
	 */
	public int getFirstDWBE()
	{
		return firstDWBE;
	}


	/**
	 * @param firstDWBE
	 *            the firstDWBE to set
	 */
	public void setFirstDWBE(int firstDWBE)
	{
		// Validate the lastDWBE
		if (!isValid(firstDWBE, 0, 15, "TLP Header First DWord Byte Enable (FirstDWBE[3:0])"))
			return;
		this.firstDWBE = firstDWBE;
	}


	/**
	 * @return the address
	 */
	public long getAddress()
	{
		return address;
	}


	/**
	 * @param address
	 *            the PCIe destination address to set
	 */
	public void setAddress(long address)
	{
		this.address = address & 0xfffffffffffffffeL;
	}


	private boolean isValid(int value, int minValue, int maxValue, String fieldName)
	{

		if (value < minValue)
		{
			String message = String.format("Field: %s: value %d is smaller than %d ", fieldName, value, minValue);
			FDKConsole.addErrorMessage(message);
			return false;

		}

		if (value > maxValue)
		{
			String message = String.format("Field: %s: value %d is greather than %d ", fieldName, value, maxValue);
			FDKConsole.addErrorMessage(message);
			return false;
		}

		return true;

	}


	public ArrayList<String[]> getFieldList()
	{
		ArrayList<String[]> fieldList = new ArrayList<String[]>();

		return fieldList;
	}

}
