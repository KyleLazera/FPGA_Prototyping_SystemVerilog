`timescale 1ns / 1ps

module hex_disp_wrapper
(
    input logic clk,
    input logic [7:0] sw,
    output logic [3:0] an,
    output logic [7:0] sseg
);

//Signal Declerations
logic [3:0] a, b;
logic [7:0] sum;

//Module Instantiation
multiplexing_with_hex mux_disp(.clk(clk), .rst(1'b0), .hex0(a), .hex1(b), .hex2(sum[3:0]), .hex3(sum[7:4]),
                                .dp_in(4'b1011), .an(an), .sseg(sseg));

//adder circuit
assign a = sw[3:0];
assign b = sw[7:4];
assign sum = {4'b0, a} + {4'b0, b};                            

endmodule
