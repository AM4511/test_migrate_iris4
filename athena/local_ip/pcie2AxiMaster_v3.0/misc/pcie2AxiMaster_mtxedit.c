/********************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: pcie2AxiMaster
**
**  DESCRIPTION: C Language Register file description of the pcie2AxiMaster module
**               for the Matrox Imaging MtxEdit tool
**
**  AUTOMATICALLY GENERATED FILE DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.5.0_beta5
**  Build ID: I20151222-1010
**
**  COPYRIGHT (c) 2015 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
********************************************************************************/
#include "editeur.h"


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : tag
* Register path    : /pcie2AxiMaster/info/tag
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INFO_TAG_
#define _FIELD_LIST_PCIE2AXIMASTER_INFO_TAG_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_info_tag[1] =
{
   {"value", "Tag value", 24, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : tag
* Description      : Matrox Tag Identifier
* Register path    : /pcie2AxiMaster/info/tag
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INFO_TAG_
#define _REG_DESCR_PCIE2AXIMASTER_INFO_TAG_

static const ST_DESCR_REG reg_descr_pcie2aximaster_info_tag =
{
   ED_IO_MEM,
   ED_RW,
   "tag",
   "Matrox Tag Identifier",
   0xffffff,
   1,
   field_list_pcie2aximaster_info_tag,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : fid
* Register path    : /pcie2AxiMaster/info/fid
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INFO_FID_
#define _FIELD_LIST_PCIE2AXIMASTER_INFO_FID_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_info_fid[1] =
{
   {"value", "null", 32, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : fid
* Description      : Matrox IP-Core Function ID
* Register path    : /pcie2AxiMaster/info/fid
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INFO_FID_
#define _REG_DESCR_PCIE2AXIMASTER_INFO_FID_

static const ST_DESCR_REG reg_descr_pcie2aximaster_info_fid =
{
   ED_IO_MEM,
   ED_RW,
   "fid",
   "Matrox IP-Core Function ID",
   0xffffffff,
   1,
   field_list_pcie2aximaster_info_fid,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : version
* Register path    : /pcie2AxiMaster/info/version
* Number of fields : 3
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INFO_VERSION_
#define _FIELD_LIST_PCIE2AXIMASTER_INFO_VERSION_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_info_version[3] =
{
   {"sub_minor", "Sub minor version", 8, ED_RO, 0},
   {"minor", "Minor version", 8, ED_RO, 0},
   {"major", "Major version", 8, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : version
* Description      : Register file version
* Register path    : /pcie2AxiMaster/info/version
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INFO_VERSION_
#define _REG_DESCR_PCIE2AXIMASTER_INFO_VERSION_

static const ST_DESCR_REG reg_descr_pcie2aximaster_info_version =
{
   ED_IO_MEM,
   ED_RW,
   "version",
   "Register file version",
   0xffffff,
   3,
   field_list_pcie2aximaster_info_version,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : capability
* Register path    : /pcie2AxiMaster/info/capability
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INFO_CAPABILITY_
#define _FIELD_LIST_PCIE2AXIMASTER_INFO_CAPABILITY_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_info_capability[1] =
{
   {"value", "null", 8, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : capability
* Description      : Register file version
* Register path    : /pcie2AxiMaster/info/capability
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INFO_CAPABILITY_
#define _REG_DESCR_PCIE2AXIMASTER_INFO_CAPABILITY_

static const ST_DESCR_REG reg_descr_pcie2aximaster_info_capability =
{
   ED_IO_MEM,
   ED_RW,
   "capability",
   "Register file version",
   0xff,
   1,
   field_list_pcie2aximaster_info_capability,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : scratchpad
* Register path    : /pcie2AxiMaster/info/scratchpad
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INFO_SCRATCHPAD_
#define _FIELD_LIST_PCIE2AXIMASTER_INFO_SCRATCHPAD_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_info_scratchpad[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : scratchpad
* Description      : Scratch pad
* Register path    : /pcie2AxiMaster/info/scratchpad
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INFO_SCRATCHPAD_
#define _REG_DESCR_PCIE2AXIMASTER_INFO_SCRATCHPAD_

static const ST_DESCR_REG reg_descr_pcie2aximaster_info_scratchpad =
{
   ED_IO_MEM,
   ED_RW,
   "scratchpad",
   "Scratch pad",
   0xffffffff,
   1,
   field_list_pcie2aximaster_info_scratchpad,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : info
* Section path       : /pcie2AxiMaster/info
* Section offset     : 0x0
* Number of Register : 5
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_info[5] =
{
   {0x0, &reg_descr_pcie2aximaster_info_tag},
   {0x4, &reg_descr_pcie2aximaster_info_fid},
   {0x8, &reg_descr_pcie2aximaster_info_version},
   {0xc, &reg_descr_pcie2aximaster_info_capability},
   {0x10, &reg_descr_pcie2aximaster_info_scratchpad}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : info
* Description      : PCIe2AxiMaster IP-Core general information
* Section path    : /pcie2AxiMaster/info
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_info[1] =
{
   {"info", 5, reg_list_pcie2aximaster_info}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : version
* Register path    : /pcie2AxiMaster/fpga/version
* Number of fields : 4
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_FPGA_VERSION_
#define _FIELD_LIST_PCIE2AXIMASTER_FPGA_VERSION_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_fpga_version[4] =
{
   {"sub_minor", "Sub minor version", 8, ED_RO, 0},
   {"minor", "Minor version", 8, ED_RO, 0},
   {"major", "Major version", 8, ED_RO, 0},
   {"firmware_type", "Firmware type", 8, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : version
* Description      : Register file version
* Register path    : /pcie2AxiMaster/fpga/version
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_FPGA_VERSION_
#define _REG_DESCR_PCIE2AXIMASTER_FPGA_VERSION_

static const ST_DESCR_REG reg_descr_pcie2aximaster_fpga_version =
{
   ED_IO_MEM,
   ED_RW,
   "version",
   "Register file version",
   0xffffffff,
   4,
   field_list_pcie2aximaster_fpga_version,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : build_id
* Register path    : /pcie2AxiMaster/fpga/build_id
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_FPGA_BUILD_ID_
#define _FIELD_LIST_PCIE2AXIMASTER_FPGA_BUILD_ID_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_fpga_build_id[1] =
{
   {"value", "null", 32, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : build_id
* Description      : Firmware build id
* Register path    : /pcie2AxiMaster/fpga/build_id
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_FPGA_BUILD_ID_
#define _REG_DESCR_PCIE2AXIMASTER_FPGA_BUILD_ID_

static const ST_DESCR_REG reg_descr_pcie2aximaster_fpga_build_id =
{
   ED_IO_MEM,
   ED_RW,
   "build_id",
   "Firmware build id",
   0xffffffff,
   1,
   field_list_pcie2aximaster_fpga_build_id,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : device
* Register path    : /pcie2AxiMaster/fpga/device
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_FPGA_DEVICE_
#define _FIELD_LIST_PCIE2AXIMASTER_FPGA_DEVICE_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_fpga_device[1] =
{
   {"id", "Manufacturer FPGA device ID", 8, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : device
* Description      : null
* Register path    : /pcie2AxiMaster/fpga/device
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_FPGA_DEVICE_
#define _REG_DESCR_PCIE2AXIMASTER_FPGA_DEVICE_

static const ST_DESCR_REG reg_descr_pcie2aximaster_fpga_device =
{
   ED_IO_MEM,
   ED_RW,
   "device",
   "null",
   0xff,
   1,
   field_list_pcie2aximaster_fpga_device,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : board_info
* Register path    : /pcie2AxiMaster/fpga/board_info
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_FPGA_BOARD_INFO_
#define _FIELD_LIST_PCIE2AXIMASTER_FPGA_BOARD_INFO_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_fpga_board_info[1] =
{
   {"capability", "Board capability", 4, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : board_info
* Description      : Board information
* Register path    : /pcie2AxiMaster/fpga/board_info
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_FPGA_BOARD_INFO_
#define _REG_DESCR_PCIE2AXIMASTER_FPGA_BOARD_INFO_

static const ST_DESCR_REG reg_descr_pcie2aximaster_fpga_board_info =
{
   ED_IO_MEM,
   ED_RW,
   "board_info",
   "Board information",
   0xf,
   1,
   field_list_pcie2aximaster_fpga_board_info,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : fpga
* Section path       : /pcie2AxiMaster/fpga
* Section offset     : 0x20
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_fpga[4] =
{
   {0x20, &reg_descr_pcie2aximaster_fpga_version},
   {0x24, &reg_descr_pcie2aximaster_fpga_build_id},
   {0x28, &reg_descr_pcie2aximaster_fpga_device},
   {0x2c, &reg_descr_pcie2aximaster_fpga_board_info}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : fpga
* Description      : FPGA informations
* Section path    : /pcie2AxiMaster/fpga
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_fpga[1] =
{
   {"fpga", 4, reg_list_pcie2aximaster_fpga}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : ctrl
* Register path    : /pcie2AxiMaster/interrupts/ctrl
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_CTRL_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_CTRL_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupts_ctrl[2] =
{
   {"global_mask", "Global Mask interrupt ", 1, ED_RW, 0},
   {"num_irq", "Number of IRQ", 7, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : ctrl
* Description      : null
* Register path    : /pcie2AxiMaster/interrupts/ctrl
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_CTRL_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_CTRL_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupts_ctrl =
{
   ED_IO_MEM,
   ED_RW,
   "ctrl",
   "null",
   0xff,
   2,
   field_list_pcie2aximaster_interrupts_ctrl,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : status
* Register path    : /pcie2AxiMaster/interrupts/status
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_STATUS_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_STATUS_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupts_status[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : status
* Description      : Interrupt status register
* Register path    : /pcie2AxiMaster/interrupts/status
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_STATUS_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_STATUS_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupts_status =
{
   ED_IO_MEM,
   ED_RW,
   "status",
   "Interrupt status register",
   0xffffffff,
   1,
   field_list_pcie2aximaster_interrupts_status,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : enable
* Register path    : /pcie2AxiMaster/interrupts/enable
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_ENABLE_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_ENABLE_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupts_enable[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : enable
* Description      : Interrupt enable register
* Register path    : /pcie2AxiMaster/interrupts/enable
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_ENABLE_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_ENABLE_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupts_enable =
{
   ED_IO_MEM,
   ED_RW,
   "enable",
   "Interrupt enable register",
   0xffffffff,
   1,
   field_list_pcie2aximaster_interrupts_enable,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : mask
* Register path    : /pcie2AxiMaster/interrupts/mask
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_MASK_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPTS_MASK_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupts_mask[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : mask
* Description      : Interrupt mask register
* Register path    : /pcie2AxiMaster/interrupts/mask
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_MASK_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPTS_MASK_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupts_mask =
{
   ED_IO_MEM,
   ED_RW,
   "mask",
   "Interrupt mask register",
   0xffffffff,
   1,
   field_list_pcie2aximaster_interrupts_mask,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : interrupts
* Section path       : /pcie2AxiMaster/interrupts
* Section offset     : 0x40
* Number of Register : 7
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_interrupts[7] =
{
   {0x40, &reg_descr_pcie2aximaster_interrupts_ctrl},
   {0x44, &reg_descr_pcie2aximaster_interrupts_status},
   {0x48, &reg_descr_pcie2aximaster_interrupts_status},
   {0x4c, &reg_descr_pcie2aximaster_interrupts_enable},
   {0x50, &reg_descr_pcie2aximaster_interrupts_enable},
   {0x54, &reg_descr_pcie2aximaster_interrupts_mask},
   {0x58, &reg_descr_pcie2aximaster_interrupts_mask}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : interrupts
* Description      : null
* Section path    : /pcie2AxiMaster/interrupts
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_interrupts[1] =
{
   {"interrupts", 7, reg_list_pcie2aximaster_interrupts}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : control
* Register path    : /pcie2AxiMaster/interrupt_queue/control
* Number of fields : 3
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupt_queue_control[3] =
{
   {"enable", "QInterrupt queue enable", 1, ED_RW, 0},
   {"rsvd0", "reserved location", 23, ED_RW, 0},
   {"nb_dw", "Number of DWORDS", 8, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : control
* Description      : null
* Register path    : /pcie2AxiMaster/interrupt_queue/control
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONTROL_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupt_queue_control =
{
   ED_IO_MEM,
   ED_RW,
   "control",
   "null",
   0xff000001,
   3,
   field_list_pcie2aximaster_interrupt_queue_control,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : cons_idx
* Register path    : /pcie2AxiMaster/interrupt_queue/cons_idx
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupt_queue_cons_idx[1] =
{
   {"cons_idx", "null", 10, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : cons_idx
* Description      : Consumer Index
* Register path    : /pcie2AxiMaster/interrupt_queue/cons_idx
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_CONS_IDX_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupt_queue_cons_idx =
{
   ED_IO_MEM,
   ED_RW,
   "cons_idx",
   "Consumer Index",
   0x3ff,
   1,
   field_list_pcie2aximaster_interrupt_queue_cons_idx,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : addr_low
* Register path    : /pcie2AxiMaster/interrupt_queue/addr_low
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupt_queue_addr_low[1] =
{
   {"addr", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : addr_low
* Description      : null
* Register path    : /pcie2AxiMaster/interrupt_queue/addr_low
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_LOW_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupt_queue_addr_low =
{
   ED_IO_MEM,
   ED_RW,
   "addr_low",
   "null",
   0xffffffff,
   1,
   field_list_pcie2aximaster_interrupt_queue_addr_low,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : addr_high
* Register path    : /pcie2AxiMaster/interrupt_queue/addr_high
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_
#define _FIELD_LIST_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_interrupt_queue_addr_high[1] =
{
   {"addr", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : addr_high
* Description      : null
* Register path    : /pcie2AxiMaster/interrupt_queue/addr_high
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_
#define _REG_DESCR_PCIE2AXIMASTER_INTERRUPT_QUEUE_ADDR_HIGH_

static const ST_DESCR_REG reg_descr_pcie2aximaster_interrupt_queue_addr_high =
{
   ED_IO_MEM,
   ED_RW,
   "addr_high",
   "null",
   0xffffffff,
   1,
   field_list_pcie2aximaster_interrupt_queue_addr_high,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : interrupt_queue
* Section path       : /pcie2AxiMaster/interrupt_queue
* Section offset     : 0x60
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_interrupt_queue[4] =
{
   {0x60, &reg_descr_pcie2aximaster_interrupt_queue_control},
   {0x64, &reg_descr_pcie2aximaster_interrupt_queue_cons_idx},
   {0x68, &reg_descr_pcie2aximaster_interrupt_queue_addr_low},
   {0x6c, &reg_descr_pcie2aximaster_interrupt_queue_addr_high}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : interrupt_queue
* Description      : null
* Section path    : /pcie2AxiMaster/interrupt_queue
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_interrupt_queue[1] =
{
   {"interrupt_queue", 4, reg_list_pcie2aximaster_interrupt_queue}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : timeout
* Register path    : /pcie2AxiMaster/tlp/timeout
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_TLP_TIMEOUT_
#define _FIELD_LIST_PCIE2AXIMASTER_TLP_TIMEOUT_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_tlp_timeout[1] =
{
   {"value", "TLP timeout value", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : timeout
* Description      : TLP transaction timeout value
* Register path    : /pcie2AxiMaster/tlp/timeout
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_TLP_TIMEOUT_
#define _REG_DESCR_PCIE2AXIMASTER_TLP_TIMEOUT_

static const ST_DESCR_REG reg_descr_pcie2aximaster_tlp_timeout =
{
   ED_IO_MEM,
   ED_RW,
   "timeout",
   "TLP transaction timeout value",
   0xffffffff,
   1,
   field_list_pcie2aximaster_tlp_timeout,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : transaction_abort_cntr
* Register path    : /pcie2AxiMaster/tlp/transaction_abort_cntr
* Number of fields : 2
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_
#define _FIELD_LIST_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_tlp_transaction_abort_cntr[2] =
{
   {"value", "Counter value", 31, ED_RO, 0},
   {"clr", "Clear transaction abort counter value", 1, ED_WO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : transaction_abort_cntr
* Description      : TLP transaction abort counter
* Register path    : /pcie2AxiMaster/tlp/transaction_abort_cntr
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_
#define _REG_DESCR_PCIE2AXIMASTER_TLP_TRANSACTION_ABORT_CNTR_

static const ST_DESCR_REG reg_descr_pcie2aximaster_tlp_transaction_abort_cntr =
{
   ED_IO_MEM,
   ED_RW,
   "transaction_abort_cntr",
   "TLP transaction abort counter",
   0xffffffff,
   2,
   field_list_pcie2aximaster_tlp_transaction_abort_cntr,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : tlp
* Section path       : /pcie2AxiMaster/tlp
* Section offset     : 0x70
* Number of Register : 2
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_tlp[2] =
{
   {0x70, &reg_descr_pcie2aximaster_tlp_timeout},
   {0x74, &reg_descr_pcie2aximaster_tlp_transaction_abort_cntr}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : tlp
* Description      : Transaction Layer protocol
* Section path    : /pcie2AxiMaster/tlp
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_tlp[1] =
{
   {"tlp", 2, reg_list_pcie2aximaster_tlp}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : SPIREGIN
* Register path    : /pcie2AxiMaster/spi/SPIREGIN
* Number of fields : 11
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_SPI_SPIREGIN_
#define _FIELD_LIST_PCIE2AXIMASTER_SPI_SPIREGIN_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_spi_spiregin[11] =
{
   {"SPIDATAW", "SPI Data  byte to write", 8, ED_RW, 0},
   {"rsvd0", "reserved location", 8, ED_RW, 0},
   {"SPITXST", "SPI SPITXST Transfer STart", 1, ED_WO, 0},
   {"rsvd1", "reserved location", 1, ED_RW, 0},
   {"SPISEL", "SPI active channel SELection", 1, ED_RW, 0},
   {"rsvd2", "reserved location", 2, ED_RW, 0},
   {"SPICMDDONE", "SPI  CoMmaD DONE", 1, ED_RW, 0},
   {"SPIRW", "SPI  Read Write", 1, ED_RW, 0},
   {"rsvd3", "reserved location", 1, ED_RW, 0},
   {"SPI_ENABLE", "SPI ENABLE", 1, ED_RW, 0},
   {"SPI_OLD_ENABLE", "null", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : SPIREGIN
* Description      : SPI Register In
* Register path    : /pcie2AxiMaster/spi/SPIREGIN
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_SPI_SPIREGIN_
#define _REG_DESCR_PCIE2AXIMASTER_SPI_SPIREGIN_

static const ST_DESCR_REG reg_descr_pcie2aximaster_spi_spiregin =
{
   ED_IO_MEM,
   ED_RW,
   "SPIREGIN",
   "SPI Register In",
   0x36500ff,
   11,
   field_list_pcie2aximaster_spi_spiregin,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : SPIREGOUT
* Register path    : /pcie2AxiMaster/spi/SPIREGOUT
* Number of fields : 4
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_SPI_SPIREGOUT_
#define _FIELD_LIST_PCIE2AXIMASTER_SPI_SPIREGOUT_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_spi_spiregout[4] =
{
   {"SPIDATARD", "SPI DATA  Read byte OUTput ", 8, ED_RO, 0},
   {"rsvd0", "reserved location", 8, ED_RW, 0},
   {"SPIWRTD", "SPI Write or Read Transfer Done", 1, ED_RO, 0},
   {"SPI_WB_CAP", "SPI Write Burst CAPable", 1, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : SPIREGOUT
* Description      : SPI Register Out
* Register path    : /pcie2AxiMaster/spi/SPIREGOUT
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_SPI_SPIREGOUT_
#define _REG_DESCR_PCIE2AXIMASTER_SPI_SPIREGOUT_

static const ST_DESCR_REG reg_descr_pcie2aximaster_spi_spiregout =
{
   ED_IO_MEM,
   ED_RW,
   "SPIREGOUT",
   "SPI Register Out",
   0x300ff,
   4,
   field_list_pcie2aximaster_spi_spiregout,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : spi
* Section path       : /pcie2AxiMaster/spi
* Section offset     : 0xe0
* Number of Register : 2
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_spi[2] =
{
   {0xe0, &reg_descr_pcie2aximaster_spi_spiregin},
   {0xe8, &reg_descr_pcie2aximaster_spi_spiregout}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : spi
* Description      : null
* Section path    : /pcie2AxiMaster/spi
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_spi[1] =
{
   {"spi", 2, reg_list_pcie2aximaster_spi}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : ctrl
* Register path    : /pcie2AxiMaster/axi_window/ctrl
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_CTRL_
#define _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_CTRL_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_axi_window_ctrl[1] =
{
   {"enable", "null", 1, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : ctrl
* Description      : PCIe Bar 0 start address
* Register path    : /pcie2AxiMaster/axi_window/ctrl
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_CTRL_
#define _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_CTRL_

static const ST_DESCR_REG reg_descr_pcie2aximaster_axi_window_ctrl =
{
   ED_IO_MEM,
   ED_RW,
   "ctrl",
   "PCIe Bar 0 start address",
   0x1,
   1,
   field_list_pcie2aximaster_axi_window_ctrl,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : pci_bar0_start
* Register path    : /pcie2AxiMaster/axi_window/pci_bar0_start
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_
#define _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_axi_window_pci_bar0_start[1] =
{
   {"value", "null", 26, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : pci_bar0_start
* Description      : PCIe Bar 0 window start offset
* Register path    : /pcie2AxiMaster/axi_window/pci_bar0_start
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_
#define _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_START_

static const ST_DESCR_REG reg_descr_pcie2aximaster_axi_window_pci_bar0_start =
{
   ED_IO_MEM,
   ED_RW,
   "pci_bar0_start",
   "PCIe Bar 0 window start offset",
   0x3ffffff,
   1,
   field_list_pcie2aximaster_axi_window_pci_bar0_start,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : pci_bar0_stop
* Register path    : /pcie2AxiMaster/axi_window/pci_bar0_stop
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_
#define _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_axi_window_pci_bar0_stop[1] =
{
   {"value", "null", 26, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : pci_bar0_stop
* Description      : PCIe Bar 0 window stop offset
* Register path    : /pcie2AxiMaster/axi_window/pci_bar0_stop
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_
#define _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_PCI_BAR0_STOP_

static const ST_DESCR_REG reg_descr_pcie2aximaster_axi_window_pci_bar0_stop =
{
   ED_IO_MEM,
   ED_RW,
   "pci_bar0_stop",
   "PCIe Bar 0 window stop offset",
   0x3ffffff,
   1,
   field_list_pcie2aximaster_axi_window_pci_bar0_stop,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : axi_translation
* Register path    : /pcie2AxiMaster/axi_window/axi_translation
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_
#define _FIELD_LIST_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_axi_window_axi_translation[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : axi_translation
* Description      : Axi offset translation
* Register path    : /pcie2AxiMaster/axi_window/axi_translation
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_
#define _REG_DESCR_PCIE2AXIMASTER_AXI_WINDOW_AXI_TRANSLATION_

static const ST_DESCR_REG reg_descr_pcie2aximaster_axi_window_axi_translation =
{
   ED_IO_MEM,
   ED_RW,
   "axi_translation",
   "Axi offset translation",
   0xffffffff,
   1,
   field_list_pcie2aximaster_axi_window_axi_translation,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : axi_window[0]
* Section path       : /pcie2AxiMaster/axi_window[0]
* Section offset     : 0x100
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_axi_window_0[4] =
{
   {0x100, &reg_descr_pcie2aximaster_axi_window_ctrl},
   {0x104, &reg_descr_pcie2aximaster_axi_window_pci_bar0_start},
   {0x108, &reg_descr_pcie2aximaster_axi_window_pci_bar0_stop},
   {0x10c, &reg_descr_pcie2aximaster_axi_window_axi_translation}
};

/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : axi_window[1]
* Section path       : /pcie2AxiMaster/axi_window[1]
* Section offset     : 0x110
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_axi_window_1[4] =
{
   {0x110, &reg_descr_pcie2aximaster_axi_window_ctrl},
   {0x114, &reg_descr_pcie2aximaster_axi_window_pci_bar0_start},
   {0x118, &reg_descr_pcie2aximaster_axi_window_pci_bar0_stop},
   {0x11c, &reg_descr_pcie2aximaster_axi_window_axi_translation}
};

/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : axi_window[2]
* Section path       : /pcie2AxiMaster/axi_window[2]
* Section offset     : 0x120
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_axi_window_2[4] =
{
   {0x120, &reg_descr_pcie2aximaster_axi_window_ctrl},
   {0x124, &reg_descr_pcie2aximaster_axi_window_pci_bar0_start},
   {0x128, &reg_descr_pcie2aximaster_axi_window_pci_bar0_stop},
   {0x12c, &reg_descr_pcie2aximaster_axi_window_axi_translation}
};

/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : axi_window[3]
* Section path       : /pcie2AxiMaster/axi_window[3]
* Section offset     : 0x130
* Number of Register : 4
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_axi_window_3[4] =
{
   {0x130, &reg_descr_pcie2aximaster_axi_window_ctrl},
   {0x134, &reg_descr_pcie2aximaster_axi_window_pci_bar0_start},
   {0x138, &reg_descr_pcie2aximaster_axi_window_pci_bar0_stop},
   {0x13c, &reg_descr_pcie2aximaster_axi_window_axi_translation}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : axi_window(3:0)
* Description      : null
* Section path    : /pcie2AxiMaster/axi_window
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_axi_window[4] =
{
   {"axi_window 0", 4, reg_list_pcie2aximaster_axi_window_0},
   {"axi_window 1", 4, reg_list_pcie2aximaster_axi_window_1},
   {"axi_window 2", 4, reg_list_pcie2aximaster_axi_window_2},
   {"axi_window 3", 4, reg_list_pcie2aximaster_axi_window_3}
};

/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : input
* Register path    : /pcie2AxiMaster/debug/input
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_DEBUG_INPUT_
#define _FIELD_LIST_PCIE2AXIMASTER_DEBUG_INPUT_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_debug_input[1] =
{
   {"value", "null", 32, ED_RO, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : input
* Description      : debug input signals
* Register path    : /pcie2AxiMaster/debug/input
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_DEBUG_INPUT_
#define _REG_DESCR_PCIE2AXIMASTER_DEBUG_INPUT_

static const ST_DESCR_REG reg_descr_pcie2aximaster_debug_input =
{
   ED_IO_MEM,
   ED_RW,
   "input",
   "debug input signals",
   0xffffffff,
   1,
   field_list_pcie2aximaster_debug_input,
   0
};
#endif


/*******************************************************************************
* REGISTER FIELD LIST INSTANTIATION
* 
* Register Name    : output
* Register path    : /pcie2AxiMaster/debug/output
* Number of fields : 1
********************************************************************************/
#ifndef _FIELD_LIST_PCIE2AXIMASTER_DEBUG_OUTPUT_
#define _FIELD_LIST_PCIE2AXIMASTER_DEBUG_OUTPUT_

static const ST_CHAMP_COMPOSE field_list_pcie2aximaster_debug_output[1] =
{
   {"value", "null", 32, ED_RW, 0}
};
#endif


/*******************************************************************************
* REGISTER DESCRIPTION
* 
* Register Name    : output
* Description      : null
* Register path    : /pcie2AxiMaster/debug/output
********************************************************************************/
#ifndef _REG_DESCR_PCIE2AXIMASTER_DEBUG_OUTPUT_
#define _REG_DESCR_PCIE2AXIMASTER_DEBUG_OUTPUT_

static const ST_DESCR_REG reg_descr_pcie2aximaster_debug_output =
{
   ED_IO_MEM,
   ED_RW,
   "output",
   "null",
   0xffffffff,
   1,
   field_list_pcie2aximaster_debug_output,
   0
};
#endif


/*******************************************************************************
* SECTION REGISTERS INSTANTIATION
* 
* Section Name       : debug
* Section path       : /pcie2AxiMaster/debug
* Section offset     : 0x200
* Number of Register : 2
********************************************************************************/
static const ST_LISTE_REG reg_list_pcie2aximaster_debug[2] =
{
   {0x200, &reg_descr_pcie2aximaster_debug_input},
   {0x204, &reg_descr_pcie2aximaster_debug_output}
};

/*******************************************************************************
* SECTION DESCRIPTION
* 
* Section Name    : debug
* Description      : null
* Section path    : /pcie2AxiMaster/debug
********************************************************************************/
static const ST_GROUPE_REG section_descr_pcie2aximaster_debug[1] =
{
   {"debug", 2, reg_list_pcie2aximaster_debug}
};

/*******************************************************************************
* IP DESCRIPTION
* 
* IP Name    : pcie2AxiMaster
* Description      : null
********************************************************************************/
static const ST_CHIP_REG chip_pcie2aximaster[8] =
{
   {"info", 1, section_descr_pcie2aximaster_info},
   {"fpga", 1, section_descr_pcie2aximaster_fpga},
   {"interrupts", 1, section_descr_pcie2aximaster_interrupts},
   {"interrupt_queue", 1, section_descr_pcie2aximaster_interrupt_queue},
   {"tlp", 1, section_descr_pcie2aximaster_tlp},
   {"spi", 1, section_descr_pcie2aximaster_spi},
   {"axi_window", 4, section_descr_pcie2aximaster_axi_window},
   {"debug", 1, section_descr_pcie2aximaster_debug}
};



