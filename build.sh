#!/bin/bash
export PATH=/home/ethan/.local/haxe:/home/ethan/.local/neko:$PATH
export HAXE_STD_PATH=/home/ethan/.local/haxe/std
export NEKOPATH=/home/ethan/.local/neko
export LD_LIBRARY_PATH=/home/ethan/.local/neko:$LD_LIBRARY_PATH

haxelib run lime build html5 "$@"
