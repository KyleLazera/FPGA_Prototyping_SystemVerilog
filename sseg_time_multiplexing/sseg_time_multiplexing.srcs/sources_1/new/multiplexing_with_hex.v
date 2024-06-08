`timescale 1ns / 1ps

module multiplexing_with_hex
(
    input logic clk, rst,
    input logic [3:0] hex0, hex1, hex2, hex3,       //Hex input vals
    input logic [3:0] dp_in,                        //Decimal point control
    output logic [7:0] sseg,                        //Ouput that drives sseg
    output logic [3:0] an                          //sseg selector
);

//Local Params
localparam N = 18;

//Signal instantiations
logic [N-1:0] d_next, q_reg;                        //Input and ouput for FF
logic [3:0] hex_out;
logic dp;

//Memory Block
always_ff @(posedge clk, posedge rst)
begin
    if(rst)
        q_reg <= 1'b0;
    else
        q_reg <= d_next;
end

//Next State Logic - Binary Counter
assign d_next = q_reg + 1;

//End-State Logic - time multiplexer
always_comb
begin
    case(q_reg[N-1:N-2])
        2'b00:
            begin
                hex_out = hex0;
                an = 4'b1110;
                dp = dp_in[0];
            end
        2'b01:
            begin
                hex_out = hex1;
                an = 4'b1101;
                dp = dp_in[1];
            end
        2'b10:
            begin
                hex_out = hex2;
                an = 4'b1011;
                dp = dp_in[2];
            end
        2'b11:
            begin
                hex_out = hex3;
                an = 4'b0111;
                dp = dp_in[3];
            end
    endcase
end

/*Hex to 8 bit decoder
always_comb
begin
    case(hex_out)
        4'h0: sseg = {dp, 7'b1000000};
        4'h1: sseg = {dp, 7'b1111001};
        4'h2: sseg = {dp, 7'b0100100};
        4'h3: sseg = {dp, 7'b0110000};
        4'h4: sseg = {dp, 7'b0011001};
        4'h5: sseg = {dp, 7'b0010010};
        4'h6: sseg = {dp, 7'b0000010};
        4'h7: sseg = {dp, 7'b1111000};
        4'h8: sseg = {dp, 7'b0000000};
        4'h9: sseg = {dp, 7'b0010000};
        4'ha: sseg = {dp, 7'b0001000};
        4'hb: sseg = {dp, 7'b0000011};
        4'hc: sseg = {dp, 7'b1000110};
        4'hd: sseg = {dp, 7'b0100001};
        4'he: sseg = {dp, 7'b0000110};
        default: sseg = {dp, 7'b0001110};       //4'hf
    endcase
end*/
always_comb
begin
    case(hex_out)
        4'h0: sseg[6:0] = 7'b1000000;
        4'h1: sseg[6:0] = 7'b1111001;
        4'h2: sseg[6:0] = 7'b0100100;
        4'h3: sseg[6:0] = 7'b0110000;
        4'h4: sseg[6:0] = 7'b0011001;
        4'h5: sseg[6:0] = 7'b0010010;
        4'h6: sseg[6:0] = 7'b0000010;
        4'h7: sseg[6:0] = 7'b1111000;
        4'h8: sseg[6:0] = 7'b0000000;
        4'h9: sseg[6:0] = 7'b0010000;
        4'ha: sseg[6:0] = 7'b0001000;
        4'hb: sseg[6:0] = 7'b0000011;
        4'hc: sseg[6:0] = 7'b1000110;
        4'hd: sseg[6:0] = 7'b0100001;
        4'he: sseg[6:0] = 7'b0000110;
        default: sseg[6:0] = 7'b0001110;       //4'hf
    endcase
    sseg[7] = dp;
end

endmodule
