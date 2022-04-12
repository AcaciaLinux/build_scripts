#!/bin/bash

set -e

export PKG_NAME="dejagnu"
export PKG_VERSION="1.6.3"
export PKG_TARFILE="dejagnu-1.6.3.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

#set +e

mkdir -v build || true
cd       build

../configure --prefix=/usr | tee ${PKG_LOGDIR}/configure.log
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
# make | tee ${PKG_LOGDIR}/make.log

make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3

make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log
install -v -dm755  ${PKG_INSTALL_DIR}/usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} ${PKG_INSTALL_DIR}/usr/share/doc/dejagnu-1.6.3

make check | tee ${PKG_LOGDIR}/check.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
