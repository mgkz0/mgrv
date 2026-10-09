module mux2 #(
    parameter int WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input s,
    output [WIDTH-1:0] y
);

  assign y = s ? b : a;

endmodule
