`timescale 1ns / 1ps

module circuit_inverter
#(parameter INPUT_WIDTH)
(
    input logic [INPUT_WIDTH-1:0] input_value,
    input logic rot_dir,                                //Indicates direction of rotation - whether to invert input or not
    output logic [INPUT_WIDTH-1:0] out
);

logic [INPUT_WIDTH-1:0] temp_var, final_temp;                       //Used to store the temporary variable during inversion

generate
    genvar i;
    always_comb
    begin
    
        if(rot_dir)
        begin
            temp_var = input_value;
        
            for(int i = 0; i < INPUT_WIDTH; i++)
            begin
            out[i] = temp_var[INPUT_WIDTH - 1 - i];      //Invert the circuit
            end     

        end
        else
            out = input_value;
    end
endgenerate


endmodule
