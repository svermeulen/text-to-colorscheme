#!/bin/bash
cd `dirname $BASH_SOURCE`/../..
cyan build --prune
rm -rf ./lua/tests
cp ./teal/src/text-to-colorscheme/internal/class.lua.txt ./lua/text-to-colorscheme/internal/class.lua
