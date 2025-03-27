# Cpp-Cmake-Base-Project

This repository provides a starting point for C++ projects using CMake as the build system. It includes a simple `main.cpp`, a CMake configuration with presets for various compilers and build types, and a `run.sh` script to streamline building and running the project.

## Features

- **Compiler Support**: Choose between GCC and Clang.
- **Build Modes**: Debug (with address sanitization) and Release.
- **Debugging**: Run the program in GDB.
- **Profiling**: Generate profiling data using Valgrind and visualize it with KCachegrind.
- **Dependency Management**: Automatically installs required dependencies listed in `deps.txt`.

## Prerequisites

- An Ubuntu or Debian-based system (for dependency installation via `apt`).
- Git (to clone the repository).

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/Cpp-Cmake-Base-Project.git
   cd Cpp-Cmake-Base-Project
   ```
2. **Run the build Script**:
   ```bash
   ./run.sh
   ```
   The script will automatically install dependencies listed in deps.txt (requires sudo privileges).
## Usage
The run.sh script simplifies building and running the project with various options. Here’s how to use it:
### Options
- -R: Build in Release mode (default is Debug).
- -C: Use Clang as the compiler (default is GCC).
- -D: Run the program in GDB for debugging.
- -P: Generate profiling data and visualize it with KCachegrind.
- -F: Force a clean build by removing existing build directories.
- -h: Display the help message.
## Project Structure

- **src/**: Contains source files (.cpp), e.g., main.cpp.
- **include/**: Place your header files (.h) here to ensure they are included in the build.
- **build/**: Stores build artifacts, organized by preset (e.g., gcc-debug, clang-release).
- **profiling/**: Holds profiling data generated with the -P option.
  This generates profiling data in profiling/profile.out and opens it in KCachegrind for visualization.
- **run.sh**: Script to build and run the project.
- **CMakeLists.txt**: CMake configuration file.
- **CMakePresets.json**: Defines build presets for different configurations.
- **deps.txt**: Lists required dependencies.
---
## License
   This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for full details.
