module alu(
 input wire clk,

 input wire [2:0] opcode,
 input wire [31:0] a, b,

 output wire [31:0] y
);

reg [31:0] res;

wire [31:0] b_and;
wire [31:0] b_or;
wire [31:0] sum;
wire [31:0] dif;


assign b_and = a & b;
assign b_or = a | b;
assign sum = a + b;
assign dif = a - b;


always @(*) begin
 case (opcode)
  3'b000: res = b_and;
  3'b001: res = b_or;
  3'b010: res = sum;
  3'b110: res = dif;
  default: res = 0;
 endcase
end


assign y = res;

endmodule
