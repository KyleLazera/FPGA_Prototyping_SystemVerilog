`timescale 1ns / 1ps

/*This module wraps teh FIFO Controller and reg file into one module to make a complete FIFO
* implemented as a circular queue.
* In this FIFO, the write input must be 16 bits and the read input must be 8 bits. Additionally,
* there is First word fall through in this FIFO*/
module fifio_wrapper
#(
    DATA_WIDTH = 8,
    ADDRESS_WIDTH = 4
)
(
    input logic clk, reset,
    input logic write, read,
    input logic [(2*DATA_WIDTH)-1:0] w_data,
    output logic [DATA_WIDTH-1:0] r_data,
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
