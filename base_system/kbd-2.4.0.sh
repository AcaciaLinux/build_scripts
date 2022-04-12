#!/bin/bash

set -e

export PKG_NAME="kbd"
export PKG_VERSION="2.4.0"
export PKG_TARFILE="kbd-2.4.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

patch -Np1 -i ${SOURCES_DIR}/kbd-2.4.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mkdir -pv           /usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.4.0

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv           ${PKG_INSTALL_DIR}/usr/share/doc/kbd-2.4.0
cp -R -v docs/doc/* ${PKG_INSTALL_DIR}/usr/share/doc/kbd-2.4.0

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
