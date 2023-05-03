int main() {
    int a = 1;
    int b = 2;
    int c = a + b;
}

/*
 * Define the entry point of the program.
 */
__attribute__((section(".text.start")))
void _start(void)
{
	main();
}