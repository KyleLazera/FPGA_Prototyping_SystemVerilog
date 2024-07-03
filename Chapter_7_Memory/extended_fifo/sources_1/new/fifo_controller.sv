`timescale 1ns / 1ps

module fifo_controller
#(ADDRESS_WIDTH = 4)
(
    input logic clk, reset,
    input logic write, read,
    output logic full, empty,
    output logic [ADDRESS_WIDTH-1:0] r_addr, w_addr, 
    output logic [ADDRESS_WIDTH:0] word_count,
    output logic almost_empty, almost_full
);

//Local variables
localparam ALMOST_EMPTY_VAL = (2**ADDRESS_WIDTH)*0.25;
localparam ALMOST_FULL_VAL = (2**ADDRESS_WIDTH)*0.75;

/***************Signal Declerations************************/
//Address pointer registers
logic [ADDRESS_WIDTH-1:0] wr_ptr, wr_ptr_next, wr_ptr_succ;
logic [ADDRESS_WIDTH-1:0] r_ptr, r_ptr_next, r_ptr_succ;
//Output flag registers
logic [ADDRESS_WIDTH:0] word_count_reg, word_count_next;
logic full_logic, full_next, empty_logic, empty_next;
logic almost_full_logic, almost_full_next, almost_empty_logic, almost_empty_next;

//used to set the read and write pointers as well as clk and reset
always_ff @(posedge clk, posedge reset)
begin
    //When reset is high set empty flag and clear full flag 
    if(reset)
        begin
            wr_ptr <= 0;
            r_ptr <= 0;
            word_count_reg <= 0;
            full_logic <= 0;
            almost_full_logic <= 0;
            empty_logic <= 1;
            almost_empty_logic <= 1;           
        end
    else
        begin
            wr_ptr <= wr_ptr_next;
            r_ptr <= r_ptr_next;
            word_count_reg <= word_count_next;
            full_logic <= full_next;
            almost_full_logic <= almost_full_next;
            empty_logic <= empty_next;
            almost_empty_logic <= almost_empty_next;
        end
end

//Next state logic for read and write pointer and empty and full flags
always_comb
begin
    //Get the next or sucessive address for the pointer by incrementing current address
    wr_ptr_succ = wr_ptr + 1;       
    r_ptr_succ = r_ptr + 1;
    //Set the remaining "next" values to default
    wr_ptr_next = wr_ptr;
    r_ptr_next = r_ptr;
    word_count_next = word_count_reg;
    full_next = full_logic;
    almost_full_next = almost_full_logic;
    empty_next = empty_logic;
    almost_empty_next = almost_empty_logic;
    unique case ({write, read})
        //Read logic 
        2'b01:
            begin
                if(~empty_logic)                            //Check if FIFO is empty first
                    begin
                        r_ptr_next = r_ptr_succ;            //Incremented pointer
                        full_next = 1'b0;                   //make sure full flag is not raised
                        word_count_next--;                  //Decrement the number of words in the FIFO after a read
                        
                        if(word_count_next <= ALMOST_EMPTY_VAL)
                            almost_empty_next = 1'b1;
                        
                        if(word_count_next < ALMOST_FULL_VAL)
                            almost_full_next = 1'b0;
                            
                        if(r_ptr_succ == wr_ptr)            //Set empty flag if next read pointer is same as write pointer
                            empty_next = 1'b1;
                    end
            end
        //Write logic
        2'b10:       
            begin
                if(~full_logic)                             //before writing check if FIFO is full
                    begin
                        wr_ptr_next = wr_ptr_succ;
                        empty_next = 1'b0;                  //Make sure empty flag is not set after write
                        word_count_next++;                  //Increment the word_count reg after a succesful write
                        
                        if(word_count_next > ALMOST_EMPTY_VAL)
                            almost_empty_next = 1'b0;
                        
                        if(word_count_next >= ALMOST_FULL_VAL)
                            almost_full_next = 1'b1;
                        
                        if(wr_ptr_succ == r_ptr)            //If write pointer has caught read pointer set full flag
                            full_next = 1'b1;
                    end
            end
        //Both read and write operations
        2'b11:
            begin
                wr_ptr_next = wr_ptr_succ;
                r_ptr_next = r_ptr_succ;
            end              
    endcase
end

//output logic 
assign r_addr = r_ptr;
assign w_addr = wr_ptr;
assign word_count = word_count_reg;

assign full = full_logic;
assign empty = empty_logic;
assign almost_full = almost_full_logic;
assign almost_empty = almost_empty_logic;

endmodule