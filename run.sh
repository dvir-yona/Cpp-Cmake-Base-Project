#!/bin/sh
set -e

./build.sh

echo running program:
echo --------------- 
echo --------------- 
echo

./build/bin/main_exe
