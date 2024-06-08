`timescale 1ns / 1ps



module BCD_increment_tb;

logic [15:0] input_val;
logic [3:0] nibble_out [3:0];

BCD_increment #(.INPUT_WIDTH(16)) uut(.input_value(input_val), .out(nibble_out));

initial
begin

    input_val = 16'h8898;
    #50;
    
    input_val = 16'h7999;
    #50;
    
    input_val = 16'h1235;
    #50;
    
    input_val = 16'h0000;
    #50;    

    input_val = 16'h1999;
    #50;

    input_val = 16'h0990;
    #50;

end

endmodule
