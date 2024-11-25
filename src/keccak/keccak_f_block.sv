module keccak_f_block #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    input  logic [w-1:0] rc,
    output logic [b-1:0] y
);

    logic [4:0][4:0][w-1:0] x_block, x_theta, x_rho, x_pi, x_chi, y_block;

    // Reorganize i/o into 3-dimensional blocks for easy indexing in keccak subfunctions
    generate
        for (genvar i = 0; i < 5; i++) begin: sheet_select
            for (genvar j = 0; j < 5; j++) begin: lane_select
                for (genvar k = 0; k < w; k++) begin: bit_select
                    assign x_block[i][j][k] = x[w*(5*j + i) + k];
                    assign y[w*(5*j + i) + k] = y_block[i][j][k];
                end
            end
        end
    endgenerate

    // Perform a single round of the sponge function
    keccak_theta #(.w) theta (.x(x_block), .y(x_theta));
    keccak_rho   #(.w) rho   (.x(x_theta), .y(x_rho));
    keccak_pi    #(.w) pi    (.x(x_rho),   .y(x_pi));
    keccak_chi   #(.w) chi   (.x(x_pi),    .y(x_chi));
    keccak_iota  #(.w) iota  (.x(x_chi),   .y(y_block), .rc);

endmodule
