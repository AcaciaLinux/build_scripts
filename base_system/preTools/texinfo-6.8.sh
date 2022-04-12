#!/bin/bash

set -e

export PKG_NAME="texinfo"
export PKG_VERSION="6.8"
export PKG_TARFILE="texinfo-6.8.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./preTools/prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/preTools/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/preTools/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/preTools/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c

./configure --prefix=/usr | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
# make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
