`timescale 1ns / 1ps

module random_delay_tb;

localparam T = 10;                  //10ns period

logic clk, reset, start;            //Input signals         
logic delay_complete;               //Output signals
logic [3:0] rand_value;

//Module Inst
random_delay#(.LFSR_WIDTH(4), .COUNTER_WIDTH(31)) uut(.*);

//Clock init
initial begin
    clk = 1'b0;
    forever #(T/2) clk =~clk;
end

//Init circuit
initial begin
    reset = 1'b1;
    #T;
    reset = 1'b0;
end

//Attempt to simulate button pushes at random intervals to see what values are generated
initial begin
    start = 1'b0;
    
    #(T*50100);
    start = 1'b1;
    #(T*1000);
    start = 1'b0;
    wait(delay_complete == 1);
    
    start = 1'b1;
    #(T*1000);
    start = 1'b0;
    wait(delay_complete == 1);
    
    start = 1'b1;
    #(T*1000);
    start = 1'b0;
    wait(delay_complete == 1);
    
    start = 1'b1;
    #(T*1000);
    start = 1'b0;
    wait(delay_complete == 1);
    
    start = 1'b1;
    #(T*1000);
    start = 1'b0;
    wait(delay_complete == 1);
    
    start = 1'b1;
    #(T*1000);
    start = 1'b0;  
    wait(delay_complete == 1); 
    
    $finish;                 
end


endmodule
