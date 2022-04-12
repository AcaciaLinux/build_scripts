#!/bin/bash

set -e

export PKG_NAME="mpfr"
export PKG_VERSION="4.1.0"
export PKG_TARFILE="mpfr-4.1.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0 | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
make html | tee ${PKG_LOGDIR}/make-html.log
make check | tee ${PKG_LOGDIR}/check.log 

make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

make -j1 install-html | tee ${PKG_LOGDIR}/install-html.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install-html | tee ${PKG_LOGDIR}/install-html.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
