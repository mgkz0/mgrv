module immgen(
 input [2:0] immgen,
 input [31:0] instr,

 output [31:0] immediate
);

localparam I_TYPE = 3'b001;
localparam S_TYPE = 3'b010;
localparam B_TYPE = 3'b011;
localparam J_TYPE = 3'b100;
localparam U_TYPE = 3'b101;

endmodule
