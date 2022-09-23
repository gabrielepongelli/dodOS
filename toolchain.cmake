# @desc     CMake toolchain file which set the tools to be used by cmake
# @author   Gabriele Pongelli
# @date     22/09/2022

set(CMAKE_WARN_DEPRECATED OFF)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR i686)

set(TOOLCHAIN_DIR "@TOOLCHAIN_DIR_PATH@")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_DIR}/${CMAKE_SYSTEM_PROCESSOR}-elf-as")
set(CMAKE_C_COMPILER "${TOOLCHAIN_DIR}/${CMAKE_SYSTEM_PROCESSOR}-elf-gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_DIR}/${CMAKE_SYSTEM_PROCESSOR}-elf-g++")
set(CMAKE_LINKER "${TOOLCHAIN_DIR}/${CMAKE_SYSTEM_PROCESSOR}-elf-ld")