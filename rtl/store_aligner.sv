module store_aligner (
    input [ 2:0] storecode,
    input [31:0] wd,
    input [ 1:0] offset,

    output reg [ 3:0] wstrb,
    output reg [31:0] aligned
);

  wire [3:0] wstrb_h, wstrb_b;
  wire [31:0] hd, bd;

  mux2 #(4) shmux (
      .a(4'b0011),
      .b(4'b1100),
      .s(offset[1]),
      .y(wstrb_h)
  );

  mux4 #(4) sbmux (
      .a(4'b0001),
      .b(4'b0010),
      .c(4'b0100),
      .d(4'b1000),
      .s(offset),
      .y(wstrb_b)
  );

  mux2 #(32) shdmux (
      .a({16'b0, wd[15:0]}),
      .b({wd[15:0], 16'b0}),
      .s(offset[1]),
      .y(hd)
  );

  mux4 #(32) sbdmux (
      .a({24'b0, wd[7:0]}),
      .b({16'b0, wd[7:0], 8'b0}),
      .c({8'b0, wd[7:0], 16'b0}),
      .d({wd[7:0], 24'b0}),
      .s(offset),
      .y(bd)
  );

  typedef enum logic [2:0] {
    SB = 3'b000,
    SH = 3'b001,
    SW = 3'b010
  } storecode_t;

  always_comb begin
    case (storecode)
      SW: begin
        aligned = wd;
        wstrb   = 4'b1111;
      end
      SH: begin
        aligned = hd;
        wstrb   = wstrb_h;
      end
      SB: begin
        aligned = bd;
        wstrb   = wstrb_b;
      end
      default: begin
        aligned = 32'b0;
        wstrb   = 4'b0000;
      end
    endcase
  end
endmodule
