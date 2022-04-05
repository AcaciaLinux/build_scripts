#!/bin/bash

if [ -z ${LFS} ];
then 	
	echo "LFS variable is not set!"
	exit 1
fi

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

echo "Password for lfs user:"

passwd lfs

chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

chown -v lfs $LFS/sources

echo "Changing to lfs user"

su - lfs

