module delay_ff (
  input logic clk, d,
  output logic q
);

  always_ff @(posedge clk) q <= d;

endmodule
