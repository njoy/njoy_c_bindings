include( FetchContent )


########################################################################
# Forward declarations
########################################################################


########################################################################
# Declare project dependencies
########################################################################

FetchContent_Declare( njoy
    GIT_REPOSITORY  http://github.com/njoy/njoy
    GIT_TAG         origin/build/fetchcontent
    )


########################################################################
# Load dependencies
########################################################################

FetchContent_MakeAvailable(
    njoy
    )
