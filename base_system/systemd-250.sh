#!/bin/bash

set -e

export PKG_NAME="systemd"
export PKG_VERSION="250"
export PKG_TARFILE="systemd-250.tar.gz"
PKG_FNAME=${PKG_NAME}-${PKG_VERSION}

./prepare.sh

PKG_BUILD_DIR=${BUILD_CACHE_DIR}/${PKG_FNAME}/
PKG_INSTALL_DIR=${PACKAGES_DIR}/${PKG_FNAME}/
PKG_LOGDIR=${BUILD_LOGS_DIR}/${PKG_FNAME}/

echo "Building in $PKG_BUILD_DIR, installing to $PKG_INSTALL_DIR..."

old_workdirectory=$(pwd)
cd ${PKG_BUILD_DIR}

patch -Np1 -i ${SOURCES_DIR}/systemd-250-upstream_fixes-1.patch

#Quick hack to remove the error for unfound filesystems
echo "index 08c8c445105a..e8c5357f9146 100644
--- a/src/basic/filesystems-gperf.gperf
+++ b/src/basic/filesystems-gperf.gperf
@@ -40,7 +40,7 @@ ceph,            {CEPH_SUPER_MAGIC}
 cgroup2,         {CGROUP2_SUPER_MAGIC}
 # note that the cgroupfs magic got reassigned from cpuset
 cgroup,          {CGROUP_SUPER_MAGIC}
-cifs,            {CIFS_MAGIC_NUMBER}
+cifs,            {CIFS_SUPER_MAGIC, SMB2_SUPER_MAGIC}
 coda,            {CODA_SUPER_MAGIC}
 configfs,        {CONFIGFS_MAGIC}
 cramfs,          {CRAMFS_MAGIC}
@@ -109,7 +109,7 @@ selinuxfs,       {SELINUX_MAGIC}
 shiftfs,         {SHIFTFS_MAGIC}
 smackfs,         {SMACK_MAGIC}
 # smb3 is an alias for cifs
-smb3,            {CIFS_MAGIC_NUMBER}
+smb3,            {CIFS_SUPER_MAGIC}
 # smbfs was removed from the kernel in 2010, the magic remains
 smbfs,           {SMB_SUPER_MAGIC}
 sockfs,          {SOCKFS_MAGIC}
diff --git a/src/basic/missing_magic.h b/src/basic/missing_magic.h
index 7d9320bb6dc9..c104fcfba315 100644
--- a/src/basic/missing_magic.h
+++ b/src/basic/missing_magic.h
@@ -38,9 +38,14 @@
 #define XFS_SB_MAGIC 0x58465342
 #endif
 
-/* Not exposed yet. Defined at fs/cifs/cifsglob.h */
-#ifndef CIFS_MAGIC_NUMBER
-#define CIFS_MAGIC_NUMBER 0xFF534D42
+/* dea2903719283c156b53741126228c4a1b40440f (5.17) */
+#ifndef CIFS_SUPER_MAGIC
+#define CIFS_SUPER_MAGIC 0xFF534D42
+#endif
+
+/* dea2903719283c156b53741126228c4a1b40440f (5.17) */
+#ifndef SMB2_SUPER_MAGIC
+#define SMB2_SUPER_MAGIC 0xFE534D42
 #endif
 
 /* 257f871993474e2bde6c497b54022c362cf398e1 (4.5) */" > filesystem_patch.patch

patch -Np1 -i filesystem_patch.patch

sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir -p build || true
cd       build

meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      --buildtype=release           \
      -Dblkid=true                  \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dldconfig=false              \
      -Dsysusers=false              \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=false                   \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-250 \
      .. 2>&1 | tee ${PKG_LOGDIR}/configure.log

ninja 2>&1 | tee ${PKG_LOGDIR}/make.log

#make check 2>&1 | tee ${PKG_LOGDIR}/check.log 

ninja -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.locally.log
tar -xf ${SOURCES_DIR}/systemd-man-pages-250.tar.xz --strip-components=1 -C /usr/share/man
rm -rf /usr/lib/pam.d

systemd-machine-id-setup
systemctl preset-all

DESTDIR=${PKG_INSTALL_DIR} ninja -j1 install 2>&1 | tee ${PKG_LOGDIR}/install.package.log
mkdir -pv ${PKG_INSTALL_DIR}/usr/share/man || true
tar -xf ${SOURCES_DIR}/systemd-man-pages-250.tar.xz --strip-components=1 -C ${PKG_INSTALL_DIR}/usr/share/man
rm -rf ${PKG_INSTALL_DIR}/usr/lib/pam.d

cd ${old_workdirectory}
echo "DONE building $PKG_FNAME"
