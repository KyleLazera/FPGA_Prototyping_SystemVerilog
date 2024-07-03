`timescale 1ns / 1ps

/*Register file for FIFO Buffer - to handle the 16 bit input, a multiplexer is used to determine
which bytes of the 16-bit input to load into the register
* This module is synthesized using registers. The introduction of the MUX means it no longer follows the inferred
* template of BRAM. Even after using synthesizer directives in the code, it did not infer a BRAM. Because of teh size of the
* FIFO however, I am okay wiht it being implemtned this way as it is not overly large.*/
module reg_file
#(
    DATA_WIDTH = 8,
    ADDRESS_WIDTH = 4
)
(
    input logic clk, reset,
    input logic wr_en,                                              //Write enable
    input logic [ADDRESS_WIDTH-1:0] r_addr, w_addr,               
    input logic [(2*DATA_WIDTH)-1:0] w_data,
    output logic [DATA_WIDTH-1:0] r_data
);

//Signal Decleration
logic [DATA_WIDTH-1:0] array_reg [0:(2**ADDRESS_WIDTH)-1];      //FIFO of length 16
logic [DATA_WIDTH-1:0] data_reg;
logic [DATA_WIDTH-1:0] w_data_8bits;
logic select_bits;                                          //Used to determine whether to write in most sig bit or least sig bit of input


always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            select_bits <= 1;
            data_reg <= 0;
            for(int i = 0; i < (2**ADDRESS_WIDTH); i++)
                array_reg[i] <= 0;
        end
    else
        begin
            if(wr_en)
                begin
                 array_reg[w_addr] = w_data_8bits;
                    select_bits <= ~select_bits;
                end    
            data_reg <= array_reg[r_addr];          
        end    
end

assign w_data_8bits = (select_bits) ? w_data[15:8] : w_data[7:0];
assign r_data = data_reg;

endmodule
