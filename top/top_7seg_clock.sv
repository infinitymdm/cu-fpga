// top_alu.sv
// Implements a proof-of-concept 24-hour clock. Counts at (very roughly) 1 minute per second.
// Features:
//  - Displays the hour and minute on the Alchitry Io board's 7-segment displays
//  - The counter can be decremented by holding down the "south" button on the Io D-pad
//  - The counter can be reset by pressing the Cu's reset button

module top_7seg_clock (
  input  logic io_btn_s, cu_btn_reset, cu_clk,
  output logic [3:0] io_7seg_s,
  output logic [7:0] cu_led, io_7seg
);

  logic day_clk;
  logic [3:0] min_ones, min_tens, hour_ones, hour_tens;

  hhmm_clock timer(.clk(cu_clk), .dec(io_btn_s), .reset(~cu_btn_reset), .min_ones, .min_tens, .hour_ones, .hour_tens, .day_clk);
  seven_seg_driver display(.clk(cu_clk), .a(min_ones), .b(min_tens), .c(hour_ones), .d(hour_tens), .select(io_7seg_s), .segments(io_7seg));

  assign cu_led[0] = day_clk;
  assign cu_led[6:1] = 0;
  assign cu_led[7] = ~cu_btn_reset;

endmodule
