# configuration
dev_name := 'alchitry_cu'
dev_family := 'hx8k'
dev_model := 'cb132'

# dirs
build_dir := 'build'
tb_dir := 'tb'

# parse source files
constraints := `find constraints -name "*.pcf" | tr '\n' ' '`
sources := `find src -name "*.sv" | tr '\n' ' '`

prep:
    mkdir -p {{build_dir}}

synth top="main": prep
    yosys -q -p 'synth_ice40 -top {{top}} -json {{build_dir}}/{{dev_name}}.json' {{sources}}

pnr top="main": (synth top)
    nextpnr-ice40 --{{dev_family}} --package {{dev_model}} --json {{build_dir}}/{{dev_name}}.json --pcf {{constraints}} --asc {{build_dir}}/{{dev_name}}.asc
    icetime -d {{dev_family}} -mtr {{build_dir}}/{{dev_name}}.rpt {{build_dir}}/{{dev_name}}.asc
    icepack {{build_dir}}/{{dev_name}}.asc {{build_dir}}/{{dev_name}}_{{top}}.bin

upload top="main": (pnr top)
    iceprog {{build_dir}}/{{dev_name}}_{{top}}.bin

sim top="main": prep
    verilator --trace --top {{top}} --cc {{sources}} --Mdir {{build_dir}} --exe {{tb_dir}}/tb_{{top}}.cpp
    make -C {{build_dir}} -f V{{top}}.mk V{{top}}
    ./{{build_dir}}/V{{top}}

view:
    gtkwave *.vcd

lint top="main":
    verilator --lint-only -Wall --top {{top}} -Isrc {{sources}}

clean:
    rm -rf {{build_dir}}
