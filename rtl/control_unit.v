module control_unit (
    input [31:0] instr,

    output [4:0] alucode,
    output regwrite,
    output alusrc,
    output memwrite,
    output jump,
    output branch,
    output [1:0] regwritesrc,
    output [2:0] immcode,

    output [3:0] systemcode,
    output csrread,
    output csrwrite
);
  wire [1:0] aluop;
  wire is_rv32m;
  wire func7b5 = instr[31:25][5];
  wire opcode5 = instr[6:0][5];
  wire gregwrite;

  wire is_system;
  wire csrregwrite;

  maindec md (
      .opcode(instr[6:0]),
      .func7(instr[31:25]),
      .regwrite(gregwrite),
      .alusrc(alusrc),
      .memwrite(memwrite),
      .branch(branch),
      .jump(jump),
      .is_rv32m(is_rv32m),
      .regwritesrc(regwritesrc),
      .aluop(aluop),
      .immcode(immcode),
      .is_system(is_system)
  );

  aludec ad (
      .aluop(aluop),
      .func3(instr[14:12]),
      .opcode5(opcode5),
      .func7b5(func7b5),
      .is_rv32m(is_rv32m),
      .alucode(alucode)
  );

  systemdec sd (
      .is_system(is_system),
      .instr(instr),
      .regwrite(csrregwrite),
      .csrwrite(csrwrite),
      .csrread(csrread),
      .systemcode(systemcode)
  );

  assign regwrite = (gregwrite || csrregwrite);
endmodule
