`include "alu_env.sv"

class alu_test extends uvm_test;

  localparam WORD_LEN = 8;

  `uvm_component_utils(alu_test)

  alu_env #(WORD_LEN) env;

  function new(string name="alu_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env#(WORD_LEN)::type_id::create("env", this);
  endfunction

endclass
