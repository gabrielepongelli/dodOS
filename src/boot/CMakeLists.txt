# List of bootloader sources
set(BOOTLOADER_SRC
    boot.asm
)
list(TRANSFORM BOOTLOADER_SRC PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/")

# Name of the final object file
set(BOOTLOADER_OUTPUT_NAME boot.o)
set(BOOTLOADER_OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${BOOTLOADER_OUTPUT_NAME}")

# Assembling the bootloader assembly code
add_custom_command(
    OUTPUT ${BOOTLOADER_OUTPUT}
    COMMAND ${CMAKE_ASM_COMPILER} ${BOOTLOADER_SRC} -o "${BOOTLOADER_OUTPUT}" ${CMAKE_ASM_FLAGS}
    DEPENDS ${BOOTLOADER_SRC}
    VERBATIM
)

# Creating target on the output file for further dependencies
add_custom_target(
    boot
    DEPENDS ${BOOTLOADER_OUTPUT}
)

# Add the output file to the list of objects which will form the operating 
# system and add the boot target to the list of targets on which the linking 
# will depend
set(OS_OBJS ${OS_OBJS} ${BOOTLOADER_OUTPUT} PARENT_SCOPE)
set(OS_TARGETS ${OS_TARGETS} boot PARENT_SCOPE)