module keccak_iota #(
    parameter l = 6,
    parameter w = 2**l,
    parameter b = 25*w
) (
    input  logic [b-1:0] x,
    input  logic [w-1:0] rc,
    output logic [b-1:0] y
);

    assign y[0+:w] = x[0+:w] ^ rc;
    assign y[b-1:w] = x[b-1:w];

endmodule
