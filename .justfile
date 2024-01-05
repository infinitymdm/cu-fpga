# Device information
device := "alchitry_cu"
dev_family := "hx8k"
dev_model := "cb132"

# synlig tools (yosys, surelog, etc)
synlig_dir := "~/software/synlig/out/release/bin"
yosys := synlig_dir + "/yosys"

constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
sources := `find src -name "*.sv" | tr '\n' ' '`

synth top:
    {{yosys}} -q \
        -p 'plugin -i systemverilog' \
        -p 'read_systemverilog {{sources}}' \
        -p 'synth_ice40 -top {{top}} -json {{device}}.json'
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{device}}.json --pcf {{constraints}} --asc {{device}}.asc
    icetime -d {{dev_family}} -mtr {{device}}.rpt {{device}}.asc
    icepack {{device}}.asc {{device}}.bin

upload top: (synth top)
    iceprog {{device}}.bin

draw top:
    {{yosys}} -q \
        -p 'plugin -i systemverilog' \
        -p 'read_systemverilog {{sources}}' \
        -p 'hierarchy -check -top {{top}}' \
        -p 'proc' \
        -p 'show -prefix {{top}} -format dot {{top}}'
    dot -Tpng {{top}}.dot -o {{top}}.png

clean:
    rm -f *.json *.asc *.rpt *.bin *.dot *.png
