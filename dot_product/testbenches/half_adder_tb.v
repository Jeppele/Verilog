`timescale 1ns/1ps   // Always set timescale for consistency

module half_adder_tb;

    // =========================================================
    // DUT I/O Signals
    // =========================================================
    // Declare test bench-controlled regs for inputs
    reg  a_tb, b_tb;
    // Declare wires to capture outputs
    wire sum_tb, carry_tb;

    // =========================================================
    // DUT Instantiation
    // =========================================================
    // Replace `template` with the name of your DUT and replace
    // ports accordingly
    half_adder DUT (
        .a      (a_tb),
        .b      (b_tb),
        .sum    (sum_tb),
        .carry  (carry_tb)
    );

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialize inputs
        a_tb = 1'bx;
        b_tb = 1'bx;

        // Monitor outputs (prints when any monitored var changes)
        $monitor("Time=%0t | a=%b b=%b | sum=%b | carry=%b", 
                 $time, a_tb, b_tb, sum_tb, carry_tb);

        // Test case 1
        #10 a_tb = 0; b_tb = 0;
        if (sum_tb != 0 || carry_tb != 0) begin
            $display("ERROR: Half adder failed at time %0t", $time);
            $finish;
        end

        // Test case 2
        #10 a_tb = 0; b_tb = 1;
        @(sum_tb or carry_tb) // Ensures the output signals have a chance to react to the input differences; we expect a change in outputs
        if (sum_tb != 1 || carry_tb != 0) begin
            $display("ERROR: Half adder failed at time %0t", $time);
            $finish;
        end

        // Test case 3
        #10 a_tb = 1; b_tb = 0;
        if (sum_tb != 1 || carry_tb != 0) begin
            $display("ERROR: Half adder failed at time %0t", $time);
            $finish;
        end

        // Test case 4
        #10 a_tb = 1; b_tb = 1;
        @(sum_tb or carry_tb)
        if (sum_tb != 0 || carry_tb != 1) begin
            $display("ERROR: Half adder failed at time %0t", $time);
            $finish;
        end

        // Wrap up simulation
        #1
        $display("Half-adder tests successful!");
        #20 $finish;
    end

    // =========================================================
    // Waveform Dump (for GTKWave, ModelSim, etc.)
    // =========================================================
    initial begin
        $dumpfile("half_adder.vcd");   // name of VCD dump file
        $dumpvars(0, half_adder_tb);      // dump all signals in tb
    end

endmodule