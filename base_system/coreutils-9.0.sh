#!/bin/bash

set -e

export PKG_NAME="coreutils"
export PKG_VERSION="9.0"
export PKG_TARFILE="coreutils-9.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

patch -Np1 -i ${SOURCES_DIR}/coreutils-9.0-i18n-1.patch
patch -Np1 -i ${SOURCES_DIR}/coreutils-9.0-chmod_fix-1.patch

autoreconf -fiv
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

#Test as root
make NON_ROOT_USERNAME=tester check-root 2>&1 | tee ${PKG_LOGDIR}/check.root.log 

#Test as tester user
echo "dummy:x:102:tester" >> /etc/group
chown -Rv tester .
su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check" 2>&1 | tee ${PKG_LOGDIR}/check.tester.log
sed -i '/dummy/d' /etc/group

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/share/man/man8/ || true
mv -v ${PKG_INSTALL_DIR}/usr/bin/chroot ${PKG_INSTALL_DIR}/usr/sbin
mv -v ${PKG_INSTALL_DIR}/usr/share/man/man1/chroot.1 ${PKG_INSTALL_DIR}/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' ${PKG_INSTALL_DIR}/usr/share/man/man8/chroot.8

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
