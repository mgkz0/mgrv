#include <verilated_vcd_c.h>
#include "Vtop.h"
#include "elfloader.h"
#include <iostream>
#include <cstdint>
#include <vector>


// Initialize and reset the simulation
void init_sim(Vtop* top, uint8_t cycles) {
    top->clk = 0;
    top->rst = 1;
    top->i_memwrite = 0;
    top->w_instr = 0;

    for (uint8_t i = 0; i < cycles; ++i) {
        top->clk = !top->clk;
    	top->eval();
    }
    top->rst = 0;
}

// Load ELF image into imem using i_memwrite/w_instr
void load_program_into_imem(Vtop* top, const ElfProgram& prog) {
    uint32_t base = 0;  // e.g. 0x80000000

    uint32_t addr = base;
    std::cout << "ADDR: " << addr << "\n";
    size_t idx = 0;
    std::cout << "DATA SIZE: " << prog.data.size() << "\n";
    while (idx < prog.data.size()) {
        // Fetch 4 bytes as one word (little-endian)
        uint32_t word = prog.data[idx] |
                        (prog.data[idx + 1] << 8) |
                        (prog.data[idx + 2] << 16) |
                        (prog.data[idx + 3] << 24);
        idx += 4;

        // Drive loader
        top->i_memwrite = 1;
        top->w_instr = word;

        // One full clock cycle to commit the write
        top->clk = !top->clk; top->eval();
        top->clk = !top->clk; top->eval();

        addr += 4;
    }

    // Finish loading
    top->i_memwrite = 0;
    top->w_instr = 0;
}

// Run the CPU for up to max_cycles, optionally checking for pass
void run_cpu(Vtop* top, VerilatedVcdC* tfp, uint64_t max_cycles, uint32_t pass_addr = 0) {
    bool has_pass_addr = (pass_addr != 0);
    bool passed = false;
    std::cout << "START PC: " << top->pc << "\n";
    for (uint64_t cycle = 0; cycle < max_cycles; ++cycle) {
        // Rising edge
        top->clk = 1;
        top->eval();
        tfp->dump(static_cast<vluint64_t>(cycle * 2));
	//std::cout << "pc: " << top->pc << "\n";
        // Optional pass check (e.g., PC == pass_addr)
        if (has_pass_addr && !passed) {
            uint32_t pc = top->pc; // or top->pc_dbg if you exposed that
            if (pc == pass_addr) {
                std::cout << "PASS at cycle " << cycle << "\n";
                passed = true;
                // You can break here if you want to stop immediately:
                // break;
            }
        }
	
        // Falling edge
        top->clk = 0;
        top->eval();
        tfp->dump(static_cast<vluint64_t>(cycle * 2 + 1));
    }
    std::cout << "END PC: " << top->pc << "\n";

    if (!has_pass_addr) {
        std::cout << "Ran " << max_cycles << " cycles (no pass check)\n";
    } else if (!passed) {
        std::cout << "FAIL: did not reach PASS_ADDR within " << max_cycles << " cycles\n";
    }
}

int main(int argc, char** argv) {
    Verilated::traceEverOn(true);
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <elf-file>\n";
        return 1;
    }
    const char* elf_path = argv[1];

    // Load ELF file
    ElfProgram prog = load_elf(elf_path);

    // Create simulation top
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    // Setup tracing for GTKWave
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 0);
    tfp->open("trace.vcd");

    // Initialize and reset
    init_sim(top, 10);

    // Load program into instruction memory
    load_program_into_imem(top, prog);

    // Optional: determine PASS_ADDR from disassembly and pass it here
    // For now, 0 means "no pass check"
    uint32_t pass_addr = 0;

     // Run CPU
    run_cpu(top, tfp, 1000000, pass_addr);
   
    // Cleanup
    tfp->close();
    delete top;
    return 0;
}
