#!/bin/bash

set -e

export PKG_NAME="expect"
export PKG_VERSION="5.45.4"
export PKG_TARFILE="expect5.45.4.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/expect5.45.4

set +e

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
make test | tee ${PKG_LOGDIR}/check.log 
make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
ln -svf expect5.45.4/libexpect5.45.4.so ${PKG_INSTALL_DIR}/usr/lib

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
