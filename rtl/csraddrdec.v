module csraddrdec (
    input [11:0] extaddr,
    output reg [3:0] interaddr
);
  // MACHINE MODE
  localparam reg [11:0] MISA = 12'h301;
  // IDS REGS
  localparam reg [11:0] MVENDORID = 12'hF11;
  localparam reg [11:0] MARCHID = 12'hF12;
  localparam reg [11:0] MIMPID = 12'hF13;
  localparam reg [11:0] MHARTID = 12'hF14;
  // STATE REGS
  localparam reg [11:0] MSTATUS = 12'h300;
  localparam reg [11:0] MTVEC = 12'h305;
  localparam reg [11:0] MCAUSE = 12'h342;
  localparam reg [11:0] MEPC = 12'h341;
  // COUNTER REGS
  localparam reg [11:0] MCYCLE = 12'hB00;
  localparam reg [11:0] MCYCLEH = 12'hB80;

  always @(*) begin
    case (extaddr)
      MISA:      interaddr = 4'd1;
      MVENDORID: interaddr = 4'd2;
      MARCHID:   interaddr = 4'd3;
      MIMPID:    interaddr = 4'd4;
      MHARTID:   interaddr = 4'd5;
      MSTATUS:   interaddr = 4'd6;
      MTVEC:     interaddr = 4'd7;
      MCAUSE:    interaddr = 4'd8;
      MEPC:      interaddr = 4'd9;
      MCYCLE:    interaddr = 4'd10;
      MCYCLEH:   interaddr = 4'd11;
      default:   interaddr = 4'd0;
    endcase
  end
endmodule
