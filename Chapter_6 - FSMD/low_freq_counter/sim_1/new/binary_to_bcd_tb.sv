`timescale 1ns / 1ps

module binary_to_bcd_tb;

localparam BINARY_WIDTH = 20;   //Indicates the width of binary input
localparam T = 10;

logic clk, reset;
logic start;
logic  [BINARY_WIDTH-1:0] binary_input;
logic [3:0] bcd_out [3:0];
logic done_flag; 
logic [3:0]autoscale_shifts;

//Module Instantiation
binary_to_bcd#(.BINARY_WIDTH(BINARY_WIDTH)) uut(.*);

//Initialize clock
initial begin
    clk = 1'b1;
    forever #(T/2) clk = ~clk;
end

//Reset circuit
initial begin
    reset = 1'b1;
    #(T*2);
    reset = 1'b0;
end

//Set values
initial begin
    start = 1'b0;
    #(T*10);
    
    binary_input = 20'd9999;
    start = 1'b1;
    #T;
    start = 1'b0;
    #(T*10000);
    
    binary_input = 20'd14999;
    start = 1'b1;
    #T;
    start = 1'b0;
    #(T*10000);
    
    binary_input = 20'd19999;
    start = 1'b1;
    #T;    
    start = 1'b0;    
    #(T*10000);
    
    binary_input = 20'd99990;
    start = 1'b1;
    #T;    
    start = 1'b0;    
    #(T*10000);
    
    binary_input = 20'd184979;
    start = 1'b1;
    #T;    
    start = 1'b0;    
    #(T*10000);     
 
    
    $finish;       
    
end

endmodule
