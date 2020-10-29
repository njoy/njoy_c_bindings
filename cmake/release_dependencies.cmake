cmake_minimum_required( VERSION 3.14 )
include( FetchContent )

#######################################################################
# Declare project dependencies
#######################################################################

FetchContent_Declare( njoy
    GIT_REPOSITORY  http://github.com/njoy/NJOY2016
    GIT_TAG         b41e221c0752d5e03ed0a74d4cb6106023a59b99
    )

#######################################################################
# Load dependencies
#######################################################################

FetchContent_MakeAvailable(
    njoy
    )
