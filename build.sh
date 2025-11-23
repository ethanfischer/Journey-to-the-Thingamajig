#!/bin/bash
export PATH=/home/ethan/.local/haxe:/home/ethan/.local/neko:$PATH
export HAXE_STD_PATH=/home/ethan/.local/haxe/std
export NEKOPATH=/home/ethan/.local/neko
export LD_LIBRARY_PATH=/home/ethan/.local/neko:$LD_LIBRARY_PATH

haxelib run lime build html5 "$@"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "BUILD SUCCEEDED"
else
    echo "BUILD FAILED (exit code $EXIT_CODE)"
fi

exit $EXIT_CODE
