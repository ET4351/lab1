/*##########################################################################
###
### RISC-V PicoSoC Firmware: Dummy Accelerator
###
###     TU Delft ET4351
###     April 2023, C. Gao
###
##########################################################################*/

#include "uart.h"

void run_accelerator() {
	// Define accelerator registers
	#define reg_gpio   (*(volatile uint32_t*)0x03000000)
	#define reg_csr    (*(volatile uint32_t*)0x03000004)
	#define reg_input  (*(volatile uint32_t*)0x03000008)
	#define reg_output (*(volatile uint32_t*)0x0300000C)

	// Define accelerator control/status bits
	#define MASK_CSR_RESET 1 << 0
	#define MASK_CSR_START 1 << 1
	#define MASK_CSR_DONE  1 << 2

	// Initialize accelerator
	reg_gpio   = 0x00000000;
	reg_csr    = 0x00000000;
	reg_input  = 0x00000000;
	reg_output = 0x00000000;

	// Reset accelerator
	reg_csr |= MASK_CSR_RESET;  // set reset bit
	reg_csr &= ~MASK_CSR_RESET; // clear reset bit

	// Set input
	reg_input = 0x00012345;

	// Start accelerator
	reg_csr |= MASK_CSR_START;

	// Wait for accelerator to finish
	while (!(reg_csr & MASK_CSR_DONE));

	// Read output from accelerator
	uint32_t output = reg_output;

	// Print output
	print_str("Accelerator Output: 0x");
	print_hex(output, 8);
	print_char('\n');
}

void main()
{
	// Initialize PicoSoC
	init_uart();

	// Your Code
	run_accelerator();

	// End of Program
	print_char(-1);
}