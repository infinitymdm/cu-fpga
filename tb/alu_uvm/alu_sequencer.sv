class alu_sequencer #(WORD_LEN) extends uvm_sequencer#(alu_tx#(WORD_LEN), alu_tx#(WORD_LEN));

  `uvm_component_utils(alu_sequencer#(WORD_LEN))

  function new(string name="alu_sequencer", uvm_component parent=null);
    super.new(name, parent);
  endfunction

endclass
