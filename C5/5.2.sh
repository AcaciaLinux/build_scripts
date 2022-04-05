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

tar xpfv ../sources/binutils*.tar.xz

cd binutils*/

mkdir -v build
cd build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --disable-werror

make $MAKEOPTS
make install
