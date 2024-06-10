`timescale 1ns / 1ps

/*****************************************
* This is a FSM that is used to determine whether or not a car has entered or left a 
* parking lot based on two "photosensors" (a and b). The following pattern determines whether a car
* has entered or left:
* Entered: first a = 1, then both a and b are 1, then a = 0 while b = 1, then a = 0 and b = 0.
* Left: first b = 1 while a  = 0, then both are 1, then b = 0 and a = 1, then both are 0
******************************************/
module parking_occupancy_FSM
(
    input logic clk, reset,
    input logic a, b,                   //These represent the 2 photoresistors
    output logic enter, exit            //Represent whether a car has entered ot left
);

typedef enum{zero,                      //Represent state whne both photoresistors are one (a = 0, b = 0) 
            a_block,                    //photoresistor a is blocked (high) 
            b_block,                    //photoresistor b is blocked (high)
            ab_block,                   //Both a and b are blocked (a was blocked first then b was blocked)
            ba_block,                   //Both b and a are blocked (b was blocked first then a was blocked)
            car_entering,               //Both a and b were blocked, but now only b is blocked
            car_exiting,                //Both a and b were blocked, but now only a is blocked
            car_entered,                //A car folllowed the pattern for a car to enter (as stated above)
            car_exited                  //A car followed the pattern to exit (as stated above)
            } state_type;
            
//Signal Declerations
state_type state_q, state_next;

//State shift register
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        state_q <= zero;
    else
        state_q <= state_next;
end

//Next State logic and output logic 
always_comb
begin
    state_next = state_q;           //Default
    exit = 1'b0;                    //Set defualt values
    enter = 1'b0;                   //Set default values
    //FSM State logic:
    case(state_q)
        zero:
        begin
            if(a & ~b)                      
                state_next = a_block;
            else if(~a & b)
                state_next = b_block;
            else
                state_next = state_q; 
        end
        
        a_block:
        begin
            if(a & b)
                state_next = ab_block;
            else if (~a & ~b)
                state_next = zero;
            else if (~a & b)
                state_next = b_block;
            else
                state_next = state_q;
        end
        
        b_block:
        begin
            if(a & b)
                state_next = ba_block;
            else if (a & ~b)
                state_next = a_block;
            else if (~a & ~b)
                state_next = zero;
            else
                state_next = state_q;
        end
        
        ab_block:
        begin
            if(~a & b)
                state_next = car_entering;
            else if (a & b)
                state_next = ab_block;
            else if (a & ~b)
                state_next = a_block;
            else
                state_next = zero;
        end
        
        ba_block:
        begin
            if(a & ~b)
                state_next = car_exiting;
            else if(a & b)
                state_next = state_q;
            else if (~a & b)
                state_next = b_block;
            else
                state_next = zero;
        end
        
        car_exiting:
        begin
            if(~a & ~b)
                state_next = car_exited;
            else if(a & ~b)
                state_next = state_q;
            else if(a & b)
                state_next = ba_block;
            else
                state_next = zero;
        end
        
        car_entering:
        begin
            if(~a & ~b)
                state_next = car_entered;
            else if(a & b)
                state_next = ab_block;
            else if(~a & b)
                state_next = state_q;
            else
                state_next = zero;             
        end
        
        car_exited:
        begin
            exit = 1'b1;
            state_next = zero;
        end
        
        car_entered:
        begin
            enter = 1'b1;
            state_next = zero;
        end
    endcase
end
endmodule
