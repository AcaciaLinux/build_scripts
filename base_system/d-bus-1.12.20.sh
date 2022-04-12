#!/bin/bash

set -e

export PKG_NAME="d-bus"
export PKG_VERSION="1.12.20"
export PKG_TARFILE="dbus-1.12.20.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/dbus-1.12.20

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --disable-static                     \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
ln -sfv /etc/machine-id /var/lib/dbus

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/etc || true
mkdir -pv ${PKG_INSTALL_DIR}/etc || true
ln -sfv ${PKG_INSTALL_DIR}/etc/machine-id ${PKG_INSTALL_DIR}/var/lib/dbus

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
