module systemgen (
    input [ 3:0] systemcode,
    input [31:0] rd1,
    input [31:0] csrrd,
    input [ 4:0] rs1,

    output reg [31:0] csrwd,
    output reg is_ebreak,
    output reg is_ecall
);
  wire [31:0] uimm;

  assign uimm = {27'b0, rs1};

  always @(*) begin
    is_ecall = 1'b0;
    is_ebreak = 1'b0;
    csrwd = 32'b0;
    case (systemcode)
      4'b0001: is_ecall = 1'b1;
      4'b0010: is_ebreak = 1'b1;
      // CSRRW / CSRRS / CSRRC
      4'b0011: csrwd = rd1;
      4'b0100: csrwd = csrrd | rd1;
      4'b0101: csrwd = csrrd & ~rd1;
      // CSRRWI / CSRRSI / RCSRRCI 
      4'b0110: csrwd = uimm;
      4'b0111: csrwd = csrrd | uimm;
      4'b1000: csrwd = csrrd & ~uimm;
      default: ;
    endcase
  end

endmodule
