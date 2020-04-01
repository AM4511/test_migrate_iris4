package com.matrox.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;
import com.fdk.validation.models.registerfile.CSection;

/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: fintek_F81216
**
**  DESCRIPTION: Register file of the fintek_F81216 module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.5.0_beta5
**  Build ID: I20151222-1010
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cfintek_F81216  extends CRegisterFile {


   public Cfintek_F81216()
   {
      super("fintek_F81216", 12, 8, true);

      CSection section;
      CRegister register;
      /***************************************************************
      * Section: ctrl
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "ctrl", "Control Register", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: reserved_space
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "reserved_space", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 0, 1, 0x0));

      /***************************************************************
      * Register: software_reset
      * Offset: 0x2
      ****************************************************************/
      register = new CRegister(section, "software_reset", "Software Reset Register", 0x2);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "swrst", "Software Reset", CField.FieldType.WO, 0, 1, 0x0));

      /***************************************************************
      * Register: ldn
      * Offset: 0x7
      ****************************************************************/
      register = new CRegister(section, "ldn", "Logic Device Select Register", 0x7);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "null", CField.FieldType.RW, 0, 4, 0x0));

      /***************************************************************
      * Register: device_id0
      * Offset: 0x20
      ****************************************************************/
      register = new CRegister(section, "device_id0", "Device ID Register– index 20h", 0x20);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "The unique value of this register", CField.FieldType.STATIC, 0, 8, 0x2));

      /***************************************************************
      * Register: device_id1
      * Offset: 0x21
      ****************************************************************/
      register = new CRegister(section, "device_id1", "Device ID Register– index 21h", 0x21);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "The unique value of this register", CField.FieldType.STATIC, 0, 8, 0x8));

      /***************************************************************
      * Register: vendor_id0
      * Offset: 0x23
      ****************************************************************/
      register = new CRegister(section, "vendor_id0", "Vendor ID Register– index 23h (High byte)", 0x23);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "The unique value of this register", CField.FieldType.STATIC, 0, 8, 0x19));

      /***************************************************************
      * Register: vendor_id1
      * Offset: 0x24
      ****************************************************************/
      register = new CRegister(section, "vendor_id1", "Vendor ID Register– index 24h (Low byte)", 0x24);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "value", "The unique value of this register", CField.FieldType.STATIC, 0, 8, 0x34));

      /***************************************************************
      * Register: clock_src_sel
      * Offset: 0x25
      ****************************************************************/
      register = new CRegister(section, "clock_src_sel", "Clock Source Select Register – index 25h", 0x25);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "clk_sel", "The clock sourse selection bit ", CField.FieldType.STATIC, 0, 1, 0x0));


      /***************************************************************
      * Section: uart[3:0]
      * Offset: 0x100 + (i * 0x80) 
      ****************************************************************/
      for (int i = 0; i < 4; i++)
      {
         long sectionOffset = 0x100 + (i * 0x80);
         section = new CSection(this, "uart", "UART[ldn] Device Control Register", sectionOffset, true, i);
         super.childrenList.add(section);

         /************************************************************
         * Register: reserved_space
         * Offset: 0x0
         *************************************************************/
         register = new CRegister(section, "reserved_space", "null", 0x0);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "reserved", "null", CField.FieldType.STATIC, 0, 1, 0x0));

         /************************************************************
         * Register: device_en
         * Offset: 0x30
         *************************************************************/
         register = new CRegister(section, "device_en", "Device Enable Register – index 30h", 0x30);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "URA_EN", "null", CField.FieldType.RW, 0, 1, 0x0));

         /************************************************************
         * Register: io_port_sel0
         * Offset: 0x60
         *************************************************************/
         register = new CRegister(section, "io_port_sel0", "I/O Port Select Register – index 60h", 0x60);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "value", "null", CField.FieldType.RO, 0, 8, 0x0));

         /************************************************************
         * Register: io_port_sel1
         * Offset: 0x61
         *************************************************************/
         register = new CRegister(section, "io_port_sel1", "I/O Port Select Register – index 61h", 0x61);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "value", "null", CField.FieldType.RO, 0, 8, 0x0));

         /************************************************************
         * Register: irq_chan_sel
         * Offset: 0x70
         *************************************************************/
         register = new CRegister(section, "irq_chan_sel", "IRQ Channel Select Register – index 70h", 0x70);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "sel_sirq", "Select the Serial IRQ channel.", CField.FieldType.RO, 0, 4, 0x0));
         register.addField(new CField(register, "irq_share", "Select the Serial IRQ channel.", CField.FieldType.RO, 4, 1, 0x0));
         register.addField(new CField(register, "irq_mode", "IRQ operation mode", CField.FieldType.RO, 5, 1, 0x0));

         /************************************************************
         * Register: clock_sel
         * Offset: 0x71
         *************************************************************/
         register = new CRegister(section, "clock_sel", "UART[n]Clock Select Register", 0x71);
         section.addRegister(register);

         //Fields:
         register.addField(new CField(register, "source", "Clock source", CField.FieldType.STATIC, 0, 2, 0x0));
         register.addField(new CField(register, "txw4c_ira", "Clock source", CField.FieldType.RW, 2, 1, 0x0));
         register.addField(new CField(register, "rxw4c_ira", "Clock source", CField.FieldType.RW, 3, 1, 0x0));

      }


 }

}

