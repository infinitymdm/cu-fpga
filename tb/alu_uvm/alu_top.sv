`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "alu_if.sv"
`include "alu_test.sv"

module alu_top;

  bit clk;
  bit reset;

  alu_if #(32) ivif (.clk, .reset);
  alu_if #(32) ovif (.clk, .reset);
  alu #(32) dut(
    .a(ivif.a), .b(ivif.b), .op_select(ivif.op_select),
    .result(ovif.result), .zero(ovif.zero), .carry(ovif.carry)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*.agent.*", "alu_in_if", ivif);
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*.agent.*", "alu_out_if", ovif);
    run_test("alu_test");
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule
