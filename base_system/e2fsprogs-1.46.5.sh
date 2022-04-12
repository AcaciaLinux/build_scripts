#!/bin/bash

set -e

export PKG_NAME="e2fsprogs"
export PKG_VERSION="1.46.5"
export PKG_TARFILE="e2fsprogs-1.46.5.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

mkdir -v build || true
cd       build

../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
rm -fv ${PKG_INSTALL_DIR}/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v ${PKG_INSTALL_DIR}/usr/share/info/libext2fs.info.gz
install-info --dir-file=${PKG_INSTALL_DIR}/usr/share/info/dir ${PKG_INSTALL_DIR}/usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info ${PKG_INSTALL_DIR}/usr/share/info
install-info --dir-file=${PKG_INSTALL_DIR}/usr/share/info/dir ${PKG_INSTALL_DIR}/usr/share/info/com_err.info


cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
