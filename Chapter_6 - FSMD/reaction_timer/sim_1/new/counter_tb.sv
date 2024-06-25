`timescale 1ns / 1ps


module counter_tb;

localparam T = 10;  //10ns period

//Signals
logic clk, reset;
logic enable;                     
logic stop, clear, led;                   
logic [3:0] ms_value[3:0];           

//Module Instantiation
bcd_counter#(.COUNTER_WIDTH(12), .TICK_WIDTH(17)) uut(.*);

//Init clock
initial begin
    clk = 1'b0;
    forever #(T/2) clk = ~clk;
end

//Reset circuit
initial begin
    reset = 1'b1;
    #(T*2);
    reset = 1'b0;
end

//Task that simulates the beginning of the counter
task start_circuit();
    begin
        enable = 1'b1;
        #(T*500);
        enable = 1'b0;
    end
endtask

//Task used to simulate the user pressing the stop button after a prolonged period specified by user (ms)
task press_stop(input int time_ms);
    begin
        #(time_ms*1000000);
        stop = 1'b1;
        #(T*100);
        stop = 1'b0;
    end
endtask

//Task simulating pressing clear 
task reset_circuit();
    begin
    clear = 1'b1;   
    #(T*1000);
    clear = 1'b0;
    end
endtask

initial begin
    enable = 1'b0;
    stop = 1'b0;
    clear = 1'b0;
    #(T*500);
    
    //Simulate pressing stop before the delay has complete (reference to top level circuit)
    press_stop(1);
    #(T*100);
    reset_circuit();
    #(T*500);
    
    start_circuit();
    press_stop(5);
    #(T*10000);
    reset_circuit();
    #(T*500);
    
    start_circuit();
    press_stop(5);
    #(T*10000);
    reset_circuit();
    #(T*500);
    
    start_circuit();
    press_stop(1050);
    #(T*10000);
    reset_circuit();
    #(T*500);
    $finish;
end

endmodule
