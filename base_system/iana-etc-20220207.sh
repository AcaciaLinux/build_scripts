#!/bin/bash

set -e

export PKG_NAME="iana-etc"
export PKG_VERSION="20220207"
export PKG_TARFILE="iana-etc-20220207.tar.gz"

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_NAME}-${PKG_VERSION}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_NAME}-${PKG_VERSION}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

cp -v services protocols /etc
mkdir -pv ${PKG_INSTALL_DIR}/etc
cp -v services protocols ${PKG_INSTALL_DIR}/etc

cd ${old_workdirectory}

