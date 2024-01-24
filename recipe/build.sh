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

# if [[ "$target_platform" == win* ]]; then
#     mv ${PREFIX}/lib/secp256k1.dll.lib ${PREFIX}/lib/libsecp256k1.dll.lib
#     mv ${PREFIX}/lib/secp256k1.lib ${PREFIX}/lib/libsecp256k1.lib
#
#     mv ${PREFIX}/bin/secp256k1-?.dll ${PREFIX}/bin/libsecp256k1-1.dll
# fi

