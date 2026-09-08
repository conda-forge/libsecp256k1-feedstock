#!/usr/bin/env bash
set -ex

# Build environment
export SECP256K1_BUILD_SHARED_LIBS="ON"
export SECP256K1_INSTALL="ON"

BUILD_DIR="build"

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

# Windows uses the conda Library/ layout for installed artifacts
declare -a PLATFORM_ARGS=()
if [[ "${target_platform}" == win-* ]]; then
  PLATFORM_ARGS+=(-D CMAKE_INSTALL_BINDIR=Library/bin)
  PLATFORM_ARGS+=(-D CMAKE_INSTALL_LIBDIR=Library/lib)
  PLATFORM_ARGS+=(-D CMAKE_INSTALL_INCLUDEDIR=Library/include)
fi

# Build & Install
cmake ${CMAKE_ARGS} \
    -G Ninja \
    -S ${SRC_DIR} \
    -B . \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=${PREFIX} \
    -D SECP256K1_ENABLE_MODULE_RECOVERY=ON \
    -D BUILD_SHARED_LIBS=${SECP256K1_BUILD_SHARED_LIBS} \
    -D SECP256K1_INSTALL=${SECP256K1_INSTALL} \
    -D SECP256K1_BUILD_TESTS=OFF \
    "${PLATFORM_ARGS[@]}"

cmake --build . --parallel ${CPU_COUNT} --target install

cd ..

# Clean build directory
rm -rf ${BUILD_DIR}

# Duplicate the import library so -lsecp256k1 (from pkg-config) resolves under MSVC
if [[ "${target_platform}" == win-* ]]; then
  cp "${PREFIX}/Library/lib/libsecp256k1.lib" "${PREFIX}/Library/lib/secp256k1.lib"
fi
