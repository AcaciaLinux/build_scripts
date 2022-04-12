#!/bin/bash

set -e

export PKG_NAME="openssl"
export PKG_VERSION="3.0.1"
export PKG_TARFILE="openssl-3.0.1.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make test 2>&1 | tee ${PKG_LOGDIR}/check.log 

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile

make -j1 MANSUFFIX=ssl install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.0.1
cp -vfr doc/* /usr/share/doc/openssl-3.0.1

make -j1 MANSUFFIX=ssl DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mv -v ${PKG_INSTALL_DIR}/usr/share/doc/openssl ${PKG_INSTALL_DIR}/usr/share/doc/openssl-3.0.1
cp -vfr doc/* ${PKG_INSTALL_DIR}/usr/share/doc/openssl-3.0.1

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
