module sync (input logic clk,
             input logic d,
             input logic q);
    logic n;

    always_ff @(posedge clk) begin
        n <= d;
        q <= n;
    end
endmodule

module delay (input logic clk, d,
              output logic q);
    always_ff @(posedge clk)
        q <= d;
endmodule
