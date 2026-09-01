module rv32_main #(
    parameter PC_RESET_VALUE = 32'h8000_0000
) (
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

  wire regwrite, alusrca, alusrcb, jump, branch;
  wire csrread, csrwrite;

  wire [1:0] regwritesrc;
  wire [2:0] immcode;
  wire [4:0] alucode;
  wire [3:0] systemcode;
  wire [3:0] csrinteraddr;

  control_unit cu (
      .instr(instr),
      .alucode(alucode),
      .regwrite(regwrite),
      .alusrca(alusrca),
      .alusrcb(alusrcb),
      .memwrite(memwrite),
      .jump(jump),
      .branch(branch),
      .regwritesrc(regwritesrc),
      .immcode(immcode),
      .systemcode(systemcode),
      .csrread(csrread),
      .csrwrite(csrwrite),
      .csrinteraddr(csrinteraddr)
  );

  datapath #(PC_RESET_VALUE) dp (
      .clk(clk),
      .rst(rst),
      .regwrite(regwrite),
      .jump(jump),
      .alusrca(alusrca),
      .alusrcb(alusrcb),
      .branch(branch),
      .readdata(readdata),
      .instr(instr),
      .regwritesrc(regwritesrc),
      .alucode(alucode),
      .immcode(immcode),
      .systemcode(systemcode),
      .csrread(csrread),
      .csrwrite(csrwrite),
      .csrinteraddr(csrinteraddr),
      .pc(pc),
      .writedata(writedata),
      .aluout(aluout),
      .wstrb(wstrb)
  );

endmodule
