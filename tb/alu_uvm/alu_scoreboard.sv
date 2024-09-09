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
    case (tx.op_select) begin : op_decode
      0: if (tx.result == (tx.a & tx.b))
          `uvm_info("SCB", "PASS! %s", tx.toString(), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a & tx.b), tx.to_String()))
      1: if (tx.result == (tx.a | tx.b))
          `uvm_info("SCB", "PASS! %s", tx.toString(), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a | tx.b), tx.to_String()))
      2: if (tx.result == (tx.a ^ tx.b))
          `uvm_info("SCB", "PASS! %s", tx.toString(), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a ^ tx.b), tx.to_String()))
      8: if (tx.result == (tx.a + tx.b))
          `uvm_info("SCB", "PASS! %s", tx.toString(), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a + tx.b), tx.to_String()))
      9: if (tx.result == (tx.a - tx.b))
          `uvm_info("SCB", "PASS! %s", tx.toString(), UVM_LOW)
        else
          `uvm_error("SCB", $sformatf("ERROR! Expected result=0x%0h, got: %s", (tx.a - tx.b), tx.to_String()))
      default: `uvm_error("SCB", $sformatf("ERROR! Unrecognized op %0h", tx.op_select))
    endcase
  endfunction

endclass
