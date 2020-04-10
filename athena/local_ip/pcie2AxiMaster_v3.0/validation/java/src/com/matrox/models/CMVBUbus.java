package com.matrox.models;

import com.fdk.validation.models.registerfile.CField;
import com.fdk.validation.models.registerfile.CRegister;
import com.fdk.validation.models.registerfile.CRegisterFile;

/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: MVBUbus
**
**  DESCRIPTION: Register file of the MVBUbus module
**
**
**  REGISTER ADDRESSES IN THIS FILE WERE MODIFIED MANUALLY. DO NOT 
**  REGENERATE WITH FDK-IDE TOOL AS THE ADDRESS GENERATION WILL BE WRONG!!!
**
**  COPYRIGHT (c) 2015 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class CMVBUbus  extends CRegisterFile {


   public CMVBUbus()
   {
      super("MVBUbus", 12, 32, true);

      CRegister register;
      /***************************************************************
      * Register: TB_RESET_UBUS
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(this, "TB_RESET_UBUS", "Testbench asserted reset timer", 0x0);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the testbench reset timer", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_WAIT1_UBUS
      * Offset: 0x1
      ****************************************************************/
      register = new CRegister(this, "TB_WAIT1_UBUS", "null", 0x1);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the wait state timer", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_WAIT2_UBUS
      * Offset: 0x2
      ****************************************************************/
      register = new CRegister(this, "TB_WAIT2_UBUS", "null", 0x2);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the wait state timer", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_WAIT3_UBUS
      * Offset: 0x3
      ****************************************************************/
      register = new CRegister(this, "TB_WAIT3_UBUS", "null", 0x3);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the wait state timer", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_POLL_MASK_UBUS
      * Offset: 0x6
      ****************************************************************/
      register = new CRegister(this, "TB_POLL_MASK_UBUS", "null", 0x6);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of tmask", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_READ_MASK_UBUS
      * Offset: 0x7
      ****************************************************************/
      register = new CRegister(this, "TB_READ_MASK_UBUS", "null", 0x7);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of read mask", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: TB_POLL_TIMER_LIMIT_UBUS
      * Offset: 0xa
      ****************************************************************/
      register = new CRegister(this, "TB_POLL_TIMER_LIMIT_UBUS", "null", 0xa);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of tmask", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: PKT_CMD_UBUS
      * Offset: 0xb00
      ****************************************************************/
      register = new CRegister(this, "PKT_CMD_UBUS", "null", 0xb00);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the command", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: PKT_ADDR_HIGH_UBUS
      * Offset: 0xb01
      ****************************************************************/
      register = new CRegister(this, "PKT_ADDR_HIGH_UBUS", "null", 0xb01);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the command address (High part)", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: PKT_ADDR_LOW_UBUS
      * Offset: 0xb02
      ****************************************************************/
      register = new CRegister(this, "PKT_ADDR_LOW_UBUS", "null", 0xb02);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the command address (Low part)", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: PKT_BYTE_COUNT_UBUS
      * Offset: 0xb03
      ****************************************************************/
      register = new CRegister(this, "PKT_BYTE_COUNT_UBUS", "null", 0xb03);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the command address (Low part)", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: PKT_DATA_UBUS
      * Offset: 0xb06
      ****************************************************************/
      register = new CRegister(this, "PKT_DATA_UBUS", "null", 0xb06);
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "value", "Value of the command address (Low part)", CField.FieldType.RW, 0, 32, 0x0));

      /***************************************************************
      * Register: CL_BUS_CONTROL
      * Offset: 0x84
      ****************************************************************/
      register = new CRegister(this, "CL_BUS_CONTROL", "null", 0x84);//done
      super.getChildrenList().add(register);

      //Fields:
      register.addField(new CField(register, "cl_clk_resetN", "null", CField.FieldType.RW, 0, 1, 0x0));
      register.addField(new CField(register, "cl_bus_resetN", "null", CField.FieldType.RW, 28, 1, 0x0));

 }

}

