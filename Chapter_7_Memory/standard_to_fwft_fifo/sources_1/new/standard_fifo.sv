`timescale 1ns / 1ps

/*This module is a Standard FIFO generated from the FIFO IP Core. The FIFO has an 8-bit data
* width and 16 word depth*/
module standard_fifo
(
    input logic clk,
    input logic reset,
    input logic [7:0] fifo_din,
    input logic fifo_wr_en,
    input logic fifo_rd_en,
    output logic [7:0] fifo_dout,
    output logic fifo_full,
    output logic fifo_empty
);

// FIFO IP Core module instantiation
fifo_generator_0 fifo_inst (
    .clk(clk),
    .srst(reset),
    .din(fifo_din),
    .wr_en(fifo_wr_en),
    .rd_en(fifo_rd_en),
    .dout(fifo_dout),
    .full(fifo_full),
    .empty(fifo_empty)
);

endmodule
