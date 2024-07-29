# Alchitry Cu FPGA Experiments
This repository contains my personal experiments with the Alchitry Cu FPGA board. It's mostly just me messing around, but may occasionally contain my solutions to textbook problems. 

The only thing I expect may be useful to others here is the work I've done in the cu.pcf file. I've expanded on the mapping for the Alchitry Io board, since I use that pretty regularly. 

This repo was inspired by and forked from https://github.com/codysnider/alchitry-cu-tutorial

## Getting started

There are a couple software dependencies you'll need to have installed in order to use the flows in this repo:

- [yosys](https://github.com/YosysHQ/yosys) for synthesis
- [nextpnr](https://github.com/YosysHQ/nextpnr) (in the iCE40 flavor) for place & route
- [icestorm](https://github.com/YosysHQ/icestorm) for working with the Lattice iCE40 FPGA in the Alchitry Cu
- [verilator](https://github.com/verilator/verilator) for simulation
- [just](https://github.com/casey/just) for running flows (see the justfile)

Once you've got those taken care of, you can run `just list` to see available recipes.
