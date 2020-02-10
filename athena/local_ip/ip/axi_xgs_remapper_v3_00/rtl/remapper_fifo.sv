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

module remapper_fifo #(
  parameter C_FAMILY = "kintexu",
  parameter DATAWIDTH = 384,
  parameter DEPTH = 1024,
  parameter PROG_FULL_THRESH = 800,
  parameter READ_MODE_SHOW_AHEAD = 1 
)(
  input wire clock,

  output wire fifo_empty,
  output wire fifo_full,
  output wire fifo_progfull,
  output wire fifo_progempty,
  output wire fifo_error,
  input wire fifo_rden,
  output wire [DATAWIDTH -1 : 0] fifo_dout,
  input wire fifo_reset,
  input wire fifo_wren,
  input wire [DATAWIDTH -1 : 0] fifo_din
);

  wire overflow;
  wire underflow;

  //xilinx fifo
  generate
  if ((C_FAMILY == "ULTRASCALE") || (C_FAMILY == "VIRTEX7") || (C_FAMILY == "virtexu") || (C_FAMILY == "virtexuplus") || (C_FAMILY == "kintexu") || (C_FAMILY == "kintexuplus")) begin
    // Permitted value for DATA_COUNT_WIDTH is
    // 1 and log2(FIFO_DEPTH)+1
    localparam DEPTH_XIL = DEPTH *2;
    localparam PROG_FULL_THRESH_XIL = PROG_FULL_THRESH *2;
    localparam DATA_COUNT_WIDTH = (`CLOG2(DEPTH_XIL)) + 1;
    localparam READ_MODE = (READ_MODE_SHOW_AHEAD == 1) ? "fwft" : "std";

    wire [DATA_COUNT_WIDTH-1:0] wr_data_count;
    wire [DATA_COUNT_WIDTH-1:0] rd_data_count;

    xpm_fifo_sync # (
        // Common module parameters
        .FIFO_MEMORY_TYPE ("auto"),
        .ECC_MODE ("no_ecc"),
        .FIFO_WRITE_DEPTH (DEPTH_XIL), //positive integer
        .WRITE_DATA_WIDTH (DATAWIDTH), //positive integer
        .WR_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
        .PROG_FULL_THRESH (PROG_FULL_THRESH_XIL), //positive integer
        .FULL_RESET_VALUE (0), //positive integer; 0 or 1
        .READ_MODE (READ_MODE), //string; "std" or "fwft";
        .FIFO_READ_LATENCY (1), //positive integer;
        .READ_DATA_WIDTH (DATAWIDTH), //positive integer
        .RD_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
        .PROG_EMPTY_THRESH (5), //positive integer
        .DOUT_RESET_VALUE ("0"), //string
        .WAKEUP_TIME (0) //positive integer; 0 or 2;
    ) xpm_fifo_sync_inst (

    // Common module ports
    .sleep (1'b0),
    .rst (fifo_reset),

     // Write Domain ports
    .wr_clk (clock),
    .wr_en (fifo_wren),
    .din (fifo_din),
    .full (fifo_full),
    .prog_full (fifo_progfull),
    .wr_data_count (),
    .overflow(overflow),
    .wr_rst_busy(),
    .almost_full(),
    .wr_ack(),

  // Read Domain ports
    .rd_en (fifo_rden),
    .dout (fifo_dout),
    .empty (fifo_empty),
    .prog_empty (fifo_progempty),
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


  //altera fifo
  end else if ((C_FAMILY == "ALTERA") || (C_FAMILY == "CYCLONE10")) begin
  
  localparam WIDTHU = (`CLOG2(DEPTH));
  localparam lpm_showahead = (READ_MODE_SHOW_AHEAD == 1) ? "ON" : "OFF";
  
        
  scfifo # (
        .lpm_width (DATAWIDTH),
        .lpm_widthu (WIDTHU),
        .lpm_numwords (DEPTH),
        .lpm_showahead (lpm_showahead),
        .lpm_type ("scfifo"),
        .lpm_hint ("DISABLE_SCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE"),
        .intended_device_family ("Cyclone 10 GX"),
        .underflow_checking ("ON"),
        .overflow_checking ("ON"),
        .allow_rwcycle_when_full ("OFF"),
        .use_eab ("ON"),
        .add_ram_output_register ("OFF"),
        .almost_full_value (PROG_FULL_THRESH),
        .ram_block_type ("AUTO"),
        .almost_empty_value (0),
        .maximum_depth (0),
        .enable_ecc  ("FALSE")
  ) scfifo_inst(
    .data (fifo_din),
    .clock (clock),
    .wrreq (fifo_wren),
    .rdreq (fifo_rden),
    .aclr (fifo_reset),
    .sclr (1'b0),
    .q (fifo_dout),
    .eccstatus (),
    .usedw (),
    .full (fifo_full),
    .empty (fifo_empty),
    .almost_full (fifo_progfull),
    .almost_empty (fifo_progempty));

    assign overflow = 1'b0;
    assign underflow = 1'b0;
      
  end
  endgenerate

assign fifo_error = overflow | underflow;

endmodule

