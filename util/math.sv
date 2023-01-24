module adder #(parameter N = 8)
              (input logic [N-1:0] a, b,
               input logic cin,
               output logic [N-1:0] s,
               output logic cout);
    assign {cout, s} = a + b + cin;
endmodule

module subtractor #(parameter N = 8)
                   (input logic [N-1:0] a, b,
                    output logic [N-1:0] y);
    assign y = a - b;
endmodule

module arithmetic #(parameter N = 8)
                   (input logic [2:0] opcode,
                    input logic [N-1:0] a, b,
                    output logic [N-1:0] y,
                    output logic n, z, c, v);

    // Invert b and multiplex based on control signal
    logic bout;
    mux2 #(N) bmux(opcode[0], b, ~b, bout);

    // Sum a and bout
    logic [N-1:0] sum;
    logic cout;
    adder #(N) s(a, bout, opcode[0], sum, cout);

    // Perform logical ops
    logic [N-1:0] andResult, orResult;
    assign andResult = a & b;
    assign orResult = a | b;

    // Mux to get result based on control signal
    logic [N-1:0] result;
    mux4 #(N) resultmux(opcode[2:1], sum, sum, andResult, orResult, result);

    // Compute flags
    assign z = ~(&result);
    assign n = result[N-1];
    assign c = ~opcode[1] & cout;
    assign v = ~opcode[1] & ~(opcode[0] ^ a[N-1] ^ b[N-1]) & (a[N-1] ^ sum[N-1]);

endmodule