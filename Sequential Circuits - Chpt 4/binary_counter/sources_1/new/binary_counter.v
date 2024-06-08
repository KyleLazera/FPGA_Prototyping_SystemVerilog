`timescale 1ns / 1ps


module binary_counter
#(parameter N = 8)
(
    input logic rst, clk,
    output logic [N-1:0] output_val,
    output logic max_value
);

//Signal Declerations
logic [N-1:0] r_reg, r_next;

//Memory Block
always_ff @(posedge clk, posedge rst)
begin
    if(rst)
        r_reg <= 1'b0;
    else
        r_reg <= r_next;
end

//Next-State memory block
assign r_next = r_reg + 1;

//Ouput logic
assign output_val = r_reg;
assign max_value = (r_reg == 2**N-1) ? 1'b1 : 1'b0;

endmodule
