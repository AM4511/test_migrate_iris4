package com.fdk.validation.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;
import com.fdk.validation.models.registerfile.CSection;

/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: dmawr
**
**  DESCRIPTION: Register file of the dmawr module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.2.0_beta2
**  Build ID: I20130418-1619
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cdmawr  extends CRegisterFile {


   public Cdmawr()
   {
      super("dmawr", 9, 64, true);

      CSection section;
      CRegister register;
      /***************************************************************
      * Section: HEADER
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "HEADER", "null", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: fstruc
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "fstruc", "Function STRUCture", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "tag", "Structure valid TAG", CField.FieldType.STATIC, 8, 24, 0x4d5458));
      register.addField(new CField(register, "mjver", "Standard header structure MaJor VERsion", CField.FieldType.STATIC, 4, 4, 0x1));
      register.addField(new CField(register, "mnver", "Standard header structure MiNor VERsion", CField.FieldType.STATIC, 0, 4, 0x4));

      /***************************************************************
      * Register: fid
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "fid", "Function IDentification", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "fid", "Function IDentification", CField.FieldType.STATIC, 16, 16, 0xc011));
      register.addField(new CField(register, "CAPABILITY", "CAPABILITY list", CField.FieldType.STATIC, 0, 16, 0x0));

      /***************************************************************
      * Register: fsize
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "fsize", "Function register SIZE", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "fullsize", "FULL register SIZE", CField.FieldType.STATIC, 16, 16, 0x40));
      register.addField(new CField(register, "usersize", "SPECific register SIZE", CField.FieldType.STATIC, 0, 16, 0x8));

      /***************************************************************
      * Register: fctrl
      * Offset: 0x18
      ****************************************************************/
      register = new CRegister(section, "fctrl", "Function ConTRoL", 0x18);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "snppdg", "SNapSHot PenDinG", CField.FieldType.RO, 29, 1, 0x0));
      register.addField(new CField(register, "active", "Active", CField.FieldType.RO, 28, 1, 0x0));
      register.addField(new CField(register, "snpsht", "SNaPSHoT", CField.FieldType.WO, 25, 1, 0x0));
      register.addField(new CField(register, "abort", "ABORT process", CField.FieldType.RW, 24, 1, 0x0));
      register.addField(new CField(register, "ipferr", "IP Function ERRor", CField.FieldType.STATIC, 16, 8, 0x0));

      /***************************************************************
      * Register: foffset
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "foffset", "Function OFFSET", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ioctloff", "IO ConTroL register OFFset", CField.FieldType.STATIC, 16, 16, 0x0));
      register.addField(new CField(register, "useroff", "SPECific register offset", CField.FieldType.STATIC, 0, 16, 0x8));

      /***************************************************************
      * Register: fint
      * Offset: 0x28
      ****************************************************************/
      register = new CRegister(section, "fint", "Function Interrupt", 0x28);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "lsbof", "LSB OFFSET", CField.FieldType.RO, 8, 7, 0x0));
      register.addField(new CField(register, "ipevent", "IP (number of) EVENT", CField.FieldType.STATIC, 0, 3, 0x1));

      /***************************************************************
      * Register: fversion
      * Offset: 0x30
      ****************************************************************/
      register = new CRegister(section, "fversion", "Function VERSION ", 0x30);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SUBFID", "SUB Function ID", CField.FieldType.RO, 16, 8, 0x0));
      register.addField(new CField(register, "ipmjver", "IP register structure MaJor VERsion", CField.FieldType.STATIC, 12, 4, 0x2));
      register.addField(new CField(register, "ipmnver", "IP register structure MiNor VERsion", CField.FieldType.STATIC, 8, 4, 0x1));
      register.addField(new CField(register, "iphwver", "IP HardWare VERsion", CField.FieldType.RO, 3, 5, 0x0));

      /***************************************************************
      * Register: frsvd3
      * Offset: 0x38
      ****************************************************************/
      register = new CRegister(section, "frsvd3", "Function ReSerVed 3", 0x38);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "frsvd3", "Function Reserved 3", CField.FieldType.STATIC, 0, 32, 0x0));


      /***************************************************************
      * Section: USER
      * Offset: 0x40
      ****************************************************************/
      section = new CSection(this, "USER", "null", 0x40);
      super.childrenList.add(section);

      /***************************************************************
      * Register: dstfstart
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "dstfstart", "Destination frame start register.", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "fstart", "Frame start address", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: dstlnpitch
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "dstlnpitch", "Destination pitch register.", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "lnpitch", "Pitch", CField.FieldType.RW, 0, 21, 0x0));

      /***************************************************************
      * Register: dstlnsize
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "dstlnsize", "Destination row size register.", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "lnsize", "Row size", CField.FieldType.RW, 0, 20, 0x0));

      /***************************************************************
      * Register: dstnbline
      * Offset: 0x18
      ****************************************************************/
      register = new CRegister(section, "dstnbline", "Destination number of row register.", 0x18);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "nbline", "Number of rows", CField.FieldType.RW, 0, 20, 0x0));

      /***************************************************************
      * Register: DSTFSTART1
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "DSTFSTART1", "DeSTination Frame START register context 1", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "FSTART", "Frame START address of the context number 1", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DSTFSTART2
      * Offset: 0x28
      ****************************************************************/
      register = new CRegister(section, "DSTFSTART2", "DeSTination Frame START register context 2", 0x28);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "FSTART", "Frame START address of the context number 2", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DSTFSTART3
      * Offset: 0x30
      ****************************************************************/
      register = new CRegister(section, "DSTFSTART3", "DeSTination Frame START register context 3", 0x30);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "FSTART", "Frame START address of the context number 3", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: DSTCTRL
      * Offset: 0x38
      ****************************************************************/
      register = new CRegister(section, "DSTCTRL", "DeSTination ConTRoL", 0x38);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "BUFCLR", "BUFfer CLeaR", CField.FieldType.RW, 7, 1, 0x0));
      register.addField(new CField(register, "DTE3", "Data Transfer Enable 3", CField.FieldType.RW, 6, 1, 0x1));
      register.addField(new CField(register, "DTE2", "Data Transfer Enable 2", CField.FieldType.RW, 5, 1, 0x1));
      register.addField(new CField(register, "DTE1", "Data Transfer Enable 1", CField.FieldType.RW, 4, 1, 0x1));
      register.addField(new CField(register, "DTE0", "Data Transfer Enable 0", CField.FieldType.RW, 3, 1, 0x1));
      register.addField(new CField(register, "BITWDTH", "BIT WiDTH", CField.FieldType.RW, 2, 1, 0x0));
      register.addField(new CField(register, "NBCONTX", "NumBer of CONTeXt", CField.FieldType.RW, 0, 2, 0x0));

      /***************************************************************
      * Register: DSTCLRPTRN
      * Offset: 0x40
      ****************************************************************/
      register = new CRegister(section, "DSTCLRPTRN", "DeSTination CLeaR PaTteRN", 0x40);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "CLRPTRN", "CLeaR PaTteRN", CField.FieldType.RW, 0, 32, 0x0));


 }

}

