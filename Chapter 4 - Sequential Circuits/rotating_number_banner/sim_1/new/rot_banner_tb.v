`timescale 1ns / 1ps


module rot_banner_tb;

//Clock period 10ns
localparam T = 10;

//Signals
logic clk, reset, dir;
logic [3:0] an;
logic [7:0] seg;
//logic [3:0] parallel_out [3:0];

//module inst
rotating_number_banner uut(.*);
                    
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end


initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
end

initial
begin
    dir = 1'b0;
    #(T*100000000);
    dir = 1'b0;
    
     
end
endmodule
