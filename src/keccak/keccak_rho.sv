module keccak_rho #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    output logic [4:0][4:0][w-1:0] y
);

    // These work for all SHA3/SHAKE variations
    localparam int rho_offsets [24:0] = {
          0,   1, 190,  28,  91,
         36, 300,   6,  55, 276,
          3,  10, 171, 153, 231,
        105,  45,  15,  21, 136,
        210,  66, 253, 120,  78
    };

    generate
        for (genvar i = 0; i < 5; i++) begin: sheet_select
            for (genvar j = 0; j < 5; j++) begin: lane_select
                if (rho_offsets[5*j+i] == 0) begin: rotate_0
                    assign y[i][j] = x[i][j];
                end else begin: rotate_n
                    assign y[i][j] = {x[i][j][w-(rho_offsets[5*j+i]%w)-1:0], x[i][j][w-1:w-(rho_offsets[5*j+i]%w)]};
                end
            end
        end
    endgenerate

endmodule
