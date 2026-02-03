Here is a repo containing some common building blocks used in digital designs, written in Verilog.

## Simulation

I use Icarus Verilog and gtkwave to run simulations. To ensure Icarus Verilog is up and running, run these commands:

```bash
% iverilog -o hello hello.v
% vvp hello
Hello, World
```

To run a more practical test bench, run these commands:
```bash
% iverilog -o counter counter_tb.v counter.v
% vvp counter
```

Alternatively, if the number of files used in a test bench becomes very large, store a `.txt` of filenames (here, named `file_list.txt`):
```txt
counter.v
counter_tb.v

```

And compile with these commands:
```bash
% iverilog -o counter -c file_list.txt
$ vvp counter
```

To view the waveform, whose .vcd file is specified in the test bench, run this command:
```bash
% gtkwave counter_tb.vcd &
```

If you want to simulate a SystemVerilog file, use the tag `-g2012`:
```bash
% iverilog -g2012 -o register_file register_file_tb.sv register_file.sv
```

## Synthesis with Yosys

I use YoSys to synthesize my Verilog projects. To get started, first install YoSys via

```bash
brew install yosys
```

(Optional) One step involves visualizing the synthesized circuit and requires `xdot`, which can be installed with 

```
brew install xdot
```

To launch YoSys, type `yosys` in the command line and click enter. The fastest way to synthesize a circuit is with

```
read -sv <filename>
synth -top <module name>
```

A more full synthesis is:
```
read -sv <filename>
hierarchy -top <module name>
write_rtlil
proc; opt
show
techmap; opt
write_verilog <module name>.v
```

If your design uses multiple modules:

```
read <filename1> <filename2> ...
synth -top <top module name>
```