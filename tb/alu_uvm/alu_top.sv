`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "alu_if.sv"
`include "alu_test.sv"

module alu_top;

  bit clk;
  always #10 clk <= ~clk;

  alu_if #(32) dut_if ();
  alu #(32) dut(
    .a(dut_if.a), .b(dut_if.b), .op_select(dut_if.op_select),
    .result(dut_if.result), .zero(dut_if.zero), .carry(dut_if.carry)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "", "alu_if", dut_if);
    run_test("alu_test");
  end

  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end

endmodule
