module cpu_main(
 input wire clk, rst,
 
 input wire [31:0] instr,
 input wire [31:0] read_data,
 output wire [31:0] pc,
 output wire [31:0] write_data
);

wire reg_write;

datapath dp (clk, rst, read_data, write_data, reg_write);

endmodule
