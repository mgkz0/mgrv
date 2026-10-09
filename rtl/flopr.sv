module flopr #(
    parameter int WIDTH = 8,
    parameter logic [31:0] RESET_VALUE = 0
) (
    input clk,
    input rst,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

  always @(posedge clk or posedge rst) begin
    if (rst) q <= RESET_VALUE;
    else q <= d;
  end

endmodule
