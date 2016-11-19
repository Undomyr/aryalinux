#!/bin/bash

./umountal.sh &> /dev/null

read -p "Inserisci la partizione dove AryaLinux è stato costruito : " ROOT_PART
read -p "Inserisci la partizione usata mentre si stava costruendo AryaLinux: " HOME_PART
read -p "Inserisci la partizione swap mentre si stava costruendo AryaLinux  : " SWAP_PART

export LFS=/mnt/lfs

mkdir -pv $LFS
mount -v -t ext4 $ROOT_PART $LFS

if [ "$HOME_PART" != "" ]
then
	mkdir -v $LFS/home
	mount -v -t ext4 $HOME_PART $LFS/home
fi

if [ "$SWAP_PART" != "" ]
then
	mkswap $SWAP_PART
	/sbin/swapon -v $SWAP_PART
fi

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login
