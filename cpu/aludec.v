module aludec(
 input [1:0] aluop,
 input [2:0] func3,
 input func7b5,
 input is_rv32m,

 output reg [4:0] alucode
);

// DEFAULT OPS
localparam ALU_AND    = 5'b00000;
localparam ALU_OR     = 5'b00001;
localparam ALU_XOR    = 5'b00010;
localparam ALU_ADD    = 5'b00011;
localparam ALU_SUB    = 5'b00100;
localparam ALU_SLTU   = 5'b00101;
localparam ALU_SLT    = 5'b00110;
localparam ALU_SLL    = 5'b00111;
localparam ALU_SRL    = 5'b01000;
localparam ALU_SRA    = 5'b01001;
// MUL OPS
localparam ALU_MUL    = 5'b01010;
localparam ALU_MULH   = 5'b01011;
localparam ALU_MULHU  = 5'b01100;
localparam ALU_MULHSU = 5'b01101;
// DIV OPS
localparam ALU_DIV    = 5'b01110;
localparam ALU_DIVU   = 5'b01111;
localparam ALU_REM    = 5'b10000;
localparam ALU_REMU   = 5'b10001;

always @(*) begin
 case (aluop)
  2'b00: alucode = ALU_ADD;

  2'b01: alucode = ALU_SUB;

  2'b10: begin
   if (is_rv32m) begin
    case (func3)
     3'b000: alucode = ALU_MUL;
     3'b001: alucode = ALU_MULH;
     3'b010: alucode = ALU_MULHSU;
     3'b011: alucode = ALU_MULHU;
     3'b100: alucode = ALU_DIV;
     3'b101: alucode = ALU_DIVU;
     3'b110: alucode = ALU_REM;
     3'b111: alucode = ALU_REMU;
     default: alucode = ALU_ADD;
    endcase
   end else begin
    case (func3)
     3'b000: alucode = func7b5 ? ALU_SUB : ALU_ADD;
     3'b001: alucode = ALU_SLL;
     3'b010: alucode = ALU_SLT;
     3'b011: alucode = ALU_SLTU;
     3'b100: alucode = ALU_XOR;
     3'b101: alucode = func7b5 ? ALU_SRA : ALU_SRL;
     3'b110: alucode = ALU_OR;
     3'b111: alucode = ALU_AND;
     default: alucode = ALU_ADD;
    endcase
   end
  end

  default: alucode = ALU_ADD;
 endcase
end

endmodule
