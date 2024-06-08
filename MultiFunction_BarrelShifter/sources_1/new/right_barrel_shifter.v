`timescale 1ns / 1ps


module right_barrel_shifter
#(parameter N=8, M=4)
(
    input logic [N-1:0] input_value,        //Input to be rotated
    input logic [M-1:0] amt,                //Amount to rotate and whether left or right
    output logic [N-1:0] rotated_out        //Ouput of rotation
);

logic [7:0] s0, s1;

assign s0 = amt[0] ? {input_value[0], input_value[N-1:1]} : input_value;
        
assign s1 = amt[1] ? {s0[1:0], s0[N-1:2]} : s0;
        
assign rotated_out = amt[2] ? {s1[3:0], s1[N-1:4]} : s1;
    
endmodule
