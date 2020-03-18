/*****************************************************************************
** File                : Cregfile_xgs_ctrl.cpp
** Project             : FDK
** Module              : regfile_xgs_ctrl
** Created on          : 2020/03/18 14:41:24
** Created by          : jmansill
** FDK IDE Version     : 4.7.0_beta3
** Build ID            : I20191219-1127
** Register file CRC32 : 0xD7056496
**
**  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#include "Cregfile_xgs_ctrl.h"

Cregfile_xgs_ctrl::Cregfile_xgs_ctrl() : CfdkRegisterFile("regfile_xgs_ctrl", 9, 32, true)
{
   CfdkSection *pSection;
   CfdkRegister *pRegister;

   /******************************************************************
   * Section: //SYSTEM
   * Offset: 0x0
   *******************************************************************/
   pSection = createSection(this, "SYSTEM", 0x0);
   this->addSection(pSection);

   /******************************************************************
   * Register: //SYSTEM/ID(31:0)
   * Offset: 0x0
   * Address: 0x0
   *******************************************************************/
   pRegister = createRegister(pSection, "ID", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "StaticID", 0, 32, CfdkField::RO, 0xcafe0ccd, 0x0, 0xffffffff)); // ID(31:0)

   /******************************************************************
   * Register: //SYSTEM/ACQ_CAP(31:0)
   * Offset: 0x30
   * Address: 0x30
   *******************************************************************/
   pRegister = createRegister(pSection, "ACQ_CAP", 0x30, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "DPC", 15, 1, CfdkField::STATIC, 0x1, 0x0, 0x1)); // ACQ_CAP(15)
   pRegister->addField(createField(pRegister, "EXP_FOT", 14, 1, CfdkField::STATIC, 0x1, 0x0, 0x1)); // ACQ_CAP(14)
   pRegister->addField(createField(pRegister, "FPN_73", 13, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // ACQ_CAP(13)
   pRegister->addField(createField(pRegister, "COLOR", 12, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // ACQ_CAP(12)
   pRegister->addField(createField(pRegister, "CH_LVDS", 8, 4, CfdkField::RO, 0x0, 0x0, 0xf)); // ACQ_CAP(11:8)
   pRegister->addField(createField(pRegister, "LUT_WIDTH", 4, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // ACQ_CAP(4)
   pRegister->addField(createField(pRegister, "LUT_PALETTE", 0, 2, CfdkField::RO, 0x0, 0x0, 0x3)); // ACQ_CAP(1:0)


   /******************************************************************
   * Section: //ACQ
   * Offset: 0x100
   *******************************************************************/
   pSection = createSection(this, "ACQ", 0x100);
   this->addSection(pSection);

   /******************************************************************
   * Register: //ACQ/GRAB_CTRL(31:0)
   * Offset: 0x0
   * Address: 0x100
   *******************************************************************/
   pRegister = createRegister(pSection, "GRAB_CTRL", 0x0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "RESET_GRAB", 31, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // GRAB_CTRL(31)
   pRegister->addField(createField(pRegister, "GRAB_ROI2_EN", 29, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // GRAB_CTRL(29)
   pRegister->addField(createField(pRegister, "ABORT_GRAB", 28, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // GRAB_CTRL(28)
   pRegister->addField(createField(pRegister, "TRIGGER_OVERLAP_BUFFn", 16, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // GRAB_CTRL(16)
   pRegister->addField(createField(pRegister, "TRIGGER_OVERLAP", 15, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // GRAB_CTRL(15)
   pRegister->addField(createField(pRegister, "TRIGGER_ACT", 12, 3, CfdkField::RW, 0x0, 0x7, 0x7)); // GRAB_CTRL(14:12)
   pRegister->addField(createField(pRegister, "TRIGGER_SRC", 8, 3, CfdkField::RW, 0x0, 0x7, 0x7)); // GRAB_CTRL(10:8)
   pRegister->addField(createField(pRegister, "GRAB_SS", 4, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // GRAB_CTRL(4)
   pRegister->addField(createField(pRegister, "BUFFER_ID", 1, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // GRAB_CTRL(1)
   pRegister->addField(createField(pRegister, "GRAB_CMD", 0, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // GRAB_CTRL(0)

   /******************************************************************
   * Register: //ACQ/GRAB_STAT(31:0)
   * Offset: 0x8
   * Address: 0x108
   *******************************************************************/
   pRegister = createRegister(pSection, "GRAB_STAT", 0x8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "GRAB_CMD_DONE", 31, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(31)
   pRegister->addField(createField(pRegister, "ABORT_PET", 30, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(30)
   pRegister->addField(createField(pRegister, "ABORT_DELAI", 29, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(29)
   pRegister->addField(createField(pRegister, "ABORT_DONE", 28, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(28)
   pRegister->addField(createField(pRegister, "TRIGGER_RDY", 24, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(24)
   pRegister->addField(createField(pRegister, "ABORT_MNGR_STAT", 20, 3, CfdkField::RO, 0x0, 0x0, 0x7)); // GRAB_STAT(22:20)
   pRegister->addField(createField(pRegister, "TRIG_MNGR_STAT", 16, 4, CfdkField::RO, 0x0, 0x0, 0xf)); // GRAB_STAT(19:16)
   pRegister->addField(createField(pRegister, "TIMER_MNGR_STAT", 12, 3, CfdkField::RO, 0x0, 0x0, 0x7)); // GRAB_STAT(14:12)
   pRegister->addField(createField(pRegister, "GRAB_MNGR_STAT", 8, 4, CfdkField::RO, 0x0, 0x0, 0xf)); // GRAB_STAT(11:8)
   pRegister->addField(createField(pRegister, "GRAB_FOT", 6, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(6)
   pRegister->addField(createField(pRegister, "GRAB_READOUT", 5, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(5)
   pRegister->addField(createField(pRegister, "GRAB_EXPOSURE", 4, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(4)
   pRegister->addField(createField(pRegister, "GRAB_PENDING", 2, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(2)
   pRegister->addField(createField(pRegister, "GRAB_ACTIVE", 1, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(1)
   pRegister->addField(createField(pRegister, "GRAB_IDLE", 0, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // GRAB_STAT(0)

   /******************************************************************
   * Register: //ACQ/READOUT_CFG1(31:0)
   * Offset: 0x10
   * Address: 0x110
   *******************************************************************/
   pRegister = createRegister(pSection, "READOUT_CFG1", 0x10, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "GRAB_REVX_OVER_RST", 30, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // READOUT_CFG1(30)
   pRegister->addField(createField(pRegister, "GRAB_REVX_OVER", 29, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // READOUT_CFG1(29)
   pRegister->addField(createField(pRegister, "GRAB_REVX", 28, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // READOUT_CFG1(28)
   pRegister->addField(createField(pRegister, "ROT_LENGTH", 16, 10, CfdkField::STATIC, 0x0, 0x0, 0x3ff)); // READOUT_CFG1(25:16)
   pRegister->addField(createField(pRegister, "FOT_LENGTH", 0, 16, CfdkField::STATIC, 0x0, 0x0, 0xffff)); // READOUT_CFG1(15:0)

   /******************************************************************
   * Register: //ACQ/READOUT_CFG2(31:0)
   * Offset: 0x18
   * Address: 0x118
   *******************************************************************/
   pRegister = createRegister(pSection, "READOUT_CFG2", 0x18, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "READOUT_LENGTH", 0, 29, CfdkField::RO, 0x0, 0x0, 0x1fffffff)); // READOUT_CFG2(28:0)

   /******************************************************************
   * Register: //ACQ/READOUT_CFG3(31:0)
   * Offset: 0x20
   * Address: 0x120
   *******************************************************************/
   pRegister = createRegister(pSection, "READOUT_CFG3", 0x20, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "KEEP_OUT_TRIG_ENA", 16, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // READOUT_CFG3(16)
   pRegister->addField(createField(pRegister, "LINE_TIME", 0, 16, CfdkField::RW, 0x16e, 0xffff, 0xffff)); // READOUT_CFG3(15:0)

   /******************************************************************
   * Register: //ACQ/READOUT_CFG4(31:0)
   * Offset: 0x24
   * Address: 0x124
   *******************************************************************/
   pRegister = createRegister(pSection, "READOUT_CFG4", 0x24, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "KEEP_OUT_TRIG_END", 16, 16, CfdkField::RW, 0x16d, 0xffff, 0xffff)); // READOUT_CFG4(31:16)
   pRegister->addField(createField(pRegister, "KEEP_OUT_TRIG_START", 0, 16, CfdkField::RW, 0x16e, 0xffff, 0xffff)); // READOUT_CFG4(15:0)

   /******************************************************************
   * Register: //ACQ/EXP_CTRL1(31:0)
   * Offset: 0x28
   * Address: 0x128
   *******************************************************************/
   pRegister = createRegister(pSection, "EXP_CTRL1", 0x28, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EXPOSURE_LEV_MODE", 28, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // EXP_CTRL1(28)
   pRegister->addField(createField(pRegister, "EXPOSURE_SS", 0, 28, CfdkField::RW, 0x0, 0xfffffff, 0xfffffff)); // EXP_CTRL1(27:0)

   /******************************************************************
   * Register: //ACQ/EXP_CTRL2(31:0)
   * Offset: 0x30
   * Address: 0x130
   *******************************************************************/
   pRegister = createRegister(pSection, "EXP_CTRL2", 0x30, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EXPOSURE_DS", 0, 28, CfdkField::RW, 0x0, 0xfffffff, 0xfffffff)); // EXP_CTRL2(27:0)

   /******************************************************************
   * Register: //ACQ/EXP_CTRL3(31:0)
   * Offset: 0x38
   * Address: 0x138
   *******************************************************************/
   pRegister = createRegister(pSection, "EXP_CTRL3", 0x38, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EXPOSURE_TS", 0, 28, CfdkField::RW, 0x0, 0xfffffff, 0xfffffff)); // EXP_CTRL3(27:0)

   /******************************************************************
   * Register: //ACQ/TRIGGER_DELAY(31:0)
   * Offset: 0x40
   * Address: 0x140
   *******************************************************************/
   pRegister = createRegister(pSection, "TRIGGER_DELAY", 0x40, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "TRIGGER_DELAY", 0, 28, CfdkField::RW, 0x0, 0xfffffff, 0xfffffff)); // TRIGGER_DELAY(27:0)

   /******************************************************************
   * Register: //ACQ/STROBE_CTRL1(31:0)
   * Offset: 0x48
   * Address: 0x148
   *******************************************************************/
   pRegister = createRegister(pSection, "STROBE_CTRL1", 0x48, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "STROBE_E", 31, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // STROBE_CTRL1(31)
   pRegister->addField(createField(pRegister, "STROBE_POL", 28, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // STROBE_CTRL1(28)
   pRegister->addField(createField(pRegister, "STROBE_START", 0, 28, CfdkField::RW, 0x0, 0xfffffff, 0xfffffff)); // STROBE_CTRL1(27:0)

   /******************************************************************
   * Register: //ACQ/STROBE_CTRL2(31:0)
   * Offset: 0x50
   * Address: 0x150
   *******************************************************************/
   pRegister = createRegister(pSection, "STROBE_CTRL2", 0x50, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "STROBE_MODE", 31, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // STROBE_CTRL2(31)
   pRegister->addField(createField(pRegister, "STROBE_B_EN", 29, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // STROBE_CTRL2(29)
   pRegister->addField(createField(pRegister, "STROBE_A_EN", 28, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // STROBE_CTRL2(28)
   pRegister->addField(createField(pRegister, "STROBE_END", 0, 28, CfdkField::RW, 0xfffffff, 0xfffffff, 0xfffffff)); // STROBE_CTRL2(27:0)

   /******************************************************************
   * Register: //ACQ/ACQ_SER_CTRL(31:0)
   * Offset: 0x58
   * Address: 0x158
   *******************************************************************/
   pRegister = createRegister(pSection, "ACQ_SER_CTRL", 0x58, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SER_RWn", 16, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // ACQ_SER_CTRL(16)
   pRegister->addField(createField(pRegister, "SER_CMD", 8, 2, CfdkField::RW, 0x0, 0x3, 0x3)); // ACQ_SER_CTRL(9:8)
   pRegister->addField(createField(pRegister, "SER_RF_SS", 4, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // ACQ_SER_CTRL(4)
   pRegister->addField(createField(pRegister, "SER_WF_SS", 0, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // ACQ_SER_CTRL(0)

   /******************************************************************
   * Register: //ACQ/ACQ_SER_ADDATA(31:0)
   * Offset: 0x60
   * Address: 0x160
   *******************************************************************/
   pRegister = createRegister(pSection, "ACQ_SER_ADDATA", 0x60, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SER_DAT", 16, 16, CfdkField::RW, 0x0, 0xffff, 0xffff)); // ACQ_SER_ADDATA(31:16)
   pRegister->addField(createField(pRegister, "SER_ADD", 0, 15, CfdkField::RW, 0x0, 0x7fff, 0x7fff)); // ACQ_SER_ADDATA(14:0)

   /******************************************************************
   * Register: //ACQ/ACQ_SER_STAT(31:0)
   * Offset: 0x68
   * Address: 0x168
   *******************************************************************/
   pRegister = createRegister(pSection, "ACQ_SER_STAT", 0x68, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SER_FIFO_EMPTY", 24, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // ACQ_SER_STAT(24)
   pRegister->addField(createField(pRegister, "SER_BUSY", 16, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // ACQ_SER_STAT(16)
   pRegister->addField(createField(pRegister, "SER_DAT_R", 0, 16, CfdkField::RO, 0x0, 0x0, 0xffff)); // ACQ_SER_STAT(15:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_CTRL(31:0)
   * Offset: 0x90
   * Address: 0x190
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_CTRL", 0x90, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SENSOR_REFRESH_TEMP", 24, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // SENSOR_CTRL(24)
   pRegister->addField(createField(pRegister, "SENSOR_POWERDOWN", 16, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // SENSOR_CTRL(16)
   pRegister->addField(createField(pRegister, "SENSOR_COLOR", 8, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SENSOR_CTRL(8)
   pRegister->addField(createField(pRegister, "SENSOR_REG_UPTATE", 4, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // SENSOR_CTRL(4)
   pRegister->addField(createField(pRegister, "SENSOR_RESETN", 1, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // SENSOR_CTRL(1)
   pRegister->addField(createField(pRegister, "SENSOR_POWERUP", 0, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // SENSOR_CTRL(0)

   /******************************************************************
   * Register: //ACQ/SENSOR_STAT(31:0)
   * Offset: 0x98
   * Address: 0x198
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_STAT", 0x98, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SENSOR_TEMP", 24, 8, CfdkField::RO, 0x0, 0x0, 0xff)); // SENSOR_STAT(31:24)
   pRegister->addField(createField(pRegister, "SENSOR_TEMP_VALID", 23, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(23)
   pRegister->addField(createField(pRegister, "SENSOR_POWERDOWN", 16, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(16)
   pRegister->addField(createField(pRegister, "SENSOR_RESETN", 13, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(13)
   pRegister->addField(createField(pRegister, "SENSOR_OSC_EN", 12, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(12)
   pRegister->addField(createField(pRegister, "SENSOR_VCC_PG", 8, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(8)
   pRegister->addField(createField(pRegister, "SENSOR_POWERUP_STAT", 1, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(1)
   pRegister->addField(createField(pRegister, "SENSOR_POWERUP_DONE", 0, 1, CfdkField::RO, 0x0, 0x0, 0x1)); // SENSOR_STAT(0)

   /******************************************************************
   * Register: //ACQ/SENSOR_SUBSAMPLING(31:0)
   * Offset: 0xa0
   * Address: 0x1a0
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_SUBSAMPLING", 0xa0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved1", 4, 12, CfdkField::STATIC, 0x0, 0x0, 0xfff)); // SENSOR_SUBSAMPLING(15:4)
   pRegister->addField(createField(pRegister, "ACTIVE_SUBSAMPLING_Y", 3, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SENSOR_SUBSAMPLING(3)
   pRegister->addField(createField(pRegister, "reserved0", 2, 1, CfdkField::STATIC, 0x0, 0x0, 0x1)); // SENSOR_SUBSAMPLING(2)
   pRegister->addField(createField(pRegister, "M_SUBSAMPLING_Y", 1, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SENSOR_SUBSAMPLING(1)
   pRegister->addField(createField(pRegister, "SUBSAMPLING_X", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // SENSOR_SUBSAMPLING(0)

   /******************************************************************
   * Register: //ACQ/SENSOR_GAIN_ANA(31:0)
   * Offset: 0xa4
   * Address: 0x1a4
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_GAIN_ANA", 0xa4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved1", 11, 5, CfdkField::STATIC, 0x0, 0x0, 0x1f)); // SENSOR_GAIN_ANA(15:11)
   pRegister->addField(createField(pRegister, "ANALOG_GAIN", 8, 3, CfdkField::RW, 0x1, 0x7, 0x7)); // SENSOR_GAIN_ANA(10:8)
   pRegister->addField(createField(pRegister, "reserved0", 0, 8, CfdkField::STATIC, 0x0, 0x0, 0xff)); // SENSOR_GAIN_ANA(7:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_ROI_Y_START(31:0)
   * Offset: 0xa8
   * Address: 0x1a8
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_ROI_Y_START", 0xa8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved", 10, 6, CfdkField::STATIC, 0x0, 0x0, 0x3f)); // SENSOR_ROI_Y_START(15:10)
   pRegister->addField(createField(pRegister, "Y_START", 0, 10, CfdkField::RW, 0x0, 0x3ff, 0x3ff)); // SENSOR_ROI_Y_START(9:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_ROI_Y_SIZE(31:0)
   * Offset: 0xac
   * Address: 0x1ac
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_ROI_Y_SIZE", 0xac, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved", 10, 6, CfdkField::STATIC, 0x0, 0x0, 0x3f)); // SENSOR_ROI_Y_SIZE(15:10)
   pRegister->addField(createField(pRegister, "Y_SIZE", 0, 10, CfdkField::RW, 0x302, 0x3ff, 0x3ff)); // SENSOR_ROI_Y_SIZE(9:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_ROI2_Y_START(31:0)
   * Offset: 0xb0
   * Address: 0x1b0
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_ROI2_Y_START", 0xb0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved", 10, 6, CfdkField::STATIC, 0x0, 0x0, 0x3f)); // SENSOR_ROI2_Y_START(15:10)
   pRegister->addField(createField(pRegister, "Y_START", 0, 10, CfdkField::RW, 0x0, 0x3ff, 0x3ff)); // SENSOR_ROI2_Y_START(9:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_ROI2_Y_SIZE(31:0)
   * Offset: 0xb4
   * Address: 0x1b4
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_ROI2_Y_SIZE", 0xb4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "reserved", 10, 6, CfdkField::STATIC, 0x0, 0x0, 0x3f)); // SENSOR_ROI2_Y_SIZE(15:10)
   pRegister->addField(createField(pRegister, "Y_SIZE", 0, 10, CfdkField::RW, 0x302, 0x3ff, 0x3ff)); // SENSOR_ROI2_Y_SIZE(9:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_M_LINES(31:0)
   * Offset: 0xd8
   * Address: 0x1d8
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_M_LINES", 0xd8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "M_SUPPRESSED", 10, 5, CfdkField::RW, 0x0, 0x1f, 0x1f)); // SENSOR_M_LINES(14:10)
   pRegister->addField(createField(pRegister, "M_LINES", 0, 10, CfdkField::RW, 0x8, 0x3ff, 0x3ff)); // SENSOR_M_LINES(9:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_F_LINES(31:0)
   * Offset: 0xdc
   * Address: 0x1dc
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_F_LINES", 0xdc, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "F_SUPPRESSED", 10, 5, CfdkField::RW, 0x0, 0x1f, 0x1f)); // SENSOR_F_LINES(14:10)
   pRegister->addField(createField(pRegister, "F_LINES", 0, 10, CfdkField::RW, 0x8, 0x3ff, 0x3ff)); // SENSOR_F_LINES(9:0)

   /******************************************************************
   * Register: //ACQ/DEBUG_PINS(31:0)
   * Offset: 0xe0
   * Address: 0x1e0
   *******************************************************************/
   pRegister = createRegister(pSection, "DEBUG_PINS", 0xe0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "Debug3_sel", 24, 5, CfdkField::RW, 0x1f, 0x1f, 0x1f)); // DEBUG_PINS(28:24)
   pRegister->addField(createField(pRegister, "Debug2_sel", 16, 5, CfdkField::RW, 0x1f, 0x1f, 0x1f)); // DEBUG_PINS(20:16)
   pRegister->addField(createField(pRegister, "Debug1_sel", 8, 5, CfdkField::RW, 0x1f, 0x1f, 0x1f)); // DEBUG_PINS(12:8)
   pRegister->addField(createField(pRegister, "Debug0_sel", 0, 5, CfdkField::RW, 0x1f, 0x1f, 0x1f)); // DEBUG_PINS(4:0)

   /******************************************************************
   * Register: //ACQ/TRIGGER_MISSED(31:0)
   * Offset: 0xe8
   * Address: 0x1e8
   *******************************************************************/
   pRegister = createRegister(pSection, "TRIGGER_MISSED", 0xe8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "TRIGGER_MISSED_RST", 28, 1, CfdkField::WO, 0x0, 0x1, 0x0)); // TRIGGER_MISSED(28)
   pRegister->addField(createField(pRegister, "TRIGGER_MISSED_CNTR", 0, 16, CfdkField::RO, 0x0, 0x0, 0xffff)); // TRIGGER_MISSED(15:0)

   /******************************************************************
   * Register: //ACQ/SENSOR_FPS(31:0)
   * Offset: 0xf0
   * Address: 0x1f0
   *******************************************************************/
   pRegister = createRegister(pSection, "SENSOR_FPS", 0xf0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SENSOR_FPS", 0, 16, CfdkField::RO, 0x0, 0x0, 0xffff)); // SENSOR_FPS(15:0)

   /******************************************************************
   * Register: //ACQ/DEBUG(31:0)
   * Offset: 0x1a0
   * Address: 0x2a0
   *******************************************************************/
   pRegister = createRegister(pSection, "DEBUG", 0x1a0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "DEBUG_RST_CNTR", 28, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // DEBUG(28)
   pRegister->addField(createField(pRegister, "TEST_MODE_PIX_START", 16, 10, CfdkField::RW, 0x0, 0x3ff, 0x3ff)); // DEBUG(25:16)
   pRegister->addField(createField(pRegister, "TEST_MOVE", 9, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // DEBUG(9)
   pRegister->addField(createField(pRegister, "TEST_MODE", 8, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // DEBUG(8)
   pRegister->addField(createField(pRegister, "LED_STAT_CLHS", 6, 2, CfdkField::RO, 0x0, 0x0, 0x3)); // DEBUG(7:6)
   pRegister->addField(createField(pRegister, "LED_STAT_CTRL", 4, 2, CfdkField::RO, 0x0, 0x0, 0x3)); // DEBUG(5:4)
   pRegister->addField(createField(pRegister, "LED_TEST_COLOR", 1, 2, CfdkField::RW, 0x0, 0x3, 0x3)); // DEBUG(2:1)
   pRegister->addField(createField(pRegister, "LED_TEST", 0, 1, CfdkField::RW, 0x0, 0x1, 0x1)); // DEBUG(0)

   /******************************************************************
   * Register: //ACQ/DEBUG_CNTR1(31:0)
   * Offset: 0x1a8
   * Address: 0x2a8
   *******************************************************************/
   pRegister = createRegister(pSection, "DEBUG_CNTR1", 0x1a8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EOF_CNTR", 0, 32, CfdkField::RO, 0x0, 0x0, 0xffffffff)); // DEBUG_CNTR1(31:0)

   /******************************************************************
   * Register: //ACQ/DEBUG_CNTR2(31:0)
   * Offset: 0x1b0
   * Address: 0x2b0
   *******************************************************************/
   pRegister = createRegister(pSection, "DEBUG_CNTR2", 0x1b0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EOL_CNTR", 0, 12, CfdkField::RO, 0x0, 0x0, 0xfff)); // DEBUG_CNTR2(11:0)

   /******************************************************************
   * Register: //ACQ/DEBUG_CNTR3(31:0)
   * Offset: 0x1b4
   * Address: 0x2b4
   *******************************************************************/
   pRegister = createRegister(pSection, "DEBUG_CNTR3", 0x1b4, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "SENSOR_FRAME_DURATION", 0, 28, CfdkField::RO, 0x0, 0x0, 0xfffffff)); // DEBUG_CNTR3(27:0)

   /******************************************************************
   * Register: //ACQ/EXP_FOT(31:0)
   * Offset: 0x1b8
   * Address: 0x2b8
   *******************************************************************/
   pRegister = createRegister(pSection, "EXP_FOT", 0x1b8, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "EXP_FOT", 16, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // EXP_FOT(16)
   pRegister->addField(createField(pRegister, "EXP_FOT_TIME", 0, 12, CfdkField::RW, 0x9ee, 0xfff, 0xfff)); // EXP_FOT(11:0)

   /******************************************************************
   * Register: //ACQ/ACQ_SFNC(31:0)
   * Offset: 0x1c0
   * Address: 0x2c0
   *******************************************************************/
   pRegister = createRegister(pSection, "ACQ_SFNC", 0x1c0, 4, true);
   pSection->addRegister(pRegister);

   //Fields:
   pRegister->addField(createField(pRegister, "RELOAD_GRAB_PARAMS", 0, 1, CfdkField::RW, 0x1, 0x1, 0x1)); // ACQ_SFNC(0)


}

