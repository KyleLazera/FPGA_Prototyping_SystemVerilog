`timescale 1ns / 1ps

module decoder_2_to_4
(
    input logic [1:0] a,
    input logic enable,
    output logic [3:0] b
);


assign b[0] = enable & (~a[0] & ~a[1]);
assign b[1] = enable & (a[0] & ~a[1]);
assign b[2] = enable & (~a[0] & a[1]);
assign b[3] = enable & (a[0] & a[1]);

endmodule
