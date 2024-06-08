`timescale 1ns / 1ps

/*
The original project called for a 72Hz cycle. This would mean the HEART_TCIK would be 21 bits wide and 
the HEART_FINAL_VAL would be set to 1388889. This however, is not visible on the sseg as all the values appear to be 
lit up at once. Therefore, I adjusted the heartbeat frequency to 2Hz.
*/

module heartbeat_circuit
#(parameter HEART_TICK = 26, SSEG_TICK = 16,            //HEART_TICK is prescaler for heartbeat and SSEG_TIVK is prescaler for sseg counter
            HEARTBEAT_WIDTH = 2)  
(
    input logic clk ,reset,
    output logic [3:0] an,
    output logic [7:0] seg
);

//Local variable declerations
localparam LEFT_IN = 8'b11111001, RIGHT_IN = 8'b11001111;
localparam LEFT_MID = 8'b11001111, RIGHT_MID = 8'b11111001;
localparam LEFT_OUT = 8'b11001111, RIGHT_OUT = 8'b11111001;
localparam HEART_FINAL_VAL = 50000000;                                    //Final Value used to achieve 72Hz
localparam SSEG_FINAL_VAL = 65535;

//Signal Declerations
logic [HEART_TICK-1:0] h_tick_reg, h_tick_next;
logic [SSEG_TICK-1:0] s_tick_reg, s_tick_next;
logic [HEARTBEAT_WIDTH-1:0] heart_reg, heart_next;
logic sseg_count_reg, sseg_count_next;

//Memory/Counter logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            h_tick_reg <= 0;
            s_tick_reg <= 0;
            heart_reg <= 0;
            sseg_count_reg <= 0;
        end
    else
        begin
            h_tick_reg <= h_tick_next;
            s_tick_reg <= s_tick_next;
            heart_reg <= heart_next;
            sseg_count_reg <= sseg_count_next;
        end;
end

/****************Combinational Logic******************/

//Prescaler for the heartbeat 
always_comb
begin
    h_tick_next = h_tick_reg + 1;
    heart_next = heart_reg;
    
    //Set the heartbeat frequency to 72Hz
    if(h_tick_reg == HEART_FINAL_VAL)
        begin
            heart_next = heart_reg + 1;
            h_tick_next = 0;
        end
    
    if(heart_reg == 2'b11)
        heart_next = 0;
end

//Prescalre for the sseg alternator
always_comb
begin
    s_tick_next = s_tick_reg + 1;
    sseg_count_next = sseg_count_reg;
    
    //Set frequency for the alternating an bits
    if(s_tick_reg == SSEG_FINAL_VAL)
        begin
            sseg_count_next = sseg_count_reg + 1;
            s_tick_next = 0;
        end
end

//Logic for the black box 
always_comb
begin
    if(sseg_count_reg)
        begin
            case(heart_reg)
            2'b00:
                begin
                    an = 4'b1011;
                    seg = LEFT_IN;
                end
            2'b01:
                begin
                   an = 4'b1011;
                   seg = LEFT_MID;
                end               
            2'b10:
                begin
                    an = 4'b0111;
                    seg = LEFT_OUT;
                end
            endcase
        end
    else
        begin
            case(heart_reg)
            2'b00:
                begin
                    an = 4'b1101;
                    seg = RIGHT_IN;
                end
            2'b01:
                begin
                   an = 4'b1101;
                   seg = RIGHT_MID;
                end               
            2'b10:
                begin
                    an = 4'b1110;
                    seg = RIGHT_OUT;
                end
            endcase
        end
end

endmodule
