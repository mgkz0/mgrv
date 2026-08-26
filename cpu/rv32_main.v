module rv32_main (
    input wire clk,
    input rst,

    input wire [31:0] instr,
    input wire [31:0] readdata,

    output wire memwrite,
    output wire [31:0] pc,
    output wire [31:0] writedata,
    output wire [31:0] aluout,
    output wire [3:0] wstrb
);

  wire regwrite, alusrc, jump, pcsrc, zero;
  wire csrread, csrwrite;

  wire [1:0] resultvsrc;
  wire [2:0] immcode;
  wire [4:0] alucode;
  wire [3:0] systemcode;

  control_unit cu (
      .instr(instr),
      .zero(zero),
      .alucode(alucode),
      .regwrite(regwrite),
      .alusrc(alusrc),
      .memwrite(memwrite),
      .jump(jump),
      .pcsrc(pcsrc),
      .resultvsrc(resultvsrc),
      .immcode(immcode),
      .systemcode(systemcode),
      .csrread(csrread),
      .csrwrite(csrwrite)
  );

  datapath dp (
      .clk(clk),
      .rst(rst),
      .regwrite(regwrite),
      .jump(jump),
      .alusrc(alusrc),
      .pcsrc(pcsrc),
      .readdata(readdata),
      .instr(instr),
      .resultvsrc(resultvsrc),
      .alucode(alucode),
      .immcode(immcode),
      .systemcode(systemcode),
      .csrread(csrread),
      .csrwrite(csrwrite),
      .pc(pc),
      .writedata(writedata),
      .aluout(aluout),
      .wstrb(wstrb),
      .zero(zero)
  );

endmodule
