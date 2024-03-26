#!/bin/bash

sisa-objcopy -O binary -j .text $1 $1.bin
hexdump $1.bin > $1.hex
rm $1.bin
