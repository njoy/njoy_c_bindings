########################################################################
# Preamble
########################################################################

cmake_minimum_required( VERSION 3.16 ) 
project( njoy_c_bindings LANGUAGES Fortran )


########################################################################
# Project-wide setup
########################################################################

set( CMAKE_Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/fortran_modules" CACHE PATH "directory for fortran modules" )
file( MAKE_DIRECTORY "${CMAKE_Fortran_MODULE_DIRECTORY}" ) 

set( CMAKE_SKIP_BUILD_RPATH FALSE )
set( CMAKE_BUILD_WITH_INSTALL_RPATH FALSE )
if ( CMAKE_SYSTEM_NAME STREQUAL "Darwin" )
    set( rpath_prefix "@loader_path" )
else()
    set( rpath_prefix "\\$ORIGIN" )
endif()
list( INSERT 0 CMAKE_INSTALL_RPATH "${rpath_prefix}/../lib" )
set( CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE )

########################################################################
# Dependencies
########################################################################

include( cmake/njoy_c_bindings_dependencies.cmake )


########################################################################
# Project targets
########################################################################

add_library( njoy_c_bindings
             "${CMAKE_CURRENT_SOURCE_DIR}/src/njoy_c_bindings.f90"
             "${CMAKE_CURRENT_SOURCE_DIR}/src/njoy_c_helpers.f90" )

target_include_directories( njoy_c_bindings PUBLIC "${CMAKE_Fortran_MODULE_DIRECTORY}" )
target_include_directories( njoy_c_bindings PUBLIC src )
target_link_libraries( njoy_c_bindings PUBLIC njoy )

file( RELATIVE_PATH relative_fortran_module_files_path 
      "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_Fortran_MODULE_DIRECTORY}" )
file( GLOB fortran_module_files 
      RELATIVE "${relative_fortran_module_files_path}"
      *.mod )
