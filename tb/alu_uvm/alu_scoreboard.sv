class alu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(alu_scoreboard);

  alu_tx tx_queue[$]; // Store received transactions in a queue
  uvm_analysis_imp #(alu_tx, alu_scoreboard) item_collected_export;

  function new(string name="alu_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
  endfunction

  virtual function write(alu_tx tx);
    tx_queue.push_back(tx);
  endfunction

  virtual task run_phase(uvm_phase phase);
    alu_tx tx;
    forever begin
      wait(tx_queue.size() > 0);
      tx = tx_queue.pop_front();
      case (tx.op_select)
        0: if (tx.result == (tx.a & tx.b))
            `uvm_info(get_full_name(), $sformatf("PASS! %s", tx.toString()), UVM_LOW)
          else
            `uvm_error(get_full_name(), $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a & tx.b), tx.toString()))
        1: if (tx.result == (tx.a | tx.b))
            `uvm_info(get_full_name(), $sformatf("PASS! %s", tx.toString()), UVM_LOW)
          else
            `uvm_error(get_full_name(), $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a | tx.b), tx.toString()))
        2: if (tx.result == (tx.a ^ tx.b))
            `uvm_info(get_full_name(), $sformatf("PASS! %s", tx.toString()), UVM_LOW)
          else
            `uvm_error(get_full_name(), $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a ^ tx.b), tx.toString()))
        8: if (tx.result == (tx.a + tx.b))
            `uvm_info(get_full_name(), $sformatf("PASS! %s", tx.toString()), UVM_LOW)
          else
            `uvm_error(get_full_name(), $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a + tx.b), tx.toString()))
        9: if (tx.result == (tx.a - tx.b))
            `uvm_info(get_full_name(), $sformatf("PASS! %s", tx.toString()), UVM_LOW)
          else
            `uvm_error(get_full_name(), $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a - tx.b), tx.toString()))
        default: `uvm_error(get_full_name(), $sformatf("ERROR! Unrecognized op %0h", tx.op_select))
      endcase
    end
  endtask

endclass
