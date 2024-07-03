`timescale 1ns / 1ps

/*This FIFO module is similar tot he extended FIFO, however, it has the same data width input and output value, and there
* are 3 new output flags added to the FIFO. This FIFO includes a word count flag, indicating to the user the number of words 
* present in the FIFO, an almost_full and an almost_empty flag whichi indicate the FIFO is either below 25% capacity, or above 75%
* capacity.*/
module fifo
#(
    DATA_WIDTH = 8,
    ADDRESS_WIDTH = 4
)
(
    input logic clk, reset,
    input logic write, read,
    input logic [DATA_WIDTH-1:0] w_data,
    output logic [DATA_WIDTH-1:0] r_data,
    output logic [ADDRESS_WIDTH:0] word_count,
    output logic almost_empty, almost_full,
    output logic full_flag, empty_flag
);

//Signal Decleration
logic [ADDRESS_WIDTH-1:0] r_addr, w_addr;
logic wr_enable, full_tmp;

/*********Module Connections ***********/
//Writing is only enabled if buffer is not full and write enable is high
assign wr_enable = write & ~full_temp;
assign full_temp = full_flag;

/******Module Instantiation*******/
//Instantiate FIFO Controller
fifo_controller#(.ADDRESS_WIDTH(ADDRESS_WIDTH)) fifo_control_unit(.*, .empty(empty_flag), .full(full_flag), .r_addr(r_addr), .w_addr(w_addr));

//Instantiate FIFO reg file
reg_file#(.DATA_WIDTH(DATA_WIDTH), .ADDRESS_WIDTH(ADDRESS_WIDTH)) fifo_reg_unit(.*, .wr_en(wr_enable), .r_addr(r_addr), .w_addr(w_addr));
endmodule
