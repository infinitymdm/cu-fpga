module keccak_iota #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    input  logic [w-1:0] rc,
    output logic [b-1:0] y
);

    assign y = {x[b-1:w*(5*2+3)], x[w*(5*2+2)+:w] ^ rc, x[w*(5*2+2)-1:0]};

endmodule
