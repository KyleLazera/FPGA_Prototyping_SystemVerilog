`timescale 1ns / 1ps

module stack_tb;

//Local Variables
localparam DATA_WIDTH = 8;
localparam T = 10;

//Signals
logic clk, reset;
logic push, pop;
logic [DATA_WIDTH-1:0] data_in, data_out;
logic stack_full, stack_empty;

//Module Instantiation
stack#(.DATA_WIDTH(8), .ADDRESS_WIDTH(4)) stack_uut(.*);

//Init clock 
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

//Reset/Initialize circuit
initial begin
    reset = 1'b1;
    #(T);
    reset = 1'b0;
end

task push_value(input logic[DATA_WIDTH-1:0] push_val);
    begin
        data_in = push_val;
        push = 1'b1;
        #(T);
        push = 1'b0;
        #(T);
    end
endtask

task pop_value(input int num_times);
    begin
        for(int i = 0; i < num_times; i++)
            begin
                pop = 1'b1;
                #(T);
                pop = 1'b0;
                #(T);
            end
    end
endtask

//Test values
initial begin
    //Init values to 0
    push = 1'b0;
    pop = 1'b0;
    data_in = 8'b0;
    //delay to allow circuit to set
    #(T*2);
    //Start by pushing 7 values onto the stack
    push_value(8'd10);
    push_value(8'd20);
    push_value(8'd30);
    push_value(8'd40);
    push_value(8'd50);
    push_value(8'd60);
    push_value(8'd70);    
    
    //Read 3 values from the stack
    pop_value(3);
        
    //Push and pop a singular value
    push_value(8'd80);
    pop_value(1);
    
    //Push onto the stack until it is full
    while(!stack_full)
        push_value(8'd11);
        
    //Pop 2 values
    pop_value(2);
    
    //Try to push more values even after stack is full
    push_value(8'd1);
    push_value(8'd2);
    push_value(8'd3);
    push_value(8'd4);
    
    //Pop all values off the stack
    pop_value(16);
    
    //Try to pop another value after stack is empty
    pop_value(1);
    
    $finish;

end


endmodule
