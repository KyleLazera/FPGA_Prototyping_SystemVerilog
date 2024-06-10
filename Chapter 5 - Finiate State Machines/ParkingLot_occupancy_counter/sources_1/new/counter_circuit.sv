`timescale 1ns / 1ps

//Counter/decrementor circuit used to count the numbers of cars that are in the parking lot
//This only counts up to 0xFF 
module counter_circuit
(
    input logic clk, reset,
    input logic inc, dec,                           //Determine hwteher to increment or decrement
    output logic [3:0] hex_out [1:0]                //Module outputs 2 hex digits 
);

//Signal Declerations
logic [7:0] counter_q, counter_next;

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        counter_q <= 0;
    else
        counter_q <= counter_next;
end

assign counter_next = (inc) ? counter_q + 1 :
                      (dec) ? counter_q - 1 : counter_q;
assign hex_out[0] = counter_q[3:0];
assign hex_out[1] = counter_q[7:4];                      

endmodule
