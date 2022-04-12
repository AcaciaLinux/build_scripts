#!/bin/bash

set -e

export PKG_NAME="ninja"
export PKG_VERSION="1.10.2"
export PKG_TARFILE="ninja-1.10.2.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

export NINJAJOBS=$(nproc)

sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

python3 configure.py --bootstrap 2>&1 | tee ${PKG_LOGDIR}/configure.log

#make 2>&1 | tee ${PKG_LOGDIR}/make.log

./ninja ninja_test 2>&1 | tee ${PKG_LOGDIR}/build.check.log
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots 2>&1 | tee ${PKG_LOGDIR}/check2.log

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

mkdir -pv ${PKG_INSTALL_DIR}/usr/bin/ || true
install -vm755 ninja ${PKG_INSTALL_DIR}/usr/bin/
install -vDm644 misc/bash-completion ${PKG_INSTALL_DIR}/usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  ${PKG_INSTALL_DIR}/usr/share/zsh/site-functions/_ninja

#make -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log

#make -j1 DESTDIR=${PKG_INSTALL_DIR} install 2>&1 | tee ${PKG_LOGDIR}/install.package.log

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
