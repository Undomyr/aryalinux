#!/bin/bash

. ./build-properties

export LFS=/mnt/lfs

DEVICES="
$LFS/boot/efi
$LFS/sys/firmware/efi/efivars
$LFS/dev/pts
$LFS/dev/shm
$LFS/dev
$LFS/sys
$LFS/proc
$LFS/run
$LFS/home
"

for DEVICE in $DEVICES; do
	if mount | grep "$DEVICE" &> /dev/null; then
		umount -v $DEVICE
	fi
done

if mount | grep "^overlay on $LFS" &> /dev/null; then
	umount -v $LFS
fi

exit 0
