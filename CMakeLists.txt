cmake_minimum_required( VERSION 3.2 ) 

if( NOT ROOT_DIRECTORY )
    set( ROOT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} )
    if ( NOT fetched_subprojects )
        if ( NOT PYTHON_EXECUTABLE )
            find_package( PythonInterp )
            if ( NOT PYTHONINTERP_FOUND )
                message( FATAL_ERROR "Python interpeter installation was not found." )
            endif()
        endif()
        execute_process( COMMAND ${PYTHON_EXECUTABLE} "./metaconfigure/fetch_subprojects.py"
                         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} 
                         RESULT_VARIABLE fetch_failure )
        if ( NOT fetch_failure )
            set( fetched_subprojects TRUE CACHE BOOL "fetch script ran" )
        else()
            message( FATAL_ERROR "Failed to fetch dependencies" )
        endif()
    endif()
endif()

if( NOT DEFINED build_type )
    if( VERBOSE )
        message( STATUS "build_type variable not specified")
        message( STATUS "build_type defaulted to debug")
    endif()
    set ( build_type "debug" )
endif()
if( NOT DEFINED njoy_c_bindings_build_type )
    if( VERBOSE )
        message( STATUS "njoy_c_bindings_build_type not specified")
        message( STATUS "njoy_c_bindings_build_type defaulted to value of build_type variable")
    endif()
    set( njoy_c_bindings_build_type "${build_type}" )
 endif()

if( NOT DEFINED static_libraries )
    if( VERBOSE )
        message( STATUS "static_libraries variable not specified")
        message( STATUS "static_libraries defaulted to FALSE")
    endif()
    set( build_static_libraries FALSE )
else()
    set( build_static_libraries ${static_libraries} )
endif()

if( NOT DEFINED static_njoy_c_bindings )
    if( VERBOSE )
        message( STATUS "static_njoy_c_bindings variable not specified")
        message( STATUS "static_njoy_c_bindings defaulted to value of static_libraries variable")
    endif()
    set( static_njoy_c_bindings ${build_static_libraries} )
endif()

if( ${static_njoy_c_bindings} )
    set( njoy_c_bindings_policy STATIC )
else()
    set( njoy_c_bindings_policy SHARED )
endif()

project( njoy_c_bindings VERSION 0.0.1 LANGUAGES Fortran )

if( NOT DEFINED Fortran_module_directory )
  set( Fortran_module_directory "${CMAKE_BINARY_DIR}/modules"
       CACHE PATH "directory for fortran modules" )
  file( MAKE_DIRECTORY "${Fortran_module_directory}" )
endif()

get_directory_property( is_subproject PARENT_DIRECTORY )
if( NOT TARGET njoy )
    add_subdirectory( ${ROOT_DIRECTORY}/subprojects/njoy )
endif()

if( DEFINED Fortran_compiler_flags )
    if( ( NOT DEFINED njoy_c_bindings_compiler_flags ) AND ( NOT DEFINED njoy_c_bindings_use_default_compiler_flags ) )
        set( njoy_c_bindings_compiler_flags "${Fortran_compiler_flags}" )
    endif()
endif()
if( NOT DEFINED njoy_c_bindings_compiler_flags )
    if( CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" )
        if( njoy_c_bindings_build_type STREQUAL "debug" )
            set( njoy_c_bindings_compiler_flags " -Wall -Wextra -Wpedantic -g -gdwarf-3" )
        elseif( njoy_c_bindings_build_type STREQUAL "coverage" )
            set( njoy_c_bindings_compiler_flags " -Wall -Wextra -Wpedantic -g -gdwarf-3 -fprofile-arcs -ftest-coverage -fno-inline" )
        elseif( njoy_c_bindings_build_type STREQUAL "release" )
            set( njoy_c_bindings_compiler_flags " -Wall -Wextra -Wpedantic -O3 -DNDEBUG" )
            if( NOT no_link_time_optimization )
                set( njoy_c_bindings_compiler_flags "${njoy_c_bindings_compiler_flags} -flto" )
            endif()
        elseif( njoy_c_bindings_build_type STREQUAL "native" )
            set( njoy_c_bindings_compiler_flags " -Wall -Wextra -Wpedantic -O3 -DNDEBUG -march=native" )
            if( NOT no_link_time_optimization )
                set( njoy_c_bindings_compiler_flags "${njoy_c_bindings_compiler_flags} -flto" )
            endif()
        endif()
    else()
        message( WARNING "Compiler vendor not recognized. No compilation flags set" )
    endif()
endif()
if( DEFINED appended_flags AND NOT njoy_c_bindings_no_appended_flags )
    set( njoy_c_bindings_compiler_flags "${njoy_c_bindings_compiler_flags} ${appended_flags}" )
endif()
if( DEFINED njoy_c_bindings_appended_flags )
    set( njoy_c_bindings_compiler_flags "${njoy_c_bindings_compiler_flags} ${njoy_c_bindings_appended_flags}" )
endif()

if ( NOT GIT_EXECUTABLE )
    find_package( Git )
    if ( NOT GIT_FOUND )
        message( FATAL_ERROR "git installation was not found." )
    endif()
endif()
execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_BRANCH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

message( STATUS "" )
message( STATUS "-----------------------------------------------------------" )
message( STATUS "" )
message( STATUS "njoy_c_bindings Version: 0.0.1" )
message( STATUS "Git current branch: ${GIT_BRANCH}" )
message( STATUS "Git commit hash: ${GIT_HASH}" )
message( STATUS "" )
message( STATUS "njoy_c_bindings flags: ${njoy_c_bindings_compiler_flags}" ) 
message( STATUS "" ) 
message( STATUS "-----------------------------------------------------------" ) 
message( STATUS "" ) 

add_library( njoy_c_bindings ${njoy_c_bindings_policy}
             src/njoy_c_bindings.f90
             src/njoy_c_helpers.f90 )
separate_arguments( njoy_c_bindings_compiler_flags_list UNIX_COMMAND "${njoy_c_bindings_compiler_flags}" )
foreach( flag IN LISTS njoy_c_bindings_compiler_flags_list )
    target_compile_options( njoy_c_bindings PUBLIC ${flag} )
endforeach( flag )           
target_link_libraries( njoy_c_bindings PUBLIC njoy ) 
set_target_properties( njoy_c_bindings PROPERTIES LINK_FLAGS "${njoy_c_bindings_compiler_flags}" )
set_target_properties( njoy_c_bindings PROPERTIES Fortran_MODULE_DIRECTORY "${Fortran_module_directory}" )
target_include_directories( njoy_c_bindings PUBLIC "${Fortran_module_directory}" )
target_include_directories( njoy_c_bindings PUBLIC src ) 
