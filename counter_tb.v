`timescale 1ns/1ps   // Always set timescale for consistency

module counter_tb;

    // =========================================================
    // Clock & Reset
    // =========================================================
    reg clk_tb;
    reg rst_tb;

    // Clock generation: toggle every 1 time unit -> 2ns period
    initial clk_tb = 0;
    always #1 clk_tb = ~clk_tb;

    // Reset generation
    initial begin
        rst_tb = 1;
        #5 rst_tb = 0;   // deassert reset after 5 time units
    end

    // =========================================================
    // DUT I/O Signals
    // =========================================================
    // Declare test bench-controlled regs for inputs
    reg  en_tb;
    // Declare wires to capture outputs
    wire [3:0] out_tb;
    wire done_tb;

    // =========================================================
    // DUT Instantiation
    // =========================================================
    // Replace `template` with the name of your DUT
    counter DUT (
        .clk    (clk_tb),
        .reset  (rst_tb),
        .enable (en_tb),
        .out    (out_tb),
        .done   (done_tb)
    );

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialize inputs
        en_tb = 0;

        // Monitor outputs (prints when any monitored var changes)
        $monitor("Time=%0t | rst=%b | en=%b | out=%b | done=%b", 
                 $time, rst_tb, en_tb, out_tb, done_tb);

        // Wait until reset finishes
        @(negedge rst_tb);

        // Test case 1
        #10 
        en_tb = 1; #50 // Let enable be high for 50 time units (25 clock cycles)
        en_tb = 0;

        // Test case 2
        #10;

        // Test case 3
        #10;

        // Wrap up simulation
        #20 $finish;
    end

    // =========================================================
    // Waveform Dump (for GTKWave, ModelSim, etc.)
    // =========================================================
    initial begin
        $dumpfile("counter_tb.vcd");   // name of VCD dump file
        $dumpvars(0, counter_tb);      // dump all signals in tb
    end

endmodule