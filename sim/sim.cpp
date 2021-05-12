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

    while(!Verilated::gotFinish()){
        if((main_time % 2) == 0)
            sim->clk = !sim->clk;

        sim->eval();
        tfp->dump(main_time);

        if(main_time > 200000)
            break;

        main_time++;
    }
    tfp->close();
    sim->final();
}
