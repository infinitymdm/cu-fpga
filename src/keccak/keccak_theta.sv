module keccak_theta #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    output logic [b-1:0] y
);
    function automatic logic [w-1:0] C (logic [b-1:0] data, int i);
        // columnwise xor
        return  data[w*(5*i+0)+:64] ^
                data[w*(5*i+1)+:64] ^
                data[w*(5*i+2)+:64] ^
                data[w*(5*i+3)+:64] ^
                data[w*(5*i+4)+:64];
    endfunction

    function automatic logic [w-1:0] D (logic [b-1:0] data, int i);
        // xor column (x-1,:,z) with (x+1,:,z-1)
        logic [w-1:0] t = C(data, (i+1) % 5);
        return C(data, (i+4) % 5) ^ {t[w-2:0], t[w-1]};
    endfunction

    generate
        for (genvar i = 0; i < 5; i++) begin: lane_x_select
            for (genvar j = 0; j < 5; j++) begin: lane_y_select
                assign y[w*(5*i+j)+63:w*(5*i+j)] = x[w*(5*i+j)+63:w*(5*i+j)] ^ D(x, i);
            end
        end
    endgenerate

endmodule
