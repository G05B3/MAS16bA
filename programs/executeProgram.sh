#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <my_program.mas> <number of cycles>"
    return
fi

# Assign the argument to a variable
input_file="$1"
cycles="$2"

cd ../assembler
source gen_tb.sh ../programs/$1 $2
cd ../programs
if [ -e ${1%.mas}.v ]; then
	mv "${1%.mas}.v" ../testbench/program.v
	cd ../testbench

	./sim_rtl.sh
	cd ../programs

	gtkwave ../testbench/dump.vcd &

	echo "Finished Executing $1"
else
	echo "Failed to generate ${1%.mas}.v"
fi

