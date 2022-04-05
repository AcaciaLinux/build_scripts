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

tar xpfv ../sources/gcc*.tar.xz

cd gcc*/

mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/fakeroot/usr          \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/11.2.0

make $MAKEOPTS

make DESTDIR=$LFS/fakeroot install
