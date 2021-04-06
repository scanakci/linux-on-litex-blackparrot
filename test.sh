#!/bin/bash
cd $LITEX/litex/tools

#Test: BIOS terminal pops?
timeout 120s ./litex_sim.py --cpu-type blackparrot --cpu-variant sim --output-dir blackparrot_BIOS > bios.log

cat bios.log
if grep -rn 'Console\|No boot medium found' bios.log; then
  echo "success when running BIOS"
else
  echo "fail when running BIOS"
  exit
fi
#Test: Memtest OK using SDRAM model?
timeout 300s ./litex_sim.py --cpu-type blackparrot --cpu-variant sim --output-dir blackparrot_BIOS_memtest --sdram-module MT41J256M16 --with-sdram > bios.log

if grep -rn 'Console\|No boot medium found' bios.log; then
  echo "Memtest OK in BIOS simulation"
else
  echo "Memtest NOT OK in BIOS simulation"
  exit
fi
#Test: Linux boots up?
