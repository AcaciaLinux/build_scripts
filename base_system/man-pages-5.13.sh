#!/bin/bash

set -e

export PKG_NAME="man-pages"
export PKG_VERSION="5.13"
export PKG_TARFILE="man-pages-5.13.tar.xz"

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_NAME}-${PKG_VERSION}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_NAME}-${PKG_VERSION}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)

cd ${PKG_BUILD_DIR}

make prefix=/usr install
make prefix=/usr DESTDIR=${PKG_INSTALL_DIR} install

cd ${old_workdirectory}

