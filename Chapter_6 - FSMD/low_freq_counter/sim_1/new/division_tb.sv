`timescale 1ns / 1ps

module division_tb;

localparam T = 10; //10ns period
localparam BIT_WIDTH = 24;

logic clk, reset;
logic start;                                                  //Used to start/initialize the module
logic [BIT_WIDTH-1:0] dvsr;                                             //Divisor input 
logic [(BIT_WIDTH*2)-1:0] dvnd;                                             //Dividend input
logic complete;                                              //Flag indicating completion
logic [BIT_WIDTH-1:0] quotient;                                         //Final quotient

//Inst module
division_circuit#(.BIT_WIDTH(BIT_WIDTH)) uut(.*);

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

task division_task(input int dividend, input int divisor);
    begin
        dvsr = divisor;
        dvnd = dividend;
        #(T*10);
        start = 1'b1;
        wait(complete == 1);
        start = 1'b0;
    end
endtask

initial begin
    
    //   1000000/100000
    division_task(40'd1000000000, 20'd100000);
    #(T*10);
    // 
    division_task(40'd1000000000, 20'd149);
    #(T*10);
    // 144/12
    division_task(40'd1000000000, 20'd50000);
    #(T*10);
    // 15/3
    division_task(40'd1000000000, 20'd10000);
    #(T*10);
    
        
    $finish;
end


endmodule
