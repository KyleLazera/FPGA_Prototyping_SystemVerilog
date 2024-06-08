`timescale 1ns / 1ps

module mux2to1
#(parameter N)
(
    input logic [N-1:0] right_rot, left_rot,
    input logic select,
    output logic [N-1:0] final_output
);

always_comb
    begin
    
    final_output = select ? right_rot : left_rot;
    
    end
endmodule
