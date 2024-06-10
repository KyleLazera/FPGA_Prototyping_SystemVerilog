`timescale 1ns / 1ps

/************************************
* This module is used to debounce the incoming buttons pushes
*************************************/
module input_debounce
#(parameter TIMER_WIDTH = 21)       //bit width of the counter to achieve 20ms tick
(
    input logic clk, reset,
    input logic in,                 //Non debounced input
    output logic db_out             //Debounced output
);

//State types
typedef enum {zero, one, wait0_1, wait1_0} state_type;

//Signal Declerations
logic [TIMER_WIDTH-1:0] tick_q, tick_next;
logic tick_20ms;
state_type state_q, state_next;

/*********************************************
* Counter/Ticker Logic - Creates a 20ms ticker
**********************************************/
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        tick_q <= 0;
    else
        tick_q <= tick_next;
 end
 
 assign tick_next = tick_q + 1;
 assign tick_20ms = (tick_q == 0) ? 1'b1 : 1'b0;

/**********************************************
* State Machine Logic 
***********************************************/

//State register
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        state_q <= zero;
    else
        state_q <= state_next;
end

//Next state and output logic
always_comb
begin
    state_next = state_q;           //Default next value
    db_out = 1'b0;                  //Default output
    //FSM:
    case(state_q)
        zero:
            if(in)
                state_next = wait0_1;
            else
               state_next = state_q;
        one:
        begin
            db_out = 1'b1;
            if(~in)
                state_next = wait1_0;
            else
                state_next = state_q;
        end
        wait0_1:    
        begin
            db_out = 1'b1;
            if(tick_20ms)
                state_next = one;
            else
               state_next = state_q;
        end
        wait1_0:
            if(tick_20ms)
                state_next = zero;
            else
                state_next = state_q;
        default: state_next = zero;
    endcase        
end
endmodule
