`include "alu_driver.sv"
`include "alu_monitor.sv"

class alu_agent extends uvm_agent;

  `uvm_component_utils(alu_agent)

  function new(string name="alu_agent", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  alu_driver              drv;
  alu_monitor             mon;
  uvm_sequencer #(alu_tx,alu_tx) seq; // We have to pass twice because of a silly bug in verilator

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq = uvm_sequencer#(alu_tx,alu_tx)::type_id::create("seq", this);
    drv = alu_driver::type_id::create("drv", this);
    mon = alu_monitor::type_id::create("mon", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seq.seq_item_export);
  endfunction

endclass
