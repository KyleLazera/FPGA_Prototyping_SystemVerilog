`timescale 1ns / 1ps


module stop_watch_tb;

localparam T = 10;               //10ns period

logic clk, clr, up;
logic [3:0] parallel_out[3:0];

stop_watch#(.TICK_WIDTH(24)) uut(.clk(clk), .clr(clr), .up(up), .parallel_out(parallel_out));

//Initialize clock
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

//Being writing values
initial
begin
    up = 1'b1;
    clr = 1'b1;
    #(T/2);
    clr = 1'b0;
    
    //clr = 1'b0;
    wait(parallel_out[2] == 1 && parallel_out[1] == 4);
    up = 1'b0;
    
end

endmodule
