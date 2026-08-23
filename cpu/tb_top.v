module tb_top;

  reg rst, clk;
  wire d_memwrite;
  wire [31:0] writedata;
  wire [31:0] d_memaddr;

  // Success conditions
  localparam SUCCESS_ADDR = 32'd128;
  localparam SUCCESS_VAL  = 32'd256;

  top dut (
      .clk(clk),
      .rst(rst),
      .i_memwrite(1'b0),
      .w_instr(32'b0),
      .d_memwrite(d_memwrite),
      .writedata(writedata),
      .d_memaddr(d_memaddr)
  );

  // Clock Generation
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  initial begin
    // 1. Load instructions into Instruction Memory
    $readmemh("cpu/memfile.hex", dut.imem.mem);

    // 2. Reset Sequence
    rst = 1;
    #22;
    rst = 0;

    // 3. Timeout Safety
    #2000;
    $display("Simulation timed out! Hardware is likely stuck.");
    $finish;
  end

  always @(negedge clk) begin
    //$display("TIME: %t | Write - Addr: %d | Data: %d", $time, d_memaddr, $signed(writedata));
    $display("TIME: %t | PC: %h | d_memwrite: %b | d_memaddr: %d | writedata: %d", $time, dut.pc,
             d_memwrite, d_memaddr, $signed(writedata));
    if (d_memwrite) begin
      if (d_memaddr == SUCCESS_ADDR) begin
        if (writedata == SUCCESS_VAL) begin
          $display("Simulation passed! RV32IM support verified.");
          $finish;
        end else begin
          $display("Simulation failed! Got %d, expected %d", $signed(writedata), SUCCESS_VAL);
          $finish;
        end
      end
    end
  end
endmodule
