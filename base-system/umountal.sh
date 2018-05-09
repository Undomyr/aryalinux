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
	if mount | grep "$DEVICE"; then
		umount $DEVICE
	fi
done

if mount | grep "^$ROOT_PART" && mount | grep "^overlay on $LFS"; then
	echo "Both overlay and root partition mounted."
	echo "Unmounting overlay"
	umount $LFS
	echo "Unmounting root"
	umount $ROOT_PART
elif mount | grep "^$ROOT_PART"; then
	echo "Only root mounted"
	echo "Unmounting root"
	umount $ROOT_PART
elif mount | grep "^overlay on $LFS"; then
	echo "Only overlay mounted"
	echo "Unmounting overlay"
	umount $LFS
fi

exit 0
