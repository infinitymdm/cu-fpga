`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_sequencer.sv"

class alu_agent #(parameter WORD_LEN = 32) extends uvm_agent;

  `uvm_component_utils(alu_agent#(WORD_LEN))

  alu_driver #(WORD_LEN)    driver;
  alu_sequencer #(WORD_LEN) sequencer;
  alu_monitor #(WORD_LEN)   monitor;

  function new(string name="alu_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = alu_monitor#(WORD_LEN)::type_id::create("monitor", this);
    driver = alu_driver#(WORD_LEN)::type_id::create("driver", this);
    sequencer = alu_sequencer#(WORD_LEN)::type_id::create("sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
