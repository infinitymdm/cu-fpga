# Recipes for working with 🐧 hdl
mod hdl

# device configuration
dev_name    :=  'alchitry_cu'
dev_family  :=  'hx8k'
dev_model   :=  'cb132'

# dirs
synth_dir :=    'synth'

# find constraint files
constraints :=  `find constraints -name "*.pcf" | tr '\n' ' '`

_default:
    @just --list

_prep:
    @just hdl::_prep
    @mkdir -p {{synth_dir}}

# Clean up generated files
clean:
    @just hdl::clean
    rm -rf {{synth_dir}}

# Synthesize a design
synth design *SV2V_FLAGS:
    @just hdl::preprocess {{design}} {{SV2V_FLAGS}} `find ~+/top {{design}}.sv`
    yosys -q -p 'synth_ice40 -top {{design}} -json {{synth_dir}}/{{dev_name}}_{{design}}.json' `find . -name "*.v" | tr '\n' ' '`

# Place and route a design
pnr design *SV2V_FLAGS: (synth design SV2V_FLAGS)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{synth_dir}}/{{dev_name}}_{{design}}.json --pcf {{constraints}} --asc {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icetime -d {{dev_family}} -mtr {{synth_dir}}/{{dev_name}}_{{design}}.rpt {{synth_dir}}/{{dev_name}}_{{design}}.asc
    icepack {{synth_dir}}/{{dev_name}}_{{design}}.asc {{synth_dir}}/{{dev_name}}_{{design}}.bin

# Upload a design to the FPGA
upload design *SV2V_FLAGS: (pnr design SV2V_FLAGS)
    iceprog {{synth_dir}}/{{dev_name}}_{{design}}.bin
