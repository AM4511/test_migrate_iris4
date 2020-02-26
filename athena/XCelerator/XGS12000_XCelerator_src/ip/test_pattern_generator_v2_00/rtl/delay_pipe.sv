`timescale 1ps/1ps

module delay_pipe #(
	parameter WIDTH = 8,
	parameter DELAY = 2 
)
(
	input clk,
	input reset,
	input [WIDTH-1: 0] sig_i,
	output [WIDTH-1: 0] sig_o
);

  reg [DELAY*WIDTH-1:0] sig_reg;

  generate if (DELAY > 0)
  begin
    genvar gi;
    for (gi = 0; gi < DELAY; gi = gi + 1) begin
      always @ (posedge clk or posedge reset) begin
        if (reset) begin
          sig_reg[(gi+1)*WIDTH-1:gi*WIDTH] <= 0;
        end
        else begin
          if (gi == 0)
            sig_reg[(gi+1)*WIDTH-1:gi*WIDTH] <= sig_i;
          else 
            sig_reg[(gi+1)*WIDTH-1:gi*WIDTH] <= sig_reg[gi*WIDTH-1:(gi-1)*WIDTH];
        end
      end
    end
  end
  endgenerate

  generate if (DELAY == 0)
  begin
    assign sig_o = sig_i; 
  end
  else
  begin
    assign sig_o = sig_reg[DELAY*WIDTH-1:(DELAY-1)*WIDTH];  
  end
  endgenerate

endmodule
