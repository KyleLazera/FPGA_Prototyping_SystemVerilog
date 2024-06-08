`timescale 1ns / 1ps


module sq_wave_tb;

//Signals
localparam T = 10;
logic clk, reset;
logic [3:0] on_period, off_period;
logic wave_out;

//instantiation
sq_wave_gen uut(.clk(clk), .reset(reset), .on_period(on_period), .off_period(off_period), .wave_out(wave_out));

//generating clock with 10ns period
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

//Reset to initialize everything
initial
begin
    reset = 1'b1;
    #(T);
    reset = 1'b0;
    #(T);
end

//Set values
initial 
begin

    for(int i = 0; i < 16; i++)
    begin
        on_period = i;
        for(int j = 0; j < 16; j++)
        begin
            off_period = j;
            #(T * 100); 
        end
    end
end

endmodule
