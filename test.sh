#!/bin/bash
cd $LITEX/litex/tools

#Test: BIOS terminal pops?
timeout 180s ./litex_sim.py --cpu-type blackparrot --cpu-variant sim --output-dir blackparrot_BIOS > bios.log

if grep -rnq 'Console\|No boot medium found' bios.log; then
  echo "success when running BIOS"
else
  echo "fail when running BIOS"
  exit

#Test: Memtest OK using SDRAM model?
timeout 300s ./litex_sim.py --cpu-type blackparrot -variant standard --integrated-rom-size 40960 --output-dir blackparrot_BIOS_memtest --csr-data-width=32 --sdram-module MT41J256M16 --with-sdram > bios.log

if grep -rnq 'Console\|No boot medium found' bios.log; then
  echo "Memtest OK in BIOS simulation"
else
  echo "Memtest NOT OK in BIOS simulation"
  exit

#Test: Linux boots up?
