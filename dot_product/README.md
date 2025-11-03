Dot products are the core of matrix multiplication, which is an increasingly important operation in tasks such as computer graphics and artificial intelligence. Therefore, it is worthwhile to create a machine which can calculate dot products efficiently and quickly.

This repo aims to create a parameterizable dot product calculator in Verilog, using modules which are thoroughly tested.

A few building blocks are essential to create first:
- [x] Adder
- [ ] Multiplier

Also, to measure the performance of this block, I will need to do some synthesis and PnR.
- [ ] Synthesis via Yosys
- [ ] Place and Route via nextpnr

Once these are in place, we can flash to an FPGA.