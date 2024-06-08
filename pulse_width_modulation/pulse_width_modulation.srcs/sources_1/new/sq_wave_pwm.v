`timescale 1ns / 1ps

module sq_wave_pwm
#(parameter N = 4) //Param used to contorl the resolution of PWM
(
    input logic clk, reset,
    input logic [N:0] pwm_control,      //PWM control bit is increased by 1 to allow for full DC output if the MSB is set
    output logic wave_out
);

//Signal Declerations
logic [N-1:0] counter_reg, counter_next;        //Control D and Q vals for counter
logic wave_reg, wave_next;                      //Controls D and Q vals for wave output

//Memory Logic
always_ff @(posedge clk, posedge reset)
begin
    if(reset)
    begin
        wave_reg <= 1'b0;
        counter_reg <= 1'b0;
    end
    
    else
    begin
        counter_reg <= counter_next;
        wave_reg <= wave_next;
    end
end        

//Next State Logic
always_comb
begin
    counter_next = counter_reg + 1;
    wave_next = wave_reg;
    
    if(counter_next < pwm_control)
        wave_next = 1'b1;
    else
        wave_next = 1'b0;
end

assign wave_out = wave_reg;

endmodule
