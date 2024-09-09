class alu_gen_seq extends uvm_sequence;

  `uvm_object_utils(alu_gen_seq);

  function new(string name="alu_gen_seq", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  rand int n; // Number of operations in sequence

  virtual task body();
    for (int i = 0; i < n; i++) begin : gen_seq
      alu_tx tx = alu_tx::type_id::create("alu_tx");
      start_item(tx);
      tx.randomize();
      `uvm_info("SEQ", $sformatf("Generate transaction: %s", tx.toString()), UVM_LOW)
      finish_item(tx);
    end
  endtask

endclass
