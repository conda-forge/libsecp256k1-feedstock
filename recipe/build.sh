#!/usr/bin/env bash
set -eox pipefail

./autogen.sh
./configure \
            '--enable-shared' \
            '--disable-dependency-tracking' \
            '--with-pic' \
            '--enable-module-extrakeys' \
            '--enable-module-recovery' \
            '--enable-module-schnorrsig' \
            '--enable-experimental' \
            '--enable-module-ecdh' \
            '--enable-benchmark=no' \
            '--enable-tests=yes' \
            '--enable-exhaustive-tests=yes' \
            --prefix=${PREFIX}

make
make check

make install

ls -lrt ${PREFIX}/lib
ls -lrt ${PREFIX}/include
ls -lrt ${PREFIX}/lib/pkgconfig
cat ${PREFIX}/lib/pkgconfig/libsecp256k1.pc

