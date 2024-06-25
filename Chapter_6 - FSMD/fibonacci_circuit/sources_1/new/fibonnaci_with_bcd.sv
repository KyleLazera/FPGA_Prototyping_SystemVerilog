`timescale 1ns / 1ps

/* This design will be of a fibonnaci circuit that takes in a BCD value and outputs a
* BCD value to be displayed on a seven segment display. The BCD input value will be restricted
* to 2 BCD digits (8 bits) and will also take in a start signal indicating for the circuit to begin
* operation. It will then output up to 4 BCD digits, therefore the highest value it could be is
* 9999.
* This project was implemented in one module with an FSMD to allow for reuse of teh BCD shift registers 
* which would reduce the number of FF's needed in the project.
*/
module fibonnaci_with_bcd
#(COUNTER_WIDTH = 27)
(
    input logic clk, reset,
    input logic start,                                                  //Used to start the circuit 
    output logic ready,                                                 //indicates the circuit is ready to be used (not computing)
    input logic [3:0] bcd_in [1:0],                                     //index input in BCD format
    output logic [3:0] bcd_out [3:0]                                    //Fibonacci output in BCD format
);

//This will allow fib circuit to run at 1Hz freq (100000000 * 10ns) = 1000000000ns which is 1 second period
localparam COUNTER_FINAL = 100000000;                                    

//Declaring FSM states
typedef enum {idle, bcd_to_bin, bin_to_bcd, fibonacci} state_type;

/*****Signal Declerations********/
//State register declerations
state_type state_reg, state_next;
//BCD shift reg declerations 
logic [3:0] bcd_shift_reg [3:0], bcd_shift_next [3:0];
logic [3:0] bcd_temp_reg [3:0];
logic [13:0] bin_shift_reg, bin_shift_next;                                  
logic [3:0] bcd_index_reg, bcd_index_next;                              //Index to keep track of BCD-to-bin or vice versa
//Fibonacci registers
logic [7:0] fib_index_reg, fib_index_next;                              //index to keep track of the fibonacci seq
logic [13:0] fib_reg[1:0], fib_next[1:0];                               //Used to hold fibonacci values
logic [COUNTER_WIDTH-1:0] counter_reg, counter_next;                    //Tick registers to set frequency for fibonacci circuit (for visual display)
logic [3:0] final_bcd_reg[3:0], final_bcd_next[3:0];                    //Used for the output value

//Wire declerations
logic [3:0] bcd_increment[3:0];
logic [3:0] bcd_decrement[1:0];
logic done;
logic conversion_dir;                                                   //1 indicates bcd to binary and 0 indicates binary to bcd

always_ff @(posedge clk, posedge reset)
begin
    if(reset)
        begin
            for(int i = 0; i < 4; i++)
            begin
                bcd_shift_reg[i] <= 0;
                final_bcd_reg[i] <= 0;
            end     
            fib_reg[0] <= 0; 
            fib_reg[1] <= 0;       
            state_reg <= idle;
            bin_shift_reg <= 0;
            counter_reg <= 0;
            fib_index_reg <= 0;
            bcd_index_reg <= 0;

        end
    else
        begin
            state_reg <= state_next;
            bcd_shift_reg <= bcd_shift_next;
            bcd_index_reg <= bcd_index_next;
            bin_shift_reg <= bin_shift_next;
            counter_reg <= counter_next;
            fib_reg <= fib_next;
            fib_index_reg <= fib_index_next;
            final_bcd_reg <= final_bcd_next;
        end
end

always_comb
begin
    //Assign default values for the registers
    state_next = state_reg;
    bcd_shift_next = bcd_shift_reg;
    bin_shift_next = bin_shift_reg;
    bcd_index_next = bcd_index_reg;
    fib_index_next = fib_index_reg;
    final_bcd_next = final_bcd_reg;
    counter_next = counter_reg + 1;
    fib_next = fib_reg;
    //Assign default values for wires
    ready = 1'b0;
    done = 1'b0;
    conversion_dir = 1'b0;
    //Control Path (FSM)
    case(state_reg)
        idle:
            begin
                ready = 1'b1;
                if(start)
                    begin
                        //Init FF's for BCD to binary conversion
                        bcd_index_next = 4'b0111;
                        bcd_shift_next[0] = {bcd_in[1][0], bcd_in[0][3:1]};
                        bcd_shift_next[1] = bcd_in[1] >> 1;
                        bin_shift_next = {bcd_in[0][0], 13'b0};
                        //Init FF's for fibonacci circuit with 0 and 1
                        fib_next[0] = 15'b0;
                        fib_next[1] = 15'b1;
                        conversion_dir = 1'b1;
                        //Next State:
                        state_next = bcd_to_bin;
                    end
            end
        bcd_to_bin:
            begin  
                conversion_dir = 1'b1;                   
                //If converting from BCD to binary shift to the right
                bcd_shift_next[0] = {bcd_temp_reg[1][0], bcd_temp_reg[0][3:1]};
                bcd_shift_next[1] = bcd_temp_reg[1] >> 1;
                bin_shift_next = {bcd_temp_reg[0][0], bin_shift_reg[13:1]}; 
                //Check index after shift
                if(bcd_index_reg == 0)
                    begin
                        fib_index_next = bin_shift_reg[13:6];   //Only specifcy the first 8-bits
                        state_next = fibonacci;
                    end                       
                else
                    bcd_index_next = bcd_index_reg - 1;
             end
        bin_to_bcd:
            begin
                conversion_dir = 1'b0;                        
                //Ensure the fibonacci number is not greater than 9999 (in decimal)
                bcd_shift_next[0] = {bcd_temp_reg[0][2:0], bin_shift_reg[13]};
                bcd_shift_next[1] = {bcd_temp_reg[1][2:0], bcd_temp_reg[0][3]};
                bcd_shift_next[2] = {bcd_temp_reg[2][2:0], bcd_temp_reg[1][3]};
                bcd_shift_next[3] = {bcd_temp_reg[3][2:0], bcd_temp_reg[2][3]};                                
                bin_shift_next = bin_shift_reg << 1;
                //Check index after shift
                if(bcd_index_reg == 4'b1110)
                    begin
                        bcd_index_next = 4'b0;
                        for(int i = 0; i < 4; i++)
                            final_bcd_next[i] = bcd_shift_reg[i];
                        state_next = fibonacci;                     
                    end 
                else
                    bcd_index_next = bcd_index_reg + 1;              
            end         
                
                  
        fibonacci:
            begin
                conversion_dir = 1'b0;
                if(counter_reg == COUNTER_FINAL)//Change this to a specific value
                    begin
                        //Reset ticker so fib sequence runs at a regular frequency
                        counter_next = 0;
                        //Reset BCD shift registers so old values dont interfere with new values   
                        for(int i = 0; i < 4; i++)
                            bcd_shift_next[i] = 4'b0;                                                      
                        //Ensure the fibonacci number is not greater than 9999 (in decimal) and load into binary reg
                        bin_shift_next = (fib_reg[0] >= 9999) ? 9999 : fib_reg[0]; 
                        //Compute next number in the fibonacci sequence           
                        fib_next[0] = fib_reg[1];
                        fib_next[1] = fib_reg[0] + fib_reg[1]; 
                        
                        if(fib_index_reg != 0)
                            begin
                                fib_index_next = fib_index_reg - 1;
                                state_next = bin_to_bcd;
                            end
                        else
                            state_next = idle;
                    end
            end        
        default : state_next = idle;                        
    endcase
end

/*********Next State Logic************/
//This is used as a continous assignment to increment each BCD register if condition is met
assign bcd_increment[0] = (bcd_shift_reg[0] > 4) ? bcd_shift_reg[0] + 3 : bcd_shift_reg[0];
assign bcd_increment[1] = (bcd_shift_reg[1] > 4) ? bcd_shift_reg[1] + 3 : bcd_shift_reg[1];
assign bcd_increment[2] = (bcd_shift_reg[2] > 4) ? bcd_shift_reg[2] + 3 : bcd_shift_reg[2];
assign bcd_increment[3] = (bcd_shift_reg[3] > 4) ? bcd_shift_reg[3] + 3 : bcd_shift_reg[3];
//Used to decrement BCD registers if condition is met
assign bcd_decrement[0] = (bcd_shift_reg[0] > 4) ? bcd_shift_reg[0] - 3 : bcd_shift_reg[0];
assign bcd_decrement[1] = (bcd_shift_reg[1] > 4) ? bcd_shift_reg[1] - 3 : bcd_shift_reg[1];

assign bcd_temp_reg[0] = (conversion_dir) ? bcd_decrement[0] : bcd_increment[0];
assign bcd_temp_reg[1] = (conversion_dir) ? bcd_decrement[1] : bcd_increment[1];
assign bcd_temp_reg[2] = (conversion_dir) ? bcd_shift_reg[2] : bcd_increment[2];
assign bcd_temp_reg[3] = (conversion_dir) ? bcd_shift_reg[3] : bcd_increment[3];

//Output Value
assign bcd_out = final_bcd_reg;

endmodule
