%=================================================================
%  $HeadURL:$
%  $Revision:$
%  $Date:$
%  $Author:$
%
%  MODULE: regfile_i2c
%
%  DESCRIPTION: Register file of the regfile_i2c module
%
%  FDK IDE Version: 4.7.0_beta4
%  Build ID: I20191220-1537
%  
%  DO NOT MODIFY MANUALLY.
%
%=================================================================



variable TEST = 1;
variable NO_TEST = 0;
variable i;		%index used for filling tables used in Group registers.

%=================================================================
% SECTION NAME	: I2C
%=================================================================
Section("I2C", 0, 0x0);

Register("i2c_id", 0x0, 4, "null");
		Field("clock_stretching", 17, 17, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue("Clock stretching not supported", 0);
			FieldValue("Clock stretching supported", 1);
		Field("ni_access", 16, 16, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "null");
			FieldValue(" Write to I2C device without address cycle is NOT supported", 0);
			FieldValue(" Write to I2C device without address cycle is supported", 1);
		Field("id", 11, 0, "rd", 0x0, 0x012C, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");

Register("i2c_ctrl0", 0x8, 4, "I2C Control Register 0");
		Field("i2c_index", 31, 24, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "I2C Index");
		Field("ni_acc", 23, 23, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "Non Indexed I2C access");
			FieldValue("Indexed Read/write operation on I2C bus", 0);
			FieldValue("Non indexed Read/Write", 1);
		Field("bus_sel", 18, 17, "rd", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "I2C BUS selection");
		Field("trigger", 16, 16, "rd|wr", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Trigger");
		Field("i2c_data_read", 15, 8, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "I2C Data Read");
		Field("i2c_data_write", 7, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, TEST, 0, 0, "I2C Data Write");

Register("i2c_ctrl1", 0x10, 4, "I2C Control Register 1");
		Field("i2c_error", 28, 28, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Error");
			FieldValue("Normal operation", 0);
			FieldValue("An error Ocured", 1);
		Field("busy", 27, 27, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Busy");
			FieldValue("Not Currently Busy", 0);
			FieldValue("Currently Busy", 1);
		Field("writing", 26, 26, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Writing");
			FieldValue("Not currently writing", 0);
			FieldValue("Currently writing", 1);
		Field("reading", 25, 25, "rd", 0x0, 0x0, 0x0, 0x0, NO_TEST, 0, 0, "Reading");
			FieldValue("Not currently reading", 0);
			FieldValue("Currently reading", 1);
		Field("i2c_device_id", 7, 1, "rd|wr", 0x0, 0x44, 0xffffffff, 0xffffffff, TEST, 0, 0, "I2C Device ID");
		Field("i2c_rw", 0, 0, "rd|wr", 0x0, 0x1, 0xffffffff, 0xffffffff, TEST, 0, 0, "I2C Read/Write");
			FieldValue("Write cycle", 0);
			FieldValue("Read cycle", 1);

Register("i2c_semaphore", 0x18, 4, "null");
		Field("i2c_in_use", 0, 0, "rd|wr", 0x0, 0x0, 0xffffffff, 0xffffffff, NO_TEST, 0, 0, "null");


