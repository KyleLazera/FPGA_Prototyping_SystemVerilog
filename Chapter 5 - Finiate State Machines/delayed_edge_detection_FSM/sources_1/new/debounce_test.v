`timescale 1ns / 1ps


module debounce_test
(
    input logic clk, rest,
    input logic [1:0] btn,
    output logic [3:0] an,
    output logic [7:0] seg
);

//Signal Declerations
logic [7:0] b_reg, d_reg;
logic [7:0] b_next, d_next;
logic btn_reg, db_reg;
logic db_level, db_tick, btn_tick, clr;

//Instantiate sevent seg display module
disp_hex_mux#(.PRESCALER_WIDTH(16), .SSEG_COUNT_WIDTH(2)) disp_unit (.clk(clk), .reset(reset), 
                .an(an), .seg(seg), .hex0(d_reg[3:0]), .hex1(d_reg[7:4]), .hex2(b_reg[3:0]), .hex3(b_reg[7:4]));
                
//Instantiate debouncing circuit
db_fsm db_unit(.clk(clk), .reset(reset), .sw(btn[1]), .debounced_sw(db_level));

//Edge detection Circuit
always_ff @(posedge clk)
begin
    btn_reg <= btn[1];
    db_reg <= db_level;
end

//Determining rising edge (going from 0 to 1)
assign btn_tick = ~btn_reg & btn[1];   
assign db_tick = ~db_reg & db_level;    

//Two counters
assign clr = btn[0];
always_ff @(posedge clk)
begin
    b_reg <= b_next;
    d_reg <= d_next;
end

assign b_next = (clr) ? 8'b0 : (btn_tick) ? b_reg + 1 : b_reg;
assign d_next = (clr) ? 8'b0 : (db_tick) ? d_reg + 1 : d_reg;

endmodule
