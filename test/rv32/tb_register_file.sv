module tb ();

    logic clk = 1; // Start on 1 so we have a negedge first
    logic we = 0;
    logic [4:0] ra, wa;
    logic [31:0] rd1, rd2, wd;

    logic exit_flag = 0;
    int num_pass = 0, num_fail = 0;

    register_file dut (clk, we, ra, wa, wa, wd, rd1, rd2);

    always begin
        #1; clk = ~clk;
    end

    // Write random data to an address and read it again

    initial begin
        wd = 32'b0;
        wa = 4'b0;
        ra = 4'b0;
    end
    always @(negedge clk) begin
        // Check if we're done
        if (exit_flag) begin
            $display("PASS: %d\nFAIL: %d", num_pass, num_fail);
            $finish;
        end
        else begin
            // Check state
            $write("%h ", rd2);
            if (rd2 === wd) begin
                $display("OK");
                num_pass++;
            end
            else begin
                $display("FAIL! Expected %h", wd);
                num_fail++;
            end
        end
    end
    always @(posedge clk) begin
        // Apply stimulus
        {exit_flag, wa}++;
        wd = $urandom();
        we = 1;
    end

endmodule
