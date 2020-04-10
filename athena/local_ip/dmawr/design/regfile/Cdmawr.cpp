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
**  FDK IDE Version: 3.7.9
**  Build ID: I20120425-1654
**
**  COPYRIGHT (c) 2014 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#include "Cdmawr.h"

Cdmawr::Cdmawr() : CfdkRegisterFile("dmawr", 9, 64, true)
{
   CfdkSection *pSection;
   CfdkRegister *pRegister;


   /******************************************************************
   * Section: //HEADER
   * Offset: 0x0
   *******************************************************************/
   pSection = createSection(this, "HEADER", 0x0);
   this->addSection(pSection);

   /******************************************************************
   * Register: //HEADER/fstruc(63:0)
   * Offset: 0x0
   * Address: 0x0
   *******************************************************************/
   pRegister = createRegister(pSection, "fstruc", 0x0, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "tag", 8, 24, CfdkField::STATIC, 0x4d5458, 0x0, 0xffffff)); // fstruc(31:8)
   pRegister->addField(createField(pRegister, "mjver", 4, 4, CfdkField::STATIC, 0x1, 0x0, 0xf)); // fstruc(7:4)
   pRegister->addField(createField(pRegister, "mnver", 0, 4, CfdkField::STATIC, 0x4, 0x0, 0xf)); // fstruc(3:0)

   /******************************************************************
   * Register: //HEADER/fid(63:0)
   * Offset: 0x8
   * Address: 0x8
   *******************************************************************/
   pRegister = createRegister(pSection, "fid", 0x8, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "fid", 16, 16, CfdkField::STATIC, 0xc011, 0x0, 0xffff)); // fid(31:16)
   pRegister->addField(createField(pRegister, "CAPABILITY", 0, 16, CfdkField::STATIC, 0x0, 0x0, 0xffff)); // fid(15:0)

   /******************************************************************
   * Register: //HEADER/fsize(63:0)
   * Offset: 0x10
   * Address: 0x10
   *******************************************************************/
   pRegister = createRegister(pSection, "fsize", 0x10, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "fullsize", 16, 16, CfdkField::STATIC, 0x40, 0x0, 0xffff)); // fsize(31:16)
   pRegister->addField(createField(pRegister, "usersize", 0, 16, CfdkField::STATIC, 0x8, 0x0, 0xffff)); // fsize(15:0)

   /******************************************************************
   * Register: //HEADER/fctrl(63:0)
   * Offset: 0x18
   * Address: 0x18
   *******************************************************************/
   pRegister = createRegister(pSection, "fctrl", 0x18, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "snppdg", 29, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // fctrl(29)
   pRegister->addField(createField(pRegister, "active", 28, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // fctrl(28)
   pRegister->addField(createField(pRegister, "snpsht", 25, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // fctrl(25)
   pRegister->addField(createField(pRegister, "abort", 24, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // fctrl(24)
   pRegister->addField(createField(pRegister, "ipferr", 16, 8, CfdkField::STATIC, 0x0, 0x0, 0xff)); // fctrl(23:16)

   /******************************************************************
   * Register: //HEADER/foffset(63:0)
   * Offset: 0x20
   * Address: 0x20
   *******************************************************************/
   pRegister = createRegister(pSection, "foffset", 0x20, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "ioctloff", 16, 16, CfdkField::STATIC, 0x0, 0x0, 0xffff)); // foffset(31:16)
   pRegister->addField(createField(pRegister, "useroff", 0, 16, CfdkField::STATIC, 0x8, 0x0, 0xffff)); // foffset(15:0)

   /******************************************************************
   * Register: //HEADER/fint(63:0)
   * Offset: 0x28
   * Address: 0x28
   *******************************************************************/
   pRegister = createRegister(pSection, "fint", 0x28, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "lsbof", 8, 7, CfdkField::RO, 0x0, 0x0, 0x7f)); // fint(14:8)
   pRegister->addField(createField(pRegister, "ipevent", 0, 3, CfdkField::STATIC, 0x1, 0x0, 0x7)); // fint(2:0)

   /******************************************************************
   * Register: //HEADER/fversion(63:0)
   * Offset: 0x30
   * Address: 0x30
   *******************************************************************/
   pRegister = createRegister(pSection, "fversion", 0x30, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SUBFID", 16, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // fversion(23:16)
   pRegister->addField(createField(pRegister, "ipmjver", 12, 4, CfdkField::STATIC, 0x2, 0x0, 0xf)); // fversion(15:12)
   pRegister->addField(createField(pRegister, "ipmnver", 8, 4, CfdkField::STATIC, 0x2, 0x0, 0xf)); // fversion(11:8)
   pRegister->addField(createField(pRegister, "iphwver", 3, 5, CfdkField::RO, 0x0, 0x0, 0x1f)); // fversion(7:3)

   /******************************************************************
   * Register: //HEADER/frsvd3(63:0)
   * Offset: 0x38
   * Address: 0x38
   *******************************************************************/
   pRegister = createRegister(pSection, "frsvd3", 0x38, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "frsvd3", 0, 32, CfdkField::STATIC, 0x0, 0x0, 0xffffffff)); // frsvd3(31:0)


   /******************************************************************
   * Section: //USER
   * Offset: 0x40
   *******************************************************************/
   pSection = createSection(this, "USER", 0x40);
   this->addSection(pSection);

   /******************************************************************
   * Register: //USER/dstfstart(63:0)
   * Offset: 0x0
   * Address: 0x40
   *******************************************************************/
   pRegister = createRegister(pSection, "dstfstart", 0x0, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "fstart", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // dstfstart(31:0)

   /******************************************************************
   * Register: //USER/dstlnpitch(63:0)
   * Offset: 0x8
   * Address: 0x48
   *******************************************************************/
   pRegister = createRegister(pSection, "dstlnpitch", 0x8, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "lnpitch", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // dstlnpitch(31:0)

   /******************************************************************
   * Register: //USER/dstlnsize(63:0)
   * Offset: 0x10
   * Address: 0x50
   *******************************************************************/
   pRegister = createRegister(pSection, "dstlnsize", 0x10, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "lnsize", 0, 31, CfdkField::RW, 0x0, 0x7fffffff, 0x7fffffff)); // dstlnsize(30:0)

   /******************************************************************
   * Register: //USER/dstnbline(63:0)
   * Offset: 0x18
   * Address: 0x58
   *******************************************************************/
   pRegister = createRegister(pSection, "dstnbline", 0x18, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "nbline", 0, 31, CfdkField::RW, 0x0, 0x7fffffff, 0x7fffffff)); // dstnbline(30:0)

   /******************************************************************
   * Register: //USER/DSTFSTART1(63:0)
   * Offset: 0x20
   * Address: 0x60
   *******************************************************************/
   pRegister = createRegister(pSection, "DSTFSTART1", 0x20, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "FSTART", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DSTFSTART1(31:0)

   /******************************************************************
   * Register: //USER/DSTFSTART2(63:0)
   * Offset: 0x28
   * Address: 0x68
   *******************************************************************/
   pRegister = createRegister(pSection, "DSTFSTART2", 0x28, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "FSTART", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DSTFSTART2(31:0)

   /******************************************************************
   * Register: //USER/DSTFSTART3(63:0)
   * Offset: 0x30
   * Address: 0x70
   *******************************************************************/
   pRegister = createRegister(pSection, "DSTFSTART3", 0x30, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "FSTART", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DSTFSTART3(31:0)

   /******************************************************************
   * Register: //USER/DSTCTRL(63:0)
   * Offset: 0x38
   * Address: 0x78
   *******************************************************************/
   pRegister = createRegister(pSection, "DSTCTRL", 0x38, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "BUFCLR", 7, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // DSTCTRL(7)
   pRegister->addField(createField(pRegister, "DTE3", 6, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // DSTCTRL(6)
   pRegister->addField(createField(pRegister, "DTE2", 5, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // DSTCTRL(5)
   pRegister->addField(createField(pRegister, "DTE1", 4, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // DSTCTRL(4)
   pRegister->addField(createField(pRegister, "DTE0", 3, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // DSTCTRL(3)
   pRegister->addField(createField(pRegister, "BITWDTH", 2, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // DSTCTRL(2)
   pRegister->addField(createField(pRegister, "NBCONTX", 0, 2, CfdkField::RW, 0x0, 0x3, 0x3)); // DSTCTRL(1:0)

   /******************************************************************
   * Register: //USER/DSTCLRPTRN(63:0)
   * Offset: 0x40
   * Address: 0x80
   *******************************************************************/
   pRegister = createRegister(pSection, "DSTCLRPTRN", 0x40, 8, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "CLRPTRN", 0, 32, CfdkField::RW, 0x0, 0xffffffff, 0xffffffff)); // DSTCLRPTRN(31:0)


}


