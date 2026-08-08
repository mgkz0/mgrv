module maindec (
 input [6:0] op,

 output regwrite,
 output alusrc,
 output memwrite,
 output branch,
 output jump,
 output is_rv32m,
 output [1:0] resultvsrc,
 output [1:0] aluop,
 output [2:0] immcode
);

reg [10:0] controls;

localparam I_TYPE = 3'b001;
localparam S_TYPE = 3'b010;
localparam B_TYPE = 3'b011;
localparam J_TYPE = 3'b100;
localparam U_TYPE = 3'b101;

// Signal Mapping:
// controls = {regwrite, alusrc, memwrite, branch, jump, resultvsrc[1:0], aluop[1:0]}
assign {regwrite, alusrc, memwrite, branch, jump, resultvsrc, aluop} = controls;

assign is_rv32m = (opcode == 7'b0110011) && (funct7 == 7'b0000001); 

always @(*) begin
 case (op)
  // R-Type (Base ALU operations & RV32M MUL/DIV)
  7'b0110011: begin
   controls = 11'b1_0_0_0_0_00_10;
   immcode = 3'b000;
 end
  // I-Type ALU (ADDI, SLTI, XORI, etc.)
  7'b0010011: begin
   controls = 11'b1_1_0_0_0_00_10;
   immcode = I_TYPE;
  end
  // I-Type Loads (LB, LH, LW, LBU, LHU)
  7'b0000011: begin
   controls = 11'b1_1_0_0_0_01_00;
   immcode = I_TYPE;
  end
  // I-Type JALR (Jump and Link Register)
  7'b1100111: begin
   controls = 11'b1_1_0_0_1_10_00;
   immcode = I_TYPE;
  end
  // S-Type Stores (SB, SH, SW)
  7'b0100011: begin
   controls = 11'b0_1_1_0_0_00_00;
   immcode = S_TYPE;
  end
  // B-Type Branches (BEQ, BNE, BLT, BGE, etc.)
  7'b1100011: begin
   controls = 11'b0_0_0_1_0_00_01;
   immcode = B_TYPE;
  end 
  // J-Type JAL (Jump and Link)
  7'b1101111: begin
   controls = 11'b1_0_0_0_1_10_00;
   immcode = J_TYPE;
  end
  // U-Type LUI (Load Upper Immediate)
  7'b0110111: begin
   controls = 11'b1_1_0_0_0_11_00;
   immcode = U_TYPE;
  end
  // U-Type AUIPC (Add Upper Immediate to PC)
  7'b0010111: begin
   controls = 11'b1_1_0_0_0_00_00;
   immcode = U_TYPE;
  end
  default: begin
   controls = 11'b0_0_0_0_0_00_00;
   immcode = 3'b000;
  end
 endcase
end

endmodule
