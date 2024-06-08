`timescale 1ns / 1ps

module pwm_tb;

//Period used will be 10ns to mimic BAsys3 clock
localparam T = 10;

//Signal Declerations
logic clk, reset;
logic [3:0] hex0, hex1, hex2, hex3;
logic [3:0] pwm_control, an, dp_in;
logic [7:0] sseg;

//Instantiate Module
sseg_time_multiplexing uut(.clk(clk), .reset(reset), .dp_in(dp_in), .*);

//Initialize clock to run forever
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

//initialize with reset
initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
end

initial 
begin
    hex0 = 4'h4012;
    hex1 = 4'h1A65;
    hex2 = 4'h76C3;
    hex3 = 4'h9ACB;
    dp_in = 4'b1000;
    
    pwm_control = 4'b0010;
    
    #(T*50)
    
    $stop;
end





endmodule
