module keccak_pi #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    output logic [4:0][4:0][w-1:0] y
);

    generate
        for (genvar i = 0; i < 5; i=i+1) begin: sheet_select
            for(genvar j = 0; j < 5; j=j+1) begin: lane_select
                assign y[i][j] = x[(i+3*j)%5][i];
            end
        end
    endgenerate

endmodule
