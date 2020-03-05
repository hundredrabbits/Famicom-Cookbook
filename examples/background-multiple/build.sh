#!/bin/bash

# Remove old
rm cart.nes

# Build

../../assembler/asm6 src/cart.asm cart.nes

# Run

fceux cart.nes