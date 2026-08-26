module csrfile (
    input wire rst,
    input wire clk,
    input wire we,
    input wire re,
    input wire [1:0] mode,
    input wire [11:0] a,
    input wire [31:0] wd,

    input wire [31:0] mcause_in,
    input wire [31:0] pc,
    input wire trap,

    output wire [31:0] rd,

    output wire csr_exc,
    output wire [31:0] mtvec_out
);
  // regfile
  reg [31:0] rf[16];
  
  integer i;

  // MACHINE MODE
  parameter reg [11:0] MISA = 12'h301;
  // IDS REGS
  parameter reg [11:0] MVENDORID = 12'hF11;
  parameter reg [11:0] MARCHID = 12'hF12;
  parameter reg [11:0] MIMPID = 12'hF13;
  parameter reg [11:0] MHARTID = 12'hF14;
  // STATE REGS
  parameter reg [11:0] MSTATUS = 12'h300;
  parameter reg [11:0] MTVEC = 12'h305;
  parameter reg [11:0] MCAUSE = 12'h342;
  parameter reg [11:0] MEPC = 12'h341;
  // COUNTER REGS
  parameter reg [11:0] MCYCLE = 12'hB00;
  parameter reg [11:0] MCYCLEH = 12'hB80;


  localparam MISA_STATE = 32'h401410F8;
  localparam MSTATUS_STATE = 32'h0000_1800;

  function automatic [3:0] get_idx;
    input [11:0] addr;
    begin
      case (addr)
        // MACHINE MODE
        MISA:      get_idx = 4'd1;
        MVENDORID: get_idx = 4'd2;
        MARCHID:   get_idx = 4'd3;
        MIMPID:    get_idx = 4'd4;
        MHARTID:   get_idx = 4'd5;
        MSTATUS:   get_idx = 4'd6;
        MTVEC:     get_idx = 4'd7;
        MCAUSE:    get_idx = 4'd8;
        MEPC:      get_idx = 4'd9;
        MCYCLE:    get_idx = 4'd10;
        MCYCLEH:   get_idx = 4'd11;
        // DEFAULT (ZERO FOR EXCEPTION)
        default:   get_idx = 4'd0;
      endcase
    end
  endfunction


  assign csr_exc =
    (re && (mode < a[9:8])) ||
    (we && (mode < a[9:8])) ||
    (we && (a[11:10] == 2'b11)) ||
    (we && (get_idx(
      a
  ) == 4'd0)) || (re && (get_idx(
      a
  ) == 4'd0));


  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 16; i = i + 1) rf[i] <= 32'b0;
      rf[get_idx(MISA)] <= MISA_STATE;
      rf[get_idx(MSTATUS)] <= MSTATUS_STATE;

    end else begin
      if (trap) begin
        rf[get_idx(MEPC)]   <= pc;
        rf[get_idx(MCAUSE)] <= mcause_in;
      end else begin
        if (we) begin
          rf[get_idx(a)] <= wd;
        end
      end
      if (a != MCYCLE && a != MCYCLEH && !trap) begin
        if (rf[get_idx(MCYCLE)] != 32'hFFFFFFFF) begin
          rf[get_idx(MCYCLE)] <= rf[get_idx(MCYCLE)] + 1;
        end else begin
          rf[get_idx(MCYCLE)] <= 0;
          if (rf[get_idx(MCYCLEH)] != 32'hFFFFFFFF) begin
            rf[get_idx(MCYCLEH)] <= rf[get_idx(MCYCLEH)] + 1;
          end else begin
            rf[get_idx(MCYCLE)]  <= 0;
            rf[get_idx(MCYCLEH)] <= 0;
          end
        end
      end
    end
  end

  assign mtvec_out = rf[get_idx(MTVEC)];
  assign rd = re ? rf[get_idx(a)] : 32'b0;

endmodule
