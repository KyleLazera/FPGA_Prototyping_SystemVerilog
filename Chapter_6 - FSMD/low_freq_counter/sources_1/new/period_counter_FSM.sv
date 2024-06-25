`timescale 1ns / 1ps

/*This is a period counter implemented using a finite state machine. It is used
* purely for comparison purposes with the period counter that is implemented using 
* sequential logic */
module period_counter_FSM
(
    input logic clk, reset,
    input logic start, edge_input,
    output logic ready, done_tick,
    output logic [9:0] prd
);

localparam CLK_US_COUNT = 100;      //1us counter
//FSM states
typedef enum {idle, waite, count, done} state_type;

//Signal Declerations
state_type state_reg, state_next;
logic [6:0] t_reg, t_next;
logic [9:0] p_reg, p_next;
logic delay_reg;
logic edg;

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= idle;
            t_reg <= 0;
            p_reg <= 0;
            delay_reg <= 0;
        end
    else
        begin
            state_reg <= state_next;
            t_reg <= t_next;
            p_reg <= p_next;
            delay_reg <= edge_input;
        end     
end

//Determine rising edge
assign edg = ~delay_reg & edge_input;

always_comb
begin
    //state_next = state_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    p_next = p_reg;
    t_next = t_reg;
    case(state_reg)
        idle:
            begin
                ready = 1'b1;
                if(start)
                    state_next = waite;
            end
        waite:
            begin
                if(edg)
                    begin
                        state_next = count;
                        t_next = 0;
                        p_next = 0;
                    end
            end                    
        count:
            begin
                if(edg)
                    state_next = done;
                else
                    if(t_reg == CLK_US_COUNT-1)
                        begin
                            t_next = 0;
                            p_next = p_reg + 1;
                        end
                    else
                        t_next = t_reg + 1;
            end              
        done:
            begin
                done_tick = 1'b1;
                state_next = idle;
            end            
        default: state_next = idle;
    endcase
end

assign prd = p_reg;

endmodule
