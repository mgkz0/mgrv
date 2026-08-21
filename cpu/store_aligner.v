module store_aligner(
 input [2:0] storecode,
 input [31:0] wd,
 input [1:0] offset,

 output [3:0] wstrb,
 output [31:0] aligned
);

wire [3:0] wstrb_h, wstrb_b;
wire [31:0] hd, bd;

mux2 #(4) shmux (4'b0011, 4'b1100, offset[1], wstrb_h);

mux4 #(4) sbmux (
 4'b0001, 4'b0010, 4'b0100, 4'b1000, offset, wstrb_b
);

mux2 #(32) shdmux (
 {16'b0, wd[15:0]},
 {wd[15:0], 16'b0},
 offset[1],
 hd
);

mux4 #(32) sbdmux (
 {24'b0, wd[7:0]},
 {16'b0, wd[7:0], 8'b0},
 {8'b0, wd[7:0], 16'b0},
 {wd[7:0], 24'b0},
 offset,
 bd
);

localparam SB = 3'b000;
localparam SH = 3'b001;
localparam SW = 3'b010;

always @(*) begin
 case (storecode)
  SW: begin 
   aligned = wd;
   wstrb = 4'b1111;
  end
  SH: begin
   aligned = hd;
   wstrb = wstrb_h;
  end
  SB: begin
   aligned = bd;
   wstrb = wstrb_b;
  end
  default: begin
   aligned = 32'b0;
   wstrb = 4'b0000;
  end
 endcase
end

endmodule
