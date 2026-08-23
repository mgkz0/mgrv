module mux2 (
    input [WIDTH-1:0] d0,
    d1,
    input s,
    output [WIDTH-1:0] y
);

  parameter WIDTH = 8;

  assign y = s ? d1 : d0;

endmodule
