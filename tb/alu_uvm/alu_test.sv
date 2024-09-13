`include "alu_env.sv"
`include "alu_gen_seq.sv"

class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)

  function new(string name="alu_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  alu_env env;
  virtual alu_if ivif;
  virtual alu_if ovif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
    `uvm_info(get_full_name(), "Build phase", UVM_LOW)
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_in_if", ivif))
      `uvm_fatal(get_full_name(), "Failed to get input interface")
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_out_if", ovif))
      `uvm_fatal(get_full_name(), "Failed to get output interface")
    uvm_config_db#(virtual alu_if)::set(this, "env.agent.*", "alu_in_if", ivif);
    uvm_config_db#(virtual alu_if)::set(this, "env.agent.monitor", "alu_out_if", ovif);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_gen_seq gen = alu_gen_seq::type_id::create("gen");
    `uvm_info("TEST", "Run phase", UVM_LOW)
    phase.raise_objection(this);
    gen.randomize();
    gen.start(env.agent.sequencer);
    #100;
    phase.drop_objection(this);
  endtask

endclass
