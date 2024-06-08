`timescale 1ns / 1ps

//Produces a parallel output rather an serial output - intended specifically for this project
module parallel_bidirectional_shift_reg
#(parameter REG_WIDTH = 4)
(
    input logic clk, reset,
    //input logic enable,                             //Used to control whether to shift or not
    input logic rot_control,                        //Control the direction of the shift
    input logic input_data,                        //Data input to be shifted left or right
    output logic [REG_WIDTH-1:0] parallel_out
);

//Signal Declerations
logic [REG_WIDTH-1:0] r_reg, r_next;

//Memory Logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        r_reg <= 1'b0;
    else
        r_reg <= r_next;
end        

//Next State Logic
always_comb
begin
    if(rot_control)
        r_next = {input_data, r_reg[REG_WIDTH-1:1]};   //Right shift
    else
        r_next = {r_reg[REG_WIDTH-2:0], input_data};             //Left shift
end

assign parallel_out = r_reg;

endmodule
