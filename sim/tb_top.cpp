#include <verilated_vcd_c.h>
#include "Vtop.h"
#include "elfloader.h"
#include <iostream>
#include <cstdint>
#include <vector>
#include <bitset>
#include <string>

constexpr uint32_t IMEM_BASE_ADDR     = 0x80000000;
constexpr uint32_t TOHOST_ADDR        = 0x80001000;
constexpr uint64_t DEFAULT_MAX_CYCLES = 1000000;
constexpr uint8_t  INIT_SIM_CYCLES    = 10;
constexpr uint8_t  PRINT_PC_CYCLES    = 16;

inline void print_bin32(const char* label, uint32_t value) {
    std::cout << label
              << "0x" << std::hex << value << std::dec << "\n";
              //<< " 32'd " << value << "\n";
}

void init_sim(Vtop* top, uint8_t cycles) {
    top->clk = 0;
    top->rst = 1;
    top->i_memwrite = 0;
    top->w_instr = 0;

    for (uint8_t i = 0; i < cycles; ++i) {
        top->clk = !top->clk;
        top->eval();
    }
}

void load_program_into_imem(Vtop* top, const ElfProgram& prog) {
    uint32_t addr = IMEM_BASE_ADDR;
    
    std::cout << "ADDR: " << addr << "\n";
    std::cout << "DATA SIZE: " << prog.data.size() << "\n";

    uint32_t cnt = 0;
    size_t idx = 0;
    while (idx < prog.data.size()) {
        uint32_t word = prog.data[idx] |
                        (prog.data[idx + 1] << 8) |
                        (prog.data[idx + 2] << 16) |
                        (prog.data[idx + 3] << 24);
        idx += 4;
	cnt += 1;
        top->i_memwrite = 1;
        top->pc = addr;
        top->w_instr = word;
	//if (cnt <= 700) {
	//	print_bin32("INSR: ", word);
	//}
	top->clk = !top->clk; top->eval();
        top->clk = !top->clk; top->eval();

        addr += 4;
    }

    top->i_memwrite = 0;
    top->w_instr = 0;
}

void run_cpu(Vtop* top, VerilatedVcdC* tfp, uint64_t max_cycles, const std::string& test_name) {
    bool passed = false;
    uint64_t pass_cycle = 0;

    bool is_pc_208 = false;
    vluint64_t t = 0;

    top->rst = 1;
    top->clk = 0;
    top->eval();
    tfp->dump(t++);

    top->clk = 1;
    top->eval();
    tfp->dump(t++);
	
    top->rst = 0;
    top->clk = 0;
    top->eval();
    tfp->dump(t++);
    
    uint32_t cnt = 0;
    std::cout << "START PC: " << top->pc << "\n";
    for (uint64_t cycle = 0; cycle < max_cycles; ++cycle) {
        top->clk = 1;
        top->eval();
        tfp->dump(t++);	
	cnt += 1;
	if (cnt <= 100) {
		//std::cout << "NOW PC: " << top->pc << "\n";
		print_bin32("NOW PC:", top->pc);
		print_bin32("INSTR: ", top->r_instr); 
	}
	if (!is_pc_208) {
		//std::cout << "NOW PC: " << top->pc << "\n";
	}
	if (!is_pc_208 && top->pc == 208) {
		is_pc_208 = true;
	}
        if (!passed &&
            top->d_memwrite &&
            top->d_memaddr == TOHOST_ADDR &&
            top->writedata != 0) {
            passed = true;
            pass_cycle = cycle;
        }

        top->clk = 0;
        top->eval();
        tfp->dump(t++);
    }
    print_bin32("END INSTR: \n", top->r_instr);	
    std::cout << "END PC: " << top->pc << "\n";
    std::cout << "[" << test_name << "] ";
    if (passed) {
        std::cout << "[PASS]\n";
    } else {
        std::cout << "[FAIL]\n";
    }
}

int main(int argc, char** argv) {
    Verilated::traceEverOn(true);
    
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <elf-file>\n";
        return 1;
    }
    
    const char* elf_path = argv[1];
    ElfProgram prog = load_elf(elf_path);

    std::string test_name = elf_path;
    size_t pos = test_name.find_last_of('/');
    if (pos != std::string::npos) {
        test_name = test_name.substr(pos + 1);
    }

    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;

    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 0);
    tfp->open("trace.vcd");

    init_sim(top, INIT_SIM_CYCLES);
    load_program_into_imem(top, prog);
    run_cpu(top, tfp, DEFAULT_MAX_CYCLES, test_name);
   
    tfp->close();
    delete top;
    return 0;
}
