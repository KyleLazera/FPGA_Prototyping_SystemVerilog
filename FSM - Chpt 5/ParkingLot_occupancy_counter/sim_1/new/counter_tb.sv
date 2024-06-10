`timescale 1ns / 1ps

//Used to simulate the counter/decrementor module
module counter_tb;

localparam T = 10; //10ns period

logic clk, reset, inc, dec;
logic [3:0] hex_out [1:0];

counter_circuit uut(.*);

//Enable Clock
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
    inc = 1'b0;
    dec = 1'b0;
    #(T*2);
    
    //test by incrementing 4 times
    for(int i = 0; i < 4; i++)
    begin
        inc = 1'b1;
        #(T);
        inc = 1'b0;
        #(T*2);
    end
    
    //Test by decrementing 2 times
    dec = 1'b1;
    #(T);    
    dec = 1'b0;
    #(T*2);
    dec = 1'b1;
    #(T);    
    dec = 1'b0;
    #(T*2);
    
    $stop;
    
end

endmodule
