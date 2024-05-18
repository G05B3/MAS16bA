#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <my_program.mas> <number of cycles>"
    return
fi

# Assign the argument to a variable
input_file="$1"
cycles="$2"
hex_file="${input_file%.mas}.hex"
output_file="${input_file%.mas}.v"

# Run the asm program with the -h flag
./asm "$input_file" -h

# Check if the hex file was created successfully
if [ ! -f "$hex_file" ]; then
    echo "Error: Failed to create $hex_file"
    return
fi

# Begin writing the output file
{
    echo "\`define NUM_INSTRUCTIONS "$cycles"\n\ntask program(); begin"
    while read -r line; do
        if [ -z "$first" ]; then
            echo "	instr = 16'h$line;"
            first=false
        else
            echo "	#10 instr = 16'h$line;"
        fi
        done < "$hex_file"
    echo 'end
endtask'
} > "$output_file"

rm "$hex_file"

echo "Output written to $output_file"

