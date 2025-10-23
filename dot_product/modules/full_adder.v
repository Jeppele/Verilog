module full_adder(
    input a, b, carry_in,
    output sum, carry_out
);

wire sum_w, c_o_w1, c_o_w2;

half_adder ha1(
    .a(a),
    .b(b),
    .carry(c_o_w1),
    .sum(sum_w)
);

half_adder ha2(
    .a(sum_w),
    .b(carry_in),
    .carry(c_o_w2),
    .sum(sum)
);

assign carry_out = c_o_w1 || c_o_w2;
    
endmodule