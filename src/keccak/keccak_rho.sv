module keccak_rho #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    output logic [4:0][4:0][w-1:0] y
);

    logic [23:0][w-1:0] A, B; // temp wires for flipping bytes
    localparam int rho_offsets [24:0] = { // These work for all SHA3/SHAKE variations
          0,   1, 190,  28,  91,
         36, 300,   6,  55, 276,
          3,  10, 171, 153, 231,
        105,  45,  15,  21, 136,
        210,  66, 253, 120,  78
    };

    generate
        // This generate block contains no combinational content, just index manipulation
        // In synthesis it should be optimized to straight wires
        for (genvar i = 0; i < 5; i++) begin: sheet_select
            for (genvar j = 0; j < 5; j++) begin: lane_select
                if (rho_offsets[5*j+i] == 0) begin: rotate_0
                    assign y[i][j] = x[i][j];
                end else begin: rotate_n
                    for (genvar k = 0; k < w/8; k++) begin: byte_flip_A
                        // TODO: See if we can use stream operators here to simplify the logic a bit (also below)
                        for (genvar p = 0; p < 8; p++) begin: bit_select_A
                            assign A[5*j+i][8*k+7-p] = x[i][j][8*k+p]; // reverse the bit order of each byte
                        end
                    end
                    assign B[5*j+i] = {A[5*j+i][(rho_offsets[5*j+i]%w)-1:0], A[5*j+i][w-1:(rho_offsets[5*j+i]%w)]}; // rol
                    for (genvar m = 0; m < w/8; m++) begin: byte_flip_B
                        for (genvar q = 0; q < 8; q++) begin: bit_select_B
                            assign y[i][j][8*m+7-q] = B[5*j+i][8*m+q]; // restore bit order of each byte
                        end
                    end
                end
            end
        end
    endgenerate

endmodule
