#!/bin/bash

set -e

export PKG_NAME="util-linux"
export PKG_VERSION="2.37.4"
export PKG_TARFILE="util-linux-2.37.4.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --sbindir=/usr/sbin  \
            --docdir=/usr/share/doc/util-linux-2.37.4 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#Remove test that fails in chroot
rm tests/ts/lsns/ioctl_ns
chown -Rv tester . 2>&1 | tee ${PKG_LOGDIR}/check.chown.log
su tester -c "make -k check" 2>&1 | tee ${PKG_LOGDIR}/check.log

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
