module top(
 input clk, rst
);

wire [31:0] instr, pc;

cpu_main megacpu(
 .clk (clk),
 .rst (rst),
 .pc (pc), 
 .instr (instr)
);

ram #(
 .ADDR_WIDTH(16), .DATA_WIDTH(32)
) imem256kb (
 .clk (clk)
);

ram #(
 .ADDR_WIDTH(18), .DATA_WIDTH(32)
) dmem1mb (
 .clk (clk)
); 
endmodule
