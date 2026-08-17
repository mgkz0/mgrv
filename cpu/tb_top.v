`timescale 1ns/1ps

module tb_top;

reg rst, clk;

reg i_memwrite, d_memwrite;

reg [31:0] w_instr, writedata, d_memaddr; 

top dut(
 .clk (clk),
 .rst (rst),
 .i_memwrite (i_memwrite),
 .w_instr (w_instr),
 .d_memwrite (d_memwrite),
 .writedata (writedata),
 d_memaddr (d_memaddr)
);

always begin
 clk = 1;
 #5;
 clk = 0;
 #5;
end

initial begin
 $readmemh("./memfile.hex", dut.imem256kb.mem);
 rst <= 1;
 #22;
 rst <= 0;
end

always @(negedge clk) begin
 if (d_memaddr) begin
  if (d_memaddr == 32'd84 && writedata == 32'd25) begin
   $display("Simulation passed!");
   $stop;
  end else begin
   $display("Simulation failed!");
   $stop;
  end
 end
end

endmodule
