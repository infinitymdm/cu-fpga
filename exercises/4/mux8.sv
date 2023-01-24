// Exercise 4.8
// Write an 8:1 multiplexer module with inputs s[2:0] d{0-7}, and
// output y.

module mux8(
    input logic s[2:0],
    input logic d0, d1, d2, d3, d4, d5, d6, d7,
    output logic y);
    
    always_comb begin : select
        case (s)
            0: y = d0;
            1: y = d1;
            2: y = d2;
            3: y = d3;
            4: y = d4;
            5: y = d5;
            6: y = d6;
            7: y = d7;
            default: y = 1'bx;
        endcase
    end
endmodule
