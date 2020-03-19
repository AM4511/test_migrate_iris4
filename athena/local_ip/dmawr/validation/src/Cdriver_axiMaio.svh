/****************************************************************************
 * Cdriver_maio.svh
 ****************************************************************************/

/**
 * Class: Cdriver_maio
 *
 * TODO: Add class documentation #(1,6)   #(int NUMB_INPUT_IO = 8, int NUMB_OUTPUT_IO = 8)  
 */
import driver_pkg::*;

class Cdriver_axiMaio extends Cdriver_axil #(8,8);
	int packet_id;
	int timeout;
	longint dest_mac_addr;
	longint src_mac_addr;

	int dest_ip_addr;
	int src_ip_addr;

	int dest_udp_port;
	int src_udp_port;

	static   int BASE_ADDR_ToE[4] = {'hD00,'hD80,'hE00,'hE80};
	static   int BASE_ADDR_ToE_MSG_LIST[4] = {'h1000,'h2000,'h3000,'h4000};
	static   int REG_OFFSET_REQUEST_ID_RANGE = 'h8;
	static   int REG_OFFSET_STATUS = 'hC;
	static   int REG_OFFSET_TRIGGER = 'h4;
	static   int REG_OFFSET_IRQ_EN = 'h10;
	static   int IRQ0_ID =0;
	static   int REG_OFFSET_IRQ_STATUS = 'h14;
	static   int REG_OFFSET_DEBUG = 'h18;
	static   int AXI_LITE_ETHERNET_SLAVE_OFFSET = 0;
	static   int ALE_GIE_OFFSET = 'h7F8;
	static   int ALE_RX_CTRL_OFFSET = 'h17FC;

	function new(virtual axi_lite_interface axil, virtual io_interface  #(8,8) gpio);
		super.new(axil,gpio);
		this.packet_id = 0;
		this.timeout = 100;
		this.dest_mac_addr = 64'h000000005E00FACE;
		this.src_mac_addr =  64'h0000000000000000;
		this.dest_ip_addr = 0;
		this.src_ip_addr =  0;
		this.dest_udp_port = 0;
		this.src_udp_port = 0;
	endfunction


	task  write_toe_buffer(input int toe_id, input Ctoe_buffer toe_buffer);
		int write_address;
		int write_data;
		int write_strb;
		int buffer_size;


		buffer_size = toe_buffer.get_max_size();

		for (int i=0; i< buffer_size; i++) begin
			write_address = BASE_ADDR_ToE_MSG_LIST[toe_id] + i*4;
			write_data = toe_buffer.data[i];
			write_strb = 32'hff;
			super.write(write_address, write_data, write_strb, this.timeout);
		end

	endtask

endclass


