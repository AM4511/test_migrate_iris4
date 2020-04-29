/*****************************************************************************
** File                : Cregfile_i2c.cpp
** Project             : FDK
** Module              : regfile_i2c
** Created on          : 2020/03/19 13:08:52
** Created by          : jmansill
** FDK IDE Version     : 4.7.0_beta3
** Build ID            : I20191219-1127
** Register file CRC32 : 0x5A5B9037
**
**  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#include "Cregfile_i2c.h"

Cregfile_i2c::Cregfile_i2c() : CfdkRegisterFile("regfile_i2c", 9, 32, true)
{
   CfdkSection *pSection;
   CfdkRegister *pRegister;

   /******************************************************************
   * Section: //I2C
   * Offset: 0x0
   *******************************************************************/
   pSection = createSection(this, "I2C", 0x0);
   this->addSection(pSection);

   /******************************************************************
   * Register: //I2C/I2C_ID(31:0)
   * Offset: 0x0
   * Address: 0x0
   *******************************************************************/
   pRegister = createRegister(pSection, "I2C_ID", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "CLOCK_STRETCHING", 17, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_ID(17)
   pRegister->addField(createField(pRegister, "NI_ACCESS", 16, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_ID(16)
   pRegister->addField(createField(pRegister, "ID", 0, 12, CfdkField::STATIC, 0x12c, 0x0, 0xfff)); // I2C_ID(11:0)

   /******************************************************************
   * Register: //I2C/I2C_CTRL0(31:0)
   * Offset: 0x8
   * Address: 0x8
   *******************************************************************/
   pRegister = createRegister(pSection, "I2C_CTRL0", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "I2C_INDEX", 24, 8, CfdkField::RW, 0x0, 0xff, 0xff)); // I2C_CTRL0(31:24)
   pRegister->addField(createField(pRegister, "NI_ACC", 23, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // I2C_CTRL0(23)
   pRegister->addField(createField(pRegister, "BUS_SEL", 17, 2, CfdkField::STATIC, 0x0, 0x0, 0x3)); // I2C_CTRL0(18:17)
   pRegister->addField(createField(pRegister, "TRIGGER", 16, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // I2C_CTRL0(16)
   pRegister->addField(createField(pRegister, "I2C_DATA_READ", 8, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // I2C_CTRL0(15:8)
   pRegister->addField(createField(pRegister, "I2C_DATA_WRITE", 0, 8, CfdkField::RW, 0x0, 0xff, 0xff)); // I2C_CTRL0(7:0)

   /******************************************************************
   * Register: //I2C/I2C_CTRL1(31:0)
   * Offset: 0x10
   * Address: 0x10
   *******************************************************************/
   pRegister = createRegister(pSection, "I2C_CTRL1", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "I2C_ERROR", 28, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_CTRL1(28)
   pRegister->addField(createField(pRegister, "BUSY", 27, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_CTRL1(27)
   pRegister->addField(createField(pRegister, "WRITING", 26, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_CTRL1(26)
   pRegister->addField(createField(pRegister, "READING", 25, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // I2C_CTRL1(25)
   pRegister->addField(createField(pRegister, "I2C_DEVICE_ID", 1, 7, CfdkField::RW, 0x44, 0x7f, 0x7f)); // I2C_CTRL1(7:1)
   pRegister->addField(createField(pRegister, "I2C_RW", 0, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // I2C_CTRL1(0)


}

