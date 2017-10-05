#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="intltool"
VERSION="0.51.0"

cd $SOURCE_DIR

URL="https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
wget -nc $URL
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/2017.09/intltool-update.patch
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../intltool-update.patch
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
