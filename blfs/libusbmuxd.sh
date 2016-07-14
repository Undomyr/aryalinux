#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:libusbmuxd_.orig:1.0.10

URL=http://archive.ubuntu.com/ubuntu/pool/main/libu/libusbmuxd/libusbmuxd_1.0.10.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "libusbmuxd=>`date`" | sudo tee -a $INSTALLED_LIST