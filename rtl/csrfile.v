module csrfile (
    input wire rst,
    input wire clk,
    input wire we,
    input wire re,
    input wire [1:0] mode,
    /* verilator lint_off UNUSEDSIGNAL */
    input wire [11:0] extaddr,
    /* verilator lint_on UNUSEDSIGNAL */
    input wire [3:0] a,
    input wire [31:0] wd,

    input wire [31:0] mcause_in,
    input wire [31:0] pc,
    input wire trap,
    input wire is_mret,

    output wire [31:0] rd,

    output wire csr_exc,
    output wire [31:0] mtvec_out
);
  // regfile
  reg [31:0] rf[16];

  integer i;

  /* verilator lint_off UNUSEDPARAM */
  // MACHINE MODE
  localparam [3:0] MISA          = 4'd1;
  // IDS REGS
  localparam [3:0] MVENDORID     = 4'd2;
  localparam [3:0] MARCHID       = 4'd3;
  localparam [3:0] MIMPID        = 4'd4;
  localparam [3:0] MHARTID       = 4'd5;
  // STATE REGS
  localparam [3:0] MSTATUS       = 4'd6;
  localparam [3:0] MTVEC         = 4'd7;
  localparam [3:0] MCAUSE        = 4'd8;
  localparam [3:0] MEPC          = 4'd9;
  // COUNTER REGS
  localparam [3:0] MCYCLE        = 4'd10;
  localparam [3:0] MCYCLEH       = 4'd11;
  /* verilator lint_on UNUSEDPARAM */

  localparam       MISA_STATE    = 32'h401410F8;
  localparam       MSTATUS_STATE = 32'h0000_1800;

  assign csr_exc = (re && (mode < extaddr[9:8])) || (we && (mode < extaddr[9:8]));

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 16; i = i + 1) rf[i] <= 32'b0;
      rf[MISA]    <= MISA_STATE;
      rf[MSTATUS] <= MSTATUS_STATE;
      // MTVEC, MEPC, MCAUSE can stay 0
    end else begin
      if (trap) begin
        rf[MEPC] <= pc;
        rf[MCAUSE] <= mcause_in;

        rf[MSTATUS][7] <= rf[MSTATUS][3];  // MPIE 
        rf[MSTATUS][3] <= 1'b0;  // MIE
        rf[MSTATUS][12:11] <= mode;  // CPU Mode
      end else if (is_mret) begin
        rf[MSTATUS][3] <= rf[MSTATUS][7];  // MIE
        rf[MSTATUS][7] <= 1'b1;  // MPIE
        rf[MSTATUS][12:11] <= 2'b11;
      end else begin
        if (we && !csr_exc) begin
          rf[a] <= wd;
        end
      end
      if (a != MCYCLE && a != MCYCLEH && !trap) begin
        if (rf[MCYCLE] != 32'hFFFFFFFF) begin
          rf[MCYCLE] <= rf[MCYCLE] + 1;
        end else begin
          rf[MCYCLE] <= 0;
          if (rf[MCYCLEH] != 32'hFFFFFFFF) begin
            rf[MCYCLEH] <= rf[MCYCLEH] + 1;
          end else begin
            rf[MCYCLE]  <= 0;
            rf[MCYCLEH] <= 0;
          end
        end
      end
    end
  end

  assign mtvec_out = rf[MTVEC];
  assign rd = re ? rf[a] : is_mret ? rf[MEPC] : 32'b0;

endmodule
