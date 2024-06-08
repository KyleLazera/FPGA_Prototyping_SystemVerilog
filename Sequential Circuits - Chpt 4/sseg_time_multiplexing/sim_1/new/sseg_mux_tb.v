`timescale 1us / 1ps


module sseg_mux_tb();

//Declerations
localparam T = 600;  //clk period
logic clk;
logic [3:0] btn;
logic [7:0] in, sseg;
logic [3:0] an;

//Instantiate module
led_patterns_wrapper uut(.clk(clk), .btn(btn), .sw(in), .an(an), .sseg(sseg));

//Clock - 20ns run forever
always
begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

initial
begin

    in = 8'b10111011;

    repeat(10) @(negedge clk); //Wait for negative edge of clock
    btn[0] = 1'b0;
    btn[1] = 1'b0;
    btn[2] = 1'b0;
    btn[3] = 1'b1;
    
    
    repeat(10) @(negedge clk); //Wait for negative edge of clock
    btn[0] = 1'b0;
    btn[1] = 1'b1;
    btn[2] = 1'b1;
    btn[3] = 1'b1;
    
    repeat(10) @(negedge clk); //Wait for negative edge of clock
    btn[0] = 1'b1;
    btn[1] = 1'b0;
    btn[2] = 1'b1;
    btn[3] = 1'b1;
    
    repeat(10) @(negedge clk); //Wait for negative edge of clock
    btn[0] = 1'b1;
    btn[1] = 1'b1;
    btn[2] = 1'b0;
    btn[3] = 1'b1;
    
    repeat(10) @(negedge clk); //Wait for negative edge of clock
    btn[0] = 1'b1;
    btn[1] = 1'b1;
    btn[2] = 1'b1;
    btn[3] = 1'b0;                
    
    
          
$stop;

end            

endmodule
