/********************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: xadc_wizard
**
**  DESCRIPTION: C Language Register file description of the xadc_wizard module
**               for the Matrox Imaging MtxEdit tool
**
**  AUTOMATICALLY GENERATED FILE DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.6.0_beta1
**  Build ID: I20160217-1125
**
**  COPYRIGHT (c) 2015 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
********************************************************************************/
#include "editeur.h"


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : ssr
* Register path    : /xadc_wizard/local_register/ssr
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_SSR_
#define _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_SSR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_local_register_ssr[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : ssr
* Description      : Software Reset Register (SSR)
* Register path    : /xadc_wizard/local_register/ssr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_SSR_
#define _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_SSR_

static const ST_DESCR_REG reg_descr_xadc_wizard_local_register_ssr =
{
   ED_IO_MEM,
   ED_RW,
   "ssr",
   "Software Reset Register (SSR)",
   0xffffffff,
   1,
   field_list_xadc_wizard_local_register_ssr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : sr
* Register path    : /xadc_wizard/local_register/sr
* Number of fields : 7
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_SR_
#define _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_SR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_local_register_sr[7] =
{
   {"channel", "Channel selection outputs", 5, ED_RO, 0},
   {"eoc", "End of Conversion signal", 1, ED_RO, 0},
   {"eos", "End of Sequence", 1, ED_RO, 0},
   {"busy", "ADC busy signal", 1, ED_RO, 0},
   {"jtag_locked", "JTAG locked", 1, ED_RO, 0},
   {"jtag_modified", "JTAG modified", 1, ED_RO, 0},
   {"jtag_busy", "JTAG busy", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : sr
* Description      : Status Register (SR)
* Register path    : /xadc_wizard/local_register/sr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_SR_
#define _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_SR_

static const ST_DESCR_REG reg_descr_xadc_wizard_local_register_sr =
{
   ED_IO_MEM,
   ED_RW,
   "sr",
   "Status Register (SR)",
   0x7ff,
   7,
   field_list_xadc_wizard_local_register_sr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : aosr
* Register path    : /xadc_wizard/local_register/aosr
* Number of fields : 9
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_AOSR_
#define _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_AOSR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_local_register_aosr[9] =
{
   {"over_temperature", "XADC Over-Temperature Alarm Status", 1, ED_RO, 0},
   {"alarm_0", "XADC Temperature-Sensor Status", 1, ED_RO, 0},
   {"alarm_1", "XADC VCCINT-Sensor Status", 1, ED_RO, 0},
   {"alarm_2", "XADC VCCAUX-Sensor Status", 1, ED_RO, 0},
   {"alarm_3", "XADC VBRAM-Sensor Status", 1, ED_RO, 0},
   {"alarm_4", "XADC VCCPINT-Sensor Status", 1, ED_RO, 0},
   {"alarm_5", "XADC VCCPAUX-Sensor Status", 1, ED_RO, 0},
   {"alarm_6", "XADC VCCDDRO-Sensor Status", 1, ED_RO, 0},
   {"alarm_7", "Logical ORing of ALARM bits 0 to 7", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : aosr
* Description      : Alarm Output Status Register (AOSR)
* Register path    : /xadc_wizard/local_register/aosr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_AOSR_
#define _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_AOSR_

static const ST_DESCR_REG reg_descr_xadc_wizard_local_register_aosr =
{
   ED_IO_MEM,
   ED_RW,
   "aosr",
   "Alarm Output Status Register (AOSR)",
   0x1ff,
   9,
   field_list_xadc_wizard_local_register_aosr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : convstr
* Register path    : /xadc_wizard/local_register/convstr
* Number of fields : 3
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_
#define _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_local_register_convstr[3] =
{
   {"convst", "Conversion Start", 1, ED_RW, 0},
   {"temp_bus_update", "Temperature bus update", 1, ED_RW, 0},
   {"temp_rd_wait_cycle", "Wait cycle for temperature update", 16, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : convstr
* Description      : CONVST Register (CONVSTR)
* Register path    : /xadc_wizard/local_register/convstr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_
#define _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_CONVSTR_

static const ST_DESCR_REG reg_descr_xadc_wizard_local_register_convstr =
{
   ED_IO_MEM,
   ED_RW,
   "convstr",
   "CONVST Register (CONVSTR)",
   0x3ffff,
   3,
   field_list_xadc_wizard_local_register_convstr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : xadc_reset
* Register path    : /xadc_wizard/local_register/xadc_reset
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_
#define _FIELD_LIST_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_local_register_xadc_reset[1] =
{
   {"reset", "null", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : xadc_reset
* Description      : XADC Hard Macro Reset Register
* Register path    : /xadc_wizard/local_register/xadc_reset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_
#define _REG_DESCR_XADC_WIZARD_LOCAL_REGISTER_XADC_RESET_

static const ST_DESCR_REG reg_descr_xadc_wizard_local_register_xadc_reset =
{
   ED_IO_MEM,
   ED_RW,
   "xadc_reset",
   "XADC Hard Macro Reset Register",
   0x1,
   1,
   field_list_xadc_wizard_local_register_xadc_reset,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : local_register
* Section path       : /xadc_wizard/local_register
* Section offset     : 0x0
* Number of Register : 5
********************************************************************************/
static const ST_LISTE_REG reg_list_xadc_wizard_local_register[5] =
{
   {0x0, &reg_descr_xadc_wizard_local_register_ssr},
   {0x4, &reg_descr_xadc_wizard_local_register_sr},
   {0x8, &reg_descr_xadc_wizard_local_register_aosr},
   {0xc, &reg_descr_xadc_wizard_local_register_convstr},
   {0x10, &reg_descr_xadc_wizard_local_register_xadc_reset}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : local_register
* Description      : XADC Wizard Local Register Grouping
* Section path    : /xadc_wizard/local_register
********************************************************************************/
static const ST_GROUPE_REG section_descr_xadc_wizard_local_register[1] =
{
   {"local_register", 5, reg_list_xadc_wizard_local_register}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : global_interrupt
* Register path    : /xadc_wizard/interrupt_controller/global_interrupt
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_
#define _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_interrupt_controller_global_interrupt[2] =
{
   {"rsvd0", "reserved location", 31, ED_RW, 0},
   {"enable", "Global Interrupt Enable", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : global_interrupt
* Description      : Global Interrupt Enable Register (GIER)
* Register path    : /xadc_wizard/interrupt_controller/global_interrupt
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_
#define _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_GLOBAL_INTERRUPT_

static const ST_DESCR_REG reg_descr_xadc_wizard_interrupt_controller_global_interrupt =
{
   ED_IO_MEM,
   ED_RW,
   "global_interrupt",
   "Global Interrupt Enable Register (GIER)",
   0x80000000,
   2,
   field_list_xadc_wizard_interrupt_controller_global_interrupt,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : interrupt_status
* Register path    : /xadc_wizard/interrupt_controller/interrupt_status
* Number of fields : 14
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_
#define _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_interrupt_controller_interrupt_status[14] =
{
   {"over_temperature", "Over-Temperature Alarm Interrupt", 1, ED_RW, 0},
   {"alarm_0", "XADC Temperature-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_1", "XADC VCCINT-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_3", "XADC VBRAM-Sensor Interrupt", 1, ED_RW, 0},
   {"eos", "End of Sequence Interrupt", 1, ED_RW, 0},
   {"eoc", "End of Sequence Interrupt", 1, ED_RW, 0},
   {"jtag_locked", "JTAGLOCKED Interrupt", 1, ED_RW, 0},
   {"jtag_modified", "JTAGMODIFIED Interrupt", 1, ED_RW, 0},
   {"over_temperature_deactive", "Over-Temperature Deactive Interrupt. ", 1, ED_RW, 0},
   {"alarm_0_deactive", "ALM[0] Deactive Interrupt. ", 1, ED_RW, 0},
   {"alarm_2", "XADC VCCAUX-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_4", "XADC VCCPINT-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_5", "XADC VCCPAUX-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_6", "XADC VCCDDRO-Sensor Interrupt", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : interrupt_status
* Description      : IP Interrupt Status Register (IPISR)
* Register path    : /xadc_wizard/interrupt_controller/interrupt_status
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_
#define _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_STATUS_

static const ST_DESCR_REG reg_descr_xadc_wizard_interrupt_controller_interrupt_status =
{
   ED_IO_MEM,
   ED_RW,
   "interrupt_status",
   "IP Interrupt Status Register (IPISR)",
   0x3fff,
   14,
   field_list_xadc_wizard_interrupt_controller_interrupt_status,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : interrupt_enable
* Register path    : /xadc_wizard/interrupt_controller/interrupt_enable
* Number of fields : 14
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_
#define _FIELD_LIST_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_interrupt_controller_interrupt_enable[14] =
{
   {"over_temperature", "Over-Temperature Alarm Interrupt", 1, ED_RW, 0},
   {"alarm_0", "XADC Temperature-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_1", "XADC VCCINT-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_3", "XADC VBRAM-Sensor Interrupt", 1, ED_RW, 0},
   {"eos", "End of Sequence Interrupt", 1, ED_RW, 0},
   {"eoc", "End of Sequence Interrupt", 1, ED_RW, 0},
   {"jtag_locked", "JTAGLOCKED Interrupt", 1, ED_RW, 0},
   {"jtag_modified", "JTAGMODIFIED Interrupt", 1, ED_RW, 0},
   {"over_temperature_deactive", "Over-Temperature Deactive Interrupt. ", 1, ED_RW, 0},
   {"alarm_0_deactive", "ALM[0] Deactive Interrupt. ", 1, ED_RW, 0},
   {"alarm_2", "XADC VCCAUX-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_4", "XADC VCCPINT-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_5", "XADC VCCPAUX-Sensor Interrupt", 1, ED_RW, 0},
   {"alarm_6", "XADC VCCDDRO-Sensor Interrupt", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : interrupt_enable
* Description      : IP Interrupt Enable Register (IPIER)
* Register path    : /xadc_wizard/interrupt_controller/interrupt_enable
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_
#define _REG_DESCR_XADC_WIZARD_INTERRUPT_CONTROLLER_INTERRUPT_ENABLE_

static const ST_DESCR_REG reg_descr_xadc_wizard_interrupt_controller_interrupt_enable =
{
   ED_IO_MEM,
   ED_RW,
   "interrupt_enable",
   "IP Interrupt Enable Register (IPIER)",
   0x3fff,
   14,
   field_list_xadc_wizard_interrupt_controller_interrupt_enable,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : interrupt_controller
* Section path       : /xadc_wizard/interrupt_controller
* Section offset     : 0x5c
* Number of Register : 3
********************************************************************************/
static const ST_LISTE_REG reg_list_xadc_wizard_interrupt_controller[3] =
{
   {0x5c, &reg_descr_xadc_wizard_interrupt_controller_global_interrupt},
   {0x60, &reg_descr_xadc_wizard_interrupt_controller_interrupt_status},
   {0x68, &reg_descr_xadc_wizard_interrupt_controller_interrupt_enable}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : interrupt_controller
* Description      : XADC Wizard Interrupt Controller
* Section path    : /xadc_wizard/interrupt_controller
********************************************************************************/
static const ST_GROUPE_REG section_descr_xadc_wizard_interrupt_controller[1] =
{
   {"interrupt_controller", 3, reg_list_xadc_wizard_interrupt_controller}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : temperature
* Register path    : /xadc_wizard/xadc_hard_macro/temperature
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_temperature[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Temperature value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : temperature
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/temperature
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_TEMPERATURE_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_temperature =
{
   ED_IO_MEM,
   ED_RW,
   "temperature",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_temperature,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcc_int
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_int
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcc_int[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vccint value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcc_int
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_int
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_INT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcc_int =
{
   ED_IO_MEM,
   ED_RW,
   "vcc_int",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcc_int,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcc_aux
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_aux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcc_aux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vccaux value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcc_aux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_aux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_AUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcc_aux =
{
   ED_IO_MEM,
   ED_RW,
   "vcc_aux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcc_aux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vp_vn
* Register path    : /xadc_wizard/xadc_hard_macro/vp_vn
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vp_vn[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vp/Vn value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vp_vn
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vp_vn
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VP_VN_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vp_vn =
{
   ED_IO_MEM,
   ED_RW,
   "vp_vn",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vp_vn,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vref_p
* Register path    : /xadc_wizard/xadc_hard_macro/vref_p
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vref_p[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vrefp value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vref_p
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vref_p
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VREF_P_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vref_p =
{
   ED_IO_MEM,
   ED_RW,
   "vref_p",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vref_p,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vref_n
* Register path    : /xadc_wizard/xadc_hard_macro/vref_n
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vref_n[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vrefp value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vref_n
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vref_n
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VREF_N_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vref_n =
{
   ED_IO_MEM,
   ED_RW,
   "vref_n",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vref_n,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcc_bram
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_bram
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcc_bram[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vrefp value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcc_bram
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_bram
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_BRAM_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcc_bram =
{
   ED_IO_MEM,
   ED_RW,
   "vcc_bram",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcc_bram,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : supply_a_offset
* Register path    : /xadc_wizard/xadc_hard_macro/supply_a_offset
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_supply_a_offset[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Supply A offset value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : supply_a_offset
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/supply_a_offset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_A_OFFSET_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_supply_a_offset =
{
   ED_IO_MEM,
   ED_RW,
   "supply_a_offset",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_supply_a_offset,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : adc_a_offset
* Register path    : /xadc_wizard/xadc_hard_macro/adc_a_offset
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_adc_a_offset[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "ADC A offset value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : adc_a_offset
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/adc_a_offset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_OFFSET_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_adc_a_offset =
{
   ED_IO_MEM,
   ED_RW,
   "adc_a_offset",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_adc_a_offset,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : adc_a_gain
* Register path    : /xadc_wizard/xadc_hard_macro/adc_a_gain
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_adc_a_gain[2] =
{
   {"mag", "Gain magnitude value", 6, ED_RO, 0},
   {"sign", "Gain sign", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : adc_a_gain
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/adc_a_gain
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_A_GAIN_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_adc_a_gain =
{
   ED_IO_MEM,
   ED_RW,
   "adc_a_gain",
   "null",
   0x7f,
   2,
   field_list_xadc_wizard_xadc_hard_macro_adc_a_gain,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcc_pint
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_pint
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcc_pint[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vcc Pint value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcc_pint
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_pint
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_PINT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcc_pint =
{
   ED_IO_MEM,
   ED_RW,
   "vcc_pint",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcc_pint,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcc_paux
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_paux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcc_paux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vcc Paux value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcc_paux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcc_paux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCC_PAUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcc_paux =
{
   ED_IO_MEM,
   ED_RW,
   "vcc_paux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcc_paux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcco_ddr
* Register path    : /xadc_wizard/xadc_hard_macro/vcco_ddr
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vcco_ddr[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vcco DDR value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcco_ddr
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vcco_ddr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VCCO_DDR_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vcco_ddr =
{
   ED_IO_MEM,
   ED_RW,
   "vcco_ddr",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vcco_ddr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vaux_p_n
* Register path    : /xadc_wizard/xadc_hard_macro/vaux_p_n
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_vaux_p_n[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Vaux_P/Vaux_N value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vaux_p_n
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/vaux_p_n
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_VAUX_P_N_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n =
{
   ED_IO_MEM,
   ED_RW,
   "vaux_p_n",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_vaux_p_n,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_temperature
* Register path    : /xadc_wizard/xadc_hard_macro/max_temperature
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_temperature[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max temperature value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_temperature
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_temperature
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_TEMPERATURE_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_temperature =
{
   ED_IO_MEM,
   ED_RW,
   "max_temperature",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_temperature,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcc_int
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_int
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcc_int[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcc_int
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_int
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_INT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_int =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcc_int",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcc_int,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcc_aux
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_aux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcc_aux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcc_aux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_aux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_AUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_aux =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcc_aux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcc_aux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcc_bram
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_bram
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcc_bram[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcc_bram
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_bram
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_BRAM_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_bram =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcc_bram",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcc_bram,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_temperature
* Register path    : /xadc_wizard/xadc_hard_macro/min_temperature
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_temperature[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum  temperature value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_temperature
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_temperature
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_TEMPERATURE_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_temperature =
{
   ED_IO_MEM,
   ED_RW,
   "min_temperature",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_temperature,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_vcc_int
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_int
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_vcc_int[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_vcc_int
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_int
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_INT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_int =
{
   ED_IO_MEM,
   ED_RW,
   "min_vcc_int",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_vcc_int,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_vcc_aux
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_aux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_vcc_aux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_vcc_aux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_aux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_AUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_aux =
{
   ED_IO_MEM,
   ED_RW,
   "min_vcc_aux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_vcc_aux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_vcc_bram
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_bram
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_vcc_bram[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcc int value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_vcc_bram
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_bram
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_BRAM_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_bram =
{
   ED_IO_MEM,
   ED_RW,
   "min_vcc_bram",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_vcc_bram,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcc_pint
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_pint
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcc_pint[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcc pint value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcc_pint
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_pint
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PINT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_pint =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcc_pint",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcc_pint,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcc_paux
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_paux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcc_paux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcc paux  value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcc_paux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcc_paux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCC_PAUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_paux =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcc_paux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcc_paux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : max_vcco_ddr
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcco_ddr
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_max_vcco_ddr[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Max  Vcco DDR value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : max_vcco_ddr
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/max_vcco_ddr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAX_VCCO_DDR_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_max_vcco_ddr =
{
   ED_IO_MEM,
   ED_RW,
   "max_vcco_ddr",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_max_vcco_ddr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_vcc_pint
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_pint
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_vcc_pint[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcc pint value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_vcc_pint
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_pint
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PINT_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_pint =
{
   ED_IO_MEM,
   ED_RW,
   "min_vcc_pint",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_vcc_pint,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : min_vcc_paux
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_paux
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_min_vcc_paux[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcc paux  value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : min_vcc_paux
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/min_vcc_paux
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MIN_VCC_PAUX_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_paux =
{
   ED_IO_MEM,
   ED_RW,
   "min_vcc_paux",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_min_vcc_paux,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : main_vcco_ddr
* Register path    : /xadc_wizard/xadc_hard_macro/main_vcco_ddr
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_main_vcco_ddr[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Minimum Vcco DDR value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : main_vcco_ddr
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/main_vcco_ddr
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_MAIN_VCCO_DDR_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_main_vcco_ddr =
{
   ED_IO_MEM,
   ED_RW,
   "main_vcco_ddr",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_main_vcco_ddr,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : supply_b_offset
* Register path    : /xadc_wizard/xadc_hard_macro/supply_b_offset
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_supply_b_offset[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "Supply A offset value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : supply_b_offset
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/supply_b_offset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_SUPPLY_B_OFFSET_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_supply_b_offset =
{
   ED_IO_MEM,
   ED_RW,
   "supply_b_offset",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_supply_b_offset,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : adc_b_offset
* Register path    : /xadc_wizard/xadc_hard_macro/adc_b_offset
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_adc_b_offset[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "ADC A offset value", 12, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : adc_b_offset
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/adc_b_offset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_OFFSET_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_adc_b_offset =
{
   ED_IO_MEM,
   ED_RW,
   "adc_b_offset",
   "null",
   0xfff0,
   2,
   field_list_xadc_wizard_xadc_hard_macro_adc_b_offset,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : adc_b_gain
* Register path    : /xadc_wizard/xadc_hard_macro/adc_b_gain
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_adc_b_gain[2] =
{
   {"mag", "Gain magnitude value", 6, ED_RO, 0},
   {"sign", "Gain sign", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : adc_b_gain
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/adc_b_gain
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_ADC_B_GAIN_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_adc_b_gain =
{
   ED_IO_MEM,
   ED_RW,
   "adc_b_gain",
   "null",
   0x7f,
   2,
   field_list_xadc_wizard_xadc_hard_macro_adc_b_gain,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : flag
* Register path    : /xadc_wizard/xadc_hard_macro/flag
* Number of fields : 12
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_FLAG_
#define _FIELD_LIST_XADC_WIZARD_XADC_HARD_MACRO_FLAG_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_xadc_hard_macro_flag[12] =
{
   {"alarm_0", "Alarm 0 output", 1, ED_RO, 0},
   {"alarm_1", "Alarm 1 output", 1, ED_RO, 0},
   {"alarm_2", "Alarm 2 output", 1, ED_RO, 0},
   {"over_temperature", "Over temperature output", 1, ED_RO, 0},
   {"alarm_3", "Alarm 3 output", 1, ED_RO, 0},
   {"alarm_4", "Alarm 4 output output", 1, ED_RO, 0},
   {"alarm_5", "Alarm 5 output", 1, ED_RO, 0},
   {"alarm_6", "Alarm 6 output", 1, ED_RO, 0},
   {"rsvd0", "reserved location", 1, ED_RW, 0},
   {"ref", "ADC reference voltage", 1, ED_RO, 0},
   {"jtgr", "", 1, ED_RO, 0},
   {"jtgd", "", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : flag
* Description      : null
* Register path    : /xadc_wizard/xadc_hard_macro/flag
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_FLAG_
#define _REG_DESCR_XADC_WIZARD_XADC_HARD_MACRO_FLAG_

static const ST_DESCR_REG reg_descr_xadc_wizard_xadc_hard_macro_flag =
{
   ED_IO_MEM,
   ED_RW,
   "flag",
   "null",
   0xeff,
   12,
   field_list_xadc_wizard_xadc_hard_macro_flag,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : xadc_hard_macro
* Section path       : /xadc_wizard/xadc_hard_macro
* Section offset     : 0x200
* Number of Register : 47
********************************************************************************/
static const ST_LISTE_REG reg_list_xadc_wizard_xadc_hard_macro[47] =
{
   {0x200, &reg_descr_xadc_wizard_xadc_hard_macro_temperature},
   {0x204, &reg_descr_xadc_wizard_xadc_hard_macro_vcc_int},
   {0x208, &reg_descr_xadc_wizard_xadc_hard_macro_vcc_aux},
   {0x20c, &reg_descr_xadc_wizard_xadc_hard_macro_vp_vn},
   {0x210, &reg_descr_xadc_wizard_xadc_hard_macro_vref_p},
   {0x214, &reg_descr_xadc_wizard_xadc_hard_macro_vref_n},
   {0x218, &reg_descr_xadc_wizard_xadc_hard_macro_vcc_bram},
   {0x220, &reg_descr_xadc_wizard_xadc_hard_macro_supply_a_offset},
   {0x224, &reg_descr_xadc_wizard_xadc_hard_macro_adc_a_offset},
   {0x228, &reg_descr_xadc_wizard_xadc_hard_macro_adc_a_gain},
   {0x234, &reg_descr_xadc_wizard_xadc_hard_macro_vcc_pint},
   {0x238, &reg_descr_xadc_wizard_xadc_hard_macro_vcc_paux},
   {0x23c, &reg_descr_xadc_wizard_xadc_hard_macro_vcco_ddr},
   {0x240, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x244, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x248, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x24c, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x250, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x254, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x258, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x25c, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x260, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x264, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x268, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x26c, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x270, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x274, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x278, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x27c, &reg_descr_xadc_wizard_xadc_hard_macro_vaux_p_n},
   {0x280, &reg_descr_xadc_wizard_xadc_hard_macro_max_temperature},
   {0x284, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_int},
   {0x288, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_aux},
   {0x28c, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_bram},
   {0x290, &reg_descr_xadc_wizard_xadc_hard_macro_min_temperature},
   {0x294, &reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_int},
   {0x298, &reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_aux},
   {0x29c, &reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_bram},
   {0x2a0, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_pint},
   {0x2a4, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcc_paux},
   {0x2a8, &reg_descr_xadc_wizard_xadc_hard_macro_max_vcco_ddr},
   {0x2b0, &reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_pint},
   {0x2b4, &reg_descr_xadc_wizard_xadc_hard_macro_min_vcc_paux},
   {0x2b8, &reg_descr_xadc_wizard_xadc_hard_macro_main_vcco_ddr},
   {0x2c0, &reg_descr_xadc_wizard_xadc_hard_macro_supply_b_offset},
   {0x2c4, &reg_descr_xadc_wizard_xadc_hard_macro_adc_b_offset},
   {0x2c8, &reg_descr_xadc_wizard_xadc_hard_macro_adc_b_gain},
   {0x2d4, &reg_descr_xadc_wizard_xadc_hard_macro_flag}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : xadc_hard_macro
* Description      : XADC Wizard Hard Macro
* Section path    : /xadc_wizard/xadc_hard_macro
********************************************************************************/
static const ST_GROUPE_REG section_descr_xadc_wizard_xadc_hard_macro[1] =
{
   {"xadc_hard_macro", 47, reg_list_xadc_wizard_xadc_hard_macro}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : config_0
* Register path    : /xadc_wizard/control/config_0
* Number of fields : 9
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_0_
#define _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_0_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_control_config_0[9] =
{
   {"input_channel", "ADC input channel", 5, ED_RW, 0},
   {"rsvd0", "reserved location", 3, ED_RW, 0},
   {"acq", "null", 1, ED_RW, 0},
   {"ec", "null", 1, ED_RW, 0},
   {"bu", "null", 1, ED_RW, 0},
   {"mux", "null", 1, ED_RW, 0},
   {"avg", "Averaging", 2, ED_RW, 0},
   {"rsvd1", "reserved location", 1, ED_RW, 0},
   {"cavg", "Disable calculation averaging", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : config_0
* Description      : null
* Register path    : /xadc_wizard/control/config_0
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_0_
#define _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_0_

static const ST_DESCR_REG reg_descr_xadc_wizard_control_config_0 =
{
   ED_IO_MEM,
   ED_RW,
   "config_0",
   "null",
   0xbf1f,
   9,
   field_list_xadc_wizard_control_config_0,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : config_1
* Register path    : /xadc_wizard/control/config_1
* Number of fields : 13
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_1_
#define _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_1_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_control_config_1[13] =
{
   {"ot_disable", "Over temperature disable", 1, ED_RW, 0},
   {"alarm_0_disable", "Alarm 0 disable", 1, ED_RW, 0},
   {"alarm_1_disable", "Alarm 0 disable", 1, ED_RW, 0},
   {"alarm_2_disable", "Alarm 2 disable", 1, ED_RW, 0},
   {"cal_enable_0", "ADCs offset correction enable", 1, ED_RW, 0},
   {"cal_enable_1", "ADCs offset and gain correction enable", 1, ED_RW, 0},
   {"cal_enable_2", "Supply sensor offset correction enable", 1, ED_RW, 0},
   {"cal_enable_3", "Supply sensor offset and gain correction enable", 1, ED_RW, 0},
   {"alarm_3_disable", "Alarm 3 disable", 1, ED_RW, 0},
   {"alarm_4_disable", "Alarm 4 disable", 1, ED_RW, 0},
   {"alarm_5_disable", "Alarm 5 disable", 1, ED_RW, 0},
   {"alarm_6_disable", "Alarm 6 disable", 1, ED_RW, 0},
   {"seq", "null", 4, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : config_1
* Description      : null
* Register path    : /xadc_wizard/control/config_1
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_1_
#define _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_1_

static const ST_DESCR_REG reg_descr_xadc_wizard_control_config_1 =
{
   ED_IO_MEM,
   ED_RW,
   "config_1",
   "null",
   0xffff,
   13,
   field_list_xadc_wizard_control_config_1,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : config_2
* Register path    : /xadc_wizard/control/config_2
* Number of fields : 4
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_2_
#define _FIELD_LIST_XADC_WIZARD_CONTROL_CONFIG_2_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_control_config_2[4] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"pd", "Power down selection", 2, ED_RW, 0},
   {"rsvd1", "reserved location", 2, ED_RW, 0},
   {"cd", "Clock division selection", 8, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : config_2
* Description      : null
* Register path    : /xadc_wizard/control/config_2
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_2_
#define _REG_DESCR_XADC_WIZARD_CONTROL_CONFIG_2_

static const ST_DESCR_REG reg_descr_xadc_wizard_control_config_2 =
{
   ED_IO_MEM,
   ED_RW,
   "config_2",
   "null",
   0xff30,
   4,
   field_list_xadc_wizard_control_config_2,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : control
* Section path       : /xadc_wizard/control
* Section offset     : 0x300
* Number of Register : 3
********************************************************************************/
static const ST_LISTE_REG reg_list_xadc_wizard_control[3] =
{
   {0x300, &reg_descr_xadc_wizard_control_config_0},
   {0x304, &reg_descr_xadc_wizard_control_config_1},
   {0x308, &reg_descr_xadc_wizard_control_config_2}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : control
* Description      : XADC Control Registers
* Section path    : /xadc_wizard/control
********************************************************************************/
static const ST_GROUPE_REG section_descr_xadc_wizard_control[1] =
{
   {"control", 3, reg_list_xadc_wizard_control}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : temperature_upper
* Register path    : /xadc_wizard/alarm_tresholds/temperature_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_temperature_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : temperature_upper
* Description      : Temperature upper  [alarm 0]
* Register path    : /xadc_wizard/alarm_tresholds/temperature_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_temperature_upper =
{
   ED_IO_MEM,
   ED_RW,
   "temperature_upper",
   "Temperature upper  [alarm 0]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_temperature_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccint_upper
* Register path    : /xadc_wizard/alarm_tresholds/vccint_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccint_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccint_upper
* Description      : VCCINT upper  [alarm 1]
* Register path    : /xadc_wizard/alarm_tresholds/vccint_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccint_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vccint_upper",
   "VCCINT upper  [alarm 1]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccint_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccaux_upper
* Register path    : /xadc_wizard/alarm_tresholds/vccaux_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccaux_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccaux_upper
* Description      : VCCAUX upper [alarm 2]
* Register path    : /xadc_wizard/alarm_tresholds/vccaux_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccaux_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vccaux_upper",
   "VCCAUX upper [alarm 2]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccaux_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : ot_alarm_limit
* Register path    : /xadc_wizard/alarm_tresholds/ot_alarm_limit
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_ot_alarm_limit[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : ot_alarm_limit
* Description      : Over-temperature alarm limit
* Register path    : /xadc_wizard/alarm_tresholds/ot_alarm_limit
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_LIMIT_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_ot_alarm_limit =
{
   ED_IO_MEM,
   ED_RW,
   "ot_alarm_limit",
   "Over-temperature alarm limit",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_ot_alarm_limit,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : temperature_lower
* Register path    : /xadc_wizard/alarm_tresholds/temperature_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_temperature_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : temperature_lower
* Description      : OT alarm limit
* Register path    : /xadc_wizard/alarm_tresholds/temperature_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_TEMPERATURE_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_temperature_lower =
{
   ED_IO_MEM,
   ED_RW,
   "temperature_lower",
   "OT alarm limit",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_temperature_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccint_lower
* Register path    : /xadc_wizard/alarm_tresholds/vccint_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccint_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccint_lower
* Description      : VCCINT lower [alarm 1]
* Register path    : /xadc_wizard/alarm_tresholds/vccint_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCINT_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccint_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vccint_lower",
   "VCCINT lower [alarm 1]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccint_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccaux_lower
* Register path    : /xadc_wizard/alarm_tresholds/vccaux_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccaux_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccaux_lower
* Description      : VCCAUX lower  [alarm 2]
* Register path    : /xadc_wizard/alarm_tresholds/vccaux_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCAUX_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccaux_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vccaux_lower",
   "VCCAUX lower  [alarm 2]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccaux_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : ot_alarm_reset
* Register path    : /xadc_wizard/alarm_tresholds/ot_alarm_reset
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_ot_alarm_reset[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : ot_alarm_reset
* Description      : Over-temperature alarm reset
* Register path    : /xadc_wizard/alarm_tresholds/ot_alarm_reset
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_OT_ALARM_RESET_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_ot_alarm_reset =
{
   ED_IO_MEM,
   ED_RW,
   "ot_alarm_reset",
   "Over-temperature alarm reset",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_ot_alarm_reset,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccbram_upper
* Register path    : /xadc_wizard/alarm_tresholds/vccbram_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccbram_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccbram_upper
* Description      : VCCBRAM upper [alarm 3]
* Register path    : /xadc_wizard/alarm_tresholds/vccbram_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccbram_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vccbram_upper",
   "VCCBRAM upper [alarm 3]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccbram_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccpint_upper
* Register path    : /xadc_wizard/alarm_tresholds/vccpint_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccpint_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccpint_upper
* Description      : VCCPINT upper [alarm 4]
* Register path    : /xadc_wizard/alarm_tresholds/vccpint_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccpint_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vccpint_upper",
   "VCCPINT upper [alarm 4]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccpint_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccpaux_upper
* Register path    : /xadc_wizard/alarm_tresholds/vccpaux_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccpaux_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccpaux_upper
* Description      : VCCPAUX upper VCCBRAM lower [alarm 5]
* Register path    : /xadc_wizard/alarm_tresholds/vccpaux_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccpaux_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vccpaux_upper",
   "VCCPAUX upper VCCBRAM lower [alarm 5]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccpaux_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcco_ddr_upper
* Register path    : /xadc_wizard/alarm_tresholds/vcco_ddr_upper
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vcco_ddr_upper[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcco_ddr_upper
* Description      : VCCO DDR upper [alarm 6]
* Register path    : /xadc_wizard/alarm_tresholds/vcco_ddr_upper
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_UPPER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vcco_ddr_upper =
{
   ED_IO_MEM,
   ED_RW,
   "vcco_ddr_upper",
   "VCCO DDR upper [alarm 6]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vcco_ddr_upper,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccbram_lower
* Register path    : /xadc_wizard/alarm_tresholds/vccbram_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccbram_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccbram_lower
* Description      : VCCBRAM lower [alarm 3]
* Register path    : /xadc_wizard/alarm_tresholds/vccbram_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCBRAM_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccbram_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vccbram_lower",
   "VCCBRAM lower [alarm 3]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccbram_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccpint_lower
* Register path    : /xadc_wizard/alarm_tresholds/vccpint_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccpint_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccpint_lower
* Description      : VCCPINT lower  [alarm 4]
* Register path    : /xadc_wizard/alarm_tresholds/vccpint_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPINT_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccpint_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vccpint_lower",
   "VCCPINT lower  [alarm 4]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccpint_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vccpaux_lower
* Register path    : /xadc_wizard/alarm_tresholds/vccpaux_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vccpaux_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vccpaux_lower
* Description      : VCCPAUX lower [alarm 5]
* Register path    : /xadc_wizard/alarm_tresholds/vccpaux_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCPAUX_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vccpaux_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vccpaux_lower",
   "VCCPAUX lower [alarm 5]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vccpaux_lower,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : vcco_ddr_lower
* Register path    : /xadc_wizard/alarm_tresholds/vcco_ddr_lower
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_
#define _FIELD_LIST_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_

static const ST_CHAMP_COMPOSE field_list_xadc_wizard_alarm_tresholds_vcco_ddr_lower[2] =
{
   {"rsvd0", "reserved location", 4, ED_RW, 0},
   {"value", "null", 12, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : vcco_ddr_lower
* Description      : VCCO DDR lower [alarm 6]
* Register path    : /xadc_wizard/alarm_tresholds/vcco_ddr_lower
********************************************************************************/
#ifndef _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_
#define _REG_DESCR_XADC_WIZARD_ALARM_TRESHOLDS_VCCO_DDR_LOWER_

static const ST_DESCR_REG reg_descr_xadc_wizard_alarm_tresholds_vcco_ddr_lower =
{
   ED_IO_MEM,
   ED_RW,
   "vcco_ddr_lower",
   "VCCO DDR lower [alarm 6]",
   0xfff0,
   2,
   field_list_xadc_wizard_alarm_tresholds_vcco_ddr_lower,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : alarm_tresholds
* Section path       : /xadc_wizard/alarm_tresholds
* Section offset     : 0x340
* Number of Register : 16
********************************************************************************/
static const ST_LISTE_REG reg_list_xadc_wizard_alarm_tresholds[16] =
{
   {0x340, &reg_descr_xadc_wizard_alarm_tresholds_temperature_upper},
   {0x344, &reg_descr_xadc_wizard_alarm_tresholds_vccint_upper},
   {0x348, &reg_descr_xadc_wizard_alarm_tresholds_vccaux_upper},
   {0x34c, &reg_descr_xadc_wizard_alarm_tresholds_ot_alarm_limit},
   {0x350, &reg_descr_xadc_wizard_alarm_tresholds_temperature_lower},
   {0x354, &reg_descr_xadc_wizard_alarm_tresholds_vccint_lower},
   {0x358, &reg_descr_xadc_wizard_alarm_tresholds_vccaux_lower},
   {0x35c, &reg_descr_xadc_wizard_alarm_tresholds_ot_alarm_reset},
   {0x360, &reg_descr_xadc_wizard_alarm_tresholds_vccbram_upper},
   {0x364, &reg_descr_xadc_wizard_alarm_tresholds_vccpint_upper},
   {0x368, &reg_descr_xadc_wizard_alarm_tresholds_vccpaux_upper},
   {0x36c, &reg_descr_xadc_wizard_alarm_tresholds_vcco_ddr_upper},
   {0x370, &reg_descr_xadc_wizard_alarm_tresholds_vccbram_lower},
   {0x374, &reg_descr_xadc_wizard_alarm_tresholds_vccpint_lower},
   {0x378, &reg_descr_xadc_wizard_alarm_tresholds_vccpaux_lower},
   {0x37c, &reg_descr_xadc_wizard_alarm_tresholds_vcco_ddr_lower}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : alarm_tresholds
* Description      : null
* Section path    : /xadc_wizard/alarm_tresholds
********************************************************************************/
static const ST_GROUPE_REG section_descr_xadc_wizard_alarm_tresholds[1] =
{
   {"alarm_tresholds", 16, reg_list_xadc_wizard_alarm_tresholds}
};

/*******************************************************************************
* IP DESCRIPTION
* 
* IP Name    : xadc_wizard
* Description      : null
********************************************************************************/
static const ST_CHIP_REG chip_xadc_wizard[5] =
{
   {"local_register", 1, section_descr_xadc_wizard_local_register},
   {"interrupt_controller", 1, section_descr_xadc_wizard_interrupt_controller},
   {"xadc_hard_macro", 1, section_descr_xadc_wizard_xadc_hard_macro},
   {"control", 1, section_descr_xadc_wizard_control},
   {"alarm_tresholds", 1, section_descr_xadc_wizard_alarm_tresholds}
};



