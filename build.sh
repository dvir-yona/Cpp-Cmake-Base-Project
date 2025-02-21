#!/bin/bash
set -e

debug=false
Rebuild=false
clang=false

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    if [ "$arg" = "-Rebuild" ]; then
      Rebuild=true
    elif [ "$arg" = "-D" ]; then
      debug=true
    elif [ "$arg" = "-C" ]; then
      clang=true
    fi
  done
fi

# Change directory to the script's location
cd "$(dirname "$0")" || {
    echo "Failed to change directory to the script's location."
    read -p "Press any key to continue..."
    exit 1
}

if [[ "$Rebuild" == "true" ]]; then
  rm ./build/* -rf
fi

echo "Current working directory: \"$(pwd)\""

cd build

# Configure CMake with Ninja generator
cmake -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $([[ "$clang" == "true" ]] && echo "-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++") -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $([[ "$clang" == "false" ]] && echo "-DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++") $([[ "$debug" == "true" ]] && echo "-DCMAKE_BUILD_TYPE=Debug") .. || {
    echo "CMake config failed. Check the output above for errors, you may need to install ninja."
    read -p "Press any key to continue..."
    exit 1
}

echo "CMake config completed successfully."

# Build with CMake
cmake --build . --parallel || {
    echo "CMake build failed. Check the output above for errors."
    read -p "Press any key to continue..."
    exit 1
}

cd ..

echo "Ninja build completed successfully"
