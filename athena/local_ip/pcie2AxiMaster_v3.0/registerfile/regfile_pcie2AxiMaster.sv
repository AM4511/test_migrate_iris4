/*****************************************************************************
 ** File                : regfile_pcie2AxiMaster.sv
 ** Project             : FDK
 ** Module              : regfile_pcie2AxiMaster
 ** Created on          : 2020/06/29 12:06:56
 ** Created by          : imaval
 ** FDK IDE Version     : 4.7.0_beta4
 ** Build ID            : I20191220-1537
 ** Register file CRC32 : 0x482014AC
 **
 **  COPYRIGHT (c) 2020 Matrox Electronic Systems Ltd.
 **  All Rights Reserved
 **
 *****************************************************************************/
typedef bit  [7:0][3:0]  uint8_t;
typedef bit  [15:0][1:0] uint16_t;
typedef bit  [31:0]      uint32_t;



/**************************************************************************
* Register name : tag
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [23:0] value;  /* Bits(23:0), Tag value */
      logic [7:0]  rsvd0;  /* Bits(31:24), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_info_tag_t;


/**************************************************************************
* Register name : fid
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_info_fid_t;


/**************************************************************************
* Register name : version
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] sub_minor;  /* Bits(7:0), Sub minor version */
      logic [7:0] minor;      /* Bits(15:8), Minor version */
      logic [7:0] major;      /* Bits(23:16), Major version */
      logic [7:0] rsvd0;      /* Bits(31:24), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_info_version_t;


/**************************************************************************
* Register name : capability
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  value;  /* Bits(7:0), null */
      logic [23:0] rsvd0;  /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_info_capability_t;


/**************************************************************************
* Register name : scratchpad
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_info_scratchpad_t;


/**************************************************************************
* Register name : version
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] sub_minor;      /* Bits(7:0), Sub minor version */
      logic [7:0] minor;          /* Bits(15:8), Minor version */
      logic [7:0] major;          /* Bits(23:16), Major version */
      logic [7:0] firmware_type;  /* Bits(31:24), Firmware type */
   } f;

} fdk_regfile_pcie2AxiMaster_fpga_version_t;


/**************************************************************************
* Register name : build_id
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_fpga_build_id_t;


/**************************************************************************
* Register name : device
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  id;     /* Bits(7:0), Manufacturer FPGA device ID */
      logic [23:0] rsvd0;  /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_fpga_device_t;


/**************************************************************************
* Register name : board_info
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [3:0]  capability;  /* Bits(3:0), Board capability */
      logic [27:0] rsvd0;       /* Bits(31:4), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_fpga_board_info_t;


/**************************************************************************
* Register name : ctrl
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        global_mask;  /* Bits(0:0), Global Mask interrupt */
      logic [6:0]  num_irq;      /* Bits(7:1), Number of IRQ */
      logic [23:0] rsvd0;        /* Bits(31:8), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupts_ctrl_t;


/**************************************************************************
* Register name : status
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupts_status_t;


/**************************************************************************
* Register name : enable
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupts_enable_t;


/**************************************************************************
* Register name : mask
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupts_mask_t;


/**************************************************************************
* Register name : control
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        enable;  /* Bits(0:0), QInterrupt queue enable */
      logic [22:0] rsvd0;   /* Bits(23:1), Reserved */
      logic [7:0]  nb_dw;   /* Bits(31:24), Number of DWORDS */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupt_queue_control_t;


/**************************************************************************
* Register name : cons_idx
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [9:0]  cons_idx;  /* Bits(9:0), null */
      logic [21:0] rsvd0;     /* Bits(31:10), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupt_queue_cons_idx_t;


/**************************************************************************
* Register name : addr_low
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] addr;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupt_queue_addr_low_t;


/**************************************************************************
* Register name : addr_high
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] addr;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_interrupt_queue_addr_high_t;


/**************************************************************************
* Register name : timeout
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), TLP timeout value */
   } f;

} fdk_regfile_pcie2AxiMaster_tlp_timeout_t;


/**************************************************************************
* Register name : transaction_abort_cntr
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [30:0] value;  /* Bits(30:0), Counter value */
      logic        clr;    /* Bits(31:31), Clear transaction abort counter value */
   } f;

} fdk_regfile_pcie2AxiMaster_tlp_transaction_abort_cntr_t;


/**************************************************************************
* Register name : SPIREGIN
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0] SPIDATAW;                /* Bits(7:0), SPI Data  byte to write */
      logic [7:0] rsvd0;                   /* Bits(15:8), Reserved */
      logic       SPITXST;                 /* Bits(16:16), SPI SPITXST Transfer STart */
      logic       rsvd1;                   /* Bits(17:17), Reserved */
      logic       SPISEL;                  /* Bits(18:18), SPI active channel SELection */
      logic [1:0] rsvd2;                   /* Bits(20:19), Reserved */
      logic       SPICMDDONE;              /* Bits(21:21), SPI  CoMmaD DONE */
      logic       SPIRW;                   /* Bits(22:22), SPI  Read Write */
      logic       rsvd3;                   /* Bits(23:23), Reserved */
      logic       SPI_ENABLE;              /* Bits(24:24), SPI ENABLE */
      logic       SPI_OLD_ENABLE;          /* Bits(25:25), null */
      logic [5:0] rsvd4;                   /* Bits(31:26), Reserved */
      logic       rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_pcie2AxiMaster_spi_SPIREGIN_t;


/**************************************************************************
* Register name : SPIREGOUT
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [7:0]  SPIDATARD;               /* Bits(7:0), SPI DATA  Read byte OUTput */
      logic [7:0]  rsvd0;                   /* Bits(15:8), Reserved */
      logic        SPIWRTD;                 /* Bits(16:16), SPI Write or Read Transfer Done */
      logic        SPI_WB_CAP;              /* Bits(17:17), SPI Write Burst CAPable */
      logic [13:0] rsvd1;                   /* Bits(31:18), Reserved */
      logic        rsvd_register_space[1];  /* Reserved space below */
   } f;

} fdk_regfile_pcie2AxiMaster_spi_SPIREGOUT_t;


/**************************************************************************
* Register name : ctrl
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        enable;  /* Bits(0:0), null */
      logic [30:0] rsvd0;   /* Bits(31:1), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_axi_window_ctrl_t;


/**************************************************************************
* Register name : pci_bar0_start
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [25:0] value;  /* Bits(25:0), null */
      logic [5:0]  rsvd0;  /* Bits(31:26), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_axi_window_pci_bar0_start_t;


/**************************************************************************
* Register name : pci_bar0_stop
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [25:0] value;  /* Bits(25:0), null */
      logic [5:0]  rsvd0;  /* Bits(31:26), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_axi_window_pci_bar0_stop_t;


/**************************************************************************
* Register name : axi_translation
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_axi_window_axi_translation_t;


/**************************************************************************
* Register name : input
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_debug_input_t;


/**************************************************************************
* Register name : output
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] value;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_debug_output_t;


/**************************************************************************
* Register name : DMA_DEBUG1
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] ADD_START;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG1_t;


/**************************************************************************
* Register name : DMA_DEBUG2
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic [31:0] ADD_OVERRUN;  /* Bits(31:0), null */
   } f;

} fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG2_t;


/**************************************************************************
* Register name : DMA_DEBUG3
***************************************************************************/
typedef union packed
{
   uint32_t u32;
   uint16_t u16;
   uint8_t  u8;

   struct packed
   {
      logic        DMA_OVERRUN;    /* Bits(0:0), null */
      logic [2:0]  rsvd0;          /* Bits(3:1), Reserved */
      logic        DMA_ADD_ERROR;  /* Bits(4:4), null */
      logic [26:0] rsvd1;          /* Bits(31:5), Reserved */
   } f;

} fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG3_t;


/**************************************************************************
* Section name   : info
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_info_tag_t        tag;         /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_info_fid_t        fid;         /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_info_version_t    version;     /* Address offset: 0x8 */
   fdk_regfile_pcie2AxiMaster_info_capability_t capability;  /* Address offset: 0xc */
   fdk_regfile_pcie2AxiMaster_info_scratchpad_t scratchpad;  /* Address offset: 0x10 */
} fdk_regfile_pcie2AxiMaster_info_t;


/**************************************************************************
* Section name   : fpga
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_fpga_version_t    version;     /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_fpga_build_id_t   build_id;    /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_fpga_device_t     device;      /* Address offset: 0x8 */
   fdk_regfile_pcie2AxiMaster_fpga_board_info_t board_info;  /* Address offset: 0xc */
} fdk_regfile_pcie2AxiMaster_fpga_t;


/**************************************************************************
* Section name   : interrupts
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_interrupts_ctrl_t   ctrl;       /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_interrupts_status_t status[2];  /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_interrupts_enable_t enable[2];  /* Address offset: 0xc */
   fdk_regfile_pcie2AxiMaster_interrupts_mask_t   mask[2];    /* Address offset: 0x14 */
} fdk_regfile_pcie2AxiMaster_interrupts_t;


/**************************************************************************
* Section name   : interrupt_queue
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_interrupt_queue_control_t   control;    /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_interrupt_queue_cons_idx_t  cons_idx;   /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_interrupt_queue_addr_low_t  addr_low;   /* Address offset: 0x8 */
   fdk_regfile_pcie2AxiMaster_interrupt_queue_addr_high_t addr_high;  /* Address offset: 0xc */
} fdk_regfile_pcie2AxiMaster_interrupt_queue_t;


/**************************************************************************
* Section name   : tlp
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_tlp_timeout_t                timeout;                 /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_tlp_transaction_abort_cntr_t transaction_abort_cntr;  /* Address offset: 0x4 */
} fdk_regfile_pcie2AxiMaster_tlp_t;


/**************************************************************************
* Section name   : spi
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_spi_SPIREGIN_t  SPIREGIN;   /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_spi_SPIREGOUT_t SPIREGOUT;  /* Address offset: 0x8 */
} fdk_regfile_pcie2AxiMaster_spi_t;


/**************************************************************************
* Section name   : axi_window
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_axi_window_ctrl_t            ctrl;             /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_axi_window_pci_bar0_start_t  pci_bar0_start;   /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_axi_window_pci_bar0_stop_t   pci_bar0_stop;    /* Address offset: 0x8 */
   fdk_regfile_pcie2AxiMaster_axi_window_axi_translation_t axi_translation;  /* Address offset: 0xc */
} fdk_regfile_pcie2AxiMaster_axi_window_t;


/**************************************************************************
* Section name   : debug
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_debug_input_t      input;       /* Address offset: 0x0 */
   fdk_regfile_pcie2AxiMaster_debug_output_t     output;      /* Address offset: 0x4 */
   fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG1_t DMA_DEBUG1;  /* Address offset: 0x8 */
   fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG2_t DMA_DEBUG2;  /* Address offset: 0xc */
   fdk_regfile_pcie2AxiMaster_debug_DMA_DEBUG3_t DMA_DEBUG3;  /* Address offset: 0x10 */
} fdk_regfile_pcie2AxiMaster_debug_t;


/**************************************************************************
* Register file name : regfile_pcie2AxiMaster
***************************************************************************/
typedef struct packed
{
   fdk_regfile_pcie2AxiMaster_info_t            info;             /* Section; Base address offset: 0x0 */
   uint32_t                                     [2:0]rsvd0;       /* Padding; Size (12 Bytes) */
   fdk_regfile_pcie2AxiMaster_fpga_t            fpga;             /* Section; Base address offset: 0x20 */
   uint32_t                                     [3:0]rsvd1;       /* Padding; Size (16 Bytes) */
   fdk_regfile_pcie2AxiMaster_interrupts_t      interrupts;       /* Section; Base address offset: 0x40 */
   uint32_t                                     rsvd2;            /* Padding; Size (4 Bytes) */
   fdk_regfile_pcie2AxiMaster_interrupt_queue_t interrupt_queue;  /* Section; Base address offset: 0x60 */
   fdk_regfile_pcie2AxiMaster_tlp_t             tlp;              /* Section; Base address offset: 0x70 */
   uint32_t                                     [25:0]rsvd3;      /* Padding; Size (104 Bytes) */
   fdk_regfile_pcie2AxiMaster_spi_t             spi;              /* Section; Base address offset: 0xe0 */
   uint32_t                                     [3:0]rsvd4;       /* Padding; Size (16 Bytes) */
   fdk_regfile_pcie2AxiMaster_axi_window_t      axi_window[4];    /* Section; Base address offset: 0x100 */
   uint32_t                                     [47:0]rsvd5;      /* Padding; Size (192 Bytes) */
   fdk_regfile_pcie2AxiMaster_debug_t           debug;            /* Section; Base address offset: 0x200 */
} fdk_regfile_pcie2AxiMaster_t;

