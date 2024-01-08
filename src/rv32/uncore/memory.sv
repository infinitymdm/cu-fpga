

module imem
	#(
		parameter INSTR_LENGTH = 32,
		parameter ADDR_LENGTH = 8
	) (
		input logic [ADDR_LENGTH-1:0] addr,
		output logic [INSTR_LENGTH-1:0] instr
	);

    logic [INSTR_LENGTH-1:0] data[(2**ADDR_LENGTH)-1:0];

    assign instr = data[addr];

endmodule

module dmem
	#(
		parameter DATA_LENGTH = 32,
		parameter ADDR_LENGTH = 10
	) (
		input logic clk, we,
		input logic [ADDR_LENGTH-1:0] addr,
		input logic [DATA_LENGTH-1:0] write_data,
		output logic [DATA_LENGTH-1:0] read_data
	);

    logic [DATA_LENGTH-1:0] data[(2**ADDR_LENGTH)-1:0];

    assign read_data = data[addr];

    always @(posedge clk) begin
		if (we) begin
			data[addr] <= write_data;
		end
    end

endmodule
