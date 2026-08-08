module control_unit(
 input [6:0] opcode,
 input [5:0] func7,
 input [2:0] func3,
 input zero,

 output [4:0] alucode,
 output regwrite, 
 output alusrc, 
 output memwrite, 
 output jump, 
 output pcsrc,
 output [1:0] resultvsrc,
 output [2:0] immcode
);

wire [1:0] aluop;
wire is_rv32m;
wire func7b5 = func7[5];
wire branch;

maindec md (
 op, 
 regwrite, 
 alusrc, 
 memwrite, 
 branch, 
 jump, 
 is_rv32m, 
 resultvsrc, 
 aluop,
 immcode
);

aludec ad (
 aluop, 
 func3, 
 func7b5, 
 is_rv32m, 
 alucode
);

assign pcsrc = (branch && zero);
endmodule
