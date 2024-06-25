`timescale 1ns / 1ps

/*Used to develop a division circuit within logic*/
module division_circuit
#(BIT_WIDTH = 24)                                       //The highest possible frequency must be 9999Hz 
(
    input logic clk, reset,
    input logic start,                                  //Used to start/initialize the module
    input logic [BIT_WIDTH-1:0] dvsr,                   //Divisor input 
    input logic [(BIT_WIDTH*2)-1:0] dvnd,               //Dividend input
    output logic complete,                              //Flag indicating completion - Used for top level module
    output logic [BIT_WIDTH-1:0] quotient               //Final quotient
);

localparam index_width = $clog2(BIT_WIDTH+1);

//FSM state declerations
typedef enum {init, computation, done} state_type;

//Signal Declerations
state_type state_reg, state_next;
logic [BIT_WIDTH-1:0] quotient_reg, quotient_next;                              //FF used to avoid an inferred latch on output signal
logic [(BIT_WIDTH*2):0] div_reg, div_next;
logic [index_width-1:0] index_reg, index_next;
logic [BIT_WIDTH-1:0] temp_div;
logic q_bit;

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= init;
            index_reg <= 0;
            quotient_reg <= 0;
            div_reg <= 0;
        end
    else
        begin
            state_reg <= state_next;
            index_reg <= index_next;
            quotient_reg <= quotient_next;
            div_reg <= div_next;
        end        
end

always_comb
begin
    //Default asserts
    state_next = state_reg;
    index_next = index_reg;
    quotient_next = quotient_reg;
    div_next = div_reg;
    temp_div = 0;
    complete = 0;
    //FSM Control Logic:
    case(state_reg)
        init:
            begin
                if(start)
                    begin
                        index_next = BIT_WIDTH+1;
                        div_next = dvnd;
                        state_next = computation;
                    end
            end
        computation:
            begin
                if(div_reg[(BIT_WIDTH*2)-1:BIT_WIDTH] >= dvsr)
                    begin
                        temp_div = div_reg[(BIT_WIDTH*2):BIT_WIDTH] - dvsr;
                        q_bit = 1'b1;
                    end
                else
                    begin
                        temp_div = div_reg[(BIT_WIDTH*2):BIT_WIDTH];
                        q_bit = 1'b0;
                    end
                
                div_next = {temp_div[BIT_WIDTH-2:0], div_reg[BIT_WIDTH-1:0], q_bit};   
                
                if(index_reg == 0) 
                    begin
                        quotient_next = div_reg[BIT_WIDTH-1:0];
                        state_next = done;
                    end                        
                else
                    index_next = index_reg - 1;                                        
            end            
        done:
            begin
                complete = 1'b1;
                state_next = init;
            end
        default: state_next = init;        
    endcase
end

assign quotient = quotient_reg;

endmodule
