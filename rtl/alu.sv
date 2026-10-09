module alu (
    input wire [ 4:0] opcode,
    input wire [31:0] a,
    input wire [31:0] b,

    output wire [31:0] y,
    output wire zero
);
  import cpu_pkg::*;

  /* verilator lint_off UNUSEDSIGNAL */
  wire [63:0] sign_prod = $signed(a) * $signed(b);
  wire [63:0] unsign_prod = a * b;
  wire [63:0] multi_sign_prod = $signed(a) * $signed({1'b0, b});
  /* verilator lint_on UNUSEDSIGNAL */

  wire is_zero = (b == 32'b0);
  wire is_overflow = (a == 32'h8000_0000) && (b == 32'hFFFF_FFFF);

  logic [31:0] res;

  always_comb begin
    case (opcode)
      // INT OPS
      ALU_AND:  res = a & b;
      ALU_OR:   res = a | b;
      ALU_XOR:  res = a ^ b;
      ALU_ADD:  res = a + b;
      ALU_SUB:  res = a - b;
      ALU_SLTU: res = (a < b) ? 32'd1 : 32'd0;
      ALU_SLT:  res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
      ALU_SLL:  res = a << b[4:0];
      ALU_SRL:  res = a >> b[4:0];
      ALU_SRA:  res = $signed(a) >>> b[4:0];
      // MUL OPS
      ALU_MUL:    res = sign_prod[31:0];
      ALU_MULH:   res = sign_prod[63:32];
      ALU_MULHU:  res = unsign_prod[63:32];
      ALU_MULHSU: res = multi_sign_prod[63:32];
      // DIV OPS
      ALU_DIV: begin
        if (is_zero) res = 32'hFFFF_FFFF;
        else if (is_overflow) res = 32'h8000_0000;
        else res = $signed(a) / $signed(b);
      end
      ALU_DIVU: begin
        if (is_zero) res = 32'hFFFF_FFFF;
        else res =  a / b;
      end
      ALU_REM: begin
        if (is_zero) res = a;
        else if (is_overflow) res = 32'b0;
        else res = $signed(a) % $signed(b);
      end
      ALU_REMU: begin
        if (is_zero) res = a;
        else res = a % b;
      end
      default: res = 32'b0;
    endcase
  end

  assign zero = (res == 32'b0);
  assign y = res;
endmodule
