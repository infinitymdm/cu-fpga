module hhmm_clock (
  input logic clk, dec, reset,
  output logic [3:0] min_ones, min_tens, hour_ones, hour_tens
);

  logic slow_clk;
  divide_by_1m clock_divider(clk, slow_clk);

  logic m0_carry, m1_carry, h_carry;
  dec10_counter m0(slow_clk, dec, reset, min_ones, m0_carry);
  dec6_counter m1(m0_carry, dec, reset, min_tens, m1_carry);
  dec24_counter h1(m1_carry, dec, reset, hour_ones, hour_tens, h_carry);

endmodule
