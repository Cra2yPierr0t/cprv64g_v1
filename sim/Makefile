rtl_dir = ../rtl/
topfile = cprv_sim.sv
svfile = $(rtl_dir)cprv_top.sv $(rtl_dir)cprv_cpu.sv $(rtl_dir)cprv_ram_1p_w.sv $(rtl_dir)cprv_ram_1p.sv $(rtl_dir)cprv_if_stage.sv $(rtl_dir)cprv_id_stage.sv $(rtl_dir)cprv_ex_stage.sv $(rtl_dir)cprv_alu.sv $(rtl_dir)cprv_mem_stage.sv $(rtl_dir)cprv_wb_stage.sv $(rtl_dir)cprv_regfile.sv
top = cprv_sim
cppfile = sim.cpp
output_dir = obj_dir
output = cprv_sim

all: V$(output)

$(output_dir): $(svfile) $(top_file) $(cppfile)
	verilator --cc -Wno-lint --trace --top-module $(top) $(topfile) $(svfile) --exe $(cppfile)

V$(output): $(output_dir)
	cd ./$(output_dir) ; make -j -f V$(output).mk V$(output)

run: V$(output)
	./$(output_dir)/V$(output)

.PHONY: clean
clean:
	rm -r obj_dir wave.vcd
