#!/bin/bash

set -e

export PKG_NAME="vim"
export PKG_VERSION="8.2.4383"
export PKG_TARFILE="vim-8.2.4383.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr 2>&1 | tee ${PKG_LOGDIR}/configure.log

make 2>&1 | tee ${PKG_LOGDIR}/make.log

chown -Rv tester . 2>&1 | tee ${PKG_LOGDIR}/check.chown.log 
#Pipe directly due to loads of binary output
echo "Testing VIM..."
su tester -c "LANG=en_US.UTF-8 make -j1 test" &> ${PKG_LOGDIR}/check.log  || true
echo "DONE testing VIM"

make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
ln -sv vim /usr/bin/vi || true
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1 || true
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.4383

make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/bin || true
ln -sv vim ${PKG_INSTALL_DIR}/usr/bin/vi || true
for L in ${PKG_INSTALL_DIR}/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1 || true
done

mkdir -pv ${PKG_INSTALL_DIR}/usr/share/doc/ || true
ln -sv ../vim/vim82/doc ${PKG_INSTALL_DIR}/usr/share/doc/vim-8.2.4383 || true

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
