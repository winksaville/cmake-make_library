cmake_minimum_required (VERSION 3.0)
project (shared-static-libs)

# Main with shared libraries
add_executable(main_shared)
target_link_libraries(main_shared m_obj s_shared)

# Main executable which will be statically linked
add_executable(main_static)
#set_property(TARGET main_static PROPERTY POSITION_INDEPENDENT_CODE 1)
target_link_libraries(main_static -static m_obj s_static)

# Create m_obj OBJECT library and PIC so we only build once
add_library(m_obj OBJECT main.c)
set_property(TARGET m_obj PROPERTY POSITION_INDEPENDENT_CODE 1)

# Create s_objs OBJECT library build PIC so we only build once
add_library(s_objs OBJECT s1.c s2.c)
set_property(TARGET s_objs PROPERTY POSITION_INDEPENDENT_CODE 1)

# Build the shared and static version of s as `libs.so` and `libs.a`
add_library(s_shared SHARED $<TARGET_OBJECTS:s_objs>)
set_target_properties(s_shared PROPERTIES OUTPUT_NAME "s")
add_library(s_static STATIC $<TARGET_OBJECTS:s_objs>)
set_target_properties(s_static PROPERTIES OUTPUT_NAME "s")
