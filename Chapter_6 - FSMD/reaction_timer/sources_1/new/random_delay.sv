`timescale 1ns / 1ps

/* This module is used to generate a random delay between 2 and 15 seconds using a LFSR coupled wiht a timer*/
module random_delay
#(LFSR_WIDTH = 4, COUNTER_WIDTH = 31)                                //4 bits to generate random number between 2 and 15 and counter to count up to 1.5*10^9ns (15s)
(
    input logic clk, reset,
    input logic start,                                              //Used to select a random value from the LFSR
    output logic delay_complete                                     //Indicates delay is complete
);

//Signal Declerations
logic [LFSR_WIDTH-1:0] lfsr_reg, lfsr_next;
logic [LFSR_WIDTH-1:0] delay_duration_s;                                //Delay duration in seconds
logic [COUNTER_WIDTH-1:0] delay_duration_ns;                            //Delay duration in ns
logic [COUNTER_WIDTH-1:0] tick_reg;

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            lfsr_reg <= 4'b0001;    //Input seed
            delay_duration_s <= 0;
            tick_reg <= 0;
        end
    else if(start)
        begin
            delay_duration_s <= lfsr_reg;     //if start is high save pseudo-random number
            lfsr_reg <= lfsr_reg;
            tick_reg <= 0;       
        end
    else
        begin
            lfsr_reg <= {(lfsr_reg[1] ^ lfsr_reg[0]), lfsr_reg[3:1]};       //LSFR with taps on bit 0 and 1
            tick_reg <= (tick_reg == delay_duration_ns && !delay_duration_ns) ? 0 : tick_reg + 1;
        end
end

assign delay_complete = ((tick_reg + 1) == delay_duration_ns) ? 1'b1 : 1'b0;            //Increment to ensure delay flag is not raised when delay_duration_ns is 0 (at init) and to get accurate second count

always_comb
begin
    delay_duration_ns = 0;
    case(delay_duration_s)
        4'd0: delay_duration_ns = 0;               //Ensure the value is not set when delay_duration_s is 0 (on reset)
        4'd1: delay_duration_ns = 31'd700000000;        //If 1 is the randomly generated number - set to 7 seconds (delay must be 2-15secs)
        4'd2: delay_duration_ns = 31'd200000000;        //2*10^9 ns / 10ns = 200,000,000
        4'd3: delay_duration_ns = 31'd300000000;        //2*10^9 ns / 10ns = 300,000,000  
        4'd4: delay_duration_ns = 31'd400000000;        //2*10^9 ns / 10ns = 400,000,000  
        4'd5: delay_duration_ns = 31'd500000000;        //2*10^9 ns / 10ns = 500,000,000  
        4'd6: delay_duration_ns = 31'd600000000;        //2*10^9 ns / 10ns = 600,000,000  
        4'd7: delay_duration_ns = 31'd700000000;        //2*10^9 ns / 10ns = 700,000,000  
        4'd8: delay_duration_ns = 31'd800000000;        //2*10^9 ns / 10ns = 800,000,000  
        4'd9: delay_duration_ns = 31'd900000000;        //2*10^9 ns / 10ns = 900,000,000  
        4'd10: delay_duration_ns = 31'd1000000000;        //2*10^9 ns / 10ns = 1,000,000,000  
        4'd11: delay_duration_ns = 31'd1100000000;        //2*10^9 ns / 10ns = 1,100,000,000  
        4'd12: delay_duration_ns = 31'd1200000000;        //2*10^9 ns / 10ns = 1,200,000,000  
        4'd13: delay_duration_ns = 31'd1300000000;        //2*10^9 ns / 10ns = 1,300,000,000  
        4'd14: delay_duration_ns = 31'd1400000000;        //2*10^9 ns / 10ns = 1,400,000,000  
        4'd15: delay_duration_ns = 31'd1500000000;        //2*10^9 ns / 10ns = 1,500,000,000  
        default: delay_duration_ns = 31'd500000000;        //Default value is set to 5 seconds        
    endcase
end


endmodule
