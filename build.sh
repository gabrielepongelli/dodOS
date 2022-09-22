#! /bin/sh

if [ $# -ne 3 ]; then
    echo "Usage: ./build.sh <toolchain_path> <project_path> <build_path>"
    exit 1
fi

for arg in $@; do
    if ! [ -d "$arg" ]; then
        echo "$arg is not a valid path."
        exit 1
    fi
done

TOOLCHAIN_DIR_PATH=$(realpath "$1")
PROJECT_DIR_PATH=$(realpath "$2")
BUILD_DIR_PATH=$(realpath "$3")
CMAKE_CFG="Debug"
TOOLCHAIN_FILE=$(realpath "toolchain.cmake")

# Configure toolchain.cmake with the correct toolchain path
sed -i -e "s#@TOOLCHAIN_DIR_PATH@#$TOOLCHAIN_DIR_PATH#g" "$TOOLCHAIN_FILE"

cmake -G "Unix Makefiles" -S "$PROJECT_DIR_PATH" -B "$BUILD_DIR_PATH" -DCMAKE_BUILD_TYPE=$CMAKE_CFG -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN_FILE"

cmake --build "$BUILD_DIR_PATH" --config $CMAKE_CFG