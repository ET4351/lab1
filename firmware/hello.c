/*##########################################################################
###
### RISC-V PicoSoC Firmware: Hello World
###
###     TU Delft ET4351
###     April 2023, C. Gao
###
##########################################################################*/

#include "uart.h"

void say_hello() {
	print_str("Hello, World!\n");
}

void main(void)
{
	// Initialize PicoSoC
	init_uart();

	// Your Code
	say_hello();

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