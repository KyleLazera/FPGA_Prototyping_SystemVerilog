`timescale 1ns / 1ps

/* This module implements the control logic using an FSMD. This circuit is the control path.*/
module low_freq_counter
#(PERIOD_WIDTH = 24)
(
    input logic clk, reset,
    input logic start, signal_in,
   output logic [3:0] an,                                       //an determines which seg to light
   output logic [7:0] seg                                       //seg value to output
);

//FSM states
typedef enum{
              idle,                                 //This is the initial state
              period_counter,                       //used to count the period of the input pulses
              period_to_freq,                       //Convert the period of the inpuklse to frequency (using 1/T = f)
              bcd_conversion                      //Converts the frequency value to BCD and autoscales the value            
              } state_type;                                      
              
/*******Signal Declerations ********/
state_type state_reg, state_next;

//Period Counter Control Signals
logic prd_start, prd_complete;                                        //Signals indicating period counter starting and is complete
logic [PERIOD_WIDTH-1:0] prd_reg, prd_next;

//Diviosn COntrol Signals
logic division_start, division_complete;
logic [PERIOD_WIDTH-1:0] freq_reg, freq_next;
logic [2:0] temp_shift_reg, temp_shift_next;

//BCD conversion control signals
logic conv_start, conv_complete;
logic [3:0] bcd_freq_reg[3:0], bcd_freq_next[3:0];



/*******Module Declerations*********/
//Instantiate period counter
period_counter#(.COUNTER_WIDTH(PERIOD_WIDTH), .TICK_WIDTH(7)) period_count(.clk(clk), .reset(reset), .enable(prd_start),
                                                .edge_input(signal_in), .period(prd_next), .done_flag(prd_complete));

//Instantiate Division circuit
division_circuit#(.BIT_WIDTH(PERIOD_WIDTH)) period_division(.clk(clk), .reset(reset), .start(division_start), 
                                            .dvsr(prd_reg), .dvnd(48'd1000000000), .complete(division_complete), .quotient(freq_next));  
                                            
//Instantiate the binary_to_bcd converter + autoscaler
binary_to_bcd#(.BINARY_WIDTH(PERIOD_WIDTH)) bcd_conversion_autoscale(.clk(clk), .reset(reset), .start(conv_start), .binary_input(freq_reg),
                                            .bcd_out(bcd_freq_next), .autoscale_shifts(temp_shift_next), .done_flag(conv_complete));
                                            
//Instantiate Disp Mux for 7 segment controller
disp_mux#(.PRESCALER_WIDTH(16), .SSEG_COUNT_WIDTH(2)) sseg_controller(.clk(clk), .reset(reset), .autoscale_shift(temp_shift_reg), .hex0(bcd_freq_reg[0]),
                                                        .hex1(bcd_freq_reg[1]), .hex2(bcd_freq_reg[2]), .hex3(bcd_freq_reg[3]), .an(an), .seg(seg));                                            

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= idle;
            prd_reg <= 0;
            freq_reg <= 0;
            temp_shift_reg <= 0;
            for(int i = 0; i < 4; i++)
                bcd_freq_reg[i] <= 0;
        end
    else
        begin
            state_reg <= state_next;         
            prd_reg <= prd_next;
            freq_reg <= freq_next;
            temp_shift_reg <= temp_shift_next;
            bcd_freq_reg <= bcd_freq_next;
        end
end


always_comb
begin
    //Set default FF and wire values 
    state_next = state_reg;
    
    conv_start = 1'b0;
    division_start = 1'b0;
    prd_start = 1'b1;
    //Control logic (FSM)
    case(state_reg)
        idle:
            begin
                if(start)                              
                    state_next = period_counter;
            end
        period_counter:
            begin
                prd_start = 1'b0;  
                if(prd_complete)                   
                    state_next = period_to_freq;                                                                              
            end  
        period_to_freq:
            begin
                division_start = 1'b1;
                if(division_complete)
                    state_next = bcd_conversion;               
            end
        bcd_conversion:
            begin
                conv_start = 1'b1;
                if(conv_complete)
                    state_next = idle;
            end    
        default: state_next = idle;      
    endcase
end


endmodule
