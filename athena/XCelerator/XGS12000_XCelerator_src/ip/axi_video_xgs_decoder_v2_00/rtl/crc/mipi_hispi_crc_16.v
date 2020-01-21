///////////////////////////////////////////////////////////////////////////////
// $Id: mipi_hispi_crc_16.v.rca 1.1 Tue Feb 16 12:27:27 2016 molarte Experimental $
// $Name:  $
//
// CONFIDENTIAL AND PROPRIETARY TO APTINA IMAGING INC    
//
// Aptina Imaging UK Design Centre, Bracknell
//
// Confidential and proprietary information of Aptina Imaging, Inc
// Do not copy or distribute without the prior written permission
// of Aptina Imaging.
//
// Copyright (c) 2009 Aptina Imaging Inc.
// All rights reserved. 
//
///////////////////////////////////////////////////////////////////////////////
//
//       Author: Steve Shaw
//      Created: 14-Jan-2009
//
//  Description: Parallel (16 bit) implementation of CRC polynomial 
//               x^16 + x^12 + x^5 + 1.
//               Based on an algorithm described in:
//                  http://www.nobugconsulting.com/crc_details.pdf
//               Data can be presented in 10,12,14 or 16-bit chunks. 
//
// Dependencies: 
//
///////////////////////////////////////////////////////////////////////////////

module mipi_hispi_crc_16 (
    
    input           clk,
    input           reset_n,
    input           hispi_streaming_en,     // Clock enable for registers associated with the HiSPi interface

    input           frame_valid,            // Frame valid from the sensor/soc odp
    input           data_to_crc_valid,      // Asserted when valid data is presented to 
                                            // the crc
    input           init_crc,               // When asserted resets the crc 
                                            // NOTE: data_to_crc_valid and init_crc must
                                            // be mutually exclusive by design 
    input   [15:0]  data_to_crc,            // Input to crc 
    input   [2:0]   pixel_depth_out,        // Width of pixels to be transmitted across HiSpi link
                                            // 'b011 = 8 bits 
                                            // 'b100 = 10 bits 
                                            // 'b101 = 12 bits
                                            // 'b110 = 14 bits
                                            // 'b111 = 16 bits

    output  [15:0]  hispi_checksum,          // Generated checksum

    input           test_start_checksum,    // When asserted (= 1) a 16-bit checksum will be 
                                            // calculated over the next complete frame
    output  [15:0]  test_checksum,          // If 'test_checksum_valid' is asserted then 
                                            // 'test_checksum' is a valid checksum calculated 
                                            // over a complete frame
    output  reg     test_checksum_valid     // If asserted (= 1) then 'test_checksum' is
                                            // outputing a valid checksum 

    );


    reg  [15:0]     data_from_crc_reg;
    reg  [2:0]      checksum_gen_state;
    reg             test_start_checksum_reg;

    wire [15:0]     data_from_crc_rev;
    wire [2:0]      checksum_gen_state_e;
    wire            test_checksum_valid_e;



    function [15:0] next_crc16_data1; // remainder of M(x)*x^16/P(x)
        input [15:0] data_from_crc;   // previous CRC value
        input B;                      // input data bit

        begin
            //                                                                                     x^12     x^5   x^0
            next_crc16_data1 = {data_from_crc[14:0], 1'b0} ^ ({16{(data_from_crc[15]^B)}} & 16'b0001_0000_0010_0001);
        end
    endfunction // next_crc16_data1
    

    function [15:0] next_crc16_data16;
        input [15:0] data_from_crc;
        input [15:0] inp;

        integer i;
        begin

            next_crc16_data16 = next_crc16_data14(data_from_crc, inp[13:0]);
            for(i=14; i<=15; i=i+1)
                next_crc16_data16 = next_crc16_data1(next_crc16_data16, inp[i]);
        end
    endfunction // next_crc16_data16

    function [15:0] next_crc16_data14;
        input [15:0] data_from_crc;
        input [13:0] inp;

        integer i;
        begin

            next_crc16_data14 = next_crc16_data12(data_from_crc, inp[11:0]);
            for(i=12; i<=13; i=i+1)
                next_crc16_data14 = next_crc16_data1(next_crc16_data14, inp[i]);
        end
    endfunction // next_crc16_data14

    function [15:0] next_crc16_data12;
        input [15:0] data_from_crc;
        input [11:0] inp;

        integer i;
        begin

            next_crc16_data12 = next_crc16_data10(data_from_crc, inp[9:0]);
            for(i=10; i<=11; i=i+1)
                next_crc16_data12 = next_crc16_data1(next_crc16_data12, inp[i]);
        end
    endfunction // next_crc16_data12

    function [15:0] next_crc16_data10;
        input [15:0] data_from_crc;
        input [9:0] inp;

        integer i;
        begin

            next_crc16_data10 = next_crc16_data8(data_from_crc, inp[7:0]);
            for(i=8; i<=9; i=i+1)
                next_crc16_data10 = next_crc16_data1(next_crc16_data10, inp[i]);
        end
    endfunction // next_crc16_data10

    function [15:0] next_crc16_data8;
        input [15:0] data_from_crc;
        input [7:0] inp;

        integer i;
        begin

            next_crc16_data8 = data_from_crc;
            for(i=0; i<=7; i=i+1)
                next_crc16_data8 = next_crc16_data1(next_crc16_data8, inp[i]);
        end
    endfunction // next_crc16_data8


    // default is to leave it the way it is. init_crc takes priority over data_to_crc_valid

    assign data_from_crc_rev[15:0] = data_to_crc_valid ? 
                                     ((pixel_depth_out[2:0] == 3'b111)    ? next_crc16_data16(data_from_crc_reg[15:0],(data_to_crc[15:0] & {16{!init_crc}})) : 
                                      ((pixel_depth_out[2:0] == 3'b110)   ? next_crc16_data14(data_from_crc_reg[15:0],(data_to_crc[13:0] & {14{!init_crc}})) :
                                       ((pixel_depth_out[2:0] == 3'b101)  ? next_crc16_data12(data_from_crc_reg[15:0],(data_to_crc[11:0] & {12{!init_crc}})) :
                                        ((pixel_depth_out[2:0] == 3'b100) ? next_crc16_data10(data_from_crc_reg[15:0],(data_to_crc[9:0]  & {10{!init_crc}})) :
                                         (                                  next_crc16_data8(data_from_crc_reg[15:0],(data_to_crc[7:0]  & {8{!init_crc}}))))))) :
                                     data_from_crc_reg[15:0];

    // Bit ordering of the checksum is fundamentally the reverse of the ordering of the polynomial
    assign hispi_checksum[15:0] = {data_from_crc_reg[0], data_from_crc_reg[1] ,data_from_crc_reg[2], data_from_crc_reg[3],
                                   data_from_crc_reg[4], data_from_crc_reg[5] ,data_from_crc_reg[6], data_from_crc_reg[7],
                                   data_from_crc_reg[8], data_from_crc_reg[9] ,data_from_crc_reg[10],data_from_crc_reg[11],
                                   data_from_crc_reg[12],data_from_crc_reg[13],data_from_crc_reg[14],data_from_crc_reg[15]};   

    always @(posedge clk) 
    begin
        if (hispi_streaming_en)
        begin
            if ((init_crc && !test_start_checksum) || 
                (!frame_valid && !data_to_crc_valid && test_start_checksum && !test_checksum_valid_e))
                data_from_crc_reg[15:0] <= 16'hffff;
            else if (data_to_crc_valid && !test_checksum_valid)
                data_from_crc_reg[15:0] <= data_from_crc_rev[15:0];
            else
                data_from_crc_reg[15:0] <= data_from_crc_reg[15:0];
        end
    end


    // In normal operation (ie. generating checksums according to the MIPI/HiSPi specs) a new checksum is generated
    // for each line of the image. An additional test mode (specified by PE and controlled by test_start_checksum)
    // calculates a checksum across a complete frame (ie. the crc does not get re-initialised between rows) and the
    // following logic controls that

    assign checksum_gen_state_e[2:0] = ({3{(checksum_gen_state[0] && !frame_valid && test_start_checksum && !test_checksum_valid) ||
                                           (checksum_gen_state[1] &&  frame_valid &&  data_to_crc_valid) ||
                                           (checksum_gen_state[2] && !frame_valid && !data_to_crc_valid)}} & {checksum_gen_state[1:0], checksum_gen_state[2]}) |
                                       ({3{(checksum_gen_state[0] && !(!frame_valid && test_start_checksum && !test_checksum_valid)) ||
                                           (checksum_gen_state[1] && !( frame_valid &&  data_to_crc_valid)) ||
                                           (checksum_gen_state[2] && !(!frame_valid && !data_to_crc_valid))}} & checksum_gen_state[2:0]);

    always @(posedge clk or negedge reset_n)
    begin
        if (reset_n == 1'b0)
        begin
            checksum_gen_state[2:0] <= 3'b001;
        end
        else
        begin
            if (hispi_streaming_en)
            begin
                checksum_gen_state[2:0] <= checksum_gen_state_e[2:0];
            end
        end
    end

    assign test_checksum[15:0] = (hispi_checksum[15:0] & {16{test_start_checksum_reg}}) | {16{!test_start_checksum_reg}};
    assign test_checksum_valid_e = (checksum_gen_state[2] && !frame_valid && !data_to_crc_valid && test_start_checksum) ||
                                   (test_checksum_valid && test_start_checksum);
    
    always @(posedge clk or negedge reset_n)
    begin
        if (reset_n == 1'b0)
        begin
            test_checksum_valid <= 1'b0;
            test_start_checksum_reg <= 1'b0;
        end
        else
        begin
            if (hispi_streaming_en)
            begin
                test_checksum_valid <= test_checksum_valid_e;
                test_start_checksum_reg <= test_start_checksum;
            end
        end
    end

endmodule

// $Source: /vault/syncdata/sync-bnuk-srv1/2647/server_vault/Projects/circuits/LogicIP/release/mipi_hispi/mipi_hispi_tx/generic/R_ALPHA_1.71/rtl/mipi_hispi_crc_16.v.rca $
// $Log: mipi_hispi_crc_16.v.rca $
// 
//  Revision: 1.1 Tue Feb 16 12:27:27 2016 molarte
//  Checked in by lib_builder v1.33
// 
//  Revision: 1.8 Mon Oct 10 18:06:20 2011 sshaw
//  Added explicit clock gating throughout the code as requested by sensor
//  HS platform team (Imaging IP SPec 685)
//  Revision 1.7 Thu Nov 18 15:45:08 2010 sshaw
//  Changes made as requested in sync note ImagingIP Spec 583:
//  - addition of 'resync_code' insertion specifically for c1ea
//  - modified sync code of ActiveStart-SP8 such that the 8th word can
//  be specified to be something other than all 0s or all 1s
//  - bug fixed to allow the HiSPi interface to be able to exit and
//  re-enter standby without first having to transmit some data
//  Revision 1.6 Wed Sep  1 16:53:52 2010 sshaw
//  Updates to bring in line with protocol spec v1.5 and to make compatible
//  with 41is combined MIPI/HiSPi phy (slvdsmipislvs_tx_1c4d), includes:
//  - support for HiSPi 8-bit and 8+8-bit data
//  - optional HiSPi checksum transmission
//  - support for CMOS input and output paths
//  Revision 1.5 Mon Oct 19 11:25:25 2009 sshaw
//  Support added for the HiSPi 8+8-bit mode and 3 lane operation in hispiSP
//  mode debugged
// Revision 1.4 Fri Aug 21 15:48:14 2009 sshaw
// Following the backwards step taken to generate R_ALPHA_1.07 release,
// now check in all subsequent changes as a result of debugging MIPI 6-,
// 7- and 14-bit modes
// 
// Revision 1.3 Tue Mar  3 09:30:51 2009 sshaw
// Check-in following initial debug of the HiSPi interface (first 4 lane
// streaming mode test passing)
// 
// Revision 1.2 Fri Jan 16 16:30:02 2009 sshaw
// Added frame-wide checksum calculation to hispi crcs  (PE test mode)
// 
// Revision 1.1 Fri Jan 16 14:50:09 2009 sshaw
// Check in of first cut of rtl
// 
// 
// Local Variables:
// tab-width: 4
// verilog-library-extensions:(".v" ".vg")
// verilog-library-directories:(".")
// End:
