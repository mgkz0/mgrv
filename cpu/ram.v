module ram(
 input clk,
 
 input we,
 input [ADDR_WIDTH-1:0] a,
 input [DATA_WIDTH-1:0] wd,

 output [DATA_WIDTH-1:0] rd 
);

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;

reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

assign rd = mem[a];

always @(posedge clk) begin
 if (we) begin
  mem[a] <= wd;
 end
end
endmodule
