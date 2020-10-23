# This cmake file is only for the linkedList.c file
# the .s assembly files do not apply here
# I'm adding this because some ide's pick up CMake files
# and automatically set up debugging stuff.

# ** If you don't know how to use cmake, just use the Makefile **

cmake_minimum_required(VERSION 3.13)
project(insertList)

set(CMAKE_C_STANDARD 11)
add_executable(linkedList linkedList.c)
