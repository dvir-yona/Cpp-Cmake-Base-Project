#!/bin/bash
set -e

terminal_width=$(tput cols)

if [[ $? -ne 0 ]]; then
  terminal_width=80
  echo "Warning: Could not determine terminal width. Defaulting to 80." >&2
fi

print_sperator() {
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

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    if [ "$arg" = "-R" ]; then
      release=true
    elif [ "$arg" = "-C" ]; then
      clang=true
    elif [ "$arg" = "-D" ]; then
      lldb=true
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

print_sperator
echo "Configurating with preset $preset"
print_sperator
build_dir="./build/${preset}"
hash_file="$build_dir/.cmakelists_hash"
current_hash=$(md5sum CMakeLists.txt | awk '{print $1}')

if [ ! -d "$build_dir" ]; then
  echo "Configuring with preset $preset (first time)"
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

ln -sf "$build_dir/compile_commands.json" ./build/
print_sperator
echo "Building..."
print_sperator
cmake --build --preset="$preset" -j$(nproc)

print_sperator
RunString="Running Program:"
if [ "$lldb" == "true" ]; then 
  RunString="Running Program in LLDB:"
fi
echo "$RunString"
print_sperator
echo ""
      
if [ "$lldb" == "true" ]; then
  lldb "./build/${preset}/bin/Project_exe"
else
  exec "./build/${preset}/bin/Project_exe"
fi
