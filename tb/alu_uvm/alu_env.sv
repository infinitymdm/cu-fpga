`include "alu_agent.sv"
`include "alu_scoreboard.sv"

class alu_env #(parameter WORD_LEN = 32) extends uvm_env;

  `uvm_component_utils(alu_env#(WORD_LEN))
  
  alu_agent #(WORD_LEN)       agent;
  alu_scoreboard #(WORD_LEN)  scoreboard;

  function new(string name="alu_env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = alu_agent#(WORD_LEN)::type_id::create("agent", this);
    scoreboard = alu_scoreboard#(WORD_LEN)::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  endfunction

endclass
