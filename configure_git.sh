#!/bin/bash
cd lnbits
# Check if the upstream remote is already configured
if ! git remote -v | grep -q "upstream"; then
    git remote rename origin upstream
fi
# Check if the origin remote is your fork
if ! git remote -v | grep -q "andre-amorim/lnbits"; then
    git remote add origin https://github.com/andre-amorim/lnbits.git
fi
git remote set-url origin https://github.com/andre-amorim/lnbits.git
git fetch origin
