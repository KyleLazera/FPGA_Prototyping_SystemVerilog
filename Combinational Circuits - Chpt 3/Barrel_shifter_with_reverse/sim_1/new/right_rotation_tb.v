`timescale 1ns / 1ps

module right_rotation_tb;

logic [7:0] input1;
logic [2:0] amt;
logic [7:0] out;

right_rotation uut(.input_value(input1), .amt(amt), .out(out));

initial 
begin

input1 = 8'b10010010;

for(int i = 0; i < 8; i++)
    begin
    amt = i;
    #50;
    end
$stop;

end

endmodule
