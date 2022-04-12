#!/bin/bash

set -e

export PKG_NAME="inetutils"
export PKG_VERSION="2.2"
export PKG_TARFILE="inetutils-2.2.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mv -v /usr/{,s}bin/ifconfig

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/sbin/ || true
mv -v ${PKG_INSTALL_DIR}/usr/{,s}bin/ifconfig

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
