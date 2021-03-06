include( FetchContent )


########################################################################
# Forward declarations
########################################################################


########################################################################
# Declare project dependencies
########################################################################

FetchContent_Declare( njoy
    GIT_REPOSITORY  http://github.com/njoy/NJOY2016
    GIT_TAG         origin/master
    GIT_SHALLOW     TRUE
    )


########################################################################
# Load dependencies
########################################################################

FetchContent_MakeAvailable(
    njoy
    )
