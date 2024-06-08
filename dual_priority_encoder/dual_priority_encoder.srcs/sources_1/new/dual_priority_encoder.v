`timescale 1ns / 1ps

module dual_priority_encoder
#(parameter INPUT_WIDTH = 8, OUTPUT_WIDTH = 3)
(
    input logic [INPUT_WIDTH-1:0] input_val,
    output logic [OUTPUT_WIDTH-1:0] priority1, priority2
);

logic [OUTPUT_WIDTH-1:0] stage1_out;                         //Output of first priority encoder
logic [INPUT_WIDTH-1:0] stage2_out, stage2_xor_out;         //Output of decoder

generate
genvar i;

    for(i = 0; i < INPUT_WIDTH; i++)
        assign stage2_xor_out[i] = input_val[i] ^ stage2_out[i];    //Instantiate XOR gates 

endgenerate

priority_encoder#(.INPUT_WIDTH(INPUT_WIDTH)) priority_1(.input_value(input_val), .out(priority1));
decoder #(.INPUT_WIDTH(OUTPUT_WIDTH))decoder_stage(.input_val(priority1), .out(stage2_out));
priority_encoder#(.INPUT_WIDTH(INPUT_WIDTH)) priority_2(.input_value(stage2_xor_out), .out(priority2)); 

endmodule
