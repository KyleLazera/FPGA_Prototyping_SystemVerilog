`timescale 1ns / 1ps


module fifo_tb;
//Declare variables
localparam DATA_WIDTH = 8;
localparam ADDRESS_WIDTH = 4;
localparam T = 10;

//Signal Declerations
logic clk, reset;
logic write, read;
logic [DATA_WIDTH-1:0] w_data, r_data;
logic [ADDRESS_WIDTH:0] word_count;
logic almost_full, almost_empty;
logic full_flag, empty_flag;

//Module inst.
fifo#(.DATA_WIDTH(DATA_WIDTH), .ADDRESS_WIDTH(4)) uut(.*);

//Init clock
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

//Reset Circuit
initial begin
    reset = 1'b1;
    #(T*2);
    reset = 1'b0;
end

//Task used to write data
task write_data(input logic[(2*DATA_WIDTH)-1:0] data);
    begin
        w_data = data;
        write = 1'b1;
        #(T);            
        write = 1'b0;
        #T;
    end
endtask

/* Testing values: There are a few things this tets bench checks for in terms of operation of the FIFO:
* 1) Can the FIFO read in 16-bit pieces of data into 2 bytes in the FIFO.
* 2) Can teh FIFO read 8 bits for each read 
* 3) Does teh full flag set correctly & can I write when flag is set
* 4) Does the Empty flag set correctly & can I read when flag is set*/
initial begin
    //Initially set both read and write bits to 0
    read = 1'b0;
    write = 1'b0;
    #(T*2);
    //Start by writing in 8 values to the FIFO
    write_data(8'd46);
    write_data(8'd45);
    write_data(8'd108);
    write_data(8'd24);
    write_data(8'd1);
    write_data(8'd213);
    write_data(8'd176);
    write_data(8'd29);
    write_data(8'd90);
    //Read from the FIFO 2 times
    read = 1'b1;
    #(T*2);
    read = 1'b0;
    
    #(T*2);
    //Read followed by write x 3
    write_data(8'd2);
    read = 1'b1;
    #(T);
    read = 1'b0;    
    write_data(8'd3);
    read = 1'b1;
    #(T);
    read = 1'b0;    
    write_data(8'd4);
    read = 1'b1;
    #(T);
    read = 1'b0;                
    
    //Begin adding values until the FIFO full flag is raised
    while(!full_flag)
            write_data(8'd40);
            
    //After full flag is set try to write another value
    write_data(8'd189);    
        
    //read from the Buffer until teh empty flag is raised
    while(!empty_flag)
        begin
            read = 1'b1;
            #(T);
            read = 1'b0; 
            #(T);       
        end
    
    //After FIFO is empty, try read from the buffer again
    read = 1'b1;
    #(T);
    read = 1'b0;
        
    $finish;
end
endmodule
