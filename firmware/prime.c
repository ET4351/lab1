/*##########################################################################
###
### RISC-V PicoSoC Firmware: Prime
###
###     TU Delft ET4351
###     April 2023, C. Gao
###
##########################################################################*/

#include "uart.h"

bool is_prime(int n) {
    for(int i = 2; i < n; i++) {
        if((n % i) == 0) {
            return false;
        }
    }
   return true;
}

void calculate_prime(int threshold) {

    if (threshold <= 1) {
        print_str("Error: Illegal threshold value. Please enter a value greater than 1.\n");
    }

    int prime_count = 0;
    for (int i = 2; i < threshold; i++) {
        if (is_prime(i)) {
            prime_count++;
            print_dec(i);
            print_char('\n');
        }
    }
}

void main(void)
{
	// Initialize PicoSoC
	init_uart();

	// Your Code
	calculate_prime(1000);

	// End of Program
	print_char(-1);
}

/*
 * Define the entry point of the program.
 */
__attribute__((section(".text.start")))
void _start(void)
{
	main();
}