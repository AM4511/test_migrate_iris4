package com.matrox.models;

import com.fdk.validation.models.registerfile.CRegister;

public interface IUbusMaster {

	public void UbusComment(String message);

	public void UbusWrite(CRegister register);

	public void UbusWrite(long address, long value);

	public void UbusRead(CRegister register);

	public void UbusVerify(CRegister register, int ValueToVerify);
	
	public void UbusPoll(CRegister register, int PollingValue);



}
