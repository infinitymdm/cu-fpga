# configuration
dev_name :=     'alchitry_cu'
dev_family :=   'hx8k'
dev_model :=    'cb132'

# dirs
tb_dir :=           'tb'
synth_dir :=        'synth'
preprocess_dir :=   'preprocessed'
build_dir :=        'build'
sim_dir :=          'sim'

# parse source files
constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
include_dirs := `find {src,tb} -name '*.sv*' -printf '-I%h\n' | sort -u | tr '\n' ' '`
src_sv := `find src -name "*.sv" | tr '\n' ' '`


## Basic recipes

_default:
    @just --list

# Create a build directory
_prep:
    @mkdir -p {{build_dir}}
    @mkdir -p {{synth_dir}}/{{preprocess_dir}}
    @mkdir -p {{sim_dir}}

# Clean up generated files
clean:
    rm -f transcript
    rm -rf {{build_dir}}
    rm -rf {{synth_dir}}
    rm -rf {{sim_dir}}

# Check the design for common code errors
lint design *VERILATOR_FLAGS:
    verilator --lint-only --timing -Wall {{VERILATOR_FLAGS}} {{include_dirs}} {{src_sv}} --top {{design}} `find -name {{design}}.sv`

# Convert a systemverilog design to verilog using sv2v
preprocess design *SV2V_FLAGS: _prep
    sv2v {{SV2V_FLAGS}} {{include_dirs}} -w{{synth_dir}}/{{preprocess_dir}} --top={{design}} `find -name {{design}}.sv` {{src_sv}}


## FPGA-related Recipes

# Synthesize a design
synth design *SV2V_FLAGS: (preprocess design SV2V_FLAGS)
    yosys -q -p 'synth_ice40 -top {{design}} -json {{synth_dir}}/{{dev_name}}_{{design}}.json' `find {{synth_dir}}/{{preprocess_dir}} -name "*.v" | tr '\n' ' '`

# Place and route a design
pnr design *SV2V_FLAGS: (synth design SV2V_FLAGS)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{synth_dir}}/{{dev_name}}_{{design}}.json --pcf {{constraints}} --asc {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icetime -d {{dev_family}} -mtr {{synth_dir}}/{{dev_name}}_{{design}}.rpt {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icepack {{synth_dir}}/{{dev_name}}_{{design}}.asc {{synth_dir}}/{{dev_name}}_{{design}}.bin

# Upload a design to the FPGA
upload design *SV2V_FLAGS: (pnr design SV2V_FLAGS)
    iceprog {{synth_dir}}/{{dev_name}}_{{design}}.bin


## Simulation Recipes

# Verilate a testbench
verilate design *VERILATOR_FLAGS: _prep
    verilator --binary --timing --trace -Wno-lint \
        -MAKEFLAGS "--silent" \
        --Mdir {{build_dir}} \
        {{VERILATOR_FLAGS}} \
        -j `nproc` \
        {{include_dirs}} \
        --top {{design}} \
        `find -name {{design}}.sv`
    make --silent -C {{build_dir}} -f V{{design}}.mk V{{design}}
    just run {{design}}

# Run simulation on a previously verilated testbench
run design *FLAGS:
    cp {{build_dir}}/V{{design}} {{sim_dir}}/.
    cd {{sim_dir}} && ./V{{design}} {{FLAGS}}

# Simulate a testbench using QuestaSim
questasim *QUESTA_FLAGS: _prep
    vlog -lint -work {{sim_dir}}/work {{QUESTA_FLAGS}} src/keccak/keccak_theta.sv src/keccak/keccak_rho.sv src/keccak/keccak_pi.sv src/keccak/keccak_chi.sv src/keccak/keccak_iota.sv src/flop/dffre.sv
    vlog -lint -work {{sim_dir}}/work {{QUESTA_FLAGS}} src/keccak/keccak_f_block.sv  src/keccak/keccak.sv
    vlog -lint -work {{sim_dir}}/work {{QUESTA_FLAGS}} tb/tb_sha3.sv
    cd {{sim_dir}} && vsim -c tb_sha3 -do "run -all"

# View simulation waveforms
view:
    gtkwave {{sim_dir}}/*.vcd
