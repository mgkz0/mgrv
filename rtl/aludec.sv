module aludec (
    input [1:0] aluop,
    input [2:0] func3,
    input opcode5,
    input func7b5,
    input is_rv32m,

    output reg [4:0] alucode
);

  import cpu_pkg::*;

  always_comb begin
    case (aluop)
      2'b00:   alucode = ALU_ADD;
      2'b01:   alucode = ALU_SUB;
      2'b10: begin
        if (is_rv32m) begin
          case (func3)
            3'b000:  alucode = ALU_MUL;
            3'b001:  alucode = ALU_MULH;
            3'b010:  alucode = ALU_MULHSU;
            3'b011:  alucode = ALU_MULHU;
            3'b100:  alucode = ALU_DIV;
            3'b101:  alucode = ALU_DIVU;
            3'b110:  alucode = ALU_REM;
            3'b111:  alucode = ALU_REMU;
            default: alucode = ALU_ADD;
          endcase
        end else begin
          case (func3)
            3'b000:  alucode = (func7b5 & opcode5) ? ALU_SUB : ALU_ADD;
            3'b001:  alucode = ALU_SLL;
            3'b010:  alucode = ALU_SLT;
            3'b011:  alucode = ALU_SLTU;
            3'b100:  alucode = ALU_XOR;
            3'b101:  alucode = func7b5 ? ALU_SRA : ALU_SRL;
            3'b110:  alucode = ALU_OR;
            3'b111:  alucode = ALU_AND;
            default: alucode = ALU_ADD;
          endcase
        end
      end
      default: alucode = ALU_ADD;
    endcase
  end

endmodule
