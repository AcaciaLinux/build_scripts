#!/bin/bash

set -e

export PKG_NAME="perl"
export PKG_VERSION="5.34.0"
export PKG_TARFILE="perl-5.34.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./preTools/prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/preTools/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/preTools/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/preTools/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

sh Configure -des                                        \
             -Dprefix=/usr                               \
             -Dvendorprefix=/usr                         \
             -Dprivlib=/usr/lib/perl5/5.34/core_perl     \
             -Darchlib=/usr/lib/perl5/5.34/core_perl     \
             -Dsitelib=/usr/lib/perl5/5.34/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.34/site_perl    \
             -Dvendorlib=/usr/lib/perl5/5.34/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.34/vendor_perl | tee ${PKG_LOGDIR}/configure.log
make | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
# make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
