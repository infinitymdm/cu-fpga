# configuration
FPGA_PKG = cb132
FPGA_TYPE = hx8k
PCF = constraints/cu.pcf
TOP = main

# included modules
SRC = main.sv util/*.sv rv32/*.sv

main: synth

synth: ${SRC}
	yosys -q -p 'synth_ice40 -top ${TOP} -json main.json' ${SRC}
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json main.json --pcf ${PCF} --asc main.asc
	icetime -d ${FPGA_TYPE} -mtr main.rpt main.asc
	icepack main.asc main.bin

upload: synth
	iceprog main.bin

sim: ${SRC}
	iverilog -g2012 -o main.vvp ${SRC}
	vvp main.vvp

dot: ${SRC}
	yosys \
		-p "read_verilog -sv ${SRC}" \
		-p "hierarchy -check -top ${TOP}" \
		-p "proc" \
		-p "show -prefix ${TOP} -format dot ${TOP}"
	dot -Tpng ${TOP}.dot -o ${TOP}.png

all: synth sim

clean:
	rm -f *.json *.asc *.rpt *.bin *yosys.log

.PHONY: all clean
