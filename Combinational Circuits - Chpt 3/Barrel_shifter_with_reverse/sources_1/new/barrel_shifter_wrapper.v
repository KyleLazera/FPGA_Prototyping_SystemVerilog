`timescale 1ns / 1ps


module barrel_shifter_wrapper
#(parameter INPUT_WIDTH = 8, SHIFT_WIDTH = 4)
(
    input logic [INPUT_WIDTH-1:0] input_value,
    input logic [SHIFT_WIDTH-1:0] amt,
    output logic [INPUT_WIDTH-1:0] out
);


logic [INPUT_WIDTH-1:0] stage1, stage2;

circuit_inverter #(.INPUT_WIDTH(INPUT_WIDTH))  pre_inverter(.input_value(input_value), .rot_dir(amt[SHIFT_WIDTH-1]), .out(stage1));
right_rotation #(.INPUT_WIDTH(INPUT_WIDTH), .SHIFT_WIDTH(SHIFT_WIDTH-1)) right_rotater(.input_value(stage1), .amt(amt[SHIFT_WIDTH-2:0]), .out(stage2));
circuit_inverter #(.INPUT_WIDTH(INPUT_WIDTH))  post_inverter(.input_value(stage2), .rot_dir(amt[SHIFT_WIDTH-1]), .out(out));



endmodule
