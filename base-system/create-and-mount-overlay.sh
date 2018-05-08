#!/bin/bash

set -e

. ./build-properties

DIR_NAME=${1}

mkdir -pv $LFS/opt/${DIR_NAME}

set +e

umount $LFS/boot/efi &> /dev/null
umount $LFS/sys/firmware/efi/efivars &> /dev/null
umount $LFS/dev/pts &> /dev/null
umount $LFS/dev/shm &> /dev/null
umount $LFS/dev &> /dev/null
umount $LFS/sys &> /dev/null
umount $LFS/proc &> /dev/null
umount $LFS/run &> /dev/null
umount $LFS/home &> /dev/null

set -e

mount -t overlay -olowerdir=$LFS,upperdir=$LFS/opt/${DIR_NAME},workdir=$LFS/tmp overlay $LFS
