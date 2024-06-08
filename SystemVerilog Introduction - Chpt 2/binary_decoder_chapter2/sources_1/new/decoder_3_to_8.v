`timescale 1ns / 1ps

module decoder_3_to_8
(
    input logic [1:0] a,
    input logic enable,
    output logic [7:0] b
);

decoder_2_to_4 decoder_lsb(.a(a), .enable(~enable), .b(b[3:0]));
decoder_2_to_4 decoder_msb(.a(a), .enable(enable), .b(b[7:4]));

endmodule
