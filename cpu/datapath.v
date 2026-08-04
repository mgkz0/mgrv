module datapath(
 input wire clk, rst,
 
 input wire reg_write,
 input wire [31:0] read_data,
 input wire [31:0] instr,
 output wire [31:0] pc,
 output wire [31:0] write_data
);

wire [31:0] pc_next, pc_plus4;

assign pc_plus4 = pc + 32'd4;


always @(posedge clk) begin
 pc <= pc_next;
end


endmodule
