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
include_dirs := `find {src,tb,include} -name '*.sv*' -printf '-I%h\n' | sort -u | tr '\n' ' '`
include_sv := `find include -name 'uvm_pkg.sv' | tr '\n' ' '`
src_sv := `find src -name "*.sv" | tr '\n' ' '`
tb_sv := `find tb -name "*.sv" | tr '\n' ' '`

# UVM-related settings
uvm_flags := "-DUVM_NO_DPI"
warnings := "-Wno-CONSTRAINTIGN -Wno-ZERODLY -Wno-SYMRSVDWORD -Wno-IGNOREDRETURN"

_default:
    @just --list

# Create a build directory
_prep:
    mkdir -p {{build_dir}}

# Synthesize the design
synth design: _prep
    yosys -q -p 'synth_ice40 -top {{design}} -json {{build_dir}}/{{dev_name}}_{{design}}.json' {{src_sv}}

# Place and route the design
pnr design: (synth design)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{build_dir}}/{{dev_name}}_{{design}}.json --pcf {{constraints}} --asc {{build_dir}}/{{dev_name}}_{{design}}.asc
    icetime -d {{dev_family}} -mtr {{build_dir}}/{{dev_name}}_{{design}}.rpt {{build_dir}}/{{dev_name}}_{{design}}.asc
    icepack {{build_dir}}/{{dev_name}}_{{design}}.asc {{build_dir}}/{{dev_name}}_{{design}}.bin

# Upload the design to the FPGA
upload design: (pnr design)
    iceprog {{build_dir}}/{{dev_name}}_{{design}}.bin

# Simulate the design against a testbench using verilator
sim design *FLAGS: _prep
    verilator --binary --timing --Mdir {{build_dir}} {{uvm_flags}} -Wno-lint {{warnings}} {{FLAGS}} -j `nproc` {{include_dirs}} --top {{design}} `find -name {{design}}.sv`
    make -C {{build_dir}} -f V{{design}}.mk V{{design}}
    just run {{design}}

run design:
    ./{{build_dir}}/V{{design}}

# View simulation waveforms
view:
    gtkwave {{wave_dir}}/*.vcd

# Check the design for common code errors
lint design *FLAGS:
    verilator --timing --lint-only {{uvm_flags}} -Wall {{warnings}} {{FLAGS}} {{include_dirs}} --top {{design}} {{include_sv}} {{tb_sv}} {{src_sv}}

clean:
    rm -rf {{build_dir}}
    rm -f *.vcd
    rm -f *.dot
    rm -f *.png
