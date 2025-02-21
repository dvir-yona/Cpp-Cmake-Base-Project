#!/bin/bash
set -e

#cmd args
debug=false
clang=false

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    if [ "$arg" = "-D" ]; then
      debug=true
      echo "debug enabled"
    elif [ "$arg" = "-C" ]; then
      clang=true
    fi
  done
fi

#arg cache
mkdir -p build

cache_file="build/.cache_file"
full_rebuild=false

## checking for changes
if [ -f "$cache_file" ]; then
  clang_cache=$(grep -E "^clang:" "$cache_file" 2>/dev/null)
  if [ -n "$clang_cache" ]; then
    cached_clang_value="${clang_cache#*:}"
    if [ "$cached_clang_value" != "$clang" ]; then
      echo "Clang setting changed. Triggering full rebuild."
      full_rebuild=true
    fi
  else
    full_rebuild=true
  fi

  debug_cache=$(grep -E "^debug:" "$cache_file" 2>/dev/null)
  if [ -n "$debug_cache" ]; then
    cached_debug_value="${debug_cache#*:}"
    if [ "$cached_debug_value" != "$debug" ]; then
      echo "Debug setting changed. Triggering full rebuild."
      full_rebuild=true
    fi
  else
    full_rebuild=true
  fi
else
  echo "cache file not found. Triggering full rebuild"
  full_rebuild=true
fi

if [[ "$clang" == "true" ]]; then
  clang_value_to_cache="true"
else
  clang_value_to_cache="false"
fi

if [ "$full_rebuild" == "true" ]; then
  echo "Full rebuild triggered"
fi

#building
./build.sh $([ "$full_rebuild" == "true" ] && echo -Rebuild) $([ "$debug" == "true" ] && echo "-D") $([ "$clang" == "true" ] && echo "-C")

#Updating cache
if [ ! -f "$cache_file" ]; then
  touch "$cache_file"
fi

if [[ "$clang" == "true" ]]; then
  clang_value_to_cache="true"
else
  clang_value_to_cache="false"
fi

sed -i "/^clang:/d" "$cache_file" 2>/dev/null
echo "clang:$clang_value_to_cache" >> "$cache_file"

if [[ "$debug" == "true" ]]; then
  debug_value_to_cache="true"
else
  debug_value_to_cache="false"
fi

sed -i "/^debug:/d" "$cache_file" 2>/dev/null
echo "debug:$debug_value_to_cache" >> "$cache_file"

echo running program:
echo --------------- 
echo --------------- 
echo

$([ "$debug" == "true" ] && echo lldb) ./build/bin/main_exe
