/*****************************************************************************
**  $HeadURL:$
**  $Revision:$
**  $Date:$
**
**  MODULE: regfile_i2c
**
**  DESCRIPTION: Register file of the regfile_i2c module
**
**
**  DO NOT MODIFY MANUALLY.
**
**  FDK IDE Version: 4.7.0_beta3
**  Build ID: I20191219-1127
**
**  COPYRIGHT (c) 2011 Matrox Electronic Systems Ltd.
**  All Rights Reserved
**
*****************************************************************************/
public class Cregfile_i2c  extends CRegisterFile {


   public Cregfile_i2c()
   {
      super("regfile_i2c", 12, 32, true);

      CSection section;
      CExternal external;
      CRegister register;

      /***************************************************************
      * Section: I2C
      * Offset: 0x0
      ****************************************************************/
      section = new CSection(this, "I2C", "null", 0x0);
      super.childrenList.add(section);

      /***************************************************************
      * Register: I2C_ID
      * Offset: 0x0
      ****************************************************************/
      register = new CRegister(section, "I2C_ID", "null", 0x0);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "CLOCK_STRETCHING", "null", CField.FieldType.RO, 17, 1, 0x0));
      register.addField(new CField(register, "NI_ACCESS", "null", CField.FieldType.RO, 16, 1, 0x0));
      register.addField(new CField(register, "ID", "null", CField.FieldType.STATIC, 0, 12, 0x12c));

      /***************************************************************
      * Register: I2C_CTRL0
      * Offset: 0x8
      ****************************************************************/
      register = new CRegister(section, "I2C_CTRL0", "I2C Control Register 0", 0x8);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "I2C_INDEX", "I2C Index", CField.FieldType.RW, 24, 8, 0x0));
      register.addField(new CField(register, "NI_ACC", "Non Indexed I2C access", CField.FieldType.RW, 23, 1, 0x0));
      register.addField(new CField(register, "BUS_SEL", "I2C BUS selection", CField.FieldType.STATIC, 17, 2, 0x0));
      register.addField(new CField(register, "TRIGGER", "Trigger", CField.FieldType.WO, 16, 1, 0x0));
      register.addField(new CField(register, "I2C_DATA_READ", "I2C Data Read", CField.FieldType.RO, 8, 8, 0x0));
      register.addField(new CField(register, "I2C_DATA_WRITE", "I2C Data Write", CField.FieldType.RW, 0, 8, 0x0));

      /***************************************************************
      * Register: I2C_CTRL1
      * Offset: 0x10
      ****************************************************************/
      register = new CRegister(section, "I2C_CTRL1", "I2C Control Register 1", 0x10);
      section.addRegister(register);

      //Fields:
      register.addField(new CField(register, "I2C_ERROR", "Error", CField.FieldType.RO, 28, 1, 0x0));
      register.addField(new CField(register, "BUSY", "Busy", CField.FieldType.RO, 27, 1, 0x0));
      register.addField(new CField(register, "WRITING", "Writing", CField.FieldType.RO, 26, 1, 0x0));
      register.addField(new CField(register, "READING", "Reading", CField.FieldType.RO, 25, 1, 0x0));
      register.addField(new CField(register, "I2C_DEVICE_ID", "I2C Device ID", CField.FieldType.RW, 1, 7, 0x44));
      register.addField(new CField(register, "I2C_RW", "I2C Read/Write", CField.FieldType.RW, 0, 1, 0x1));


 }

}


