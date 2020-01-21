`include "common_functions.vh"

module afifo_wrapper #(
  parameter C_FAMILY = "ULTRASCALE",
  parameter WIDTH = 128,
  parameter DEPTH = 256,
  parameter PROG_EMPTY_THRESH = DEPTH/2,
  parameter PROG_FULL_THRESH = DEPTH/2
)(
  input wire rst_wr,
  input wire rst_rd,
  input wire wr_clk,
  input wire rd_clk,
  input wire [WIDTH-1 : 0] din,
  input wire wr_en,
  input wire rd_en,
  output wire [WIDTH-1 : 0] dout,
  //output wire overflow,
  //output wire wr_rst_busy,
  //output wire underflow,
  //output wire rd_rst_busy,
  output wire full,
  output wire almost_full,
  output wire empty,
  output wire almost_empty,
  output wire fifo_error
);

  wire overflow;
  wire wr_rst_busy;
  wire underflow;
  wire rd_rst_busy;

  generate 
  if ((C_FAMILY == "ULTRASCALE") || (C_FAMILY == "VIRTEX7") || (C_FAMILY == "kintexu")) begin
    // Permitted value for DATA_COUNT_WIDTH is 
    // 1 and log2(FIFO_DEPTH)+1
    localparam DATA_COUNT_WIDTH = (`CLOG2(DEPTH)) + 1;

    wire [DATA_COUNT_WIDTH-1:0] wr_data_count;
    wire [DATA_COUNT_WIDTH-1:0] rd_data_count;

    // xpm_fifo_async: Asynchronous FIFO
    // Xilinx Parameterized Macro, Version 2017.1
    xpm_fifo_async # (
      .FIFO_MEMORY_TYPE ("auto"), //string; "auto", "block", or "distributed";
      .ECC_MODE ("no_ecc"), //string; "no_ecc" or "en_ecc";
      .RELATED_CLOCKS (0), //positive integer; 0 or 1
      .FIFO_WRITE_DEPTH (DEPTH), //positive integer
      .WRITE_DATA_WIDTH (WIDTH), //positive integer
      .WR_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
      .PROG_FULL_THRESH (PROG_FULL_THRESH), //positive integer
      .FULL_RESET_VALUE (0), //positive integer; 0 or 1
      .READ_MODE ("fwft"), //string; "std" or "fwft";
      .FIFO_READ_LATENCY (1), //positive integer;
      .READ_DATA_WIDTH (WIDTH), //positive integer
      .RD_DATA_COUNT_WIDTH (DATA_COUNT_WIDTH), //positive integer
      .PROG_EMPTY_THRESH (PROG_EMPTY_THRESH), //positive integer
      .DOUT_RESET_VALUE ("0"), //string
      .CDC_SYNC_STAGES (2), //positive integer
      .WAKEUP_TIME (0) //positive integer; 0 or 2;
    ) xpm_fifo_async_inst (
      .rst (rst_wr),
      .wr_clk (wr_clk),
      .wr_en (wr_en),
      .din (din),
      .full (full),
      .overflow (overflow),
      .wr_rst_busy (wr_rst_busy),
      .rd_clk (rd_clk),
      .rd_en (rd_en),
      .dout (dout),
      .empty (empty),
      .underflow (underflow),
      .rd_rst_busy (rd_rst_busy),
      .prog_full (almost_full),
      .wr_data_count (wr_data_count),
      .prog_empty (almost_empty),
      .rd_data_count (rd_data_count),
      .sleep (1'b0),
      .injectsbiterr (1'b0),
      .injectdbiterr (1'b0),
      .sbiterr (),
      .dbiterr ()
    );
    // End of xpm_fifo_async instance declaration
  end else if ((C_FAMILY == "ALTERA") || (C_FAMILY == "CYCLONE10") || (C_FAMILY == "Intel")) begin 
    localparam WIDTHU = (`CLOG2(DEPTH));

    wire [WIDTH-1:0] sub_wire0;
    wire  sub_wire1;
    wire [WIDTHU-1:0] sub_wire2;
    wire  sub_wire3;
    wire [WIDTHU-1:0] sub_wire4;
    assign dout = sub_wire0[WIDTH-1:0];
    assign empty = sub_wire1;
    wire [WIDTHU-1:0] rdusedw = sub_wire2[WIDTHU-1:0];
    assign  full = sub_wire3;
    wire [WIDTHU-1:0] wrusedw = sub_wire4[WIDTHU-1:0];

    assign wr_rst_busy = 1'b0;
    assign rd_rst_busy = 1'b0;

    // Number of words stored in the FIFO
    assign almost_full = wrusedw[WIDTHU-1];
    assign almost_empty = ~rdusedw[WIDTHU-1];

    assign overflow = 1'b0;
    assign underflow = 1'b0;

    dcfifo # (
        .enable_ecc ("FALSE"),
        .intended_device_family ("Cyclone 10 GX"),
        .lpm_hint ("DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=TRUE"),
        .lpm_numwords (DEPTH),
        .lpm_showahead ("ON"),
        .lpm_type ("dcfifo"),
        .lpm_width (WIDTH),
        .lpm_widthu (WIDTHU),
        .overflow_checking ("ON"),
        .rdsync_delaypipe (4),
        .read_aclr_synch ("ON"),
        .underflow_checking ("ON"),
        .use_eab ("ON"),
        .write_aclr_synch ("ON"),
        .wrsync_delaypipe (4)    
    ) dcfifo_component (
        .aclr (rst_wr),
        .data (din),
        .rdclk (rd_clk),
        .rdreq (rd_en),
        .wrclk (wr_clk),
        .wrreq (wr_en),
        .q (sub_wire0),
        .rdempty (sub_wire1),
        .rdusedw (sub_wire2),
        .wrfull (sub_wire3),
        .wrusedw (sub_wire4),
        .eccstatus (),
        .rdfull (),
        .wrempty ());

  end
  else begin
    assign dout           = 0;
    assign overflow       = 0;
    assign wr_rst_busy    = 0;
    assign underflow      = 0;
    assign rd_rst_busy    = 0;
    assign full           = 0;
    assign almost_full    = 0;
    assign empty          = 0;
    assign almost_empty   = 0;
  end
  endgenerate

assign fifo_error = overflow | underflow;

endmodule

