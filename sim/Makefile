rtl_dir = ../rtl/
topfile = cprv_sim.sv
svfile = $(rtl_dir)cprv_top.sv $(rtl_dir)cprv_cpu.sv $(rtl_dir)cprv_ram_1p_w.sv $(rtl_dir)cprv_ram_1p.sv $(rtl_dir)cprv_if_stage.sv $(rtl_dir)cprv_id_stage.sv $(rtl_dir)cprv_ex_stage.sv $(rtl_dir)cprv_alu.sv $(rtl_dir)cprv_mem_stage.sv $(rtl_dir)cprv_wb_stage.sv $(rtl_dir)cprv_regfile.sv $(rtl_dir)cprv_rom_1p_w.sv cprv_rom_1p.sv $(rtl_dir)cprv_forwarding_mechanism.sv $(rtl_dir)cprv_staller.sv
top = cprv_sim
cppfile = sim.cpp
output_dir = obj_dir
output = cprv_sim
wave = wave.vcd

all: V$(output)

$(output_dir): $(svfile) $(top_file) $(cppfile)
	verilator --cc -Wno-lint --trace --top-module $(top) $(topfile) $(svfile) --exe $(cppfile)

V$(output): $(output_dir)
	cd ./$(output_dir) ; make -j -f V$(output).mk V$(output)

run: $(output_dir)/V$(output)
	./$(output_dir)/V$(output)

bin: test_bench.asm
	riscv64-unknown-elf-as test_bench.asm
	riscv64-unknown-elf-objdump -D a.out

.PHONY: clean 
clean:
	rm -r obj_dir wave.vcd a.out
