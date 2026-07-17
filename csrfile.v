module csrfile(
 input wire clk,
 input wire we,
 input wire [1:0] mode,
 input wire [11:0] ra, wa,
 input wire [31:0] wd,

 output wire csr_exc,
 output wire [31:0] rd
);

// MODES
parameter reg [1:0] MACHINE = 2'b11;
parameter reg [1:0] SUPERVISOR = 2'b01;
parameter reg [1:0] USER = 2'b00;

// REGFILE
reg [31:0] rf [29];

// MACHINE MODE
parameter reg [11:0] MISA = 12'h301;
// IDS REGS
parameter reg [11:0] MVENDORID = 12'hF11;
parameter reg [11:0] MARCHID = 12'hF12;
parameter reg [11:0] MIMPID = 12'hF13;
parameter reg [11:0] MHARTID = 12'hF14;
parameter reg [11:0] MCONFIGPTR = 12'hF15;
// STATE REGS
parameter reg [11:0] MSTATUS = 12'h300;
parameter reg [11:0] MSTATUSH = 12'h310;
parameter reg [11:0] MTVEC = 12'h305;
parameter reg [11:0] MCAUSE = 12'h342;

// USER MODE
// FLOATING-POINT REGS
parameter reg [11:0] FFLAGS = 12'h001;
parameter reg [11:0] FRM = 12'h002;
parameter reg [11:0] FCSR = 12'h003;
// COUNTER REGS
parameter reg [11:0] CYCLE = 12'hC00;
parameter reg [11:0] TIME = 12'hC01;
parameter reg [11:0] INSTRET = 12'hC02;
// RV32 COUNTER REGS
parameter reg [11:0] CYCLEH = 12'hC80;
parameter reg [11:0] TIMEH = 12'hC81;
parameter reg [11:0] INSTRETH = 12'hC82;


// SUPERVISOR MODE
// STATE REGS
parameter reg [11:0] SSTATUS = 12'h100;
parameter reg [11:0] STVEC = 12'h105;
parameter reg [11:0] SIE = 12'h104;
parameter reg [11:0] SIP = 12'h144;
parameter reg [11:0] SCOUNTEREN = 12'h106;
parameter reg [11:0] SSCRATCH = 12'h140;
parameter reg [11:0] SEPC = 12'h141;
parameter reg [11:0] SCAUSE = 12'h142;
parameter reg [11:0] STVAL = 12'h143;
// MMU REGS
parameter reg [11:0] SATP = 12'h180;


function automatic [4:0] get_idx;
 input [11:0] addr;
 begin
  case (addr)
   // MACHINE MODE
   MISA:        get_idx = 5'd0;
   MVENDORID:   get_idx = 5'd1;
   MARCHID:     get_idx = 5'd2;
   MIMPID:      get_idx = 5'd3;
   MHARTID:     get_idx = 5'd4;
   MCONFIGPTR:  get_idx = 5'd5;
   MSTATUS:     get_idx = 5'd6;
   MSTATUSH:    get_idx = 5'd7;
   MTVEC:       get_idx = 5'd8;
   MCAUSE:      get_idx = 5'd9;
   // SUPERVISOR MODE
   SSTATUS:     get_idx = 5'd19;
   STVEC:       get_idx = 5'd20;
   SIE:         get_idx = 5'd21;
   SIP:         get_idx = 5'd22;
   SCOUNTEREN:  get_idx = 5'd23;
   SSCRATCH:    get_idx = 5'd24;
   SEPC:        get_idx = 5'd25;
   SCAUSE:      get_idx = 5'd26;
   STVAL:       get_idx = 5'd27;
   SATP:        get_idx = 5'd28;
   // USER MODE
   FFLAGS:      get_idx = 5'd10;
   FRM:         get_idx = 5'd11;
   FCSR:        get_idx = 5'd12;
   CYCLE:       get_idx = 5'd13;
   TIME:        get_idx = 5'd14;
   INSTRET:     get_idx = 5'd15;
   CYCLEH:      get_idx = 5'd16;
   TIMEH:       get_idx = 5'd17;
   INSTRETH:    get_idx = 5'd18;

   default:     get_idx = 5'd0;
  endcase
 end
endfunction

always @(posedge clk) begin
 if (we) begin
  if (wa[11:10] == 2'b11) begin
   csr_exc <= 1;
  end else begin
   rf[get_idx(wa)] <= wd;
  end
 end
end

assign rd = (ra != 0) ? rf[get_idx(ra)] : 0;

endmodule
