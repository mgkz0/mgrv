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

wire [31:0] pcnext, pcplus4, immediate;

wire [31:0] rd1, rd2, wd3;

// IMMEDIATE GENERATION LOGIC
immgen ig(
 .immcode (immcode),
 .instr (instr),
 .immediate (immediate)
);


// NEXT PC LOGIC
wire is_jalr = (regwrite & alusrc & jump);

adder addnextpc(
 .a (pc), .b (32'b100), .y (pcplus4)
);

adder addnextpcjalr(
 .a (immediate), .b (instr[19:15])
);


// REGFILE LOGIC
regfile rf(
 .clk (clk),
 .we3 (regwrite),
 .ra1 (instr[19:15]),
 .ra2 (instr[24:20]),
 .wa3 (instr[11:7]),
 .wd3 (wd3),
 .rd1 (rd1),
 .rd2 (rd2),
);

endmodule
