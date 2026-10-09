module ram #(
    parameter int ADDR_WIDTH = 16,
    parameter int DATA_WIDTH = 32
) (
    input clk,
    input we,
    input [ADDR_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] wd,

    output [DATA_WIDTH-1:0] rd
);

  logic [DATA_WIDTH-1:0] mem[1<<ADDR_WIDTH];

  assign rd = mem[a];

  always @(posedge clk) begin
    if (we) begin
      mem[a] <= wd;
    end
  end
endmodule
