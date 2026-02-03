module register_file (
    input logic clk, n_rst, wen,
    input logic [4:0] rsel1, rsel2, wsel,
    input logic [31:0] wdat,
    output logic [31:0] rdat1, rdat2
);

logic [31:0][31:0] registers;
logic [31:0][31:0] next_registers;

// Next-State Logic
always_comb begin
    next_registers = registers;
    if (wen == 1) begin
        // Register 0 always remains at 0
        if (wsel != '0)
            next_registers[wsel] = wdat;
    end
end

// State Register
always_ff @(posedge clk or negedge n_rst) begin
    if (n_rst == 0) begin
        registers <= 0;
    end
    else begin
        registers <= next_registers;
    end
end

assign rdat1 = registers[rsel1];
assign rdat2 = registers[rsel2];
    
endmodule