# Make SHARED, STATIC or OBJECT libraries
#  For SHARED the name of the cmake object is ${name}_shared and file name is lib${name}.so
#  For STATIC the name of the cmake object is ${name}_static and file name is lib${name}.a
#  For OBJECT the name of the cmake object is ${name} and file name is internally generated
function(make_library name)
  cmake_parse_arguments(ARG
    "SHARED;STATIC;OBJECT"
    ""
    ""
    ${ARGN})
  #message(STATUS "name=${name}")
  #message(STATUS "ARGN=${ARGN}")
  #message(STATUS "ARG_UNPARSED_ARGUMENTS=${ARG_UNPARSED_ARGUMENTS}")
  #message(STATUS "ARG_OBJECT=${ARG_OBJECT}")
  #message(STATUS "ARG_SHARED=${ARG_SHARED}")
  #message(STATUS "ARG_STATIC=${ARG_STATIC}")

  if(ARG_OBJECT)
    if(ARG_SHARED AND ARG_STATIC)
      message(FATAL_ERROR "Both SHARED and STATIC for a OBJECT library is not supported")
    endif()
    if(NOT (ARG_SHARED OR ARG_STATIC))
      message(FATAL_ERROR "Either SHARED or STATIC must be defined")
    endif()
    add_library(${name} OBJECT ${ARG_UNPARSED_ARGUMENTS})
    if(ARG_SHARED)
      set_property(TARGET ${name} PROPERTY POSITION_INDEPENDENT_CODE 1)
    endif()
  else()
    set(SHARED_PARAM)
    if(ARG_SHARED)
      set(SHARED_STATIC_PARAM "SHARED")
    else()
      set(SHARED_STATIC_PARAM "STATIC")
    endif()

    # Temporary name for the objlib
    set(objlib_name ${name}_${SHARED_STATIC_PARAM}_objlib)

    # Recursively call ourselves to make an OBJECT library so the files
    # making up the static/shared libraries are only compiled once if
    # both are requested.
    make_library(${objlib_name} OBJECT ${SHARED_STATIC_PARAM} ${ARG_UNPARSED_ARGUMENTS})

    if(ARG_SHARED)
      # Return ${name}_shared cmake object by using PARENT_SCOPE
      set(${name}_shared ${name}_shared PARENT_SCOPE)
      add_library(${name}_shared SHARED $<TARGET_OBJECTS:${objlib_name}>)
      set_target_properties(${name}_shared PROPERTIES OUTPUT_NAME ${name})
    endif()

    if(ARG_STATIC)
      # Return ${name}_static cmake object by using PARENT_SCOPE
      set(${name}_static ${name}_static PARENT_SCOPE)
      add_library(${name}_static STATIC $<TARGET_OBJECTS:${objlib_name}>)
      set_target_properties(${name}_static PROPERTIES OUTPUT_NAME ${name})
    endif()

    set(objlib_name)
  endif()
endfunction(make_library)
