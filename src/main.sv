module main
    (
        input  logic       btn_reset, cu_clk,
        input  logic [7:0] io_dip_a, io_dip_b, io_dip_c,
        output logic [3:0] io_7seg_select,
        output logic [7:0] io_7seg, io_led_a, io_led_b, io_led_c
    );

    // Pass dips directly to LEDs
    always_comb begin
        io_led_a = io_dip_a;
        io_led_b = io_dip_b;
        io_led_c = io_dip_c;
    end

    // Use 2 dip banks for addresses
    // Use 1 dip bank for write
    logic [31:0] wd = 32'b0;
    always_comb begin
        wd[7:0] = io_dip_c;
    end

    logic [31:0] rd1, rd2;
    register_file rf (btn_reset, io_dip_b[7], io_dip_a[4:0], io_dip_b[4:0], io_dip_b[4:0], wd, rd1, rd2);

    // Select b/t a) rd1 and rd2 b) upper half and lower half
    logic [15:0] y;
    mux4 mux_7seg (io_dip_a[7:6], rd2[31:16], rd2[15:0], rd1[31:16], rd1[15:0], y);
    seven_seg_driver display (cu_clk, y[3:0], y[7:4], y[11:8], y[15:12], io_7seg_select, io_7seg);
endmodule
