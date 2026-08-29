#pragma once
#include <cstdint>
#include <vector>
#include <string>

struct ElfProgram {
    std::vector<uint8_t> data;   // flat memory image
    uint32_t base_addr;          // load address (expected 0)
    uint32_t entry;              // entry point (PC start)
};

// Load a simple RV32 ELF file. Assumes:
// - 32-bit little-endian ELF
// - At least one PT_LOAD segment
// - You're okay using the first PT_LOAD's vaddr as base_addr
ElfProgram load_elf(const std::string& path);

