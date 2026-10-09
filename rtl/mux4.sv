module mux4 #(
    parameter int WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    input [1:0] s,
    output reg [WIDTH-1:0] y
);
  always_comb begin
    case (s)
      2'b00:   y = a;
      2'b01:   y = b;
      2'b10:   y = c;
      2'b11:   y = d;
      default: y = 0;
    endcase
  end
endmodule
