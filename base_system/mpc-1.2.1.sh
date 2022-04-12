#!/bin/bash

set -e

export PKG_NAME="mpc"
export PKG_VERSION="1.2.1"
export PKG_TARFILE="mpc-1.2.1.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.2.1 | tee ${PKG_LOGDIR}/configure.log

make | tee ${PKG_LOGDIR}/make.log
make hmtl | tee ${PKG_LOGDIR}/make-html.log

make check | tee ${PKG_LOGDIR}/check.log 

make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

make -j1 install-html | tee ${PKG_LOGDIR}/install-html.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install-html | tee ${PKG_LOGDIR}/install-html.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
