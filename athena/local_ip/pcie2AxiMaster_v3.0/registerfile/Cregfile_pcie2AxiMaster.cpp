/*****************************************************************************
** File                : Cregfile_pcie2AxiMaster.cpp
** Project             : FDK
** Module              : regfile_pcie2AxiMaster
** Created on          : 2020/06/29 12:06:56
** Created by          : imaval
** FDK IDE Version     : 4.7.0_beta4
** Build ID            : I20191220-1537
** Register file CRC32 : 0x482014AC
**
**  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#include "Cregfile_pcie2AxiMaster.h"

Cregfile_pcie2AxiMaster::Cregfile_pcie2AxiMaster() : CfdkRegisterFile("regfile_pcie2AxiMaster", 10, 32, true)
{
   CfdkSection *pSection;
   CfdkRegister *pRegister;

   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/info
   * Offset: 0x0
   *******************************************************************/
   pSection = createSection(this, "info", 0x0);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/info/tag(31:0)
   * Offset: 0x0
   * Address: 0x0
   *******************************************************************/
   pRegister = createRegister(pSection, "tag", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 24, CfdkField::STATIC, 0x58544d, 0x0, 0xffffff)); // tag(23:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/info/fid(31:0)
   * Offset: 0x4
   * Address: 0x4
   *******************************************************************/
   pRegister = createRegister(pSection, "fid", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::STATIC, 0x0, 0x0, 0xffffffff)); // fid(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/info/version(31:0)
   * Offset: 0x8
   * Address: 0x8
   *******************************************************************/
   pRegister = createRegister(pSection, "version", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "major", 16, 8, CfdkField::STATIC, 0x0, 0x0, 0xff)); // version(23:16)
   pRegister->addField(createField(pRegister, "minor", 8, 8, CfdkField::STATIC, 0x9, 0x0, 0xff)); // version(15:8)
   pRegister->addField(createField(pRegister, "sub_minor", 0, 8, CfdkField::STATIC, 0x0, 0x0, 0xff)); // version(7:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/info/capability(31:0)
   * Offset: 0xc
   * Address: 0xc
   *******************************************************************/
   pRegister = createRegister(pSection, "capability", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 8, CfdkField::STATIC, 0x0, 0x0, 0xff)); // capability(7:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/info/scratchpad(31:0)
   * Offset: 0x10
   * Address: 0x10
   *******************************************************************/
   pRegister = createRegister(pSection, "scratchpad", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // scratchpad(31:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/fpga
   * Offset: 0x20
   *******************************************************************/
   pSection = createSection(this, "fpga", 0x20);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/fpga/version(31:0)
   * Offset: 0x0
   * Address: 0x20
   *******************************************************************/
   pRegister = createRegister(pSection, "version", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "firmware_type", 24, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // version(31:24)
   pRegister->addField(createField(pRegister, "major", 16, 8, CfdkField::RO, 0x1, 0x0, 0xff)); // version(23:16)
   pRegister->addField(createField(pRegister, "minor", 8, 8, CfdkField::RO, 0x1, 0x0, 0xff)); // version(15:8)
   pRegister->addField(createField(pRegister, "sub_minor", 0, 8, CfdkField::RO, 0x1, 0x0, 0xff)); // version(7:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/fpga/build_id(31:0)
   * Offset: 0x4
   * Address: 0x24
   *******************************************************************/
   pRegister = createRegister(pSection, "build_id", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RO, 0x0, 0x0, 0xffffffff)); // build_id(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/fpga/device(31:0)
   * Offset: 0x8
   * Address: 0x28
   *******************************************************************/
   pRegister = createRegister(pSection, "device", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "id", 0, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // device(7:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/fpga/board_info(31:0)
   * Offset: 0xc
   * Address: 0x2c
   *******************************************************************/
   pRegister = createRegister(pSection, "board_info", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "capability", 0, 4, CfdkField::RO, 0x0, 0x0, 0xf)); // board_info(3:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/interrupts
   * Offset: 0x40
   *******************************************************************/
   pSection = createSection(this, "interrupts", 0x40);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/ctrl(31:0)
   * Offset: 0x0
   * Address: 0x40
   *******************************************************************/
   pRegister = createRegister(pSection, "ctrl", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "num_irq", 1, 7, CfdkField::RO, 0x1, 0x0, 0x7f)); // ctrl(7:1)
   pRegister->addField(createField(pRegister, "global_mask", 0, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // ctrl(0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/status[0](31:0)
   * Offset: 0x4
   * Address: 0x44
   *******************************************************************/
   pRegister = createRegister(pSection, "status[0]", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW2C, 0x0, 0xffffffff, 0x0)); // status[0](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/status[1](31:0)
   * Offset: 0x8
   * Address: 0x48
   *******************************************************************/
   pRegister = createRegister(pSection, "status[1]", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW2C, 0x0, 0xffffffff, 0x0)); // status[1](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/status[1](31:0)
   * Offset: 0x4
   * Address: 0x44
   *******************************************************************/
   pRegister = createRegister(pSection, "status[1]", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW2C, 0x0, 0xffffffff, 0x0)); // status[](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/enable[0](31:0)
   * Offset: 0xc
   * Address: 0x4c
   *******************************************************************/
   pRegister = createRegister(pSection, "enable[0]", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // enable[0](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/enable[1](31:0)
   * Offset: 0x10
   * Address: 0x50
   *******************************************************************/
   pRegister = createRegister(pSection, "enable[1]", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // enable[1](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/enable[1](31:0)
   * Offset: 0xc
   * Address: 0x4c
   *******************************************************************/
   pRegister = createRegister(pSection, "enable[1]", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // enable[](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/mask[0](31:0)
   * Offset: 0x14
   * Address: 0x54
   *******************************************************************/
   pRegister = createRegister(pSection, "mask[0]", 0x14, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // mask[0](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/mask[1](31:0)
   * Offset: 0x18
   * Address: 0x58
   *******************************************************************/
   pRegister = createRegister(pSection, "mask[1]", 0x18, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // mask[1](31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupts/mask[1](31:0)
   * Offset: 0x14
   * Address: 0x54
   *******************************************************************/
   pRegister = createRegister(pSection, "mask[1]", 0x14, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // mask[](31:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/interrupt_queue
   * Offset: 0x60
   *******************************************************************/
   pSection = createSection(this, "interrupt_queue", 0x60);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupt_queue/control(31:0)
   * Offset: 0x0
   * Address: 0x60
   *******************************************************************/
   pRegister = createRegister(pSection, "control", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "nb_dw", 24, 8, CfdkField::STATIC, 0x1, 0x0, 0xff)); // control(31:24)
   pRegister->addField(createField(pRegister, "enable", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // control(0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupt_queue/cons_idx(31:0)
   * Offset: 0x4
   * Address: 0x64
   *******************************************************************/
   pRegister = createRegister(pSection, "cons_idx", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "cons_idx", 0, 10, CfdkField::RW, 0x0, 0x3ff, 0x3ff)); // cons_idx(9:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupt_queue/addr_low(31:0)
   * Offset: 0x8
   * Address: 0x68
   *******************************************************************/
   pRegister = createRegister(pSection, "addr_low", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "addr", 0, 32, CfdkField::RW, 0x0, 0xfffff000, 0xffffffff)); // addr_low(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/interrupt_queue/addr_high(31:0)
   * Offset: 0xc
   * Address: 0x6c
   *******************************************************************/
   pRegister = createRegister(pSection, "addr_high", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "addr", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // addr_high(31:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/tlp
   * Offset: 0x70
   *******************************************************************/
   pSection = createSection(this, "tlp", 0x70);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/tlp/timeout(31:0)
   * Offset: 0x0
   * Address: 0x70
   *******************************************************************/
   pRegister = createRegister(pSection, "timeout", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x1dcd650, 0xffffffff, 0xffffffff)); // timeout(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/tlp/transaction_abort_cntr(31:0)
   * Offset: 0x4
   * Address: 0x74
   *******************************************************************/
   pRegister = createRegister(pSection, "transaction_abort_cntr", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "clr", 31, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // transaction_abort_cntr(31)
   pRegister->addField(createField(pRegister, "value", 0, 31, CfdkField::RO, 0x0, 0x0, 0x7fffffff)); // transaction_abort_cntr(30:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/spi
   * Offset: 0xe0
   *******************************************************************/
   pSection = createSection(this, "spi", 0xe0);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/spi/SPIREGIN(31:0)
   * Offset: 0x0
   * Address: 0xe0
   *******************************************************************/
   pRegister = createRegister(pSection, "SPIREGIN", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SPI_OLD_ENABLE", 25, 1, CfdkField::STATIC, 0x0, 0x0, 0x1)); // SPIREGIN(25)
   pRegister->addField(createField(pRegister, "SPI_ENABLE", 24, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SPIREGIN(24)
   pRegister->addField(createField(pRegister, "SPIRW", 22, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SPIREGIN(22)
   pRegister->addField(createField(pRegister, "SPICMDDONE", 21, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SPIREGIN(21)
   pRegister->addField(createField(pRegister, "SPISEL", 18, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SPIREGIN(18)
   pRegister->addField(createField(pRegister, "SPITXST", 16, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // SPIREGIN(16)
   pRegister->addField(createField(pRegister, "SPIDATAW", 0, 8, CfdkField::RW, 0x0, 0xff, 0xff)); // SPIREGIN(7:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/spi/SPIREGOUT(31:0)
   * Offset: 0x8
   * Address: 0xe8
   *******************************************************************/
   pRegister = createRegister(pSection, "SPIREGOUT", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SPI_WB_CAP", 17, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SPIREGOUT(17)
   pRegister->addField(createField(pRegister, "SPIWRTD", 16, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SPIREGOUT(16)
   pRegister->addField(createField(pRegister, "SPIDATARD", 0, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // SPIREGOUT(7:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/axi_window[0]
   * Offset: 0x100
   *******************************************************************/
   pSection = createSection(this, "axi_window[0]", 0x100);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/axi_window[0]/ctrl(31:0)
   * Offset: 0x0
   * Address: 0x100
   *******************************************************************/
   pRegister = createRegister(pSection, "ctrl", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "enable", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // ctrl(0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/axi_window[0]/pci_bar0_start(31:0)
   * Offset: 0x4
   * Address: 0x104
   *******************************************************************/
   pRegister = createRegister(pSection, "pci_bar0_start", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 26, CfdkField::RW, 0x0, 0x3fffffc, 0x3ffffff)); // pci_bar0_start(25:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/axi_window[0]/pci_bar0_stop(31:0)
   * Offset: 0x8
   * Address: 0x108
   *******************************************************************/
   pRegister = createRegister(pSection, "pci_bar0_stop", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 26, CfdkField::RW, 0x0, 0x3fffffc, 0x3ffffff)); // pci_bar0_stop(25:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/axi_window[0]/axi_translation(31:0)
   * Offset: 0xc
   * Address: 0x10c
   *******************************************************************/
   pRegister = createRegister(pSection, "axi_translation", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xfffffffc, 0xffffffff)); // axi_translation(31:0)


   /******************************************************************
   * Section: /regfile_pcie2AxiMaster/debug
   * Offset: 0x200
   *******************************************************************/
   pSection = createSection(this, "debug", 0x200);
   this->addSection(pSection);

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/debug/input(31:0)
   * Offset: 0x0
   * Address: 0x200
   *******************************************************************/
   pRegister = createRegister(pSection, "input", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RO, 0x0, 0x0, 0xffffffff)); // input(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/debug/output(31:0)
   * Offset: 0x4
   * Address: 0x204
   *******************************************************************/
   pRegister = createRegister(pSection, "output", 0x4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "value", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // output(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/debug/DMA_DEBUG1(31:0)
   * Offset: 0x8
   * Address: 0x208
   *******************************************************************/
   pRegister = createRegister(pSection, "DMA_DEBUG1", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "ADD_START", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DMA_DEBUG1(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/debug/DMA_DEBUG2(31:0)
   * Offset: 0xc
   * Address: 0x20c
   *******************************************************************/
   pRegister = createRegister(pSection, "DMA_DEBUG2", 0xc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "ADD_OVERRUN", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DMA_DEBUG2(31:0)

   /******************************************************************
   * Register: /regfile_pcie2AxiMaster/debug/DMA_DEBUG3(31:0)
   * Offset: 0x10
   * Address: 0x210
   *******************************************************************/
   pRegister = createRegister(pSection, "DMA_DEBUG3", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "DMA_ADD_ERROR", 4, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // DMA_DEBUG3(4)
   pRegister->addField(createField(pRegister, "DMA_OVERRUN", 0, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // DMA_DEBUG3(0)


}

