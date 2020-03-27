
project( njoy_c_bindings LANGUAGES Fortran )
include( CMakeDependentOption REQUIRED )
set( njoy_c_bindings_GNU_minimum_version 5.1 )

if( njoy_c_bindings_${CMAKE_Fortran_COMPILER_ID}_minimum_version )
    if( CMAKE_Fortran_COMPILER_VERSION AND
        CMAKE_Fortran_COMPILER_VERSION VERSION_LESS
        ${njoy_c_bindings_${CMAKE_Fortran_COMPILER_ID}_minimum_version} )
        message( FATAL_ERROR "${CMAKE_Fortran_COMPILER_ID} version must be greater than ${njoy_c_bindings_${CMAKE_Fortran_COMPILER_ID}_minimum_version}" )
    endif()
endif()

# general properties
option( strict "Compile time warnings are converted to errors" OFF )

# binary instrumentation
option( coverage "Enable binary instrumentation to collect test coverage information in the DEBUG configuration" )
option( profile_generate "Enable binary instrumentation to generation execution profiles in the RELEASE configuration which may be used to guide later optimization" )

# additional optimizations
option( link_time_optimization "Enable link time optimization in the RELEASE configuration" )
option( profile_use "In the RELEASE configuration, leverage previously generated exeution profile to inform optimization decisions" )
option( nonportable_optimization "Enable optimizations which compromise portability of resulting binary in the RELEASE configuration" )

# libraries and linking
option( static "Statically link component and environment libraries" OFF )
if ( static AND ( "${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin" ) )
    message( FATAL_ERROR "Static binaries not supported on OSX" )
endif()

CMAKE_DEPENDENT_OPTION( static_libraries "Statically link component libraries" OFF "NOT static" ON )
CMAKE_DEPENDENT_OPTION( static_njoy_c_bindings "Statically link the njoy_c_bindings component library" OFF "NOT static;NOT static_libraries" ON ) 

if ( profile_generate AND profile_use )
    message( FATAL_ERROR "Cannot both generate and use execution profile in the same configuration" )
endif()

if ( profile_generate )
    file( MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/profiling" )
endif()

set( CMAKE_Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/fortran_modules" CACHE PATH "directory for fortran modules" )
file( MAKE_DIRECTORY "${CMAKE_Fortran_MODULE_DIRECTORY}" ) 

set( njoy_c_bindings_GNU_Windows_common_flags "-Wall" "-Wextra" )
set( njoy_c_bindings_GNU_Windows_DEBUG_flags "-O0" "-g" "-gdwarf-3" "-fsignaling-nans" "-fcheck=all" "-ffpe-trap=invalid,zero,overflow" )
set( njoy_c_bindings_GNU_Windows_RELEASE_flags "-O3" "-DNDEBUG" )
set( njoy_c_bindings_GNU_Windows_strict_flags "-Werror" )
set( njoy_c_bindings_GNU_Windows_coverage_flags "--coverage" )
set( njoy_c_bindings_GNU_Windows_subproject_flags  )
set( njoy_c_bindings_GNU_Windows_base_project_flags  )
set( njoy_c_bindings_GNU_Windows_profile_generate_flags "-fprofile-generate='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Windows_link_time_optimization_flags "-flto" )
set( njoy_c_bindings_GNU_Windows_profile_use_flags "-fprofile-use='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Windows_nonportable_optimization_flags "-march=native" )
set( njoy_c_bindings_GNU_Windows_static_flags "-static" )
set( njoy_c_bindings_GNU_Linux_common_flags "-Wall" "-Wextra" )
set( njoy_c_bindings_GNU_Linux_DEBUG_flags "-O0" "-g" "-gdwarf-3" "-fsignaling-nans" "-fcheck=all" "-ffpe-trap=invalid,zero,overflow" )
set( njoy_c_bindings_GNU_Linux_RELEASE_flags "-O3" "-DNDEBUG" )
set( njoy_c_bindings_GNU_Linux_strict_flags "-Werror" )
set( njoy_c_bindings_GNU_Linux_coverage_flags "--coverage" )
set( njoy_c_bindings_GNU_Linux_subproject_flags  )
set( njoy_c_bindings_GNU_Linux_base_project_flags  )
set( njoy_c_bindings_GNU_Linux_profile_generate_flags "-fprofile-generate='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Linux_link_time_optimization_flags "-flto" )
set( njoy_c_bindings_GNU_Linux_profile_use_flags "-fprofile-use='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Linux_nonportable_optimization_flags "-march=native" )
set( njoy_c_bindings_GNU_Linux_static_flags "-static" )
set( njoy_c_bindings_GNU_Darwin_common_flags "-Wall" "-Wextra" )
set( njoy_c_bindings_GNU_Darwin_DEBUG_flags "-O0" "-g" "-gdwarf-3" "-fsignaling-nans" "-fcheck=all" "-ffpe-trap=invalid,zero,overflow" )
set( njoy_c_bindings_GNU_Darwin_RELEASE_flags "-O3" "-DNDEBUG" )
set( njoy_c_bindings_GNU_Darwin_strict_flags "-Werror" )
set( njoy_c_bindings_GNU_Darwin_coverage_flags "--coverage" )
set( njoy_c_bindings_GNU_Darwin_subproject_flags  )
set( njoy_c_bindings_GNU_Darwin_base_project_flags  )
set( njoy_c_bindings_GNU_Darwin_profile_generate_flags "-fprofile-generate='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Darwin_link_time_optimization_flags "-flto" )
set( njoy_c_bindings_GNU_Darwin_profile_use_flags "-fprofile-use='${CMAKE_BINARY_DIR}/profiling'" )
set( njoy_c_bindings_GNU_Darwin_nonportable_optimization_flags "-march=native" )
set( njoy_c_bindings_GNU_Darwin_static_flags "-static" )

if ( static_njoy_c_bindings )
    set( njoy_c_bindings_library_linkage STATIC )
else ()
    set( njoy_c_bindings_library_linkage SHARED )
endif () 

set( CMAKE_SKIP_BUILD_RPATH FALSE )
set( CMAKE_BUILD_WITH_INSTALL_RPATH FALSE )
if ( CMAKE_SYSTEM_NAME STREQUAL "Darwin" )
    set( rpath_prefix "@loader_path" )
else()
    set( rpath_prefix "\\$ORIGIN" )
endif()
list( INSERT 0 CMAKE_INSTALL_RPATH "${rpath_prefix}/../lib" )
set( CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE )
get_directory_property( is_subproject PARENT_DIRECTORY )

add_library( njoy_c_bindings ${njoy_c_bindings_library_linkage} 
             "${CMAKE_CURRENT_SOURCE_DIR}/src/njoy_c_bindings.f90"
             "${CMAKE_CURRENT_SOURCE_DIR}/src/njoy_c_helpers.f90" )
target_include_directories( njoy_c_bindings PUBLIC "${CMAKE_Fortran_MODULE_DIRECTORY}" )
target_include_directories( njoy_c_bindings PUBLIC src )

set( PREFIX njoy_c_bindings_${CMAKE_Fortran_COMPILER_ID}_${CMAKE_SYSTEM_NAME} )

target_compile_options( njoy_c_bindings PRIVATE 
${${PREFIX}_common_flags}
$<$<BOOL:${strict}>:${${PREFIX}_strict_flags}>
$<$<BOOL:${static}>:${${PREFIX}_static_flags}>
$<$<BOOL:${is_subproject}>:${${PREFIX}_subproject_flags}>
$<$<NOT:$<BOOL:${is_subproject}>>:${${PREFIX}_base_project_flags}>
$<$<CONFIG:DEBUG>:
${${PREFIX}_DEBUG_flags} 
$<$<BOOL:${coverage}>:${${PREFIX}_coverage_flags}>>
$<$<CONFIG:RELEASE>:
${${PREFIX}_RELEASE_flags} 
$<$<BOOL:${profile_generate}>:${${PREFIX}_profile_generate_flags}> 
$<$<BOOL:${profile_use}>:${${PREFIX}_profile_use_flags}> 
$<$<BOOL:${link_time_optimization}>:${${PREFIX}_link_time_optimization_flags}> 
$<$<BOOL:${nonportable_optimization}>:${${PREFIX}_nonportable_optimization_flags}>>
${Fortran_appended_flags} ${njoy_c_bindings_appended_flags} )

target_link_libraries( njoy_c_bindings PUBLIC "$<$<AND:$<CONFIG:RELEASE>,$<BOOL:${link_time_optimization}>>:${${PREFIX}_RELEASE_flags};${${PREFIX}_link_time_optimization_flags}$<$<BOOL:${profile_generate}>:${${PREFIX}_profile_generate_flags};>$<$<BOOL:${profile_use}>:${${PREFIX}_profile_use_flags};>$<$<BOOL:${nonportable_optimization}>:${${PREFIX}_nonportable_optimization_flags};>>$<$<CONFIG:DEBUG>:$<$<BOOL:${coverage}>:${${PREFIX}_coverage_flags};>>$<$<BOOL:Fortran_appended_flags>:${Fortran_appended_flags};>$<$<BOOL:njoy_c_bindings_appended_flags>:${njoy_c_bindings_appended_flags};>" )

target_link_libraries( njoy_c_bindings PUBLIC NJOY2016 )


file( RELATIVE_PATH relative_fortran_module_files_path 
      "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_Fortran_MODULE_DIRECTORY}" )
file( GLOB fortran_module_files 
      RELATIVE "${relative_fortran_module_files_path}"
      *.mod )
install( FILES ${fortran_module_files} 
         DESTINATION include
         PERMISSIONS OWNER_READ OWNER_WRITE 
                     GROUP_READ 
                     WORLD_READ )
