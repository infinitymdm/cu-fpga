`include "alu_env.sv"

class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)

  alu_env env;

  function new(string name="alu_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction

endclass
