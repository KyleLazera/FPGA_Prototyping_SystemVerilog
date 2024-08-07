`timescale 1ns / 1ps

/* The goal of this module is to simply provide a ROM based temperature conversion from celcius to farenheit
* or vice versa based on the "factor" bit. There are many different desing implementations to be taken into consideration:
* 1) 2 ROM's with the celcius to farenheit conversion using a -32 to get the correct address of the ROM
            Example: input = 32 (farenheit) -> correct address is at 0x00 therefore in ROM r_addr = (input - 32)
     This adds unnecessary logic for the subtraction but allows for an easy implementation
  2) Using case statements - This removes teh unnecessary arithmetic logic for the addressing but also 
     makes the design asynchrnous and adds a delay from the multiplexer that will be geometrically, very large
*/
module temp_conversion_rom
#(DATA_WIDTH = 8)
(
    input logic clk, 
    input logic format,                             //1 indicates C to F and 0 indicates F to C
    input logic [DATA_WIDTH-1:0] temp_input,
    output logic [DATA_WIDTH-1:0] temp_out
);

localparam celcius_range = 101;         //Celcius temperatures can only span from 0 to 100 (101 values total)
localparam farenheit_range = 181;       //(212 - 32) the range is 180 (181 total)


/*****Signal Declerations*******/
//This ROM holds farenheit values for each celcius input
logic [DATA_WIDTH-1:0] farenheit_rom [celcius_range-1:0];
//This ROM holds celcius values for each farenheit input
logic [DATA_WIDTH-1:0] celcius_rom [farenheit_range-1:0];
logic [DATA_WIDTH-1:0] data_reg;

initial begin
    //Read all LUT values from file - generated by C code
    $readmemb("C_to_F_conversion.txt", farenheit_rom);
    $readmemb("F_to_C_conversion.txt", celcius_rom);
end

always_ff @(posedge clk)
begin
    if(format)
    //Ensure the input values are within range or else FF is given as output (invalid)
        data_reg <= (temp_input < 0 || temp_input > 100) ? 8'hFF : farenheit_rom[temp_input];
    else
        data_reg <= (temp_input < 32 || temp_input > 212) ? 8'hFF : celcius_rom[temp_input - 8'd32]; 
end

assign temp_out = data_reg;

endmodule
