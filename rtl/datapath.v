module datapath #(
    parameter PC_RESET_VALUE = 32'h8000_0000
) (
    input wire clk,
    input rst,

    input wire regwrite,
    input jump,
    input alusrc,
    input branch,
    input wire [31:0] readdata,
    input wire [31:0] instr,
    input wire [1:0] regwritesrc,
    input wire [4:0] alucode,
    input wire [2:0] immcode,

    input wire [3:0] systemcode,
    input wire csrread,
    input wire csrwrite,

    output wire [31:0] pc,
    output wire [31:0] writedata,
    output wire [31:0] aluout,
    output wire [ 3:0] wstrb
);

  wire [31:0] immediate, pcnext, loaddata;

  wire [31:0] rd1, rd2, wd3;
  wire [31:0] srcb;

  wire take_branch, zero;
  wire trap;
  wire is_ebreak, is_ecall, csr_exc;
  wire [31:0] csrrd, csrwd;
  wire [31:0] mcause_in, mtvec_out;

  // SIGN IMMEDIATE GENERATION LOGIC
  immgen ig (
      .immcode(immcode),
      .instr(instr),
      .immediate(immediate)
  );

  // NEXT PC LOGIC
  pcnextgen pcng (
      .regwrite(regwrite),
      .alusrc(alusrc),
      .jump(jump),
      .take_branch(take_branch),
      .pc(pc),
      .rd1(rd1),
      .immediate(immediate),
      .mtvec_out(mtvec_out),
      .trap(trap),
      .pcnext(pcnext)
  );

  flopr #(32, PC_RESET_VALUE) pcprep (
      clk,
      rst,
      pcnext,
      pc
  );

  // SYSTEM INSTRUCTIONS DATA GEN LOGIC
  systemgen sg (
      .systemcode(systemcode),
      .rd1(rd1),
      .csrrd(csrrd),
      .rs1(instr[19:15]),
      .csrwd(csrwd),
      .is_ebreak(is_ebreak),
      .is_ecall(is_ecall)
  );

  assign trap = (is_ecall || is_ebreak || csr_exc);

  assign mcause_in = (is_ecall) ? 32'd11 : (is_ebreak) ? 32'd3 : (csr_exc) ? 32'd2 : 32'd0;

  // REGFILE LOGIC
  regfile rf (
      .clk(clk),
      .we3(regwrite && !trap),
      .ra1(instr[19:15]),
      .ra2(instr[24:20]),
      .wa3(instr[11:7]),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
  );

  // CSR FILE LOGIC
  csrfile csrf (
      .rst(rst),
      .clk(clk),
      .we(csrwrite),
      .re(csrread),
      .mode(2'b11),
      .a(instr[31:20]),
      .wd(csrwd),
      .rd(csrrd),
      .pc(pc),
      .mcause_in(mcause_in),
      .trap(trap),
      .csr_exc(csr_exc),
      .mtvec_out(mtvec_out)
  );

  // ALU LOGIC
  mux2 #(32) srcbmux (
      rd2,
      immediate,
      alusrc,
      srcb
  );

  alu alu (
      .opcode(alucode),
      .a(rd1),
      .b(srcb),
      .y(aluout),
      .zero(zero)
  );

  // LOAD & STORE INSTRUCTIONS ALIGN LOGIC

  load_aligner la (
      .rd(readdata),
      .offset(aluout[1:0]),
      .loadcode(instr[14:12]),
      .aligned(loaddata)
  );

  store_aligner sa (
      .storecode(instr[14:12]),
      .wd(rd2),
      .offset(aluout[1:0]),
      .wstrb(wstrb),
      .aligned(writedata)
  );

  // BRANCH DECODE
  branchdec bd (
      .branch(branch),
      .zero(zero),
      .func3(instr[14:12]),
      .aluout32b(aluout[31]),
      .take_branch(take_branch)
  );

  // SELECTING SOURCE TO WRITE IN REGITER
  assign wd3 = (csrread) ? csrrd : (regwritesrc == 2'b00) ? aluout : 
	  (regwritesrc == 2'b01) ? loaddata : 
	  (regwritesrc == 2'b10) ? (pc + 32'd4) : immediate;

endmodule
