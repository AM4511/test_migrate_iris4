/*****************************************************************************
** File                : Cregfile_i2c.h
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
