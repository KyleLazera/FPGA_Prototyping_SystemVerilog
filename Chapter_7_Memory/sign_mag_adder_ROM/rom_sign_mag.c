#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#define MAX_VALUE 7
#define SUM(x,y) ((x) + (y))
#define DIFF(x, y) ((x) - (y))

void convert_to_4_bits(int8_t num, FILE* file)
{
    for(int i = 3; i >= 0; i--){
        //print each bit at a time
        fprintf(file, "%d", (num >> i) & 1);
    }
    
    fprintf(file, "      ");
}

void convert_to_8_bits(int8_t num, FILE* file)
{
    for(int i = 7; i >= 0; i--){
        //print each bit at a time
        fprintf(file, "%d", (num >> i) & 1);
    }
    
    fprintf(file, "      ");
}

uint8_t sign_mag_adder(uint8_t a, uint8_t b)
{
    uint8_t sign_a, sign_b, sign_sum; //1 means negative and 0 means positive
    uint8_t mag_a, mag_b, mag_sum;

    //Determine the signs of the inputs
    sign_a = ((a & 0x08) != 0) ? 1 : 0;  
    sign_b = ((b & 0x08) != 0) ? 1 : 0;

    //Determine magnitude of input
    mag_a = (a & 0x07);
    mag_b = (b & 0x07);

    //If signs are the same, simply add magnitudes together and append sign at front
    if(sign_a == sign_b)
    {
        //Is sum of magnitudes is greater than maximum value (7 for 4 bit output) set the output to 0
        mag_sum = (SUM(mag_a, mag_b) > MAX_VALUE)? 0 : SUM(mag_a, mag_b);
        sign_sum = sign_a;
    }
    else
    {
        //Subtract smaller mag from larger mag
        mag_sum = DIFF(fmax(mag_a, mag_b),fmin(mag_a, mag_b));
        //Carry over sign of the largest magnitude
        sign_sum = (mag_a > mag_b) ? sign_a : sign_b;
    }

    return ((sign_sum << 3) | mag_sum);
}

//Define an algorithm that produces a 2^8-to-4 truth table for a 2 (4-bit)input sign
//magnitude adder
int main()
{
    FILE *file = fopen("sign_mag_tt.txt", "w");
    uint8_t input_8_bits, output_4_bits;
    uint8_t temp_a, temp_b;   

    if(file == NULL)
    {
        printf("Error opening file!\n");
        return 1;
    }

    //Iterate over all possible values for an 8-bit number
    for(uint16_t input = 0; input <= 255; input++)
    {
        input_8_bits = (uint8_t)input;

        //Seperate the 8 bit number into 2 nibbles (input 1 and input 2)
        temp_a = ((input & 0x00F0) >> 4);
        temp_b = (input & 0x000F);
        output_4_bits = sign_mag_adder(temp_a, temp_b);

        //convert_to_8_bits(input_8_bits, file);
        convert_to_4_bits(output_4_bits, file);
        fprintf(file, "\n");
    }


    fclose(file);

    return 0;
}