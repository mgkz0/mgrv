module load_aligner(
 input [31:0] rd,
 input [1:0] offset,
 input [2:0] loadcode,

 output reg [31:0] aligned
);

wire [15:0] hd;
wire [7:0] bd;

localparam LW  = 3'b001;
localparam LH  = 3'b010;
localparam LHU = 3'b011;
localparam LB  = 3'b100;
localparam LBU = 3'b101;

mux2 #(16) lhmux (rd[15:0], rd[31:16], offset[1], hd);

mux4 #(8) lbmux (
 rd[7:0], rd[15:8], rd[23:16], rd[31:24], offset, bd
);

always @(*) begin
 case (loadcode)
  LW: aligned = rd;
  LH: aligned = {{16{hd[15]}}, hd};
  LHU: aligned = {{16{1'b0}}, hd};
  LB: aligned = {{24{bd[7]}}, bd};
  LBU: aligned = {{24{1'b0}}, bd};
  default: aligned = 32'b0;
 endcase
end

endmodule
