########################################################################
# Preamble
########################################################################

cmake_minimum_required( VERSION 3.14 )
project( njoy_c_bindings LANGUAGES Fortran )


########################################################################
# Project-wide setup
########################################################################

set( CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_BINARY_DIR}/fortran_modules
    CACHE PATH "directory for fortran modules"
    )
file( MAKE_DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY} ) 


########################################################################
# Dependencies
########################################################################

set( REPOSITORIES "release"
    CACHE STRING
    "Options for where to fetch repositories: develop, release, local"
    )

if( REPOSITORIES STREQUAL "develop" )
    include( cmake/develop_dependencies.cmake )

elseif( REPOSITORIES STREQUAL "release" )
    include( cmake/release_dependencies.cmake )

elseif( REPOSITORIES STREQUAL "local" )
    include( cmake/local_dependencies.cmake )

endif()


########################################################################
# Project targets
########################################################################

add_library( njoy_c_bindings
    src/njoy_c_bindings.f90
    src/njoy_c_helpers.f90
    )

target_include_directories( njoy_c_bindings 
    PUBLIC ${CMAKE_Fortran_MODULE_DIRECTORY}
    PUBLIC src/
    )
target_link_libraries( njoy_c_bindings PUBLIC njoy )

file( RELATIVE_PATH relative_fortran_module_files_path 
    ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_Fortran_MODULE_DIRECTORY}
    )
file( GLOB fortran_module_files 
    RELATIVE ${relative_fortran_module_files_path}
    *.mod
    )
