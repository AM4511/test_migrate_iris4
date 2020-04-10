package com.matrox.models;

public class LegacyInterruptMessage {
	String type;
	double time;
	String units;


	public LegacyInterruptMessage()
	{
		super();
		this.type = "";
		this.time = 0;
		this.units = "ns";
	}


	/**
	 * @return the type
	 */
	public String getType()
	{
		return type;
	}


	/**
	 * @param type
	 *            the type to set
	 */
	public void setType(String type)
	{
		this.type = type;
	}


	/**
	 * @return the time
	 */
	public double getTime()
	{
		return time;
	}


	/**
	 * @param time
	 *            the time to set
	 */
	public void setTime(double time, String units)
	{
		this.time = time;
		this.units = units.trim();
	}


	/**
	 * @return the units
	 */
	public String getUnits()
	{
		return units;
	}


	/**
	 * @param units
	 *            the units to set
	 */
	public void setUnits(String units)
	{
		this.units = units;
	}

}
