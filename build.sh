#!/bin/sh
set -e

# Change directory to the script's location
cd "$(dirname "$0")" || {
    echo "Failed to change directory to the script's location."
    read -p "Press any key to continue..."
    exit 1
}

echo "Current working directory: \"$(pwd)\""

cd ./build/

# Configure CMake with Ninja generator
cmake -G "Ninja" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. || {
    echo "CMake config failed. Check the output above for errors."
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

echo "Ninja build completed successfully"

cd ..

exit 0
