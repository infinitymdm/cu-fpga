class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)

  function new(string name="alu_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  alu_env env;
  virtual alu_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif))
      `uvm_fatal("TEST", "Failed to get interface")
    uvm_config_db#(virtual alu_env)::set(this, "env.agt.*", "alu_if", vif);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_gen_seq gen = alu_gen_seq::type_id::create("gen");
    phase.raise_objection(this);
    apply_reset();
    gen.randomize() with {n == 100;};
    gen.start(env.agt.seq);
    #100;
    phase.drop_objection(this);
  endtask

  virtual task apply_reset();
    vif.op_select = 0;
    vif.a = 0;
    vif.b = 0;
    #10;
  endtask

endclass
