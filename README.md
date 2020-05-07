[Logo](docs/bp_litex_logo.png) TODO: add a logo

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
# BlackParrot in LiteX
> **Note:** Tested on Ubuntu 18.04

## FPGA Demo (TODO: update video)
[![asciicast](https://asciinema.org/a/326077.svg)](https://asciinema.org/a/326077)


## Prerequisites

```
$ sudo apt install build-essential device-tree-compiler wget git python3-setuptools libevent-dev libjson-c-dev
$ sudo apt install verilator # for simulation
$ git clone https://github.com/enjoy-digital/linux-on-litex-blackparrot
$ cd linux-on-litex-blackparrot
```

## Installing LiteX and a RISC-V toolchain

```
$ wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
$ chmod +x litex_setup.py
$ ./litex_setup.py init
$ sudo ./litex_setup.py install
$ sudo ./litex_setup.py gcc
$ source ./setEnvironment.sh # set necessary environment variables for BP (should be sourced each time you open a terminal or just add this line to bashrc)
```

## Pre-built Bitstream and BBL
Pre-built bistream for Genesys Kintex 2 and pre-built Berkeley boot loader (bbl) can be found in the prebuilt folder.

## Running BIOS 

### Simulation
```
cd $LITEX/litex/tools
./litex_sim.py --cpu-type blackparrot --cpu-variant standard --output-dir build/BP_Trial
```

### FPGA
```
Coming soon!
```

## Running Linux 


### Simulation
```
Modify litex_sim.py by replacing soc.add_constant("ROM_BOOT_ADDRESS", 0x40000000) with soc.add_constant("ROM_BOOT_ADDRESS", 0x80000000)

./litex_sim.py --cpu-type blackparrot --cpu-variant standard --integrated-rom-size 40960 --output-dir build/BP_newversion_linux_ram/ --threads 4 --ram-init build/tests/boot.bin.uart.simu.trial

```

### FPGA (Coming soon!)

```
$ Load the FPGA bitstream
$ Load the Linux images over Serial
$ $LITEX/litex/tools/litex_term --images=images.json /dev/ttyUSBX --no-crc
```
## Generating the BBL (optional) 

```sh
$ git clone freedom-sdk
$ cd freedom-sdk
$ make bbl
```
The BBL is located in *work/riscv-pk/*. #todo double check


