`timescale 1ns / 1ps



module basic_fpu_tb;

logic [31:0] float1, float2;
logic out;


//signed_int_to_float uut(.signed_int(input_val), .float(out));
//float_to_signed_int uut(.float(input_val), .signed_int(out), .overflow(of), .underflow(uf));
float_greater_than uut(.float1(float1), .float2(float2), .gt(out));

initial begin

float1 = 32'h3F400000;//0.75
float2 = 32'h3E800000; //0.25
#50;

float1 = 32'hBF000000; //-0.50
float2 = 32'hBE800000; //-0.25
#50;

float1 = 32'h3E800000;//0.25
float2 = 32'hBE800000;//-0.25
#50;

float1 = 32'h42906733;//80.05
float2 = 32'h42906799;//80.09
#50;

float1 = 32'hC2906733;//-80.05
float2 = 32'hC2906799;//-80.09
#50;

$stop;


end
endmodule
