`timescale 1ns/1ps   // Always set timescale for consistency

module template_tb;

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
    reg  a_tb, b_tb;
    // Declare wires to capture outputs
    wire out_tb;

    // =========================================================
    // DUT Instantiation
    // =========================================================
    // Replace `module_name` with the name of your DUT
    // module_name DUT (
    //     .clk (clk_tb),
    //     .rst (rst_tb),
    //     .a   (a_tb),
    //     .b   (b_tb),
    //     .out (out_tb)
    // );

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialize inputs
        a_tb = 0;
        b_tb = 0;

        // Monitor outputs (prints when any monitored var changes)
        $monitor("Time=%0t | rst=%b | a=%b b=%b | out=%b", 
                 $time, rst_tb, a_tb, b_tb, out_tb);

        // Wait until reset finishes
        @(negedge rst_tb);

        // Test case 1
        #10 a_tb = 1; b_tb = 0;

        // Test case 2
        #10 a_tb = 0; b_tb = 1;

        // Test case 3
        #10 a_tb = 1; b_tb = 1;

        // Wrap up simulation
        #20 $finish;
    end

    // =========================================================
    // Waveform Dump (for GTKWave, ModelSim, etc.)
    // =========================================================
    initial begin
        $dumpfile("template_tb.vcd");   // name of VCD dump file
        $dumpvars(0, template_tb);      // dump all signals in tb
    end

endmodule