`timescale 1ns / 1ps


module sseg_time_multiplexing
#(parameter COUNTER_WIDTH = 18, PWM_RESOLUTION = 4)
(
    input logic clk, reset,
    input logic [3:0] hex0, hex1, hex2, hex3,
    input logic [3:0] dp_in,                        //Decimal place values input
    input logic [PWM_RESOLUTION:0] pwm_control,
    output logic [3:0] an,                          //Select which sseg to light up
    output logic [7:0] sseg                        //sseg value to display (active low)
);

//Signal Declerations
logic [COUNTER_WIDTH-1:0] sseg_counter_reg, sseg_counter_next;      //Counter used to control sseg
logic [PWM_RESOLUTION-1:0] pwm_counter_reg, pwm_counter_next;       //Counter used to control pwm
logic wave_reg, wave_next;
logic [3:0] hex_in;
logic dp;

//Memory logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
    begin
        sseg_counter_reg <= 1'b0;
        wave_reg <= 1'b0;
        pwm_counter_reg <= 1'b0;
    end
    
    else
    begin
        sseg_counter_reg <= sseg_counter_next;
        wave_reg <= wave_next;
        pwm_counter_reg <= pwm_counter_next;
    end
end


//Next State Logic
always_comb
begin
    sseg_counter_next = sseg_counter_reg + 1;

    //2 to 4 decoder + Multiplexer logic
    case(sseg_counter_next[COUNTER_WIDTH-1:COUNTER_WIDTH-2])
        2'b00: 
        begin
            an = {3'b111, ~wave_next};
            hex_in = hex0;
            dp = dp_in[0];
        end
        
        2'b01:
        begin
            an = {2'b11, ~wave_next, 1'b1};
            hex_in = hex1;
            dp = dp_in[1];
        end
        
        2'b10:
        begin
            an = {1'b1, ~wave_next, 2'b11};
            hex_in = hex2;
            dp = dp_in[2];
        end
        
        2'b11:
        begin
            an = {~wave_next, 3'b111};
            hex_in = hex3;
            dp = dp_in[3];
        end
    endcase   
end

//Logic for comparator
always_comb
begin
    pwm_counter_next = pwm_counter_reg + 1;
    
    if(pwm_counter_reg < pwm_control)
        wave_next = 1'b1;
     else
        wave_next = 1'b0;
end


//Logic for hex to binary 
always_comb
begin
   case(hex_in)
        4'h0: sseg[6:0] = 7'b1000000;
        4'h1: sseg[6:0] = 7'b1111001;
        4'h2: sseg[6:0] = 7'b0100100;
        4'h3: sseg[6:0] = 7'b0110000;
        4'h4: sseg[6:0] = 7'b0011001;
        4'h5: sseg[6:0] = 7'b0010010;
        4'h6: sseg[6:0] = 7'b0000010;
        4'h7: sseg[6:0] = 7'b1111000;
        4'h8: sseg[6:0] = 7'b0000000;
        4'h9: sseg[6:0] = 7'b0010000;
        4'ha: sseg[6:0] = 7'b0001000;
        4'hb: sseg[6:0] = 7'b0000011;
        4'hc: sseg[6:0] = 7'b1000110;
        4'hd: sseg[6:0] = 7'b0100001;
        4'he: sseg[6:0] = 7'b0000110;
        default: sseg[6:0] = 7'b0001110;       //4'hf
    endcase
    sseg[7] = dp;
end       

 
endmodule
