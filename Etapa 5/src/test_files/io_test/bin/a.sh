#!/bin/bash

sisa-as ../$1.S -o $1
sisa-objcopy -O binary -j .text $1 $1.bin
hexdump $1.bin > ../hex/$1.hex
rm $1.bin
