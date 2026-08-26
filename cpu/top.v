module top (
    input clk,
    input rst,
    input i_memwrite,
    input [31:0] w_instr,
    output d_memwrite,
    output [31:0] writedata,
    output [31:0] d_memaddr
);
  /* verilator lint_off UNUSEDSIGNAL */
  wire [31:0] pc, readdata, r_instr;
  wire [3:0] wstrb;
  /* verilator lint_on UNUSEDSIGNAL */
  rv32_main cpu (
      .clk(clk),
      .rst(rst),
      .instr(r_instr),
      .readdata(readdata),
      .memwrite(d_memwrite),
      .pc(pc),
      .writedata(writedata),
      .aluout(d_memaddr),
      .wstrb(wstrb)
  );

  ram #(
      .ADDR_WIDTH(16),
      .DATA_WIDTH(32)
  ) imem (
      .clk(clk),
      .we (i_memwrite),
      .a  (pc[17:2]),
      .wd (w_instr),
      .rd (r_instr)
  );

  dataram32 #(
      .ADDR_WIDTH(18)
  ) dmem (
      .clk(clk),
      .we(d_memwrite),
      .a(d_memaddr[19:2]),
      .wd(writedata),
      .rd(readdata),
      .wstrb(wstrb)
  );
endmodule
