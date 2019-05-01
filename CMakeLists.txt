# Create main_shared and main_static with either
# the two libraries either created One At A Time by
# passing -DOAAT=true to cmake command or simultaneously
# by not passing OAAT

cmake_minimum_required (VERSION 3.0)
project (shared-static-libs)

# Main with shared libraries
add_executable(main_shared)
target_link_libraries(main_shared m_obj s_shared)

# Main executable which will be statically linked
add_executable(main_static)
target_link_libraries(main_static -static m_obj s_static)

# Get make_library function
include(make_library.cmake)

# Create m_obj OBJECT library and PIC so we only build once
make_library(m_obj SHARED OBJECT main.c)

# Make s_shared and s_static who's names will be `libs.so` and `libs.a`
# either One At A Time or simultaneously
if(OAAT)
  make_library(s SHARED s1.c s2.c)
  make_library(s STATIC s1.c s2.c)
else()
  make_library(s SHARED STATIC s1.c s2.c)
endif()
