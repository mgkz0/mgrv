#include "elfloader.h"
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <cstdint>

ElfProgram load_elf(const std::string& path) {
    std::ifstream f(path, std::ios::binary);
    if (!f) {
        throw std::runtime_error("Cannot open ELF: " + path);
    }

    // Read e_ident[16]
    uint8_t e_ident[16];
    f.read(reinterpret_cast<char*>(e_ident), 16);
    if (!f || e_ident[0] != 0x7f || e_ident[1] != 'E' ||
        e_ident[2] != 'L' || e_ident[3] != 'F') {
        throw std::runtime_error("Not an ELF file: " + path);
    }
    if (e_ident[4] != 1) { // ELFCLASS32
        throw std::runtime_error("Not a 32-bit ELF: " + path);
    }
    if (e_ident[5] != 1) { // ELFDATA2LSB (little-endian)
        throw std::runtime_error("Not a little-endian ELF: " + path);
    }

    f.seekg(0);

    // ELF32 header (relevant fields)
    struct Elf32_Ehdr {
        uint8_t  e_ident[16];
        uint16_t e_type;
        uint16_t e_machine;
        uint32_t e_version;
        uint32_t e_entry;
        uint32_t e_phoff;
        uint32_t e_shoff;
        uint32_t e_flags;
        uint16_t e_ehsize;
        uint16_t e_phentsize;
        uint16_t e_phnum;
        uint16_t e_shentsize;
        uint16_t e_shnum;
        uint16_t e_shstrndx;
    } ehdr;

    f.read(reinterpret_cast<char*>(&ehdr), sizeof(ehdr));
    if (!f) {
        throw std::runtime_error("Failed to read ELF header");
    }

    uint32_t entry   = ehdr.e_entry;
    uint32_t phoff   = ehdr.e_phoff;
    uint16_t phnum   = ehdr.e_phnum;
    uint16_t phentsz = ehdr.e_phentsize;

    // Program header (32-bit)
    struct Elf32_Phdr {
        uint32_t p_type;
        uint32_t p_offset;
        uint32_t p_vaddr;
        uint32_t p_paddr;
        uint32_t p_filesz;
        uint32_t p_memsz;
        uint32_t p_flags;
        uint32_t p_align;
    };

    // Find first PT_LOAD
    uint32_t base_addr = 0;
    uint32_t mem_size  = 0;
    uint32_t file_off  = 0;
    bool found = false;

    for (uint16_t i = 0; i < phnum; ++i) {
        Elf32_Phdr ph;
        f.seekg(phoff + i * phentsz);
        f.read(reinterpret_cast<char*>(&ph), sizeof(ph));
        if (!f) {
            throw std::runtime_error("Failed to read program header");
        }

        if (ph.p_type == 1) { // PT_LOAD
            base_addr = ph.p_vaddr;
            mem_size  = ph.p_memsz;
            file_off  = ph.p_offset;
            found = true;
            break; // use first PT_LOAD only
        }
    }

    if (!found) {
        throw std::runtime_error("No PT_LOAD segment found in ELF");
    }

    // Read segment data
    std::vector<uint8_t> image(mem_size, 0);
    f.seekg(file_off);
    f.read(reinterpret_cast<char*>(image.data()), mem_size);
    if (!f && !f.eof()) {
        throw std::runtime_error("Failed to read segment data from ELF");
    }

    ElfProgram prog;
    prog.data      = std::move(image);
    prog.base_addr = base_addr;
    prog.entry     = entry;
    return prog;
}
