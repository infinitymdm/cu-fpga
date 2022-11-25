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

    logic [3:0] minute_ones;
    logic [3:0] minute_tens;
    logic [3:0] hour_ones;
    logic [3:0] hour_tens;
    logic m0_carry, m1_carry, h_carry;
    dec10_counter m0(clk, io_dip_a[7], ~btn_reset, minute_ones, m0_carry);
    dec6_counter m1(m0_carry, io_dip_a[7], ~btn_reset, minute_tens, m1_carry);
    dec24_counter h1(m1_carry, io_dip_a[7], ~btn_reset, hour_ones, hour_tens, h_carry);

    seven_seg_driver display(cu_clk, minute_ones, minute_tens, hour_ones, hour_tens, io_7seg_select, io_7seg);
    assign led[0] = m0_carry;
    assign led[1] = m1_carry;
    assign led[2] = h0_carry;
    assign led[3] = h1_carry;
    assign led[7] = btn_reset;
endmodule

module dec10_counter (input logic clk, dec, reset,
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
    end
    delay d1(clk, (state == S9) & (nextstate == S0), carry);
endmodule

module dec6_counter (input logic clk, dec, reset,
                        output logic [3:0] data,
                        output logic carry);
    // decimal_counter is a Moore FSM which counts up once each time
    // clk is asserted. dec can be asserted to decrease by 1 
    // synchronously, or reset can be asserted to set to 0 
    // asynchronously.
    // Also provides a carry output for cascading with other counters.

    typedef enum logic [4:0] {S0, S1, S2, S3, S4, S5} statetype;
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
            S5: nextstate = dec ? S4 : S0;
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
            default: data = 4'd0;
        endcase
    end
    delay d1(clk, (state == S5) & (nextstate == S0), carry);
endmodule

module dec24_counter (input logic clk, dec, reset,
                        output logic [3:0] ones, tens,
                        output logic carry);
    // decimal_counter is a Moore FSM which counts up once each time
    // clk is asserted. dec can be asserted to decrease by 1 
    // synchronously, or reset can be asserted to set to 0 
    // asynchronously.
    // Also provides a carry output for cascading with other counters.

    typedef enum logic [5:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9,
                              S10, S11, S12, S13, S14, S15, S16, S17,
                              S18, S19, S20, S21, S22, S23} statetype;
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
            S9: nextstate = dec ? S8 : S10;
            S10: nextstate = dec ? S9 : S11;
            S11: nextstate = dec ? S10 : S12;
            S12: nextstate = dec ? S11 : S13;
            S13: nextstate = dec ? S12 : S14;
            S14: nextstate = dec ? S13 : S15;
            S15: nextstate = dec ? S14 : S16;
            S16: nextstate = dec ? S15 : S17;
            S17: nextstate = dec ? S16 : S18;
            S18: nextstate = dec ? S17 : S19;
            S19: nextstate = dec ? S18 : S20;
            S20: nextstate = dec ? S19 : S21;
            S21: nextstate = dec ? S20 : S22;
            S22: nextstate = dec ? S21 : S23;
            S23: nextstate = dec ? S22 : S0;
            default: nextstate = S0;
        endcase
    end

    // output logic
    always_comb begin
        case (state)
            S0: begin
                ones = 0;
                tens = 0;
            end
            S1: begin
                ones = 1;
                tens = 0;
            end
            S2: begin
                ones = 2;
                tens = 0;
            end
            S3: begin
                ones = 3;
                tens = 0;
            end
            S4: begin 
                ones = 4;
                tens = 0;
            end
            S5: begin
                ones = 5;
                tens = 0;
            end
            S6: begin
                ones = 6;
                tens = 0;
            end
            S7: begin
                ones = 7;
                tens = 0;
            end
            S8: begin
                ones = 8;
                tens = 0;
            end
            S9: begin
                ones = 9;
                tens = 0;
            end

            S10: begin
                ones = 0;
                tens = 1;
            end
            S11: begin
                ones = 1;
                tens = 1;
            end
            S12: begin
                ones = 2;
                tens = 1;
            end
            S13: begin
                ones = 3;
                tens = 1;
            end
            S14: begin 
                ones = 4;
                tens = 1;
            end
            S15: begin
                ones = 5;
                tens = 1;
            end
            S16: begin
                ones = 6;
                tens = 1;
            end
            S17: begin
                ones = 7;
                tens = 1;
            end
            S18: begin
                ones = 8;
                tens = 1;
            end
            S19: begin
                ones = 9;
                tens = 1;
            end

            S20: begin
                ones = 0;
                tens = 2;
            end
            S21: begin
                ones = 1;
                tens = 2;
            end
            S22: begin
                ones = 2;
                tens = 2;
            end
            S23: begin
                ones = 3;
                tens = 2;
            end
            default: begin
                ones = 4'd0;
                tens = 4'd0;
            end
        endcase
    end
    delay d1(clk, (state == S23) & (nextstate == S0), carry);
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

module delay (input logic clk, d,
              output logic q);
    always_ff @(posedge clk)
        q <= d;
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

    // Subdivide clock. Select should be slower than refresh.
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
    seven_seg_decoder segments_driver(data, 1'b0, segments);
endmodule

