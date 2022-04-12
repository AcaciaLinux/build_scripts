#!/bin/bash

set -e

export PKG_NAME="gcc"
export PKG_VERSION="11.2.0"
export PKG_TARFILE="gcc-11.2.0.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

sed -e '/static.*SIGSTKSZ/d' \
    -e 's/return kAltStackSize/return SIGSTKSZ * 4/' \
    -i libsanitizer/sanitizer_common/sanitizer_posix_libcdep.cpp

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -v build || true
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib | tee ${PKG_LOGDIR}/configure.log

make | tee ${PKG_LOGDIR}/make.log

#Testing
ulimit -s 32768
chown -Rv tester .
su tester -c "PATH=$PATH make -k check" | tee ${PKG_LOGDIR}/check.log || true
../contrib/test_summary | grep -A7 Summ > ${PKG_LOGDIR}/testSummary.log || true

#Install locally
make -j1 install | tee ${PKG_LOGDIR}/install.locally.log
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/11.2.0/include-fixed/bits/
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/11.2.0/include{,-fixed}
ln -svr /usr/bin/cpp /usr/lib  || true 
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/11.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/  || true 

#Do some sanity tests
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib' | tee ${PKG_LOGDIR}/readelf.log
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | tee ${PKG_LOGDIR}/succeeded.log
grep -B4 '^ /usr/include' dummy.log | tee ${PKG_LOGDIR}/includes.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' | tee ${PKG_LOGDIR}/searchpaths.log
grep "/lib.*/libc.so.6 " dummy.log | tee ${PKG_LOGDIR}/libc.log
grep found dummy.log | tee ${PKG_LOGDIR}/found-ld-linux.log
rm -v dummy.c a.out dummy.log

#Clean up
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

#Install in package directory
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${PKG_LOGDIR}/install.package.log
rm -rf ${PKG_INSTALL_DIR}/usr/lib/gcc/$(gcc -dumpmachine)/11.2.0/include-fixed/bits/
chown -v -R root:root \
    ${PKG_INSTALL_DIR}/usr/lib/gcc/*linux-gnu/11.2.0/include{,-fixed}
mkdir -pv ${PKG_INSTALL_DIR}/usr/bin
mkdir -pv ${PKG_INSTALL_DIR}/usr/lib
ln -svr ${PKG_INSTALL_DIR}/usr/bin/cpp ${PKG_INSTALL_DIR}/usr/lib || true 
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/11.2.0/liblto_plugin.so \
        ${PKG_INSTALL_DIR}/usr/lib/bfd-plugins/  || true 
      
mkdir -pv ${PKG_INSTALL_DIR}/usr/share/gdb/auto-load/usr/lib
mv -v ${PKG_INSTALL_DIR}/usr/lib/*gdb.py ${PKG_INSTALL_DIR}/usr/share/gdb/auto-load/usr/lib

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
