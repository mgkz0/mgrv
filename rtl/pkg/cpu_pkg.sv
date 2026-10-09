package cpu_pkg;
typedef enum logic [4:0] {
    // DEFAULT OPS
    ALU_AND    = 5'b00000,
    ALU_OR     = 5'b00001,
    ALU_XOR    = 5'b00010,
    ALU_ADD    = 5'b00011,
    ALU_SUB    = 5'b00100,
    ALU_SLTU   = 5'b00101,
    ALU_SLT    = 5'b00110,
    ALU_SLL    = 5'b00111,
    ALU_SRL    = 5'b01000,
    ALU_SRA    = 5'b01001,
    // MUL OPS
    ALU_MUL    = 5'b01010,
    ALU_MULH   = 5'b01011,
    ALU_MULHU  = 5'b01100,
    ALU_MULHSU = 5'b01101,
    // DIV OPS
    ALU_DIV    = 5'b01110,
    ALU_DIVU   = 5'b01111,
    ALU_REM    = 5'b10000,
    ALU_REMU   = 5'b10001
  } alu_op_t;

endpackage
