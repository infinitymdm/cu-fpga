module top(
    input clk, 
    input btn_reset,
    output [7:0] io_led_a,
    output [7:0] io_led_b
);

    localparam COUNTER_WIDTH = 32;
    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk)
    counter <= counter + 1;

    assign io_led_a[0] = ~counter[COUNTER_WIDTH-8];
    assign io_led_a[1] = ~counter[COUNTER_WIDTH-7];
    assign io_led_a[2] = ~counter[COUNTER_WIDTH-6];
    assign io_led_a[3] = ~counter[COUNTER_WIDTH-5];
    assign io_led_a[4] = ~counter[COUNTER_WIDTH-4];
    assign io_led_a[5] = ~counter[COUNTER_WIDTH-3];
    assign io_led_a[6] = ~counter[COUNTER_WIDTH-2];
    assign io_led_a[7] = ~counter[COUNTER_WIDTH-1];

    assign io_led_b[0] = counter[COUNTER_WIDTH-1];
    assign io_led_b[1] = counter[COUNTER_WIDTH-2];
    assign io_led_b[2] = counter[COUNTER_WIDTH-3];
    assign io_led_b[3] = counter[COUNTER_WIDTH-4];
    assign io_led_b[4] = counter[COUNTER_WIDTH-5];
    assign io_led_b[5] = counter[COUNTER_WIDTH-6];
    assign io_led_b[6] = counter[COUNTER_WIDTH-7];
    assign io_led_b[7] = counter[COUNTER_WIDTH-8];
endmodule
