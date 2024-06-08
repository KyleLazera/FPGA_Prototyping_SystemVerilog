`timescale 1ns / 1ps

module BCD_increment
#(parameter INPUT_WIDTH = 8, NUM_OF_NIBBLES = INPUT_WIDTH >> 2)
(
    input logic [INPUT_WIDTH-1:0] input_value,
    output logic [3:0] out [NUM_OF_NIBBLES-1:0]
);

logic [3:0] nibbles [NUM_OF_NIBBLES-1:0];           //Holds bit sliced nibbles from input

NibbleExtraction#(.INPUT_WIDTH(INPUT_WIDTH)) bit_slicer(.input_value(input_value), .out(nibbles));


generate
genvar i, j;

    logic [3:0] incremented_digit [NUM_OF_NIBBLES-1:0], incrementer_output [NUM_OF_NIBBLES-1:0];
    
    assign incremented_digit[0] = nibbles[0] + 1;                                       //The first nibble will always be incremented 
    assign out[0] = (incremented_digit[0] > 4'b1001) ? 4'b0000 : incremented_digit[0];  //The output (of first nibble) will be decided by whether the incremented nibble is > 9
    
    /*This loop increments each nibble and checks if it is greater than 9. If so, the output value is set to 0. If not, the output is the incremented nibble*/
    for(j = 1; j < NUM_OF_NIBBLES; j++)
    begin
        always_comb
        begin
        
        incremented_digit[j] = nibbles[j] + 1;          
        incrementer_output[j] = (incremented_digit[j] > 4'b1001) ? 4'b0000 : incremented_digit[j]; //If a nibble is incremeted and is > 9, it will be set to 0
        
        end
    end
    
    /*This for loop instantiates hardware to look if the previous nibble was greater than 9 when incrmeneted and if the previous output nibble was 0 - this would indicate 
    the current nibble needs to be incremented*/
    for(i = 1; i < NUM_OF_NIBBLES; i++)
    begin
        always_comb
        begin      
                
        out[i] = ((incremented_digit[i-1] > 4'b1001) && (!out[i-1])) ? incrementer_output[i] : nibbles[i];   //Each output is dependent upon whether the previous nibble is greater than 9 or equal to 0
            
        end
    end
    
endgenerate
endmodule



//This module uses bit slicing to seperate the input value into nibbles
module NibbleExtraction
#(parameter INPUT_WIDTH, NUM_OF_NIBBLES = INPUT_WIDTH >> 2)
(
    input logic [INPUT_WIDTH-1:0] input_value,
    output logic [3:0] out[NUM_OF_NIBBLES-1:0]
);

always_comb
begin

    for(int i = 0; i < NUM_OF_NIBBLES; i++)
        out[i] = input_value[(i*4) +: 4];

end
endmodule
