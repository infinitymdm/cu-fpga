module main (input logic [7:0] io_dip_a,
             input logic btn_reset,
                         cu_clk,
             output logic [3:0] io_7seg_select,
             output logic [7:0] led,
                                io_7seg);

    logic [3:0] minute_ones, minute_tens, hour_ones, hour_tens;
    time_counter timer(cu_clk, io_dip_a[7], ~btn_reset, minute_ones, minute_tens, hour_ones, hour_tens);
    seven_seg_driver display(cu_clk, minute_ones, minute_tens, hour_ones, hour_tens, io_7seg_select, io_7seg);

    assign led[6:0] = 0;
    assign led[7] = ~btn_reset;
endmodule
