`include "alu_tx.sv"

class alu_driver extends uvm_driver #(alu_tx);

  `uvm_component_utils(alu_driver)

  virtual alu_if vif;
  alu_tx tx;

  function new(string name="alu_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Failed to get interface")
    `uvm_info(get_full_name(), "Build phase complete.", UVM_LOW)
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      while (vif.reset == 1'b0) begin
        seq_item_port.get_next_item(tx);
        drive_item(tx);
        seq_item_port.item_done();
      end
    end
  endtask

  virtual task drive_item(alu_tx tx);
    vif.enable <= 1'b0;
    repeat(5) @(posedge vif.clk);

    vif.enable <= 1'b1;
    vif.op_select <= tx.op_select;
    vif.a <= tx.a;
    vif.b <= tx.b;
    @(posedge vif.clk);
  endtask

endclass
