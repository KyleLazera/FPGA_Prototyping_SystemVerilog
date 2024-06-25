`timescale 1ns / 1ps

module babbage_machine_tb;

localparam T = 10;       //10ns period

logic clk, reset;
logic start;
logic [5:0] input_value;                     
logic [3:0] bcd_out [3:0];

//Module Instantiation - this tb teste both versions of the babbage engine
//babbage_diff#(.INPUT_WIDTH(6), .OUTPUT_WIDTH(13)) uut(.*);
babbage_diff_modified#(.INPUT_WIDTH(6), .OUTPUT_WIDTH(13)) uut(.*);

//Init clock
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

//Reset Circuit
initial begin
    reset = 1'b1;
    #(T*10);
    reset = 1'b0;
end

//This task simulates a user inputting a value and pressing start
task start_circuit(input int input_val);
    begin
        input_value = input_val;
        #(10000);
        start = 1'b1;
        #(10000);
        start = 1'b0;
    end
endtask

initial begin
    start = 1'b0;
    input_value = 0;
    #(1000);
    
    //For loop is used to test all possible values for the 6-bit input
    for(int i = 0; i < 20; i++)
        begin
            start_circuit(i);
            #(10000000);   //10ms delay     
        end

    $finish;
end

endmodule
