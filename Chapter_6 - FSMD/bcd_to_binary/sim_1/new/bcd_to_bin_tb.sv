`timescale 1ns / 1ps


module bcd_to_bin_tb;

localparam T = 10;      //constant for 10ns clock period

logic clk, reset, load, done_tick, ready;
logic [3:0] bcd_value[1:0];
logic [7:0] binary_value;

//Module inst
bcd_to_bin uut(.*);

//Set clk period
initial begin
    clk = 1'b0;
    forever #(T/2) clk =~ clk; 
end

//Create reset values
initial begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
end

//UUT assignments
initial begin

    //Deley to test for ready signal
    #(T*10);        
    load = 1'b1;
    //Set bcd value to 84
    bcd_value[0] = 4'b0100;
    bcd_value[1] = 4'b1000;
    #(T*5);
    load = 1'b0;
    //Wait for compitation to complete
    #(T*10000);
    
     load = 1'b1;
    //Set bcd value to 39
    bcd_value[0] = 4'b1001;
    bcd_value[1] = 4'b0011;
    #(T*5);
    load = 1'b0;
    #(T*100);
    
        
end

endmodule
