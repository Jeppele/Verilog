`timescale 1ns/1ps   // Always set timescale for consistency

module register_file_tb;

    // =========================================================
    // Clock & Reset
    // =========================================================
    reg clk_tb;
    reg n_rst_tb;

    // Clock generation: toggle every 1 time unit -> 2ns period
    initial clk_tb = 0;
    always #1 clk_tb = ~clk_tb;

    // Reset generation
    initial begin
        n_rst_tb = 0;
        #5 n_rst_tb = 1;   // deassert low reset after 5 time units
    end

    // =========================================================
    // DUT I/O Signals
    // =========================================================
    // Inputs
    logic wen_tb;
    logic [4:0] rsel1_tb, rsel2_tb, wsel_tb;
    logic [31:0] wdat_tb;
    // Outputs
    logic [31:0] rdat1_tb, rdat2_tb;

    // =========================================================
    // DUT Instantiation
    // =========================================================
    // Replace `register_file` with the name of your DUT and replace
    // ports accordingly
    register_file DUT (
        .clk (clk_tb),
        .n_rst (n_rst_tb),
        .rsel1 (rsel1_tb),
        .rsel2 (rsel2_tb),
        .wen (wen_tb),
        .wsel (wsel_tb),
        .wdat (wdat_tb),
        .rdat1 (rdat1_tb),
        .rdat2 (rdat2_tb)
    );

    // =========================================================
    // Helper Functions
    // =========================================================
    task write_reg( input logic [4:0] regnum, 
                    input logic [31:0] regdata);
        begin
            // Set inputs
            wsel_tb = regnum;
            wdat_tb = regdata;
            wen_tb = 1'b1;

            // Wait until positive edge of clock to write
            @(posedge clk_tb);

            // Wait until negative edge, reset signals
            @(negedge clk_tb);
            wsel_tb = '0;
            wdat_tb = '0;
            wen_tb = 1'b0;
        end
    endtask
    
    task check_reg1( input logic [4:0] regnum,
                    input logic [31:0] expected,
                    input string tag = "");
        begin
            // To hold data
            logic [31:0] regdata;

            // Set inputs
            rsel1_tb = regnum;
            
            // Affirm regdata matches expected at a positive clock edge
            @(posedge clk_tb);
            assign regdata = rdat1_tb;
            
            if (regdata !== expected) begin
                $error("REGFILE MISMATCH %s: x%0d expected 0x%08x, got 0x%08x",
                tag, regnum, expected, regdata);
            end

            // Wait until negative edge, reset signals
            @(negedge clk_tb);
            rsel1_tb = '0;
        end
    endtask

    task check_reg2( input logic [4:0] regnum,
                    input logic [31:0] expected,
                    input string tag = "");
        begin
            // To hold data
            logic [31:0] regdata;

            // Set inputs
            rsel2_tb = regnum;
            
            // Affirm regdata matches expected at a positive clock edge
            @(posedge clk_tb);
            assign regdata = rdat2_tb;
            
            if (regdata !== expected) begin
                $error("REGFILE MISMATCH %s: x%0d expected 0x%08x, got 0x%08x",
                tag, regnum, expected, regdata);
            end

            // Wait until negative edge, reset signals
            @(negedge clk_tb);
            rsel2_tb = '0;
        end
    endtask

    // =========================================================
    // Stimulus
    // =========================================================
    initial begin
        // Initialize inputs
        rsel1_tb = 0;
        rsel2_tb = 0;
        wen_tb = 0;
        wsel_tb = 0;
        wdat_tb = 0;

        // Monitor outputs (prints when any monitored var changes)
        // $monitor("Time=%0t | rst=%b | a=%b b=%b | out=%b", 
        //          $time, n_rst_tb, a_tb, b_tb, out_tb);

        // Wait until reset finishes
        @(posedge n_rst_tb);

        // Every register should be 0
        for (int i=0; i<32; ++i) begin
            check_reg1(i, 0, $sformatf("Register %d is 0 after reset", i));
            check_reg2(i, 0, $sformatf("Register %d is 0 after reset", i));
        end

        // Write to all the register files
        for (int i=0; i<32; ++i) begin
            write_reg(i, i + 2);
        end

        // Register 0 should remain 0
        check_reg1(0, 0, "x0 remains zero");
        check_reg2(0, 0, "x0 remains zero");

        // Other registers should have written data
        for (int i=1; i<32; ++i) begin
            check_reg1(i, i + 2, $sformatf("Register %d after write", i));
            check_reg2(i, i + 2, $sformatf("Register %d after write", i));
        end

        // Wrap up simulation
        #5 $finish;
    end

    // =========================================================
    // Waveform Dump (for GTKWave, ModelSim, etc.)
    // =========================================================
    initial begin
        $dumpfile("register_file_tb.vcd");   // name of VCD dump file
        $dumpvars(0, register_file_tb);      // dump all signals in tb
    end

endmodule