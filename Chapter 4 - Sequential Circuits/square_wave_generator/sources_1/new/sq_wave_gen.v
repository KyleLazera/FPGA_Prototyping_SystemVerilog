`timescale 1ns / 1ps

module sq_wave_gen
#(parameter sysclk_period = 10)  //Period of Basys3 is 10ns
(
    input logic clk, reset, 
    input logic [3:0] on_period, off_period,
    output logic wave_out
);

//Register declerations
logic [3:0] sysclk_tick_count, sysclk_tick_count_next;      //used to count number of ticks
logic [3:0] wave_count, wave_count_next;                    //used to count length of time wave is high or low
logic wave_reg, wave_next;                                  //Remembers state of output wave

//Memory Logic
always_ff@(posedge clk, posedge reset)
begin

    if(reset)
    begin
        sysclk_tick_count <= 1'b0;
        wave_reg <= 1'b0;
        wave_count <= 1'b0;
    end
    else
    begin
        sysclk_tick_count <= sysclk_tick_count_next;
        wave_count <= wave_count_next;
        wave_reg <= wave_next;
    end
end

always_comb
begin
    wave_next = wave_reg;
    wave_count_next = wave_count;
    sysclk_tick_count_next = sysclk_tick_count + 1;

    if(wave_reg == 1'b1 && wave_count == on_period)
    begin
        wave_next = 1'b0;
        wave_count_next = 1'b0;
    end
    
    if(wave_reg == 1'b0 && wave_count == off_period)
    begin
        wave_next = 1'b1;
        wave_count_next = 1'b0;
    end
    
    if(sysclk_tick_count == sysclk_period - 1)
    begin
        wave_count_next = wave_count + 1;
        sysclk_tick_count_next = 1'b0;
    end
   
end

assign wave_out = wave_reg;

endmodule
