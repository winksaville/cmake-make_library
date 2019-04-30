cmake_minimum_required (VERSION 3.0)
project (main)
add_executable(main main.c)

add_library(s s1.c s2.c)
target_link_libraries(main s)
