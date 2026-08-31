module maindec (
    input [6:0] opcode,
    input [6:0] func7,

    output regwrite,
    output alusrca,
    output alusrcb,
    output memwrite,
    output branch,
    output jump,
    output is_rv32m,
    output [1:0] regwritesrc,
    output [1:0] aluop,
    output [2:0] immcode,
    output is_system
);

  reg [12:0] controls;

  // Signal Mapping:
  // controls = {regwrite, alusrca, alusrcb, memwrite, branch, jump, regwritesrc[1:0], aluop[1:0], immcode[2:0]}
  assign {regwrite, alusrca, alusrcb, memwrite, branch, jump, regwritesrc, aluop, immcode} = controls;

  assign is_rv32m = (opcode == 7'b0110011) && (func7 == 7'b0000001);
  assign is_system = (opcode == 7'b1110011);

  always @(*) begin
    case (opcode)
      // R-Type: A=rd1, B=rd2
      7'b0110011: controls = 13'b1_0_0_0_0_0_00_10_000;
      // I-Type ALU: A=rd1, B=imm
      7'b0010011: controls = 13'b1_0_1_0_0_0_00_10_001;
      // I-Type Loads: A=rd1, B=imm (for addr calc)
      7'b0000011: controls = 13'b1_0_1_0_0_0_01_00_001;
      // I-Type JALR: A=rd1, B=imm
      7'b1100111: controls = 13'b1_0_1_0_1_0_10_00_001;
      // S-Type Stores: A=rd1, B=imm (for addr calc)
      7'b0100011: controls = 13'b0_0_1_1_0_0_00_00_010;
      // B-Type Branches: A=rd1, B=rd2
      7'b1100011: controls = 13'b0_0_0_0_1_0_00_01_011;
      // J-Type JAL: Jumps
      7'b1101111: controls = 13'b1_0_0_0_1_0_10_00_100;
      // U-Type LUI: A=0, B=imm (result is imm)
      7'b0110111: controls = 13'b1_0_1_0_0_0_11_00_101;
      // U-Type AUIPC: A=pc, B=imm
      7'b0010111: controls = 13'b1_1_1_0_0_0_00_00_101;
      // SYSTEM
      7'b1110011: controls = 13'b0_0_0_0_0_0_00_00_000;
      default:    controls = 13'b0_0_0_0_0_0_00_00_000;
    endcase
  end

endmodule
