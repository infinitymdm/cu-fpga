module register_file
    #(
        parameter WORD_LENGTH = 32,
        parameter ADDR_LENGTH = 5
    ) (
        input  logic                   clk, we3,
        input  logic [ADDR_LENGTH-1:0] ra1, ra2, wa3,
        input  logic [WORD_LENGTH-1:0] wd3,
        output logic [WORD_LENGTH-1:0] rd1, rd2
    );

    // 3-port register file
    // 2 read ports and 1 write port
    // Combinational reads and sequential writes
    // 0x0 is always zero per rv32 spec

    logic [WORD_LENGTH-1:0] data[(2**ADDR_LENGTH)-1:0];
    initial data[0] = '0;

    // Read combinationally
    assign rd1 = data[ra1];
    assign rd2 = data[ra2];

    // Write on clock rising edge
    always @(posedge clk) begin
        if (we3 && |wa3) begin
            data[wa3] <= wd3;
        end
    end

endmodule // register_file


