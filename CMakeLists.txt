# @desc     CMake file which build the os and generate its iso file
# @author   Gabriele Pongelli
# @date     22/09/2022

cmake_minimum_required(VERSION 3.24)

# Tell cmake that it is not necessary to test the compilers as it will generate 
# a lot of errors
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)

project(dodOS
    LANGUAGES CXX C ASM
)

set(OS_BINARY_NAME "${PROJECT_NAME}.bin")
set(OS_BINARY_PATH "") # Must be filled insied src subdir

# Add sources to the project
add_subdirectory(src)

set(IMG_FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.img")
set(ISO_FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.iso")

# Create the floppy .img file
add_custom_command(
    OUTPUT ${IMG_FILE}
    DEPENDS ${OS_BINARY_NAME} ${OS_BINARY_PATH}
    COMMAND dd if=/dev/zero of=${IMG_FILE} bs=1024 count=1440 status=none
    COMMAND dd if=${OS_BINARY_PATH} of=${IMG_FILE} seek=0 conv=notrunc status=none
    VERBATIM
)

add_custom_target(img
    DEPENDS ${IMG_FILE}
)

# Create the CD/DVD .iso file
add_custom_command(
    OUTPUT ${ISO_FILE}
    DEPENDS ${IMG_FILE}
    COMMAND mkdir -p iso
    COMMAND cp ${IMG_FILE} iso/floppy.img
    COMMAND mkisofs -quiet -V '${PROJECT_NAME}' -input-charset iso8859-1 -o ${ISO_FILE} -b floppy.img -hide floppy.img iso/
    VERBATIM
)

add_custom_target(iso ALL
    DEPENDS ${ISO_FILE}
)