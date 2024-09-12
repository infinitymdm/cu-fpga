class alu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(alu_scoreboard);

  function new(string name="alu_scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_imp #(alu_tx, alu_scoreboard) tx_analysis_imp;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tx_analysis_imp = new("tx_analysis_imp", this);
  endfunction

  virtual function write(alu_tx tx);
    case (tx.op_select)
      0: if (tx.result == (tx.a & tx.b))
          `uvm_info("SCB", $sformatf("PASS! %s", tx.toString()), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a & tx.b), tx.toString()))
      1: if (tx.result == (tx.a | tx.b))
          `uvm_info("SCB", $sformatf("PASS! %s", tx.toString()), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a | tx.b), tx.toString()))
      2: if (tx.result == (tx.a ^ tx.b))
          `uvm_info("SCB", $sformatf("PASS! %s", tx.toString()), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a ^ tx.b), tx.toString()))
      8: if (tx.result == (tx.a + tx.b))
          `uvm_info("SCB", $sformatf("PASS! %s", tx.toString()), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a + tx.b), tx.toString()))
      9: if (tx.result == (tx.a - tx.b))
          `uvm_info("SCB", $sformatf("PASS! %s", tx.toString()), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a - tx.b), tx.toString()))
      default: `uvm_error("SCB", $sformatf("ERROR! Unrecognized op %0h", tx.op_select))
    endcase
  endfunction

endclass
