module keccak_iota #(
    parameter w = 64
) (
    input  logic [4:0][4:0][w-1:0] x,
    input  logic           [w-1:0] rc,
    output logic [4:0][4:0][w-1:0] y
);

    generate
        for (genvar i = 0; i < 5; i++) begin: sheet_select
            for (genvar j = 0; j < 5; j++) begin: lane_select
                if ((i == 0) & (j == 0)) begin: apply_rc
                    assign y[i][j] = x[i][j] ^ rc;
                end else begin: passthrough
                    assign y[i][j] = x[i][j];
                end
            end
        end
    endgenerate

endmodule
