module alu_top;

  import uvm_pkg::*;

  bit clk;
  always #10 clk <= ~clk;

  alu_if #(32) dut_if (); // FIXME
  alu_wrapper #(32) dut_wrapper (._if(dut_if));

  initial begin
    uvm_config_db#(virtual alu_if)::set(null, "", "alu_if", dut_if);
    run_test("alu_test");
  end

  initial begin
    $dumpvars;
    $dumpfile("dump.vcd");
  end

endmodule
