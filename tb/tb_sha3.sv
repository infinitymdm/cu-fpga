module tb_sha3 ();

    localparam d = 256;
    localparam r = 1600 - 2*d;

    string message_file_name = "/home/marcus/Pictures/wallpapers/Pines.jpg";
    int message_file;

    bit clk, reset, enable;
    bit [r-1:0] message;
    bit [d-1:0] digest;

    keccak #(.d) dut (
        .clk, .reset, .enable,
        .message, .digest
    );

    initial begin: dump_vcd
        $dumpfile("wave.vcd");
        $dumpvars;
    end

    initial begin: init_and_reset
        clk = 1'b0;
        enable = 1'b0;
        reset = 1'b1;
        message = '0;
        #10;
        reset = 1'b0;
        enable = 1'b1;
    end
    always #5 clk <= ~clk;

    initial begin: open_message_file
        message_file = $fopen(message_file_name, "rb");
        if (message_file == 0) begin: handle_fopen_error
            $display("Error: unable to open file '%s'", message_file_name);
            $finish;
        end
    end

    task automatic read_message_chunk (input int m_file, output bit [r-1:0] m);
        int pad_count = 0;
        byte message_byte;
        for (int i = 0; i < r/8; i++) begin: get_message_byte
            if (!$feof(m_file)) begin: read_byte
                // Read as long as there are bytes
                $fread(message_byte, m_file);
                // $display("Read byte: %h", message_byte);
            end else begin: pad_byte
                // Once out of bytes to read, pad according to SHA3
                pad_count++;
                case ({pad_count == 1, i == r/8-1})
                    2'b00: message_byte = 8'b00000000;
                    2'b01: message_byte = 8'b00000001;
                    2'b10: message_byte = 8'b01100000;
                    2'b11: message_byte = 8'b01100001;
                endcase
            end
            m = {m[r-9:0], message_byte};
        end
    endtask

    always @(posedge clk) begin: stimulate_dut
        $display("digest: %h", digest);
        if (!$feof(message_file)) begin: get_message
            read_message_chunk(message_file, message);
            $display("Message chunk: %h", message);
        end else begin: handle_eof
            $display("Result: %h", digest);
            $fclose(message_file);
            $finish;
        end
    end

endmodule
