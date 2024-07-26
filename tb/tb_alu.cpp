#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <Valu.h>
#include <Valu___024root.h>

#define MAX_SIM_CYCLES 20
vluint64_t sim_cycles = 0;

int main (int argc, char** argv, char** env) {
    Valu *dut = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    dut->op_select = 8;
    while (sim_cycles < MAX_SIM_CYCLES) {
        dut->a++;
        dut->eval();
        m_trace->dump(sim_cycles);
        sim_cycles++;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}
