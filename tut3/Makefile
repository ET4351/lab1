CROSS = /data/picorv32-utils/riscv32imc/bin/riscv32-unknown-elf-
CFLAGS = -O0

sum.elf: sum.c linkerscript.ld
	$(CROSS)gcc $(CFLAGS) -march=rv32imc \
		-T linkerscript.ld \
		-nostdlib \
		-o $@ \
		$<

clean:
	rm -f sum.elf

.PHONY: clean