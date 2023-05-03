
##########################################################################
###
### ModelSim script - Behavioral simulation.
###
###     TU Delft EE4615 lecture on the automated digital IC design flow
###     March 2022, C.Gao, C. Frenkel
###
##########################################################################

# Compile
source compile.sh

# Launch the simulation
vsim testbench -c -do run.cmd -t 100ps +firmware=../firmware/hello.hex

