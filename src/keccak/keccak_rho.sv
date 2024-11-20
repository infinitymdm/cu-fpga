module keccak_rho #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    output logic [b-1:0] y
);

    /*localparam int rho_offsets [24:0] = {
          0,   1, 190,  28,  91,
         36, 300,   6,  55, 276,
          3,  10, 171, 153, 231,
        105,  45,  15,  21, 136,
        210,  66, 253, 120,  78
    };*/
    localparam int rho_offsets [24:0] = {
        21, 120, 28, 55, 153,
        136, 78, 91, 276, 231,
        105, 210, 0, 36, 3,
        45, 66, 1, 300, 10,
        15, 253, 190, 6, 171
    };

    // rotate each lane by the correct offset
    generate
        for (genvar i = 0; i < 5; i++) begin: lane_x_select
            for (genvar j = 0; j < 5; j++) begin: lane_y_select
                rotate #(.width(w), .n(rho_offsets[5*i+j] % w)) rotate_lane (
                    .x(x[w*(5*i+j)+:w]), .y(y[w*(5*i+j)+:w])
                );
            end
        end
    endgenerate

endmodule
