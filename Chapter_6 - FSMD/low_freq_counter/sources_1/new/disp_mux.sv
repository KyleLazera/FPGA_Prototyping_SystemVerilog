`timescale 1ns / 1ps

//Module used to display the output on the seven segment display
module disp_mux
#(parameter PRESCALER_WIDTH = 16,                        //Controls the width of the timer 
            SSEG_COUNT_WIDTH = 2)                         //Controls width of sseg switch (an)                       
(
   input logic clk, reset,
   input logic [3:0] hex0, hex1, hex2, hex3,
   input logic [2:0] autoscale_shift,
   output logic [3:0] an,                                       //an determines which seg to light
   output logic [7:0] seg                                       //seg value to output
);

//constant variables
localparam TIMER_FINAL = 62500;                                  //Value for timer prescaler to count up localparam

//Signal Declerations
logic [PRESCALER_WIDTH-1:0] tick_q, tick_next;                  //Ticker (prescaler) FF values
logic [SSEG_COUNT_WIDTH-1:0] sseg_count_q, sseg_count_next;      //Used to determine output for an bit (select sseg)
logic [3:0] hex_out;

//Memory (FF) Logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
    begin
        tick_q <= 0;
        sseg_count_q <= 0;
    end
    
    else
    begin
        tick_q <= tick_next;
        sseg_count_q <= sseg_count_next;
    end
end

//********Combinational Logic **********/
//SSEG timer - once the ticker hits a specific val, increment the sseg counter 
always_comb
begin
    tick_next = tick_q + 1;
    sseg_count_next = sseg_count_q;
    
    if(tick_q == TIMER_FINAL)
    begin
        tick_next = 0;
        sseg_count_next = sseg_count_q + 1;
    end
end

//Logic to choose the sseg to display
always_comb
begin
    case(sseg_count_q)
    2'b00:
        begin
            an = 4'b1110;
            hex_out = hex0;
            seg[7] = (autoscale_shift == 3'b1) ? 1'b0 : 1'b1;
        end  
    2'b01:
        begin
            an = 4'b1101;
            hex_out = hex1;
            seg[7] = (autoscale_shift == 3'b10) ? 1'b0 : 1'b1;            
        end   
    2'b10:
        begin
            an = 4'b1011;
            hex_out = hex2;
            seg[7] = (autoscale_shift == 3'b11) ? 1'b0 : 1'b1;            
        end   
    2'b11:
        begin
            an = 4'b0111;
            hex_out = hex3;
            seg[7] = (autoscale_shift == 3'b100) ? 1'b0 : 1'b1;            
        end
    endcase                             
end

//Logic to convert the BCD digits to binary for the sseg
always_comb
begin
    case(hex_out)
        4'h0: seg[6:0] = 7'b1000000;
        4'h1: seg[6:0] = 7'b1111001;
        4'h2: seg[6:0] = 7'b0100100;
        4'h3: seg[6:0] = 7'b0110000;
        4'h4: seg[6:0] = 7'b0011001;
        4'h5: seg[6:0] = 7'b0010010;
        4'h6: seg[6:0] = 7'b0000010;
        4'h7: seg[6:0] = 7'b1111000;
        4'h8: seg[6:0] = 7'b0000000;
        4'h9: seg[6:0] = 7'b0010000;
        default: seg[6:0] = 7'b0001110;  
    endcase
end
endmodule
