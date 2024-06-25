`timescale 1ns / 1ps

/*
 * This version of the babbage engine is modified to support larger degree polynomials. In this implementation, each phase is broken down into a seperate clokc cycle.
 * This makes the overall time it takes to compute the outcome longer, however, it allows for larger poynomials to be used. Despite increasing the degree of the polynomial,
 * the WNS will not increase because the FF's are used to seperate each compution. This is not the case for the original babbage engine. 
 *
 * A timing comparison for this module compared to the original is given in the main module.
*/
module babbage_diff_modified
#(
    OUTPUT_WIDTH = 14,
    INPUT_WIDTH = 5                                                 //If n>20, the output is 5 digits, whicih does not fit on the sseg of the basys3 - this can be seen in simulation though
 )
(
    input logic clk, reset,
    input logic start, 
    input logic [INPUT_WIDTH-1:0] input_value,                     //User input for 'n'
    output logic [3:0] bcd_out [3:0]
);

//Local Variables
localparam bcd_index_width = $clog2(OUTPUT_WIDTH + 1);

//Declare states for FSM
typedef enum {idle,                                 //This is the initial state and the defualt state while circuit is not operating
              compute_h,                              
              compute_g, 
              compute_f,
              bcd_conversion                        //Converts the computed value to BCD                           
              }state_type;

/*****Signal Declerations******/
state_type state_reg, state_next;
//Babbage Engine signals
logic [OUTPUT_WIDTH-1:0] f_reg, f_next;                 //Used to store current value of f(n) that will be used as f(n-1) in next iteration
logic [OUTPUT_WIDTH-1:0] g_reg, g_next;                 //Used to store current value of g(n) that will be used as g(n-1) in next iteration
logic [OUTPUT_WIDTH-1:0] h_reg, h_next;                 //Used to store current value of h(n) that will be used as h(n-1) in next iteration
logic [OUTPUT_WIDTH-1:0] f_temp, g_temp, h_temp;
logic [INPUT_WIDTH-1:0] index_reg, index_next;
//BCD Conversion Signals
logic [OUTPUT_WIDTH-1:0] bin_shift_reg, bin_shift_next;
logic [3:0] bcd_shift_reg[3:0], bcd_shift_next[3:0], bcd_temp[3:0];
logic [bcd_index_width-1:0] bcd_index_reg, bcd_index_next;
logic [3:0] bcd_out_reg[3:0], bcd_out_next[3:0];        //Note: Utilizing a seperate register for bcd conversion reduces critical path and improves WNS & WHS at the expense of an extra FF

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= idle;
            f_reg <= 0;
            g_reg <= 0;
            h_reg <= 0;
            index_reg <= 0;
            bin_shift_reg <= 0;
            bcd_index_reg <= 0;
            for(int i = 0; i < 4; i++)
                begin
                    bcd_shift_reg[i] <= 0;
                    bcd_out_reg[i] <= 0;
                end
        end
    else
        begin
            state_reg <= state_next;
            f_reg <= f_next;
            g_reg <= g_next;
            h_reg <= h_next;
            index_reg <= index_next;
            bin_shift_reg <= bin_shift_next;
            bcd_index_reg <= bcd_index_next;
            bcd_shift_reg <= bcd_shift_next;
            bcd_out_reg <= bcd_out_next;
        end
end

always_comb
begin
    //Default values
    state_next = state_reg;
    f_next = f_reg;
    g_next = g_reg;
    h_next = h_reg;
    index_next = index_reg;
    bcd_index_next = bcd_index_reg;
    bcd_shift_next = bcd_shift_reg;
    bin_shift_next = bin_shift_reg;
    bcd_out_next = bcd_out_reg;
    
    //FSM Control Logic
    case(state_reg)
        idle:
            begin
                if(start)
                    begin
                        index_next = 0;
                        bcd_index_next = OUTPUT_WIDTH;
                        bin_shift_next = 0;                      
                        f_next = 0;
                        g_next = 0;
                        h_next = 0;
                        for(int i = 0; i < 4; i++)
                            bcd_shift_next[i] = 0;
                        state_next = compute_h;
                    end
            end
        compute_h:
            begin
                 h_next = (index_reg < 2) ? 0 : (index_reg == 2) ? 10 : h_reg + 6;
                 state_next = compute_g;
            end
        compute_g:
            begin
                g_next = (index_reg < 1) ? 0 : (index_reg == 1) ? 5 : g_reg + h_reg;
                state_next = compute_f;
            end    
        compute_f:
            begin
                f_next = (index_reg == 0) ? 1 : g_reg + f_reg;
                 //Check if index is equal to input value 'n'
                 if(index_reg == input_value)
                    begin                        
                        bin_shift_next = f_next;  
                        state_next = bcd_conversion;                                              
                    end
                 else    
                    begin                                                      
                        index_next = index_reg + 1;
                        state_next = compute_h;
                    end                
            end                                                                                                                                 
        bcd_conversion:
            begin
                //Shift the BCD shift registers
                bcd_shift_next[3] = {bcd_temp[3][2:0], bcd_temp[2][3]};
                bcd_shift_next[2] = {bcd_temp[2][2:0], bcd_temp[1][3]};
                bcd_shift_next[1] = {bcd_temp[1][2:0], bcd_temp[0][3]};
                bcd_shift_next[0] = {bcd_temp[0][2:0], bin_shift_reg[OUTPUT_WIDTH-1]};
                //Shift binary shift reg
                bin_shift_next = bin_shift_reg << 1;
                //Check index value
                if(bcd_index_reg == 0)
                    begin                         
                        bcd_out_next = bcd_shift_reg;                          
                        state_next = idle;
                    end
                else
                    bcd_index_next = bcd_index_reg - 1;                
            end        
        default: state_next = idle;
    endcase
end

always_comb
begin
    for(int i = 0; i < 4; i++)
        bcd_temp[i] = (bcd_shift_reg[i] > 4) ? bcd_shift_reg[i] + 3 : bcd_shift_reg[i];
end

assign bcd_out = bcd_out_reg;

endmodule
