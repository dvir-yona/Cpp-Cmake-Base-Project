cmake_minimum_required(VERSION 3.15)
project(Project)

add_executable(main_exe src/main.cpp)

# target paths
set(Target_Build "${CMAKE_BINARY_DIR}/build")
file(MAKE_DIRECTORY "${Target_Build}")

set(Target_Install "${CMAKE_BINARY_DIR}/install")
file(MAKE_DIRECTORY "${Target_Install}")

set(Target_Output "${CMAKE_BINARY_DIR}/bin")
file(MAKE_DIRECTORY "${Target_Output}")

set_target_properties(main_exe PROPERTIES
    BUILD_RPATH "${Target_Build}"
    INSTALL_RPATH "${Target_Install}"
)

set_target_properties(main_exe PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${Target_Output}"
)
