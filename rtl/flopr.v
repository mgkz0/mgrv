module flopr #(
    parameter WIDTH = 8,
    parameter RESET_VALUE = 0
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset) q <= RESET_VALUE;
    else q <= d;
  end

endmodule
