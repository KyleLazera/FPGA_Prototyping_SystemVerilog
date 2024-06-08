`timescale 1ns / 1ps


module priority_encoder_tb;

logic [3:0] input_val;
logic [1:0] out1, out2;

dual_priority_encoder#(.INPUT_WIDTH(4), .OUTPUT_WIDTH(2)) uut(.input_val(input_val), .priority1(out1), .priority2(out2));

initial
begin
   
   /*input_val = 8'b01010101;
   #50;

   input_val = 8'b10000001;
   #50;

   input_val = 8'b00010010;
   #50;

   input_val = 8'b0100001;
   #50;

   input_val = 8'b00110000;
   #50;

   input_val = 8'b00001010;
   #50;

   input_val = 8'b10100001;
   #50;

   input_val = 8'b00010001;
   #50;*/
   
for(int i = 0; i < 16; i++)
begin

input_val = i;
#50;

end

end
endmodule
