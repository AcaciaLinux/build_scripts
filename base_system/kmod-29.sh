#!/bin/bash

set -e

export PKG_NAME="kmod"
export PKG_VERSION="29"
export PKG_TARFILE="kmod-29.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
done
ln -sfv kmod /usr/bin/lsmod

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/sbin || true
mkdir -pv ${PKG_INSTALL_DIR}/usr/bin || true
for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod ${PKG_INSTALL_DIR}/usr/sbin/$target
done
ln -sfv kmod ${PKG_INSTALL_DIR}/usr/bin/lsmod

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
