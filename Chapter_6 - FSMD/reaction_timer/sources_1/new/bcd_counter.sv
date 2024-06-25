`timescale 1ns / 1ps

//A millisecond counter that ouputs BCD values
module bcd_counter
#(
    parameter TICK_WIDTH = 17, 
    parameter COUNTER_WIDTH = 12
)
(
    input logic clk, reset,
    input logic enable,                         // Enables module to begin
    input logic stop, clear,                    //User inputs from top level circuit
    output logic led,                           //LED acts as a "counter" flag so it is driven from this module
    output logic [3:0] ms_value [3:0]           // Output in BCD 
);

// Local Parameters
localparam TICK_FINAL = 100000-1;                 // Creates 1ms tick

//State Declerations
typedef enum {idle,                               //Initial value that module starts in 
              count,                              //The module is activley counting
              convert,                            //Converts teh counted binary value to a BCD value
              stop_count                          //Stops counting - saves current value
              }state_type;

/***** Signal Declarations *******/
state_type state_reg, state_next;
//Counter signals
logic [TICK_WIDTH-1:0] tick_reg, tick_next;
logic [COUNTER_WIDTH-1:0] counter_reg, counter_next;
//BCD conversion signals
logic [COUNTER_WIDTH-1:0] bin_shift_reg, bin_shift_next;
logic [3:0] bcd_shift_reg[3:0], bcd_shift_next[3:0];
logic [3:0] bcd_temp[3:0];
logic [3:0] index_reg, index_next;
logic [3:0] bcd_out_reg[3:0], bcd_out_next[3:0];

always_ff@(posedge clk, posedge reset)
begin
    if(reset)
        begin
            state_reg <= idle;
            tick_reg <= 0;
            counter_reg <= 0;
            bin_shift_reg <= 0;
            index_reg <= 0;
            for(int i = 0; i < 4; i++)
                begin
                    bcd_shift_reg[i] <= 0;
                    bcd_out_reg[i] <= 0;
                end
        end
    else
        begin
            state_reg <= state_next;
            tick_reg <= tick_next;
            counter_reg <= counter_next;
            index_reg <= index_next;
            bcd_shift_reg <= bcd_shift_next;
            bin_shift_reg <= bin_shift_next;
            bcd_out_reg <= bcd_out_next;
        end        
end

always_comb
begin
    //Default values
    state_next = state_reg;
    tick_next = (tick_reg == TICK_FINAL) ? 0 : tick_reg + 1;
    counter_next = (tick_reg == TICK_FINAL) ? counter_reg + 1 : counter_reg;
    bcd_shift_next = bcd_shift_reg;
    bin_shift_next = bin_shift_reg;
    index_next = index_reg;
    bcd_out_next = bcd_out_reg;
    led = 0;
    
    case(state_reg)
        idle:
            begin
                //If stop is pressed before counter immediately go to done state
                if(stop)
                    begin
                        for(int i = 0; i < 4; i++)                            
                                bcd_out_next[i] = 9;
                        state_next = stop_count;                                                      
                    end  
                //If enable signal enters - delay has complete and counting can start             
                else if(enable)
                    begin
                        led = 1'b1;         //Turn on led
                        tick_next = 0;
                        counter_next = 0;
                        bin_shift_next = 0;
                        index_next = 4'b1100;                        
                        state_next = count;
                        for(int i = 0; i < 4; i++)
                            begin
                                bcd_shift_next[i] = 0;
                                bcd_out_next[i] = 0;
                            end                                
                    end                 
            end
        count:
            begin  
                led = 1'b1;              
                //Give main priority to stop
                if(stop)
                    state_next = stop_count;
                //Ensure the counter does not exceed 1000 (user does not take 1 second or more to press stop)                
                else if(counter_reg >= 1000)
                    begin
                        counter_next = 1000;
                        bin_shift_next = 1000;     
                        state_next = stop_count;
                    end
                //If counter has incremented make sure to enter conversion state
                else if(counter_reg != counter_next)
                    begin
                        //Load current counter value into the bin shift register
                        bin_shift_next = counter_next;                                           
                        state_next = convert;  
                    end     
                //if not condition is met remain in counting state                          
                else
                    state_next = count;                                                                                                                             
            end    
        convert:
            begin
                //If stop is pressed during convert ensure it does not make the LED go high
                if(stop)
                    begin
                        state_next = stop_count;
                        led = 1'b0;
                    end
                else
                    led = 1'b1; //LED should still be high during this period
                //Shift the BCD shift registers
                bcd_shift_next[3] = {bcd_temp[3][2:0], bcd_temp[2][3]};
                bcd_shift_next[2] = {bcd_temp[2][2:0], bcd_temp[1][3]};
                bcd_shift_next[1] = {bcd_temp[1][2:0], bcd_temp[0][3]};
                bcd_shift_next[0] = {bcd_temp[0][2:0], bin_shift_reg[COUNTER_WIDTH-1]};
                //Shift binary shift reg
                bin_shift_next = bin_shift_reg << 1;
                //Check index value
                if(index_reg == 0)
                    begin
                        //After conversion is complete, reset all bcd registers 
                        index_next = 4'b1100;   
                        bcd_out_next = bcd_shift_reg;  
                        for(int i = 0; i < 4; i++)
                                bcd_shift_next[i] = 0;
                        state_next = count;
                    end
                else
                    index_next = index_reg - 1;
            end 
        stop_count:
            begin
                led = 1'b0; //Make sure LED turns off
                if(clear)
                    begin
                        //If clear is pressed clear the output immediately and wait for enable 
                        for(int i = 0; i < 4; i++)
                            bcd_out_next[i] = 0;
                        state_next = idle;
                    end
                    
                tick_next = tick_reg;
                counter_next = counter_reg;
                bcd_shift_next = bcd_shift_reg;
            end  
        default: state_next = idle;                                                 
    endcase
end

always_comb
begin
for(int i = 0; i < 4; i++)
    bcd_temp[i] = (bcd_shift_reg[i] > 4) ? bcd_shift_reg[i] + 3 : bcd_shift_reg[i];
end

assign ms_value = bcd_out_reg;

endmodule


