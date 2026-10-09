module csraddrdec (
    input [11:0] extaddr,
    output reg [3:0] interaddr
);
  typedef enum logic [11:0] {
    MISA      = 12'h301,
    MVENDORID = 12'hF11,
    MARCHID   = 12'hF12,
    MIMPID    = 12'hF13,
    MHARTID   = 12'hF14,
    MSTATUS   = 12'h300,
    MTVEC     = 12'h305,
    MCAUSE    = 12'h342,
    MEPC      = 12'h341,
    MCYCLE    = 12'hB00,
    MCYCLEH   = 12'hB80
  } csr_addr_t;

  always_comb begin
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
