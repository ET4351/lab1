
RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /data/picorv32-utils/riscv32
CROSS = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)imc/bin/riscv32-unknown-elf-
# CROSS=riscv32-unknown-elf-
CFLAGS=

# et4351_sim: et4351_tb.vvp firmware.hex
# 	vvp -N $<

# et4351_tb.vvp: et4351_tb.v et4351.v accelerator.v spimemio.v simpleuart.v picosoc.v ../picorv32.v spiflash.v
# 	iverilog -s testbench -o $@ $^

all: et4351_sections.lds et4351_fw.elf firmware.hex
	
et4351_sections.lds: sections.lds
	$(CROSS)cpp -P -Det4351 -o $@ $^

et4351_fw.elf: et4351_sections.lds start.s firmware.c
	$(CROSS)gcc $(CFLAGS) -Det4351 -mabi=ilp32 -march=rv32imc -Wl,--build-id=none,-Bstatic,-T,et4351_sections.lds,--strip-debug -ffreestanding -nostdlib -o et4351_fw.elf start.s firmware.c

firmware.hex: et4351_fw.elf
	$(CROSS)objcopy -O verilog $^ $@

# ---- Clean ----
clean:
	rm -f et4351_fw.elf et4351_fw.hex et4351_fw.bin cmos.log et4351_sections.lds firmware.hex

.PHONY: clean
.PHONY: et4351_sim