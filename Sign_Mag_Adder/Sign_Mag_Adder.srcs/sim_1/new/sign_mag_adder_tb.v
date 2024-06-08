`timescale 1ns / 1ps

module sign_mag_adder_tb;

logic [3:0] input1, input2, out;

sign_mag_adder uut(.a(input1), .b(input2), .c(out));

begin 
initial
    for(int i = 0; i < 16; i++)
        begin
        input1 = i;
        for(int j = 0; j < 16; j++)
            begin
            input2 = j;
            #20;
            end
        end
end
endmodule
