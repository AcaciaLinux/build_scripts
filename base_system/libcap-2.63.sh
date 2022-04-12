#!/bin/bash

set -e

export PKG_NAME="libcap"
export PKG_VERSION="2.63"
export PKG_TARFILE="libcap-2.63.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -i '/install -m.*STA/d' libcap/Makefile

# configure | tee ${PKG_LOGDIR}/configure.log
make prefix=/usr lib=lib | tee ${PKG_LOGDIR}/make.log
make test | tee ${PKG_LOGDIR}/check.log 
make -j1 prefix=/usr lib=lib install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 prefix=/usr lib=lib DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
