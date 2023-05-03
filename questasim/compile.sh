
##########################################################################
###
### ModelSim script - Behavioral simulation.
###
###     TU Delft EE4615 lecture on the automated digital IC design flow
###     March 2022, C.Gao, C. Frenkel
###
##########################################################################
 
workLib=workLib
rm -rf ${workLib}
vlib ${workLib}
vmap work ${workLib}

# et4351_tb.v et4351.v accelerator.v spimemio.v simpleuart.v picosoc.v ../picorv32.v spiflash.v
# Compile the DUT
vlog ../sourcecode/design/accelerator.v \
     ../sourcecode/design/simpleuart.v \
     ../sourcecode/design/spimemio.v \
     ../sourcecode/design/picosoc.v \
     ../sourcecode/design/picorv32.v \
     ../sourcecode/design/et4351.v \
     +incdir+../sourcecode/include                  -timescale 1ns/1ps

# Compile the testbench 
vlog     ../sourcecode/testbench/spiflash.v +define+BEHAV=1 -timescale 1ns/1ps
vlog -sv ../sourcecode/testbench/et4351_tb.sv +incdir+../sourcecode/include +define+BEHAV=1 -timescale 1ns/1ps
