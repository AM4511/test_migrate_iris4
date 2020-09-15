/*****************************************************************************
** File                : Cregfile_pcie2AxiMaster.h
** Project             : FDK
** Module              : regfile_pcie2AxiMaster
** Created on          : 2020/09/14 14:50:04
** Created by          : amarchan
** FDK IDE Version     : 4.7.0_beta4
** Build ID            : I20191220-1537
** Register file CRC32 : 0x9CA38D67
**
**  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
#ifndef CREGFILE_PCIE2AXIMASTER_H
#define CREGFILE_PCIE2AXIMASTER_H

#include "StandardTypes.h"
#include "CfdkRegisterFile.h"
#include "CfdkSection.h"
#include "CfdkExternal.h"
#include "CfdkRegister.h"

class Cregfile_pcie2AxiMaster : public CfdkRegisterFile
{
   public:
	Cregfile_pcie2AxiMaster();

};

#endif //CREGFILE_PCIE2AXIMASTER_H
