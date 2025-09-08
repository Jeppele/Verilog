module counter #(
    parameter N = 8
) (
    input clk, reset, enable,
    output [3:0] out, 
    output done
);

reg [3:0] out_r;
reg done_r;

always @(posedge clk, posedge reset)
begin
    done_r <= 0;
    if (reset == 1)
        out_r <= 0;
    else
    begin
        if (enable == 1)
        begin
            if (out_r + 1 == N)
            begin
                out_r <= 0;
                done_r <= 1;
            end
            else
                out_r <= out_r + 1;
        end
        else
            out_r <= out_r;
    end
end

assign out = out_r;
assign done = done_r;
    
endmodule