/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: regfile_ares
**
**  DESCRIPTION: Register file of the regfile_ares module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.5.0_beta6
**  Build ID: I20160216-1844
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cregfile_ares  extends CRegisterFile {


   public Cregfile_ares()
   {
      super("regfile_ares", 15, 32, true);

      CSection section;
      CExternal external;
      CRegister register;
      /***************************************************************
      * Section: Device_specific
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "Device_specific", "null", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: INTSTAT
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "INTSTAT", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "IRQ_TICK_LATCH", "null", CField.FieldType.RW2CLR, 7, 1, 0x0));
      register.addField(new CField(register, "IRQ_MICROBLAZE", "null", CField.FieldType.RW2CLR, 6, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK_WA", "null", CField.FieldType.RW2CLR, 4, 1, 0x0));
      register.addField(new CField(register, "IRQ_TIMER", "null", CField.FieldType.RO, 3, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK", "null", CField.FieldType.RW2CLR, 1, 1, 0x0));
      register.addField(new CField(register, "IRQ_IO", "null", CField.FieldType.RW2CLR, 0, 1, 0x0));

      /***************************************************************
      * Register: INTMASKn
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "INTMASKn", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "IRQ_TICK_LATCH", "null", CField.FieldType.STATIC, 7, 1, 0x1));
      register.addField(new CField(register, "IRQ_MICROBLAZE", "null", CField.FieldType.RW, 6, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK_WA", "null", CField.FieldType.RW, 4, 1, 0x0));
      register.addField(new CField(register, "IRQ_TIMER", "null", CField.FieldType.RW, 3, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK", "null", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "IRQ_IO", "null", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: INTSTAT2
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "INTSTAT2", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "IRQ_TIMER_END", "null", CField.FieldType.RW2CLR, 16, 8, 0x0));
      register.addField(new CField(register, "IRQ_TIMER_START", "null", CField.FieldType.RW2CLR, 0, 8, 0x0));

      /***************************************************************
      * Register: BUILDID
      * Offset: 0x1c
      ****************************************************************/
      register = new CRegister(section, "BUILDID", "null", 0x1c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "YEAR", "null", CField.FieldType.RO, 24, 8, 0x0));
      register.addField(new CField(register, "MONTH", "null", CField.FieldType.RO, 20, 4, 0x0));
      register.addField(new CField(register, "DATE", "null", CField.FieldType.RO, 12, 8, 0x0));
      register.addField(new CField(register, "HOUR", "null", CField.FieldType.RO, 4, 8, 0x0));
      register.addField(new CField(register, "MINUTES", "null", CField.FieldType.RO, 0, 4, 0x0));

      /***************************************************************
      * Register: FPGA_ID
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "FPGA_ID", "null", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "PROFINET_LED", "null", CField.FieldType.RW, 12, 1, 0x0));
      register.addField(new CField(register, "PB_DEBUG_COM", "null", CField.FieldType.RW, 10, 1, 0x0));
      register.addField(new CField(register, "FPGA_ID", "null", CField.FieldType.RO, 0, 5, 0x2));

      /***************************************************************
      * Register: LED_OVERRIDE
      * Offset: 0x24
      ****************************************************************/
      register = new CRegister(section, "LED_OVERRIDE", "null", 0x24);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "RED_ORANGE_FLASH", "null", CField.FieldType.RW, 25, 1, 0x0));
      register.addField(new CField(register, "ORANGE_OFF_FLASH", "null", CField.FieldType.RW, 24, 1, 0x0));


      /***************************************************************
      * Section: INTERRUPT_QUEUE
      * Offset: 0x40
      ****************************************************************/
      section = new CSection(this, "INTERRUPT_QUEUE", "null", 0x40);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CONTROL
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CONTROL", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "NB_DW", "null", CField.FieldType.STATIC, 24, 8, 0x1));
      register.addField(new CField(register, "ENABLE", "null", CField.FieldType.RW, 0, 1, 0x0));

      /***************************************************************
      * Register: CONS_IDX
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "CONS_IDX", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "CONS_IDX", "null", CField.FieldType.RW, 0, 10, 0x0));

      /***************************************************************
      * Register: ADDR_LOW
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "ADDR_LOW", "null", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ADDR", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: ADDR_HIGH
      * Offset: 0xc
      ****************************************************************/
      register = new CRegister(section, "ADDR_HIGH", "null", 0xc);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ADDR", "null", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: MAPPING
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "MAPPING", "null", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "IRQ_TIMER_END", "null", CField.FieldType.WO, 24, 8, 0x0));
      register.addField(new CField(register, "IRQ_TIMER_START", "null", CField.FieldType.WO, 16, 8, 0x0));
      register.addField(new CField(register, "IO_INTSTAT", "null", CField.FieldType.WO, 8, 4, 0x0));
      register.addField(new CField(register, "IRQ_TICK_LATCH", "null", CField.FieldType.WO, 5, 1, 0x0));
      register.addField(new CField(register, "IRQ_MICROBLAZE", "null", CField.FieldType.WO, 4, 1, 0x0));
      register.addField(new CField(register, "IRQ_TIMER", "null", CField.FieldType.WO, 3, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK_WA", "null", CField.FieldType.WO, 2, 1, 0x0));
      register.addField(new CField(register, "IRQ_TICK", "null", CField.FieldType.WO, 1, 1, 0x0));
      register.addField(new CField(register, "IRQ_IO", "null", CField.FieldType.WO, 0, 1, 0x0));


      /***************************************************************
      * Section: SPI
      * Offset: 0xe0
      ****************************************************************/
      section = new CSection(this, "SPI", "null", 0xe0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: SPIREGIN
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "SPIREGIN", "SPI Register In", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SPI_ENABLE", "SPI ENABLE", CField.FieldType.RW, 24, 1, 0x0));
      register.addField(new CField(register, "SPIRW", "SPI  Read Write", CField.FieldType.RW, 22, 1, 0x0));
      register.addField(new CField(register, "SPICMDDONE", "SPI  CoMmaD DONE", CField.FieldType.RW, 21, 1, 0x0));
      register.addField(new CField(register, "SPISEL", "SPI active channel SELection", CField.FieldType.RW, 18, 1, 0x0));
      register.addField(new CField(register, "SPITXST", "SPI SPITXST Transfer STart", CField.FieldType.WO, 16, 1, 0x0));
      register.addField(new CField(register, "SPIDATAW", "SPI Data  byte to write", CField.FieldType.RW, 0, 8, 0x0));

      /***************************************************************
      * Register: SPIREGOUT
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "SPIREGOUT", "SPI Register Out", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "SPI_WB_CAP", "SPI Write Burst CAPable", CField.FieldType.STATIC, 17, 1, 0x0));
      register.addField(new CField(register, "SPIWRTD", "SPI Write or Read Transfer Done", CField.FieldType.STATIC, 16, 1, 0x0));
      register.addField(new CField(register, "SPIDATARD", "SPI DATA  Read byte OUTput ", CField.FieldType.STATIC, 0, 8, 0x0));


      /***************************************************************
      * Section: IO[1:0]
      * Offset: 0x200 + (i * 0x20) 
      ****************************************************************/
      for (int i = 0; i < 2; i++)
      {
         long sectionOffset = 0x200 + (i * 0x20);
         section = new CSection(this, "IO", "null", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: CAPABILITIES_IO
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "CAPABILITIES_IO", "null", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "IO_ID", "null", CField.FieldType.STATIC, 24, 8, 0x10));
         register.addField(new CField(register, "N_port", "null", CField.FieldType.RO, 19, 5, 0x0));
         register.addField(new CField(register, "Input", "null", CField.FieldType.RO, 18, 1, 0x0));
         register.addField(new CField(register, "Output", "null", CField.FieldType.RO, 17, 1, 0x0));
         register.addField(new CField(register, "Intnum", "null", CField.FieldType.RO, 12, 5, 0x0));

         /************************************************************
         * Register: IO_PIN
         * Offset: 0x4
         *************************************************************/
         register = new CRegister(section, "IO_PIN", "null", 0x4);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Pin_value", "null", CField.FieldType.RO, 0, 4, 0x0));

         /************************************************************
         * Register: IO_OUT
         * Offset: 0x8
         *************************************************************/
         register = new CRegister(section, "IO_OUT", "null", 0x8);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Out_value", "null", CField.FieldType.RW, 0, 4, 0x0));

         /************************************************************
         * Register: IO_DIR
         * Offset: 0xc
         *************************************************************/
         register = new CRegister(section, "IO_DIR", "null", 0xc);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Dir", "null", CField.FieldType.RW, 0, 4, 0x0));

         /************************************************************
         * Register: IO_POL
         * Offset: 0x10
         *************************************************************/
         register = new CRegister(section, "IO_POL", "null", 0x10);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "In_pol", "null", CField.FieldType.RW, 0, 4, 0x0));

         /************************************************************
         * Register: IO_INTSTAT
         * Offset: 0x14
         *************************************************************/
         register = new CRegister(section, "IO_INTSTAT", "null", 0x14);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Intstat", "null", CField.FieldType.RW2CLR, 0, 4, 0x0));

         /************************************************************
         * Register: IO_INTMASKn
         * Offset: 0x18
         *************************************************************/
         register = new CRegister(section, "IO_INTMASKn", "null", 0x18);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Intmaskn", "null", CField.FieldType.RW, 0, 4, 0x0));

         /************************************************************
         * Register: IO_ANYEDGE
         * Offset: 0x1c
         *************************************************************/
         register = new CRegister(section, "IO_ANYEDGE", "null", 0x1c);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "In_AnyEdge", "null", CField.FieldType.RW, 0, 4, 0x0));

      }


      /***************************************************************
      * Section: Quadrature[0:0]
      * Offset: 0x300 + (i * 0x3c) 
      ****************************************************************/
      for (int i = 0; i < 1; i++)
      {
         long sectionOffset = 0x300 + (i * 0x3c);
         section = new CSection(this, "Quadrature", "null", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: CAPABILITIES_QUAD
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "CAPABILITIES_QUAD", "null", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "QUADRATURE_ID", "null", CField.FieldType.STATIC, 24, 8, 0x64));
         register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));

         /************************************************************
         * Register: PositionReset
         * Offset: 0x4
         *************************************************************/
         register = new CRegister(section, "PositionReset", "null", 0x4);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "PositionResetSource", "null", CField.FieldType.RW, 2, 4, 0x0));
         register.addField(new CField(register, "PositionResetActivation", "null", CField.FieldType.RW, 1, 1, 0x0));
         register.addField(new CField(register, "soft_PositionReset", "null", CField.FieldType.WO, 0, 1, 0x0));

         /************************************************************
         * Register: DecoderInput
         * Offset: 0x8
         *************************************************************/
         register = new CRegister(section, "DecoderInput", "null", 0x8);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "BSelector", "null", CField.FieldType.RW, 29, 3, 0x2));
         register.addField(new CField(register, "ASelector", "null", CField.FieldType.RW, 13, 3, 0x1));

         /************************************************************
         * Register: DecoderCfg
         * Offset: 0xc
         *************************************************************/
         register = new CRegister(section, "DecoderCfg", "null", 0xc);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "DecOutSource0", "null", CField.FieldType.RW, 2, 3, 0x0));
         register.addField(new CField(register, "QuadEnable", "null", CField.FieldType.RW, 0, 1, 0x0));

         /************************************************************
         * Register: DecoderPosTrigger
         * Offset: 0x10
         *************************************************************/
         register = new CRegister(section, "DecoderPosTrigger", "null", 0x10);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "PositionTrigger", "null", CField.FieldType.RW, 0, 32, 0x1));

         /************************************************************
         * Register: DecoderCntrLatch_Cfg
         * Offset: 0x14
         *************************************************************/
         register = new CRegister(section, "DecoderCntrLatch_Cfg", "null", 0x14);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "DecoderCntrLatch_SW", "null", CField.FieldType.WO, 24, 1, 0x0));
         register.addField(new CField(register, "DecoderCntrLatch_Src", "null", CField.FieldType.RW, 16, 5, 0x0));
         register.addField(new CField(register, "DecoderCntrLatch_En", "null", CField.FieldType.RW, 8, 1, 0x0));
         register.addField(new CField(register, "DecoderCntrLatch_Act", "null", CField.FieldType.RW, 4, 2, 0x0));

         /************************************************************
         * Register: DecoderCntrLatched_SW
         * Offset: 0x34
         *************************************************************/
         register = new CRegister(section, "DecoderCntrLatched_SW", "null", 0x34);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "DecoderCntr", "null", CField.FieldType.RO, 0, 32, 0x0));

         /************************************************************
         * Register: DecoderCntrLatched
         * Offset: 0x38
         *************************************************************/
         register = new CRegister(section, "DecoderCntrLatched", "null", 0x38);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "DecoderCntr", "null", CField.FieldType.RO, 0, 32, 0x0));

      }


      /***************************************************************
      * Section: TickTable[0:0]
      * Offset: 0x380 + (i * 0x58) 
      ****************************************************************/
      for (int i = 0; i < 1; i++)
      {
         long sectionOffset = 0x380 + (i * 0x58);
         section = new CSection(this, "TickTable", "null", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: CAPABILITIES_TICKTBL
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "CAPABILITIES_TICKTBL", "null", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TICKTABLE_ID", "null", CField.FieldType.STATIC, 24, 8, 0x61));
         register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x1));
         register.addField(new CField(register, "NB_ELEMENTS", "null", CField.FieldType.STATIC, 12, 5, 0xd));
         register.addField(new CField(register, "INTNUM", "null", CField.FieldType.RO, 7, 5, 0x0));

         /************************************************************
         * Register: CAPABILITIES_EXT1
         * Offset: 0x4
         *************************************************************/
         register = new CRegister(section, "CAPABILITIES_EXT1", "null", 0x4);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TABLE_WIDTH", "null", CField.FieldType.STATIC, 0, 8, 0x4));
         register.addField(new CField(register, "NB_LATCH", "null", CField.FieldType.STATIC, 8, 4, 0x2));

         /************************************************************
         * Register: TickTableClockPeriod
         * Offset: 0x8
         *************************************************************/
         register = new CRegister(section, "TickTableClockPeriod", "null", 0x8);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Period_ns", "null", CField.FieldType.RO, 0, 8, 0x1e));

         /************************************************************
         * Register: TickConfig
         * Offset: 0xc
         *************************************************************/
         register = new CRegister(section, "TickConfig", "null", 0xc);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "ClearTickTable", "Clear command in Tick Table", CField.FieldType.WO, 28, 1, 0x0));
         register.addField(new CField(register, "ClearMask", "Clear command Mask ", CField.FieldType.RW, 16, 8, 0x0));
         register.addField(new CField(register, "TickClock", "null", CField.FieldType.RW, 8, 4, 0x0));
         register.addField(new CField(register, "IntClock_sel", "null", CField.FieldType.RW, 6, 2, 0x1));
         register.addField(new CField(register, "TickClockActivation", "null", CField.FieldType.RW, 4, 2, 0x0));
         register.addField(new CField(register, "EnableHalftableInt", "null", CField.FieldType.RW, 3, 1, 0x0));
         register.addField(new CField(register, "IntClock_en", "null", CField.FieldType.RW, 2, 1, 0x0));
         register.addField(new CField(register, "LatchCurrentStamp", "null", CField.FieldType.WO, 1, 1, 0x0));
         register.addField(new CField(register, "ResetTimestamp", "null", CField.FieldType.WO, 0, 1, 0x0));

         /************************************************************
         * Register: CurrentStampLatched
         * Offset: 0x10
         *************************************************************/
         register = new CRegister(section, "CurrentStampLatched", "null", 0x10);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "CurrentStamp", "null", CField.FieldType.RO, 0, 32, 0x0));

         /************************************************************
         * Register: WriteTime
         * Offset: 0x14
         *************************************************************/
         register = new CRegister(section, "WriteTime", "null", 0x14);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "WriteTime", "null", CField.FieldType.RW, 0, 32, 0x0));

         /************************************************************
         * Register: WriteCommand
         * Offset: 0x18
         *************************************************************/
         register = new CRegister(section, "WriteCommand", "null", 0x18);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "WriteDone", "null", CField.FieldType.RO, 13, 1, 0x0));
         register.addField(new CField(register, "WriteStatus", "null", CField.FieldType.RO, 12, 1, 0x0));
         register.addField(new CField(register, "ExecuteFutureWrite", "null", CField.FieldType.WO, 9, 1, 0x0));
         register.addField(new CField(register, "ExecuteImmWrite", "null", CField.FieldType.WO, 8, 1, 0x0));
         register.addField(new CField(register, "BitCmd", "null", CField.FieldType.RW, 5, 2, 0x0));
         register.addField(new CField(register, "BitNum", "null", CField.FieldType.RW, 0, 2, 0x0));

         /************************************************************
         * Register: LatchIntStat
         * Offset: 0x1c
         *************************************************************/
         register = new CRegister(section, "LatchIntStat", "null", 0x1c);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "LatchIntStat", "null", CField.FieldType.RW2CLR, 0, 2, 0x0));

         /************************************************************
         * Register: InputStamp
         * Offset: 0x20
         *************************************************************/
         register = new CRegister(section, "InputStamp", "null", 0x20);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "InputStampSource", "null", CField.FieldType.RW, 16, 4, 0x0));
         register.addField(new CField(register, "LatchInputIntEnable", "null", CField.FieldType.RW, 9, 1, 0x0));
         register.addField(new CField(register, "LatchInputStamp_En", "null", CField.FieldType.RW, 8, 1, 0x0));
         register.addField(new CField(register, "InputStampActivation", "null", CField.FieldType.RW, 4, 2, 0x0));

         /************************************************************
         * Register: reserved_for_extra_latch
         * Offset: 0x28
         *************************************************************/
         register = new CRegister(section, "reserved_for_extra_latch", "null", 0x28);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "reserved_for_extra_latch", "null", CField.FieldType.STATIC, 0, 1, 0x0));

         /************************************************************
         * Register: InputStampLatched
         * Offset: 0x50
         *************************************************************/
         register = new CRegister(section, "InputStampLatched", "null", 0x50);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "InputStamp", "null", CField.FieldType.RO, 0, 32, 0x0));

      }


      /***************************************************************
      * Section: InputConditioning
      * Offset: 0x400
      ****************************************************************/
      section = new CSection(this, "InputConditioning", "null", 0x400);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_INCOND
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_INCOND", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "INPUTCOND_ID", "null", CField.FieldType.STATIC, 24, 8, 0x62));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "NB_INPUTS", "null", CField.FieldType.STATIC, 12, 5, 0x4));
      register.addField(new CField(register, "Period_ns", "null", CField.FieldType.RO, 0, 8, 0x0));

      /***************************************************************
      * Register: InputConditioning
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "InputConditioning", "", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "DebounceHoldOff", "null", CField.FieldType.RW, 8, 24, 0x0));
      register.addField(new CField(register, "InputFiltering", "null", CField.FieldType.RW, 1, 1, 0x0));
      register.addField(new CField(register, "InputPol", "null", CField.FieldType.RW, 0, 1, 0x0));


      /***************************************************************
      * Section: OutputConditioning
      * Offset: 0x480
      ****************************************************************/
      section = new CSection(this, "OutputConditioning", "null", 0x480);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_OUTCOND
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_OUTCOND", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "OUTPUTCOND_ID", "null", CField.FieldType.STATIC, 24, 8, 0x63));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "NB_OUTPUTS", "null", CField.FieldType.STATIC, 12, 5, 0x4));

      /***************************************************************
      * Register: OutputCond
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "OutputCond", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "OutputVal", "Output Value", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "OutputPol", "null", CField.FieldType.RW, 7, 1, 0x0));
      register.addField(new CField(register, "Outsel", "null", CField.FieldType.RW, 0, 6, 0x0));

      /***************************************************************
      * Register: Reserved
      * Offset: 0x14
      ****************************************************************/
      register = new CRegister(section, "Reserved", "null", 0x14);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "Reserved", "null", CField.FieldType.STATIC, 0, 8, 0x0));

      /***************************************************************
      * Register: Output_Debounce
      * Offset: 0x2c
      ****************************************************************/
      register = new CRegister(section, "Output_Debounce", "null", 0x2c);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "Output_HoldOFF_reg_EN", "null", CField.FieldType.RW, 16, 1, 0x0));
      register.addField(new CField(register, "Output_HoldOFF_reg_CNTR", "null", CField.FieldType.RW, 0, 10, 0x1ff));


      /***************************************************************
      * Section: InternalInput
      * Offset: 0x500
      ****************************************************************/
      section = new CSection(this, "InternalInput", "null", 0x500);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_INT_INP
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_INT_INP", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "INT_INPUT_ID", "null", CField.FieldType.STATIC, 24, 8, 0x66));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "NB_INPUTS", "null", CField.FieldType.STATIC, 12, 5, 0x3));


      /***************************************************************
      * Section: InternalOutput
      * Offset: 0x580
      ****************************************************************/
      section = new CSection(this, "InternalOutput", "null", 0x580);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_INTOUT
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_INTOUT", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "INT_OUTPUT_ID", "null", CField.FieldType.STATIC, 24, 8, 0x65));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "NB_OUTPUTS", "null", CField.FieldType.STATIC, 12, 5, 0x1));

      /***************************************************************
      * Register: OutputCond
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "OutputCond", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "OutputVal", "Output Value", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "Outsel", "null", CField.FieldType.RW, 0, 6, 0x0));


      /***************************************************************
      * Section: Timer[7:0]
      * Offset: 0x600 + (i * 0x20) 
      ****************************************************************/
      for (int i = 0; i < 8; i++)
      {
         long sectionOffset = 0x600 + (i * 0x20);
         section = new CSection(this, "Timer", "null", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: CAPABILITIES_TIMER
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "CAPABILITIES_TIMER", "null", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TIMER_ID", "null", CField.FieldType.STATIC, 24, 8, 0x60));
         register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
         register.addField(new CField(register, "INTNUM", "null", CField.FieldType.RO, 7, 5, 0x0));

         /************************************************************
         * Register: TimerClockPeriod
         * Offset: 0x4
         *************************************************************/
         register = new CRegister(section, "TimerClockPeriod", "null", 0x4);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Period_ns", "null", CField.FieldType.RO, 0, 16, 0xf0));

         /************************************************************
         * Register: TimerTriggerArm
         * Offset: 0x8
         *************************************************************/
         register = new CRegister(section, "TimerTriggerArm", "null", 0x8);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "Soft_TimerArm", "null", CField.FieldType.WO, 31, 1, 0x0));
         register.addField(new CField(register, "TimerTriggerOverlap", "null", CField.FieldType.RW, 25, 2, 0x0));
         register.addField(new CField(register, "TimerArmEnable", "null", CField.FieldType.RW, 24, 1, 0x0));
         register.addField(new CField(register, "TimerArmSource", "null", CField.FieldType.RW, 19, 5, 0x0));
         register.addField(new CField(register, "TimerArmActivation", "null", CField.FieldType.RW, 16, 3, 0x0));
         register.addField(new CField(register, "Soft_TimerTrigger", "null", CField.FieldType.WO, 15, 1, 0x0));
         register.addField(new CField(register, "TimerMesurement", "null", CField.FieldType.RW, 14, 1, 0x0));
         register.addField(new CField(register, "TimerTriggerLogicESel", "null", CField.FieldType.RW, 11, 2, 0x0));
         register.addField(new CField(register, "TimerTriggerLogicDSel", "null", CField.FieldType.RW, 9, 2, 0x0));
         register.addField(new CField(register, "TimerTriggerSource", "null", CField.FieldType.RW, 3, 6, 0x0));
         register.addField(new CField(register, "TimerTriggerActivation", "null", CField.FieldType.RW, 0, 3, 0x0));

         /************************************************************
         * Register: TimerClockSource
         * Offset: 0xc
         *************************************************************/
         register = new CRegister(section, "TimerClockSource", "null", 0xc);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "IntClock_sel", "null", CField.FieldType.RW, 16, 2, 0x1));
         register.addField(new CField(register, "DelayClockActivation", "null", CField.FieldType.RW, 12, 2, 0x0));
         register.addField(new CField(register, "DelayClockSource", "null", CField.FieldType.RW, 8, 4, 0x0));
         register.addField(new CField(register, "TimerClockActivation", "null", CField.FieldType.RW, 4, 2, 0x0));
         register.addField(new CField(register, "TimerClockSource", "null", CField.FieldType.RW, 0, 4, 0x0));

         /************************************************************
         * Register: TimerDelayValue
         * Offset: 0x10
         *************************************************************/
         register = new CRegister(section, "TimerDelayValue", "null", 0x10);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TimerDelayValue", "null", CField.FieldType.RW, 0, 32, 0x0));

         /************************************************************
         * Register: TimerDuration
         * Offset: 0x14
         *************************************************************/
         register = new CRegister(section, "TimerDuration", "null", 0x14);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TimerDuration", "null", CField.FieldType.RW, 0, 32, 0x1));

         /************************************************************
         * Register: TimerLatchedValue
         * Offset: 0x18
         *************************************************************/
         register = new CRegister(section, "TimerLatchedValue", "null", 0x18);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TimerLatchedValue", "null", CField.FieldType.RO, 0, 32, 0x0));

         /************************************************************
         * Register: TimerStatus
         * Offset: 0x1c
         *************************************************************/
         register = new CRegister(section, "TimerStatus", "null", 0x1c);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "TimerStatus", "null", CField.FieldType.RO, 29, 3, 0x0));
         register.addField(new CField(register, "TimerStatus_Latched", "null", CField.FieldType.RO, 26, 3, 0x0));
         register.addField(new CField(register, "TimerEndIntmaskn", "null", CField.FieldType.RW, 17, 1, 0x0));
         register.addField(new CField(register, "TimerStartIntmaskn", "null", CField.FieldType.RW, 16, 1, 0x0));
         register.addField(new CField(register, "TimerLatchAndReset", "null", CField.FieldType.RW, 10, 1, 0x0));
         register.addField(new CField(register, "TimerLatchValue", "null", CField.FieldType.WO, 9, 1, 0x0));
         register.addField(new CField(register, "TimerCntrReset", "null", CField.FieldType.WO, 8, 1, 0x0));
         register.addField(new CField(register, "TimerInversion", "null", CField.FieldType.RW, 1, 1, 0x0));
         register.addField(new CField(register, "TimerEnable", "null", CField.FieldType.RW, 0, 1, 0x0));

      }


      /***************************************************************
      * Section: Microblaze
      * Offset: 0xa00
      ****************************************************************/
      section = new CSection(this, "Microblaze", "null", 0xa00);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_MICRO
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_MICRO", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "MICRO_ID", "null", CField.FieldType.STATIC, 24, 8, 0x70));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "Intnum", "null", CField.FieldType.STATIC, 15, 5, 0x6));

      /***************************************************************
      * Register: ProdCons
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "ProdCons", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "MemorySize", "null", CField.FieldType.STATIC, 20, 5, 0xc));
      register.addField(new CField(register, "Offset", "null", CField.FieldType.RO, 0, 20, 0x2000));


      /***************************************************************
      * Section: AnalogOutput
      * Offset: 0xa80
      ****************************************************************/
      section = new CSection(this, "AnalogOutput", "null", 0xa80);
      super.childrenList.add(section);

      /***************************************************************
      * Register: CAPABILITIES_ANA_OUT
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "CAPABILITIES_ANA_OUT", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "ANA_OUT_ID", "null", CField.FieldType.STATIC, 24, 8, 0x67));
      register.addField(new CField(register, "FEATURE_REV", "null", CField.FieldType.STATIC, 20, 4, 0x0));
      register.addField(new CField(register, "NB_OUTPUTS", "null", CField.FieldType.STATIC, 12, 4, 0x1));

      /***************************************************************
      * Register: OutputValue
      * Offset: 0x4
      ****************************************************************/
      register = new CRegister(section, "OutputValue", "null", 0x4);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "OutputVal", "", CField.FieldType.RW, 0, 8, 0x0));


      /***************************************************************
      * Section: EOFM
      * Offset: 0xb00
      ****************************************************************/
      section = new CSection(this, "EOFM", "null", 0xb00);
      super.childrenList.add(section);

      /***************************************************************
      * Register: EOFM
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "EOFM", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "EOFM", "null", CField.FieldType.STATIC, 24, 8, 0x0));


      /***************************************************************
      * External: ProdCons
      * Offset: 0x2000
      ****************************************************************/
      external = new CExternal(this, "ProdCons", "null", 0x2000);
      super.childrenList.add(external);

      /***************************************************************
      * Register: Pointers
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(external, "Pointers", "null", 0x0);
      external.addRegister(register);

      //Fields:
      register.addField(new CField(register, "OUTPUT_FREE_END", "", CField.FieldType.RW, 24, 8, 0xff));
      register.addField(new CField(register, "OUTPUT_FREE_START", "", CField.FieldType.RO, 16, 8, 0x0));
      register.addField(new CField(register, "INPUT_FREE_END", "", CField.FieldType.RO, 8, 8, 0x0));
      register.addField(new CField(register, "INPUT_FREE_START", "", CField.FieldType.RW, 0, 8, 0x0));

      /***************************************************************
      * Register: DPRAM
      * Offset: 0x1000
      ****************************************************************/
      register = new CRegister(external, "DPRAM", "null", 0x1000);
      external.addRegister(register);

      //Fields:
      register.addField(new CField(register, "data", "null", CField.FieldType.RW, 0, 32, 0x0));


 }

}

