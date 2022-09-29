# @desc     CMake file which correctly builds the bootloader
# @author   Gabriele Pongelli
# @date     23/09/2022

# List of bootloader sources
set(BOOTLOADER_SRC
    boot.asm
)
list(TRANSFORM BOOTLOADER_SRC PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

# Name of the final object file
set(BOOTLOADER_BIN_NAME boot.bin)
set(BOOTLOADER_OBJ_NAME boot.o)
set(BOOTLOADER_BIN "${CMAKE_CURRENT_BINARY_DIR}/${BOOTLOADER_BIN_NAME}")
set(BOOTLOADER_OBJ "${CMAKE_CURRENT_BINARY_DIR}/${BOOTLOADER_OBJ_NAME}")

# Assembling the bootloader assembly code
add_custom_command(
    OUTPUT ${BOOTLOADER_BIN} ${BOOTLOADER_OBJ}
    COMMAND ${CMAKE_ASM_COMPILER} ${BOOTLOADER_SRC} -o ${BOOTLOADER_OBJ}
    COMMAND ${CMAKE_LINKER} -o ${BOOTLOADER_BIN} --oformat binary -Ttext 0x7c00 ${BOOTLOADER_OBJ}
    DEPENDS ${BOOTLOADER_SRC}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
)

# Creating target on the output file for further dependencies
add_custom_target(boot
    DEPENDS ${BOOTLOADER_BIN} ${BOOTLOADER_OBJ}
)

# Add the output file to the list of binaries which will form the operating
# system and add the boot target to the list of targets on which the final os
# will depend
set(OS_BINS ${BOOTLOADER_BIN} ${OS_BINS} PARENT_SCOPE)
set(OS_TARGETS boot ${OS_TARGETS} PARENT_SCOPE)