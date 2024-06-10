`timescale 1ns / 1ps



module rot_square_tb;

//period is 10ns
localparam T = 10;

logic clk, reset;
logic cw, enable;
logic [3:0] an;
logic [7:0] sseg;

//Module Inst.
rotating_square#(.TIMER_WIDTH(26), .COUNTER_WIDTH(3)) uut(.*);

//Set clock to alwasy run
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

//Reset circuit prior to start
initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
end

initial
begin
    cw = 1'b1;
    enable = 1'b1;
    
    #(T*200000000);
    
    cw = 1'b0;
    
    #(T*200000000);
    
    enable = 1'b0;
end
    
endmodule
