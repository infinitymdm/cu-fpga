module keccak_rho #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    output logic [b-1:0] y
);

    localparam int rho_offsets [24:0] = {
          0,   1, 190,  28,  91,
         36, 300,   6,  55, 276,
          3,  10, 171, 153, 231,
        105,  45,  15,  21, 136,
        210,  66, 253, 120,  78
    };

    // rotate each lane by the correct offset
    generate
        for (genvar i = 0; i < 5; i++) begin: lane_x_select
            for (genvar j = 0; j < 5; j++) begin: lane_y_select
                rotate #(.width(w), .n(rho_offsets[5*i+j] % w)) rotate_lane (
                    .x(x[w*(5*i+j)+:64]), .y(y[w*(5*i+j)+:64])
                );
            end
        end
    endgenerate

endmodule
