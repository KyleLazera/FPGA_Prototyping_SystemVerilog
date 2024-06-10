`timescale 1ns / 1ps


module dual_edge_tb;

localparam T = 10; //Clock freq is 10ns

//Signals
logic clk, reset, in;
logic edge_detector;

//Module inst
dual_edge_mealy uut(.*);

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
    
    #(T);
    in = 1'b1;
    #(T);
    in = 1'b0;
    #(T/3);
    in = 1'b1;
    #(T*2);
    in = 1'b0;
    #(T*3);
    in = 1'b1;
    #(T*4);
    in = 1'b0;
end

endmodule
