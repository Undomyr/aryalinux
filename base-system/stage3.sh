set -e
set +h

. /sources/build-properties

LFS=/mnt/lfs

chown -R root:root $LFS/tools

mkdir -pv $LFS/{dev,proc,sys,run}

# Create /dev/console and /dev/null if not done already

if [ ! -e /dev/console ] || [ ! -e /dev/null ]; then
	
	mknod -m 600 $LFS/dev/console c 5 1
	mknod -m 666 $LFS/dev/null c 1 3

	mount -v --bind /dev $LFS/dev

	mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
	mount -vt proc proc $LFS/proc
	mount -vt sysfs sysfs $LFS/sys
	mount -vt tmpfs tmpfs $LFS/run

	mount -vt tmpfs tmpfs $LFS/dev/shm
fi

# Building Final System

chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /sources/stage4.sh
