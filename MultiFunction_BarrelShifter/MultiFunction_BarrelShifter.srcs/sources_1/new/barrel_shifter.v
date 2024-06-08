`timescale 1ns / 1ps


module barrel_shifter
#(parameter N = 8, M = 4)
(
    input logic [N-1:0] input_value,        //Input to be rotated
    input logic [M-1:0] amt,                //Amount to rotate and whether left or right
    output logic [N-1:0] rotated_out        //Ouput of rotation
);

logic rot_dir;              //Direction of rotation : 1 is right and 0 is left
logic [N-1:0] left_rot, right_rot; //Ouput for left and right rotators


left_barrel_shifter_ left_rotation(.*, .rotated_out(left_rot));
right_barrel_shifter right_rotation(.*, .rotated_out(right_rot)); 
mux2to1 #(.N(8)) mux(.select(rot_dir), .right_rot(right_rot), .left_rot(left_rot), .final_output(rotated_out));

always_comb
    begin

    if(amt[M-1] == 1)
        rot_dir = 1;         //Right rotation
    else
        rot_dir = 0;        //Left rotation
    end
endmodule
