module keccak #(
    parameter d = 512,      // length of digest in bits
    parameter l = 6,        // log base 2 of the lane size
    parameter n = 12 + 2*l, // number of rounds
    parameter w = 2**l,     // lane size (i.e. word length)
    parameter b = 25*w,     // keccak permutation width (i.e. state vector length)
    parameter c = 2*d,      // capacity of the sponge function
    parameter r = b - c     // rate of the sponge function
) (
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,
    input  logic [r-1:0] message,
    output logic [d-1:0] digest
);

    // Note: These only work for SHA3/SHAKE algorithms (i.e. where l=6).
    // See FIPS 202 for details on how to generate constants for l!=6.
    longint iota_consts [23:0] = {
        64'h8000000080008008,
        64'h0000000080000001,
        64'h8000000000008080,
        64'h8000000080008081,
        64'h800000008000000a,
        64'h000000000000800a,
        64'h8000000000000080,
        64'h8000000000008002,
        64'h8000000000008003,
        64'h8000000000008089,
        64'h800000000000008b,
        64'h000000008000808b,
        64'h000000008000000a,
        64'h0000000080008009,
        64'h0000000000000088,
        64'h000000000000008a,
        64'h8000000000008009,
        64'h8000000080008081,
        64'h0000000080000001,
        64'h000000000000808b,
        64'h8000000080008000,
        64'h800000000000808a,
        64'h0000000000008082,
        64'h0000000000000001
    };

    logic [b-1:0] state, next_state;
    logic [b-1:0] x [n] /*verilator split_var*/;
    logic [b-1:0] y [n] /*verilator split_var*/;

    dffre #(.width(b)) state_reg (
        .clk, .reset, .enable,
        .d(next_state),
        .q(state)
    );

    // Perform the keccak sponge function to compute the next state
    always @(y[23]) begin: disp_on_change
        $display("next state: %h", y[23]);
    end
    generate
        for (genvar round = 0; round < n; round++) begin: keccak_round
            if (round == 0) begin: keccak_round_0
                assign x[round] = {state[b-1:c] ^ message, state[c-1:0]};
            end else begin: keccak_round_n
                assign x[round] = y[round-1];
            end
            keccak_f_block #(l) f_permute (.x(x[round]), .rc(iota_consts[round]), .y(y[round]));
        end
    endgenerate
    assign next_state = y[n-1];

    // Output is sponge output after absorbing the full message
    // Technically this only works for SHA3 stuff, since r > d in all certified configurations
    // FIXME: for cases r < d, shift in sponge outputs
    assign digest = state[b-1-:d];

endmodule
