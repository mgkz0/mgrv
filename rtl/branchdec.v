module branchdec (
    input branch,
    input zero,
    input [2:0] func3,
    input aluout32b,
    output reg take_branch
);

  always @(*) begin
    take_branch = 1'b0;
    if (branch) begin
      case (func3)
        3'b000:  take_branch = zero;
        3'b001:  take_branch = ~zero;
        3'b100:  take_branch = aluout32b;
        3'b101:  take_branch = ~aluout32b;
        3'b110:  take_branch = aluout32b;
        3'b111:  take_branch = ~aluout32b;
        default: take_branch = 1'b0;
      endcase
    end
  end
endmodule
