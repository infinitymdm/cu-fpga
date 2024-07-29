module main (
  input  logic io_btn_down, btn_reset, cu_clk,
  output logic [3:0] io_7seg_select,
  output logic [7:0] led, io_7seg
);

  logic day_clk;
  logic [3:0] min_ones, min_tens, hour_ones, hour_tens;

  hhmm_clock timer(.clk(cu_clk), .dec(io_btn_down), .reset(~btn_reset), .min_ones, .min_tens, .hour_ones, .hour_tens, .day_clk);
  seven_seg_driver display(.clk(cu_clk), .a(min_ones), .b(min_tens), .c(hour_ones), .d(hour_tens), .select(io_7seg_select), .segments(io_7seg));

  assign led[0] = day_clk;
  assign led[6:1] = 0;
  assign led[7] = ~btn_reset;

endmodule
