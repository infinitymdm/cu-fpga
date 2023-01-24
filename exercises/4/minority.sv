// Exercise 4.5
// Write an HDL module called minority with three inputs. The output
// should be true if at least two of the inputs are false.

module minority (input logic a, b, c, output logic y);
    assign y = a&b | b&c | a&c;
endmodule