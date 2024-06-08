`timescale 1ns / 1ps

/*This module will have 4, 4-bit shift registers*/  
module shift_reg_4bit
#(parameter PRESCALER_WIDTH = 26)                       //Prescaler width determins bit width of the timer                       
(
    input logic clk, reset,
    input logic dir,                                    //Dir determines direction of rotation
    input logic enable,                                 //Active low, freezes the rotation        
    output logic [3:0] parallel_out [3:0]
);

//Variables
localparam TIMER_FINAL = 50000000;                      //Holds const value that prescaler counts to

//Signal Declerations
logic [PRESCALER_WIDTH-1:0] tick_q, tick_next;          //Timer that controls freq of counter & rotation of shift reg.
logic [3:0] shift_reg_q [3:0], shift_reg_next[3:0];     //Wires fo the FF of the shift register


//Memory Logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
    begin
        tick_q <= 0;
        for(int i = 0; i < 4; i++)
            shift_reg_q[i] <= 0;
    end
    //If enable is high Pause rotation (it is active low signal)
    else if(enable)
    begin
        tick_q <= tick_q;
        shift_reg_q <= shift_reg_q;
    end
               
    else
    begin
        tick_q <= tick_next;
        shift_reg_q <= shift_reg_next;
    end
end    
 
/********Combinational logic******/

//Timer Logic - when timer reaches set val increment counter and reset the timer
always_comb
begin
    tick_next = tick_q + 1;
    shift_reg_next = shift_reg_q;
    
    if(tick_q == TIMER_FINAL)
    begin
        tick_next = 0;
        //If direction bit is 1, shift left
        if(dir)
        begin
            //Shift all values to the left
            for(int i = 3; i > 0; i--)
                shift_reg_next[i] = shift_reg_next[i-1];
            //Value that is shifted in is calculated based off current value in the lsb position (incremented)
            shift_reg_next[0] = (shift_reg_q[0] > 8) ? 0 : shift_reg_q[0] + 1;    
        end
        //If dir is 0, shift value right
        else
        begin
            //Shift all values to the right
            for(int i = 0; i < 3; i++)
                shift_reg_next[i] = shift_reg_next[i+1];
            //Value that is shifted in is calculated based off current value in the lsb position (decremented)
            shift_reg_next[3] = (shift_reg_q[3] > 9 || shift_reg_q[3] == 0) ? 9 : shift_reg_q[3] - 1;           
        end
    end
end    
 
assign parallel_out = shift_reg_q;
 
endmodule
