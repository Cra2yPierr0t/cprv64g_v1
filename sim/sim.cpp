#include <iostream>
#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vcprv_sim.h"

unsigned int main_time = 0;

int main(int argc, char *argv[]){
    Verilated::commandArgs(argc, argv);

    Vcprv_sim *sim = new Vcprv_sim();

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    sim->trace(tfp, 99);
    tfp->open("wave.vcd");
    
    sim->clk = 0;
    unsigned int instr_addr;
    unsigned int instr_data;
    unsigned int id_rs1_data, id_rs2_data, id_imm_data, id_rd_addr, id_rd_en, id_mem_en;
    unsigned int ex_rs1_data, ex_rs2_data, ex_imm_data, ex_rd_addr, ex_rd_en, ex_mem_en, ex_alu_out;
    unsigned int mem_rs2_data, mem_rd_addr, mem_rd_en, mem_mem_en_dmem, mem_addr_dmem, mem_wdata_dmem;

    while(!Verilated::gotFinish()){

        sim->eval();

        instr_addr = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__if_stage__DOT__instr_addr_r;
        instr_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__instr_data_id;

        id_rs1_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__rs1_data_ex_o_r;
        id_rs2_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__rs2_data_ex_o_r;
        id_imm_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__imm_data_ex_o_r;
        id_rd_addr  = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__rd_addr_ex_o_r;
        id_rd_en    = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__rd_en_ex_o_r;
        id_mem_en   = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__id_stage__DOT__mem_w_en_ex_o_r;

        ex_rs1_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__rs1_data_mem_o_r;
        ex_rs2_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__rs2_data_mem_o_r;
        ex_imm_data = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__imm_data_mem_o_r;
        ex_rd_addr  = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__rd_addr_mem_o_r;
        ex_rd_en    = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__rd_en_mem_o_r;
        ex_mem_en   = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__mem_w_en_mem_o_r;
        ex_alu_out  = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__ex_stage__DOT__alu_out_mem_o_r;

        mem_rs2_data    = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__rs2_data_wb_o_r;
        mem_rd_addr     = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__rd_addr_wb_o_r;
        mem_rd_en       = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__rd_en_wb_o_r;
        mem_mem_en_dmem = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__w_en_dmem_o_r;
        mem_addr_dmem   = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__addr_dmem_o_r;
        mem_wdata_dmem  = (unsigned int)sim->cprv_sim__DOT__top__DOT__cpu__DOT__mem_stage__DOT__wdata_dmem_o_r;

        if(sim->clk == 1) {

            printf("--------------------\n");
            printf("|instr_addr: 0x%08x|rs1_data:\t%d|rs1_data:\t%d|               |WB\t|\n", instr_addr, id_rs1_data, ex_rs1_data);
            printf("|instr_data: 0x%08x|rs2_data:\t%d|rs2_data:\t%d|rs2_data:\t%d|WB\t|\n", instr_data, id_rs2_data, ex_rs2_data, mem_rs2_data);
            printf("|                      |imm_data:\t%d|imm_data:\t%d|               |WB\t|\n", id_imm_data, ex_imm_data);
            printf("|                      |rd_en:\t\t%d|rd_en:\t%d|rd_en:\t%d|WB\t|\n", id_rd_en, ex_rd_en, mem_rd_en);
            printf("|                      |rd_addr:\t%d|rd_addr:\t%d|rd_addr:\t%d|WB\t|\n", id_rd_addr, ex_rd_addr, mem_rd_addr);
            printf("|                      |mem_en:\t\t%d|mem_en:\t%d|mem_en:\t%d|WB\t|\n", id_mem_en, ex_mem_en, mem_mem_en_dmem);
            printf("|                      |                 |alu_out:\t%d|               |WB\t|\n", ex_alu_out);
            printf("|                      |                 |               |addr_dmem:\t%d|WB\t|\n", mem_addr_dmem);
            printf("|                      |                 |               |wdata_dmem:\t%d|WB\t|\n", mem_wdata_dmem);
        }

        tfp->dump(main_time);

        if(main_time > 100)
            break;

        sim->clk = !sim->clk;
        main_time++;
    }
    tfp->close();
    sim->final();
}
