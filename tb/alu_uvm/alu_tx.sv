class alu_tx #(int WORD_LEN = 32) extends uvm_sequence_item;

  rand bit [WORD_LEN-1:0] a, b;
  rand bit [3:0]          op_select;
       bit [WORD_LEN-1:0] result;
       bit                zero, carry;

  `uvm_object_utils_begin(alu_tx)
    `uvm_field_int (a, UVM_DEFAULT)
    `uvm_field_int (b, UVM_DEFAULT)
    `uvm_field_int (op_select, UVM_DEFAULT)
    `uvm_field_int (result, UVM_DEFAULT)
    `uvm_field_int (zero, UVM_DEFAULT)
    `uvm_field_int (carry, UVM_DEFAULT)
  `uvm_object_utils_end

  virtual function string toString();
    return $sformatf("a = 0x%0h, b = 0x%0h, op_select = 0x%0h, result = 0x%0h, z = %b, c = %b", a, b, op_select, result, zero, carry);
  endfunction

  function new(string name="alu_in_tx");
    super.new(name);
  endfunction

  constraint op_c {
    op_select inside {0, 1, 2, 8, 9};
  }

endclass
