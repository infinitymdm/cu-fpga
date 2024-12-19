# configuration
dev_name := 'alchitry_cu'
dev_family := 'hx8k'
dev_model := 'cb132'

# dirs
tb_dir := 'tb'
synth_dir := 'synth'
build_dir := 'build'
sim_dir := 'sim'

# parse source files
constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
include_dirs := `find {src,tb} -name '*.sv*' -printf '-I%h\n' | sort -u | tr '\n' ' '`
# include_sv := `find include -name 'uvm_pkg.sv' | tr '\n' ' '`
src_sv := `find src -name "*.sv" | tr '\n' ' '`
tb_sv := `find tb -name "*.sv" | tr '\n' ' '`


_default:
    @just --list

# Create a build directory
_prep:
    mkdir -p {{build_dir}}
    mkdir -p {{synth_dir}}
    mkdir -p {{sim_dir}}

# Synthesize the design
synth design: _prep
    yosys -q -p 'synth_ice40 -top {{design}} -json {{synth_dir}}/{{dev_name}}_{{design}}.json' {{src_sv}}

# Place and route the design
pnr design: (synth design)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{synth_dir}}/{{dev_name}}_{{design}}.json --pcf {{constraints}} --asc {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icetime -d {{dev_family}} -mtr {{synth_dir}}/{{dev_name}}_{{design}}.rpt {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icepack {{synth_dir}}/{{dev_name}}_{{design}}.asc {{synth_dir}}/{{dev_name}}_{{design}}.bin

# Upload the design to the FPGA
upload design: (pnr design)
    iceprog {{synth_dir}}/{{dev_name}}_{{design}}.bin

# Simulate a testbench using verilator
sim design *FLAGS: _prep
    verilator --binary --timing --trace --Mdir {{build_dir}} -Wno-lint {{FLAGS}} -j `nproc` {{include_dirs}} --top {{design}} `find -name {{design}}.sv`
    make -C {{build_dir}} -f V{{design}}.mk V{{design}}
    just run {{design}}

run design *FLAGS:
    cp {{build_dir}}/V{{design}} {{sim_dir}}/.
    cd {{sim_dir}} && ./V{{design}} {{FLAGS}}

# Simulate a testbench using QuestaSim
questasim *FLAGS: _prep
    vlog -lint -work {{sim_dir}}/work {{FLAGS}} src/keccak/keccak_theta.sv src/keccak/keccak_rho.sv src/keccak/keccak_pi.sv src/keccak/keccak_chi.sv src/keccak/keccak_iota.sv src/flop/dffre.sv
    vlog -lint -work {{sim_dir}}/work {{FLAGS}} src/keccak/keccak_f_block.sv  src/keccak/keccak.sv
    vlog -lint -work {{sim_dir}}/work {{FLAGS}} tb/tb_sha3.sv
    cd {{sim_dir}} && vsim -c tb_sha3 -do "run -all"

# View simulation waveforms
view:
    gtkwave {{sim_dir}}/*.vcd

# Check the design for common code errors
lint design *FLAGS:
    verilator --lint-only --timing -Wall {{FLAGS}} {{include_dirs}} {{src_sv}} --top {{design}} `find -name {{design}}.sv`

clean:
    rm -f transcript
    rm -rf {{synth_dir}}
    rm -rf {{build_dir}}
    rm -rf {{sim_dir}}
