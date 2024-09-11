module alu_wrapper #(parameter WORD_LEN = 32) (alu_if _if);

  alu #(WORD_LEN) alu(
    .a(_if.a), .b(_if.b), .op_select(_if.op_select),
    .result(_if.result), .zero(_if.zero), .carry(_if.carry)
  );

endmodule
