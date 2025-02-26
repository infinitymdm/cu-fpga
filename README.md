# Alchitry Cu FPGA Experiments
This repository contains my personal experiments with the Alchitry Cu FPGA board. It's mostly just
me messing around, but may occasionally contain my solutions to textbook problems or other work.

The big thing I expect will be useful to others here is the work I've done in the cu.pcf file. I've
expanded on the mapping for the Alchitry Io board, since I use that pretty regularly. I've also
created some helpful flows for programming your FPGA.

This repo was inspired by (and originally forked from) https://github.com/codysnider/alchitry-cu-tutorial

## Getting started

There are a couple software dependencies you'll need to have installed in order to use the flows
in this repo. For simulation you'll just need a couple things:

- [verilator](https://github.com/verilator/verilator) for simulation
- [sv2v](https://github.com/zachjs/sv2v) for SystemVerilog to Verilog conversion
- [just](https://github.com/casey/just) for running flows (see the justfile)
- [gtkwave](https://github.com/gtkwave/gtkwave) (optional) if you want to view waveforms using `just view`
- [yosys](https://github.com/YosysHQ/yosys) for synthesis
- [nextpnr](https://github.com/YosysHQ/nextpnr) (in the iCE40 flavor) for place & route
- [icestorm](https://github.com/YosysHQ/icestorm) for working with the Lattice iCE40 FPGA in the Alchitry Cu

Once you've got those taken care of, you can run `just --list` to see available recipes.

> Note: The recipes in the justfile will probably also work for other Lattice iCE40-based FPGAs.
Feel free to fiddle with the `dev_*` parameters near the top of the justfile to get things working
with your device.

## Organization

- `constriants` contains I/O mappings for the Alchitry Cu and Io.
- `docs` contains schematics for the Alchitry Cu and Io.
- `hdl` contains SystemVerilog source code and testbenches from [penguin HDL](https://github.com/infinitymdm/penguin).
- `top` contains toplevel designs that are ready to be loaded onto an FPGA.
