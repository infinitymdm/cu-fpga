// This module performs one iteration of the keccak sponge function each cycle

module keccak #(
    parameter d = 112,
    parameter l = 6,
    parameter n = 12 + 2*l,
    parameter b = 25*(2**l),
    parameter c = 2*d,
    parameter r = b - c
) (
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,
    input  logic [r-1:0] message,
    output logic [d-1:0] digest
);

    // Note: These only work for SHA3/SHAKE algorithms (i.e. where l=6).
    // See FIPS 202 for details on how to generate constants for l~=6.
    longint iota_consts [23:0] = {
        64'h0000000000000001,
        64'h0000000000008082,
        64'h800000000000808a,
        64'h8000000080008000,
        64'h000000000000808b,
        64'h0000000080000001,
        64'h8000000080008081,
        64'h8000000000008009,
        64'h000000000000008a,
        64'h0000000000000088,
        64'h0000000080008009,
        64'h000000008000000a,
        64'h000000008000808b,
        64'h800000000000008b,
        64'h8000000000008089,
        64'h8000000000008003,
        64'h8000000000008002,
        64'h8000000000000080,
        64'h000000000000800a,
        64'h800000008000000a,
        64'h8000000080008081,
        64'h8000000000008080,
        64'h0000000080000001,
        64'h8000000080008008
    };

    logic [b-1:0] state, next_state;
    logic [n-1:0][b-1:0] x, x_theta, x_rho, x_pi, x_chi, x_iota;

    dffre #(.width(b)) state_reg (
        .clk, .reset, .enable,
        .d(next_state),
        .q(state)
    );

    // Perform the keccak sponge function to compute the next state
    generate
        for (genvar i = 0; i < n; i++) begin: keccak_f_block
            if (i == 0) begin: keccak_f_init
                assign x[i] = {state[b-1:c] ^ message, state[c-1:0]};
            end else begin: keccak_f_round
                assign x[i] = x_iota[i-1];
            end
            keccak_theta #(.l) theta (.x(x[i]), .y(x_theta[i]));
            keccak_rho #(.l) rho (.x(x_theta[i]), .y(x_rho[i]));
            keccak_pi #(.l) pi (.x(x_rho[i]), .y(x_pi[i]));
            keccak_chi #(.l) chi (.x(x_pi[i]), .y(x_chi[i]));
            keccak_iota #(.l) iota (.x(x_chi[i]), .rc(iota_consts[i]), .y(x_iota[i]));
        end
    endgenerate
    assign next_state = x_iota[n-1];

    // Output is sponge output after absorbing the full message
    // Technically this only works for SHA3 stuff, since r > d in all certified configurations
    // FIXME: for cases r < d, register sponge outputs so we can fill up all bits of the digest
    assign digest = next_state[c+:d];

endmodule
