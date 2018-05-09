#!/bin/bash

set -e

. ./build-properties

DIR_NAME=${1}

mkdir -pv $LFS/opt/${DIR_NAME}

if [ "x$DIR_NAME" != "xx-server" ]; then
	ln -svf $LFS/opt/${DIR_NAME} $LFS/opt/desktop-environment
fi
