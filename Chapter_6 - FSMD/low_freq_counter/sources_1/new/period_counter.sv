`timescale 1ns / 1ps

/*This module is used to count the period in microseconds between input values*/
module period_counter
#(TICK_WIDTH = 7, COUNTER_WIDTH = 24)                                   //Largets possible period needs to be 1000000 us (1 second)
(
    input logic clk, reset,
    input logic edge_input,                                             //External input (this is what the module is determining the period of)
    input logic enable,                                                 //Active low signle that enables operation of this module
    output logic [COUNTER_WIDTH-1:0] period,                            //This is the period of the input pulse
    output logic done_flag                                              //Indicates the period has been counted
);

localparam FINAL_TICK = 100;                        //Counting to 100 takes 1000ns which is the period for 1 microsecond

//Signal Declerations
logic [TICK_WIDTH-1:0] tick_reg, tick_next;
logic [COUNTER_WIDTH-1:0] counter_reg, counter_next;    //Determines if circuit is currently "counting" the period
logic [COUNTER_WIDTH-1:0] out_reg, out_next;            //Used to keep track of the ouput period - Used to avoid unintentional latch
logic counter_flag_reg, counter_flag_next;              //used to determine whether the circuit is currently counting the input period
logic done_reg, done_next;                              //Used to keep track if operation is complete
//Wires
logic delay_reg;
logic r_edg;
 
always_ff @(posedge clk, posedge reset, posedge enable)
begin
    if(reset)
        begin
            tick_reg <= 0;
            counter_reg <= 0;
            delay_reg <= 0;
            counter_flag_reg <= 0;
            done_reg <= 0;
            out_reg <= 0;
        end
    else if(enable)
        begin
            tick_reg <= tick_reg;
            counter_reg <= counter_reg;
            delay_reg <= 0;
            counter_flag_reg <= counter_flag_reg;
            done_reg <= done_reg;
            out_reg <= out_reg;            
        end
    else
        begin
            tick_reg <= tick_next;
            counter_reg <= counter_next;
            delay_reg <= edge_input;
            counter_flag_reg <= counter_flag_next;
            done_reg <= done_next;
            out_reg <= out_next;
        end        
end

/********Next State Logic*********/
//Determine if there is a rising edge
assign r_edg = ~delay_reg & edge_input; 
//Determine whether the value is counting or not (counting flag is high)                                   
assign counter_flag_next = (r_edg) ? ~counter_flag_reg : counter_flag_reg; 

/***Tick & Counter logic****/
assign tick_next = (r_edg || tick_reg == FINAL_TICK-1) ? 0 : 
                   (counter_flag_reg) ? tick_reg + 1: tick_reg;      
                                 
assign counter_next = (r_edg) ? 1 : 
                      (tick_reg == FINAL_TICK-1) ? counter_reg + 1 : counter_reg;

//Determine if counter flag is going from high to low (indicating period has been counted)                      
assign done_next = counter_flag_reg & ~counter_flag_next;
assign out_next = (counter_flag_reg) ? counter_reg : out_reg;

/********Ouput Logic ************/
assign period = out_reg;
assign done_flag = done_reg;


endmodule
