`timescale 1ns / 1ps


module heartbeat_tb;

//Clock period 10ns
localparam T = 10;

//Signals
logic clk, reset;
logic [3:0] an;
logic [7:0] seg;

//module inst
heartbeat_circuit#(.HEART_TICK(21), .SSEG_TICK(16), .HEARTBEAT_WIDTH(2))
                    uut(.*);
                    
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end


initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
end

endmodule
