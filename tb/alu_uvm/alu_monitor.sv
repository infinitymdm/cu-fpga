class alu_monitor extends uvm_monitor;

  `uvm_component_utils(alu_monitor)

  function new(string name="alu_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port #(alu_tx) monitor_analysis_port;
  virtual alu_if ivif;
  virtual alu_if ovif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_in_if", ivif))
      `uvm_fatal(get_full_name(), "Failed to get input interface")
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "alu_out_if", ovif))
      `uvm_fatal(get_full_name(), "Failed to get output interface")
    monitor_analysis_port = new("monitor_analysis_port", this);
    `uvm_info(get_full_name(), "Build phase complete.", UVM_LOW)
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin : monitor_tx
      @(posedge ivif.clk);
      if (ivif.enable) begin: monitor_tx_sel
        alu_tx tx = new;
        tx.op_select = ivif.op_select;
        tx.a = ivif.a;
        tx.b = ivif.b;
        tx.result = ovif.result;
        tx.zero = ovif.zero;
        tx.carry = ovif.carry;
        monitor_analysis_port.write(tx);
      end
    end
  endtask

endclass
