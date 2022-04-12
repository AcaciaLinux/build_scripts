#!/bin/bash

set -e

export PKG_NAME="shadow"
export PKG_VERSION="4.11.1"
export PKG_TARFILE="shadow-4.11.1.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
    -i etc/login.defs

#Enable cracklib support
sed -i 's:DICTPATH.*:DICTPATH\t/lib/cracklib/pw_dict:' etc/login.defs

mkdir -pv /usr/bin/
mkdir -pv ${PKG_INSTALL_DIR}/usr/bin/

touch /usr/bin/passwd
touch ${PKG_INSTALL_DIR}/usr/bin/passwd

./configure --sysconfdir=/etc \
            --disable-static  \
            --with-group-name-max-length=32 | tee ${PKG_LOGDIR}/configure.log

make | tee ${PKG_LOGDIR}/make.log
# make check | tee ${PKG_LOGDIR}/check.log 
make -j1 exec_prefix=/usr install | tee ${PKG_LOGDIR}/install.locally.log
make -j1 exec_prefix=/usr DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log

make -C man -j1 install-man | tee ${PKG_LOGDIR}/install-man.locally.log
make -C man -j1 DESTDIR=${PKG_INSTALL_DIR} install-man | tee ${PKG_LOGDIR}/install-man.package.log

pwconv
grpconv
mkdir -pv ${PKG_INSTALL_DIR}/etc/default
mkdir -pv /etc/default
useradd -D --gid 999

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
