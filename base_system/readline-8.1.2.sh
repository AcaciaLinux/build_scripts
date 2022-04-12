#!/bin/bash

set -e

export PKG_NAME="readline"
export PKG_VERSION="8.1.2"
export PKG_TARFILE="readline-8.1.2.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1.2 | tee ${PKG_LOGDIR}/configure.log

make SHLIB_LIBS="-lncursesw" | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
make SHLIB_LIBS="-lncursesw" install -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make SHLIB_LIBS="-lncursesw" install -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2
install -v -m644 doc/*.{ps,pdf,html,dvi} ${PKG_INSTALL_DIR}/usr/share/doc/readline-8.1.2

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
