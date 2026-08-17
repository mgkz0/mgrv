module alu(
 input wire [4:0] opcode,
 input wire [31:0] a, b,

 output wire [31:0] y,
 output wire zero
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

/* verilator lint_off UNUSEDSIGNAL */
wire [63:0] sign_prod = $signed(a) * $signed(b);
wire [63:0] unsign_prod = a * b;
wire [63:0] multi_sign_prod = $signed(a) * $signed({1'b0, b});
/* verilator lint_on UNUSEDSIGNAL */

wire is_zero = (b == 32'b0);
wire is_overflow = (a == 32'h8000_0000) && (b == 32'hFFFF_FFFF);

reg [31:0] res;

wire [31:0] b_and, b_or, b_xor, sum, dif, slt, ult, lsl, lsr, lsra;
wire [31:0] mul, mulh, mulhu, mulhsu, div, divu, rem, remu;

assign b_and = a & b;
assign b_or = a | b;
assign b_xor = a ^ b;
assign sum = a + b;
assign dif = a - b;

assign ult = (a < b) ? 32'b1 : 32'b0;
assign slt = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;

assign lsl = a << b[4:0];
assign lsr = a >> b[4:0];
assign lsra = $signed(a) >>> b[4:0];

assign mul = sign_prod[31:0];
assign mulh = sign_prod[63:32];
assign mulhu = unsign_prod[63:32];
assign mulhsu = multi_sign_prod[63:32];

assign div = $signed(a) / $signed(b);
assign divu = a / b;
assign rem = $signed(a) % $signed(b);
assign remu = a % b;

always @(*) begin
 case (opcode)
  ALU_AND:    res = b_and;
  ALU_OR:     res = b_or;
  ALU_XOR:    res = b_xor;
  ALU_ADD:    res = sum;
  ALU_SUB:    res = dif;
  ALU_SLTU:   res = ult;
  ALU_SLT:    res = slt;
  ALU_SLL:    res = lsl;
  ALU_SRL:    res = lsr;
  ALU_SRA:    res = lsra;

  ALU_MUL:    res = mul;
  ALU_MULH:   res = mulh;
  ALU_MULHU:  res = mulhu;
  ALU_MULHSU: res = mulhsu;
  
  ALU_DIV: begin
   if (is_zero) res = 32'hFFFF_FFFF;
   else if (is_overflow) res = 32'h8000_0000;
   else res = div;
  end

  ALU_DIVU: begin
   if (is_zero) res = 32'hFFFF_FFFF;
   else res = divu;
  end

  ALU_REM: begin
   if (is_zero) res = a;
   else if (is_overflow) res = 32'b0;
   else res = rem;
  end

  ALU_REMU: begin
   if (is_zero) res = a;
   else res = remu;
  end

  default: res = 32'b0;
 endcase
end

assign zero = (res == 32'b0);
assign y = res;

endmodule
