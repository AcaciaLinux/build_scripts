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

tar xpfv $LFS/sources/gcc*.tar.xz

cd gcc*/

echo "extracting mpfr"
tar -xf $LFS/sources/mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
echo "extracting gmp"
tar -xf $LFS/sources/gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
echo "extracting mpc"
tar -xf $LFS/sources/mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd build

../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.35 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-initfini-array   \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-decimal-float   \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make $MAKEOPTS
make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
