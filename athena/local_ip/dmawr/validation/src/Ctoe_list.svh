/****************************************************************************
 * Ctoe_list.svh
 ****************************************************************************/

/**
 * Class: Ctoe_list
 *
 * TODO: Add class documentation
 */
import gev_pkg::*;
import network_pkg::*;

class Ctoe_list;
	const int END_OF_LIST_MARKER = 32'hffffffff;
	Cethernet_frame frame_list[$];
	int data[$];


	function new();
	endfunction


	function void add_frame (Cethernet_frame frame);
		this.frame_list.push_back(frame);
	endfunction


	function void buildlist();
		stream_t eth_stream;
		stream32_t eth_stream32;

		Cethernet_frame current_frame;
		int number_of_frame;
		int frame_reference_entry;
		int frame_offset;
		int frame_size;
		int list_size;

		number_of_frame = this.frame_list.size();

		// Add the End Of List Marker in the table index
		for (int i=0; i<=number_of_frame; i++) begin
			this.data.insert(i,END_OF_LIST_MARKER);
		end

		// Calculate the current frame offset in byte
		frame_offset = 4*(number_of_frame+1);

		for (int i=0; i<number_of_frame; i++) begin
			int eth_stream32_size;
			byte crc_garbage_byte;
			// Retrieve the message
			current_frame = frame_list[i];
			eth_stream = current_frame.serialize();

			// Remove the CRC32 garbage bytes
			for(int c=0; c<4; c++) begin
				crc_garbage_byte =  eth_stream.pop_back();
			end
			
			//Pad if required to align the payload on 32 bits boundaries
			// Requested by the EthernetLite controller
			while (eth_stream.size % 4 > 0 ) begin
				eth_stream.push_back(0);
			end

			// Convert the Ethernet frame to a 32 bits little endian stream
			eth_stream32 = stream_to_stream32_reverse(eth_stream);

			// Add the message pointer in the table index list (Table Of Content)
			// The unit of the Frame pointer are in Byte (4*frame_offset)
			frame_size = eth_stream.size() & 7'h7f;
			frame_reference_entry = ((frame_size << 16) | (frame_offset & 12'hfff));

			this.data[i] = frame_reference_entry;

			// Add the current Ethernet frame in the TOE list @ frame_offset
			eth_stream32_size = eth_stream32.size();
			for (int j=0; j<eth_stream32_size; j++) begin
				this.data.insert(frame_offset/4, eth_stream32.pop_front());
				frame_offset+=4;
			end
		end
	endfunction


endclass


