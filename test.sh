#!/bin/bash
# Build and test the game, outputting errors to test-runner/errors.log

cd /mnt/c/Users/ethan/Repos/Journey-to-the-Thingamajig

# Build
export PATH=/home/ethan/.local/haxe:/home/ethan/.local/neko:$PATH
export HAXE_STD_PATH=/home/ethan/.local/haxe/std
export NEKOPATH=/home/ethan/.local/neko
export LD_LIBRARY_PATH=/home/ethan/.local/neko:$LD_LIBRARY_PATH

echo "Building..."
haxelib run lime build html5 2>&1

echo "Running test..."
cd test-runner
cmd.exe /c cscript //nologo run-and-wait.vbs 2>&1

echo "Results:"
head -40 errors.log
