`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////


module barrel_shifter_tb;

logic [7:0] input1;
logic [3:0] amt;
logic [7:0] out;

barrel_shifter uut(.input_value(input1), .amt(amt), .rotated_out(out));

initial begin

    input1 = 8'b10010010;
   for(int i = 0; i < 16; i++)
   begin
   
   amt = i;
   #100;
   
   end
    

end

endmodule
