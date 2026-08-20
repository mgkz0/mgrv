module rv32_main(
 input wire clk, rst,
 
 input wire [31:0] instr,
 input wire [31:0] readdata,

 output wire memwrite,
 output wire [31:0] pc,
 output wire [31:0] writedata,
 output wire [31:0] aluout
);

wire regwrite, alusrc, jump, pcsrc, zero;

wire [1:0] resultvsrc;
wire [2:0] immcode;
wire [4:0] alucode;


control_unit cu (
 .opcode (instr[6:0]),
 .func7 (instr[31:25]),
 .func3 (instr[14:12]),
 .zero (zero),
 .alucode (alucode),
 .regwrite (regwrite),
 .alusrc (alusrc),
 .memwrite (memwrite),
 .jump (jump),
 .pcsrc (pcsrc),
 .resultvsrc (resultvsrc),
 .immcode (immcode)
);

datapath dp (
 .clk (clk), 
 .rst (rst),
 .regwrite (regwrite),
 .jump (jump),
 .alusrc (alusrc),
 .pcsrc (pcsrc),
 .readdata (readdata), 
 .instr (instr),
 .resultvsrc (resultvsrc),
 .alucode (alucode),
 .immcode (immcode),
 .loadcode (instr[14:12]),
 .pc (pc),
 .writedata (writedata),
 .aluout (aluout),
 .zero (zero)
);

endmodule
