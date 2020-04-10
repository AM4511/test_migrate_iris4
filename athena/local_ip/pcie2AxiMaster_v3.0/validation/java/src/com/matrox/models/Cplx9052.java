package com.matrox.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;
import com.fdk.validation.models.registerfile.CSection;

/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: plx9052
**
**  DESCRIPTION: Register file of the plx9052 module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.5.0_beta5
**  Build ID: I20151222-1010
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cplx9052  extends CRegisterFile {


   public Cplx9052()
   {
      super("plx9052", 8, 32, true);

      CSection section;
      CRegister register;
      /***************************************************************
      * Section: local_config
      * Offset: 0x4c
      ****************************************************************/
      section = new CSection(this, "local_config", "PLX 9052 Local Bus register emulations", 0x4c);
      super.childrenList.add(section);

      /***************************************************************
      * Register: intcsr
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "intcsr", "Interrupt Control/Status", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SOFTINT", "Software Interrupt", CField.FieldType.RW, 7, 1, 0x0));
      register.addField(new CField(register, "PINTEN", "PCI Interrupt Enable", CField.FieldType.RW, 6, 1, 0x0));
      register.addField(new CField(register, "LINTi2STAT", "Local INTerrupt input # 2 STATus", CField.FieldType.RO, 5, 1, 0x0));
      register.addField(new CField(register, "LINTi2POL", "Local INTerrupt input # 2 Polarity", CField.FieldType.RW, 4, 1, 0x0));
      register.addField(new CField(register, "LINTi2EN", "Local INTerrupt input # 2 ENable", CField.FieldType.RW, 3, 1, 0x0));
      register.addField(new CField(register, "LINTi1STAT", "Local INTerrupt input # 1 STATus", CField.FieldType.RO, 2, 1, 0x0));
      register.addField(new CField(register, "LINTi1POL", "Local INTerrupt input # 1 Polarity", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "LINTi1EN", "Local INTerrupt input # 1 ENable", CField.FieldType.RW, 0, 1, 0x0));


      /***************************************************************
      * Section: mvb
      * Offset: 0xa0
      ****************************************************************/
      section = new CSection(this, "mvb", "Matrox VME Bridge (MVB)", 0xa0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: version
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "version", "MVB Register file version", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "scratch", "Scratch pad", CField.FieldType.RW, 16, 16, 0xcafe));
      register.addField(new CField(register, "major", "Register file major version", CField.FieldType.STATIC, 8, 8, 0x0));
      register.addField(new CField(register, "minor", "Registerfile minor version", CField.FieldType.STATIC, 0, 8, 0x1));

      /***************************************************************
      * Register: build_id
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "build_id", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RO, 0, 32, 0x0));

      /***************************************************************
      * Register: svn
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "svn", "Subversion", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "revision", "SVN revision number", CField.FieldType.RO, 0, 32, 0x0));

      /***************************************************************
      * Register: capability
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "capability", "null", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "numbuart", "Number of UART", CField.FieldType.STATIC, 0, 4, 0x8));

      /***************************************************************
      * Register: vme_timeout
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "vme_timeout", "VME Bus time out value", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 20, 0x208d5));


      /***************************************************************
      * Section: SPI
      * Offset: 0xe0
      ****************************************************************/
      section = new CSection(this, "SPI", "Serial Peripheral Interface Bus", 0xe0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: SPIREGIN
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "SPIREGIN", "SPI Register In", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SPI_ENABLE", "SPI ENABLE", CField.FieldType.RW, 24, 1, 0x0));
      register.addField(new CField(register, "SPIRW", "SPI  Read Write", CField.FieldType.RW, 22, 1, 0x0));
      register.addField(new CField(register, "SPICMDDONE", "SPI  CoMmaD DONE", CField.FieldType.RW, 21, 1, 0x0));
      register.addField(new CField(register, "SPISEL", "SPI active channel SELection", CField.FieldType.STATIC, 18, 1, 0x0));
      register.addField(new CField(register, "SPITXST", "SPI Transfer STart", CField.FieldType.WO, 16, 1, 0x0));
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
      * Section: debug
      * Offset: 0xf0
      ****************************************************************/
      section = new CSection(this, "debug", "Debug control section", 0xf0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: status
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "status", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "error", "Master error ", CField.FieldType.RO, 31, 1, 0x0));

      /***************************************************************
      * Register: vme_iread_req_cntr
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "vme_iread_req_cntr", "VME Interface interrupt status read request transaction counter", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "clr", "clear", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "overflow", "Counter overflow", CField.FieldType.RO, 30, 1, 0x0));
      register.addField(new CField(register, "count", "Count value", CField.FieldType.RO, 0, 24, 0x0));

      /***************************************************************
      * Register: vme_iread_compl_cntr
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "vme_iread_compl_cntr", "VME Interface Interrupt read request completion counter", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "clr", "clear", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "overflow", "Counter overflow", CField.FieldType.RO, 30, 1, 0x0));
      register.addField(new CField(register, "count", "Count value", CField.FieldType.RO, 0, 24, 0x0));

      /***************************************************************
      * Register: vme_bus_error_cntr
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "vme_bus_error_cntr", "VME Interface Bus error counter", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "clr", "clear", CField.FieldType.RW, 31, 1, 0x0));
      register.addField(new CField(register, "overflow", "Counter overflow", CField.FieldType.RO, 30, 1, 0x0));
      register.addField(new CField(register, "count", "Count value", CField.FieldType.RO, 0, 24, 0x0));


 }

}

