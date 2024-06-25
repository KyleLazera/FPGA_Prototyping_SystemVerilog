`timescale 1ns / 1ps

module top_wrapper
(
    input logic clk, reset,
    input logic signal_in, start,
    //output logic ready,
    //output logic [3:0] an,
    //output logic [7:0] seg
    output logic [3:0]autoscale,
    output logic [3:0] bcd_out [3:0]
);


//Signal Declerations
logic [2:0] autoscale_shift_reg, autoscale_shift_next;
logic [3:0] bcd_reg[3:0], bcd_next[3:0];
assign autoscale = autoscale_shift_reg;
assign bcd_out = bcd_reg;
                                                    
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            autoscale_shift_reg <= 0;
            for(int i = 0; i < 4; i++)
                bcd_reg[i] <= 0;
        end
    else
        begin
            autoscale_shift_reg = autoscale_shift_next;
            bcd_reg = bcd_next;
        end
end                                                                                                     

endmodule
