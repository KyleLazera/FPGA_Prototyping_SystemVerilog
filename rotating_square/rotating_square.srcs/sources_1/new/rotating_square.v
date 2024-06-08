`timescale 1ns / 1ps


module rotating_square
#(parameter TIMER_WIDTH = 26, COUNTER_WIDTH = 3)
(
    input logic clk, reset,
    input logic cw,                     //cw determine clockwise or coutnerclockwise
    input logic enable,                 //If pulled low, pauses the clock
    output logic [3:0] an,              //Selects the specific sseg to light up
    output logic [7:0] sseg             //Output value on sseg
);

//Constants
localparam FINAL_VALUE = 50000000;         //value the timer couns up to
localparam TOP_SQUARE = 8'b10011100;    //Holds value for top square for sseg
localparam BOTTOM_SQUARE = 8'b10100011; //Value for bottom square for sseg

//Signals
logic [TIMER_WIDTH-1:0] timer_reg, timer_next;                      
logic [COUNTER_WIDTH-1:0] counter_reg, counter_next;

//Timer and counter memory logic
always_ff @(posedge clk, posedge reset)
begin
//If reset is high reset all FF values
    if(reset)
    begin
        timer_reg <= 0;
        counter_reg <= 0;
    end
    
    else
    begin
        timer_reg <= timer_next;
        counter_reg <= counter_next;
    end
end

//Combinational Logic
always_comb
begin    
    counter_next = counter_reg;
    timer_next = timer_reg + 1;
    
    //If timer value has been reached, increment the counter & reset timer
    if(timer_reg == FINAL_VALUE)
    begin
        if(enable == 1'b1)
            counter_next = cw ? (counter_reg + 1) : (counter_reg - 1);
        timer_next = 0;
    end
   
end

//Logic to determine location of square 
always_comb
begin
    case(counter_reg)
        3'b000: 
            begin
                an = 4'b0111;
                sseg = TOP_SQUARE;
            end
        3'b001:
            begin
                an = 4'b1011;
                sseg = TOP_SQUARE;
            end
        3'b010:
            begin
                an = 4'b1101;
                sseg = TOP_SQUARE;
            end
        3'b011:
            begin
                an = 4'b1110;
                sseg = TOP_SQUARE;
            end
        3'b100:
            begin
                an = 4'b1110;
                sseg = BOTTOM_SQUARE;
            end
        3'b101:
            begin
                an = 4'b1101;
                sseg = BOTTOM_SQUARE;
            end
        3'b110:
            begin
                an = 4'b1011;
                sseg = BOTTOM_SQUARE;
            end
        3'b111:
            begin
                an = 4'b0111;
                sseg = BOTTOM_SQUARE;
            end
   
    endcase                                           
end

endmodule
