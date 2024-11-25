module keccak_chi #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    output logic [4:0][4:0][w-1:0] y
);

    generate
        for (genvar i = 0; i < 5; i=i+1) begin: sheet_select
            for(genvar j = 0; j < 5; j=j+1) begin: lane_select
                assign y[i][j] = x[i][j] ^ ((~x[(i+1)%5][j]) & x[(i+2)%5][j]); // Spec uses ^1 instead of ~. Double check
            end
        end
    endgenerate

endmodule
