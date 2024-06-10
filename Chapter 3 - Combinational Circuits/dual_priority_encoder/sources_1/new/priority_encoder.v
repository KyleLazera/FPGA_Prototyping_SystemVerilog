`timescale 1ns / 1ps

//Parameterized Priority Encoder
module priority_encoder
#(parameter INPUT_WIDTH, parameter OUTPUT_WIDTH = $clog2(INPUT_WIDTH))
(
        input logic [INPUT_WIDTH-1:0] input_value,
        output logic [OUTPUT_WIDTH-1:0] out
);

always_comb
begin

logic msb;

out = 'x;
msb = 0;

for(int i = INPUT_WIDTH; i >= 0; i--)
begin
        if(!msb && input_value[i])
        begin
            out = i;
            msb = 1;
        end

end
end

//This is a priority encoder implemented in a different way 
/*logic [INPUT_WIDTH-1:0] temp_input;
int width;

always_comb
begin

    out = 1'b0;
    temp_input = input_value;

    for(int i = OUTPUT_WIDTH-1; i >= 0; i--)
    begin
    
    width = 1 << i;                         //Used to determine half the width of input value (i.e input width = 8, output width = 3, 1 << 3 = 4)
    
    if(|(temp_input >> width))
        out[i] = 1;
        
    temp_input = out[i] ? temp_input >> width : temp_input & ((1'b1 << width) - 1'b1);
    
    end
end*/
endmodule

module decoder
#(parameter INPUT_WIDTH, OUTPUT_WIDTH = 2**INPUT_WIDTH)
(
    input logic [INPUT_WIDTH-1:0] input_val,
    output logic [OUTPUT_WIDTH-1:0] out
);

assign out = 1'b1 << input_val;

endmodule
