module regfile #(parameter N = 5) (
    input logic clk,
    input logic we3,
    input logic [N-1:0] ra1, ra2, wa3,
    input logic [31:0] wd3,
    output logic [31:0] rd1, rd2);

    // 2**N-row 32-bit register file
    // 2 read ports
    // 1 write port

    logic [31:0] rf[2**N-1:0];

    assign rf[0] = 32'b0;

    // Read two ports combinationally
    always_comb begin
        rd1 = rf[ra1];
        rd2 = rf[ra2];
    end

    // Write third port on rising edge of clock
    always_ff @ (posedge clk) begin
        if (we3 && |wa3) begin
                rf[wa3] <= wd3;
        end
    end

endmodule
