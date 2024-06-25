`timescale 1ns / 1ps

module early_db_test;

//Signal Creation
logic clk, reset, in;
logic db_out;

//Module Inst
early_detect_debounce#(.COUNTER_WIDTH(21)) uut(.out(db_out), .*);

//Set clock for 10ns period
always begin
    clk = 1'b0;
    #(5);
    clk = 1'b1;
    #5;
end 

//Reset circuit
initial begin
    reset = 1'b1;
    #5;
    reset = 1'b0;
end

//Set values
initial begin
    //Simulating a very short debounce from a button
    in = 1'b0;
    #200;
    in = 1'b1;
    #300;
    in = 1'b0;
    #200;
    in = 1'b1;
    #200;
    in = 1'b0;
    #400;
    in = 1'b1;
    
    //Must wait 20ms from first rising edge to see output
    #25000000
    
    //Simulating a very short debounce going from high to low
    in = 1'b0;
    #200;
    in = 1'b1;
    #300;
    in = 1'b0;
    #200;
    in = 1'b1;
    #200;
    in = 1'b0;
    #400;
    in = 1'b1;
    #200;
    in = 1'b0;
    
    $finish;  
end

endmodule
