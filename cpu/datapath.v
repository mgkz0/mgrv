module datapath(
 input wire clk, rst,
 
 input wire regwrite, jump, alusrc, pcsrc,
 input wire [31:0] readdata,
 input wire [31:0] instr,
 input wire [1:0] resultvsrc,
 input wire [4:0] alucode,
 input wire [2:0] immcode,

 output wire [31:0] pc,
 output wire [31:0] writedata,
 output wire [31:0] aluout,
 output wire zero
);

///
// output [4:0] alucode,
// output regwrite, 
// output alusrc, 
// output memwrite, 
// output jump, 
// output pcsrc,
// output [1:0] resultvsrc,
// output [2:0] immcode
//
wire [31:0] pc_next, pc_plus4;

assign pc_plus4 = pc + 32'd4;


always @(posedge clk) begin
 pc <= pc_next;
end


endmodule
