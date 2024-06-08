`timescale 1ns / 1ps


module sign_mag_adder
#(parameter N =4)
(
    input logic [N-1:0] a, b,
    output logic [N-1:0] c
);

logic sign_a, sign_b, sign_c;
logic [2:0] mag_a, mag_b, max, min;

always_comb
begin

sign_a = a[N-1];
sign_b = b[N-1];

mag_a = a[N-2:0];
mag_b = b[N-2:0];

//Determine which magnitude is larger
if(mag_a > mag_b)
    begin
    max = mag_a;
    min = mag_b;
    sign_c = sign_a;
    end
else
    begin
    max = mag_b;
    min = mag_a;
    sign_c = sign_b;
    end
    
if(sign_a == sign_b)
    c = { sign_a, (mag_a + mag_b)};
else
    c = {sign_c, (max + min)};

end
endmodule
