#!/bin/bash

#Has to be run as root
if [[ $EUID -ne 0 ]];
then
   echo "This script must be run as root" 
   exit 1
fi

#Check for the root variable
if [ -z ${ROOTDIR} ];
then 	
	echo "ROOTDIR is not set!"
	exit 1
fi

mkdir -pv ${ROOTDIR}/{dev,proc,sys,run}
mknod -m 600 ${ROOTDIR}/dev/console c 5 1
mknod -m 666 ${ROOTDIR}/dev/null c 1 3

mkdir -pv ${ROOTDIR}/{boot,home,mnt,opt,srv}

mkdir -pv ${ROOTDIR}/etc/{opt,sysconfig}
mkdir -pv ${ROOTDIR}/lib/firmware
mkdir -pv ${ROOTDIR}/media/{floppy,cdrom}
mkdir -pv ${ROOTDIR}/usr/{,local/}{include,src}
mkdir -pv ${ROOTDIR}/usr/local/{bin,lib,sbin}
mkdir -pv ${ROOTDIR}/usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv ${ROOTDIR}/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv ${ROOTDIR}/usr/{,local/}share/man/man{1..8}
mkdir -pv ${ROOTDIR}/var/{cache,local,log,mail,opt,spool}
mkdir -pv ${ROOTDIR}/var/lib/{color,misc,locate}

ln -sfv ${ROOTDIR}/run ${ROOTDIR}/var/run
ln -sfv ${ROOTDIR}/run/lock ${ROOTDIR}/var/lock

mkdir -pv ${ROOTDIR}/root
mkdir -pv ${ROOTDIR}/tmp
mkdir -pv ${ROOTDIR}/var/tmp
