`timescale 1ns / 1ps


module period_counter_tb;

localparam T = 10;  //10ns period
localparam period_width = 24;

logic clk, reset;
logic edge_input, enable;
logic [period_width-1:0] period; 
logic done_flag;

period_counter#(.TICK_WIDTH(7), .COUNTER_WIDTH(period_width)) uut(.*);

//Task Definition of creating input ticks -> x is in microseconds 
task generate_input(input int x);
    begin
        edge_input = 1'b1;
        #(T*10);
        edge_input = 1'b0;
        #(T*(x*100));
        edge_input = 1'b1;
        #(T*10);
        edge_input = 1'b0;
    end
endtask    

//Set clk period
initial begin
    clk = 1'b1;
    forever #(T/2) clk =~ clk; 
end      

initial begin
    reset = 1'b1;
    #(T);
    reset = 1'b0;
end         

initial begin
    enable = 1'b0;
    edge_input = 1'b0;
    #(T*2);
    
    generate_input(100000); //Period of 0.1 seconds (10Hz) 
    #(T*500);
    generate_input(66667); //Period of 0.06s (15Hz) 
    #(T*500);
    generate_input(50000); //period of 0.05 seconds (20Hz) 
    #(T*500);
    generate_input(10000); //period of 0.01 seconds (100Hz)
    #(T*500);
    generate_input(5405);  //Period of 0.0054 seconds (185Hz) 
    #(T*500);
    generate_input(149);  //Period of 0.0054 seconds (6711Hz) 
    #(T*500);    
    $finish;
end


endmodule
