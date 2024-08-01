#include <stdlib.h>
#include <climits>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <Valu.h>
#include <Valu___024root.h>

// Wrapper functions for simulated versions of alu ops
int sim_and (int x, int y) {return x & y;}
int sim_or  (int x, int y) {return x | y;}
int sim_xor (int x, int y) {return x ^ y;}
int sim_add (int x, int y) {return x + y;}
int sim_sub (int x, int y) {return x - y;}


bool test_op (Valu *dut, vluint64_t &t_sim, VerilatedVcdC *m_trace, int op, int (*op_sim)(int, int)) {
    int expected;

    // Iterate over many values for x and y
    dut->op_select = op;
    for (int x = 0; x < 1000; x++) {
        dut->a = x;
        for (int y = 0; y < 1000; y++) {
            dut->b = y;
            dut->eval();

            // Determine the expected result from the operator simulation function
            expected = op_sim(x, y);

            // Print an error and exit early if the result doesn't match what we expect
            if (expected != dut->result) {
                std::cout << "ERROR: result did not match expected"
                    << "\nexpected: " << expected
                    << "\nresult:   " << (int)(dut->result)
                    << "\nt_sim:    " << t_sim << std::endl;
                return false;
            }

            // Dump results to waveform and step sim time
            m_trace->dump(t_sim);
            t_sim++;
        }
    }
    return true;
}


int main (int argc, char** argv, char** env) {

    Verilated::commandArgs(argc, argv);
    Valu *dut = new Valu;
    vluint64_t t_sim = 0;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("tb_alu.vcd");

    test_op(dut, t_sim, m_trace, 0, &sim_and);
    test_op(dut, t_sim, m_trace, 1, &sim_or);
    test_op(dut, t_sim, m_trace, 2, &sim_xor);
    test_op(dut, t_sim, m_trace, 8, &sim_add);
    test_op(dut, t_sim, m_trace, 9, &sim_sub);

    m_trace->close();
    delete dut;

    exit(EXIT_SUCCESS);
}
