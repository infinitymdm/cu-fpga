## Keccak implementation

The goal here is to have a SHA3-compatible keccak algorithm implementation.

We can check results against the reference openssl implementation with
`openssl dgst -sha3-<num_bits> <path/to/file>`
