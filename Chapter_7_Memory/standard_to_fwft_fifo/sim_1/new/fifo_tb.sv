`timescale 1ns / 1ps

/*This tb is used to test teh FWFT FIFO. The maibn difference should be that in teh standard FIFO we do not get 
* an output until we enable teh read_flag. However, in the FWFT, as soon as as value is inserted into the FIFO,
* the value is available. The read value simply "removes" this value rather than makes it available*/
module fifo_tb;

//Local variables 
localparam T = 10;

//Signals
logic clk, reset;
logic [7:0] fifo_din;
logic fifo_wr_en, fifo_rd_en;
logic [7:0] fifo_dout;
logic fifo_full, fifo_empty;

//Module Instantiation
fwft_fifo uut(.*);

//Init Clock and reset values
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

initial begin
    reset = 1'b1;
    #(T*2);
    reset = 1'b0;
end

//Task used to write data
task write_data(input logic[7:0] data);
    begin
        fifo_din = data;
        fifo_wr_en = 1'b1;
        #(T);             
        fifo_wr_en = 1'b0;
        #T;
    end
endtask

//Task used to write data
task read_data();
    begin
        fifo_rd_en = 1'b1;
        #(T);             
        fifo_rd_en = 1'b0;
        #T;
    end
endtask

//Init values
initial begin
    //Set initial values to 0 and wait for circuit to init
    fifo_wr_en = 0;
    fifo_rd_en = 0;
    #(T*10);
    
    //Write in a few values
    write_data(8'd20);
    write_data(8'd76);
    write_data(8'd34);
    
    //Read a few values
    read_data();
    read_data();
    
    $finish;
    
end

endmodule
