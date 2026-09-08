#!/usr/bin/env bash
set -ex

# Build environment
export SECP256K1_BUILD_SHARED_LIBS="ON"
export SECP256K1_INSTALL="ON"

BUILD_DIR="build"

mkdir -p ${BUILD_DIR}

# Build & Install
cd ${BUILD_DIR}
  cmake ${CMAKE_ARGS} \
      -S ${SRC_DIR} \
      -B . \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=${PREFIX} \
      -D SECP256K1_ENABLE_MODULE_RECOVERY=ON \
      -D BUILD_SHARED_LIBS=${SECP256K1_BUILD_SHARED_LIBS} \
      -D SECP256K1_INSTALL=${SECP256K1_INSTALL} \
      -D SECP256K1_BUILD_TESTS=OFF

  cmake --build . --parallel ${CPU_COUNT} --config Release --target install

  cd ..

# Clean build directory
rm -rf ${BUILD_DIR}
