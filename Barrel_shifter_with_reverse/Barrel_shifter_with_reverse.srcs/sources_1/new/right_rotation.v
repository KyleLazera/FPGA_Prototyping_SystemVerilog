`timescale 1ns / 1ps

module right_rotation
#(parameter INPUT_WIDTH, parameter SHIFT_WIDTH)       
(
    input logic [INPUT_WIDTH-1:0] input_value,
    input logic [SHIFT_WIDTH-1:0] amt,
    output logic [INPUT_WIDTH-1:0] out
);

logic [INPUT_WIDTH-1:0] stage[SHIFT_WIDTH:0];

genvar i;
generate

    assign stage[0] = input_value;

    for(i = 0; i < SHIFT_WIDTH; i++)
    begin:Mux2_to_1
        always_comb
        begin   
            localparam int temp = 2**i;
            stage[i+1] = amt[i] ? {stage[i][temp-1:0], stage[i][INPUT_WIDTH-1:temp]} : stage[i];
        end
    end

endgenerate

assign out = stage[SHIFT_WIDTH];

endmodule
