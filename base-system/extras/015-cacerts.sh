#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="014-cacerts.sh"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

install -vm755 make-ca.sh-20170514 /usr/sbin/make-ca.sh
/usr/sbin/make-ca.sh

echo "$STEPNAME" | tee -a $LOGFILE

fi
