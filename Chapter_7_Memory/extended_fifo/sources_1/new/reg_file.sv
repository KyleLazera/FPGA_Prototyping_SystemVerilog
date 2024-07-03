`timescale 1ns / 1ps

module reg_file
#(
    DATA_WIDTH = 8,
    ADDRESS_WIDTH = 4
)
(
    input logic clk, reset,
    input logic wr_en,                                              //Write enable
    input logic [ADDRESS_WIDTH-1:0] r_addr, w_addr,               
    input logic [DATA_WIDTH-1:0] w_data,
    output logic [DATA_WIDTH-1:0] r_data
);

//Signal Decleration
logic [DATA_WIDTH-1:0] array_reg [0:(2**ADDRESS_WIDTH)-1];      //FIFO of length 16
logic [DATA_WIDTH-1:0] data_reg;


always_ff @(posedge clk, posedge reset)
begin
    if(wr_en)
        array_reg[w_addr] = w_data;    
        
    data_reg <= array_reg[r_addr];             
end

assign r_data = data_reg;
endmodule
