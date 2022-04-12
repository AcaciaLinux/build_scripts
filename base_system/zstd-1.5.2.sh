#!/bin/bash

set -e

export PKG_NAME="zstd"
export PKG_VERSION="1.5.2"
export PKG_TARFILE="zstd-1.5.2.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

# configure | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
make check | tee ${PKG_LOGDIR}/check.log 
make -j1 prefix=/usr install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 prefix=/usr DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

rm -v /usr/lib/libzstd.a
rm -v ${PKG_INSTALL_DIR}/usr/lib/libzstd.a

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
