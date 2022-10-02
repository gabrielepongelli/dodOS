# @desc     CMake file which correctly builds the bootloader
# @author   Gabriele Pongelli
# @date     23/09/2022

set(LIB
    print_string.asm
    read_from_drive.asm
    reboot.asm
)
list(TRANSFORM LIB PREPEND "${CMAKE_CURRENT_SOURCE_DIR}/lib/")

set(FIRST_STAGE_SRC "${CMAKE_CURRENT_SOURCE_DIR}/boot0.asm")
set(FIRST_STAGE_OBJ "${CMAKE_CURRENT_BINARY_DIR}/boot0.o")
set(FIRST_STAGE_BIN "${CMAKE_CURRENT_BINARY_DIR}/boot0.bin")

set(SECOND_STAGE_SRC "${CMAKE_CURRENT_SOURCE_DIR}/boot1.asm")
set(SECOND_STAGE_OBJ "${CMAKE_CURRENT_BINARY_DIR}/boot1.o")
set(SECOND_STAGE_BIN "${CMAKE_CURRENT_BINARY_DIR}/boot1.bin")

set(BOOTLOADER_BIN "${CMAKE_CURRENT_BINARY_DIR}/boot.bin")


# Producing the second stage binary
add_custom_command(
    OUTPUT ${SECOND_STAGE_OBJ} ${SECOND_STAGE_BIN}
    COMMAND ${CMAKE_ASM_COMPILER} ${SECOND_STAGE_SRC} -o ${SECOND_STAGE_OBJ} ${CMAKE_ASM_FLAGS}
    COMMAND ${CMAKE_LINKER} -o ${SECOND_STAGE_BIN} --oformat binary -Ttext 0x1000 ${SECOND_STAGE_OBJ}
    DEPENDS ${SECOND_STAGE_SRC} ${LIB}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    VERBATIM
)

add_custom_target(second_stage
    DEPENDS ${SECOND_STAGE_OBJ} ${SECOND_STAGE_BIN}
)

# Producing the first stage binary
add_custom_command(
    OUTPUT ${FIRST_STAGE_OBJ} ${FIRST_STAGE_BIN}
    COMMAND ${CMAKE_ASM_COMPILER} ${FIRST_STAGE_SRC} -o ${FIRST_STAGE_OBJ} ${CMAKE_ASM_FLAGS} -defsym SECOND_STAGE_SIZE=`${CMAKE_COMMAND} -E cat ${SECOND_STAGE_BIN} | wc -c` -defsym SECTOR_SIZE=512 --divide
    COMMAND ${CMAKE_LINKER} -o ${FIRST_STAGE_BIN} --oformat binary -Ttext 0x7c00 ${FIRST_STAGE_OBJ}
    DEPENDS second_stage ${SECOND_STAGE_BIN} ${FIRST_STAGE_SRC} ${LIB}
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)

add_custom_target(first_stage
    DEPENDS ${FIRST_STAGE_OBJ} ${FIRST_STAGE_BIN}
)


# Producing the final bootloader binary
add_custom_command(
    OUTPUT ${BOOTLOADER_BIN}
    COMMAND ${CMAKE_COMMAND} -E cat ${FIRST_STAGE_BIN} ${SECOND_STAGE_BIN} > ${BOOTLOADER_BIN}
    DEPENDS first_stage second_stage ${FIRST_STAGE_BIN} ${SECOND_STAGE_BIN}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    VERBATIM
)

# Creating target on the output file for further dependencies
add_custom_target(boot
    DEPENDS ${BOOTLOADER_BIN}
)

# Add the output file to the list of binaries which will form the operating
# system and add the boot target to the list of targets on which the final os
# will depend
set(OS_BINS ${BOOTLOADER_BIN} ${OS_BINS} PARENT_SCOPE)
set(OS_TARGETS boot ${OS_TARGETS} PARENT_SCOPE)