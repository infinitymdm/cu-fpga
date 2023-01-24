// 7-segment decoder for Ex. 4.6
// Decodes 0-F for an active-low display with decimal point

module seven_seg_decoder (input logic [3:0] data,
                          input logic dp,
                          output logic [7:0] segments);
    always_comb begin
        // Assign segments
        case (data)
            //                       abc_defg
            'h0: segments = ~{dp, 7'b111_1110};
            'h1: segments = ~{dp, 7'b011_0000};
            'h2: segments = ~{dp, 7'b110_1101};
            'h3: segments = ~{dp, 7'b111_1001};
            'h4: segments = ~{dp, 7'b011_0011};
            'h5: segments = ~{dp, 7'b101_1011};
            'h6: segments = ~{dp, 7'b101_1111};
            'h7: segments = ~{dp, 7'b111_0000};
            'h8: segments = ~{dp, 7'b111_1111};
            'h9: segments = ~{dp, 7'b111_1011};
            'hA: segments = ~{dp, 7'b111_0111};
            'hB: segments = ~{dp, 7'b001_1111};
            'hC: segments = ~{dp, 7'b000_1101};
            'hD: segments = ~{dp, 7'b011_1101};
            'hE: segments = ~{dp, 7'b100_1111};
            'hF: segments = ~{dp, 7'b100_0111};
            default: segments = 8'bx;
        endcase
    end
endmodule

module tb_7seg ();
    logic [3:0] data;
    logic dp;
    logic [7:0] segments, expected;
    logic clk;
    logic [31:0] vectornum, errors;
    logic [12:0]  test_vectors[1:1000];

    // initialize uut
    seven_seg_decoder uut(data, dp, segments);

    // dump waveforms to file
    initial begin
        $dumpfile("tb_7seg.vcd");
        $dumpvars(0, tb_7seg);
    end

    // generate clk
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // load test vectors
    initial begin
        $readmemb("4.7.txt", test_vectors);
        vectornum = 0; errors = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {data, dp, expected} = test_vectors[vectornum];
    end

    // check results on falling edge of clock
    always @(negedge clk) begin
        if (segments !== ~expected) begin
            $display("Error: inputs = %b.%b", data, dp);
            $display("      outputs = %b (expected %b)", segments, ~expected);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === 13'bx) begin
            $display("Test completed with %d errors.", errors);
            $stop;
        end
    end
endmodule

// Errors on the final test vector - this is expected per Ex 4.7
// For simulation results, see: https://i.imgur.com/FvFVgoA.png