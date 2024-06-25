`timescale 1ns / 1ps


module top_wrapper_tb;

localparam T = 10;

logic clk, reset;
logic signal_in, start;
//logic [3:0] an;
//logic [7:0] seg;
logic [3:0]autoscale;
logic [3:0] bcd_out [3:0];

//Module inst
top_wrapper uut(.*);

//task that simulates an input signal with specified period (us)
task generate_input_signal(input int us_period);
    begin
        signal_in = 1'b1;
        #(T*20);
        signal_in = 1'b0;
        #(T*(100 * us_period));
        signal_in = 1'b1;
        #(T*20);
        signal_in = 1'b0;
        #(T*100000);
    end
endtask

//Initialize clock
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

//Reset circuit
initial begin
    reset = 1'b1;
    #T;
    reset = 1'b0;
end

//Signal Assignments
initial begin
    start = 1'b0;
    #(T*20);    //Initial delay to ensure circuit is reset
    start = 1'b1;
    
    generate_input_signal(100000); //Period of 100000us (0.1s) - 10Hz freq
    generate_input_signal(11494);  //Period of 11494us (0.01149s) - 87Hz
    generate_input_signal(8474); //Period of 8474us (0.008474s) - 118Hz
    generate_input_signal(3496); //Period of 3496us (0.003496s) - 286Hz
    generate_input_signal(1700); //period of 1700 us (0.001700s) - 585Hz
    generate_input_signal(593); //period of 596us (0.000593s) - 1685Hz
    generate_input_signal(157); //Period of 157us (0.000157s) - 6342Hz
    $finish;
    
end

endmodule
