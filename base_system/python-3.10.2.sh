#!/bin/bash

set -e

export PKG_NAME="python"
export PKG_VERSION="3.10.2"
export PKG_TARFILE="Python-3.10.2.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/Python-3.10.2

./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --with-ensurepip=yes \
            --enable-optimizations 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
install -v -dm755 /usr/share/doc/python-3.10.2/html
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.10.2/html \
    -xvf ${SOURCES_DIR}/python-3.10.2-docs-html.tar.bz2

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
install -v -dm755 ${PKG_INSTALL_DIR}/usr/share/doc/python-3.10.2/html
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C ${PKG_INSTALL_DIR}/usr/share/doc/python-3.10.2/html \
    -xvf ${SOURCES_DIR}/python-3.10.2-docs-html.tar.bz2

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
