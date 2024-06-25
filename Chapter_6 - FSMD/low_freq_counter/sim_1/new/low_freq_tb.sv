`timescale 1ns / 1ps

module low_freq_tb;

localparam T = 10;  //10ns period
localparam period_width = 24;

logic clk, reset;
logic start, signal_in;
//logic ready; 
logic [3:0] an;                                     //an determines which seg to light
logic [7:0] seg;    

low_freq_counter#(.PERIOD_WIDTH(period_width)) uut(.*);

//Task Definition of creating input ticks -> x is in microseconds 
task generate_input(input int x);
    begin
        signal_in = 1'b1;
        #(T*10);
        signal_in = 1'b0;
        #(T*(x*100));
        signal_in = 1'b1;
        #(T*10);
        signal_in = 1'b0;
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
    start = 1'b1;
    signal_in = 1'b0;
    #(T*2);
    
    generate_input(100000); //Period of 0.1 seconds (10Hz) 
    #(T*100);
    generate_input(66667); //Period of 0.06s (15Hz) 
    #(T*350);
    generate_input(50000); //period of 0.05 seconds (20Hz) 
    #(T*100);
    generate_input(10000); //period of 0.01 seconds (100Hz)
    #(T*100);
    generate_input(5405);  //Period of 0.0054 seconds (185Hz) 
    #(T*100);   
    generate_input(1000);  //Period of 0.001 seconds (1000Hz)
    #(T*100);
    generate_input(148);   //Period of 0.000148 (6750Hz)
    #(T*10000);
    $finish;
end


endmodule
