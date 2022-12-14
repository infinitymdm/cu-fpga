# configuration
SHELL = /bin/sh
FPGA_PKG = cb132
FPGA_TYPE = hx8k
PCF = constraints/cu.pcf

# included modules
SRC = main.sv

main: main.rpt main.bin

main.json: ${SRC}
	yosys -ql main-yosys.log -p 'synth_ice40 -top main -json $@' ${SRC}

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

all: main

clean:
	rm -f *.json *.asc *.rpt *.bin *yosys.log

.PHONY: all clean