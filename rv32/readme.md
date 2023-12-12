# RV32I Core

This folder contains source for a simple scratch-built RISC-V core that I hope will fit on the Alchitry Cu. We'll see whether I have to upgrade to an Au.

The goal is a simple serial CPU that can take in one word at a time and execute at the push of a button. Think Altair 8800, where you enter instructions with switches then execute at the push of a button.

The Alchitry Io module will serve as input for instructions using the onboard switches, and the display will serve multiple purposes. Using the D-pad, you should be able to view the state of various system registers.
