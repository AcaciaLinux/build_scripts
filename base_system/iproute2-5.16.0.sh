#!/bin/bash

set -e

export PKG_NAME="iproute2"
export PKG_VERSION="5.16.0"
export PKG_TARFILE="iproute2-5.16.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

#configure 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 SBINDIR=/usr/sbin install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mkdir -pv             /usr/share/doc/iproute2-5.16.0
cp -v COPYING README* /usr/share/doc/iproute2-5.16.0

make -j1 SBINDIR=/usr/sbin DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv             ${PKG_INSTALL_DIR}/usr/share/doc/iproute2-5.16.0
cp -v COPYING README* ${PKG_INSTALL_DIR}/usr/share/doc/iproute2-5.16.0

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
