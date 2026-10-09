module load_aligner (
    input [31:0] rd,
    input [ 1:0] offset,
    input [ 2:0] loadcode,

    output reg [31:0] aligned
);
  wire [15:0] hd;
  wire [ 7:0] bd;

  typedef enum logic [2:0] {
    LW  = 3'b001,
    LH  = 3'b010,
    LHU = 3'b011,
    LB  = 3'b100,
    LBU = 3'b101
  } loadcode_t;

  mux2 #(16) lhmux (
      .a(rd[15:0]),
      .b(rd[31:16]),
      .s(offset[1]),
      .y(hd)
  );

  mux4 #(8) lbmux (
      .a(rd[7:0]),
      .b(rd[15:8]),
      .c(rd[23:16]),
      .d(rd[31:24]),
      .s(offset),
      .y(bd)
  );

  always_comb begin
    case (loadcode)
      LW: aligned = rd;
      LH: aligned = {{16{hd[15]}}, hd};
      LHU: aligned = {{16{1'b0}}, hd};
      LB: aligned = {{24{bd[7]}}, bd};
      LBU: aligned = {{24{1'b0}}, bd};
      default: aligned = 32'b0;
    endcase
  end
endmodule
