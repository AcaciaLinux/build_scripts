#!/bin/bash

set -e

export PKG_NAME="binutils"
export PKG_VERSION="2.38"
export PKG_TARFILE="binutils-2.38.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

if [ $(expect -c "spawn ls") -ne "spawn ls" ]
then
	echo "System has no more ptys!"
	exit 1
fi

patch -Np1 -i ${SOURCES_DIR}/binutils-2.38-lto_fix-1.patch

sed -e '/R_386_TLS_LE /i \   || (TYPE) == R_386_TLS_IE \\' \
    -i ./bfd/elfxx-x86.h

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib | tee ${PKG_LOGDIR}/configure.log

make tooldir=/usr | tee ${PKG_LOGDIR}/make.log
make -k check | tee ${PKG_LOGDIR}/check.log 
make -j1 tooldir=/usr install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 tooldir=/usr DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
rm -fv ${PKG_INSTALL_DIR}/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
