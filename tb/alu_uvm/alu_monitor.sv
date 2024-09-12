class alu_monitor extends uvm_monitor;

  `uvm_component_utils(alu_monitor)

  function new(string name="alu_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port #(alu_tx) monitor_analysis_port;
  virtual alu_if vif;
  semaphore vif_acquired;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_if", vif))
      `uvm_fatal("MON", "Failed to get interface")
    vif_acquired = new(1);
    monitor_analysis_port = new("monitor_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin : monitor_tx
      @(posedge vif.clk);
      if (vif.sel) begin: monitor_tx_sel
        alu_tx tx = new;
        tx.op_select = vif.op_select;
        tx.a = vif.a;
        tx.b = vif.b;
        tx.result = vif.result;
        tx.zero = vif.zero;
        tx.carry = vif.carry;
        `uvm_info("MON", $sformatf("Monitor found transaction %s", tx.toString()), UVM_LOW);
        monitor_analysis_port.write(tx);
      end
    end
  endtask

endclass
