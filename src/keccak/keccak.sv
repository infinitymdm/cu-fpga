// This module performs one iteration of the keccak sponge function each cycle

module keccak #(
    parameter l = 6,
    parameter d = 112,
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

    // constants for rho and iota functions
    // TODO

    logic [b-1:0] state, next_state;
    logic [n-1:0][b-1:0] x, x_theta, x_rho, x_pi, x_chi, x_iota;

    bsg_dff_reset_en #(.width_p(state)) state_reg (
        .clk_i(clk), .reset_i(reset), .en_i(enable),
        .data_i(next_state), .data_o(state)
    );

    // Perform the keccak sponge function to compute the next state
    generate
        for (genvar i = 0; i < n; i++) begin: keccak_f_block
            if (i == 0)
                x[i] = {state[b-1:c] ^ message, state[c-1:0]};
            else
                x[i] = x_iota[i-1];
            keccak_theta #(.l) theta (.x(x[i]), .y(x_theta[i]));
            keccak_rho #(.l) rho (.x(x_theta[i]), .y(x_rho[i]));
            keccak_pi #(.l) pi (.x(x_rho[i]), .y(x_pi[i]));
            keccak_chi #(.l) chi (.x(x_pi[i]), .y(x_chi[i]));
            keccak_iota #(.l) iota (.x(x_chi[i]), .y(x_iota[i]));
        end
    endgenerate
    assign next_state = x_iota[n-1]

    // Output is sponge output after absorbing the full message
    // Technically this only works for SHA3 stuff, since r > d in all certified configurations
    // FIXME: for cases r < d, register sponge outputs so we can fill up all bits of the digest
    digest = next_state[b-(d+c)-1:c];

endmodule
