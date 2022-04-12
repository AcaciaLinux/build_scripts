#!/bin/bash

set -e

export PKG_NAME="glibc"
export PKG_VERSION="2.35"
export PKG_TARFILE="glibc-2.35.tar.xz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_NAME}-${PKG_VERSION}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_NAME}-${PKG_VERSION}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

set +e

#Build GLIBC
patch -Np1 -i ${SOURCES_DIR}/glibc-2.35-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib | tee ${BUILD_LOGS_DIR}/${PKG_FNAME}/configure.log 


make | tee ${BUILD_LOGS_DIR}/${PKG_FNAME}/make.log
make check | tee ${BUILD_LOGS_DIR}/${PKG_FNAME}/check.log

#Install GLIBC locally
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make -j1 install | tee ${BUILD_LOGS_DIR}/${PKG_FNAME}/install.locally.log
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /usr/lib/systemd/system/nscd.service

make localedata/install-locales

localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true

#Configure glibc locally
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ${SOURCES_DIR}/tzdata2021e.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

#Done installing GLIBC locally

#Install GLIBC in package directory
touch ${PKG_INSTALL_DIR}/etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make -j1 DESTDIR=${PKG_INSTALL_DIR} install | tee ${BUILD_LOGS_DIR}/${PKG_FNAME}/install.package.log
sed '/RTLDLIST=/s@/usr@@g' -i ${PKG_INSTALL_DIR}/usr/bin/ldd
cp -v ../nscd/nscd.conf ${PKG_INSTALL_DIR}/etc/nscd.conf
mkdir -pv ${PKG_INSTALL_DIR}/var/cache/nscd
install -v -Dm644 ../nscd/nscd.tmpfiles ${PKG_INSTALL_DIR}/usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service ${PKG_INSTALL_DIR}/usr/lib/systemd/system/nscd.service

make DESTDIR=${PKG_INSTALL_DIR} localedata/install-locales

localedef -i POSIX -f UTF-8 C.UTF-8 ${PKG_INSTALL_DIR} 2> /dev/null || true
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS ${PKG_INSTALL_DIR} 2> /dev/null || true

#Configure GLIBC in package directory

cat > ${PKG_INSTALL_DIR}/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

ZONEINFO=${PKG_INSTALL_DIR}/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

cat > ${PKG_INSTALL_DIR}/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> ${PKG_INSTALL_DIR}/etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv ${PKG_INSTALL_DIR}/etc/ld.so.conf.d

#Done installing GLIBC in package directory

cd ${old_workdirectory}
echo "DONE building $PKG_NAME-$PKG_VERSION"
