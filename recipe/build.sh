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

if [[ "$target_platform" == win* ]]; then
  mkdir -p ${PREFIX}/Library/bin ${PREFIX}/Library/include ${PREFIX}/Library/lib ${PREFIX}/Library/lib/pkgconfig

  /usr/bin/install -c -m 644 ${PREFIX}/include/secp256k1*.h ${PREFIX}/Library/include

  /usr/bin/install -c -m 644 ${PREFIX}/lib/secp256k1.dll.lib ${PREFIX}/Library/lib/libsecp256k1.dll.lib
  /usr/bin/install -c -m 644 ${PREFIX}/lib/secp256k1.lib ${PREFIX}/Library/lib/libsecp256k1.lib
  /usr/bin/install -c -m 644 ${PREFIX}/lib/pkgconfig/libsecp256k1.pc ${PREFIX}/Library/lib/pkgconfig/libsecp256k1.pc

  /usr/bin/install -c ${PREFIX}/bin/secp256k1-?.dll ${PREFIX}/Library/bin/libsecp256k1-1.dll
fi

