`timescale 1ns / 1ps

/*This is an early detection debouncing circuit (similar to the project from chapter 5), however, 
* it is implemented using RT methodolgy*/
module early_detect_debounce
#(parameter COUNTER_WIDTH = 21) 
(
    input logic clk, reset,
    input logic in,                     //Input signal (to be debounced)
    output logic out                 //Debounced signal
);

localparam TIMER_VALUE = 2000000;      //Value used to create 20ms timer 

//FSM State Type
typedef enum {zero, wait0_1, one, wait1_0}state_type;

//Signal Declerations
state_type state_reg, state_next;
logic [COUNTER_WIDTH-1:0] counter_reg, counter_next;
logic redge_reg, fedge_reg;                                     //Registers to hold the input values 
logic edge_reg;                                                //Registers to determine rising or falling edge
logic db_out;

always_ff @(posedge clk, posedge reset)
begin
    if(reset) 
        begin
            state_reg <= zero;
            counter_reg <= 0;
            redge_reg <= 0;
            fedge_reg <= 0;
        end
    
    else
        begin
            state_reg <= state_next;
            counter_reg <= counter_next;
            edge_reg <= in;
        end
end

//Detect rising edge:
assign r_edge = ~edge_reg & in;
//Detect falling edge:
assign f_edge = edge_reg & ~in;

//Next State Logic
always_comb
    begin
        state_next = state_reg;
        counter_next = counter_reg;
        db_out = 1'b0;          //Default output
        //Control logic (FSM):
        case(state_reg)
        zero:
            if(r_edge)
                state_next = wait0_1;
        wait0_1:
            begin
                db_out = 1'b1;
                if(counter_reg == TIMER_VALUE-1)
                begin
                    counter_next = 0;
                    state_next = one;
                end
                else
                    counter_next = counter_reg + 1;
            end
        one:
            begin
                db_out = 1'b1;
                if(f_edge)
                    state_next = wait1_0;
            end       
        wait1_0:
            begin
                if(counter_reg == TIMER_VALUE-1)
                begin
                    counter_next = 0;
                    state_next = zero;
                end
                else
                    counter_next = counter_reg + 1;
            end
       default: state_next = zero;
       endcase
    end      

//Output logic
assign out = db_out;

endmodule
