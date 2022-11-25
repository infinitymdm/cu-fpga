module main (input logic [7:0] io_dip_a,
             input logic io_btn_up,
                         io_btn_down,
                         io_btn_ctr,
                         io_btn_left,
                         io_btn_right,
                         btn_reset,
                         cu_clk,
             output logic [3:0] io_7seg_select,
             output logic [7:0] led,
                                io_7seg);
    logic clk;
    divide_by_1m clock_divider(cu_clk, clk);

    logic [3:0] data;
    logic carry;
    decimal_counter seconds(clk, io_dip_a[7], ~btn_reset, data, carry);

    seven_seg_driver display(cu_clk, data, 4'b0010, 4'b0011, 4'b0100, io_7seg_select, io_7seg);
    assign led[0] = carry;
endmodule

module decimal_counter (input logic clk, dec, reset,
                        output logic [3:0] data,
                        output logic carry);
    // decimal_counter is a Moore FSM which counts up once each time
    // clk is asserted. dec can be asserted to decrease by 1 
    // synchronously, or reset can be asserted to set to 0 
    // asynchronously.
    // Also provides a carry output for cascading with other counters.

    typedef enum logic [4:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9} statetype;
    statetype state, nextstate;

    // state register
    always_ff @(posedge clk, posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= nextstate;
    end

    // next state logic
    always_comb begin
        case (state)
            S0: nextstate = dec ? S9 : S1;
            S1: nextstate = dec ? S0 : S2;
            S2: nextstate = dec ? S1 : S3;
            S3: nextstate = dec ? S2 : S4;
            S4: nextstate = dec ? S3 : S5;
            S5: nextstate = dec ? S4 : S6;
            S6: nextstate = dec ? S5 : S7;
            S7: nextstate = dec ? S6 : S8;
            S8: nextstate = dec ? S7 : S9;
            S9: nextstate = dec ? S8 : S0;
            default: nextstate = S0;
        endcase
    end

    // output logic
    always_comb begin
        case (state)
            S0: data = 4'd0;
            S1: data = 4'd1;
            S2: data = 4'd2;
            S3: data = 4'd3;
            S4: data = 4'd4;
            S5: data = 4'd5;
            S6: data = 4'd6;
            S7: data = 4'd7;
            S8: data = 4'd8;
            S9: data = 4'd9;
            default: data = 4'd0;
        endcase
        carry = (state == S9) & (nextstate == S0);
    end
endmodule

module divide_by_1m (input logic clk,
                     output logic out_clk);
    localparam N = 27;
    logic [N-1:0] counter;

    always @(posedge clk)
        counter <= counter + 1;

    assign out_clk = counter[N-1];
endmodule

module divide_by_4 (input logic clk,
                     output logic out_clk);
    localparam N = 4;
    logic [N-1:0] counter;

    always @(posedge clk)
        counter <= counter + 1;

    assign out_clk = counter[N-1];
endmodule


module sync (input logic clk,
             input logic d,
             input logic q);
    logic n;

    always_ff @(posedge clk) begin
        n <= d;
        q <= n;
    end
endmodule

module seven_seg_select_decoder (input logic [1:0] s,
                                 output logic [3:0] y);
    always_comb begin
        case (s)
            0: y = 4'b1110;
            1: y = 4'b1101;
            2: y = 4'b1011;
            3: y = 4'b0111;
        endcase
    end
endmodule

module seven_seg_decoder (input logic [3:0] data,
                          input logic dp,
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
            default: segments = ~{dp, 7'b00};
        endcase
    end
endmodule

module seven_seg_driver (input logic clk,
                         input logic [3:0] a, b, c, d,
                         output logic [3:0] select,
                         output logic [7:0] segments);
    // seven_seg_driver asynchronously drives a bank of four seven-
    // segment displays with a duty cycle of 1/16. 

    typedef enum logic [1:0] {S0, S1, S2, S3} statetype;
    statetype state, nextstate;

    // Subdivide clock. Select should be slower than flip.
    logic select_clk, refresh_clk;
    divide_by_4 refresh_divider(clk, refresh_clk);
    divide_by_4 select_divider(refresh_clk, select_clk);

    // state register
    always_ff @(posedge select_clk)
        state <= nextstate;

    // next state logic - cycle in a fixed ring
    always_comb begin
        case (state)
            S0: nextstate = S1;
            S1: nextstate = S2;
            S2: nextstate = S3;
            S3: nextstate = S0;
            default: nextstate = S0;
        endcase
    end

    // select output logic
    logic [1:0] s;
    always_comb begin
        case (state)
            S0: s = 0;
            S1: s = 1;
            S2: s = 2;
            S3: s = 3;
            default: s = 2'b00;
        endcase
    end
    seven_seg_select_decoder select_driver(s, select);

    // segments output logic
    logic [3:0] data;
    always_comb begin
        case (state)
            S0: data = select_clk ? a : 4'b1111;
            S1: data = select_clk ? b : 4'b1111;
            S2: data = select_clk ? c : 4'b1111;
            S3: data = select_clk ? d : 4'b1111;
            default: data = 4'b1111;
        endcase
    end
    seven_seg_decoder segments_driver(data, 0, segments);

endmodule

