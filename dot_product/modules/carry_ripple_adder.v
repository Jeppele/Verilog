module carry_ripple_adder #(
    parameter BIT_WIDTH = 32
) (
    input [BIT_WIDTH-1:0] a, b,
    output [BIT_WIDTH-1:0] sum,
    output overflow, negative
);

// Array to hold carries
wire [BIT_WIDTH:0] carry;
assign carry[0] = 0;

// For generating chain of full adders
genvar i;

generate
    for (i = 0; i < BIT_WIDTH; i = i + 1)begin
        full_adder FA(.a(a[i]), .b(b[i]), .carry_in(carry[i]), .sum(sum[i]), .carry_out(carry[i+1]));
    end
endgenerate

// Overflow whenever both addends are positive and sum is negative, or vice versa
assign overflow = ((a[BIT_WIDTH-1] == b[BIT_WIDTH-1]) && (a[BIT_WIDTH-1] != sum[BIT_WIDTH-1]));
assign negative = sum[BIT_WIDTH-1];
    
endmodule