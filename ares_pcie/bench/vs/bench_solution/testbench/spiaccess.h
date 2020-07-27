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
#pragma once
#include <cstdint>
#include "fdk.h"

/** @name Register Map
 *
 * Register offsets from the base address of an QSPI device.
 * @{
 */
#define XQSPIPS_CR_OFFSET	 	    0x00 /**< Configuration Register */
#define XQSPIPS_SR_OFFSET	 	    0x04 /**< Interrupt Status */
#define XQSPIPS_IER_OFFSET	 	    0x08 /**< Interrupt Enable */
#define XQSPIPS_IDR_OFFSET	 	    0x0c /**< Interrupt Disable */
#define XQSPIPS_IMR_OFFSET	 	    0x10 /**< Interrupt Enabled Mask */
#define XQSPIPS_ER_OFFSET	 	    0x14 /**< Enable/Disable Register */
#define XQSPIPS_DR_OFFSET	 	    0x18 /**< Delay Register */
#define XQSPIPS_TXD_00_OFFSET	    0x1C /**< Transmit 4-byte inst/data */
#define XQSPIPS_RXD_OFFSET	 	    0x20 /**< Data Receive Register */
#define XQSPIPS_SICR_OFFSET	 	    0x24 /**< Slave Idle Count */
#define XQSPIPS_TXWR_OFFSET	 	    0x28 /**< Transmit FIFO Watermark */
#define XQSPIPS_RXWR_OFFSET	 	    0x2C /**< Receive FIFO Watermark */
#define XQSPIPS_GPIO_OFFSET	 	    0x30 /**< GPIO Register */
#define XQSPIPS_LPBK_DLY_ADJ_OFFSET	0x38 /**< Loopback Delay Adjust Reg */
#define XQSPIPS_TXD_01_OFFSET	 	0x80 /**< Transmit 1-byte inst */
#define XQSPIPS_TXD_10_OFFSET	 	0x84 /**< Transmit 2-byte inst */
#define XQSPIPS_TXD_11_OFFSET	 	0x88 /**< Transmit 3-byte inst */
#define XQSPIPS_LQSPI_CR_OFFSET  	0xA0 /**< Linear QSPI config register */
#define XQSPIPS_LQSPI_SR_OFFSET  	0xA4 /**< Linear QSPI status register */
#define XQSPIPS_MOD_ID_OFFSET  		0xFC /**< Module ID register */


 // QSPI Configuration Register bits
#define XQSPIPS_CR_SSFORCE_MASK   0x00004000 /**< Force Slave Select (bit 14)  */
#define XQSPIPS_CR_SSCTRL_MASK    0x00000400 /**< Slave Select Decode */
#define XQSPIPS_CR_MANSTRT_MASK   0x00010000 /**< Manual Transmission Start */
#define XQSPIPS_CR_MANSTRTEN_MASK 0x00008000 /**< Manual Transmission Start (bit 15) */
#define XQSPIPS_CR_HOLD_B_MASK    0x00080000 /**< HOLD_B Pin Drive Enable (bit 19) */

// Linear QSPI Configuration Register
#define XQSPIPS_LQSPI_CR_LINEAR_MASK	 0x80000000 /**< LQSPI mode enable */


#define XQSPIPS_IXR_TXUF_MASK	   0x00000040  /**< QSPI Tx FIFO Underflow */
#define XQSPIPS_IXR_RXFULL_MASK    0x00000020  /**< QSPI Rx FIFO Full */
#define XQSPIPS_IXR_RXNEMPTY_MASK  0x00000010  /**< QSPI Rx FIFO Not Empty */
#define XQSPIPS_IXR_TXFULL_MASK    0x00000008  /**< QSPI Tx FIFO Full */
#define XQSPIPS_IXR_TXOW_MASK	   0x00000004  /**< QSPI Tx FIFO Overwater */
#define XQSPIPS_IXR_RXOVR_MASK	   0x00000001  /**< QSPI Rx FIFO Overrun */
#define XQSPIPS_IXR_DFLT_MASK	   0x00000025  /**< QSPI default interrupts


/** @name Flash commands
 *
 * The following constants define most of the commands supported by flash
 * devices. Users can add more commands supported by the flash devices
 *
 * @{
 */
#define	XQSPIPS_FLASH_OPCODE_WRSR	0x01 /* Write status register */
#define	XQSPIPS_FLASH_OPCODE_PP		0x02 /* Page program */
#define	XQSPIPS_FLASH_OPCODE_NORM_READ	0x03 /* Normal read data bytes */
#define	XQSPIPS_FLASH_OPCODE_WRDS	0x04 /* Write disable */
#define	XQSPIPS_FLASH_OPCODE_RDSR1	0x05 /* Read status register 1 */
#define	XQSPIPS_FLASH_OPCODE_WREN	0x06 /* Write enable */
#define	XQSPIPS_FLASH_OPCODE_FAST_READ	0x0B /* Fast read data bytes */
#define	XQSPIPS_FLASH_OPCODE_BE_4K	0x20 /* Erase 4KiB block */
#define	XQSPIPS_FLASH_OPCODE_RDSR2	0x35 /* Read status register 2 */
#define	XQSPIPS_FLASH_OPCODE_DUAL_READ	0x3B /* Dual read data bytes */
#define	XQSPIPS_FLASH_OPCODE_BE_32K	0x52 /* Erase 32KiB block */
#define	XQSPIPS_FLASH_OPCODE_QUAD_READ	0x6B /* Quad read data bytes */
#define	XQSPIPS_FLASH_OPCODE_ERASE_SUS	0x75 /* Erase suspend */
#define	XQSPIPS_FLASH_OPCODE_ERASE_RES	0x7A /* Erase resume */
#define	XQSPIPS_FLASH_OPCODE_RDID	0x9F /* Read JEDEC ID */
#define	XQSPIPS_FLASH_OPCODE_BE		0xC7 /* Erase whole flash block */
#define	XQSPIPS_FLASH_OPCODE_SE		0xD8 /* Sector erase (usually 64KB)*/
#define XQSPIPS_FLASH_OPCODE_DUAL_IO_READ 0xBB /* Read data using Dual I/O */
#define XQSPIPS_FLASH_OPCODE_QUAD_IO_READ 0xEB /* Read data using Quad I/O */
#define XQSPIPS_FLASH_OPCODE_BRWR	0x17 /* Bank Register Write */
#define XQSPIPS_FLASH_OPCODE_BRRD	0x16 /* Bank Register Read */
 /* Extende Address Register Write - Micron's equivalent of Bank Register */
#define XQSPIPS_FLASH_OPCODE_EARWR	0xC5
/* Extende Address Register Read - Micron's equivalent of Bank Register */
#define XQSPIPS_FLASH_OPCODE_EARRD	0xC8
#define XQSPIPS_FLASH_OPCODE_DIE_ERASE	0xC4
#define XQSPIPS_FLASH_OPCODE_READ_FLAG_SR	0x70
#define XQSPIPS_FLASH_OPCODE_CLEAR_FLAG_SR	0x50
#define XQSPIPS_FLASH_OPCODE_READ_LOCK_REG	0xE8	/* Lock register Read */
#define XQSPIPS_FLASH_OPCODE_WRITE_LOCK_REG	0xE5	/* Lock Register Write */


#define XQSPIPS_FIFO_DEPTH	63	/**< FIFO depth (words) */

/** @name FIFO threshold value
 *
 * This is the Rx FIFO threshold (in words) that was found to be most
 * optimal in terms of performance
 *
 * @{
 */
#define XQSPIPS_RXFIFO_THRESHOLD_OPT		32

#define PAGE_SIZE	 256
#define PAGE_COUNT	 16
#define MAX_DATA	 PAGE_COUNT * PAGE_SIZE
#define DATA_OFFSET	 4 /* Start of Data for Read/Write */
#define DUMMY_OFFSET 4 /* Dummy byte offset for fast, dual and quad reads */
#define DUMMY_SIZE   1 /* Number of dummy bytes for fast, dual and quad reads */


 /*
  * The following constants define the commands which may be sent to the FLASH
  * device.
  */
#define WRITE_STATUS_CMD	0x01
#define WRITE_CMD		0x02
#define READ_CMD		0x03
#define WRITE_DISABLE_CMD	0x04
#define READ_STATUS_CMD		0x05
#define WRITE_ENABLE_CMD	0x06
#define FAST_READ_CMD		0x0B
#define DUAL_READ_CMD		0x3B
#define QUAD_READ_CMD		0x6B
#define BULK_ERASE_CMD		0xC7
#define	SEC_ERASE_CMD		0xD8
#define READ_ID			0x9F



class CZynqQSpiAccess
{
public:
	// Constructor/Destructor
	CZynqQSpiAccess(volatile u32* zynqQspiWindow);
	~CZynqQSpiAccess();

	void QspiWriteReg(u32  RegOffset, u32  RegValue) { *(m_QspiRegisters + (RegOffset >> 2)) = RegValue; };
	u32  QspiReadReg(u32  RegOffset) { return *(m_QspiRegisters + (RegOffset >> 2)); };


	void EnableSpi() { QspiWriteReg(XQSPIPS_ER_OFFSET, 1); }
	void DisableSpi() { QspiWriteReg(XQSPIPS_ER_OFFSET, 0); }

	void Init();
	void MapPtr();
	void UnmapPtr();

	void ActivateSlaveSelect(bool Activate);
	u32  FlashReadID();
	void FlashRead(u32  Address, u32  ByteCount, u8 Command, u8 * ReadBuffer);
	u8* GetReadData(u32  Data, u8 * RecvBufferPtr, u32 RequestedBytes);
	void PolledTransfer(u8 * SendBuffer, u8 * RecvBuffer, u32  ByteCount);

private:
	volatile u32* m_QspiRegisters;
	u64 m_PhyAddr;
	MIL_ID* m_mBufId;

}; /* CZynqQSpiAccess */
