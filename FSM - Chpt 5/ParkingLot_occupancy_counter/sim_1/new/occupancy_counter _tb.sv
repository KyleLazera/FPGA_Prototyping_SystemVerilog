`timescale 1ns / 1ps

//testing parking occupancy counter FSM
module occupancy_counter_tb;

localparam T = 10;           //Clock has period of 10ns
localparam delay = T*5;      //used to delay for 50ns (used for testing)
localparam blocked = 1'b1;   //Represents the photoresisto being blocked
localparam open = 1'b0;      //Represents the photoresistor being open

//Signals
logic clk, reset, a, b;
logic enter, exit;

//Module inst
parking_occupancy_FSM uut(.*);

//Enable Clock
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

//Start assigning values
initial
begin
    reset = 1'b1;
    #(T/2);
    reset = 1'b0;
    a = open;
    b = open;
    
    //Simulate a car entering the parking lot:
    a = blocked;
    #delay;
    b = blocked;
    #delay;
    a = open;
    #delay;
    b = open;
    #(T*10);
    
    //Simulate a car leaving the parking lot
    b = blocked;
    #delay;
    a = blocked;
    #delay;
    b = open;
    #delay;
    a = open;
    #(T*10);
    
    //Simulate a car entering halfway, then reversing back out
    a = blocked;
    #delay;
    b = blocked;
    #delay;
    a = open;
    #delay;
    a = blocked;
    #delay;
    b = open;
    #delay;
    a = open;
    #(T*10);
    
    //car entering halfway, reversing halfway, then enering fully
    a = blocked;
    #delay;
    b = blocked;
    #delay;
    a = open;
    #delay;
    a = blocked;
    #delay;
    b = open;
    #delay;
    b = blocked;
    #delay; 
    a = open;
    #delay;
    b = open;
    #(T*10);   
    
    //car exiting halfway, reversing halfway, then exiting fully
    b = blocked;
    #delay;
    a = blocked;
    #delay;
    b = open;
    #delay;
    b = blocked;
    #delay;
    a = open;
    #delay;
    a = blocked;
    #delay; 
    b = open;
    #delay;
    a = open;
    #(T*10);      
    
    //testing random array of operations 
    b = blocked;
    #delay;
    a = blocked;
    #delay;
    b = blocked;
    #delay;
    b = open;
    #delay;
    a = open;
    #delay;
    a = blocked;
    #delay; 
    b = open;
    #delay;
    a = open;
    #delay;  
    b = blocked;
    #delay;
    a = open;
    b = open;
    #delay;
    a = blocked;
    #delay;
    a = open;
    b = open;
    #(T*10);
    
    $stop;
end

endmodule
