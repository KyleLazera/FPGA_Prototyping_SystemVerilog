`timescale 1ns / 1ps

/*This is implemented using a synchronout ROM*/
module sign_mag_rom
#(
    parameter DATA_WIDTH = 8,
    parameter OUTPUT_WIDTH = 4
)
(
    input logic clk,
    input logic [OUTPUT_WIDTH-1:0] input1, input2,
    output logic [OUTPUT_WIDTH-1:0] r_data
);

//Signal Declerations
logic [OUTPUT_WIDTH-1:0] rom [0:2**DATA_WIDTH-1];
logic [OUTPUT_WIDTH-1:0] data_out;
logic [DATA_WIDTH-1:0] r_addr;

//Read truth table generated from C file and save to ROM 
initial
    $readmemb("C:/Users/klaze/Desktop/C_Revision/sign_mag_tt.txt", rom);
    
always_ff @(posedge clk)
    data_out <= rom[r_addr];
    
assign r_addr = {input1, input2};
assign r_data = data_out;    


endmodule
