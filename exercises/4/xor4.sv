// Exercise 4.3 & 4.4
// Write an HDL module that computes a four-input XOR function.

module xor4 (input logic [3:0] a, output logic y);
    assign y = a[3] ^ a[2] ^ a[1] ^ a[0];
endmodule

module tb_xor4();
    logic [3:0]  a;
    logic        y, y_expected;
    logic clk;
    logic [31:0] vectornum, errors;
    logic [4:0]  test_vectors[1:1000];

    // instantiate UUT
    xor4 uut(a, y);

    // dump waveforms to file
    initial begin
        $dumpfile("tb_xor4.vcd");
        $dumpvars(0, tb_xor4);
    end

    // generate clk
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // load test vectors
    initial begin
        $readmemb("4.4.txt", test_vectors);
        vectornum = 0; errors = 0;
    end

    // apply test vectors on rising edge of clk
    always @(posedge clk) begin
        #1; {a[3:0], y_expected} = test_vectors[vectornum];
    end

    // check results on falling edge of clk
    always @(negedge clk) begin
        if (y !== y_expected) begin // check result
            $display("Error: input = %b", a[3:0]);
            $display("     outputs = %b (%b expected)", y, y_expected);
            errors = errors + 1;
        end
        vectornum = vectornum + 1;
        if (test_vectors[vectornum] === 5'bx) begin
            $display("%d tests completed with %d errors.", vectornum, errors);
            $stop;
        end
    end

endmodule

// For sim results, see https://i.imgur.com/hX0AgLj.png