#!/bin/bash

set -e

export PKG_NAME="meson"
export PKG_VERSION="0.61.1"
export PKG_TARFILE="meson-0.61.1.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

#configure 2>&1 | tee ${PKG_LOGDIR}/configure.log

python3 setup.py build 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

python3 setup.py install --root=dest 2>&1 | tee ${PKG_LOGDIR}/install.cache.log

cp -rv dest/* / 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

cp -rv dest/* ${PKG_INSTALL_DIR}/ 2>&1 | tee ${PKG_LOGDIR}/install.package.log
install -vDm644 data/shell-completions/bash/meson ${PKG_INSTALL_DIR}/usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson ${PKG_INSTALL_DIR}/usr/share/zsh/site-functions/_meson

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
