#!/bin/bash

set -e

export PKG_NAME="zlib"
export PKG_VERSION="1.2.12"
export PKG_TARFILE="zlib-1.2.12.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

./configure --prefix=/usr | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
make check | tee ${PKG_LOGDIR}/check.log 

make install | tee ${PKG_LOGDIR}/install.locally.log
rm -fv /usr/lib/libz.a

make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log
rm -fv ${PKG_INSTALL_DIR}/usr/lib/libz.a

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
