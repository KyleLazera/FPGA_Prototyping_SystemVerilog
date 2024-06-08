`timescale 1ns / 1ps


module barrel_shifter_testbench;

logic [7:0] input_value;
logic [3:0] amt;
logic [7:0] out;

 barrel_shifter_wrapper #(.INPUT_WIDTH(8), .SHIFT_WIDTH(4)) uut(.input_value(input_value), .amt(amt), .out(out));
 //circuit_inverter #(.INPUT_WIDTH(8)) uut(.*, .rot_dir(amt[3]));
 
 initial
 begin
 
 input_value = 8'b10010010;
 
    for(int i = 0; i < 16; i++)
    begin
    amt = i;
    #50;
    end
end
endmodule
