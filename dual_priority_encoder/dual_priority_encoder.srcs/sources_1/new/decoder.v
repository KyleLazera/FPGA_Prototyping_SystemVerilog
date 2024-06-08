`timescale 1ns / 1ps

module decoder
#(parameter INPUT_WIDTH, OUTPUT_WIDTH = 2**INPUT_WIDTH)
(
    input logic [INPUT_WIDTH-1:0] input_val,
    output logic [OUTPUT_WIDTH-1:0] out
);

assign out = 1'b1 << input_val;

endmodule
