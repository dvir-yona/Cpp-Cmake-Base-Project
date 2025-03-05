cmake_minimum_required(VERSION 3.15)
project(Project)

file(GLOB_RECURSE SOURCE_FILES "src/*.cpp")
message(STATUS "Source files found: ${SOURCE_FILES}")

add_executable(Project_exe ${SOURCE_FILES})

# target paths
set(Target_Build "${CMAKE_BINARY_DIR}/build")
file(MAKE_DIRECTORY "${Target_Build}")

set(Target_Install "${CMAKE_BINARY_DIR}/install")
file(MAKE_DIRECTORY "${Target_Install}")

set(Target_Output "${CMAKE_BINARY_DIR}/bin")
file(MAKE_DIRECTORY "${Target_Output}")

set_target_properties(Project_exe PROPERTIES
    BUILD_RPATH "${Target_Build}"
    INSTALL_RPATH "${Target_Install}"
)

set_target_properties(Project_exe PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${Target_Output}"
)

#include(FetchContent)
#Set(FETCHCONTENT_QUIET FALSE)

#FetchContent_Declare(
# someTarget
# GIT_REPOSITORY "https://github.com/someone/someTarget.git"
# GIT_TAG "tag"
#  GIT_PROGRESS TRUE
#)
