`timescale 1ns / 1ps

module decoder_3_to_8_tb;

logic [2:0] input1;
logic [7:0] out;

decoder_3_to_8 uut(.a(input1[1:0]), .enable(input1[2]), .b(out));

initial
begin

    for(int i = 0; i < 8; i++)
    begin
    input1 = i;
    #20;
    end


end
endmodule
