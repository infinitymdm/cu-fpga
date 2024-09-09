class alu_driver extends uvm_driver #(alu_tx);

  `uvm_component_utils(alu_driver)

  function new(string name="alu_driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual alu_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif))
      `uvm_fatal("DRV", "Failed to get interface")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin : run_tx
      alu_tx tx;
      `uvm_info("DRV", "Wait for item from sequencer", UVM_LOW)
      seq_item_port.get_next_item(tx);
      drive_item(tx);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(alu_tx tx);
    vif.sel <= 1;
    vif.op_select <= tx.op_select;
    vif.a <= tx.a;
    vif.b <= tx.b;
    @(posedge vif.clk);
    while (!vif.ready) begin : wait_rdy
      `uvm_info("DRV", "Wait until interface is ready", UVM_LOW)
      @(posedge vif.clk);
    end
    vif.sel <= 0;
  endtask

endclass
