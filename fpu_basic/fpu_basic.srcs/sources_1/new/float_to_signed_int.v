`timescale 1ns / 1ps

/*Convert a 32 bit floating point value into an 8-bit integer - if negative it will be in 2's complement*/
module float_to_signed_int
(
    input logic [31:0] float,
    output logic [7:0] signed_int,
    output logic underflow, overflow
);

/*Floating point unit make-up*/
logic [22:0] mantissa;
logic [7:0] exponent;
logic sign_bit;

logic [7:0] unbiased_exponenet, integer_val;

generate

/*Break up floating point unit into its constituent parts: sign, exponent and mantissa*/
assign sign_bit = float[31];
assign exponent = float[30:23];
assign mantissa = float[22:0];


assign unbiased_exponenet = exponent - 8'b01111111;            //Remove biasing from exponent (subtract 127)
assign integer_val = ({1'b1, mantissa[22:16]} >> (7 - unbiased_exponenet)) ;                  //Get the int value from mantissa

always_comb
    begin
    
    //Check for status of overflow and underflow flags
    if(integer_val > 8'b01111111)
        begin
        overflow = 1'b1;
        underflow = 1'b0;
        end
        
    else if(integer_val < 8'b00000001)
        begin
        overflow = 1'b0;
        underflow = 1'b1;
        end 
        
    else
        begin
        overflow = 1'b0;
        underflow = 1'b0;
        end         
          
     //Check for sign bit - if negative present in 2's complement
     if(sign_bit == 1)
        
        signed_int = ~(integer_val) + 1;
        
    else
        signed_int = integer_val;
     
     
    end
    
endgenerate 
endmodule
