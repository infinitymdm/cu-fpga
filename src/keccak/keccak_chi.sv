module keccak_chi #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    output logic [b-1:0] y
);

    generate
        for (genvar i = 0; i < 5; i++) begin: lane_x_select
            for (genvar j = 0; j < 5; j++) begin: lane_y_select
                assign y[w*(5*i+j)+:64] = x[w*(5*i+j)+:64] ^ ((~x[w*(5*((i+1)%5)+j)+:64]) & x[w*(5*((i+2)%5)+j)+:64]);
            end
        end
    endgenerate

endmodule
