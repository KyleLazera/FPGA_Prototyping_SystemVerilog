`timescale 1ns / 1ps

/*This is going to be the FIFO wrapper that converts the standard FIFO into a FWFT FIFO*/
module fwft_fifo
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

//Module Instantiation of Standard FIFO
standard_fifo fifio_unit(.*, .fifo_rd_en(fifo_std_rd), .fifo_empty(fifo_std_empty));

//Signal Decleration
logic data_available, fifo_std_rd, fifo_std_empty;         

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        data_available <= 0;
    else
        begin
            //If fifo read is asserted then there is data available so empty must be 0
            if(fifo_std_rd)
                data_available <= 1;
            else if(fifo_rd_en)
                data_available <= 0;
        end
end     

//We will assert fifo read if original fifo is not empty and there is either no data in the output reg or a read signal is asserted
assign fifo_std_rd = !fifo_std_empty && (!data_available || fifo_rd_en);
//if there is no data available in the out register then the FIFO must be empty
assign fifo_empty = !data_available;

endmodule
