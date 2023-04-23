/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

#include <stdint.h>
#include <stdbool.h>

#define MEM_TOTAL 0x20000 /* 128 KB */
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
/*
 * PicoSoC Utilities
 */

void init_picosoc(void)
{
	// set up UART
	reg_uart_clkdiv = 104; 
}

void putchar(char c)
{
	reg_uart_data = c;
}

void print_str(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_hex(uint32_t v, int digits)
{
	for (int i = 7; i >= 0; i--) {
		char c = "0123456789abcdef"[(v >> (4*i)) & 15];
		if (c == '0' && i >= digits) continue;
		putchar(c);
		digits = i;
	}
}

void print_dec(int v)
{
    if (v < 0) {
        putchar('-');
        v = -v;
    }

    char digits[10];
    int i = 0;
    do {
        digits[i++] = (v % 10) + '0';
        v /= 10;
    } while (v != 0);

    while (i > 0) {
        putchar(digits[--i]);
    }
}

char getchar_prompt(char *prompt)
{
	int32_t c = -1;

	uint32_t cycles_begin, cycles_now, cycles;
	__asm__ volatile ("rdcycle %0" : "=r"(cycles_begin));


	if (prompt)
		print_str(prompt);

	while (c == -1) {
		__asm__ volatile ("rdcycle %0" : "=r"(cycles_now));
		cycles = cycles_now - cycles_begin;
		if (cycles > 12000000) {
			if (prompt)
				print_str(prompt);
			cycles_begin = cycles_now;
		}
		c = reg_uart_data;
	}

	return c;
}

char getchar()
{
	return getchar_prompt(0);
}

/*
 * Prime Number Calculation
 */

bool is_prime(int n) {
    if (n <= 1) {
        return false;
    }
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            return false;
        }
    }
    return true;
}

void calculate_prime() {
	int threshold = 50;

    if (threshold <= 1) {
        print_str("Error: Illegal threshold value. Please enter a value greater than 1.\n");
    }

    int prime_count = 0;
    for (int i = 2; i < threshold; i++) {
        if (is_prime(i)) {
            prime_count++;
            print_dec(i);
            putchar('\n');
        }
    }
}

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
	putchar('\n');
}

void main()
{
	// Initialize PicoSoC
	init_picosoc();

	// Your Code
	run_accelerator();
	// calculate_prime();

	// End of Program
	putchar(-1);
}