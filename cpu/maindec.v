module maindec (
 input [6:0] opcode,
 input [6:0] func7,

 output regwrite,
 output alusrc,
 output memwrite,
 output branch,
 output jump,
 output is_rv32m,
 output [1:0] resultvsrc,
 output [1:0] aluop,
 output [2:0] immcode,
 output is_system
);

reg [11:0] controls;

// Signal Mapping:
// controls = {regwrite, alusrc, memwrite, branch, jump, resultvsrc[1:0], aluop[1:0], immcode[2:0]}
assign {
 regwrite, alusrc, memwrite, branch, jump, resultvsrc, aluop, immcode
} = controls;

assign is_rv32m = (opcode == 7'b0110011) && (func7 == 7'b0000001); 
assign is_system = (opcode == 7'b1110011);

always @(*) begin
 case (opcode)
  // R-Type (Base ALU operations & RV32M MUL/DIV)
  7'b0110011: controls = 12'b1_0_0_0_0_00_10_000;
  // I-Type ALU (ADDI, SLTI, XORI, etc.)
  7'b0010011: controls = 12'b1_1_0_0_0_00_10_001;
  // I-Type Loads (LB, LH, LW, LBU, LHU)
  7'b0000011: controls = 12'b1_1_0_0_0_01_00_001;
  // I-Type JALR (Jump and Link Register)
  7'b1100111: controls = 12'b1_1_0_0_1_10_00_001;
  // S-Type Stores (SB, SH, SW)
  7'b0100011: controls = 12'b0_1_1_0_0_00_00_010;
  // B-Type Branches (BEQ, BNE, BLT, BGE, etc.)
  7'b1100011: controls = 12'b0_0_0_1_0_00_01_011; 
  // J-Type JAL (Jump and Link)
  7'b1101111: controls = 12'b1_0_0_0_1_10_00_100;
  // U-Type LUI (Load Upper Immediate)
  7'b0110111: controls = 12'b1_1_0_0_0_11_00_101;
  // U-Type AUIPC (Add Upper Immediate to PC)
  7'b0010111: controls = 12'b1_1_0_0_0_00_00_101;
  // SYSTEM (Zicsr & Ecall / Ebreak)
  7'b1110011: controls = 12'b0_0_0_0_0_00_00_000;
  default:    controls = 12'b0_0_0_0_0_00_00_000;
 endcase
end

endmodule
