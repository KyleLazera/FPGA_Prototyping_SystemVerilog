`timescale 1ns / 1ps



module disp_hex_mux    
#(parameter PRESCALER_WIDTH = 16,                        //Controls the width of the timer 
            SSEG_COUNT_WIDTH = 2)                         //Controls width of sseg switch (an)                       
(
   input logic clk, reset,
   input logic [3:0] hex0, hex1, hex2, hex3,
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
        end  
    2'b01:
        begin
            an = 4'b1101;
            hex_out = hex1;
        end   
    2'b10:
        begin
            an = 4'b1011;
            hex_out = hex2;
        end   
    2'b11:
        begin
            an = 4'b0111;
            hex_out = hex3;
        end
    endcase                             
end

//Logic to convert the BCD digits to binary for the sseg
always_comb
begin
    case(hex_out)
        4'h0: seg = 8'b11000000;
        4'h1: seg = 8'b11111001;
        4'h2: seg = 8'b10100100;
        4'h3: seg = 8'b10110000;
        4'h4: seg = 8'b10011001;
        4'h5: seg = 8'b10010010;
        4'h6: seg = 8'b10000010;
        4'h7: seg = 8'b11111000;
        4'h8: seg = 8'b10000000;
        4'h9: seg = 8'b10010000;
        4'ha: seg = 8'b10001000;
        4'hb: seg = 8'b10000011;
        4'hc: seg = 8'b11000110;
        4'hd: seg = 8'b10100001;
        4'he: seg = 8'b10000110;
        default: seg = 8'b10001110;  
    endcase
end

endmodule
