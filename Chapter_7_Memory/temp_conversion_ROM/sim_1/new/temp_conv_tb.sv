`timescale 1ns / 1ps

module temp_conv_tb;

logic clk; 
logic format;
logic [7:0] temp_input;
logic [7:0] temp_out;

//Module inst
temp_conversion_rom#(.DATA_WIDTH(8)) uut(.*);

//Init clock - 10ns period
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//Test Values
initial begin
    //Begin with conversion from C to F
    format = 1'b1;
    temp_input = 8'd10;
    #(100);
    temp_input = 8'd0;
    #(100);
    temp_input = 8'd46;
    #(100);
    temp_input = 8'd96;
    #(100);
    temp_input = 8'd100;
    #100;
    //Error checking inputs:
    temp_input = 8'd105;
    #(100);  
    
    //Slight pause 
    #10000;
    
    //Convert from F to C
    format = 1'b0;
    temp_input = 8'd32;
    #(100);
    temp_input = 8'd76;
    #(100);
    temp_input = 8'd178;
    #(100);
    temp_input = 8'd110;
    #(100);
    temp_input = 8'd43; 
    #100;
    temp_input = 8'd212; 
    #100;
    //Error checking inputs:
    temp_input = 8'd21;
    #(100);  
    temp_input = 8'd250;
    #(100);
    
    $finish;      
end

endmodule
