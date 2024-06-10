`timescale 1ns / 1ps

module decoder_2_to_4_testbench;

logic [1:0] input1;
logic enable;
logic [3:0] out;

decoder_2_to_4 uut(.a(input1), .enable(enable), .b(out));

initial
begin

enable = 0;

for(int i = 0; i < 4; i++)
    begin
    input1 = i;
    #100;
    end
    
enable = 1;

for(int i = 0; i < 4; i++)
    begin
    input1 = i;
    #100;
    end

$stop;

end
endmodule
