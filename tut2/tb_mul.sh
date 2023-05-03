#!/bin/bash

# make sure we are in the correct directory
cd "$(dirname "$0")"  

# set work library
workLib=workLib
rm -rf ${workLib}
vlib ${workLib}
vmap work ${workLib}

# Compile the Design Under Test (DUT)
vlog -sv mul.sv tb_mul.sv -timescale 1ns/1ps

vsim -voptargs=+acc tb_multiplier_32bit -do tb_mul.cmd -t 100ps