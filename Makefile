# configuration
FPGA_PKG = cb132
FPGA_TYPE = hx8k
PCF = constraints/cu.pcf
TOP = main

# included modules
SRC = main.sv util/*.sv rv32/*.sv

main: main.rpt main.bin

main.json: ${SRC}
	yosys -ql main-yosys.log -p 'synth_ice40 -top ${TOP} -json $@' ${SRC}

main.asc: main.json
	nextpnr-ice40 --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc $@

main.rpt: main.asc
	icetime -d ${FPGA_TYPE} -mtr $@ $<

main.bin: main.asc
	icepack $< $@

gui: main.json
	nextpnr-ice40 --gui --${FPGA_TYPE} --package ${FPGA_PKG} --json $< --pcf ${PCF} --asc main.asc

upload: main.bin
	iceprog $<

main.vvp:
	iverilog -g2012 -o main.vvp ${SRC}

main.vcd: main.vvp
	vvp main.vvp

sim: main.vcd
	gtkwave tb_main.vcd

dot: 
	yosys \
		-p "read_verilog -sv ${SRC}" \
		-p "hierarchy -check -top ${TOP}" \
		-p "proc" \
		-p "show -prefix ${TOP} -format dot ${TOP}"
	dot -Tpng ${TOP}.dot -o ${TOP}.png

all: main

clean:
	rm -f *.json *.asc *.rpt *.bin *yosys.log

.PHONY: all clean
