`timescale 1ns / 1ps

//Delayed edge deterctor debouncing circuit based on Moore machine
module db_fsm
(
    input logic clk, reset,
    input logic sw,
    output logic debounced_sw
);

//width of counter bits used to set approx 10ms tick
localparam N = 20; 

//fsm states
typedef enum {
    zero, wait1_1, wait1_2, wait1_3,
    one, wait0_1, wait0_2, wait0_3
    }state_type;
    
//Signal Declerations
state_type state_reg, state_next;
logic [N-1:0] tick_10ms_q, tick_10ms_next;
logic ms_tick;

/*********************************************
* Counter Logic
**********************************************/
always_ff @(posedge clk)
    tick_10ms_q <= tick_10ms_next;
    
assign tick_10ms_next = tick_10ms_q + 1;
assign ms_tick = (tick_10ms_q == 0) ? 1'b1 : 1'b0;

/***************************************************
* FSM Logic
****************************************************/

//State register 
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        state_reg <= zero;
    else
        state_reg <= state_next;
end

//next-state and output logic 
always_comb
begin
    state_next = state_reg;     //Default value does not change
    debounced_sw = 1'b0;        //Set default output
    //FSM:
    case(state_reg)
        zero:
            if(sw)
                state_next = wait1_1;
        wait1_1:
            if(!sw)
                state_next = zero;
            else
                if(ms_tick)
                    state_next = wait1_2;
        wait1_2:
            if(!sw)
                state_next = zero;
            else
                if(ms_tick)
                    state_next = wait1_3;
        wait1_3:
            if(!sw)
                state_next = zero;
            else
                if(ms_tick)
                    state_next = one;
        one:
        begin
            debounced_sw = 1'b1;
            if(!sw)
                state_next = wait0_1;
        end
        
        wait0_1:
        begin
            debounced_sw = 1'b1;
            if(sw)
                state_next = one;
            else
                if(ms_tick)
                    state_next = wait0_2;
        end
        
        wait0_2:
        begin
            debounced_sw = 1'b1;
            if(sw)
                state_next = one;
            else
                if(ms_tick)
                    state_next = wait0_3;
        end
        
        wait0_3:
        begin
            debounced_sw = 1'b1;
            if(sw)
                state_next = one;
            else
                if(ms_tick)
                    state_next = zero;
        end  
        
        default: state_next = zero;
    endcase          
end            
endmodule
