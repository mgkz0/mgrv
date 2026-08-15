module top(
 input clk, rst,
 input i_memwrite,
 input [31:0] w_instr,
 output d_memwrite,
 output [31:0] writedata, d_memaddr
);

wire [31:0] pc, readdata, r_instr;

rv32_main cpu(
 .clk (clk),
 .rst (rst), 
 .instr (r_instr),
 .readdata (readdata),
 .memwrite (d_memwrite),
 .pc (pc),
 .writedata (writedata),
 .aluout (d_memaddr)
);

ram #(
 .ADDR_WIDTH(16), .DATA_WIDTH(32)
) imem256kb (
 .clk (clk),
 .we (i_memwrite),
 .a (pc[17:2]),
 .wd (w_instr),
 .rd (r_instr)
);

ram #(
 .ADDR_WIDTH(18), .DATA_WIDTH(32)
) dmem1mb (
 .clk (clk),
 .we (d_memwrite),
 .a (d_memaddr[19:2]),
 .wd (writedata),
 .rd (readdata)
); 
endmodule
