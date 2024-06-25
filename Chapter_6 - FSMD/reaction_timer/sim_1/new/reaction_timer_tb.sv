`timescale 1ns / 1ps

//Testbench to test reaction timer top module
module reaction_timer_tb;

localparam T = 10;            //10ns period

logic clk, reset;
logic clear, start, stop;               //User driven inputs         
logic led;
logic [3:0] an;
logic [7:0] seg;

//Module inst
reaction_timer uut(.*);

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
        start = 1'b1;
        #(T*500);
        start = 1'b0;
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
    //Init all inputs to 0 - At this point LED should be off and 7seg should display "HI"
    start = 1'b0;
    clear = 1'b0;
    stop = 1'b0;
    #(T*1000);
    
    //Beign circuit by pressing start - this initializes a random delay (2-15 seconds)
    //LED should be off and 7 segment should be blank
    start_circuit();
    wait(led == 1);     //Wait until led is on indicating delay has complete
    press_stop(350);    //Press stop with simulated 350 ms delay
    #(1000000);        //Delay for short period - output should remain the same as when stop was pressed 
    $finish;
    
end

endmodule
