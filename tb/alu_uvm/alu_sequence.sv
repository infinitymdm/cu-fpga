class alu_sequence #(WORD_LEN = 32) extends uvm_sequence;

  `uvm_object_utils(alu_sequence);
  `uvm_declare_p_sequencer(alu_sequencer)

  function new(string name="alu_sequence");
    super.new(name);
  endfunction

  virtual task body();
    for (int i = 0; i < n; i++) begin : gen_seq
      alu_tx tx = alu_tx#(WORD_LEN)::type_id::create("alu_tx");
      wait_for_grant();
      tx.randomize();
      send_request(tx);
      wait_for_item_done();
    end
  endtask

  constraint num_ops_c {
    n == 10;
  }

endclass
