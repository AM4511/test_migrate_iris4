package com.matrox.models;

import java.util.ArrayList;

import com.fdk.validation.core.FDKConsole;

public class TlpPacket {

	private String name;

	private TlpHeader header;
	private int maxPayloadSize;
	private ArrayList<Integer> payload;
	private int tlpDigest;


	public TlpPacket(String name)
	{
		this.name = name;
		this.header = new TlpHeader();
		this.maxPayloadSize = 256; // in DWords
		this.payload = new ArrayList<Integer>();
		this.tlpDigest = -1;
	}


	/**
	 * @return the name
	 */
	public String getName()
	{
		return name;
	}


	/**
	 * @param name
	 *            the name to set
	 */
	public void setName(String name)
	{
		this.name = name;
	}


	/**
	 * @return the header
	 */
	public TlpHeader getHeader()
	{
		return header;
	}


	/**
	 * @param header
	 *            the header to set
	 */
	public void setHeader(TlpHeader header)
	{
		this.header = header;
	}


	/**
	 * @return the maxPayloadSize
	 */
	public int getMaxPayloadSize()
	{
		return maxPayloadSize;
	}


	/**
	 * @param maxPayloadSize
	 *            the maxPayloadSize to set
	 */
	public void setMaxPayloadSize(int maxPayloadSize)
	{
		if (maxPayloadSize >= 0 & maxPayloadSize <= 256)
		{
			this.maxPayloadSize = maxPayloadSize;

		}
		else
		{
			String message = String.format("%d is out of range", maxPayloadSize);
			FDKConsole.addErrorMessage(message);
		}
	}


	/**
	 * @return the payload
	 */
	public ArrayList<Integer> getPayload()
	{
		return payload;
	}


	/**
	 * @param payload
	 *            the payload to set
	 */
	public void setPayload(ArrayList<Integer> payload)
	{
		if (payload != null)
		{
			this.payload = payload;
			return;
		}
	}


	/**
	 * @return the tlpDigest
	 */
	public int getTlpDigest()
	{
		return tlpDigest;
	}


	/**
	 * @param tlpDigest
	 *            the tlpDigest to set
	 */
	public void setTlpDigest(int tlpDigest)
	{
		this.tlpDigest = tlpDigest;
	}


	public void addPayloadData(int dwData)
	{
		int payloadSizeInDW = this.payload.size();
		if (payloadSizeInDW <= this.maxPayloadSize)
		{
			this.payload.add(new Integer(dwData));
		}
		else
		{
			String message = String.format("Payload is full. Value is %d DW", payloadSizeInDW);
			FDKConsole.addErrorMessage(message);
		}
	}


	public void addPayloadData(int[] dwData)
	{
		for (int i : dwData)
		{
			addPayloadData(i);
		}
	}


	public int getlength()
	{
		if (this.payload == null)
		{
			return -1;
		}
		else
		{
			return this.payload.size();
		}
	}

}
