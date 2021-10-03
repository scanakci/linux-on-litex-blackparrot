export PATH := $(wildcard $(PWD)/riscv64-*/bin/):$(PATH)

prebuilt/fpga/Arty/digilent_arty.bit:
	litex-boards/litex_boards/targets/digilent_arty.py --build \
		--sys-clk-freq 20e6 --cpu-type blackparrot --cpu-variant standard \
		--variant=a7-100 --csr-csv "csr-arty.csv"
	cp build/digilent_arty/gateware/digilent_arty.bit prebuilt/fpga/Arty/digilent_arty.bit

prebuilt/fpga/boot_digilent_arty.bin:
	cd freedom-u-sdk && \
	git submodule update --init --recursive
	$(MAKE) -C freedom-u-sdk bbl LITEX_MODE=-DLITEX_MODE
	riscv64-unknown-elf-objcopy -O binary freedom-u-sdk/work/riscv-pk/bbl prebuilt/fpga/Arty/boot_digilent_arty.bin

arty: prebuilt/fpga/Arty/digilent_arty.bit prebuilt/fpga/Arty/boot_digilent_arty.bin
	mkdir -p build/digilent_arty/gateware
	cp prebuilt/fpga/Arty/digilent_arty.bit build/digilent_arty/gateware
	litex-boards/litex_boards/targets/digilent_arty.py --load \
		--sys-clk-freq 20e6 --cpu-type blackparrot --cpu-variant standard \
		--variant=a7-100 --csr-csv "csr-arty.csv"
	lxterm /dev/ttyUSB* --kernel prebuilt/fpga/Arty/boot_digilent_arty.bin --kernel-adr 0x80000000 --speed=115200

prebuilt/simulation/boot_simulation.bin:
	cd freedom-u-sdk && \
	git submodule update --init --recursive && \
	$(MAKE) -C freedom-u-sdk bbl LITEX_MODE=-DLITEX_MODE
	riscv64-unknown-elf-objcopy -O binary freedom-u-sdk/work/riscv-pk/bbl prebuilt/simulation/boot_simulation.bin

simulation: prebuilt/simulation/boot_simulation.bin
	litex_sim --cpu-type blackparrot \
		--cpu-variant standard \
		--with-sdram \
		--sdram-init prebuilt/simulation/boot_simulation.bin

simulation-non-interactive: prebuilt/simulation/boot_simulation.bin
	litex_sim --cpu-type blackparrot \
		--cpu-variant standard \
		--with-sdram \
		--non-interactive \