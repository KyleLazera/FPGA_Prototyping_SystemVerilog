`timescale 1ns / 1ps

/*This module is a greater than comparator for 2 floating point values. It outputs a 1 if the first
??input is greater than the second and a 0 in all other conditions*/
module float_greater_than
(
    input logic [31:0] float1,
    input logic [31:0] float2,
    output logic gt
);

generate

/*Signal declerations used within circuit:*/

//Used to break floating point number into sign, exponenet and mantissa
logic sign_bit[1:0];
logic [7:0] exponent[1:0];
logic [22:0] mantissa[1:0];

//comparison (check if equal) signals
logic exponenets_equal, sign_bit_equal;

//greater than comparisions 
logic mantissa_comp, expoenent_comp, sign_bit_comp;


/*Continous assignments*/

//Break inputs into constituent parts
assign sign_bit[0] = float1[31];
assign exponent[0] = float1[30:23];
assign mantissa[0] = float1[22:0];

assign sign_bit[1] = float2[31];
assign exponent[1] = float2[30:23];
assign mantissa[1] = float2[22:0];

//assign values for comparators (check if equal)
assign exponenets_equal = (exponent[0] == exponent[1]) ? 1'b1 : 1'b0;
assign sign_bit_equal = (sign_bit[0] == sign_bit[1]) ? 1'b1 : 1'b0;

//assign values for greater than comparators
assign sign_bit_comp = (sign_bit[0] > sign_bit[1]) ? 1'b0 : 1'b1;
assign exponenet_comp = (exponent[0] > exponent[1]) ? 1'b1 : 1'b0;
assign mantissa_comp = (mantissa[0] > mantissa[1]) ? 1'b1 : 1'b0;

always_comb
    begin

    if(sign_bit_equal == 0)     //If sign bits are not equal
        gt = sign_bit_comp;
    else                        //If sign bits are equal
        begin
        if(sign_bit[0] == 1)    //If both values negative invert the output - larger absolute value = smaller value
            gt = (exponenets_equal == 0) ? ~exponenet_comp : ~mantissa_comp;
        else
            gt = (exponenets_equal == 0) ? exponenet_comp : mantissa_comp;
        end
    end
endgenerate
endmodule
