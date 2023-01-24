// Exercise 4.12
// Write an HDL module for an 8-input priority circuit.

module priority8 (input logic [7:0] s,
                  output logic [7:0] y);
    always_comb begin
        case (s)
            8'b1???????: y = 8'b10000000;
            8'b01??????: y = 8'b01000000;
            8'b001?????: y = 8'b00100000;
            8'b0001????: y = 8'b00010000;
            8'b00001???: y = 8'b00001000;
            8'b000001??: y = 8'b00000100;
            8'b0000001?: y = 8'b00000010;
            8'b00000001; y = 8'b00000001;
            default: y = 8'b0;
        endcase
    end
endmodule