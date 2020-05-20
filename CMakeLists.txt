########################################################################
# Preamble
########################################################################

cmake_minimum_required( VERSION 3.16 )
project( njoy_c_bindings LANGUAGES Fortran )


########################################################################
# Project-wide setup
########################################################################

set( CMAKE_Fortran_MODULE_DIRECTORY 
    ${CMAKE_BINARY_DIR}/fortran_modules
    CACHE PATH "directory for fortran modules"
    )


########################################################################
# Dependencies
########################################################################

include( cmake/njoy_c_bindings_dependencies.cmake )


########################################################################
# Project targets
########################################################################

add_library( njoy_c_bindings
    src/njoy_c_bindings.f90
    src/njoy_c_helpers.f90 )
target_include_directories( njoy_c_bindings PUBLIC ${CMAKE_Fortran_MODULE_DIRECTORY} )
target_include_directories( njoy_c_bindings PUBLIC src )
target_link_libraries( njoy_c_bindings
    PUBLIC njoy
    )
