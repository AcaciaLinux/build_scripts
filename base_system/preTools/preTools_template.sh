#!/bin/bash

set -e

export PKG_NAME=""
export PKG_VERSION=""
export PKG_TARFILE=""
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./preTools/prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/preTools/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/preTools/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/preTools/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

# configure | tee ${PKG_LOGDIR}/configure.log
# make | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
# make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
# make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
