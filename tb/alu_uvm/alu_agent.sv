`include "alu_driver.sv"
`include "alu_monitor.sv"

class alu_agent extends uvm_agent;

  `uvm_component_utils(alu_agent)

  function new(string name="alu_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  alu_driver                      driver;
  alu_monitor                     monitor;
  uvm_sequencer #(alu_tx,alu_tx)  sequencer; // We have to pass alu_tx twice because of a silly bug in verilator

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = uvm_sequencer#(alu_tx,alu_tx)::type_id::create("sequencer", this);
    driver = alu_driver::type_id::create("driver", this);
    monitor = alu_monitor::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
