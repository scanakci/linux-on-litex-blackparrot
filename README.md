[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/scanakci/linux-on-litex-blackparrot.svg?branch=master)](https://travis-ci.org/scanakci/linux-on-litex-blackparrot)

# BlackParrot in LiteX

This repository presents necessary steps to run Linux on FPGA and simulation level using BP core integrated into LiteX.
> **Note:** Tested on Ubuntu 18.04

> **Note:** Since both BlackParrot and Litex are under active development, newer updates on LiteX or BP can cause some compatibility issues. If the most recent BP and LiteX do not work, please switch to to following commits (by updating their submodules as well):
```
LiteX: c136113a9b71cbcbdf525aaad38acb012f4a12f3
LiteDRAM: fe478382e16ff3592e07774580c96bde0dc82da3
litex-boards: c7404e356f737a58be4527b3ae8de20fce96defd
blackparrot: 7eb1037637d8515a259e204117b7b1273b1c2941
```
> Also copy the files and folders in patch_files to the following paths:
```
core.py -> litex/soc/cores/cpu/blackparrot/
setEnvironment.sh -> litex/soc/cores/cpu/blackparrot/
Makefile -> litex/soc/software/bios/
bp_litex/ -> litex/soc/cores/cpu/blackparrot/
```
## FPGA Demo

https://www.youtube.com/watch?v=npeDkfEMsoI&feature=youtu.be


## Prerequisites

```
$ sudo apt install build-essential device-tree-compiler wget git python3-setuptools libevent-dev libjson-c-dev
$ sudo apt install verilator # for simulation
$ git clone https://github.com/enjoy-digital/linux-on-litex-blackparrot

```
## Installing LiteX

```
$ wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
$ chmod +x litex_setup.py
$ ./litex_setup.py init install --user
```

## Installing RISC-V toolchain
```
$ ./litex_setup.py gcc 
```
Do not forget to add RISC-V toolchain binary path to your PATH.

 
## Set necessary environment variables for BlackParrot

Add the following lines to your bashrc to set up BlackParrot environment variables

```
pushd .
cd  PATH/TO/LITEX/litex/soc/cores/cpu/blackparrot
source ./setEnvironment.sh
popd
```

## Pre-built Bitstream and BBL
Pre-built bistream for Genesys Kintex 2 and pre-built Berkeley boot loader (bbl) can be found in the prebuilt folder.

## Running Linux 


### Simulation
First modify $LITEX/litex/litex_sim.py by replacing soc.add_constant("ROM_BOOT_ADDRESS", 0x40000000) with soc.add_constant("ROM_BOOT_ADDRESS", 0x80000000)

Next, launch simulation.
```
$ cd linux-on-litex-blackparrot
$ $LITEX/litex/litex_sim.py --cpu-type blackparrot --cpu-variant standard --integrated-rom-size 40960 --output-dir $PWD/build/BP_linux_simu/ --ram-init prebuilt/simulation/Genesys2/bbl

```

### FPGA
Generate the bitstream 'top.bit' under build/BP_trial/gateware folder
```
$LITEX/litex/boards/genesys2.py --cpu-type blackparrot --cpu-variant standard --output-dir $PWD/build/BP_Trial --integrated-rom-size 51200 --build  
```
In another terminal, launch LiteX terminal.
```
cd linux-on-litex-blackparrot
sudo $LITEX/litex/tools/litex_term.py /dev/ttyUSBX --images images.json --no-crc
```
Load the FPGA bitstream top.bit to your FPGA (you can use vivado hardware manager)

This step will boot up LinuX after copying bbl to DRAM through UART. The whole process will take roughly 15 minutes. 

## Generating the BBL (optional TODO) 

```sh
$ git clone freedom-sdk
$ cd freedom-sdk
$ make bbl
```
The BBL is located in *work/riscv-pk/*. #todo double check


