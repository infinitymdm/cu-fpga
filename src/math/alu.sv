module alu #(
  parameter WORD_LEN = 32
) (
  input logic [WORD_LEN-1:0] a, b,
  input logic [3:0] op_select,
  output logic [WORD_LEN-1:0] result,
  output logic zero
);

  // ALU supporting add, sub, and, or, xor, signed and unsigned comparison, shift, and arithmetic
  // shift operations.

  logic carry, overflow;
  logic [WORD_LEN-1:0] sum;

  always_comb begin
    {carry, sum} = a + {1'b0, (op_select[0]? b : ~b)}; // TODO: Use a fast adder

    case (op_select)
      0: result = a & b;
      1: result = a | b;
      2: result = a ^ b;
      8: result = sum; // add
      9: result = sum; // sub
      default: result = sum;
    endcase

    //overflow = 
    zero = ~(|result);
  end

endmodule
