`timescale 1ns / 1ps

/*This module will take in an 8-bit signed integer and converts it to a 32-bit float:
Note: Inputs must be in 2's complement
*/
module signed_int_to_float
(
    input logic [7:0] signed_int,
    output logic [31:0] float
);

generate

/*These bits represent the inidivual pieces of the integer in floating point format*/
logic sign_bit;
logic [7:0] exponent;
logic [22:0] mantissa;

/*Internmediate Wires used within the circuit*/
logic [7:0] input_magnitude;
logic [2:0] most_significant_one;                   //Holds position of the most significant one

    
/*This circuit will onlt receieve 8-bit inputs, therefore a hardcoded priority encoder is used to determine the 
//position of the most significant 1*/
always_comb
    begin
    
        //If the input value is negative - revert out of 2's complement
        if(sign_bit == 1)
            input_magnitude = ~(signed_int - 1);
        
        //If the input value is positive - keep input the same
        else
            input_magnitude = signed_int;
    
    //Priority Encoder - Used to determine the position of the most significant one
        if(input_magnitude[7])
            most_significant_one = 3'b111;
        else if(input_magnitude[6])
            most_significant_one = 3'b110;
        else if(input_magnitude[5])
            most_significant_one = 3'b101;
        else if(input_magnitude[4])
            most_significant_one = 3'b100; 
        else if(input_magnitude[3])
            most_significant_one = 3'b011;            
        else if(input_magnitude[2])
            most_significant_one = 3'b010;               
        else if(input_magnitude[1])
            most_significant_one = 3'b001;    
        else if(input_magnitude[0])
            most_significant_one = 3'b000;    
    end
    
/*Continous assignments*/
assign sign_bit = signed_int[7];                    //Sign bit is most significant bit of input value
assign mantissa = ({(input_magnitude << (8 - most_significant_one)), 15'b0}) & 23'h7FFFFE; 
assign exponent = most_significant_one + 8'b01111111;

//Concatenate above wires to create floating-point notation
assign float = {sign_bit, exponent, mantissa};

endgenerate
endmodule
