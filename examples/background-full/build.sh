#!/bin/bash

# Remove old
rm cart.nes

# Build

../../compiler/asm6 src/cart.asm cart.nes

# Run

fceux cart.nes