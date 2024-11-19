module keccak_theta #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    output logic [b-1:0] y
);
    function automatic logic [w-1:0] C (logic [b-1:0] data, i);
        // columnwise xor
        return  data[w*(5*i+0)+63:w*(5*i+0)] ^
                data[w*(5*i+1)+63:w*(5*i+1)] ^
                data[w*(5*i+2)+63:w*(5*i+2)] ^
                data[w*(5*i+3)+63:w*(5*i+3)] ^
                data[w*(5*i+4)+63:w*(5*i+4)];
    endfunction

    function automatic logic [w-1:0] D (logic [b-1:0] data, i);
        // xor column (x-1,:,z) with (x+1,:,z-1)
        logic [w-1:0] t = C(data, (i+1) % 5);
        return C(data, (i+4) % 5) ^ {t[5*w-2:0], t[5*w-1]};
    endfunction

    generate
        for (genvar i = 0; i < 5; i++) begin: lane_x_select
            for (genvar j = 0; j < 5; j++) begin: lane_y_select
                y[w*(5*i+j)+63:w*(5*i+j)] = x[w*(5*i+j)+63:w*(5*i+j)] ^ D(x, i);
            end
        end
    endgenerate

endmodule
