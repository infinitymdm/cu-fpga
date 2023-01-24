// Exercise 4.9
// Write a structural module to compute y = a & ~b | ~b & ~c | ~a & b & c
// using the mux8 module from the previous exercise.

module ex49 (input logic a, b, c
             output logic y);
    mux8 result({a, b, c}, 1, 0, 0, 1, 1, 1, 0, 0, y);
endmodule