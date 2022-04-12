#!/bin/bash

set -e

export PKG_NAME="tcl"
export PKG_VERSION="8.6.12"
export PKG_TARFILE="tcl8.6.12-src.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${BUILD_CACHE_DIR}/tcl8.6.12/

set +e

tar -xf ${SOURCES_DIR}/tcl8.6.12-html.tar.gz --strip-components=1

SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit) | tee ${PKG_LOGDIR}/configure.log

make | tee ${PKG_LOGDIR}/make.log

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.3|/usr/lib/tdbc1.1.3|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3|/usr/include|"            \
    -i pkgs/tdbc1.1.3/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.2|/usr/lib/itcl4.2.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.2|/usr/include|"            \
    -i pkgs/itcl4.2.2/itclConfig.sh

unset SRCDIR

make test | tee ${PKG_LOGDIR}/check.log 
make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers | tee ${PKG_LOGDIR}/install_headers.locally.log
ln -sfv tclsh8.6 /usr/bin/tclsh
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
mkdir -v -p /usr/share/doc/tcl-8.6.12
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.12

chmod -v u+w ${PKG_INSTALL_DIR}/usr/lib/libtcl8.6.so
make DESTDIR=${PKG_INSTALL_DIR} install-private-headers | tee ${PKG_LOGDIR}/install_headers.package.log
ln -sfv tclsh8.6 ${PKG_INSTALL_DIR}/usr/bin/tclsh
mv ${PKG_INSTALL_DIR}/usr/share/man/man3/{Thread,Tcl_Thread}.3
mkdir -v -p ${PKG_INSTALL_DIR}/usr/share/doc/tcl-8.6.12
cp -v -r  ../html/* ${PKG_INSTALL_DIR}/usr/share/doc/tcl-8.6.12

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
