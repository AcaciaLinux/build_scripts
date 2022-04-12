#!/bin/bash

set -e

export PKG_NAME="intltool"
export PKG_VERSION="0.51.0"
export PKG_TARFILE="intltool-0.51.0.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
install -v -Dm644 doc/I18N-HOWTO ${PKG_INSTALL_DIR}/usr/share/doc/intltool-0.51.0/I18N-HOWTO

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
