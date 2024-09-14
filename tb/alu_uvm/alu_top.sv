`include "uvm_pkg.sv"

import uvm_pkg::*;

`include "alu_if.sv"
`include "alu_test.sv"

module alu_top;

  bit clk;
  bit reset;

  alu_if #(32) vif (.clk, .reset);
  alu #(32) dut(
    .op_select(vif.op_select),
    .a(vif.a), 
    .b(vif.b),
    .result(vif.result),
    .zero(vif.zero),
    .carry(vif.carry)
  );

  initial begin
    uvm_config_db#(virtual alu_if)::set(uvm_root::get(), "*", "vif", vif);
    run_test("alu_test");
  end

endmodule
