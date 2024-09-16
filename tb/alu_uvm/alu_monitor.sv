class alu_monitor #(parameter WORD_LEN = 32) extends uvm_monitor;

  `uvm_component_utils(alu_monitor#(WORD_LEN))
  
  virtual alu_if #(WORD_LEN) vif;
  alu_tx #(WORD_LEN) tx_collected;
  uvm_analysis_port #(alu_tx#(WORD_LEN)) item_collected_port;

  function new(string name="alu_monitor", uvm_component parent=null);
    super.new(name, parent);
    tx_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if#(WORD_LEN))::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Failed to get interface")
    `uvm_info(get_full_name(), "Build phase complete.", UVM_LOW)
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      @(posedge vif.clk);
      if (vif.enable) begin: monitor_tx_sel
        tx_collected.op_select = vif.op_select;
        tx_collected.a = vif.a;
        tx_collected.b = vif.b;
        tx_collected.result = vif.result;
        tx_collected.zero = vif.zero;
        tx_collected.carry = vif.carry;
        item_collected_port.write(tx_collected);
      end
    end
  endtask

endclass
