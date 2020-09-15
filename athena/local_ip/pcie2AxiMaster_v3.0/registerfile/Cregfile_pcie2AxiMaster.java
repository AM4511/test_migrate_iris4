/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: regfile_pcie2AxiMaster
**
**  DESCRIPTION: Register file of the regfile_pcie2AxiMaster module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.7.0_beta4
**  Build ID: I20191220-1537
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cregfile_pcie2AxiMaster  extends CRegisterFile {


   public Cregfile_pcie2AxiMaster()
   {
      super("regfile_pcie2AxiMaster", 10, 32, true);

      CSection section;
      CExternal external;
      CRegister register;

      /***************************************************************
      * Section: info
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "info", "PCIe2AxiMaster IP-Core general information", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: tag
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "tag", "Matrox Tag Identifier", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "Tag value", CField.FieldType.STATIC, 0, 24, 0x58544d));

      /***************************************************************
      * Register: fid
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "fid", "Matrox IP-Core Function ID", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.STATIC, 0, 32, 0x0));

      /***************************************************************
      * Register: version
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "version", "Register file version", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "major", "Major version", CField.FieldType.STATIC, 16, 8, 0x0));
      register.addField(new CField(register, "minor", "Minor version", CField.FieldType.STATIC, 8, 8, 0x9));
      register.addField(new CField(register, "sub_minor", "Sub minor version", CField.FieldType.STATIC, 0, 8, 0x0));

      /***************************************************************
      * Register: capability
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "capability", "Register file version", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.STATIC, 0, 8, 0x0));

      /***************************************************************
      * Register: scratchpad
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "scratchpad", "Scratch pad", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0x0));


      /***************************************************************
      * Section: fpga
      * Offset: 0x20
      ****************************************************************/
      section = new CSection(this, "fpga", "FPGA informations", 0x20);
      super.childrenList.add(section);

      /***************************************************************
      * Register: version
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "version", "Register file version", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "firmware_type", "Firmware type", CField.FieldType.RO, 24, 8, 0x0));
      register.addField(new CField(register, "major", "Major version", CField.FieldType.RO, 16, 8, 0x1));
      register.addField(new CField(register, "minor", "Minor version", CField.FieldType.RO, 8, 8, 0x1));
      register.addField(new CField(register, "sub_minor", "Sub minor version", CField.FieldType.RO, 0, 8, 0x1));

      /***************************************************************
      * Register: build_id
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "build_id", "Firmware build id", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RO, 0, 32, 0x0));

      /***************************************************************
      * Register: device
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "device", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "id", "Manufacturer FPGA device ID", CField.FieldType.RO, 0, 8, 0x0));

      /***************************************************************
      * Register: board_info
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "board_info", "Board information", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "capability", "Board capability", CField.FieldType.RO, 0, 4, 0x0));


      /***************************************************************
      * Section: interrupts
      * Offset: 0x40
      ****************************************************************/
      section = new CSection(this, "interrupts", "null", 0x40);
      super.childrenList.add(section);

      /***************************************************************
      * Register: ctrl
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "ctrl", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "num_irq", "Number of IRQ", CField.FieldType.RO, 1, 7, 0x1));
      register.addField(new CField(register, "global_mask", "Global Mask interrupt ", CField.FieldType.RW, 0, 1, 0x1));

      /***************************************************************
      * Register: status
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "status", "Interrupt status register", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW2CLR, 0, 32, 0x0));

      /***************************************************************
      * Register: enable
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "enable", "Interrupt status enable", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: mask
      * Offset: 0x14
      ****************************************************************/
      register = new CRegister(section, "mask", "Interrupt event mask", 0x14);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0xffffffff));


      /***************************************************************
      * Section: interrupt_queue
      * Offset: 0x60
      ****************************************************************/
      section = new CSection(this, "interrupt_queue", "null", 0x60);
      super.childrenList.add(section);

      /***************************************************************
      * Register: control
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "control", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "nb_dw", "Number of DWORDS", CField.FieldType.STATIC, 24, 8, 0x1));
      register.addField(new CField(register, "enable", "QInterrupt queue enable", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: cons_idx
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "cons_idx", "Consumer Index", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "cons_idx", "null", CField.FieldType.RW, 0, 10, 0x0));

      /***************************************************************
      * Register: addr_low
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "addr_low", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "addr", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: addr_high
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "addr_high", "null", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "addr", "null", CField.FieldType.RW, 0, 32, 0x0));


      /***************************************************************
      * Section: tlp
      * Offset: 0x70
      ****************************************************************/
      section = new CSection(this, "tlp", "Transaction Layer protocol", 0x70);
      super.childrenList.add(section);

      /***************************************************************
      * Register: timeout
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "timeout", "TLP transaction timeout value", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "TLP timeout value", CField.FieldType.RW, 0, 32, 0x1dcd650));

      /***************************************************************
      * Register: transaction_abort_cntr
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "transaction_abort_cntr", "TLP transaction abort counter", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "clr", "Clear transaction abort counter value", CField.FieldType.WO, 31, 1, 0x0));
      register.addField(new CField(register, "value", "Counter value", CField.FieldType.RO, 0, 31, 0x0));


      /***************************************************************
      * Section: spi
      * Offset: 0xe0
      ****************************************************************/
      section = new CSection(this, "spi", "null", 0xe0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: SPIREGIN
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "SPIREGIN", "SPI Register In", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SPI_OLD_ENABLE", "null", CField.FieldType.STATIC, 25, 1, 0x0));
      register.addField(new CField(register, "SPI_ENABLE", "SPI ENABLE", CField.FieldType.RW, 24, 1, 0x0));
      register.addField(new CField(register, "SPIRW", "SPI  Read Write", CField.FieldType.RW, 22, 1, 0x0));
      register.addField(new CField(register, "SPICMDDONE", "SPI  CoMmaD DONE", CField.FieldType.RW, 21, 1, 0x0));
      register.addField(new CField(register, "SPISEL", "SPI active channel SELection", CField.FieldType.RW, 18, 1, 0x0));
      register.addField(new CField(register, "SPITXST", "SPI SPITXST Transfer STart", CField.FieldType.WO, 16, 1, 0x0));
      register.addField(new CField(register, "SPIDATAW", "SPI Data  byte to write", CField.FieldType.RW, 0, 8, 0x0));

      /***************************************************************
      * Register: SPIREGOUT
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "SPIREGOUT", "SPI Register Out", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SPI_WB_CAP", "SPI Write Burst CAPable", CField.FieldType.RO, 17, 1, 0x0));
      register.addField(new CField(register, "SPIWRTD", "SPI Write or Read Transfer Done", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "SPIDATARD", "SPI DATA  Read byte OUTput ", CField.FieldType.RO, 0, 8, 0x0));


      /***************************************************************
      * Section: arbiter
      * Offset: 0xf0
      ****************************************************************/
      section = new CSection(this, "arbiter", "null", 0xf0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: ARBITER_CAPABILITIES
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "ARBITER_CAPABILITIES", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "AGENT_NB", "null", CField.FieldType.STATIC, 16, 2, 0x2));
      register.addField(new CField(register, "TAG", "null", CField.FieldType.STATIC, 0, 12, 0xaab));

      /***************************************************************
      * Register: AGENT
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "AGENT", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ACK", "master request ACKnoledge", CField.FieldType.RO, 9, 1, 0x0));
      register.addField(new CField(register, "REC", "master request RECeived", CField.FieldType.RO, 8, 1, 0x0));
      register.addField(new CField(register, "DONE", "transaction DONE ", CField.FieldType.WO, 4, 1, 0x0));
      register.addField(new CField(register, "REQ", "REQuest resource", CField.FieldType.WO, 0, 1, 0x0));


      /***************************************************************
      * Section: axi_window[3:0]
      * Offset: 0x100 + (i * 0x10) 
      ****************************************************************/
      for (int i = 0; i < 4; i++)
      {
         long sectionOffset = 0x100 + (i * 0x10);
         section = new CSection(this, "axi_window", "null", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: ctrl
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "ctrl", "PCIe Bar 0 start address", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "enable", "null", CField.FieldType.RW, 0, 1, 0x0));

         /************************************************************
         * Register: pci_bar0_start
         * Offset: 0x4
         *************************************************************/
         register = new CRegister(section, "pci_bar0_start", "PCIe Bar 0 window start offset", 0x4);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 26, 0x0));

         /************************************************************
         * Register: pci_bar0_stop
         * Offset: 0x8
         *************************************************************/
         register = new CRegister(section, "pci_bar0_stop", "PCIe Bar 0 window stop offset", 0x8);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 26, 0x0));

         /************************************************************
         * Register: axi_translation
         * Offset: 0xc
         *************************************************************/
         register = new CRegister(section, "axi_translation", "Axi offset translation", 0xc);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

      }


      /***************************************************************
      * Section: debug
      * Offset: 0x200
      ****************************************************************/
      section = new CSection(this, "debug", "null", 0x200);
      super.childrenList.add(section);

      /***************************************************************
      * Register: input
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "input", "debug input signals", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RO, 0, 32, 0x0));

      /***************************************************************
      * Register: output
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "output", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DMA_DEBUG1
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "DMA_DEBUG1", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ADD_START", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DMA_DEBUG2
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "DMA_DEBUG2", "null", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ADD_OVERRUN", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DMA_DEBUG3
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "DMA_DEBUG3", "null", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "DMA_ADD_ERROR", "null", CField.FieldType.RO, 4, 1, 0x0));
      register.addField(new CField(register, "DMA_OVERRUN", "null", CField.FieldType.RO, 0, 1, 0x0));


 }

}


