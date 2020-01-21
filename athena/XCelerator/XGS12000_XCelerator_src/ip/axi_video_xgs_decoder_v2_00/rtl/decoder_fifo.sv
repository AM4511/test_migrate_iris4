//`include "common_functions.vh"

`define CLOG2(x) \
   (x <= 2) ? 1 : \
   (x <= 4) ? 2 : \
   (x <= 8) ? 3 : \
   (x <= 16) ? 4 : \
   (x <= 32) ? 5 : \
   (x <= 64) ? 6 : \
   (x <= 128) ? 7 : \
   (x <= 256) ? 8 : \
   (x <= 512) ? 9 : \
   (x <= 1024) ? 10 : \
   (x <= 2048) ? 11 : \
   (x <= 4096) ? 12 : \
   (x <= 8192) ? 13 : \
   (x <= 16384) ? 14 : \
   (x <= 32768) ? 15 : \
   16

module decoder_fifo #(
  parameter C_FAMILY = "ULTRASCALE",
  parameter MAX_DATAWIDTH = 12,
  parameter NROF_CONTR_CONN = 12,
  parameter PROG_EMPTY_THRESH = 5,
  parameter PROG_FULL_THRESH = MAX_DATAWIDTH*NROF_CONTR_CONN-1,
  parameter FIFO_READ_LATENCY = 1,
  parameter READ_MODE_SHOW_AHEAD = 1,
  parameter DEPTH = 1024
)(
  input wire clock,

  input wire fifo_en,

  output wire fifo_empty,
  output wire fifo_aempty,
  output wire fifo_full,
  output wire fifo_afull,
  input wire fifo_rden,
  output wire [MAX_DATAWIDTH * NROF_CONTR_CONN -1 : 0] fifo_dout,
  input wire fifo_reset,
  input wire fifo_wren,
  input wire [MAX_DATAWIDTH * NROF_CONTR_CONN -1 : 0] fifo_din,

  input wire  sof_in,
  output wire sof_out,
  input wire  eof_in,
  output wire eof_out,
  input wire  sol_in,
  output wire sol_out,
  input wire  eol_in,
  output wire eol_out,


  output wire error
);

  wire overflow;
  wire underflow;

  wire [MAX_DATAWIDTH * NROF_CONTR_CONN + 3 : 0] video_din;
  wire [MAX_DATAWIDTH * NROF_CONTR_CONN + 3 : 0] video_dout;

  //xilinx fifo
  generate
  if ((C_FAMILY == "ULTRASCALE") || (C_FAMILY == "VIRTEX7") || (C_FAMILY == "kintexu")) begin
    // Permitted value for DATA_COUNT_WIDTH is
    // 1 and log2(FIFO_DEPTH)+1
    localparam DEPTH_XIL = DEPTH *2;
    localparam PROG_FULL_THRESH_XIL = DEPTH_XIL - 32;
    localparam DATA_COUNT_WIDTH = (`CLOG2(DEPTH_XIL)) + 1;
    localparam READ_MODE = (READ_MODE_SHOW_AHEAD == 1) ? "fwft" : "std";

    wire [DATA_COUNT_WIDTH-1:0] wr_data_count;
    wire [DATA_COUNT_WIDTH-1:0] rd_data_count;

    xpm_fifo_sync # (
        // Common module parameters
        .FIFO_MEMORY_TYPE ("auto"),
        .ECC_MODE ("no_ecc"),
        .FIFO_WRITE_DEPTH (DEPTH_XIL), //positive integer
        .WRITE_DATA_WIDTH (MAX_DATAWIDTH * NROF_CONTR_CONN + 4), //positive integer
        .WR_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
        .PROG_FULL_THRESH (PROG_FULL_THRESH_XIL), //positive integer
        .FULL_RESET_VALUE (0), //positive integer; 0 or 1
        .READ_MODE (READ_MODE), //string; "std" or "fwft";
        .FIFO_READ_LATENCY (FIFO_READ_LATENCY), //positive integer;
        .READ_DATA_WIDTH (MAX_DATAWIDTH * NROF_CONTR_CONN + 4), //positive integer
        .RD_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
        .PROG_EMPTY_THRESH (PROG_EMPTY_THRESH), //positive integer
        .DOUT_RESET_VALUE ("0"), //string
        .WAKEUP_TIME (0) //positive integer; 0 or 2;
    ) xpm_fifo_sync_inst (

    // Common module ports
    .sleep (1'b0),
    .rst (fifo_reset),

     // Write Domain ports
    .wr_clk (clock),
    .wr_en (fifo_wren),
    .din (video_din),
    .full (fifo_full),
    .prog_full (fifo_afull),
    .wr_data_count (),
    .overflow(overflow),
    .wr_rst_busy(),
    .almost_full(),
    .wr_ack(),

  // Read Domain ports
    .rd_en (fifo_rden),
    .dout (video_dout),
    .empty (fifo_empty),
    .prog_empty (fifo_aempty),
    .rd_data_count (),
    .underflow (underflow),
    .rd_rst_busy (),
    .almost_empty (),
    .data_valid (),

  // ECC Related ports
    .injectsbiterr (1'b0),
    .injectdbiterr (1'b0),
    .sbiterr (),
    .dbiterr ()
    );
 
    //
 end else if ((C_FAMILY == "ALTERA") || (C_FAMILY == "CYCLONE10")) begin
  
  localparam WIDTHU = (`CLOG2(DEPTH));
  localparam lpm_showahead = (READ_MODE_SHOW_AHEAD == 1) ? "ON" : "OFF";
  
  scfifo  # (
        // Common module parameters
        .lpm_width(MAX_DATAWIDTH * NROF_CONTR_CONN + 4),
        .lpm_widthu ( WIDTHU),
        .lpm_numwords (DEPTH),
        .lpm_showahead (lpm_showahead),   
        //scfifo_inst.lpm_showahead  = "ON",
        .lpm_type("scfifo"),
        .lpm_hint ("DISABLE_SCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE"),
        .intended_device_family ("Cyclone 10 GX"),
        .underflow_checking("ON"),
        .overflow_checking ("ON"),
        .allow_rwcycle_when_full("OFF"),
        .use_eab ("ON"),
        .add_ram_output_register("OFF"),
        .almost_full_value(0),
        .ram_block_type("AUTO"),
        .almost_empty_value (0),
        .maximum_depth (0),
        .enable_ecc ("FALSE")
    ) scfifo_inst(
    .data (video_din),
    .clock (clock),
    .wrreq (fifo_wren),
    .rdreq (fifo_rden),
    .aclr (1'b0),
    .sclr (fifo_reset),
    .q (video_dout),
    .eccstatus (),
    .usedw (),
    .full (fifo_full),
    .empty (fifo_empty),
    .almost_full (fifo_afull),
    .almost_empty (fifo_aempty));
   

  
    assign overflow = 1'b0;
    assign underflow = 1'b0;
  end
    
  endgenerate



assign fifo_dout = video_dout[MAX_DATAWIDTH * NROF_CONTR_CONN +3:4];
assign sof_out = video_dout[3];
assign sol_out = video_dout[2];
assign eof_out = video_dout[1];
assign eol_out = video_dout[0];

assign video_din = {fifo_din ,sof_in ,sol_in ,eof_in ,eol_in};

assign error = overflow | underflow;

endmodule

