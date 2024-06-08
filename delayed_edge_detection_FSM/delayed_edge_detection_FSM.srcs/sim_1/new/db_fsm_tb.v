`timescale 1ns / 1ps


module db_fsm_tb;

//Set clock frequency
localparam T = 10;    //10ns

//Signals
logic clk, reset, sw;
logic debounced_sw;

//Module inst
db_fsm uut(.*);

//Set clock
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end;

initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
    
    #(T*2);
    sw = 1'b1;
    #(T/4);
    sw = 1'b0;
    #(T/8);
    sw = 1'b1;
    #(T);
    sw = 1'b0;
    #(T/3);
    sw = 1'b1;
    
    #(T*1000000);
    
    #(T*2);
    sw = 1'b0;
    #(T/4);
    sw = 1'b1;
    #(T/8);
    sw = 1'b0;
    #(T);
    sw = 1'b1;
    #(T/3);
    sw = 1'b0;
end

endmodule
