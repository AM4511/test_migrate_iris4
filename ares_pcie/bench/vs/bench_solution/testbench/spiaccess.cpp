//==============================================================================
//
// Filename     :  FlashUpdate.cpp
// Owner        :  Matrox Imaging dept.
// Rev          :
// Content      :  Update the flash of Spider FPGA
// Compile flag :
//
// COPYRIGHT (c) Matrox Electronic Systems Ltd.
// All Rights Reserved
//==============================================================================
#include <mil.h>
#include "spiaccess.h"
using namespace std;

/**
 * This typedef defines qspi flash instruction format
 */
typedef struct {
	u8 OpCode;	/**< Operational code of the instruction */
	u8 InstSize;	/**< Size of the instruction including address bytes */
	u8 TxOffset;	/**< Register address where instruction has to be
			   written */
} XQspiPsInstFormat;

/***************** Macros (Inline Functions) Definitions *********************/

#define ARRAY_SIZE(Array)		(sizeof(Array) / sizeof((Array)[0]))

/*
 * List of all the QSPI instructions and its format
 */
static XQspiPsInstFormat FlashInst[] = {
   { XQSPIPS_FLASH_OPCODE_WREN, 1, XQSPIPS_TXD_01_OFFSET },
   { XQSPIPS_FLASH_OPCODE_WRDS, 1, XQSPIPS_TXD_01_OFFSET },
   { XQSPIPS_FLASH_OPCODE_RDSR1, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_RDSR2, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_WRSR, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_PP, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_SE, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_BE_32K, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_BE_4K, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_BE, 1, XQSPIPS_TXD_01_OFFSET },
   { XQSPIPS_FLASH_OPCODE_ERASE_SUS, 1, XQSPIPS_TXD_01_OFFSET },
   { XQSPIPS_FLASH_OPCODE_ERASE_RES, 1, XQSPIPS_TXD_01_OFFSET },
   { XQSPIPS_FLASH_OPCODE_RDID, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_NORM_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_FAST_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_DUAL_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_QUAD_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_DUAL_IO_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_QUAD_IO_READ, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_BRWR, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_BRRD, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_EARWR, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_EARRD, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_DIE_ERASE, 4, XQSPIPS_TXD_00_OFFSET },
   { XQSPIPS_FLASH_OPCODE_READ_FLAG_SR, 2, XQSPIPS_TXD_10_OFFSET },
   { XQSPIPS_FLASH_OPCODE_CLEAR_FLAG_SR, 1, XQSPIPS_TXD_01_OFFSET },
   /* Add all the instructions supported by the flash device */
};

#define DUMMY_SIZE		1 /* Number of dummy bytes for fast, dual and quad reads */
#define OVERHEAD_SIZE		4


CZynqQSpiAccess::CZynqQSpiAccess(volatile u32* zynqQspiWindow) : m_QspiRegisters(zynqQspiWindow), m_PhyAddr(), m_mBufId()
{
	
}

CZynqQSpiAccess::~CZynqQSpiAccess()
{
	UnmapPtr();
}

void CZynqQSpiAccess::Init()
{
	u32 ConfigReg;

	// Initialize the Configuration register to have Slave Select enabled, Manual Start Enable and Hold B active
	ConfigReg = QspiReadReg(XQSPIPS_CR_OFFSET);
	ConfigReg |= (XQSPIPS_CR_SSFORCE_MASK | XQSPIPS_CR_MANSTRTEN_MASK | XQSPIPS_CR_HOLD_B_MASK);
	QspiWriteReg(XQSPIPS_CR_OFFSET, ConfigReg);

	// Remove the Linear access mask, so we use the I/O mode, as opposite to the Linear mode.
	ConfigReg = QspiReadReg(XQSPIPS_LQSPI_CR_OFFSET);
	ConfigReg &= ~XQSPIPS_LQSPI_CR_LINEAR_MASK;
	QspiWriteReg(XQSPIPS_LQSPI_CR_OFFSET, ConfigReg);
}

void CZynqQSpiAccess::MapPtr()
{
	MbufCreate2d(M_DEFAULT_HOST,
		4096,
		1,
		8 + M_UNSIGNED,
		M_IMAGE + M_MMX_ENABLED,
		M_PHYSICAL_ADDRESS + M_PITCH_BYTE,
		4096,
		(void*)m_PhyAddr,
		m_mBufId);

	MbufInquireUnsafe(*m_mBufId, M_HOST_ADDRESS, &m_QspiRegisters); // Unsafe because volatile argument is not supported.
}

/**************************************************************************************************
* Name:           UnmapPtr()
*
* Synopsis:       Unmaps the Eeprom control pointer
*
* Note:
*
**************************************************************************************************/
void CZynqQSpiAccess::UnmapPtr()
{
	MbufFree(*m_mBufId);

	m_mBufId = 0;

	m_QspiRegisters = 0;
}


void CZynqQSpiAccess::ActivateSlaveSelect(bool Activate)
{
	u32 ConfigReg;
	ConfigReg = QspiReadReg(XQSPIPS_CR_OFFSET);
	if (Activate)
		ConfigReg &= ~XQSPIPS_CR_SSCTRL_MASK;
	else
		ConfigReg |= XQSPIPS_CR_SSCTRL_MASK;
	QspiWriteReg(XQSPIPS_CR_OFFSET, ConfigReg);
}

u32 CZynqQSpiAccess::FlashReadID()
{
	u8 WriteBuffer[4];
	u8 ReadBuffer[4] = { 0 };

	WriteBuffer[0] = 0x9F; //READ_ID;
	WriteBuffer[1] = 0x23;		/* 3 dummy bytes */
	WriteBuffer[2] = 0x08;
	WriteBuffer[3] = 0x09;

	PolledTransfer(WriteBuffer, ReadBuffer, 4);
	u32 FlashID = (ReadBuffer[3] << 24) | (ReadBuffer[2] << 16) | (ReadBuffer[1] << 8) | (ReadBuffer[0]);
	return FlashID;
}

void CZynqQSpiAccess::FlashRead(u32 Address, u32 ByteCount, u8 Command, u8 * ReadBuffer)
{
	u8 WriteBuffer[4];
	/*
	 * Setup the write command with the specified address and data for the
	 * FLASH
	 */
	WriteBuffer[0] = Command;
	WriteBuffer[1] = (u8)((Address & 0xFF0000) >> 16);
	WriteBuffer[2] = (u8)((Address & 0xFF00) >> 8);
	WriteBuffer[3] = (u8)(Address & 0xFF);

	if ((Command == FAST_READ_CMD) || (Command == DUAL_READ_CMD) ||
		(Command == QUAD_READ_CMD))
	{
		ByteCount += DUMMY_SIZE;
	}
	/*
	 * Send the read command to the FLASH to read the specified number
	 * of bytes from the FLASH, send the read command and address and
	 * receive the specified number of bytes of data in the data buffer
	 */
	PolledTransfer(WriteBuffer, ReadBuffer, ByteCount + OVERHEAD_SIZE);
}

u8* CZynqQSpiAccess::GetReadData(u32 Data, u8 * RecvBufferPtr, u32 RequestedBytes)
{
	u8 DataByte3;
	u8 ShiftReadData = 0;
	u8 Size = (u8)RequestedBytes;

	if (RecvBufferPtr)
	{
		switch (Size)
		{
		case 1:
			if (ShiftReadData == 1)
			{
				*((u8*)RecvBufferPtr) = ((Data & 0xFF000000) >> 24);
			}
			else
			{
				*((u8*)RecvBufferPtr) = (Data & 0xFF);
			}
			RecvBufferPtr += 1;
			break;
		case 2:
			if (ShiftReadData == 1)
			{
				*((u16*)RecvBufferPtr) = ((Data & 0xFFFF0000) >> 16);
			}
			else
			{
				*((u16*)RecvBufferPtr) = (Data & 0xFFFF);
			}
			RecvBufferPtr += 2;
			break;
		case 3:
			if (ShiftReadData == 1)
			{
				*((u16*)RecvBufferPtr) = (u16)((Data & 0x00FFFF00) >> 8);
				RecvBufferPtr += 2;
				DataByte3 = ((Data & 0xFF000000) >> 24);
				*((u8*)RecvBufferPtr) = DataByte3;
			}
			else {
				*((u16*)RecvBufferPtr) = (Data & 0xFFFF);
				RecvBufferPtr += 2;
				DataByte3 = (u8)((Data & 0x00FF0000) >> 16);
				*((u8*)RecvBufferPtr) = DataByte3;
			}
			RecvBufferPtr += 1;
			break;
		default:
			/* This will never execute */
			break;
		}
	}
	ShiftReadData = 0;
	RequestedBytes -= Size;
	if (RequestedBytes < 0)
	{
		RequestedBytes = 0;
	}
	return RecvBufferPtr;
}

void CZynqQSpiAccess::PolledTransfer(u8 * SendBuffer, u8 * RecvBuffer, u32 ByteCount)
{
	u8 Instruction;
	u32 Index;
	XQspiPsInstFormat* CurrInst;
	//   XQspiPsInstFormat NewInst[2];
	u8 TransCount;
	u32 Data;
	u8* SendBufferPtr;
	u8* RecvBufferPtr;
	u32 RequestedBytes, RemainingBytes;
	u32 RegValue;
	u32 RxCount = 0;

	Instruction = *SendBuffer;
	SendBufferPtr = SendBuffer;
	RecvBufferPtr = RecvBuffer;
	RequestedBytes = RemainingBytes = ByteCount;

	for (Index = 0; Index < ARRAY_SIZE(FlashInst); Index++)
	{
		if (Instruction == FlashInst[Index].OpCode)
		{
			break;
		}
	}


	ActivateSlaveSelect(true);
	EnableSpi();

	if (Index < ARRAY_SIZE(FlashInst))
	{
		CurrInst = &FlashInst[Index];
		/*
		 * Check for WRSR instruction which has different size for
		 * Spansion (3 bytes) and Micron (2 bytes)
		 */
		if ((CurrInst->OpCode == XQSPIPS_FLASH_OPCODE_WRSR) &&
			(ByteCount == 3))
		{
			CurrInst->InstSize = 3;
			CurrInst->TxOffset = XQSPIPS_TXD_11_OFFSET;
		}
	}
	else
	{
		CurrInst = &FlashInst[0];
		// Generate an error, opcpde not supported
	}

	/*
	 * If the instruction size in not 4 bytes then the data received needs
	 * to be shifted
	 */
	 //   if (CurrInst->InstSize != 4)
	 //      {
	 //      InstancePtr->ShiftReadData = 1;
	 //      }
	 //   else
	 //      {
	 //      InstancePtr->ShiftReadData = 0;
	 //      }
	TransCount = 0;
	/* Get the complete command (flash inst + address/data) */
	Data = *((u32*)SendBufferPtr);
	SendBufferPtr += CurrInst->InstSize;
	RemainingBytes -= CurrInst->InstSize;
	if (RemainingBytes < 0)
	{
		RemainingBytes = 0;
	}
	QspiWriteReg(CurrInst->TxOffset, Data);
	++TransCount;

	/*
	 * Fill the DTR/FIFO with as many bytes as it will take (or as
	 * many as we have to send).
	 */
	while ((RemainingBytes > 0) && (TransCount < XQSPIPS_FIFO_DEPTH))
	{
		QspiWriteReg(XQSPIPS_TXD_00_OFFSET, *((u32*)SendBufferPtr));
		SendBufferPtr += 4;
		RemainingBytes -= 4;
		if (RemainingBytes < 0)
		{
			RemainingBytes = 0;
		}
		++TransCount;
	}

	while ((RemainingBytes > 0) || (RequestedBytes > 0))
	{
		/*
		 * Fill the TX FIFO with RX threshold no. of entries (or as
		 * many as we have to send, in case that's less).
		 */
		while ((RemainingBytes > 0) && (TransCount < XQSPIPS_RXFIFO_THRESHOLD_OPT))
		{
			QspiWriteReg(XQSPIPS_TXD_00_OFFSET, *((u32*)SendBufferPtr));
			SendBufferPtr += 4;
			RemainingBytes -= 4;
			if (RemainingBytes < 0)
			{
				RemainingBytes = 0;
			}
			++TransCount;
		}

		// In Manual Start mode, start the transfer.
		RegValue = QspiReadReg(XQSPIPS_CR_OFFSET);
		RegValue |= XQSPIPS_CR_MANSTRT_MASK;
		QspiWriteReg(XQSPIPS_CR_OFFSET, RegValue);

		/*
		 * Reset TransCount - this is only used to fill TX FIFO
		 * in the above loop;
		 * RxCount is used to keep track of data received
		 */
		TransCount = 0;

		/*
		 * Wait for RX FIFO to reach threshold (or)
		 * TX FIFO to become empty.
		 * The latter check is required for
		 * small transfers (<32 words) and
		 * when the last chunk in a large data transfer is < 32 words.
		 */

		do
		{
			RegValue = QspiReadReg(XQSPIPS_SR_OFFSET);
		} while (((RegValue & XQSPIPS_IXR_TXOW_MASK) == 0) &&
			((RegValue & XQSPIPS_IXR_RXNEMPTY_MASK) == 0));

		/*
		 * A transmit has just completed. Process received data
		 * and check for more data to transmit.
		 * First get the data received as a result of the
		 * transmit that just completed. Receive data based on the
		 * count obtained while filling tx fifo. Always get
		 * the received data, but only fill the receive
		 * buffer if it points to something (the upper layer
		 * software may not care to receive data).
		 */
		while ((RequestedBytes > 0) && (RxCount < XQSPIPS_RXFIFO_THRESHOLD_OPT))
		{
			u32 Data;

			RxCount++;

			if (RecvBufferPtr != NULL)
			{
				if (RequestedBytes < 4)
				{
					Data = QspiReadReg(XQSPIPS_RXD_OFFSET);
					RecvBufferPtr = GetReadData(Data, RecvBufferPtr, RequestedBytes);
				}
				else
				{
					(*(u32*)RecvBufferPtr) = QspiReadReg(XQSPIPS_RXD_OFFSET);
					RecvBufferPtr += 4;
					RequestedBytes -= 4;
					if (RequestedBytes < 0)
					{
						RequestedBytes = 0;
					}
				}
			}
			else
			{
				Data = QspiReadReg(XQSPIPS_RXD_OFFSET);
				RequestedBytes -= 4;
			}
		}
		RxCount = 0;
	}


	DisableSpi();
	ActivateSlaveSelect(false);
}
