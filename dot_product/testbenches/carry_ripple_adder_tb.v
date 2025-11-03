`timescale 1ns/1ps   // Always set timescale for consistency

module carry_ripple_adder_tb;
    localparam BIT_WIDTH = 8;

    // =========================================================
    // DUT I/O Signals
    // =========================================================
    // Declare test bench-controlled regs for inputs
    reg signed  [BIT_WIDTH-1:0] a_tb, b_tb;
    // Declare wires to capture outputs
    wire signed [BIT_WIDTH-1:0] sum_tb;
    wire overflow_tb, negative_tb;

    // =========================================================
    // DUT Instantiation
    // =========================================================
    // Replace `template` with the name of your DUT and replace
    // ports accordingly
    carry_ripple_adder #(
        .BIT_WIDTH(BIT_WIDTH)
    )
    DUT
    (
        .a          (a_tb),
        .b          (b_tb),
        .sum        (sum_tb),
        .overflow   (overflow_tb),
        .negative   (negative_tb)
    );

    // =========================================================
    // Automatic checking task
    // =========================================================

    task automatic check_add(
            input signed [BIT_WIDTH-1:0] a_i,
            input signed [BIT_WIDTH-1:0] b_i,
            input signed [BIT_WIDTH-1:0] sum_expected,
            input overflow_expected,
            input negative_expected
        );
        begin
            // Assign tb inputs to a_i and b_i
            a_tb = a_i;
            b_tb = b_i;

            // Let things settle
            #1

            if (sum_tb != sum_expected) begin
            $display("ERROR: Carry ripple adder had incorrect sum at time %0t (expected %d, got %d)", $time, sum_expected, sum_tb);
            $finish;
            end
            if (overflow_tb != overflow_expected) begin
                $display("ERROR: Carry ripple adder had incorrect overflow flag at time %0t (expected %b, got %b)", $time, overflow_expected, overflow_tb);
                $finish;
            end
            if (negative_tb != negative_expected) begin
                $display("ERROR: Carry ripple adder had incorrect negative flag at time %0t (expected %b, got %b)", $time, negative_expected, negative_tb);
                $finish;
            end
        end

        endtask

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialize inputs
        a_tb = 0;
        b_tb = 0;

        // Monitor outputs (prints when any monitored var changes)
        $monitor("Time=%0t | a=%d b=%d | sum=%d overflow=%b negative=%b", 
                 $time, a_tb, b_tb, sum_tb, overflow_tb, negative_tb);

        // Test case 1 (0 + 0)
        check_add(0, 0, 0, 0, 0);

        // Test case 2 (20 + 10)
        check_add(20, 10, 30, 0, 0);

        // Test case 3 (negative sum)
        check_add(-20, 10, -10, 0, 1);

        // Test case 4 (positive overflow)
        check_add(64, 64, -128, 1, 1);

        // Test case 5 (negative overflow)
        check_add(-128, -1, 127, 1, 0);

        // Test case 6
        check_add(126, 1, 127, 0, 0);

        // Wrap up simulation
        #1
        $display("Carry ripple adder tests successful!");
        $finish;
    end

    // =========================================================
    // Waveform Dump (for GTKWave, ModelSim, etc.)
    // =========================================================
    initial begin
        $dumpfile("carry_ripple_adder_tb.vcd");   // name of VCD dump file
        $dumpvars(0, carry_ripple_adder_tb);      // dump all signals in tb
    end

endmodule