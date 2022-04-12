#!/bin/bash

set -e

export PKG_NAME="libelf"
export PKG_VERSION="0.186"
export PKG_TARFILE="elfutils-0.186.tar.bz2"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/elfutils-0.186

./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 -C libelf install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

make -j1 -C libelf DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
install -vm644 config/libelf.pc ${PKG_INSTALL_DIR}/usr/lib/pkgconfig
rm ${PKG_INSTALL_DIR}/usr/lib/libelf.a

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
