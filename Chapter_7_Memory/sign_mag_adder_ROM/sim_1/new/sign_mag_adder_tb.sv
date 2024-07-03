`timescale 1ns / 1ps

module sign_mag_adder_tb;

//Signals 
logic [3:0] input1, input2;
logic [3:0] r_data;

//Module Instantiation
sign_mag_rom#(.DATA_WIDTH(8), .OUTPUT_WIDTH(4)) uut(.*);

//Test values
initial begin
    //Output should be 7
    input1 = 4'b0100;
    input2 = 4'b0011;
    #1000;
    
    //Output shoudl be -9
    input1 = 4'b1011; 
    input2 = 4'b1100;
    #1000;
    
    //output should be 5
    input1 = 4'b0111;
    input2 = 4'b1001;
    #1000;
    
    $finish;
end

endmodule
