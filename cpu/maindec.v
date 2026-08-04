module maindec (
 input [6:0] op,

 output regwrite,
 output alusrc,
 output memwrite,
 output branch,
 output jump,
 output [1:0] resultvsrc,
 output [1:0] aluop
);

reg [10:0] controls;

// Signal Mapping:
// controls = {regwrite, alusrc, memwrite, branch, jump, resultvsrc[1:0], aluop[1:0]}
assign {regwrite, alusrc, memwrite, branch, jump, resultvsrc, aluop} = controls;

always @(*) begin
 case (op)
  // R-Type (Base ALU operations & RV32M MUL/DIV)
  7'b0110011: controls = 11'b1_0_0_0_0_00_10;
  // I-Type ALU (ADDI, SLTI, XORI, etc.)
  7'b0010011: controls = 11'b1_1_0_0_0_00_10;
  // Loads (LB, LH, LW, LBU, LHU)
  7'b0000011: controls = 11'b1_1_0_0_0_01_00;
  // Stores (SB, SH, SW)
  7'b0100011: controls = 11'b0_1_1_0_0_00_00;
  // Branches (BEQ, BNE, BLT, BGE, etc.)
  7'b1100011: controls = 11'b0_0_0_1_0_00_01;
  // JAL (Jump and Link)
  7'b1101111: controls = 11'b1_0_0_0_1_10_00;
  // JALR (Jump and Link Register)
  7'b1100111: controls = 11'b1_1_0_0_1_10_00;
  // LUI (Load Upper Immediate)
  7'b0110111: controls = 11'b1_1_0_0_0_11_00;
  // AUIPC (Add Upper Immediate to PC)
  7'b0010111: controls = 11'b1_1_0_0_0_00_00;
  
  default: controls = 11'b0_0_0_0_0_00_00;
 endcase
end

endmodule
