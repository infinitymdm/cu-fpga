module main (input logic [7:0] io_dip_a,
                               io_dip_b,
            output logic [3:0] io_7seg_select,
            output logic [7:0] led,
                               io_led_b,
                               io_7seg);

    assign io_led_b = io_dip_b;
    seven_seg display(io_dip_a[1:0], io_dip_b[3:0], io_dip_b[4],
                      io_7seg_select, io_7seg);
    assign led = io_7seg;
endmodule


module flop (input logic clk,
             input logic [3:0] d,
             output logic [3:0] q);
    always_ff @(posedge clk)
        q <= d;
endmodule


module sync (input logic clk,
             input logic d,
             input logic q);
    logic n;

    always_ff @(posedge clk)
        begin
            n <= d;
            q <= n;
        end
endmodule


module seven_seg (input logic [1:0] select,
                  input logic [3:0] data,
                  input logic dp,
                  output logic [3:0] selection,
                  output logic [7:0] segments);
    always_comb begin
        // Assign segments
        case (data)
            //                     abc_defg
            0: segments = ~{dp, 7'b111_1110};
            1: segments = ~{dp, 7'b011_0000};
            2: segments = ~{dp, 7'b110_1101};
            3: segments = ~{dp, 7'b111_1001};
            4: segments = ~{dp, 7'b011_0011};
            5: segments = ~{dp, 7'b101_1011};
            6: segments = ~{dp, 7'b101_1111};
            7: segments = ~{dp, 7'b111_0000};
            8: segments = ~{dp, 7'b111_1111};
            9: segments = ~{dp, 7'b111_1011};
            default: segments = ~{dp, 7'b01};
        endcase

        // Assign selector
        selection[3] = ~(select[1] & select[0]);
        selection[2] = ~(select[1] & ~select[0]);
        selection[1] = ~(~select[1] & select[0]);
        selection[0] = ~(~select[1] & ~select[0]);
    end
endmodule