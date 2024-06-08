`timescale 1ns / 1ps

module stop_watch
#(parameter TICK_WIDTH = 24)                                    //Determines the size of the ticker/prescaler
(
    input logic clk, up,                                        //Up control counting direction
    input logic clr,
    output logic [3:0] parallel_out [3:0]
);

//const variable
localparam TICK_10HZ = 10000000;                                //Value to count up to, to achieve 10Hz tick

//Signal Declerations
logic [TICK_WIDTH-1:0] tick_10hz_q, tick_10hz_next;
logic [3:0] digit_next[3:0], digit_q[3:0];                      //Holds next and current digit values being output               
logic ms_tick, d0_tick, d1_tick, d2_tick;                       //Ticker for each digit (ms, digit 1, digit 2...)
logic d0_en, d1_en, d2_en, d3_en;                               //"Indicate" to folllowing digit that it needs to increment/decrement
logic d2_dis, d1_dis, d0_dis;                                   //Locks the current digit based on value of next significant digit 

always_ff @(posedge clk, posedge clr)
begin
    if(clr)
    begin
        tick_10hz_q <= 0;
        for(int i = 0; i < 4; i++)
            digit_q[i] <= 0; 
    end
    else
    begin   
        tick_10hz_q <= tick_10hz_next;
        for(int i = 0; i < 4; i++)
            digit_q[i] <= digit_next[i];
    end
end

//Logic to increment the ticker
assign tick_10hz_next = (clr || tick_10hz_q == TICK_10HZ) ? 0 : tick_10hz_q + 1;

assign ms_tick = (tick_10hz_q == TICK_10HZ) ? 1'b1 : 1'b0;
assign d0_en = ms_tick; 
assign d0_dis = (!digit_q[3] && !digit_q[2] && !digit_q[1]) ? 1'b1 : 1'b0; //If the next 3 digits are 0, then disable the least significant digit at 0
    
//0.1 second counter logic 
always_comb
begin
    if(up)
    begin
        digit_next[0] = (clr || (d0_en && digit_q[0] == 9)) ? 4'b0 : 
                        (d0_en) ? digit_q[0] + 1 : digit_q[0];
    end
    else
    begin
        digit_next[0] = (d0_en && (d0_dis && digit_q[0] == 0)) ? 4'b0 :
                        (d0_en && digit_q[0] == 0) ? 9 : 
                        (d0_en) ? digit_q[0] - 1 : digit_q[0]; 
        
    end
end

assign d0_tick = (up) ? (digit_q[0] == 9) && d0_en : (digit_q[0] == 0) && d0_en;
assign d1_en = d0_tick;
assign d1_dis = (!digit_q[3] && !digit_q[2]) ? 1'b1 : 1'b0; //If the next 2 digits are 0, then disable the 2nd least sig digit at 0

//1 second counter counter
always_comb
begin
    if(up)
    begin
        digit_next[1] = (clr || (d1_en && digit_q[1] == 9)) ? 4'b0 :
                        (d1_en) ? digit_q[1] + 1 : digit_q[1];
    end
    else
    begin
        digit_next[1] = (d1_en && (d1_dis && digit_q[1] == 0)) ? 4'b0 :
                        (d1_en && digit_q[1] == 0) ? 9 : 
                        (d1_en) ? digit_q[1] - 1 : digit_q[1]; 
    end
end
                     
assign d1_tick = (up) ? (digit_q[1] == 9) && d1_en : (digit_q[1] == 0) && d1_en;
assign d2_en = d1_tick;       
assign d2_dis = (!digit_q[3]) ? 1'b1 : 1'b0;

//10 second counter
always_comb
begin
    if(up)
    begin
        digit_next[2] = (clr || (d2_en && digit_q[2] == 5)) ? 4'b0 :
                        (d2_en) ? digit_q[2] + 1 : digit_q[2];
    end
    else
    begin
        digit_next[2] = (d2_en && (d2_dis && digit_q[2] == 0)) ? 4'b0 :
                        (d2_en && digit_q[2] == 0) ? 5 : 
                        (d2_en) ? digit_q[2] - 1 : digit_q[2]; 
    end
end
                        
assign d2_tick = (up) ? (digit_q[2] == 5) && d2_en : (digit_q[2] == 0) && d2_en;
assign d3_en = d2_tick;

//1 minute counter
always_comb
begin
    if(up)
    begin
        digit_next[3] = (clr || (d3_en && digit_q[3] == 9)) ? 4'b0 :
                        (d3_en) ? (digit_q[3] + 1) : digit_q[3];
    end
    else
    begin
        digit_next[3] = (d3_en && (digit_q[3] == 0)) ? 4'b0 : 
                        (d3_en) ? digit_q[3] - 1 : digit_q[3]; 
    end
end                                     

//ouput logic
assign parallel_out[0] = digit_q[0];
assign parallel_out[1] = digit_q[1];
assign parallel_out[2] = digit_q[2];
assign parallel_out[3] = digit_q[3];

endmodule
