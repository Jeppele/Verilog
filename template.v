module template (
    input clk, rst, a, b,
    output out
);

assign out = a & b;
    
endmodule