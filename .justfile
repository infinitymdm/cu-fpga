# Device information
device := "alchitry_cu"
dev_family := "hx8k"
dev_model := "cb132"

# synlig tools (yosys, surelog, etc)
synlig_dir := "~/software/synlig/out/release/bin"
yosys := synlig_dir + "/yosys"

constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
sources := `find src -name "*.sv" | tr '\n' ' '`

default: pnr

synth top="main":
    {{yosys}} -q \
        -p 'plugin -i systemverilog' \
        -p 'read_systemverilog {{sources}}' \
        -p 'synth_ice40 -top {{top}} -json {{device}}.json'

pnr top="main": (synth top)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{device}}.json --pcf {{constraints}} --asc {{device}}.asc
    icetime -d {{dev_family}} -mtr {{device}}.rpt {{device}}.asc
    icepack {{device}}.asc {{device}}.bin

pnr-gui top="main": (synth top)
    nextpnr-ice40 --gui --{{dev_family}} --package {{dev_model}} --json {{device}}.json --pcf {{constraints}} --asc {{device}}.asc

upload:
    iceprog {{device}}.bin # Equivalent to `openFPGALoader -b ice40_generic {{device}}.bin`

draw top="main":
    {{yosys}} -q \
        -p 'plugin -i systemverilog' \
        -p 'read_systemverilog {{sources}}' \
        -p 'hierarchy -check -top {{top}}' \
        -p 'proc' \
        -p 'show -prefix {{top}} -format dot {{top}}'
    dot -Tpng {{top}}.dot -o {{top}}.png

sim top +SOURCEFILES: (synth top)
    iverilog -g2012 -o {{device}}_{{top}}.vvp {{SOURCEFILES}} # Consider switching to verilator
    vvp {{device}}_{{top}}.vvp

clean:
    rm -f *.json *.asc *.rpt *.bin *.dot *.png
