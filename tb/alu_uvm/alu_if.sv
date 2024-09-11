interface alu_if #(parameter WORD_LEN = 32) (input clk);

  logic                 sel;
  logic [WORD_LEN-1:0]  a, b;
  logic [3:0]           op_select;
  logic [WORD_LEN-1:0]  result;
  logic                 zero, carry;

endinterface
