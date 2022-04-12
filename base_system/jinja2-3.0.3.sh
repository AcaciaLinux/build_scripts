#!/bin/bash

set -e

export PKG_NAME="jinja2"
export PKG_VERSION="3.0.3"
export PKG_TARFILE="Jinja2-3.0.3.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/Jinja2-3.0.3

#configure 2>&1 | tee ${PKG_LOGDIR}/configure.log

#make 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

python3 setup.py install --optimize=1 2>&1 | tee ${PKG_LOGDIR}/install.locally.log

#make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log

touch ${PKG_INSTALL_DIR}/BUILD_TIME_DEPENDENCY_OF_SYSTEMD

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
