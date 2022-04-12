#!/bin/bash

set -e

export PKG_NAME="gawk"
export PKG_VERSION="5.1.1"
export PKG_TARFILE="gawk-5.1.1.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mkdir -pv                                   /usr/share/doc/gawk-5.1.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.1

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv                                   ${PKG_INSTALL_DIR}/usr/share/doc/gawk-5.1.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} ${PKG_INSTALL_DIR}/usr/share/doc/gawk-5.1.1

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
