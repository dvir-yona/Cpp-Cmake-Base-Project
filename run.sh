#!/bin/bash
set -e

terminal_width=$(tput cols)

if [[ $? -ne 0 ]]; then
  terminal_width=80
  echo "Warning: Could not determine terminal width. Defaulting to 80." >&2
fi

print_separator() {
  local hyphens=""
  for ((i=0; i<terminal_width; i++)); do
    hyphens+="-"
  done

  echo "$hyphens"
}

#cmd args
release=false
lldb=false
clang=false
profile=false

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    if [ "$arg" = "-R" ]; then
      release=true
    elif [ "$arg" = "-C" ]; then
      clang=true
    elif [ "$arg" = "-D" ]; then
      lldb=true
    elif [ "$arg" = "-P" ]; then
      profile=true
    elif [ "$arg" = "-h" ]; then
      echo "Usage: $0 <options>"
      echo "Example: $0 -R -C"
      print_separator
      echo "Options:"
      print_separator
      echo "-h - show this help message and exit"
      echo "-P - generate readable profiling data and exit (at ./profiling/)"
      echo "-R - build in release mode"
      echo "-C - use clang as compiler"
      echo "-D - run in LLDB"
      echo "-F - force a clean build"
      exec echo
    elif [ "$arg" = "-F" ]; then
      print_separator
      echo "Cleaning build files"
      rm -rf ./build/ ./profiling/
    fi
  done
fi

build_string() {
  local compiler_str=""
  local mode_str=""

  if [ "${clang}" == "true" ]; then
    compiler_str="clang"
  else
    compiler_str="gcc"
  fi

  if [ "$release" == "true" ]; then
    mode_str="release"
  else
    mode_str="debug"
  fi

  local result_string="${compiler_str}-${mode_str}"
  echo "$result_string"
}

preset=$(build_string)
build_dir="./build/${preset}"

print_separator
echo "Configurating with preset $preset"
print_separator
hash_file="$build_dir/.cmakelists_hash"
current_hash=$(md5sum CMakeLists.txt | awk '{print $1}')

if [ ! -d "$build_dir" ]; then
  deps=$(cat deps.txt | tr '\n' ' ' | sed 's/  */ /g' | xargs)
  if [ -z "$deps" ]; then
    echo "Error: deps.txt is empty."
    exit 1
  fi
  echo "Installing dependencies from deps.txt"
  print_separator
  sudo apt install $deps
  print_separator
  echo "Dependencies installed successfully."
  print_separator
  echo "Configuring with preset $preset (first time)"
  print_separator
  mkdir -p "$build_dir"
  cmake --preset="$preset" .
  echo "$current_hash" > "$hash_file"
elif [ ! -f "$hash_file" ]; then
  echo "Configuring with preset $preset (hash file missing)"
  cmake --preset="$preset" .
  echo "$current_hash" > "$hash_file"
else
  cached_hash=$(cat "$hash_file")
  if [ "$cached_hash" != "$current_hash" ]; then
    echo "Configuring with preset $preset (CMakeLists.txt changed)"
    cmake --preset="$preset" .
    echo "$current_hash" > "$hash_file"
  else
    echo "Using cached build directory: $build_dir"
  fi
fi

cp "$build_dir/compile_commands.json" ./build/
print_separator
echo "Building..."
print_separator
cmake --build --preset="$preset" -j$(nproc)

if [ "$profile" == "true" ]; then
  print_separator
  echo "Getting profiling data from preset $preset"
  print_separator
  echo "Running valgrind"
  print_separator
  mkdir -p profiling
  valgrind --tool=callgrind --callgrind-out-file=profiling/profile.out --collect-jumps=yes --dump-instr=yes "$build_dir/bin/Project_exe"
  print_separator
  echo "Visualizing"
  print_separator
  kcachegrind profiling/profile.out

  exec echo
fi

print_separator
RunString="Running Program:"
if [ "$lldb" == "true" ]; then 
  RunString="Running Program in LLDB:"
fi
echo "$RunString"
print_separator
echo ""
      
if [ "$lldb" == "true" ]; then
  gdb "./build/${preset}/bin/Project_exe"
else
  cd "./build/${preset}/"
  exec "./bin/Project_exe"
fi
