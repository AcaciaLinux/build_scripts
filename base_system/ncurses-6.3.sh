#!/bin/bash

set -e

export PKG_NAME="ncurses"
export PKG_VERSION="6.3"
export PKG_TARFILE="ncurses-6.3.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
#make check | tee ${PKG_LOGDIR}/check.log 
make DESTDIR=$PWD/dest install | tee ${PKG_LOGDIR}/install.locally.log

#Install locally
mkdir -pv ${PKG_INSTALL_DIR}/usr/lib
mkdir -pv ${PKG_INSTALL_DIR}/usr/lib/pkgconfig

install -vm755 dest/usr/lib/libncursesw.so.6.3 /usr/lib
install -vm755 dest/usr/lib/libncursesw.so.6.3 ${PKG_INSTALL_DIR}/usr/lib

rm -v  dest/usr/lib/{libncursesw.so.6.3,libncurses++w.a}

cp -av dest/* /
cp -av dest/* ${PKG_INSTALL_DIR}/

for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

for lib in ncurses form panel menu ; do
    rm -vf                    ${PKG_INSTALL_DIR}/usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > ${PKG_INSTALL_DIR}/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        ${PKG_INSTALL_DIR}/usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

rm -vf                     ${PKG_INSTALL_DIR}/usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > ${PKG_INSTALL_DIR}/usr/lib/libcursesw.so
ln -sfv libncurses.so      ${PKG_INSTALL_DIR}/usr/lib/libcurses.so

#Install documentation
mkdir -pv      /usr/share/doc/ncurses-6.3
cp -v -R doc/* /usr/share/doc/ncurses-6.3

mkdir -pv      ${PKG_INSTALL_DIR}/usr/share/doc/ncurses-6.3
cp -v -R doc/* ${PKG_INSTALL_DIR}/usr/share/doc/ncurses-6.3

#make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
