`timescale 1ns / 1ps

/*This module holds the control logic for the reaction timer circuit. This circuit will essentially count (in ms)
* how long it takes the user to press a button after an LED it lit up. It will follow the follosing flow of contorl:
* 1) Pressing the clear button returns the circuit to the initial state (7 segment display showing "HI")
* 2) Start clears the 7 segment display and there is a 2-15 second delay
* 3) If the user pushes stop before the LED is lit up 9999 will display
* 4) An LED will illuminate and the 7 segment display will display a ms counter
* 5) When the stop button is pressed the timer will stop - The timer will not exceed 1000 (1 second)
*/
module reaction_timer
(
    input logic clk, reset,
    input logic clear, start, stop,             //User inputs (linked to buttons)              
    output logic led,
    output logic [3:0] an,
    output logic [7:0] seg
);

//constant variables
localparam TIMER_FINAL = 62500;                  //Used as a ticker for the sseg controller

//FSM States
typedef enum {clear_value,                      //Used to reset the circuit
              random_delay,                     //Generates a random delay betwen 2-15 seconds
              counter                           //Counts in ms while stop has not been pressed              
              } state_type;
              
/*****Signal Declerations******/
state_type state_next, state_reg;
//7-segment control signals
logic [15:0] seg_tick_reg;
logic [3:0] temp_out[3:0], hex_out;

logic delay_complete;

/***Module Instantiations*****/
//Instantiate random delay generator
random_delay#(.LFSR_WIDTH(4), .COUNTER_WIDTH(31)) pseudo_random_delay_generator(.clk(clk), .reset(reset), .start(start),    //Input signals 
                                                                                .delay_complete(delay_complete));           //Output signals

//Instantiate bcd counter and converter module                                                                                
bcd_counter#(.TICK_WIDTH(17), .COUNTER_WIDTH(12)) ms_counter(.clk(clk), .reset(reset), .clear(clear), .stop(stop), .enable(delay_complete),
                                                             .led(led), .ms_value(temp_out));                                                                             

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= clear_value;
            seg_tick_reg <= 0;
        end
    else
        begin
            state_reg <= state_next;
            seg_tick_reg <= (seg_tick_reg == TIMER_FINAL) ? 0 : seg_tick_reg + 1;
        end
end             

always_comb
begin
    //Default Values:
    state_next = state_reg;
    an = 4'b1111;   //Default for seg is off
    hex_out = 4'b0;
    //FSM Control Logic
    case(state_reg)
        clear_value:
            begin
                //Drive the 'an' signal for the sseg controller - Should only display the first 2 LED's
                case(seg_tick_reg[15])
                    1'b0: 
                        begin
                            an = 4'b1110;
                            hex_out = 4'hF;//Temporary value that decodes to "I"
                        end
                    1'b1:
                        begin 
                            an = 4'b1101;
                            hex_out = 4'hE; //Temporary value that decodes to "H"
                        end
                endcase
                                                
                if(start)
                    state_next = random_delay;
            end
        random_delay:
            begin  
                //When in random delay - disable the seven segment display
                an = 4'b1111;
                          
                if(stop || delay_complete)
                    state_next = counter;                                
            end      
        counter:
            begin
                //Control display for the counter period
                case(seg_tick_reg[15:14])
                2'b00:
                    begin
                        an = 4'b1110;
                        hex_out = temp_out[0];
                    end  
                2'b01:
                    begin
                        an = 4'b1101;
                        hex_out = temp_out[1];           
                    end   
                2'b10:
                    begin
                        an = 4'b1011;
                        hex_out = temp_out[2];           
                    end   
                2'b11:
                    begin
                        an = 4'b0111;
                        hex_out = temp_out[3];           
                    end
                endcase
                
                if(clear)
                    state_next = clear_value;    
            end
        default: state_next = clear_value;                                     
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
        4'hE: seg = 8'b10001001;    //Represents "H"
        4'hF: seg = 8'b11111001;    //Represents "I"
        default: seg = 8'b11111111;  
    endcase
end


endmodule
