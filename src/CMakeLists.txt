# Set common compiler flags to use in every compilation
set(CMAKE_ASM_FLAGS ${CMAKE_ASM_FLAGS} -msyntax=intel -mnaked-reg)
set(COMMON_FLAGS -ffreestanding -O2 -Wall -Wextra)
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} -std=gnu99 ${COMMON_FLAGS})
set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS} -fno-exceptions -fno-rtti ${COMMON_FLAGS})

# Define a list of object files which will then be linked together to form the 
# operating system. Initially it is empty, but will be updated inside the 
# following  subdirectories
set(OS_OBJS "")

# Define a list of target which the link command will depend on. Initially it 
# is empty, but will be updated inside the following  subdirectories
set(OS_TARGETS "")

add_subdirectory(boot)
# TODO: add subdirectories

set(OUTPUT_OS_PATH "${CMAKE_CURRENT_BINARY_DIR}/${OS_BINARY_NAME}")
set(OS_BINARY_PATH ${OUTPUT_OS_PATH} PARENT_SCOPE)

# Linking everything together
add_custom_command(
    OUTPUT ${OUTPUT_OS_PATH}
    DEPENDS boot ${OS_TARGETS} ${OS_OBJS}
    COMMAND ${CMAKE_LINKER} -o "${OUTPUT_OS_PATH}" --oformat binary -Ttext 0x7c00 ${OS_OBJS}
    VERBATIM
)

# Creating target on the output file for further dependencies
add_custom_target(${OS_BINARY_NAME}
    DEPENDS ${OUTPUT_OS_PATH}
)