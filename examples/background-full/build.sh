#!/bin/bash

# Remove old

rm cart.nes

# Lint source

node ../../tools/lint6502.js

# Build

../../assembler/asm6 src/cart.asm cart.nes

# Run

fceux cart.nes