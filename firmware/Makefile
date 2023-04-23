
RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /data/picorv32-utils/riscv32
CROSS = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)imc/bin/riscv32-unknown-elf-

prime: prime.elf prime.hex

prime.hex: prime.elf
	$(CROSS)objcopy -O verilog $^ $@

prime.elf: prime.c sections.lds start.s
	$(CROSS)gcc $(CFLAGS) -Det4351 -mabi=ilp32 -march=rv32imc -Wl,--build-id=none,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ start.s $< uart.c


dummy_accel: dummy_accel.elf dummy_accel.hex

dummy_accel.hex: dummy_accel.elf
	$(CROSS)objcopy -O verilog $^ $@

dummy_accel.elf: dummy_accel.c sections.lds start.s
	$(CROSS)gcc $(CFLAGS) -Det4351 -mabi=ilp32 -march=rv32imc -Wl,--build-id=none,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ start.s $< uart.c

hello: hello.elf hello.hex

hello.hex: hello.elf
	$(CROSS)objcopy -O verilog $^ $@

hello.elf: hello.c sections.lds start.s
	$(CROSS)gcc $(CFLAGS) -Det4351 -mabi=ilp32 -march=rv32imc -Wl,--build-id=none,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ start.s $< uart.c


# ---- Clean ----
clean:
	rm -f prime.elf prime.hex
	rm -f dummy_accel.elf dummy_accel.hex
	rm -f hello.elf hello.hex

.PHONY: clean
.PHONY: et4351_sim