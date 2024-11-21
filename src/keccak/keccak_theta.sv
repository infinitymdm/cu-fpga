module keccak_theta #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    output logic [4:0][4:0][w-1:0] y
);

    logic [4:0][w-1:0] C;
    logic [4:0][w-1:0] D;

    generate
        for (genvar i = 0; i < 5; i++) begin: sheet_select
            assign C[i] = x[i][0] ^ x[i][1] ^ x[i][2] ^ x[i][3] ^ x[i][4];
            assign D[i] = C[(i+4)%5] ^ {C[(i+1)%5][w-2:0], C[(i+1)%5][w-1]};
            for (genvar j = 0; j < 5; j++) begin: lane_select
                assign y[i][j] = x[i][j] ^ D[i];
            end
        end
    endgenerate

endmodule
