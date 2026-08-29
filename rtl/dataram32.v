module dataram32 (
    input clk,
    input we,
    input [ADDR_WIDTH-1:0] a,
    input [3:0] wstrb,
    input [31:0] wd,
    output [31:0] rd
);
  parameter ADDR_WIDTH = 18;
  reg [31:0] mem[0:(1<<ADDR_WIDTH)-1];
  assign rd = mem[a];

  always @(posedge clk) begin
    if (we) begin
      case (wstrb)
        // WORDS
        4'b1111: mem[a] <= wd;
        // HALFWORDS
        4'b0011: mem[a][15:0] <= wd[15:0];
        4'b1100: mem[a][31:16] <= wd[31:16];
        // BYTES
        4'b0001: mem[a][7:0] <= wd[7:0];
        4'b0010: mem[a][15:8] <= wd[15:8];
        4'b0100: mem[a][23:16] <= wd[23:16];
        4'b1000: mem[a][31:24] <= wd[31:24];
        default: ;
      endcase
    end
  end
endmodule

