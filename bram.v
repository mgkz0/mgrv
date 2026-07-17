module bram(
 input wire clk,
 input wire we_n,
 input wire [ADDR_WIDTH-1:0] addr,
 input wire [DATA_WIDTH-1:0] din,
 output reg [DATA_WIDTH-1:0] dout
);

parameter reg ADDR_WIDTH = 18;
parameter reg DATA_WIDTH = 32;

reg [DATA_WIDTH-1:0] mem [1<<DATA_WIDTH];

always @(posedge clk) begin
 if (we_n) begin
  mem[addr] <= din;
 end
 dout <= mem[addr];
end

endmodule
