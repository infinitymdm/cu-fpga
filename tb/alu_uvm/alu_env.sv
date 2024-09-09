class alu_env extends uvm_env;

  `uvm_component_utils(alu_env)

  function new(string name="alu_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  alu_agent       agt;
  alu_scoreboard  scb;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = alu_agent::type_id::create("agt", this);
    scb = alu_scoreboard::type_id::create("scb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.monitor_analysis_port.connect(scb.tx_analysis_imp);
  endfunction

endclass
