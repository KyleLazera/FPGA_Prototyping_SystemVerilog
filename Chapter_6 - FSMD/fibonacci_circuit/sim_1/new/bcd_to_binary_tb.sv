`timescale 1ns / 1ps


module bcd_to_binary_tb;

localparam T = 10;      //constant for 10ns clock period

logic clk, reset, ready, start;                                                 
logic [3:0] bcd_in[1:0];                                                       
logic [3:0] bcd_out[3:0];

//Module inst
fibonnaci_with_bcd uut(.*);

//Set clk period
initial begin
    clk = 1'b1;
    forever #(T/2) clk =~ clk; 
end

//Create reset values
initial begin
    reset = 1'b1;
    #(T*5);
    reset = 1'b0;
end

//UUT assignments
initial begin
    start = 1'b0;
    //Delay to test for ready signal
    #(T*10);        
    //Set bcd index to 10
    bcd_in[0] = 4'b0000;
    bcd_in[1] = 4'b0001;
    #(T*10);
    start = 1'b1;
    //Wait for compitation to complete
    #(T*100000);
    start = 1'b0;
    #(T*100000);

        
end
endmodule
