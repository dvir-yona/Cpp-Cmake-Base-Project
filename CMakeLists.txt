cmake_minimum_required(VERSION 3.15)
project(ProjectAi)

add_executable(main_exe src/main.cpp)

# target paths
set(Target_Build "${CMAKE_BINARY_DIR}/build")
file(MAKE_DIRECTORY "${Target_Build}")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(Target_Install "${CMAKE_BINARY_DIR}/install")
file(MAKE_DIRECTORY "${Target_Install}")

set(Target_Output "${CMAKE_BINARY_DIR}/output")
file(MAKE_DIRECTORY "${Target_Output}")

set_target_properties(main_exe PROPERTIES
    BUILD_RPATH "${Target_Build}"
    INSTALL_RPATH "${Target_Install}"
)

set_target_properties(main_exe PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${Target_Output}"
)

#external libraries
include(FetchContent)

target_compile_options(main_exe PRIVATE "-mavx" "-march=native")

