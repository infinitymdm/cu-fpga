# configuration
dev_name := 'alchitry_cu'
dev_family := 'hx8k'
dev_model := 'cb132'

# dirs
build_dir := 'build'
tb_dir := 'tb'
wave_dir := '.'

# parse source files
constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
sources := `find src -name "*.sv" | tr '\n' ' '`


_default:
    @just --list

# Create a build directory
prep:
    mkdir -p {{build_dir}}

# Synthesize the design
synth design="main": prep
    yosys -q -p 'synth_ice40 -top {{design}} -json {{build_dir}}/{{dev_name}}_{{design}}.json' {{sources}}

# Place and route the design
pnr design="main": (synth design)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{build_dir}}/{{dev_name}}_{{design}}.json --pcf {{constraints}} --asc {{build_dir}}/{{dev_name}}_{{design}}.asc
    icetime -d {{dev_family}} -mtr {{build_dir}}/{{dev_name}}_{{design}}.rpt {{build_dir}}/{{dev_name}}_{{design}}.asc
    icepack {{build_dir}}/{{dev_name}}_{{design}}.asc {{build_dir}}/{{dev_name}}_{{design}}.bin

# Upload the design to the FPGA
upload design="main": (pnr design)
    iceprog {{build_dir}}/{{dev_name}}_{{design}}.bin

# Simulate the design against a testbench using verilator
sim design="main": prep
    verilator --trace --top {{design}} --cc {{sources}} --Mdir {{build_dir}} --exe {{tb_dir}}/tb_{{design}}.cpp
    make -C {{build_dir}} -f V{{design}}.mk V{{design}}
    ./{{build_dir}}/V{{design}}

# View simulation waveforms
view:
    gtkwave {{wave_dir}}/*.vcd

# Check the design for common code errors
lint design="main":
    verilator --lint-only -Wall --top {{design}} -Isrc {{sources}}

clean:
    rm -rf {{build_dir}}
