#!/bin/bash

set -e

export PKG_NAME="bash"
export PKG_VERSION="5.1.16"
export PKG_TARFILE="bash-5.1.16.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr                      \
            --docdir=/usr/share/doc/bash-5.1.16 \
            --without-bash-malloc              \
            --with-installed-readline 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

chmod -v 777 /tmp
chown -Rv tester .
su -s /usr/bin/expect tester "
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value " 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
