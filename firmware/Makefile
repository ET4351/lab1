
CROSS = /data/picorv32-utils/riscv32imc/bin/riscv32-unknown-elf-
CFLAGS = -O0

all: prime.hex dummy_accel.hex hello.hex

prime: prime.hex

prime.hex: prime.elf
	$(CROSS)objcopy -O verilog $^ $@

prime.elf: prime.c uart.c linkerscript.ld
	$(CROSS)gcc $(CFLAGS) -march=rv32imc \
		-T linkerscript.ld \
		-nostdlib \
		-o $@ \
		$< uart.c \

dummy_accel: dummy_accel.hex

dummy_accel.hex: dummy_accel.elf
	$(CROSS)objcopy -O verilog $^ $@

dummy_accel.elf: dummy_accel.c uart.c linkerscript.ld
	$(CROSS)gcc $(CFLAGS) -march=rv32imc \
		-T linkerscript.ld \
		-nostdlib \
		-o $@ \
		$< uart.c \

hello: hello.hex

hello.hex: hello.elf
	$(CROSS)objcopy -O verilog $^ $@

hello.elf: hello.c uart.c linkerscript.ld
	# $(CROSS)gcc -march=rv32imc -S hello.c -o hello.s
	# $(CROSS)gcc -c hello.s -o hello.o
	# $(CROSS)gcc -march=rv32imc -S uart.c -o uart.s
	# $(CROSS)gcc -c uart.s -o uart.o
	# $(CROSS)ld -T linkerscript.ld hello.o uart.o -o $@
	# $(CROSS)ld hello.o uart.o -o $@
	$(CROSS)gcc $(CFLAGS) -march=rv32imc \
		-T linkerscript.ld \
		-nostdlib \
		-o $@ \
		$< uart.c

# ---- Clean ----
clean:
	rm -f prime.elf prime.hex
	rm -f dummy_accel.elf dummy_accel.hex
	rm -f hello.elf hello.hex

.PHONY: all
.PHONY: clean
.PHONY: hello
.PHONY: dummy_accel
.PHONY: prime