# sim/Makefile

# For https://github.com/riscv-software-src/riscv-tests
RISCV_TESTS = ../../riscv-tests/isa

TOP = top

# Build
all:
	@verilator --cc --exe --build --trace --timing --timescale 1ns/1ps -Wall -j 0 \
		-Mdir obj_dir \
		-I../rtl \
		../rtl/top.v \
		../rtl/rv32_main.v \
		../rtl/ram.v \
		../rtl/dataram32.v \
		tb_top.cpp \
		elfloader.cpp

# RV32UI – base integer ISA (all tests)
run-ui:
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-add
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-addi
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-and
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-andi
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-auipc
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-beq
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-bge
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-bgeu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-blt
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-bltu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-bne
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-fence_i
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-jal
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-jalr
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lb
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lbu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lh
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lhu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lw
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-lui
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-or
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-ori
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sb
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sh
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-simple
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sll
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-slli
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-slt
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-slti
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sltiu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sltu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sra
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-srai
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-srl
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-srli
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-st_ld
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sub
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-sw
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-xor
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32ui-p-xori
	@echo "All RV32UI tests done"

# RV32UM – M extension (multiply/divide/rem)
run-m:
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-div
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-divu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-mul
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-mulh
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-mulhsu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-mulhu
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-rem
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32um-p-remu
	@echo "All RV32UM tests done"

# RV32MI – machine mode / CSR / traps (Zicsr, M-mode only subset)
run-csr:
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32mi-p-csr
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32mi-p-mcsr
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32mi-p-breakpoint
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32mi-p-illegal
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/rv32mi-p-shamt
	@echo "Selected RV32MI CSR/trap tests done"

# Run everything relevant for RV32IM + Zicsr (M-mode only)
run-all: run-ui run-m run-csr

# Single test runner: make run-test TEST=rv32ui-p-addi
TEST ?= rv32ui-p-simple
run-test:
	@./obj_dir/V$(TOP) $(RISCV_TESTS)/$(TEST)

# Clean
clean:
	@rm -rf obj_dir
