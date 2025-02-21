// top_alu.sv
// Implements an 8-bit ALU with opcode, operands, and result displayed on LEDs.
// Features:
//  - Opcode displaed on Cu LEDs 3 through 0
//  - Carry and zero flags displayed on Cu LEDs 5 and 4 respectively
//  - Opcode and operands can be set using DIP switches
//  - Operands a and b displayed on leftmost 7-segment displays as hex values
//  - Result displayed on rightmost 7-segment displays as hex values

module top_alu (
  input  logic       cu_clk,
  output logic [7:0] cu_led,
  input  logic       cu_btn_reset,
  output logic [7:0] io_led_a, io_led_b, io_led_c,
  input  logic [7:0] io_dip_a, io_dip_b,
  input  logic [3:0] io_dip_c,
  output logic [3:0] io_7seg_s,
  output logic [7:0] io_7seg
);

  logic [3:0] opcode;
  logic [7:0] result;
  logic       zero, carry;

  assign opcode = io_dip_c[3:0];
  alu #(8) alu (.a(io_dip_a), .b(io_dip_b), .op_select(opcode), .result, .zero, .carry);

  // Display opcode, inputs and results on 7seg
  seven_seg_driver display(.clk(cu_clk), .d(io_dip_a[3:0]), .c(io_dip_b[3:0]), .b(result[7:4]),
    .a(result[3:0]), .select(io_7seg_s), .segments(io_7seg));

  always_comb begin
    io_led_a = io_dip_a;
    io_led_b = io_dip_b;
    io_led_c = result;
    cu_led[3:0] = opcode;
    cu_led[4] = zero;
    cu_led[5] = carry;
    cu_led[6] = 0;
    cu_led[7] = ~cu_btn_reset;
  end

endmodule
