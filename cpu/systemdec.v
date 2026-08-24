module systemdec (
    input is_system,
    input [31:0] instr,

    output csrregwrite,
    output csrwrite,
    output csrread,
    output [3:0] systemcode
);

  wire [2:0] func3;
  wire is_csr, is_rd, is_rs1;

  reg [5:0] controls;

  assign func3 = instr[14:12];
  assign is_csr = (is_system && func3 != 3'b000 && func3 != 3'b100);

  assign is_rd = (instr[11:7] != 5'd0);
  assign is_rs1 = (instr[19:15] != 5'd0);

  assign csrregwrite = is_csr && is_rd;

  // Signal Mapping:
  // controls = {csrread, csrwrite, systemcode[3:0]}
  assign {csrread, csrwrite, systemcode} = controls;

  always @(*) begin
    controls = 6'b00_0000;
    if (is_system) begin
      case (func3)
        // EBREAK / ECALL
        3'b000:
        controls = (instr == 32'h0000_0073) ? 6'b00_0001 : (instr == 32'h0010_0073) ? 6'b00_0010 : 6'b00_0000;
        // CSRRW
        3'b001: controls = is_rd ? 6'b11_0011 : 6'b01_0011;
        // CSRRS
        3'b010: controls = is_rs1 ? 6'b11_0100 : 6'b10_0100;
        // CSRRC
        3'b011: controls = is_rs1 ? 6'b11_0101 : 6'b10_0101;
        // CSRRWI
        3'b101: controls = is_rd ? 6'b11_0110 : 6'b01_0110;
        // CSRRSI
        3'b110: controls = is_rs1 ? 6'b11_0111 : 6'b10_0111;
        // CSRRCI
        3'b111: controls = is_rs1 ? 6'b11_1000 : 6'b10_1000;
        default: controls = 6'b00_0000;
      endcase
    end
  end

endmodule
