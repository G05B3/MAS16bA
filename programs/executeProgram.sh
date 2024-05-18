#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then
    echo "Usage: $0 <my_program.mas> <number of cycles> [-v]"
    return
fi
# Assign the argument to a variable
input_file="$1"
cycles="$2"
verbose=false

if [ "$#" -eq 3 ] && [ "$3" = "-v" ]; then
    verbose=true
else
    verbose=false
fi

cd ../assembler
source gen_tb.sh ../programs/$1 $2
cd ../programs
if [ -e ${1%.mas}.v ]; then
	mv "${1%.mas}.v" ../testbench/program.v
	cd ../testbench

	./sim_rtl.sh
	cd ../programs

	if [ "$verbose" = true ]; then
		gtkwave ../testbench/dump.vcd &
	fi

	echo "Finished Executing $1"
else
	echo "Failed to generate ${1%.mas}.v"
fi

