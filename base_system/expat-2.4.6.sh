#!/bin/bash

set -e

export PKG_NAME="expat"
export PKG_VERSION="2.4.6"
export PKG_TARFILE="expat-2.4.6.tar.xz"
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
            --docdir=/usr/share/doc/expat-2.4.6 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.4.6

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
install -v -m644 doc/*.{html,css} ${PKG_INSTALL_DIR}/usr/share/doc/expat-2.4.6

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
