`timescale 1ns / 1ps

//Dual edge detector based on Mealy machine
module dual_edge_mealy
(
    input logic clk, reset,
    input logic in,
    output logic edge_detector
);

//FSm States
typedef enum {zero, one} state_type;

//Signal Declerations
state_type state_reg, state_next;

//State Register
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        state_reg <= zero;
    else
        state_reg <= state_next;
end

//Next state and output logic
always_comb
begin
    state_next = state_reg;        
    edge_detector = 1'b0;           //Default value for edge detector is 0
    //FSM
    case(state_reg)
        zero:
        begin
            if(in)
            begin
                edge_detector = 1'b1;
                state_next = one;
            end
            else
               state_next = zero;
        end
        
        one:
        begin
            if(~in)
            begin
                edge_detector = 1'b1;
                state_next = zero;
            end
            else
                state_next = one;
        end
        default: state_next = zero;
    endcase 
end
endmodule
