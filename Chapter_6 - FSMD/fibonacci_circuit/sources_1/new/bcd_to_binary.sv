`timescale 1ns / 1ps

/* This module is used to convert the BCD input value into a binary input value*/
module bcd_to_binary
(
    input logic clk, reset, start,
    //input logic [3:0] index,                                                     //Specifies the number of times the shift reg iterates
    input logic [3:0] bcd_in[1:0],  
    output logic done,                                                          //used to indicate the completion of the conversion
    output logic [7:0] binary_out                              
);

//Signal Decleration
logic [3:0] bcd_shift_reg [1:0], bcd_shift_next[1:0];                           //BCD shift registers used to convert to binary
logic [3:0] index_reg, index_next;
logic [7:0] binary_out_reg, binary_out_next;
logic [3:0] bcd_temp [1:0];
logic init;                                                                     //Flag used to initialize the registers


always_ff @(posedge clk, posedge reset, posedge start)
begin
    if(reset)
        begin
            index_reg <= 0;
            bcd_shift_reg[0] <= 0;
            bcd_shift_reg[1] <= 0;
            binary_out_reg <= 0;
            init <= 1'b1;
        end
    //If thst start bit is high and the initialization flag is high, load values into the shift resgiters
    else if(start && init)
        begin
            index_reg <= 4'b1000;                                               //Set index to 7
            bcd_shift_reg[0] <= {bcd_in[1][0], bcd_in[0][3:1]};                 //Shift the first values into register
            bcd_shift_reg[1] <= bcd_in[1] >> 1;
            binary_out_reg <= {bcd_in[0][0], 7'b0};                         
            init <= 1'b0;                                                       //Set initialize flag low
        end
    else 
        begin
            bcd_shift_reg <= bcd_shift_next;
            index_reg <= index_next;
            binary_out_reg <= binary_out_next;
        end
end     

assign index_next = (!done) ? index_reg - 1 : index_reg;
assign bcd_temp[0] = (bcd_shift_reg[0] > 4) ? (bcd_shift_reg[0] - 3) : bcd_shift_reg[0];
assign bcd_temp[1] = (bcd_shift_reg[1] > 4) ? (bcd_shift_reg[1] - 3) : bcd_shift_reg[1];

assign bcd_shift_next[0] = (index_reg != 1) ? {bcd_temp[1][0], bcd_temp[0][3:1]} : bcd_shift_reg[0];
assign bcd_shift_next[1] = (index_reg != 1) ? bcd_temp[1] >> 1 : bcd_shift_reg[1];
assign binary_out_next = (index_reg != 1) ? {bcd_temp[0][0], binary_out_reg[7:1]} : binary_out_reg; 

assign done = (index_reg == 0) ? 1'b1 : 1'b0;
assign binary_out = binary_out_reg;

endmodule
