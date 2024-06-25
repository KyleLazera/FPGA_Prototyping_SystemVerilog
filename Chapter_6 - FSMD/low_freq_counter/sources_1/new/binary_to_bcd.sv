`timescale 1ns / 1ps

/*This module converts binary values into BCD while also autoscaling the value to ensure only the
* 4 most significant bits are being displayed*/
module binary_to_bcd
#(BINARY_WIDTH = 24)
(
    input logic clk, reset,
    input logic start,
    input logic  [BINARY_WIDTH-1:0] binary_input,
    output logic [3:0] bcd_out [3:0],
    output logic [2:0] autoscale_shifts,                                  //Counts how many times the value was shifted so most sig digit is not 0                                       
    output logic done_flag
);

localparam INDEX_WIDTH = $clog2(BINARY_WIDTH+1);
genvar i;

//Declare FSM states
typedef enum {init, conversion, autoscale, done} state_type;

//Signal Declerations
state_type state_reg, state_next;
logic [3:0] bcd_shift_reg [7:0], bcd_shift_next[7:0];       //Using 8 bcd_shift regs because of diviosn by 1000000000 (to increase accuracy)
logic [BINARY_WIDTH-1:0] bin_shift_reg, bin_shift_next;
logic [INDEX_WIDTH-1:0] index_reg, index_next;
logic [3:0] tmp_bcd [7:0];
logic [3:0] num_shift_reg, num_shift_next;                        //Holds the number of shifts to autoscale the value

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= init;
            bin_shift_reg <= 0;
            index_reg <= 0;
            num_shift_reg <= 0;
            for(int i = 0; i < 8; i++)
                bcd_shift_reg[i] <= 0;
        end
    else
        begin
            state_reg <= state_next;
            bin_shift_reg <= bin_shift_next;
            bcd_shift_reg <= bcd_shift_next;
            index_reg <= index_next;
            num_shift_reg <= num_shift_next;
        end        
end

always_comb
begin
    //Set default values
    state_next = state_reg;
    bcd_shift_next = bcd_shift_reg;
    bin_shift_next = bin_shift_reg;
    index_next = index_reg;
    num_shift_next = num_shift_reg;
    done_flag = 1'b0;
    //Control Logic (FSM)
    case(state_reg)
        init:
            begin
                if(start)
                    begin
                        bin_shift_next = binary_input;
                        for(int i = 0; i < 8; i++)
                            bcd_shift_next[i] = 0;
                        index_next = BINARY_WIDTH;
                        num_shift_next = 0;
                        state_next = conversion;
                    end
            end
        conversion:
            begin
                //Rotate shift registers to the left
                bcd_shift_next[0] = {tmp_bcd[0][2:0], bin_shift_reg[BINARY_WIDTH-1]};
                for(int i = 1; i < 8 ; i++)
                    bcd_shift_next[i] = {tmp_bcd[i][2:0], tmp_bcd[i-1][3]};
                                                 
                bin_shift_next = bin_shift_reg << 1;
                
                if(index_reg == 1)
                    state_next = autoscale;
                else
                    index_next = index_reg - 1;
            end 
        autoscale:
            begin
                //Check if left most BCD is 0
                if(bcd_shift_reg[7] == 0)       
                    begin
                        //Shift all BCD digits to the left
                        for(int i = 7; i > 0; i--)
                            bcd_shift_next[i] = bcd_shift_next[i-1];
                        //Increment number of shifts
                        num_shift_next = num_shift_reg + 1; 
                    end
                 else
                    state_next = done;
            end  
        done:
            begin
                done_flag = 1'b1;
                state_next = init;
            end   
        default: state_next = init;                  
    endcase
end

always_comb begin
    for (int i = 0; i < 8; i++) begin
        tmp_bcd[i] = (bcd_shift_reg[i] > 4) ? bcd_shift_reg[i] + 3 : bcd_shift_reg[i];
    end
end

assign bcd_out = bcd_shift_reg[7:4];
assign autoscale_shifts = num_shift_reg;

endmodule
