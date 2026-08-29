TOP = top

all:
	verilator --cc --exe --build --trace --timing --timescale 1ns/1ps -Wall -j 0 \
		-Mdir obj_dir \
		-I../rtl \
		../rtl/top.v \
		./tb_top.cpp \
		./elfloader.cpp \
		

run: all
	./obj_dir/V$(TOP) ../tests/riscv/rv32ui-p-addi

clean:
	rm -rf obj_dir
