`timescale 1ns / 1ps


module top_wrapper
(
    input logic clk, reset,
    input logic btn,                                        //This signifies the start button
    input logic [3:0] sw[1:0],                              //This is for the BCD style input values (using switches)
    output logic ready,                                     //This is the reayd signal displayed using an LED        
    output logic [7:0] seg,                                 //Seven segment display output
    output logic [3:0] an                                   //Seven segment display selector
);

//Signal to transfer output for fib circuit to 7-seg controller
logic [3:0] bcd_output[3:0];

//Instantiate the fibonacci sequence circuit
fibonnaci_with_bcd fib(.clk(clk), .reset(reset), .start(btn), .ready(ready), .bcd_in(sw), .bcd_out(bcd_output));

//Instantiate the Disp_mux 
disp_mux_sseg ssef_controller(.clk(clk), .reset(reset), .hex0(bcd_output[0]), .hex1(bcd_output[1]), 
                                .hex2(bcd_output[2]), .hex3(bcd_output[3]), .seg(seg), .an(an));

endmodule
