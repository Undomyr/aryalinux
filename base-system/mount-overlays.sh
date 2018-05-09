#!/bin/bash

set -e

. ./build-properties

echo "Mounting overlays..."

if [ -d $LFS/opt/x-server ]; then
	echo "x-server overlay found..."
	if [ -d $LFS/opt/desktop-environment ]; then
		echo "desktop-environment overlay found..."
		echo "Mounting desktop-environment overlay..."
		mount -t overlay -olowerdir=$LFS/opt/x-server:$LFS,upperdir=$LFS/opt/desktop-environment,workdir=$LFS/tmp overlay $LFS
	else
		echo "Mounting x-server overlay..."
		mount -v -t overlay -olowerdir=$LFS,upperdir=$LFS/opt/x-server,workdir=$LFS/tmp overlay $LFS
	fi
fi