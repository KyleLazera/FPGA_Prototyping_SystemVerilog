`timescale 1ns / 1ps


module time_multiplexing_led_patterns
(
    input logic [7:0] in0, in1, in2, in3,  //Input determining how 7-seg lights up (active low)
    input logic clk, reset,
    output logic [7:0] sseg,    //Output for 7-seg
    output logic [3:0] enable   //Enables which 7-seg is displayed
);

//Describes refresh rate (using 18 bit binary counter)
//Yields 1600Hz frequency
localparam REFRESH_RATE = 18;

logic [REFRESH_RATE-1:0] r_reg, r_next;

//Memory Logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        r_reg <= 1'b0;
    else
        r_reg <= r_next;
end

//Next-State Logic
assign r_next = r_reg + 1; //Binary counter

//Ouput Logic
always_comb
begin
    case(r_reg[REFRESH_RATE-1 : REFRESH_RATE-2])
        2'b00: 
            begin
                enable = 4'b1110;
                sseg = in0;
            end
        2'b01:
            begin
                enable = 4'b1101;
                sseg = in1;
            end
        2'b10:
            begin
                enable = 4'b1011;
                sseg = in2;
            end
        2'b11:
            begin
                enable = 4'b0111;
                sseg = in3;
            end
     endcase    
end

endmodule
