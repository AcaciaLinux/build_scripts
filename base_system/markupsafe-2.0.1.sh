#!/bin/bash

set -e

export PKG_NAME="markupsafe"
export PKG_VERSION="2.0.1"
export PKG_TARFILE="MarkupSafe-2.0.1.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/MarkupSafe-2.0.1

#configure 2>&1 | tee ${PKG_LOGDIR}/configure.log

python3 setup.py build 2>&1 | tee ${PKG_LOGDIR}/build.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

python3 setup.py install --optimize=1 2>&1 | tee ${PKG_LOGDIR}/install.locally.log

touch ${PKG_INSTALL_DIR}/BUILD_TIME_DEPENDENCY_OF_SYSTEMD

#make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
