module pcnextgen(
 input regwrite, alusrc, jump, pcsrc,
 input [31:0] pc,
 input [31:0] rd1, 
 input [31:0] immediate,

 output [31:0] pcnext
);

wire is_jalr;
wire [31:0] pcplus4, pcnextbr, pcnextjalr;

adder nextplus4(
 .a (pc), .b (32'b100), .y (pcplus4)
);
adder nextpcbranch(
 .a (pc), .b (immediate), .y (pcnextbr)
);
assign pcnextjalr = (rd1 + immediate) & ~32'h1;

assign is_jalr = (regwrite & alusrc & jump);

assign pcnext = is_jalr ? pcnextjalr : pcsrc ? pcnextbr : pcplus4;

endmodule
