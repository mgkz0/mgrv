module pcnextgen (
    input regwrite,
    input alusrc,
    input jump,
    input pcsrc,
    input trap,
    input [31:0] pc,
    input [31:0] rd1,
    input [31:0] immediate,
    /* verilator lint_off UNUSEDSIGNAL */
    input [31:0] mtvec_out,
    /* verilator lint_on UNUSEDSIGNAL */

    output reg [31:0] pcnext
);

  wire is_jalr;
  wire [31:0] pcplus4, pcnextbr, pcnextjalr, pcnexttrap;

  adder nextplus4 (
      .a(pc),
      .b(32'b100),
      .y(pcplus4)
  );
  adder nextpcbranch (
      .a(pc),
      .b(immediate),
      .y(pcnextbr)
  );
  assign pcnextjalr = (rd1 + immediate) & ~32'h1;
  assign pcnexttrap = {mtvec_out[31:2], 2'b00};

  assign is_jalr = (regwrite & alusrc & jump);

  always @(*) begin
    if (trap) begin
      pcnext = pcnexttrap;
    end else if (is_jalr) begin
      pcnext = pcnextjalr;
    end else if (jump | pcsrc) begin
      pcnext = pcnextbr;
    end else begin
      pcnext = pcplus4;
    end
  end

endmodule
