// This module performs one iteration of the keccak sponge function each cycle

module keccak #(
    parameter d = 112,
    parameter l = 6,
    parameter n = 12 + 2*l,
    parameter w = 2**l,
    parameter b = 25*w,
    parameter c = 2*d,
    parameter r = b - c
) (
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,
    input  logic [r-1:0] message,
    output logic [d-1:0] digest
);

    function automatic logic [4:0][4:0][w-1:0] to_block (logic [b-1:0] x_vec);
        logic [4:0][4:0][w-1:0] x_block;
        for (int i = 0; i < 5; i++)
            for (int j = 0; j < 5; j++)
                for (int k = 0; k < w; k++)
                    x_block[i][j][k] = x_vec[w*(5*j + i) + k];
        return x_block;
    endfunction

    function automatic logic [b-1:0] to_vector (logic [4:0][4:0][w-1:0] x_blk);
        logic [b-1:0] x_vector;
        for (int i = 0; i < 5; i++)
            for (int j = 0; j < 5; j++)
                for (int k = 0; k < w; k++)
                    x_vector[w*(5*j + i) + k] = x_blk[i][j][k];
        return x_vector;
    endfunction

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
    logic [n-1:0][4:0][4:0][w-1:0] x /*verilator split_var*/;
    logic [n-1:0][4:0][4:0][w-1:0] x_theta /*verilator split_var*/;
    logic [n-1:0][4:0][4:0][w-1:0] x_rho /*verilator split_var*/;
    logic [n-1:0][4:0][4:0][w-1:0] x_pi /*verilator split_var*/;
    logic [n-1:0][4:0][4:0][w-1:0] x_chi /*verilator split_var*/;
    logic [n-1:0][4:0][4:0][w-1:0] x_iota /*verilator split_var*/;

    dffre #(.width(b)) state_reg (
        .clk, .reset, .enable,
        .d(next_state),
        .q(state)
    );

    // Perform the keccak sponge function to compute the next state
    logic [4:0][4:0][w-1:0] x_in_blk = to_block({state[b-1:c] ^ message, state[c-1:0]});
    generate
        for (genvar q = 0; q < n; q++) begin: keccak_f_block
            if (q == 0) begin: keccak_f_init
                assign x[q] = x_in_blk;
            end else begin: keccak_f_round
                assign x[q] = x_iota[q-1];
            end
            keccak_theta #(.w) theta (.x(x[q]),       .y(x_theta[q]));
            keccak_rho   #(.w) rho   (.x(x_theta[q]), .y(x_rho[q]));
            keccak_pi    #(.w) pi    (.x(x_rho[q]),   .y(x_pi[q]));
            keccak_chi   #(.w) chi   (.x(x_pi[q]),    .y(x_chi[q]));
            keccak_iota  #(.w) iota  (.x(x_chi[q]),   .y(x_iota[q]), .rc(iota_consts[q]));
        end
    endgenerate
    assign next_state = to_vector(x_iota[n-1]);

    // Output is sponge output after absorbing the full message
    // Technically this only works for SHA3 stuff, since r > d in all certified configurations
    // FIXME: for cases r < d, register sponge outputs so we can fill up all bits of the digest
    assign digest = next_state[c+:d];

endmodule
