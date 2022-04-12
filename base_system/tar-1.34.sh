#!/bin/bash

set -e

export PKG_NAME="tar"
export PKG_VERSION="1.34"
export PKG_TARFILE="tar-1.34.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr

#configure 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
make -C doc install-html docdir=/usr/share/doc/tar-1.34 2>&1 | tee ${PKG_LOGDIR}/install-html.locally.log

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
make -C doc DESTDIR=${PKG_INSTALL_DIR} install-html docdir=/usr/share/doc/tar-1.34 2>&1 | tee ${PKG_LOGDIR}/install-html.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"