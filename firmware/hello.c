/*##########################################################################
###
### RISC-V PicoSoC Firmware: Hello World
###
###     TU Delft ET4351
###     April 2023, C. Gao
###
##########################################################################*/

#include "uart.h"

void hello() {
	print_str("Hello, World!\n");
}

void main()
{
	// Initialize PicoSoC
	init_uart();

	// Your Code
	hello();

	// End of Program
	print_char(-1);
}