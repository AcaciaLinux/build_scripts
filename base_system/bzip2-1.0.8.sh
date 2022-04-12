#!/bin/bash

set -e

export PKG_NAME="bzip2"
export PKG_VERSION="1.0.8"
export PKG_TARFILE="bzip2-1.0.8.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

patch -Np1 -i ${SOURCES_DIR}/bzip2-1.0.8-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

# configure | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
make -j1 PREFIX=/usr install | tee ${PKG_LOGDIR}/install.locally.log
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a

make -j1 PREFIX=/usr DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/bin/
mkdir -pv ${PKG_INSTALL_DIR}/usr/lib/
cp -av libbz2.so.* ${PKG_INSTALL_DIR}/usr/lib/
ln -sv libbz2.so.1.0.8 ${PKG_INSTALL_DIR}/usr/lib/libbz2.so
cp -v bzip2-shared ${PKG_INSTALL_DIR}/usr/bin/bzip2
for i in ${PKG_INSTALL_DIR}/usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv ${PKG_INSTALL_DIR}/usr/lib/libbz2.a

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
