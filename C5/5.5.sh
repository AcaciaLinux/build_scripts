#!/bin/bash

if [ -z ${LFS} ];
then 	
	echo "LFS is not set!"
	exit 1
fi

if [ -z ${LFS_TGT} ];
then
	echo "LFS_TGT is not set!"
	exit 1
fi

mkdir -pv $LFS/build
cd $LFS/build

mkdir -pv $LFS/fakeroot
cd $LFS/fakeroot

tar xpfv ../sources/glibc*.tar.xz

cd glibc*/

case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

patch -Np1 -i $LFS/sources/glibc-2.35-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/fakeroot/usr/sbin" > configparms
../configure                             \
      --prefix=/fakeroot/usr             \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/fakeroot/usr/include    \
      libc_cv_slibdir=/fakeroot/usr/lib

make $MAKEOPTS

make DESTDIR=$LFS/fakeroot install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/fakeroot/usr/bin/ldd

$LFS/tools/libexec/gcc/$LFS_TGT/11.2.0/install-tools/mkheaders
