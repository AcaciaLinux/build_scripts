#!/bin/bash

set -e

export PKG_NAME="sed"
export PKG_VERSION="4.8"
export PKG_TARFILE="sed-4.8.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr | tee ${PKG_LOGDIR}/configure.log

make | tee ${PKG_LOGDIR}/make.log
make html | tee ${PKG_LOGDIR}/make.html.log

chown -Rv tester .
su tester -c "PATH=$PATH make check" | tee ${PKG_LOGDIR}/check.log 

make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

install -d -m755           /usr/share/doc/sed-4.8
install -m644 doc/sed.html /usr/share/doc/sed-4.8

install -d -m755           ${PKG_INSTALL_DIR}/usr/share/doc/sed-4.8
install -m644 doc/sed.html ${PKG_INSTALL_DIR}/usr/share/doc/sed-4.8

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
