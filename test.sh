#!/bin/bash
cd $LITEX/litex/tools

timeout 180s ./litex_sim.py --cpu-type blackparrot --cpu-variant standard --integrated-rom-si    ze 40960 --output-dir build/blackparrot_BIOS > bios.log

#Test: BIOS terminal pops?
if grep -rnq 'Console\|No boot medium found' hi; then
  echo "success test1"
else
  echo "fail when running BIOS"
  exit

#Test: Linux boots up?
