`timescale 1ns / 1ps


module parking_occupancy_counter
(
    input logic clk, reset,
    input logic [1:0] sw,                   //Controls the photoresistors for the parking lot entrance
    output logic [3:0] an,          
    output logic [7:0] seg
);

//Signal Declerations
logic debounced_a, debounced_b;             //These are the input values after debouncing
logic car_enter, car_exit;             
logic [3:0] hex_out [1:0];    

/****Module Instantiation****/

//passing input values to debouncing modules
input_debounce#(.TIMER_WIDTH(21)) db_input_a(.clk(clk), .reset(reset), .in(sw[0]), .db_out(debounced_a));  //debounce a 
input_debounce#(.TIMER_WIDTH(21)) db_input_b(.clk(clk), .reset(reset), .in(sw[1]), .db_out(debounced_b));  //debounce b

//Pass debounced inputs to the parking lot FSM
parking_occupancy_FSM parking_lot_counter(.clk(clk), .reset(reset), .a(debounced_a), .b(debounced_b), .enter(car_enter), .exit(car_exit));

//Pass number of cars that eneterd/exited parking lot into the counter/decrementor
counter_circuit car_counter(.clk(clk), .reset(reset), .inc(car_enter), .dec(car_exit), .hex_out(hex_out));

//Pass counter output to disp mux to display  on the seven segment display on BASYS3
disp_mux sseg_controller(.clk(clk), .reset(reset), .hex0(hex_out[0]), .hex1(hex_out[1]), .an(an), .seg(seg));

endmodule
