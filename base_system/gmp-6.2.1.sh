#!/bin/bash

set -e

export PKG_NAME="gmp"
export PKG_VERSION="6.2.1"
export PKG_TARFILE="gmp-6.2.1.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.1 | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
make html | tee ${PKG_LOGDIR}/make.html.log
make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

if [ $(awk '/# PASS:/{total+=$3} ; END{print total}' ${PKG_LOGDIR}/check.log) -ne 197 ]
then
	echo "Not all tests of GMP passed!"
	exit 1
fi

make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 install-html | tee ${PKG_LOGDIR}/install-html.locally.log

make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install-html | tee ${PKG_LOGDIR}/install-html.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
