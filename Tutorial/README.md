Here is a repo containing some common building blocks used in digital designs, written in Verilog.

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
