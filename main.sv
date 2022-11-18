module top (input logic [7:0] io_dip_a,
            input logic [7:0] io_dip_b,
            output logic [7:0] io_led_a,
            output logic [7:0] io_led_b,
            output logic [3:0] io_7seg_select,
            output logic [7:0] io_7seg);

    assign io_led_a = io_dip_a;
    assign io_led_b = io_dip_b;
    assign io_7seg_select = ~io_dip_a[3:0];
    assign io_7seg = ~io_dip_b;
endmodule