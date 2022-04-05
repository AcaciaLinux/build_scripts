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

tar xpfv ../sources/linux*.tar.xz

cd linux*/

make mrproper

make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/fakeroot/usr
