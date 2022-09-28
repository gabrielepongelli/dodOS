# @desc     CMake file which correctly assemble the main os binary file.
# @author   Gabriele Pongelli
# @date     22/09/2022

# Set common compiler flags to use in every compilation
set(COMMON_FLAGS -ffreestanding -O2 -Wall -Wextra)
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -std=gnu99 ${COMMON_FLAGS})
set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS} -fno-exceptions -fno-rtti ${COMMON_FLAGS})

# Define a list of binary files which will then form the final operating 
# system. Initially it is empty, but will be updated inside the following  
# subdirectories
set(OS_BINS "")

# Define a list of target which the final os will depend on. Initially it
# is empty, but will be updated inside the following  subdirectories
set(OS_TARGETS "")

add_subdirectory(boot)
# TODO: add subdirectories

set(OUTPUT_OS_PATH "${CMAKE_CURRENT_BINARY_DIR}/${OS_BINARY_NAME}")
set(OS_BINARY_PATH ${OUTPUT_OS_PATH} PARENT_SCOPE)

# Putting everything together
add_custom_command(
    OUTPUT ${OUTPUT_OS_PATH}
    DEPENDS boot ${OS_TARGETS} ${OS_BINS}
    COMMAND ${CMAKE_COMMAND} -E cat ${OS_BINS} > "${OUTPUT_OS_PATH}"
    VERBATIM
)

# Creating target on the output file for further dependencies
add_custom_target(${OS_BINARY_NAME}
    DEPENDS ${OUTPUT_OS_PATH}
)