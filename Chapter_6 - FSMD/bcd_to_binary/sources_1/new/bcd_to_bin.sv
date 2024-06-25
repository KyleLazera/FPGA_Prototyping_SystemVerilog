`timescale 1ns / 1ps

//This module uses a BCD shift register to convert an 8-bit BCD (2 decimal digits) into 
// a 7 bit binary value - This was specified by the assignment
module bcd_to_bin
(
    input logic clk, reset,
    input logic load,                                   //Input used to load the bcd value inot the circuit                          
    input logic [3:0] bcd_value[1:0],                   //BCD input value (limited to 2 BCD digits in this project)
    output logic done_tick, ready,                      //output flag indicating completion
    output logic [7:0] binary_value                     //Output binary value
);

//FSM States
typedef enum {idle, comp, done} state_type;

//Signal Declerations
state_type state_reg, state_next;
logic [3:0] bcd_reg [1:0];                              //BCD shift registers                         
logic [3:0] bcd_next [1:0];
logic [3:0] bcd_temp [1:0];                             //used to compute new bcd values
logic [3:0] index_reg, index_next;                      //Index register
logic [7:0] bin_reg, bin_next;                          //Signal that holds binary value

//State and data registers
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= idle;
            bcd_reg[0] <= 0;
            bcd_reg[1] <= 0;
            index_reg <= 0;
            bin_reg <= 0;
        end
    else
        begin
            state_reg <= state_next;
            bcd_reg[0] <= bcd_next[0];
            bcd_reg[1] <= bcd_next[1];
            index_reg <= index_next;
            bin_reg <= bin_next;
        end                         
end

always_comb
begin
    //Assign default values to registers and signals 
    state_next = state_reg;
    bcd_next[0] = bcd_reg[0];
    bcd_next[1] = bcd_reg[1];
    index_next = index_reg;
    bin_next = bin_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    //FSM Logic:
    case(state_reg)
        idle:
            begin
                ready = 1'b1;
                if(load)
                begin
                    //Upon loading values immediately shift 1 value to the right
                    bcd_next[0] = {bcd_value[1][0], bcd_value[0][3:1]};
                    bcd_next[1] = bcd_value[1] >> 1;
                    bin_next = {bcd_value[0][0], bin_next[7:1]};
                    index_next = 4'b0111;               //in this case the index is limited to 7
                    state_next = comp;
                end    
            end
        comp:
            begin
                //Shift bcd values to the right and push first value into binary reg
                bcd_next[0] = {bcd_temp[1][0], bcd_temp[0][3:1]};
                bcd_next[1] = bcd_temp[1] >> 1;
                bin_next = {bcd_temp[0], bin_next[7:1]};
                //Decrement index
                index_next = index_reg - 1;
                if(index_reg == 1)
                    state_next = done;
            end
        done:
            begin
                done_tick = 1'b1;
                state_next = idle;
            end       
        default: state_next = idle;
    endcase
    
    
end

//If one of the bcd shift register vals is greater than 4, subtract 3
assign bcd_temp[0] = (bcd_reg[0] > 4) ? bcd_reg[0] - 3 : bcd_reg[0];
assign bcd_temp[1] = (bcd_reg[1] > 4) ? bcd_reg[1] - 3 : bcd_reg[1];

assign binary_value = bin_reg;

endmodule
