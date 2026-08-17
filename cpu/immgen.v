module immgen(
 input [2:0] immcode,
 /* verilator lint_off UNUSEDSIGNAL */
 input [31:0] instr,
 /* verilator lint_on UNUSEDSIGNAL */

 output reg [31:0] immediate
);

localparam I_TYPE = 3'b001;
localparam S_TYPE = 3'b010;
localparam B_TYPE = 3'b011;
localparam J_TYPE = 3'b100;
localparam U_TYPE = 3'b101;


always @(*) begin
 case (immcode)
  I_TYPE: immediate = {{21{instr[31]}}, instr[30:20]};
  S_TYPE: immediate = {{21{instr[31]}}, instr[30:25], instr[11:7]};
  B_TYPE: immediate = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
  J_TYPE: immediate = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
  U_TYPE: immediate = {instr[31], instr[30:20], instr[19:12], {12{1'b0}}};
  default: immediate = 32'd0;
 endcase
end
endmodule
