#!/bin/bash

set -e

. ./build-properties

DIR_NAME=${1}

mkdir -pv $LFS/opt/${DIR_NAME}
