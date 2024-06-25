`timescale 1ns / 1ps

/*Top level module that controls babbage difference engine. For more information
* on the operation see the babbage_dd module*/

/*
* This top module contains two different versions of the babbage engine. One must be commented out at all times and the other not commented. 
* To see info on eahch desing check the module itself.
*/
module top_wrapper
#(INPUT_WIDTH = 5)
(
    input logic clk, reset,
    input logic start, 
    input logic [INPUT_WIDTH-1:0] sw,                     //User input for 'n'
    output logic [3:0] an,
    output logic [7:0] seg
);

//Signal Declerations - Used to connect the two modules
logic [3:0] hex_out[3:0];

/*****Module Instantiations*****/
//Babbge Engine
//babbage_diff#(.OUTPUT_WIDTH(14), .INPUT_WIDTH(INPUT_WIDTH)) function_computation(.clk(clk), .reset(reset), .start(start), .input_value(sw),
                                                                        //.bcd_out(hex_out));                                                                        
//Babbge Engine - modified
babbage_diff_modified#(.OUTPUT_WIDTH(14), .INPUT_WIDTH(INPUT_WIDTH)) function_computation(.clk(clk), .reset(reset), .start(start), .input_value(sw),
                                                                        .bcd_out(hex_out));                                                                        
//Disp Mux 
disp_mux#(.PRESCALER_WIDTH(16), .SSEG_COUNT_WIDTH(2)) sseg_controller(.clk(clk), .reset(reset), .hex0(hex_out[0]), .hex1(hex_out[1]), .hex2(hex_out[2]),
                                                                       .hex3(hex_out[3]), .an(an), .seg(seg));


endmodule
