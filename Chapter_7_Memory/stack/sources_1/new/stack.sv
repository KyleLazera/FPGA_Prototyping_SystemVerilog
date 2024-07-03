`timescale 1ns / 1ps

/*This is a basic stack with push and pop operations as well as full and empty flags.*/
module stack
#(
    DATA_WIDTH = 8,
    ADDRESS_WIDTH = 4
 )
 (
    input logic clk, reset,
    input logic push, pop,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic stack_full, stack_empty
);

//Signal Declerations
logic [DATA_WIDTH-1:0] stack_reg [0:(2**ADDRESS_WIDTH)-1];
logic [DATA_WIDTH-1:0] data_reg;
logic [ADDRESS_WIDTH:0] stck_ptr, stck_ptr_next;
logic stck_full_logic, stck_full_next, stck_empty_logic, stck_empty_next;

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            stck_ptr <= 0;
            stck_full_logic <= 0;
            stck_empty_logic <= 1;
            for(int i = 0; i < 2**ADDRESS_WIDTH; i++)
                stack_reg[i] <= 0;
        end
    else
        begin
            stck_ptr <= stck_ptr_next;
            stck_full_logic <= stck_full_next;
            stck_empty_logic <= stck_empty_next;
            
            if(push && !stck_full_logic)
                    stack_reg[stck_ptr] <= data_in;                          
            else if(pop && !stck_empty_logic)
                    data_reg <= stack_reg[stck_ptr-1];
        end        
end

always_comb
begin
    //Defualt values
    stck_ptr_next = stck_ptr;
    stck_full_next = stck_full_logic;
    stck_empty_next = stck_empty_logic;
    unique case ({push, pop})
        //Push
        2'b10:
            begin
                //Ensure the stack is not full before writing to it
                if(~stck_full_logic)
                    begin
                        stck_empty_next = 1'b0;
                        stck_ptr_next = stck_ptr + 1;
                        
                        //If current stck ptr is at 16, then set full flag & prevent incrementing pointer
                        if(stck_ptr_next == (2**ADDRESS_WIDTH))                                                  
                            stck_full_next = 1'b1;                   
                    end
            end                    
        //Pop
        2'b01:
            begin
                if(~stck_empty_logic)
                    begin
                        stck_full_next = 1'b0;
                        stck_ptr_next = stck_ptr - 1;
                        //If stack pointer is at 0, set emmpty flag and prevent decreasing address
                        if(stck_ptr_next == 0)
                            stck_empty_next = 1'b1;                               
                    end                       
            end 
        default: ; //Null statement 
    endcase
end

assign data_out = data_reg;
assign stack_full = stck_full_logic;
assign stack_empty = stck_empty_logic;

endmodule
