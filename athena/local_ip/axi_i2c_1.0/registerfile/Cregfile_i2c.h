/*****************************************************************************
** File                : Cregfile_i2c.h
** Project             : FDK
** Module              : regfile_i2c
** Created on          : 2020/08/06 14:21:42
** Created by          : imaval
** FDK IDE Version     : 4.7.0_beta4
** Build ID            : I20191220-1537
** Register file CRC32 : 0x8865ADCE
**
**  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#ifndef CREGFILE_I2C_H
#define CREGFILE_I2C_H

#include "StandardTypes.h"
#include "CfdkRegisterFile.h"
#include "CfdkSection.h"
#include "CfdkExternal.h"
#include "CfdkRegister.h"

class Cregfile_i2c : public CfdkRegisterFile
{
   public:
	Cregfile_i2c();

};

#endif //CREGFILE_I2C_H
