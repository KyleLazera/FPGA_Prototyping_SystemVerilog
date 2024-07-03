#include <stdio.h>
#include <stdint.h>

#define C_TO_F(x) (((9.0/5.0) * x) + 32.0)
#define F_TO_C(y) ((y - 32.0)*(5.0/9.0))

void convert_to_8_bits(int8_t num, FILE* file)
{
    for(int i = 7; i >= 0; i--){
        //print each bit at a time
        fprintf(file, "%d", (num >> i) & 1);
    }
    
    fprintf(file, "\n");
}

int main()
{
    FILE *c_file, *f_file;
    f_file = fopen("C_to_F_conversion.txt", "w");
    c_file = fopen("F_to_C_conversion.txt", "w");
    uint8_t converted_value;

    if(c_file == NULL || f_file == NULL)
    {
        printf("Error opening file!\n");
        return 1;
    }

    //For Loop used to generate the Celcius to Farnheit values (range form 0 to 100)
    for(uint8_t i = 0; i < 101; i++)
    {
        converted_value = C_TO_F(i);
        convert_to_8_bits(converted_value, f_file);
    }

    //For Loop used to generate the Farenheit to Celcius values (range from 32 to 212)
    for(uint8_t i = 32; i < 213; i++)
    {
        converted_value = F_TO_C(i);
        convert_to_8_bits(converted_value, c_file);
    }

    fclose(c_file);
    fclose(f_file);

    return 0;
}